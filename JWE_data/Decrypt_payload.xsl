<xsl:stylesheet version="1.0" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
     xmlns:apim="http://www.ibm.com/apimanagement"
     xmlns:dp="http://www.datapower.com/extensions" 
     extension-element-prefixes="dp"
     exclude-result-prefixes="dp apim"
> 
<dp:input-mapping href="sample.ffd" type="ffd"/>
	<xsl:output method="text"/>

 
  
  <xsl:template match="/">
    <xsl:variable name="jsParams">
			<parameter name="key">JWE_encrypt</parameter>
			<parameter name="alg">RSA1_5</parameter>
			<parameter name="enc">A128CBC-HS256</parameter>
		</xsl:variable>
		<xsl:variable name="payload" select="string(/sampleFile/sampleTag/node())"/>
		<dp:set-variable name="'var://service/mpgw/skip-backside'" value="'1'"/>
                <dp:set-http-request-header name="'Content-Type'" value="'application/json'"/>
		
				<xsl:value-of select="dp:gatewayscript('decrypt.js', $payload,false(),$jsParams)"/>
				
    
  </xsl:template>

</xsl:stylesheet>

