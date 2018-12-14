var jwt = require('jwt');
var hm = require('header-metadata');
var sm = require('service-metadata');
var urlopen = require('urlopen');
//var apic = require('local:///isp/policy/apim.custom.js');
//var props = apic.getPolicyProperty();
//var apiScopes = props.scopes;
//var tokenHeader = props.tokenHeader;
//var scopeVerificationRequired = props.scopeVerificationRequired;
var traceId = hm.current.get('x-b3-traceid');
var spanId = hm.current.get('x-b3-spanid');
var apiScopes= hm.current.get('scopes').split(',');
//var catalog = hm.current.get('env.path');
var errors={};
try {
    //Retrieve Token from HTTP Header
    var bearertoken = hm.current.get('authorization');;
    if (typeof(bearertoken) === 'undefined') {
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
    hm.current.set('JWTClaim', decodedClaim);
    var issuer = decodedClaim.iss;
    var reqScopes = decodedClaim.scopes || decodedClaim.scope;
    
    if (typeof(reqScopes) === 'string') {
	reqScopes = reqScopes.split(' ');
	
    };

    

    var encodedHeader = jwtSplitTokens[0];
    var decodedHeader = JSON.parse(new Buffer(encodedHeader, 'base64').toString('utf-8'));
    var kid = decodedHeader.kid;

    if ((typeof(kid) === 'undefined') || (typeof(kid) === 'undefined')) {
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
        ['x-api-environment']: catalog,
        Accept: 'application/json'
    };

    var serviceEndpoint = '';
    var customURL=hm.current.get('jwkURL');
    if((typeof(customURL) === 'undefined')){
        //If Custome JWK URL  provided then validate against Custom JWK registry
        serviceEndpoint = customURL;
    }
    else{
        // If Custome JWK URL not provided then by default validate against STI JWK registry
        serviceEndpoint ='https://auth.service.dev/oidc/.well-known/jwks.json';
    }
    var targetUrl = serviceEndpoint;
    apic.setvariable('RegistrytargetUrl', targetUrl);



    //Extract JWK by calling registry using kid and issuer
    var options = {
        target: targetUrl,
        method: 'GET',
        headers: httpheaders,
    };

    urlopen.open(options, function(error, response) {
                
        if (error) {
                                                                apic.error('JWTError', 401, 'Unauthorized', 'Unable to connect to JWKs Registry');
        }

                                if (response.statusCode == 500) {
                                                console.error('not able to connect to JWKs registry');
                                                apic.error('JWTError', 401, 'Unauthorized', 'Unable to connect to JWKs Registry');
        }
                                
                                if (response.statusCode != 200) {
                                                console.error('Couldnt get JWK for given issuer and kid ' + response.statusCode);
                                                apic.error('JWTError', 401, 'Unauthorized', 'Invalid Issuer');
            
        }
                                
        response.readAsJSON(function(error, jwsJWK) {
            if (error) {
                apic.error('JWTError', 401, 'Unauthorized', 'Not a valid JWK');
            }
	    
       var key = "key_ops";
       if (jwsJWK[key]) {
             delete jwsJWK[key];
           } 	
            decoder.addOperation('verify', jwsJWK).addOperation({ validateDataType: true,  validateAudience: false,  validateExpiration: true,  validateNotBefore: true },'validate',{'aud': 'xxxx'}).decode(function(error, claims) {
                if (error) {

                    var errorPhrase = error.errorMessage;
                    if (errorPhrase.includes('expired')) {

                        apic.error('JWTError', 401, 'Unauthorized', 'The access token expired, ' + errorPhrase);

                    } else {

                        apic.error('JWTError', 403, 'Forbidden', 'Invalid token signature, '+ errorPhrase );

                    }
                } else {
                    apic.setvariable('SignatureValidation', 'success');


                        var scopeFound = false;

                        for (var i = 0; i < reqScopes.length; i++) {
                            if (apiScopes.indexOf(reqScopes[i]) >= 0) {
                                scopeFound = true;
                                break;
                            }
                        };

                        if (!scopeFound) {

                            apic.error('JWTError', 403, 'Forbidden', 'Insufficient Scope');

                        } else {
                            apic.setvariable('JWTvalidation', 'success');
                        }

                   

                }
            })
        });


    });
} catch (e) {
    apic.error(e.errorType, e.errorCode, e.name, e.message);
}
