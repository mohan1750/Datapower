<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:func="http://exslt.org/functions" extension-element-prefixes="dp func" xmlns:util="http://www.anz.com/utilities" exclude-result-prefixes="dp dpconfig str func regexp util">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<!-- 
		<xsl:variable name="actions" select="dp:variable('var://context/SSI/actions')"/>
		 -->
		<xsl:variable name="sourceConfig" select="dp:variable('var://context/SSI/sourceConfig')"/>
		<xsl:choose>
			<xsl:when test="$sourceConfig">
				<dp:set-local-variable name="'var://local/PreTransformOut'" value="."/>
				<xsl:for-each select="$sourceConfig/actions/action">
					<xsl:choose>
						<!-- Schema validation -->
						<xsl:when test="./@name='SCHEMA-VALIDATE'">
							<xsl:if test="dp:variable('var://context/SSI/Rq/PreTrans/SchemaValidation') = 'true'">
								<xsl:message>Executing Schema Validate action</xsl:message>
								<xsl:variable name="schemaValid">
									<xsl:call-template name="doSchemaValidation">
										<xsl:with-param name="input" select="dp:local-variable('var://local/PreTransformOut')"/>
										<xsl:with-param name="schemaFile" select="."/>
									</xsl:call-template>
								</xsl:variable>
							</xsl:if>
						</xsl:when>
						<xsl:when test="./@name='STRIP-SOAP'">
							<xsl:message>Executing STRIP-SOAP action</xsl:message>
							<!--StripSOAP headers -->
							<xsl:variable name="afterStripSoap">
								<xsl:copy-of select="dp:transform(dp:variable('var://context/SSI/action/StripSoap'),dp:local-variable('var://local/PreTransformOut'))"/>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PreTransformOut'" value="$afterStripSoap"/>
						</xsl:when>
						<xsl:when test="./@type='custom'">
							<xsl:message>Executing custom action:<xsl:value-of select="./@name"/>
							</xsl:message>
							<xsl:variable name="afterCustom">
								<xsl:variable name="customFile" select="document($sourceConfig/request/actions/action[@type='custom'])"/>
								<xsl:choose>
									<xsl:when test="$customFile">
										<xsl:copy-of select="dp:transform($sourceConfig/request/actions/action[@type='custom'],dp:local-variable('var://local/PreTransformOut'))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="yes">The specified custom XSL doesn't exist</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<dp:set-local-variable name="'var://local/PreTransformOut'" value="$afterCustom"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:copy-of select="dp:local-variable('var://local/PreTransformOut')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">sourceConfig doesn't exist</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="doSchemaValidation">
		<xsl:param name="input"/>
		<xsl:param name="schemaFile"/>
		<xsl:choose>
			<xsl:when test="string-length($schemaFile) > 0">
				<xsl:variable name="schema" select="document($schemaFile)"/>
				<xsl:choose>
					<xsl:when test="$schema">
						<xsl:value-of select="dp:schema-validate($schemaFile,$input)"/>
						<xsl:choose>
							<xsl:when test="dp:variable('var://context/PreProcessOut/_extension/error')">
								<dp:set-variable name="'var://context/SSI/error-subcode'" value="'200'"/>
								<dp:set-variable name="'var://context/SSI/error-message'" value="dp:variable('var://context/PreProcessOut/_extension/error')"/>
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
