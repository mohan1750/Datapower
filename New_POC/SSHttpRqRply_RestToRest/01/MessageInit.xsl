<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:util="http://www.anz.com/utilities" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fn="http://www.w3.org/2005/xpath-functions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str soapenv fn">

	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:variable name="environmentManifest" select="document('local:///ondisk/environment/environment.xml')"/>
		<xsl:variable name="filesystemPath" select="$environmentManifest/environment/filesystem-path"/>
		<xsl:variable name="filesystemPathServices" select="$environmentManifest/environment/filesystem-path-services"/>
		<xsl:variable name="ssiConfigPath" select="$environmentManifest/environment/ssi-configuration-path"/>
		<xsl:message>ssiConfigPath:<xsl:value-of select="$ssiConfigPath"/>
		</xsl:message>
		<xsl:choose>
			<!-- When incoming message is a SOAP message -->
			<xsl:when test="soapenv:Envelope">
				<xsl:variable name="standardHeader" select="soapenv:Envelope/soapenv:Body/*/messageHeader"/>
				<xsl:choose>
					<!-- When Standard Header exists -->
					<xsl:when test="$standardHeader">
						<xsl:message>Standard Message Header exists inside SOAP Body</xsl:message>
						<xsl:variable name="messageIdentifierFile" select="concat($ssiConfigPath,'defaultMessageIdentifier.xsl')"/>
						<xsl:variable name="messageIdetifier" select="document($messageIdentifierFile)"/>
						<xsl:if test="not($messageIdetifier)">
							<xsl:message terminate="yes"> Either Service URI is not supported or messageIdendifier '<xsl:value-of select="$messageIdentifierFile"/>' doesn't exist </xsl:message>
						</xsl:if>
						<xsl:message>messageIdentifierFile: <xsl:value-of select="$messageIdentifierFile"/>
						</xsl:message>
						<dp:set-variable name="'var://context/SSI/MessageIdentifier'" value="string($messageIdentifierFile)"/>
						<xsl:variable name="serviceURI">
							<xsl:call-template name="getServiceURI"/>
						</xsl:variable>
						<xsl:message>serviceURI= <xsl:value-of select="$serviceURI"/>
						</xsl:message>
						<xsl:variable name="tokens" select="str:tokenize($serviceURI,'/')"/>
						<xsl:message>tokens: <xsl:copy-of select="$tokens"/>
						</xsl:message>
						<xsl:variable name="sourceSystem" select="$tokens[1]"/>
						<dp:set-variable name="'var://context/SSI/ClientQual'" value="string($sourceSystem)"/>
					</xsl:when>
					<!-- When Standard Header doesn't exists -->
					<xsl:otherwise>
						<!-- 
							Using URI to determine the message identifier.
							Query Parameters are not considered.
						 -->
						<xsl:message>Standard Message Header doesn't exists inside SOAP Body</xsl:message>
						<xsl:variable name="messageIdentifierFile">
							<xsl:call-template name="getMessageIdentifier">
								<xsl:with-param name="configurationPath" select="$ssiConfigPath"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="messageIdetifier" select="document($messageIdentifierFile)"/>
						<xsl:if test="not($messageIdetifier)">
							<xsl:message terminate="yes"> Either Service URI is not supported or messageIdendifier '<xsl:value-of select="$messageIdentifierFile"/>' doesn't exist </xsl:message>
						</xsl:if>
						<xsl:message>messageIdentifierFile: <xsl:value-of select="$messageIdentifierFile"/>
						</xsl:message>
						<dp:set-variable name="'var://context/SSI/MessageIdentifier'" value="string($messageIdentifierFile)"/>
						<dp:set-variable name="'var://context/SSI/StdMsgHdr'" value="'N'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- When incoming message is NOT a SOAP message -->
			<xsl:otherwise>
				<xsl:variable name="standardHeader" select="/*/messageHeader"/>
				<xsl:choose>
					<!-- When Standard Header exists -->
					<xsl:when test="$standardHeader">
						<xsl:message>Standard Message Header exists inside message root element</xsl:message>
						<xsl:variable name="messageIdentifierFile" select="concat($ssiConfigPath,'defaultMessageIdentifier.xsl')"/>
						<xsl:variable name="messageIdetifier" select="document($messageIdentifierFile)"/>
						<xsl:if test="not($messageIdetifier)">
							<xsl:message terminate="yes"> Either Service URI is not supported or messageIdendifier '<xsl:value-of select="$messageIdentifierFile"/>' doesn't exist </xsl:message>
						</xsl:if>
						<xsl:message>messageIdentifierFile: <xsl:value-of select="$messageIdentifierFile"/>
						</xsl:message>
						<dp:set-variable name="'var://context/SSI/MessageIdentifier'" value="string($messageIdentifierFile)"/>
						<xsl:variable name="serviceURI">
							<xsl:call-template name="getServiceURI"/>
						</xsl:variable>
						<xsl:message>serviceURI= <xsl:value-of select="$serviceURI"/>
						</xsl:message>
						<xsl:variable name="tokens" select="str:tokenize($serviceURI,'/')"/>
						<xsl:message>tokens: <xsl:copy-of select="$tokens"/>
						</xsl:message>
						<xsl:variable name="sourceSystem" select="$tokens[1]"/>
						<dp:set-variable name="'var://context/SSI/ClientQual'" value="string($sourceSystem)"/>
					</xsl:when>
					<!-- When Standard Header doesn't exists -->
					<xsl:otherwise>
						<!-- 
							Using URI to determine the message identifier.
							Query Parameters are not considered.
						 -->
						<xsl:message>Standard Message Header doesn't exists inside message root element</xsl:message>
						<xsl:variable name="messageIdentifierFile">
							<xsl:call-template name="getMessageIdentifier">
								<xsl:with-param name="configurationPath" select="$ssiConfigPath"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:message>messageIdentifierFile: <xsl:value-of select="$messageIdentifierFile"/>
						</xsl:message>
						<xsl:variable name="messageIdetifier" select="document($messageIdentifierFile)"/>
						<xsl:if test="not($messageIdetifier)">
							<xsl:message terminate="yes"> Either Service URI is not supported or messageIdendifier '<xsl:value-of select="$messageIdentifierFile"/>' doesn't exist </xsl:message>
						</xsl:if>
						<dp:set-variable name="'var://context/SSI/MessageIdentifier'" value="string($messageIdentifierFile)"/>
						<dp:set-variable name="'var://context/SSI/StdMsgHdr'" value="'N'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getMessageIdentifier">
		<xsl:param name="configurationPath"/>
		<xsl:variable name="resourceName" select="dp:http-request-header('resourceName')"/>
		<xsl:variable name="ReqMethod" select="dp:http-request-method()"/>
		<xsl:variable name="businessEventDir">
			<xsl:call-template name="getBusinessEventDir">
				<xsl:with-param name="configPath" select="$configurationPath"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($businessEventDir,$ReqMethod,'/','MessageIdentifier.xsl')"/>
	</xsl:template>
	<xsl:template name="getBusinessEventDir">
		<xsl:param name="configPath"/>
		<xsl:variable name="serviceURI">
			<xsl:call-template name="getServiceURI"/>
		</xsl:variable>
		<xsl:variable name="tokens" select="str:tokenize($serviceURI,'/')"/>
		<xsl:message>tokens: <xsl:copy-of select="$tokens"/>
		</xsl:message>
		<xsl:choose>
			<xsl:when test="$resourceName">
			<!--Identifing the MessageIdentifier.xsl from resourceName Header-->
				<xsl:value-of select="concat($configPath,$ReqMethod,'/',$resourceName,'/')"/>
				<dp:set-variable name="'var://context/SSI/resourceName'" value="$resourceName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="count($tokens) &gt; 3 or count($tokens) = 3 ">
						<xsl:variable name="sourceSystem" select="$tokens[1]"/>
						<dp:set-variable name="'var://context/SSI/ClientQual'" value="string($sourceSystem)"/>
						<xsl:variable name="serviceName" select="$tokens[2]"/>
						<xsl:variable name="serviceVersion" select="$tokens[3]"/>
						<xsl:choose>
							<xsl:when test="contains($sourceSystem,'-')">
								<xsl:variable name="sourceSys" select="substring-before($sourceSystem,'-')"/>
								<xsl:value-of select="concat($configPath,$sourceSys,'/',$serviceName,'_',$serviceVersion,'/')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($configPath,$sourceSystem,'/',$serviceName,'_',$serviceVersion,'/')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="sourceSystem" select="$tokens[1]"/>
						<dp:set-variable name="'var://context/SSI/ClientQual'" value="string($sourceSystem)"/>
						<dp:set-local-variable name="'filePath'" value="$configPath"/>
						<xsl:message>**filePath=<xsl:value-of select="dp:local-variable('filePath')"/>
						</xsl:message>
						<xsl:for-each select="$tokens">
							<xsl:variable name="currentPath" select="concat(dp:local-variable('filePath'),current())"/>
							<xsl:message>**curentPath=<xsl:value-of select="$currentPath"/>
							</xsl:message>
							<dp:set-local-variable name="'filePath'" value="concat($currentPath,'/')"/>
						</xsl:for-each>
						<xsl:value-of select="concat(dp:local-variable('filePath'),'/')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<!--
		getServiceURI template returns the service URI without forward slash '/' at the end. 
	 -->
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