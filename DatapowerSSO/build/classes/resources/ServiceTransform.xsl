<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<xsl:element name="entries">
			<xsl:apply-templates select="/entries/array"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="array">
		<xsl:element name="entry">
			<xsl:attribute name="match"><xsl:value-of select="./match"/></xsl:attribute>
			<xsl:attribute name="method"><xsl:value-of select="./method"/></xsl:attribute>
			<xsl:element name="ServiceMetadata">
				<xsl:element name="OperationName">
					<xsl:value-of select="./ServiceMetadata/OperationName"/>
				</xsl:element>
				<xsl:element name="ConditionalRouting">
					<xsl:value-of select="./ServiceMetadata/ConditionalRouting"/>
				</xsl:element>
				<xsl:element name="Routing">
					<xsl:attribute name="type"><xsl:value-of select="./ServiceMetadata/Routing/type"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="ServiceTransformation">
					<xsl:value-of select="./ServiceMetadata/ServiceTransformation"/>
				</xsl:element>
				<xsl:copy-of select="./ServiceMetadata/SourceConfig"/>
				<xsl:element name="TargetConfig">
					<xsl:attribute name="name">
						<xsl:value-of select="./ServiceMetadata/TargetConfig/name"/>
					</xsl:attribute>
					<xsl:copy-of select="./ServiceMetadata/TargetConfig/node()[local-name() != 'name']"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="RouterMetadata">
				<xsl:element name="Authorize">
					<xsl:attribute name="enabled"><xsl:value-of select="./RouterMetadata/Authorize/enabled"></xsl:value-of></xsl:attribute>
					<xsl:for-each select="./RouterMetadata/Authorize/attribute-value">
						<xsl:element name="attribute-value">
							<xsl:attribute name="name"><xsl:value-of select="./name"/></xsl:attribute>
							<xsl:value-of select="./text()"/>
						</xsl:element>
					
					</xsl:for-each>
				</xsl:element>
				<xsl:element name="LogRule">
					<xsl:value-of select="./RouterMetadata/LogRule"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
