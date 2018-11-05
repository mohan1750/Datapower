<xsl:stylesheet version="1.0" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:json="http://www.ibm.com/xmlns/prod/2009/jsonx">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<!-- 
		<xsl:variable name="actions" select="dp:variable('var://context/SSI/actions')"/>
		 -->
		<xsl:variable name="targetConfig" select="dp:variable('var://context/SSI/targetConfig')"/>
		<xsl:choose>
			<xsl:when test="$targetConfig">
				<dp:set-local-variable name="'var://local/PostTransformOut'" value="."/>
				<xsl:for-each select="$targetConfig/actions/action">
					<xsl:choose>
						<xsl:when test="./@name='HTTP-RQHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing Http Rq header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/HttpRqHeaderHandler'),dp:local-variable('var://local/PostTransformOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='MQ-RQHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing Mq Rq header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/MqRqHeaderHandler'),dp:local-variable('var://local/PostTransformOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='JMS-RQHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing JMS Rq header handler action</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/JmsRqHeaderHandler'),dp:local-variable('var://local/PostTransformOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='ADD-SOAP'">
							<!-- Add soap envelop-->
							<xsl:message>Executing Add SOAP action</xsl:message>
							<xsl:variable name="afterAddSoap">
								<xsl:copy-of select="dp:transform(dp:variable('var://context/SSI/action/AddSoap'),dp:local-variable('var://local/PostTransformOut'))"/>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PostTransformOut'" value="$afterAddSoap"/>
						</xsl:when>
						<xsl:when test="./@type='custom'">
							<xsl:message>Executing custom action</xsl:message>
							<xsl:variable name="afterCustom">
								<xsl:variable name="customFile" select="document($targetConfig/request/actions/action[@type='custom'])"/>
								<xsl:choose>
									<xsl:when test="$customFile">
										<xsl:copy-of select="dp:transform($targetConfig/request/actions/action[@type='custom'],dp:local-variable('var://local/PostTransformOut'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="yes">The specified custom XSL doesn't exist</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PostTransformOut'" value="$afterCustom"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">targetConfig doesn't exist</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Set the endpoint -->
		<xsl:variable name="environmentManifest" select="dp:variable('var://context/SSI/envManifest')"/>
		<xsl:variable name="filesystemPathApplications" select="$environmentManifest/environment/filesystem-path-applications"/>
		<xsl:variable name="envName" select="$environmentManifest/environment/@name"/>
		<xsl:message>			epConfig: 
<xsl:copy-of select="$targetConfig/request/endpointConfig"/>
		</xsl:message>
		<xsl:message>targetSystem:
<xsl:value-of select="$targetConfig/request/endpointConfig/targetSystem"/>
		</xsl:message>
		<xsl:variable name="clientQual" select="dp:variable('var://context/SSI/ClientQual')"/>
		<xsl:message>clientQual=
<xsl:value-of select="$clientQual"/>
		</xsl:message>
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
					<xsl:message>qualifier=
<xsl:value-of select="$qualifier"/>
					</xsl:message>
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
						<xsl:with-param name="payload" select="dp:local-variable('var://local/PostTransformOut')"/>
					</xsl:call-template>
					<dp:set-local-variable name="'var://local/sslProxyProfile'" value="$routingInfoFile/routingInfo/sslProxyProfile"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="routingInfoFileName" select="concat($filesystemPathApplications,$targetConfig/EndpointConfig/TargetSystem,'.xml')"/>
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
						<xsl:with-param name="payload" select="dp:local-variable('var://local/PostTransformOut')"/>
					</xsl:call-template>
					<dp:set-local-variable name="'var://local/sslProxyProfile'" value="$routingInfoFile/routingInfo/sslProxyProfile"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- 
		
		<xsl:variable name="documentError" select="dp:variable('var://local/_extension/error')"/>
		<xsl:if test="$documentError">
			<xsl:message terminate="yes"><xsl:value-of select="$documentError"/></xsl:message>
		</xsl:if>
		
		<xsl:variable name="routingURL">
			<xsl:choose>
				<xsl:when test="$routingInfoFile">
					<xsl:call-template name="getRoutingUrl">
						<xsl:with-param name="rtInfoFile" select="$routingInfoFile"/>
						<xsl:with-param name="tConfig" select="$targetConfig"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					
					<xsl:variable name="clientQualFileName" select="concat($filesystemPathApplications,'qualifiers/',$clientQual,'.xml')"/>
					<xsl:variable name="clientQualFile" select="document($clientQualFileName)"/>
					<xsl:variable name="qualifier" select="$clientQualFile/qualifiers/qualifier[@name='$targetConfig/request/endpointConfig/targetSystem']"/>
					
					<xsl:variable name="routingInfoFileName" select="concat($filesystemPathApplications,$targetConfig/request/endpointConfig/targetSystem,'-',$qualifier,'.xml')"/>
					<xsl:variable name="routingInfoFile" select="document($routingInfoFileName)"/>
					<xsl:call-template name="getRoutingUrl">
						<xsl:with-param name="rtInfoFile" select="$routingInfoFile"/>
						<xsl:with-param name="tConfig" select="$targetConfig"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>		
			
		</xsl:variable>
		
 -->
		<xsl:message>			routingURL: 
<xsl:value-of select="$routingURL"/>
		</xsl:message>
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
		<xsl:message>			sslProxyProfile: 
<xsl:value-of select="$sslProxyProfile"/>
		</xsl:message>
		<xsl:if test="$sslProxyProfile">
			<dp:set-variable name="'var://service/routing-url-sslprofile'" value="$sslProxyProfile"/>
		</xsl:if>
		<!--Transformation for json messages-->
		<xsl:choose>
			<xsl:when test="/json:object">
				<dp:set-variable name="'var://context/CT/TransformXSL'" value="'store:///jsonx2json.xsl'"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/CT/TransformXSL'" value="'store:///identity.xsl'"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="dp:local-variable('var://local/PostTransformOut')"/>
	</xsl:template>
	<xsl:template name="getRoutingUrl">
		<xsl:param name="rtInfoFile"/>
		<xsl:param name="tConfig"/>
		<xsl:param name="env"/>
		<xsl:param name="payload"/>
		<xsl:message>			rtInfoFile: 
<xsl:copy-of select="$rtInfoFile"/>
		</xsl:message>
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
			<xsl:when test="$tarConfig/EndpointConfig/uri/@type">
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
				<xsl:value-of select="$tarConfig/EndpointConfig/uri"/>
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