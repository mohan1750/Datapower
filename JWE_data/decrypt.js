// Simple JWS 'decrypt' example
//   - JSON serialization
//   - Needs configurable key, encrypted message

var jose = require('jose');

session.input.readAsJSON(function(error, json) {
    if (error) {
        session.reject("Error reading input: "+error);
    } else {
        // Parse the JWE object to extract the serialized values for the object's individual components.
        // An instance of JWEObject is returned, through which we can access the JWE content.
        var jweObj = jose.parse(json);

        // Get the enumerated value to use as the key encryption algorithm.
        var algValue = session.parameters.alg;

        // Check if alg is the expected value.
        if (jweObj.getProtected('alg') != algValue) {
            console.log('alg parameter does not match the exptected value. Abort!!!!!!!'+algValue);
            session.reject('alg parameter does not match the exptected value. Abort!');
        }

        // Get the name of the mgmt object to use as the key
        var keyValue = session.parameters.key;

        // Set the key value for each recipient in the JWE object.
        jweObj.getRecipients().forEach(function (recipient) {
            console.log('recipent value. Set!!!!!!!'+recipient+'!!!!!!!!!!!'+keyValue);
            recipient.setKey(keyValue);
        });

        // Decrypt the JWE object
        jose.createJWEDecrypter(jweObj).decrypt(function(error, plaintext) {
            if (error) {
            // An error occurred during the decrypt process and is passed back
            // via the error parameter, since .decrypt is an asynchronous call.
            console.log(error.errorMessage);
            session.reject(error.errorMessage);
            } else {
                // Since the decryption was successful, we can write the
                // plaintext to the output context.
                console.log('Decoded JSON is++++++'+plaintext);
                session.output.write(plaintext);
            }
        });
    }
});
