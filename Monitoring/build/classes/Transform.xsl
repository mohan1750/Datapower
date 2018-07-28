<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:amp="http://www.datapower.com/schemas/appliance/management/3.0">
    <xsl:template match="/">
        <!-- TODO: Auto-generated template -->
        <xsl:element name="Service">
            <xsl:attribute name="name">
                <xsl:value-of select="//amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[1]/@name"/>
            </xsl:attribute>
            <xsl:attribute name="class-name">
                <xsl:value-of select="//amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[1]/@class-name"/>
            </xsl:attribute>
            <xsl:attribute name="class-display-name">
                <xsl:value-of select="//amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[1]/@class-display-name"/>
            </xsl:attribute>
            
            <xsl:apply-templates select="amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[1]/amp:ReferencedObject"/>
            <xsl:element name="Files">
            <xsl:for-each select="//amp:GetReferencedObjectsResponse/amp:Files/amp:File">
            	<xsl:element name="File"><xsl:value-of select="./text()"/></xsl:element>
            </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="amp:ReferencedObject">
        <xsl:element name="ReferenceObject">
            
        <xsl:variable name="names">
            <xsl:value-of select="./@name"/>
        </xsl:variable>	
        <xsl:variable name="class"><xsl:value-of select="@class-name"/></xsl:variable>
            <xsl:attribute name="name"><xsl:value-of select="$names"/></xsl:attribute>
            <xsl:attribute name="class-name"><xsl:value-of select="$class"/></xsl:attribute>
            <xsl:attribute name="class-display-name"><xsl:value-of select="@class-display-name"/></xsl:attribute>
           
            <xsl:choose>
                <xsl:when test="//amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[@name=$names and @class-name=$class]/amp:ReferencedObject">
                    <xsl:apply-templates select="//amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[@name=$names and @class-name=$class]/amp:ReferencedObject"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="Comments">
                    <xsl:copy-of select="//amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[@name=$names and @class-name=$class]/amp:UserComments/text()"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
           
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>