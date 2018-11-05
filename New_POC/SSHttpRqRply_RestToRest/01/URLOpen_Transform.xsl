<xsl:stylesheet version="1.0" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:json="http://www.ibm.com/xmlns/prod/2009/jsonx">
   <xsl:template match="/">
      <xsl:variable name="TC_xsl" select="dp:variable('var://context/SSI/Rs/TCTransform')"/>
      <xsl:variable name="CS_xsl" select="dp:variable('var://context/SSI/Rs/CSTransform')"/>
      <xsl:variable name="TC_Stylesheet">
	 <xsl:if test="not(contains($TC_xsl,'copyTemplate.xsl'))">
	    <xsl:value-of select="$TC_xsl"/>
	</xsl:if>
	</xsl:variable>
	<xsl:variable name="CS_Stylesheet">
	<xsl:if test="not(contains($CS_xsl,'copyTemplate.xsl'))">
	  <xsl:value-of select="$CS_xsl"/>
	</xsl:if>
	</xsl:variable>
     
    <xsl:variable name="TC_Res">
       <xsl:choose>
          <xsl:when test="$TC_Stylesheet != ''">
             <xsl:copy-of select="dp:transform($TC_Stylesheet,$Route)"/>
          </xsl:when>
         <xsl:otherwise>
           <xsl:message>Inside the Transform TC Res: <xsl:value-of select="$Route"/></xsl:message>
           <xsl:copy-of select="."/>
         </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="CS_Res">
     <xsl:choose>
        <xsl:when test="$CS_Stylesheet != ''">
          <xsl:copy-of select="dp:transform($CS_Stylesheet,$TC_Res)"/>
        </xsl:when>
         <xsl:otherwise>
            <xsl:message>Inside the Delete Post Transform CS Res: <xsl:value-of select="$TC_Res"/></xsl:message>
            <xsl:copy-of select="$TC_Res"/>
         </xsl:otherwise>
       </xsl:choose>
    </xsl:variable>

    <xsl:variable name="PT_Stylesheet" select="'local:/ondisk/services/SSHttpRqRply_RestToRest/01/SSI_ResPostTransform_Json.xsl'"/>
    <xsl:variable name="PostTransform_Res" select="dp:transform($PT_Stylesheet,$CS_Res )"/>

      <xsl:choose>
        <xsl:when test="json:object">
          <xsl:copy-of select="dp:transform('store:///jsonx2json.xsl',$PostTransform_Res)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$PostTransform_Res"/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>
</xsl:stylesheet>