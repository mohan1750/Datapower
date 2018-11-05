<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:dyn="http://exslt.org/dynamic" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:variable name="serviceName" select="dp:variable('var://service/processor-name')"/>
		<xsl:variable name="environmentManifest" select="document('local:///ondisk/environment/environment.xml')"/>
		<xsl:variable name="envDocumentError" select="dp:variable('var://local/_extension/error')"/>
		<xsl:if test="$envDocumentError">
			<xsl:message terminate="yes">
				<xsl:value-of select="$envDocumentError"/>
			</xsl:message>
		</xsl:if>
		<dp:set-variable name="'var://context/ANZ/LogRule'" value="string($environmentManifest/environment/LogRule)"/>
		<dp:set-variable name="'var://context/SSI/envManifest'" value="$environmentManifest"/>
		<xsl:variable name="ssiConfigurationPath" select="$environmentManifest/environment/common-config-path"/>
		<xsl:variable name="filesystemPathServices" select="$environmentManifest/environment/filesystem-path-services"/>
		<xsl:variable name="sTransformPath" select="$environmentManifest/environment/ssi-s-transform-path"/>
		<xsl:variable name="tTransformPath" select="$environmentManifest/environment/ssi-t-transform-path"/>
		<xsl:variable name="serviceDirectory">
			<xsl:call-template name="getServiceDir">
				<xsl:with-param name="servicesDir" select="$filesystemPathServices"/>
				<xsl:with-param name="serviceName" select="$serviceName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="serviceManifest" select="concat($serviceDirectory,'ServiceMf.xml')"/>
		<xsl:variable name="serviceManifestFile" select="document($serviceManifest)"/>
		<xsl:variable name="smDocumentError" select="dp:variable('var://local/_extension/error')"/>
		<xsl:if test="$smDocumentError">
			<xsl:message terminate="yes">
				<xsl:value-of select="$smDocumentError"/>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="nullTransformTemplate" select="$serviceManifestFile/service/action[@name='NULL-TRANSFORM']"/>
		<xsl:variable name="stripSoapaction" select="$serviceManifestFile/service/action[@name='STRIP-SOAP']"/>
		<xsl:variable name="addSoapaction" select="$serviceManifestFile/service/action[@name='ADD-SOAP']"/>
		<xsl:variable name="httpRqHeaderHandler" select="$serviceManifestFile/service/action[@name='HTTP-RQHEADER-HANDLER']"/>
		<xsl:variable name="httpRsHeaderHandler" select="$serviceManifestFile/service/action[@name='HTTP-RSHEADER-HANDLER']"/>
		<xsl:variable name="mqRqHeaderHandler" select="$serviceManifestFile/service/action[@name='MQ-RQHEADER-HANDLER']"/>
		<xsl:variable name="jmsRqHeaderHandler" select="$serviceManifestFile/service/action[@name='JMS-RQHEADER-HANDLER']"/>
		<xsl:variable name="ssiUriHandler" select="$serviceManifestFile/service/action[@name='SSI-URI-HANDLER']"/>
		<dp:set-variable name="'var://context/SSI/action/StripSoap'" value="string($stripSoapaction)"/>
		<dp:set-variable name="'var://context/SSI/action/AddSoap'" value="string($addSoapaction)"/>
		<dp:set-variable name="'var://context/SSI/action/HttpRqHeaderHandler'" value="string($httpRqHeaderHandler)"/>
		<dp:set-variable name="'var://context/SSI/action/HttpRsHeaderHandler'" value="string($httpRsHeaderHandler)"/>
		<dp:set-variable name="'var://context/SSI/action/MqRqHeaderHandler'" value="string($mqRqHeaderHandler)"/>
		<dp:set-variable name="'var://context/SSI/action/JmsRqHeaderHandler'" value="string($jmsRqHeaderHandler)"/>
		<dp:set-variable name="'var://context/SSI/action/SsiUriHandler'" value="string($ssiUriHandler)"/>
		<dp:set-variable name="'var://context/SSI/ServiceMfFilename'" value="string($serviceManifest)"/>
		<xsl:variable name="Provider" select="dp:http-request-header('Provider')"/>
		<xsl:variable name="uri">
			<xsl:choose>
				<xsl:when test="contains(dp:variable('var://service/URI'),'?')">
					<xsl:value-of select="substring-before(dp:variable('var://service/URI'),'?')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="dp:variable('var://service/URI')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="method" select="normalize-space(dp:variable('var://service/protocol-method'))"/>
		<xsl:message dp:priority="error">
			URI: <xsl:value-of select="$uri"/>
			Provider: <xsl:value-of select="$Provider"/>
		</xsl:message>
		<xsl:variable name="businessEventMf">
			<xsl:call-template name="getbusinessEventMf">
				<xsl:with-param name="ssiConfigPath" select="$ssiConfigurationPath"/>
				<xsl:with-param name="origin" select="$Provider"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="businessEventMfFile" select="document($businessEventMf)"/>
		<xsl:variable name="businessEvent" select="$businessEventMfFile/entries/entry[regexp:test($uri, @match) and @method=$method]"/>
		<dp:set-variable name="'var://context/ANZ/EventManifest'" value="$businessEvent"/>
		<xsl:variable name="beDocumentError" select="dp:variable('var://local/_extension/error')"/>
		<xsl:if test="$beDocumentError">
			<xsl:message terminate="yes">
				<xsl:value-of select="$beDocumentError"/>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="LogRule" select="string($businessEvent/RouterMetadata/LogRule)"/>
		<xsl:if test="$LogRule !=''">
			<dp:set-variable name="'var://context/ANZ/LogRule'" value="$LogRule"/>
			<xsl:message>
                            ************* Splunk Logging *****************
                            <xsl:value-of select="$LogRule"/>
			</xsl:message>
		</xsl:if>
		<!--######################
					This below section sets following context variables
						var://context/SSI/actions
						var://context/SSI/endpointConfig
						var://context/SSI/errorConfig
				 #########################-->
		<!--  
				<dp:set-variable name="'var://context/SSI/actions'" value="$businessEventMfFile/businessEvent/actions" />
				<dp:set-variable name="'var://context/SSI/endpointConfig'" value="$businessEventMfFile/businessEvent/targetConfig/request/endpointConfig" />
				 -->
		<dp:set-variable name="'var://context/SSI/errorConfig'" value="$businessEvent/ServiceMetadata/ErrorConfig"/>
		<xsl:variable name="sourceConfig" select="$businessEvent/ServiceMetadata/SourceConfig"/>
		<xsl:message dp:priority="error">
			SourceConfig: <xsl:value-of select="$sourceConfig"/>
		</xsl:message>
		<dp:set-variable name="'var://context/SSI/sourceConfig'" value="$businessEvent/ServiceMetadata/SourceConfig"/>
		<dp:set-variable name="'var://context/ANZ/operationName'" value="$businessEvent/ServiceMetadata/OperationName"/>
		<xsl:variable name="conditionalRouting" select="$businessEvent/ServiceMetadata/ConditionalRouting"/>
		<xsl:variable name="conditionalRoutingType" select="$businessEvent/ServiceMetadata/Routing/@type"/>
		<xsl:choose>
			<xsl:when test="$conditionalRouting='Y'">
				<xsl:choose>
					<xsl:when test="$conditionalRoutingType = 'XSL'">
						<xsl:variable name="input" select="."/>
						<xsl:for-each select="$businessEvent/ServiceMetadata/TargetConfig">
							<xsl:variable name="filterTransform" select="document(concat($tTransformPath,./filter))"/>
							<xsl:if test="not($filterTransform)">
								<xsl:message terminate="yes">The filter <xsl:value-of select="concat($tTransformPath,./filter)"/> doesn't exist </xsl:message>
							</xsl:if>
							<xsl:variable name="filterOut">
								<xsl:copy-of select="dp:transform(concat($tTransformPath,./filter),$input)"/>
							</xsl:variable>
							<xsl:message>filterOutput: <xsl:copy-of select="$filterOut"/>
							</xsl:message>
							<xsl:if test="$filterOut='true'">
								<dp:set-variable name="'var://context/SSI/targetConfig'" value="."/>
								<xsl:message>Filtered Target Config: <xsl:copy-of select="."/>
								</xsl:message>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$conditionalRoutingType = 'xpath'">
						<xsl:variable name="input" select="."/>
						<xsl:variable name="tempRoute" select="$businessEvent/ServiceMetadata/Routing"/>
						<xsl:variable name="filterExpression" select="dyn:evaluate($tempRoute)"/>
						<xsl:variable name="filterOut">
							<xsl:copy-of select="$businessEvent/ServiceMetadata/TargetConfig[@name = $filterExpression]"/>
						</xsl:variable>
						<dp:set-variable name="'var://context/SSI/targetConfig'" value="$filterOut"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/SSI/targetConfig'" value="$businessEvent/ServiceMetadata/TargetConfig"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="targetConfig" select="dp:variable('var://context/SSI/targetConfig')"/>
		<xsl:variable name="sourcesys" select="dp:http-request-header('ANZ-Application-ID')"/>
		<xsl:variable name="messageID" select="dp:http-request-header('RequestID')"/>
		<dp:set-variable name="'var://context/ANZ/targetsys'" value="$Provider"/>
		<dp:set-variable name="'var://context/ANZ/sourcesys'" value="$sourcesys"/>
		<dp:set-variable name="'var://context/ANZ/MessageID'" value="$messageID"/>
		<!-- #########################-->
		<!--######################
					This below section sets transform context variables
						var://context/SSI/Rq/SCTransform
						var://context/SSI/Rq/CTTransform
						var://context/SSI/Rs/TCTransform
						var://context/SSI/Rs/CSTransform
				 #########################-->
		<xsl:message>
						nullTransformTemplate: <xsl:value-of select="$nullTransformTemplate"/>
		</xsl:message>
		<xsl:variable name="srcToCommonTransform" select="$sourceConfig/SourceConfig/SCTransform"/>
		<xsl:choose>
			<!-- 
					<xsl:when test="$srcToCommonTransform/@type='NULL-TRANSFORM'">
						<dp:set-variable name="'var://context/SSI/Rq/SCTransform'" value="string($nullTransformTemplate)" />
					</xsl:when>
					 -->
			<xsl:when test="string-length($srcToCommonTransform)!=0">
				<dp:set-variable name="'var://context/SSI/Rq/SCTransform'" value="$srcToCommonTransform"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/SSI/Rq/SCTransform'" value="string($nullTransformTemplate)"/>
				<!-- <xsl:message terminate="yes">SC Transform must be specified</xsl:message>  -->
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="commonToTargetTransform" select="$targetConfig/TargetConfig/CTTransform"/>
		<xsl:choose>
			<!-- 
					<xsl:when test="$commonToTargetTransform/@type='NULL-TRANSFORM'">
						<dp:set-variable name="'var://context/SSI/Rq/CTTransform'" value="string($nullTransformTemplate)" />
					</xsl:when>
					 -->
			<xsl:when test="string-length($commonToTargetTransform)!=0">
				<dp:set-variable name="'var://context/SSI/Rq/CTTransform'" value="$commonToTargetTransform"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/SSI/Rq/CTTransform'" value="string($nullTransformTemplate)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="targetToCommonTransform" select="$targetConfig/TargetConfig/TCTransform"/>
		<xsl:choose>
			<!-- 
					<xsl:when test="$targetToCommonTransform/@type='NULL-TRANSFORM'">
						<dp:set-variable name="'var://context/SSI/Rs/TCTransform'" value="string($nullTransformTemplate)" />
					</xsl:when>
				 -->
			<xsl:when test="string-length($targetToCommonTransform)!=0">
				<dp:set-variable name="'var://context/SSI/Rs/TCTransform'" value="$targetToCommonTransform"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/SSI/Rs/TCTransform'" value="string($nullTransformTemplate)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="commonToSrcTransform" select="$sourceConfig/SourceConfig/CSTransform"/>
		<xsl:choose>
			<!-- 
					<xsl:when test="$commonToSrcTransform/@type='NULL-TRANSFORM'">
						<dp:set-variable name="'var://context/SSI/Rs/CSTransform'" value="string($nullTransformTemplate)" />
					</xsl:when>
				 -->
			<xsl:when test="string-length($commonToSrcTransform)!=0">
				<dp:set-variable name="'var://context/SSI/Rs/CSTransform'" value="$commonToSrcTransform"/>
			</xsl:when>
			<xsl:otherwise>
				<dp:set-variable name="'var://context/SSI/Rs/CSTransform'" value="string($nullTransformTemplate)"/>
				<!-- 
						<xsl:message terminate="yes">CS Transform must be specified</xsl:message>
						 -->
			</xsl:otherwise>
		</xsl:choose>
		<!--######################
					This below section sets schemaValidation context variable which specifies whether its enabled or not
						var://context/SSI/Rq/PreTrans/SchemaValidation
						var://context/SSI/Rs/PostTrans/SchemaValidation
						
				 #########################-->
		<xsl:variable name="rqPreTransformSchemaEnabled">
			<SchemaValidate>
				<xsl:call-template name="getSchemaEnabled">
					<xsl:with-param name="type" select="'request'"/>
					<xsl:with-param name="schemaValidateaction" select="$businessEvent/entry/SourceConfig/actions/action[@name='SCHEMA-VALIDATE']"/>
					<xsl:with-param name="envManifest" select="$environmentManifest"/>
				</xsl:call-template>
			</SchemaValidate>
		</xsl:variable>
		<xsl:message>
						rqPreTransformSchemaEnabled: <xsl:value-of select="$rqPreTransformSchemaEnabled"/>
		</xsl:message>
		<xsl:if test="$rqPreTransformSchemaEnabled='true'">
			<dp:set-variable name="'var://context/SSI/Rq/PreTrans/Schema'" value="$businessEvent/entry/SourceConfig/actions/action[@name='SCHEMA-VALIDATE']"/>
			<dp:set-variable name="'var://context/SSI/Rq/PreTrans/SchemaValidation'" value="string($rqPreTransformSchemaEnabled)"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getServiceDir">
		<xsl:param name="servicesDir"/>
		<xsl:param name="serviceName"/>
		<xsl:variable name="service" select="substring($serviceName,1,string-length($serviceName)-2)"/>
		<xsl:variable name="version" select="substring($serviceName,string-length($serviceName)-1)"/>
		<xsl:value-of select="concat($servicesDir,$service,'/',$version,'/')"/>
	</xsl:template>
	<xsl:template name="getbusinessEventMf">
		<xsl:param name="ssiConfigPath"/>
		<xsl:param name="origin"/>
		<xsl:value-of select="concat($ssiConfigPath,$origin,'_','Manifest.xml')"/>
		<xsl:message dp:priority="error">***ManifestPath=<xsl:value-of select="concat($ssiConfigPath,$origin,'_','Manifest.xml')"/>
		</xsl:message>
	</xsl:template>
	<xsl:template name="getSchemaEnabled">
		<xsl:param name="type"/>
		<xsl:param name="schemaValidateaction"/>
		<xsl:param name="envManifest"/>
		<xsl:message>
			type: <xsl:copy-of select="$type"/>
			schemaValidateaction: <xsl:copy-of select="$schemaValidateaction"/>
			envManifest: <xsl:copy-of select="$envManifest"/>
		</xsl:message>
		<xsl:choose>
			<xsl:when test="$schemaValidateaction/@enabled='true'">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:when test="$schemaValidateaction/@enabled='false'">
				<xsl:value-of select="'false'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$envManifest/environment/schema-validate[@type=$type]/@enabled"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>