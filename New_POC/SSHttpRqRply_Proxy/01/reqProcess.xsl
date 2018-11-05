<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:func="http://exslt.org/functions" extension-element-prefixes="dp func" xmlns:util="http://www.anz.com/utilities" exclude-result-prefixes="dp dpconfig str func regexp util">
	<!--<dp:input-mapping href="local:///ondisk/services/SSPHTTPRqRplyOutward/01/dataProcess.ffd" type="ffd"/>-->
	<xsl:template match="/">
		<!-- 
		<xsl:variable name="actions" select="dp:variable('var://context/SSI/actions')"/>
		 -->
		<xsl:variable name="msgType" select="dp:variable('var://context/ANZ/targetMsgType')"/>
		<xsl:message>***MsgType=<xsl:value-of select="$msgType"/>
		</xsl:message>
		<!--<xsl:variable name="sourceConfig" select="dp:variable('var://context/SSI/sourceConfig')"/>-->
		<xsl:variable name="targetConfig" select="dp:variable('var://context/SSI/targetConfig')"/>
		<xsl:variable name="reqProcessOut">
			<!--<xsl:copy-of select="/InputData/InputDataTag/node()"/>-->
			<xsl:copy-of select="."/>
		</xsl:variable>
		<dp:set-local-variable name="'var://local/ReqProcessOut'" value="$reqProcessOut"/>
		<xsl:choose>
			<xsl:when test="$targetConfig">
				<!--<dp:set-local-variable name="var://local/ReqProcessOut'" value="."/>-->
				<xsl:for-each select="$targetConfig/request/actions/action">
					<xsl:choose>
						<xsl:when test="./@name='HTTP-RQHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing Http Rq header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/HttpRqHeaderHandler'),dp:local-variable('var://local/ReqProcessOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='MQ-RQHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing Mq Rq header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/MqRqHeaderHandler'),dp:local-variable('var://local/ReqProcessOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='JMS-RQHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing JMS Rq header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/JmsRqHeaderHandler'),dp:local-variable('var://local/ReqProcessOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='custom'">
							<xsl:message>Executing custom action:<xsl:value-of select="./@name"/>
							</xsl:message>
							<xsl:variable name="afterCustom">
								<xsl:variable name="customFile" select="document($targetConfig/request/actions/action[@name='custom'])"/>
								<xsl:choose>
									<xsl:when test="$customFile">
										<xsl:copy-of select="dp:transform($targetConfig/request/actions/action[@name='custom'],dp:local-variable('var://local/ReqProcessOut'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="yes">The specified custom XSL doesn't exist</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/ReqProcessOut'" value="$afterCustom"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">targetConfig doesn't exist</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="environmentManifest" select="dp:variable('var://context/SSI/envManifest')"/>
		<xsl:variable name="filesystemPathApplications" select="$environmentManifest/environment/filesystem-path-applications"/>
		<xsl:variable name="envName" select="$environmentManifest/environment/@name"/>
		<xsl:variable name="clientQual" select="dp:variable('var://context/SSI/ClientQual')"/>
		<xsl:variable name="routingURL">
			<xsl:choose>
				<xsl:when test="contains($clientQual,'-')">
					<xsl:variable name="clientQualFileName" select="concat($filesystemPathApplications,'qualifiers/',$clientQual,'.xml')"/>
					<xsl:variable name="clientQualFile" select="document($clientQualFileName)"/>
					<xsl:variable name="cqfDocumentError" select="dp:variable('var://local/_extension/error')"/>
					<xsl:if test="$cqfDocumentError">
						<xsl:message terminate="yes">
							<xsl:value-of select="$cqfDocumentError"/>
						</xsl:message>
					</xsl:if>
					<xsl:variable name="qualifier" select="$clientQualFile/qualifiers/qualifier[@system=$targetConfig/request/endpointConfig/targetSystem]"/>
					<xsl:choose>
						<xsl:when test="$qualifier!=''">
							<dp:set-local-variable name="'var://local/routingInfoFileName'" value="concat($filesystemPathApplications,$targetConfig/request/endpointConfig/targetSystem,'-',$qualifier,'.xml')"/>
						</xsl:when>
						<xsl:otherwise>
							<dp:set-local-variable name="'var://local/routingInfoFileName'" value="concat($filesystemPathApplications,$targetConfig/request/endpointConfig/targetSystem,'.xml')"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:variable name="routingInfoFile" select="document(dp:local-variable('var://local/routingInfoFileName'))"/>
					<xsl:variable name="rifDocumentError" select="dp:variable('var://local/_extension/error')"/>
					<xsl:if test="$rifDocumentError">
						<xsl:message terminate="yes">
							<xsl:value-of select="$rifDocumentError"/>
						</xsl:message>
					</xsl:if>
					<xsl:call-template name="getRoutingUrl">
						<xsl:with-param name="rtInfoFile" select="$routingInfoFile"/>
						<xsl:with-param name="tConfig" select="$targetConfig"/>
						<xsl:with-param name="env" select="$envName"/>
						<xsl:with-param name="payload" select="dp:local-variable('var://local/ReqProcessOut')"/>
					</xsl:call-template>
					<dp:set-local-variable name="'var://local/sslProxyProfile'" value="$routingInfoFile/routingInfo/sslProxyProfile"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="routingInfoFileName" select="concat($filesystemPathApplications,$targetConfig/request/endpointConfig/targetSystem,'.xml')"/>
					<xsl:variable name="routingInfoFile" select="document($routingInfoFileName)"/>
					<xsl:variable name="rif2DocumentError" select="dp:variable('var://local/_extension/error')"/>
					<xsl:if test="$rif2DocumentError">
						<xsl:message terminate="yes">
							<xsl:value-of select="$rif2DocumentError"/>
						</xsl:message>
					</xsl:if>
					<xsl:call-template name="getRoutingUrl">
						<xsl:with-param name="rtInfoFile" select="$routingInfoFile"/>
						<xsl:with-param name="tConfig" select="$targetConfig"/>
						<xsl:with-param name="env" select="$envName"/>
						<xsl:with-param name="payload" select="dp:local-variable('var://local/ReqProcessOut')"/>
					</xsl:call-template>
					<dp:set-local-variable name="'var://local/sslProxyProfile'" value="$routingInfoFile/routingInfo/sslProxyProfile"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="number(normalize-space(string-length($routingURL))) = number(0)">
			<dp:set-variable name="'var://context/ANZ/errorCode'" value="'0b000001'"/>
			<xsl:message terminate="yes">Backend service is unavailable'</xsl:message>
		</xsl:if>
		<xsl:variable name="timeout">
			<xsl:call-template name="getTimeout">
				<xsl:with-param name="tConfig" select="$targetConfig"/>
			</xsl:call-template>
		</xsl:variable>
		<dp:set-variable name="'var://service/routing-url'" value="$routingURL"/>
		<dp:set-variable name="'var://service/mpgw/backend-timeout'" value="$timeout"/>
		<xsl:variable name="sslProxyProfile" select="dp:local-variable('var://local/sslProxyProfile')"/>
		<xsl:if test="$sslProxyProfile">
			<dp:set-variable name="'var://service/routing-url-sslprofile'" value="$sslProxyProfile"/>
		</xsl:if>
		<!--	<xsl:choose>
			<xsl:when test="$msgType='SOAP' or $msgType='XML'">
				<xsl:message>***insideWhenMsgType=<xsl:value-of select="$msgType"/>
				</xsl:message>
				<xsl:copy-of select="dp:parse(dp:local-variable('var://local/ReqProcessOut'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>***OutsideWhenMsgType=<xsl:value-of select="$msgType"/>
				</xsl:message>
				<xsl:copy-of select="dp:local-variable('var://local/ReqProcessOut')"/>
			</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	<xsl:template name="getRoutingUrl">
		<xsl:param name="rtInfoFile"/>
		<xsl:param name="tConfig"/>
		<xsl:param name="env"/>
		<xsl:param name="payload"/>
		<xsl:variable name="domain" select="dp:variable('var://service/domain-name')"/>
		<!--Fetching the uri variable if set in service specific xsl-->
		<xsl:variable name="uri">
			<xsl:choose>
				<xsl:when test="dp:variable('var://context/SSI/FinalURI') != ''">
					<xsl:value-of select="dp:variable('var://context/SSI/FinalURI')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getRoutingUri">
						<xsl:with-param name="tarConfig" select="$tConfig"/>
						<xsl:with-param name="inpayload" select="$payload"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--Fetching the url variable if set in service specific xsl-->
		<xsl:variable name="url">
			<xsl:choose>
				<xsl:when test="dp:variable('var://context/SSI/URLVariable') != ''">
					<xsl:value-of select="dp:variable('var://context/SSI/URLVariable')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rtInfoFile/routingInfo/routing-urls/url[@env=$env and @domain=$domain]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($uri)!=''">
				<xsl:value-of select="concat($url,$uri)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$url"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getRoutingUri">
		<xsl:param name="tarConfig"/>
		<xsl:param name="inpayload"/>
		<xsl:choose>
			<!-- When type is specified i.e when custom URI is required-->
			<xsl:when test="$tarConfig/request/endpointConfig/uri/@type">
				<xsl:variable name=" ssiUriHandler" select="dp:variable('var://context/SSI/action/SsiUriHandler')"/>
				<xsl:variable name="payload">
					<xsl:choose>
						<xsl:when test="$inpayload">
							<xsl:copy-of select="$inpayload"/>
						</xsl:when>
						<xsl:otherwise>
							<payload>empty</payload>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="normalize-space($ssiUriHandler)!=''">
						<xsl:variable name="uriHandlerFile" select="document($ssiUriHandler)"/>
						<xsl:choose>
							<xsl:when test="$uriHandlerFile">
								<xsl:value-of select="dp:transform($ssiUriHandler,$payload)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:message terminate="yes">The specified SSI Uri Handler 
<xsl:value-of select="$ssiUriHandler"/>
 doesn't exist</xsl:message>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">Specified URI handler must be specified</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- When URI type is not specified, the given URI will be used to set -->
			<xsl:otherwise>
				<xsl:value-of select="$tarConfig/request/endpointConfig/uri"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
		default timeout 30 seconds 
	 -->
	<xsl:template name="getTimeout">
		<xsl:param name="tConfig"/>
		<xsl:choose>
			<xsl:when test="$tConfig/request/endpointConfig/timeout">
				<xsl:value-of select="$tConfig/request/endpointConfig/timeout"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'30'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
