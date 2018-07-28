<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output media-type="html"/>
    <xsl:param name="files"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Services In Domain</title>
                <script type="text/javascript" src="script.js"></script>
                <link type="text/css" href="./stylesheet.css" rel="stylesheet" media="all" />
            </head>
            <body>
                <ul>
                    <li><span class="ele"><xsl:value-of select="concat(/Service/@name,':',Service/@class-name)"/></span>
                    <ul>
                        <xsl:for-each select="Service/ReferenceObject">
                            <li><span class="ele"><xsl:value-of select="concat(./@name,':',./@class-name)"/></span>
                                <xsl:if test="./ReferenceObject"><ul>
                            <xsl:for-each select="./ReferenceObject">
                                <li><span class="ele"><xsl:value-of select="concat(./@name,':',./@class-name)"/></span>
                                 
                                    <xsl:if test="./ReferenceObject"><ul>
                                     <xsl:for-each select="./ReferenceObject">
                                         <li><span class="ele"><xsl:value-of select="concat(./@name,':',./@class-name)"/></span></li>
                                     </xsl:for-each></ul>
                                     </xsl:if>
                                    
                                    
                                </li>
                            </xsl:for-each>
                                </ul>
                                </xsl:if>
                            
                            </li>
                    </xsl:for-each>
                    <xsl:for-each select="Service/Files/File">
                        <li><span class="ele">File:<xsl:value-of select="."/></span></li>
                    </xsl:for-each>
                    </ul>
                    </li>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>