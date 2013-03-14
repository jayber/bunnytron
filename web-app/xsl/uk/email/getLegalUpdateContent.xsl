<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:import href="formatting-rules.xsl"/>
    <xsl:output omit-xml-declaration="yes" method="xml"/>

    <xsl:param name="title"/>
    <xsl:param name="abstract"/>
    <xsl:param name="useAbstract"/>
    <xsl:param name="plcReference"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="legalupdate | practicenote">
        <section2>
            <title>
                <xsl:value-of select="$title"/>
            </title>
            <!--add author if there-->
            <xsl:apply-templates select="author"/>
            <!-- convert href to simpleplcxlink?-->
            <!--<xsl:if test="$useAuthor='true'">
                <para><emphasis role='bold'><xsl:apply-templates select="$author"/></emphasis></para>
            </xsl:if>-->
            <xsl:choose>
                <xsl:when test="$useAbstract = 'true' ">
                    <xsl:copy-of select="abstract/child::*"/>
                    <xsl:call-template name="readmore"/>
                </xsl:when>
                <xsl:when test="speedread">
                    <xsl:apply-templates select="speedread/child::node()" mode="ft"/>
                    <xsl:call-template name="readmore"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="fulltext/child::node()" mode="ft"/>
                </xsl:otherwise>
            </xsl:choose>

        </section2>
    </xsl:template>
    <xsl:template match="section1" mode="ft">
        <xsl:apply-templates mode="ft"/>
    </xsl:template>
    <xsl:template match="@*|node()" mode="ft">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="ft"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template name="readmore">
        <para>
            <plcxlink>
                <xlink:locator>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="$plcReference"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:role">
                        <xsl:text>Article</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:title">
                        <xsl:value-of select="$title"/>
                    </xsl:attribute>
                    <xsl:text>Read more.</xsl:text>
                </xlink:locator>
            </plcxlink>
        </para>
    </xsl:template>

    <!--for author-->

    <xsl:template match="author">
        <para>
            <emphasis role="bold">Author:</emphasis>
            <xsl:apply-templates/>
        </para>
    </xsl:template>

    <xsl:template match="author/a">
        <emphasis role="bold-italic">
            <simpleplcxlink>
                <xsl:attribute name="xlink:href">
                    <xsl:value-of select="attribute::href"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </simpleplcxlink>
        </emphasis>
    </xsl:template>


    <!--
      <xsl:template match="text()">
        <xsl:value-of disable-output-escaping="yes" select="."/>
      </xsl:template> -->


    <!-- Identity transformation. -->
    <!--

     <xsl:template priority="-1"
                    match="@* | * | text() | processing-instruction() | comment()">
        <xsl:copy>
          <xsl:apply-templates
               select="@* | * | text() | processing-instruction() | comment()"/>
        </xsl:copy>
      </xsl:template>

    -->


</xsl:stylesheet>
