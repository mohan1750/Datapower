<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" 
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
	xmlns:str="http://exslt.org/strings" 
	xmlns:dp="http://www.datapower.com/extensions" 
	exclude-result-prefixes="dp soapenv str xsi" 
	extension-element-prefixes="dp">
	<xsl:template match="/">
		<xsl:variable name="errorConfig" select="dp:variable('var://context/SSI/errorConfig')"/>
		<xsl:variable name="errorCode" select="dp:variable('var://service/error-code')"/>
		<xsl:variable name="errorSubcode" select="dp:variable('var://service/error-subcode')"/>
		<xsl:variable name="errorDesc" select="dp:variable('var://service/error-message')"/>
		<xsl:variable name="validationErrorCode" select="dp:variable('var://context/SSI/error-subcode')"/>
		<xsl:variable name="validationErrorMessage" select="dp:variable('var://context/SSI/error-message')"/>

		<xsl:variable name="errorStylesheet" select="$errorConfig/errorHandler/@stylesheet"/>
		<xsl:message>errorStylesheet:<xsl:value-of select="$errorStylesheet"/> </xsl:message>

		<xsl:choose>
			<xsl:when test="$errorStylesheet">
			
				<xsl:variable name="statusBlock">
					<status>
						<xsl:choose>
							
							<xsl:when test="$validationErrorCode = '200'">
								<statusCode>200</statusCode>
								<severity>error</severity>
								<statusDesc><xsl:value-of select="$validationErrorMessage"/></statusDesc>
							</xsl:when>
							<xsl:when test="$errorCode='0x01130006' or $errorCode='0x01130007' or $errorCode='0x01130008' or $errorCode='0x0113001e' or $errorCode='0x0113001c' ">
								<statusCode>300</statusCode>
								<severity>error</severity>
								<statusDesc><xsl:value-of select="$errorDesc"/></statusDesc>
							</xsl:when>
							<xsl:when test="$errorCode='0x00c30002' or $errorCode='0x00230001'">
								<statusCode>100</statusCode>
								<severity>error</severity>
								<statusDesc><xsl:value-of select="$errorDesc"/></statusDesc>
							</xsl:when>
							<xsl:when test="$errorSubcode = '0x01d30001' or $errorSubcode = '0x01d30002'">			
								<statusCode>1740</statusCode>
								<severity>error</severity>
								<statusDesc>Authentication/Authorisation failure</statusDesc>
							</xsl:when>
							
							<xsl:otherwise>
								<statusCode>100</statusCode>
								<severity>error</severity>
								<statusDesc><xsl:value-of select="$errorDesc"/></statusDesc>
							</xsl:otherwise>
						</xsl:choose>
					</status>
				</xsl:variable>
<xsl:message>statusBlock:<xsl:copy-of select="$statusBlock"/> </xsl:message>
				<xsl:copy-of select="dp:transform($errorStylesheet,$statusBlock)"/>
			</xsl:when>
			<xsl:otherwise>
				
				<xsl:choose>
					<xsl:when test="$validationErrorCode = '200'">
						<dp:set-variable name="'var://service/error-protocol-response'" value="'400'"/>
						<dp:set-variable name="'var://service/error-protocol-reason-phrase'" value="'Bad Request'"/>
						
						<!-- Used for logging -->
						<dp:set-variable name="'var://context/ANZ/protocolStatusCode'" value="'400'"/>
						<dp:set-variable name="'var://context/ANZ/protocolStatusMessage'" value="'Bad Request'"/>
					</xsl:when>
					<xsl:when test="$errorSubcode = '0x01d30001' or $errorSubcode = '0x01d30002'">
						<dp:set-variable name="'var://service/error-protocol-response'" value="'401'"/>
						<dp:set-variable name="'var://service/error-protocol-reason-phrase'" value="'Unauthorized'"/>
						<!-- Used for logging -->
						<dp:set-variable name="'var://context/ANZ/protocolStatusCode'" value="'401'"/>
						<dp:set-variable name="'var://context/ANZ/protocolStatusMessage'" value="'Unauthorized'"/>
					</xsl:when>
					<xsl:otherwise>
						<dp:set-variable name="'var://service/error-protocol-response'" value="'500'"/>
						<!-- Used for logging -->
						<dp:set-variable name="'var://context/ANZ/protocolStatusCode'" value="'500'"/>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
					
		
		
		

	</xsl:template>
	
</xsl:stylesheet>