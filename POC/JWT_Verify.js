var jwt = require('jwt');
var hm = require('header-metadata');
var sm = require('service-metadata');
var urlopen = require('urlopen');
var traceId = hm.current.get('x-b3-traceid');
var spanId = hm.current.get('x-b3-spanid');
var apiScopes = hm.current.get('scopes').split(',');

try {
    //Retrieve Token from HTTP Header
    var bearertoken = hm.current.get('authorization');;
    if (typeof (bearertoken) === 'undefined') {
        throw {
            name: "Unauthorized",
            message: "Missing access token",
            errorType: "JWTError",
            errorCode: "401"
        }

    }

    if (!(bearertoken.startsWith('Bearer '))) {
        throw {
            name: "Unauthorized",
            message: "Invalid access token",
            errorType: "JWTError",
            errorCode: "401"
        }
    }

    // Retrieve the JWT token.
    var buff = bearertoken.substring(7);
    var jwttoken = buff.toString();

    //Retrieve the JWT Issuer and kid
    var jwtSplitTokens = buff.split('.');
    var encodedClaim = jwtSplitTokens[1];
    var decodedClaim = JSON.parse(new Buffer(encodedClaim, 'base64').toString('utf-8'));
    console.error('JWTClaim subject: ' + decodedClaim.sub);
    var issuer = decodedClaim.iss;
    var reqScopes = decodedClaim.scopes || decodedClaim.scope;

    if (typeof (reqScopes) === 'string') {
        reqScopes = reqScopes.split(' ');

    };



    var encodedHeader = jwtSplitTokens[0];
    var decodedHeader = JSON.parse(new Buffer(encodedHeader, 'base64').toString('utf-8'));
    var kid = decodedHeader.kid;

    if ((typeof (kid) === 'undefined') || (typeof (kid) === 'undefined')) {
        throw {
            name: "Unauthorized",
            message: "Missing kid or issuer",
            errorType: "JWTError",
            errorCode: "401"
        }

    }

    var decoder = new jwt.Decoder(jwttoken);


    //Need to update HTTP headers
    var httpheaders = {
        ['x-b3-traceid']: traceId,
        ['x-b3-spanid']: spanId,
        Accept: 'application/json'
    };

    var serviceEndpoint = '';
    var customURL = hm.current.get('jwkURL');
    console.error('Custom JWK URL: '+ typeof(customURL));
    if (!(typeof (customURL) === 'undefined')) {
        //If Custome JWK URL  provided then validate against Custom JWK registry
        console.error('Custom URL has been provided:'+ customURL);
        serviceEndpoint = customURL;
    } else {
        // If Custome JWK URL not provided then by default validate against STI JWK registry
        //serviceEndpoint ='https://auth.service.dev/oidc/.well-known/jwks.json';
        console.error('Custom URL has not been provided. Proceeding with STI JWK Registry');
        serviceEndpoint = 'http://10.0.0.25:8091/get';
    }
    var targetUrl = serviceEndpoint;
    console.log('RegistrytargetUrl: ' + targetUrl);



    //Extract JWK by calling registry using kid and issuer
    var options = {
        target: targetUrl,
        method: 'GET',
        headers: httpheaders,
    };

    urlopen.open(options, function (error, response) {

        if (error) {
            throw {
                name: "Unauthorized",
                message: "Unable to connect to JWKs Registry",
                errorType: "JWTError",
                errorCode: "401"
            }
        }

        if (response.statusCode == 500) {
            console.error('not able to connect to JWKs registry');
            throw {
                name: "Unauthorized",
                message: "Unable to connect to JWKs Registry",
                errorType: "JWTError",
                errorCode: "401"
            }

        }

        if (response.statusCode != 200) {
            console.error('Couldnt get JWK for given issuer and kid ' + response.statusCode);
            throw {
                name: "Unauthorized",
                message: "Invalid Issuer",
                errorType: "JWTError",
                errorCode: "401"
            }


        }

        response.readAsJSON(function (error, jwsJWK) {
            if (error) {
                throw {
                    name: "Unauthorized",
                    message: "Not a valid JWK",
                    errorType: "JWTError",
                    errorCode: "401"
                }
            }

            var key = "key_ops";
            if (jwsJWK[key]) {
                delete jwsJWK[key];
            }
            decoder.addOperation('verify', jwsJWK).addOperation({
                validateDataType: true,
                validateAudience: false,
                validateExpiration: true,
                validateNotBefore: true
            }, 'validate', {
                'aud': 'xxxx'
            }).decode(function (error, claims) {
                if (error) {

                    var errorPhrase = error.errorMessage;
                    if (errorPhrase.includes('expired')) {
                        throw {
                            name: "Unauthorized",
                            message: "The access token expired",
                            errorType: "JWTError",
                            errorCode: "401"
                        }


                    } else {
                        throw {
                            name: "Forbidden",
                            message: "Invalid token signature",
                            errorType: "JWTError",
                            errorCode: "403"
                        }
                        //apic.error('JWTError', 403, 'Forbidden', 'Invalid token signature, '+ errorPhrase );

                    }
                } else {
                    console.error('SignatureValidation success');


                    var scopeFound = false;

                    for (var i = 0; i < reqScopes.length; i++) {
                        if (apiScopes.indexOf(reqScopes[i]) >= 0) {
                            scopeFound = true;
                            break;
                        }
                    };

                    if (!scopeFound) {
                        throw {
                            name: "Forbidden",
                            message: "Insufficient Scope",
                            errorType: "JWTError",
                            errorCode: "403"
                        }


                    } else {
                        session.output.write(claims);
                    }



                }
            })
        });
        //session.output.write(decodedClaim);

    });
    //session.output.write(decodedClaim);
} catch (e) {
    var errorresponse = {};
    errorresponse.name = e.name;
    errorresponse.code = e.errorCode;
    errorresponse.type = e.errorType;
    errorresponse.message = e.message;
    session.output.write(errorresponse);
}
