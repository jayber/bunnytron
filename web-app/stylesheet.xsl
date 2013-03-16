<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- Structure -->
    <xsl:template match="xml">
        <div>
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>

    <xsl:template match="section1">
        <div>
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>

    <xsl:template match="title">
        <h1>
            <xsl:apply-templates select="node()"/>
        </h1>
    </xsl:template>

    <xsl:template match="para">
        <p>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>

</xsl:stylesheet>