<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="p">&#160;
        <xsl:apply-templates/>
        <xsl:if test="not(following-sibling::p)">&#160;</xsl:if>
    </xsl:template>
    <xsl:template match="br">&#160;</xsl:template>
</xsl:stylesheet>