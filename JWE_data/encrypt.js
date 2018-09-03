// Simple JWS 'encrypt' example
//   - JSON serialization
//   - Needs configurable enc, alg, key, message

var jose = require('jose');

// The input *should* be JSON, but readAsBuffer will process the input even if it's
// not valid JSON
session.input.readAsBuffer(function(error, buffer) {
    if (error) {
        session.reject("Error reading input: "+error);
    } else {
        // Get the enumerated value to use as the encryption algorithm. Valid options are:
        //   - A128CBC-HS256
        //   - A192CBC-HS384
        //   - A256CBC-HS512
		
        var encValue = session.parameters.enc;

        // Create a JWEHeader object, passing the encryption algorithm as an argument.
        var jweHdr = jose.createJWEHeader(encValue);

        // Get the enumerated value to use as the key encryption algorithm.
        // Valid options are:
        //    - RSA1_5        (Key Encryption algorithm)
        //    - RSA-OAEP      (Key Encryption algorithm)
        //    - RSA-OAEP-256  (Key Encryption algorithm)
        //    - A128KW        (Key Wrapping algorithm)
        //    - A192KW        (Key Wrapping algorithm)
        //    - A256KW        (Key Wrapping algorithm)
        var algValue = session.parameters.alg;

        // Get the name of the mgmt object to use as the key
        var keyValue = session.parameters.key;

        // Set the 'alg' protected header and the single recipient's key value.
        jweHdr.setProtected('alg', algValue);
        jweHdr.addRecipient(keyValue);

        // 1. Specify which jweHeader defines how to encrypt this message, to create a JWEEncrypter object.
        // 2. Update the JWEEncrypter object with the message to be encrypted.
        // 3. Encrypt the JWEEncrypter object using JSON serialization output format
        jose.createJWEEncrypter(jweHdr).update(buffer).encrypt('json', function(error, jweJSONObj) {
            if (error) {
                // An error occurred during the encrypt process and is passed back
                // via the error parameter since .encrypt is an asynchronous call.
                session.reject(error.errorMessage);
            } else {
                // Encryption was successful. The resulting 'jweCompactObj' is a JSON object, which
                // can be written to the output context.
                // The object's format is:
                //   {
                //   "protected":"BASE64URL(UTF8(JWE Protected Header))",
                //   "unprotected":"JWE Shared Unprotected Header"",
                //   "recipients":[
                //   {"header":JWE Per-Recipient Unprotected Header 1,
                //   "encrypted_key":"BASE64URL(JWE Encrypted Key 1)"},
                //   ...
                //   {"header":JWE Per-Recipient Unprotected Header 2,
                //   "encrypted_key":"BASE64URL(JWE Encrypted Key N)"}],
                //   "aad":"BASE64URL(JWE AAD))",
                //   "iv":"BASE64URL(JWE Initialization Vector)",
                //   "ciphertext":"BASE64URL(JWE Ciphertext)",
                //   "tag":"BASE64URL(JWE Authentication Tag)"
                //   }
				//var jweResponse= {"encrypted_data":jweJSONObj }
                session.output.write(jweJSONObj);
            }
        });
    }
});
