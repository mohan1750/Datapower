<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:amp="http://www.datapower.com/schemas/appliance/management/3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs amp"
    version="2.0">
    <xsl:output media-type="html"/>
    <xsl:template match="/">
        Exclude Objects:<select name="exserv"  multiple="multiple">
        <xsl:for-each select="/amp:GetReferencedObjectsResponse/amp:Objects/amp:Object[position()>1]">
            <xsl:variable name="temp" select="concat(./@name,':',./@class-name,',',./@class-display-name)"/>
            <option><xsl:attribute name="value"><xsl:value-of select="$temp"/></xsl:attribute><xsl:value-of select="substring-before($temp,',')"/></option>
        </xsl:for-each>
        </select><br/>
        Exclude Files:<select name="exfiles"><option value="true">true</option><option value="false">false</option></select>
            </xsl:template>
</xsl:stylesheet>