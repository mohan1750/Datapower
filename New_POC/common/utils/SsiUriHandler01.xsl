<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:dyn="http://exslt.org/dynamic" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str">
	<!-- 
	Author	      : Senthil Murugesan
	Date	      : 26-Jul-2013
	Version       : 0.1
	Description   : This style sheet builds and returns the URIs as specified in the endpoint config
		Required Variable:  var://context/SSI/targetConfig
		
		Note: This URI handler is not used in SSHttpRqRplyXmlToXml01 but this implementation is added to meet the standard implementation
	-->
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:message>IN SsiUriHandler</xsl:message>
		<xsl:variable name="targetConfig" select="dp:variable('var://context/SSI/targetConfig')"/>
		<xsl:variable name="CanonicalRq">
			<xsl:copy-of select="dp:variable('var://context/SC-RqOut/_roottree')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$targetConfig">
				<xsl:variable name="uriType" select="$targetConfig/EndpointConfig/uri/@type"/>
				<xsl:message>uriType=<xsl:value-of select="$uriType"/>
				</xsl:message>
				<xsl:choose>
					<xsl:when test="$uriType='copy'">
					
					</xsl:when>
					<xsl:when test="$uriType='partialCopy'"/>
					<xsl:when test="$uriType='set'">
						<xsl:value-of select="$targetConfig/EndpointConfig/uri"/>
					</xsl:when>
					<xsl:when test="$uriType = 'uri-in'">
						<xsl:value-of select="dp:variable('var://service/URI')"/>
					</xsl:when>
					<xsl:when test="$uriType ='blank'">
						<xsl:value-of select="''"/>
					</xsl:when>
					<xsl:when test="$uriType='dyn'">
						<xsl:variable name="finalURI">
							<xsl:for-each select="$targetConfig/EndpointConfig/uri-pattern/*">
								<xsl:choose>
									<xsl:when test="name() = 'static'">
										<xsl:variable name="staticURI" select="."/>
										<xsl:value-of select="$staticURI"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="tempDynURI" select="string(.)"/>
										<xsl:variable name="dynURI">
											<xsl:value-of select="dyn:evaluate(concat('$CanonicalRq/',$tempDynURI))"/>
										</xsl:variable>
										<xsl:value-of select="$dynURI"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="$finalURI"/>
					</xsl:when>
					<xsl:when test="$uriType='dynXSL'">
						<xsl:variable name="uriPayload">
							<uriPayload>
								<uri>
									<xsl:value-of select="dp:variable('var://service/URI')"/>
								</uri>
							</uriPayload>
						</xsl:variable>
						<xsl:variable name="dynXSL">
							<xsl:value-of select="$targetConfig/EndpointConfig/uri/node()"/>
						</xsl:variable>
				<xsl:message>uriTypetxfrm=<xsl:copy-of select="dp:transform($dynXSL,$uriPayload)"/>
				</xsl:message>
						<xsl:value-of select="dp:transform($dynXSL,$uriPayload)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$targetConfig/EndpointConfig/uri"/>
                                                <xsl:message dp:priority="error">uriType=<xsl:value-of select="$targetConfig/EndpointConfig/uri"/>
				</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>