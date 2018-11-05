<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions">

<xsl:template match="/">

<xsl:message><dp:http-response-header name="Content-Type"/><xsl:value-of select="."/></xsl:message>


<xsl:variable name="ContentTypeXML">
          <ResponseContent>
          <ContentType><xsl:value-of select="dp:http-response-header('Content-Type')"/></ContentType>
          </ResponseContent>
         </xsl:variable>

<dp:set-variable name="'var://service/protocol-method'" value="'POST'"/>
 
       <xsl:copy-of select="$ContentTypeXML"/>

</xsl:template>

</xsl:stylesheet>