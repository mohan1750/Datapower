<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str">
	<xsl:template match="/">
		<xsl:variable name="environmentManifest" select="document('local:///ondisk/environment/environment.xml')"/>
		<xsl:variable name="filesystemPathApplications" select="$environmentManifest/environment/filesystem-path-applications"/>
		<xsl:variable name="envName" select="$environmentManifest/environment/@name"/>
		<xsl:variable name="provider" select="dp:http-request-header('Provider')"/>
		<xsl:variable name="httpMethod" select="dp:variable('var://service/protocol-method')"/>
		<xsl:message dp:priority="error">
				Provider is <xsl:value-of select="$provider"/>
		</xsl:message>
		<xsl:variable name="targetSystemFileName" select="concat($filesystemPathApplications,$provider,'.xml')"/>
		<xsl:message dp:priority="error">
				Path is <xsl:value-of select="$filesystemPathApplications"/> and File is <xsl:value-of select="$provider"/>.xml
		</xsl:message>
		<xsl:variable name="targetSystem" select="document($targetSystemFileName)"/>
		<dp:set-variable name="'var://context/ANZ/TargetManifest'" value="$targetSystem"/>
		<xsl:variable name="endpoint" select="$targetSystem/routingInfo/routing-urls/url[@env=$envName]"/>
		<xsl:message dp:priority="error">
				Manifest is <xsl:value-of select="$targetSystem"/>
		</xsl:message>
		<xsl:variable name="sslProxyProfile" select="$targetSystem/routingInfo/sslProxyProfile"/>
		<xsl:variable name="sslClientProfile" select="$targetSystem/routingInfo/sslClientProfile"/>
		<xsl:variable name="incomingURI" select="dp:variable('var://service/URI')"/>
		<dp:set-variable name="'var://context/ANZ/sourcesys'" value="dp:http-request-header('ANZ-Application-ID')"/>
		<dp:set-variable name="'var://context/ANZ/targetsys'" value="$provider"/>
		<dp:set-variable name="'var://context/ANZ/operationName'" value="dp:http-request-header('X-OperationName')"/>
		<dp:set-variable name="'var://context/ANZ/MessageID'" value="dp:http-request-header('RequestID')"/>
		<dp:set-variable name="'var://service/routing-url'" value="concat($endpoint,$incomingURI)"/>
		<xsl:if test="$sslProfile">
			<dp:set-variable name="'var://service/routing-url-sslprofile'" value="$sslProxyProfile"/>
		</xsl:if>
		<xsl:if test="$sslClientProfile">
			<dp:set-variable name="'var://service/routing-url-sslprofile'" value="concat('client:',$sslClientProfile)"/>
		</xsl:if>
		<dp:set-variable name="'var://context/ANZ/LogRule'" value="'Common_Log_Rule02'"/>
		<dp:set-variable name="'var://service/mpgw/backend-timeout'" value="$targetSystem/routingInfo/Timeout"/>
		<dp:set-variable name="'var://service/protocol-method'" value="$httpMethod"/>
		<dp:set-variable name="'var://context/ANZDP/Content-Type'" value="dp:http-request-header('Content-Type')"/>
		<dp:remove-http-request-header name="Provider"/>
		<dp:remove-http-request-header name="Qualifier"/>
		<dp:remove-http-request-header name="ANZ-Application-ID"/>
	</xsl:template>
</xsl:stylesheet>