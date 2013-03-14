<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <!-- UK/PRODUCT -->

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../plcdtd/plcdtd2html.xsl"/>

    <!-- fatwire parameters -->
    <xsl:param name="pagename"/>
    <xsl:param name="childPageName"/>
    <xsl:param name="contentType"/>
    <xsl:param name="contentId"/>
    <xsl:param name="fwAction"/>
    <xsl:param name="view"/>

    <xsl:strip-space elements="*"/>

    <xsl:variable name="resource-root" select="resource"/>
    <xsl:variable name="plcReference" select="$resource-root/plcReference"/>

    <xsl:template match="/">
        <xsl:apply-templates select="resource/xml"/>
    </xsl:template>

    <xsl:template match="resource/xml">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
