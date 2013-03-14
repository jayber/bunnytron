<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:db="http://docbook.org/ns/docbook"
                xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:atict="http://www.arbortext.com/namespace/atict" exclude-result-prefixes="xlink atict mml db">
    <xsl:import href="../common/docbook.xsl"/>

    <!-- obliviate the links from google view -->
    <xsl:template match="db:link">
        <xsl:apply-templates select="text()"/>
    </xsl:template>

</xsl:stylesheet>