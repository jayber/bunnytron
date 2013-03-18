<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:template match="speedread">
        <div>
            <i>
                <small>
                    <xsl:apply-templates select="*"/>
                </small>
            </i>
        </div>
    </xsl:template>

    <!-- Render lists -->

    <xsl:template match="itemizedlist">
        <ul>
            <xsl:apply-templates select="listitem"/>
        </ul>
    </xsl:template>

    <xsl:template match="orderedlist">
        <ol>
            <xsl:apply-templates select="listitem"/>
        </ol>
    </xsl:template>

    <xsl:template match="listitem">
        <li>
            <xsl:apply-templates select="node()"/>
        </li>
    </xsl:template>

    <!-- Render block level elements -->

    <xsl:template match="para">
        <p>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>

    <xsl:template match="title">
        <h2>
            <xsl:apply-templates select="node()"/>
        </h2>
    </xsl:template>

    <!-- Render inline elements -->

    <xsl:template match="emphasis[@role='bold']">
        <b>
            <xsl:apply-templates select="node()"/>
        </b>
    </xsl:template>

    <xsl:template match="emphasis[@role='italic']">
        <i>
            <xsl:apply-templates select="node()"/>
        </i>
    </xsl:template>

    <xsl:template match="emphasis[@role='underline']">
        <u>
            <xsl:apply-templates select="node()"/>
        </u>
    </xsl:template>


    <xsl:template match="bold">
        <b>
            <xsl:apply-templates select="node()"/>
        </b>
    </xsl:template>

    <xsl:template match="italics">
        <i>
            <xsl:apply-templates select="node()"/>
        </i>
    </xsl:template>

    <xsl:template match="undeline">
        <u>
            <xsl:apply-templates select="node()"/>
        </u>
    </xsl:template>

    <xsl:template match="link">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </a>
    </xsl:template>

    <!-- Copy attributes by default -->
    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
