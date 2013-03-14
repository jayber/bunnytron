<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">


    <xsl:template match="/topic">
        <article xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:apply-templates/>
        </article>
    </xsl:template>

    <xsl:template match="editorial">
        <fulltext>
            <xsl:apply-templates/>
        </fulltext>
    </xsl:template>

    <xsl:template match="metadata">
        <xsl:element name="metadata"/>
        <!--				<fulltext>
                            <xsl:apply-templates/>
                        </fulltext> -->
    </xsl:template>

    <!-- Ignore the first section as contains the top part of an issue which we donot want to be inculded in an email -->
    <xsl:template match="section1[1]">
    </xsl:template>


    <!-- Identity transformation. -->
    <xsl:template priority="-1" match="@* | * | text() | processing-instruction() | comment()">
        <xsl:copy>
            <xsl:apply-templates select="@* | * | text() | processing-instruction() | comment()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
