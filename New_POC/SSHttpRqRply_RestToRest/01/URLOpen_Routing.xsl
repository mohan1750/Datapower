<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:util="http://www.anz.com/utilities" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fn="http://www.w3.org/2005/xpath-functions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str soapenv fn">
	<xsl:template match="/">
		
                <dp:set-variable name="'var://service/mpgw/skip-backside'" value="'1'"/>
		<xsl:variable name="routingURL" select="dp:variable('var://service/routing-url')"/>
		<xsl:variable name="timeout" select="normalize-space(dp:variable('var://service/mpgw/backend-timeout'))"/>
		<xsl:variable name="sslProxyProfile" select="dp:variable('var://service/routing-url-sslprofile')"/>
		
                <xsl:variable name="headerManifest" select="dp:variable('var://service/header-manifest')"/>
                <xsl:variable name="http_method" select="normalize-space(dp:variable('var://service/protocol-method'))"/>

<!--
<xsl:variable name="input" select="normalize-space(.)"/>
    -->         
              <xsl:variable name="input">
               <xsl:choose>
               <xsl:when test="string-length(normalize-space(dp:variable('var://context/CT/TransformXSL')))!=0">
                 <xsl:copy-of select="dp:transform(dp:variable('var://context/CT/TransformXSL'),.)"/>
               </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
           </xsl:variable>





               <xsl:message>The HTTP method used in the URL-open <xsl:value-of select="$http_method"/></xsl:message>




                   
                <xsl:variable name="headerValues">
                <xsl:for-each select="$headerManifest/headers/header">
                 <xsl:variable name="headerName"><xsl:value-of select="."/></xsl:variable> 
                  <header>
                   <xsl:attribute name="name">
                     <xsl:value-of select="$headerName"/></xsl:attribute>
                   <xsl:value-of select="dp:request-header($headerName)"/>
                  </header>
                </xsl:for-each>
                </xsl:variable>             
               

		<xsl:variable name="Route">
			<dp:url-open target="{$routingURL}" response="responsecode-binary" ssl-proxy="{$sslProxyProfile}" http-headers="$headerValues"  timeout="{$timeout}" http-method="{$http_method}">
				<xsl:copy-of select="$input"/>
			</dp:url-open>
		</xsl:variable>

<xsl:variable name="HTTP_Resp_code" select="string($Route/result/responsecode)"/>
<xsl:variable name="HTTP_Resp_Phrase" select="string($Route/reasonphrase)"/>

<xsl:message>The ResponseCode: <xsl:value-of select="$HTTP_Resp_code"/></xsl:message>
<dp:set-http-response-header name="'x-dp-response-code'" value="$Route/result/responsecode"/>


           <xsl:for-each select="$Route/result/headers/header">
           <xsl:variable name="headerValue"><xsl:value-of select="."/></xsl:variable>
           <dp:set-http-response-header name="./@name" value="$headerValue"/> 
           </xsl:for-each>

        <xsl:if test="string-length(normalize-space($Route/result/errorstring))!=0">
         <xsl:message>Exception occurred during URL Open:<xsl:value-of select="$Route/result/errorstring"/></xsl:message>
         <xsl:message terminate="yes"><xsl:value-of select="$Route/result/errorstring"/></xsl:message>
        </xsl:if>


           
          <xsl:variable name="URLOpenResp">
          <xsl:value-of select="dp:decode(dp:binary-encode($Route/result/binary/node()),'base-64')"/>
          </xsl:variable>
        
        
          <xsl:value-of select="$URLOpenResp" disable-output-escaping="yes"/>
        
  </xsl:template>
</xsl:stylesheet>