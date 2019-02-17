<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xmlns:str="http://exslt.org/strings" xmlns:dyn="http://exslt.org/dynamic" xmlns:util="http://www.anz.com/utilities" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:dp="http://www.datapower.com/extensions" exclude-result-prefixes="dp str xsi" extension-element-prefixes="dp dyn xsi str regexp">
	<dp:input-mapping href="RequestData.ffd" type="ffd"/>
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:variable name="protocol" select="dp:variable('var://service/protocol')"/>
		<xsl:variable name="payload">
			<xsl:copy-of select="/logInputFile/logInputTag/node()"/>
		</xsl:variable>
		<xsl:message dp:priority="error">
			Recieved Payload: <xsl:copy-of select="dp:parse($payload)"/>
		</xsl:message>
		<xsl:choose>
			<xsl:when test="contains($protocol, 'dpmq')">
				<xsl:variable name="mqmd" select="dp:parse(dp:request-header('MQMD'))"/>
				<!--<xsl:variable name="mqrfh2" select="dp:parse(dp:request-header('MQRFH2'))"/> -->
				<dp:set-variable name="'var://context/ANZ/MQMD'" value="$mqmd"/>
				<dp:set-variable name="'var://context/ANZ/MQRFH2'" value="$mqrfh2"/>
				<dp:set-variable name="'var://context/mq/replytoqm'" value="normalize-space($mqmd/MQMD/ReplyToQMgr)"/>
				<dp:set-variable name="'var://context/mq/replytoq'" value="normalize-space($mqmd/MQMD/ReplyToQ)"/>
				<dp:set-http-request-header name="'MQMD'" value="''"/>
				<dp:remove-http-request-header name="'MQMD'"/>
				<xsl:variable name="MQPayload" select="dp:parse($payload)"/>
				<xsl:copy-of select="string(normalize-space($MQPayload/B2BGatewayRq/Payload/text()))"/>
				<xsl:variable name="inContentType" select="string(normalize-space($MQPayload/B2BGatewayRqHdr/RoutingInfo/ContentType))"/>
				<dp:set-http-request-header name="'Content-Type'" value="$inContentType"/>
				<dp:freeze-headers/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$payload"/>
				<xsl:variable name="inContentType" select="dp:variable('var://service/original-content-type')"/>
				<dp:set-http-request-header name="'Content-Type'" value="$inContentType"/>
				<dp:freeze-headers/>
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:variable name="MQtarget" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetApp"/>
		<xsl:variable name="MQtokens" select="str:tokenize($target,'_')"/>
		<xsl:variable name="HTTPtarget" select="dp:http-request-header('Provider')"/>
		<xsl:variable name="HTTPtokens" select="str:tokenize($serviceURI,'/')"/>
		<xsl:variable name="HTTPuri" select="dp:variable('var://service/URI')"/>
		<xsl:variable name="HTTPmethod" select="normalize-space(dp:variable('var://service/protocol-method'))"/>
		<xsl:variable name="businessEventMf">
			<xsl:choose>
				<xsl:when test="contains($protocol, 'dpmq')">
					<xsl:variable name="MQPayload" select="dp:parse($payload)"/>
					<xsl:message dp:priority="error">
			MQ Payload: <xsl:copy-of select="$MQPayload"/>
					</xsl:message>
					<xsl:variable name="target" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetApp"/>
					<xsl:variable name="tagetservice" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetServiceName"/>
					<xsl:variable name="targetVersion" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetServiceVersion"/>
					<xsl:variable name="targetMethod" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetMethod"/>
					<xsl:variable name="ContentType" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/ContentType"/>
					<xsl:variable name="tokens" select="str:tokenize($target,'_')"/>
					<xsl:choose>
						<xsl:when test="string-length($target) != 0">
							<xsl:value-of select="concat($ssiConfigPath,$target,'_','Manifest.xml')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($ssiConfigPath,$tokens[1],'_','Manifest.xml')"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:variable name="MQuri" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetServiceURI"/>
					<xsl:variable name="MQmethod" select="normalize-space($targetMethod)"/>
					<dp:set-variable name="'var://service/URI'" value="$MQuri"/>
					<dp:set-variable name="'var://service/protocol-method'" value="$MQmethod"/>
					<dp:set-http-request-header name="'Content-Type'" value="$ContentType"/>
					<dp:set-http-request-header name="'RequestID'" value="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/MessageHeader/sourceSystemMessageID"/>
					<dp:set-http-request-header name="'ANZ-Application-ID'" value="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/MessageHeader/emittedBySourceSystemInstance/name"/>
					<dp:set-http-request-header name="'Provider'" value="$target"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="serviceURI">
						<xsl:call-template name="getServiceURI"/>
					</xsl:variable>
					<xsl:message dp:priority="error">
                            ************* Values Got *****************
                            <xsl:value-of select="$method"/>  And <xsl:value-of select="$uri"/>
					</xsl:message>
					<xsl:variable name="target" select="dp:http-request-header('Provider')"/>
					<xsl:variable name="tokens" select="str:tokenize($serviceURI,'/')"/>
					<xsl:choose>
						<xsl:when test="string-length($target) != 0">
							<xsl:value-of select="concat($ssiConfigPath,$target,'_','Manifest.xml')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($ssiConfigPath,$tokens[1],'_','Manifest.xml')"/>
						</xsl:otherwise>
					</xsl:choose>
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
		<xsl:variable name="entry">
			<xsl:choose>
				<xsl:when test="contains($protocol,'dpmq')">
					<xsl:variable name="MQPayload" select="dp:parse($payload)"/>
					<xsl:variable name="service" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr/RoutingInfo/targetServiceName"/>
					<xsl:copy-of select="$businessEventMfFile/entries/entry[ServiceMetadata/OperationName=$service]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$businessEventMfFile/entries/entry[regexp:test($HTTPuri, @match) and @method=$HTTPmethod]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:message dp:priority="error">
                            ************* Entry picked *****************
                            <xsl:copy-of select="$entry"/>
		</xsl:message>
		<dp:set-variable name="'var://context/SSI/ServiceManifest'" value="$entry"/>
		<xsl:variable name="SSICheck" select="$entry/entry/ServiceMetadata/ServiceTransformation"/>
		<xsl:variable name="RouterMapManifest" select="document('RouterMapping.xml')"/>
		<xsl:variable name="URI" select="dp:variable('var://service/URI')"/>
		<xsl:choose>
			<xsl:when test="$SSICheck != 'Y'">
				<xsl:variable name="SSIRoute" select="$RouterMapManifest/routingInfo/routing-urls/url[@type='proxy']"/>
				<dp:set-variable name="'var://service/routing-url'" value="concat($SSIRoute,$URI)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="SSIRoute" select="$RouterMapManifest/routingInfo/routing-urls/url[@type='SSI']"/>
				<dp:set-variable name="'var://service/routing-url'" value="concat($SSIRoute,$URI)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:message dp:priority="error">
                            ************* Splunk Log Rule *****************
                            <xsl:value-of select="$entry/RouterMetadata/LogRule"/>
		</xsl:message>
		<xsl:variable name="LogRule" select="string($entry/entry/RouterMetadata/LogRule)"/>
		<xsl:if test="$LogRule !=''">
			<dp:set-variable name="'var://context/ANZ/LogRule'" value="$LogRule"/>
			<xsl:message dp:priority="error">
                            ************* Splunk Logging *****************
                            <xsl:value-of select="$LogRule"/>
			</xsl:message>
		</xsl:if>
		<!--Sets the Authorize Value from the Manifest-->
		<xsl:variable name="enableAAA">
			<xsl:value-of select="string($entry/entry/RouterMetadata/Authorize/@enabled)"/>
		</xsl:variable>
		<xsl:message>
						enableAAA: <xsl:value-of select="$enableAAA"/>
		</xsl:message>
		<xsl:choose>
			<xsl:when test="contains($protocol, 'dpmq')">
				<dp:set-variable name="'var://context/ANZDP/Authorise/Enabled'" value="'N'"/>
			</xsl:when>
			<xsl:otherwise>
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
			</xsl:otherwise>
		</xsl:choose>
		<dp:set-variable name="'var://context/ANZ/Authorize'" value="$entry/entry/RouterMetadata/Authorize"/>
		<xsl:variable name="ServiceName" select="$entry/entry/ServiceMetadata/OperationName"/>
		<xsl:choose>
			<xsl:when test="contains($protocol, 'dpmq')">
				<xsl:variable name="MQPayload" select="dp:parse($payload)"/>
				<xsl:variable name="MQReqHeaders" select="$MQPayload/B2BGatewayRq/B2BGatewayRqHdr"/>
				<dp:set-variable name="'var://context/ANZ/RequestHeaders'" value="$MQReqHeaders"/>
				<dp:set-variable name="'var://context/ANZ/sourcesys'" value="$MQReqHeaders/MessageHeader/emittedBySourceSystemInstance/name"/>
				<dp:set-variable name="'var://context/ANZ/targetsys'" value="$MQReqHeaders/RoutingInfo/targetApp"/>
				<dp:set-variable name="'var://context/ANZ/MessageID'" value="$MQReqHeaders/MessageHeader/sourceSystemMessageID"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/ANZ/sourcesys'" value="dp:http-request-header('ANZ-Application-ID')"/>
				<dp:set-variable name="'var://context/ANZ/targetsys'" value="dp:http-request-header('Provider')"/>
				<dp:set-variable name="'var://context/ANZ/MessageID'" value="dp:http-request-header('RequestID')"/>
			</xsl:otherwise>
		</xsl:choose>
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
