<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:xalan="http://xml.apache.org/xslt" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:dp="http://www.datapower.com/extensions" xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="xalan dp exsl str regexp date" extension-element-prefixes="dp">
	<!-- This stylesheet is used to Extract the identity of the user -->
	<xsl:template match="/">
		<!--<xsl:variable name="serviceName" select="dp:variable('var://service/processor-name')"/>
		<xsl:variable name="gatewaypatternName" select="substring($serviceName,0,number(string-length($serviceName))-1)"/>-->
		<!--<xsl:variable name="RequestMsgHdr" select="/*[local-name()='Envelope']/*[local-name()='Body']/B2BInwardGatewayRq/B2BInwardGatewayRqHdr"/>-->
		<!--<xsl:variable name="consName" select="$RequestMsgHdr/MessageHeader/emittedBySourceSystemInstance/name"/>-->
		<!--<dp:set-variable name="'var://context/B2BInwardGateway01/ConsName'" value="string($consName)"/>-->
		<!--<dp:set-variable name="'var://context/ANZ/GatewaypatternName'" value="string($gatewaypatternName)"/>-->
		<xsl:value-of select="dp:client-subject-dn('ldap')"/>
	</xsl:template>
</xsl:stylesheet>