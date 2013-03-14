<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <!-- designed to transform snippets of plcdtd xml (for example on product pages) -->

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

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
