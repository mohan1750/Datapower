<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<!-- 
		<xsl:variable name="actions" select="dp:variable('var://context/SSI/actions')"/>
		 -->
		<xsl:variable name="sourceConfig" select="dp:variable('var://context/SSI/sourceConfig')"/>
		<xsl:choose>
			<xsl:when test="$sourceConfig">
				<dp:set-local-variable name="'var://local/PostTransformOut'" value="."/>
				<xsl:for-each select="$sourceConfig/actions/action">
					<xsl:choose>
						<xsl:when test="./@name='HTTP-RSHEADER-HANDLER'">
							<!-- header handling -->
							<xsl:message>Executing Http Rs header handler</xsl:message>
							<xsl:value-of select="dp:transform(dp:variable('var://context/SSI/action/HttpRsHeaderHandler'),dp:local-variable('var://local/PostTransformOut'))"/>
						</xsl:when>
						<xsl:when test="./@name='ADD-SOAP'">
							<xsl:message>Executing Add Soap action</xsl:message>
							<!--StripSOAP headers -->
							<xsl:variable name="afterAddSoap">
								<xsl:copy-of select="dp:transform(dp:variable('var://context/SSI/action/AddSoap'),dp:local-variable('var://local/PostTransformOut'))"/>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PostTransformOut'" value="$afterAddSoap"/>
						</xsl:when>
						<xsl:when test="./@type='custom'">
							<xsl:variable name="afterCustom">
								<xsl:variable name="customFile" select="document($sourceConfig/response/actions/action[@type='custom'])"/>
								<xsl:choose>
									<xsl:when test="$customFile">
										<xsl:copy-of select="dp:transform($sourceConfig/response/actions/action[@type='custom'],dp:local-variable('var://local/PostTransformOut'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="yes">The specified custom XSL doesn't exist</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PostTransformOut'" value="$afterCustom"/>
						</xsl:when>
						<xsl:when test="./@name='SCHEMA-VALIDATE'">
							<!-- Schema validation -->
							<xsl:if test="dp:variable('var://context/SSI/Rs/PostTrans/SchemaValidation') = 'true'">
								<xsl:message>Executing Schema Validate action</xsl:message>
								<xsl:call-template name="doSchemaValidation">
									<xsl:with-param name="input" select="dp:local-variable('var://local/PostTransformOut')"/>
									<xsl:with-param name="schemaFile" select="."/>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>sourceConfig doesn't exist</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="dp:local-variable('var://local/PostTransformOut')"/>
	</xsl:template>
	<xsl:template name="doSchemaValidation">
		<xsl:param name="input"/>
		<xsl:param name="schemaFile"/>
		<xsl:choose>
			<xsl:when test="string-length($schemaFile) > 0">
				<xsl:choose>
					<xsl:when test="$schema">
						<xsl:copy-of select="dp:schema-validate($schemaFile,$input)"/>
						<xsl:choose>
							<xsl:when test="dp:variable('var://context/PostProcessOut/_extension/error')">
								<dp:set-variable name="'var://context/SSI/error-subcode'" value="'200'"/>
								<dp:set-variable name="'var://context/SSI/error-message'" value="dp:variable('var://context/PostProcessOut/_extension/error')"/>
								<xsl:message terminate="yes">Schema validation failed</xsl:message>
							</xsl:when>
							<xsl:otherwise>
								<xsl:message>Schema validation is successful</xsl:message>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">Specified Schema not found</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">Schema is required</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
