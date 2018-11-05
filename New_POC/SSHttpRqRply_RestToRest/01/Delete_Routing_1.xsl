<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:dpconfig="http://www.datapower.com/param/config" xmlns:str="http://exslt.org/strings" xmlns:util="http://www.anz.com/utilities" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fn="http://www.w3.org/2005/xpath-functions" extension-element-prefixes="dp" exclude-result-prefixes="dp dpconfig str soapenv fn">
	<xsl:template match="/">
		
                <dp:set-variable name="'var://service/mpgw/skip-backside'" value="'1'"/>
		<xsl:variable name="routingURL" select="dp:variable('var://context/Delete/routing-url')"/>
		<xsl:variable name="timeout" select="normalize-space(dp:variable('var://service/mpgw/backend-timeout'))"/>
		<xsl:variable name="sslProxyProfile" select="dp:variable('var://context/Delete/sslProxyProfile')"/>
		<xsl:variable name="input" select="normalize-space(.)"/>
                <xsl:variable name="headerManifest" select="dp:variable('var://service/header-manifest')"/>

                   
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
			<dp:url-open target="{$routingURL}" response="responsecode-binary" ssl-proxy="{$sslProxyProfile}" http-headers="$headerValues"  timeout="{$timeout}" http-method="delete">
				<xsl:copy-of select="$input"/>
			</dp:url-open>
		</xsl:variable>

           <xsl:for-each select="$Route/result/headers/header">
           <xsl:variable name="headerValue"><xsl:value-of select="."/></xsl:variable>
           <dp:set-http-response-header name="./@name" value="$headerValue"/> 
           </xsl:for-each>
           
          <xsl:variable name="DeleteResp">
          <xsl:value-of select="dp:decode(dp:binary-encode($Route/result/binary/node()),'base-64')"/>
          </xsl:variable>
        
        
          <xsl:value-of select="$DeleteResp" disable-output-escaping="yes"/>
        
  </xsl:template>
</xsl:stylesheet>