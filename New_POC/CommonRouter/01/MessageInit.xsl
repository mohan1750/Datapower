<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xmlns:str="http://exslt.org/strings" xmlns:dyn="http://exslt.org/dynamic" xmlns:util="http://www.anz.com/utilities" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:dp="http://www.datapower.com/extensions" exclude-result-prefixes="dp str xsi" extension-element-prefixes="dp dyn xsi str regexp">
<dp:input-mapping href="RequestData.ffd" type="ffd"/>
<xsl:output method="xml"/>
	<xsl:template match="/">
                <xsl:variable name="payload">
                    <xsl:copy-of select="/logInputFile/logInputTag/node()"/>
                </xsl:variable>
		<xsl:variable name="serviceName" select="dp:variable('var://service/processor-name')"/>
		<!--Fetching the Env Manifest File -->
		<xsl:variable name="environmentManifest" select="document('local:///ondisk/environment/environment.xml')"/>
		<xsl:variable name="documentError" select="dp:variable('var://local/_extension/error')"/>
		<xsl:if test="$documentError">
			<xsl:message terminate="yes">
				<xsl:value-of select="$documentError"/>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="filesystemPathServices" select="$environmentManifest/environment/filesystem-path-services"/>
		<xsl:variable name="ssiConfigPath" select="$environmentManifest/environment/common-config-path"/>
		<dp:set-variable name="'var://context/ANZ/LogRule'" value="string($environmentManifest/environment/LogRule)"/>
		<dp:set-variable name="'var://context/SSI/envManifest'" value="$environmentManifest"/>
		<dp:set-variable name="'var://service/mpgw/proxy-http-response'" value="1"/>
		<xsl:variable name="serviceURI">
			<xsl:call-template name="getServiceURI"/>
		</xsl:variable>
		<xsl:variable name="uri" select="dp:variable('var://service/URI')"/>
		<xsl:variable name="method" select="normalize-space(dp:variable('var://service/protocol-method'))"/>
		<xsl:message dp:priority="error">
                            ************* Values Got *****************
                            <xsl:value-of select="$method"/>  And <xsl:value-of select="$uri"/>
		</xsl:message>
		<xsl:variable name="target" select="dp:http-request-header('Provider')"/>
		<xsl:variable name="tokens" select="str:tokenize($serviceURI,'/')"/>
		<xsl:variable name="businessEventMf">
			<xsl:choose>
				<xsl:when test="string-length($target) != 0">
					<xsl:value-of select="concat($ssiConfigPath,$target,'_','Manifest.xml')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($ssiConfigPath,$tokens[1],'_','Manifest.xml')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="businessEventMfFile" select="document($businessEventMf)"/>
		<xsl:variable name="beDocumentError" select="dp:variable('var://local/_extension/error')"/>
		<xsl:if test="$beDocumentError">
			<xsl:message terminate="yes">
				<xsl:value-of select="$beDocumentError"/>
			</xsl:message>
		</xsl:if>
		<dp:set-variable name="'var://context/SSI/CommonManifest'" value="$businessEventMfFile"/>
		<xsl:variable name="entry" select="$businessEventMfFile/entries/entry[regexp:test($uri, @match) and @method=$method]"/>
		
		<xsl:message dp:priority="error">
                            ************* Entry picked *****************
                            <xsl:copy-of select="$entry"/>
		</xsl:message>
		<dp:set-variable name="'var://context/SSI/ServiceManifest'" value="$entry"/>
		<xsl:variable name="SSICheck" select="$entry/ServiceMetadata/ServiceTransformation"/>
		<xsl:variable name="RouterMapManifest" select="document('RouterMapping.xml')"/>
		<xsl:choose>
			<xsl:when test="$SSICheck != 'Y'">
				<xsl:variable name="SSIRoute" select="$RouterMapManifest/routingInfo/routing-urls/url[@type='proxy']"/>
				<dp:set-variable name="'var://service/routing-url'" value="concat($SSIRoute,$uri)"/>
			</xsl:when>
			<xsl:otherwise >
			        <xsl:variable name="SSIRoute" select="$RouterMapManifest/routingInfo/routing-urls/url[@type='SSI']"/>
				<dp:set-variable name="'var://service/routing-url'" value="concat($SSIRoute,$uri)"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="LogRule" select="string($entry/RouterMetadata/LogRule)"/>
		<xsl:if test="$LogRule !=''">
			<dp:set-variable name="'var://context/ANZ/LogRule'" value="$LogRule"/>
			<xsl:message dp:priority="error">
                            ************* Splunk Logging *****************
                            <xsl:value-of select="$LogRule"/>
			</xsl:message>
		</xsl:if>
		<!--Sets the Authorize Value from the Manifest-->
		<xsl:variable name="enableAAA">
			<xsl:value-of select="string($entry/RouterMetadata/Authorize/@enabled)"/>
		</xsl:variable>
		<xsl:message>
						enableAAA: <xsl:value-of select="$enableAAA"/>
		</xsl:message>
		<xsl:choose>
			<xsl:when test="$enableAAA = 'Y'">
				<xsl:message>enableAAA: <xsl:value-of select="$enableAAA"/>
				</xsl:message>
				<dp:set-variable name="'var://context/ANZDP/Authorise/Enabled'" value="'Y'"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/ANZDP/Authorise/Enabled'" value="'N'"/>
			</xsl:otherwise>
		</xsl:choose>
		<dp:set-variable name="'var://context/ANZ/Authorize'" value="$entry/RouterMetadata/Authorize"/>
		<xsl:variable name="ServiceName" select="$entry/ServiceMetadata/OperationName"/>
		<dp:set-variable name="'var://context/ANZ/sourcesys'" value="dp:http-request-header('ANZ-Application-ID')"/>
		<dp:set-variable name="'var://context/ANZ/targetsys'" value="dp:http-request-header('Provider')"/>
		<dp:set-variable name="'var://context/ANZ/MessageID'" value="dp:http-request-header('RequestID')"/>
		<dp:set-variable name="'var://context/ANZ/operationName'" value="$ServiceName"/>
		<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	</xsl:template>
	<xsl:template name="getServiceDir">
		<xsl:param name="servicesDir"/>
		<xsl:param name="serviceName"/>
		<xsl:variable name="service" select="substring($serviceName,1,string-length($serviceName)-2)"/>
		<xsl:variable name="version" select="substring($serviceName,string-length($serviceName)-1)"/>
		<xsl:value-of select="concat($servicesDir,$service,'/',$version,'/')"/>
	</xsl:template>
	<xsl:template name="getServiceURI">
		<xsl:variable name="serviceUri" select="dp:variable('var://service/URI')"/>
		<xsl:choose>
			<!-- when query parameter is present -->
			<xsl:when test="contains($serviceUri,'?')">
				<xsl:value-of select="substring-before($serviceUri,'?')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$serviceUri"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>