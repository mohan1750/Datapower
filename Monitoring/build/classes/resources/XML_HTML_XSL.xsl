<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output media-type="html"/>
    <xsl:template match="/">
        <ul>
            <li><span class="ele"><xsl:value-of select="concat(/Service/@name,':',Service/@class-name)"/></span>
                <xsl:apply-templates select="Service/ReferenceObject"/>
                <ul>
                <li><span class="ele"><xsl:value-of select="'Files'"/></span><ul>
                    <xsl:for-each select="Service/Files/File">
                        <li><span class="ele">File:<xsl:value-of select="."/></span></li>
                    </xsl:for-each></ul></li>
                </ul>
            </li>
            
        </ul>
        
    </xsl:template>
    <xsl:template match="ReferenceObject">
        <ul>
            <li><span class="ele"><xsl:value-of select="concat(./@name,':',./@class-name)"/></span>
                <xsl:if test="./ReferenceObject">
                    <xsl:apply-templates select="./ReferenceObject"/>
                </xsl:if>
            </li>
        </ul>
    </xsl:template>
</xsl:stylesheet>