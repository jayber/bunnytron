<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <xsl:value-of select="$this_string"/>
    </xsl:template>

</xsl:stylesheet>