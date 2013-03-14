<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <!-- US/ISSUE -->

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../plcdtd/plcdtd2html.xsl"/>

    <!-- fatwire parameters -->
    <xsl:param name="pagename"/>
    <xsl:param name="childPageName"/>
    <xsl:param name="contentType"/>
    <xsl:param name="contentId"/>
    <xsl:param name="fwAction"/>
    <xsl:param name="view"/>

    <!-- user preferences -->
    <xsl:param name="abstractDisplay" select="'inline'"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!--<xsl:template match="plcxlink">
        <xsl:variable name="locator" select="xlink:locator"/>
        <xsl:variable name="url">?pagename=PLCWrapper&amp;childpagename=PLC/PageLayout&amp;c=PLC_Doc_C&amp;cid=<xsl:value-of select="$locator/@xlink:href"/></xsl:variable>
        <a href="{$url}"><xsl:value-of select="$locator"/></a>
        </xsl:template>-->

</xsl:stylesheet>