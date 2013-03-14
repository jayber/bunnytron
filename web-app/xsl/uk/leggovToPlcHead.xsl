<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html"/>

    <xsl:variable name="presentation.path" select="'/presentation/leggov'"/>


    <xsl:template match="node()|@*"/>


    <xsl:template match="html">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- take out html head -->

    <xsl:template match="head">
        <leggovHead>
            <wrapper>
                <xsl:apply-templates/>
            </wrapper>
        </leggovHead>
    </xsl:template>

    <!-- CB this needs to be rewritten in tb2 change so that we take all leggov css and scripts-->
    <xsl:template match="style[@type='text/css']">
        <xsl:if test="contains (preceding-sibling::script[1]/@src,'tabs.js')">
            <script type="text/javascript" src="/presentation/leggov/scripts/view/tabs.js"/>
        </xsl:if>
        <style type="text/css">
            <xsl:apply-templates/>
        </style>
        <xsl:if test="contains (following-sibling::link[1]/@href,'explanatoryNotesInterweave')">
            <script type="text/javascript" src="/presentation/leggov/scripts/eniw/eniw_leg.gov.uk.js"/>
            <link rel="stylesheet" href="/presentation/leggov/styles/explanatoryNotesInterweave.css" type="text/css"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="text()[parent::style]">
        <xsl:call-template name="changetextpath">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="changetextpath">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="contains ($this_string,'/styles')">
                <xsl:call-template name="changetextpath">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'/styles')"/>
                </xsl:call-template>
                <xsl:value-of select="$presentation.path"/><xsl:text disable-output-escaping="yes">/styles</xsl:text>
                <xsl:call-template name="changetextpath">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'/styles')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string,'@import')">
                <xsl:call-template name="changetextpath">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'@import')"/>
                </xsl:call-template>
                <xsl:text disable-output-escaping="yes">&#13;&#10;@import</xsl:text>
                <xsl:call-template name="changetextpath">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'@import')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
