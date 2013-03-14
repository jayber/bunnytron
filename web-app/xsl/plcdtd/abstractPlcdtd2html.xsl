<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <!-- xsls in shared folder require addition variables defined in other xsls. -->

    <xsl:import href="variables-short.xsl"/>
    <xsl:import href="sharedPlcdtd2html.xsl"/>
    <xsl:import href="convert-chars.xsl"/>
    <xsl:import href="numbering.xsl"/>
    <xsl:import href="execution.xsl"/>
    <xsl:import href="plcfPrecxhtml.xsl"/>


    <!-- Avoids the 'top' named anchor in sharedPlcdtd2html.xsl -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>

