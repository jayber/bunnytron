<?xml version="1.0" encoding="UTF-8"?>
<!-- US -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/search_components.xsl"/>

    <!-- fatwire parameters -->
    <xsl:param name="pagename"/>
    <xsl:param name="childPageName"/>
    <xsl:param name="contentType"/>
    <xsl:param name="contentId"/>
    <xsl:param name="fwAction"/>
    <xsl:param name="view"/>

    <xsl:param name="currentDate"/>

    <xsl:variable name="glotype" select="$searchParams/glossaryContext"/>
    <xsl:variable name="category" select="$searchParams/categoryList/category"/>

    <xsl:variable name="base-url">?params=true
        <xsl:if test="string-length($pagename)&gt;0">&amp;pagename=<xsl:value-of select="$pagename"/>
        </xsl:if>
        <xsl:if test="string-length($childPageName)&gt;0">&amp;childpagename=<xsl:value-of select="$childPageName"/>
        </xsl:if>
        <xsl:if test="string-length($fwAction)&gt;0">&amp;fwaction=<xsl:value-of select="$fwAction"/>
        </xsl:if>
        <xsl:if test="string-length($view)&gt;0">&amp;view=<xsl:value-of select="$view"/>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="indexes" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <!-- identifies to the configuration whether this is search, topic or something else -->
    <xsl:variable name="plcPageType" select="'glossary'"/>

    <!-- the actual number of resources (on this page)-->
    <xsl:variable name="resourceCount" select="count(/search/searchResults/detail/document)"/>
    <!-- the estimated total results - if its over 1000, cap it -->
    <xsl:variable name="estTotal">
        <xsl:choose>
            <xsl:when test="/search/searchResults/detail/total &gt; 1000">1000</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/search/searchResults/detail/total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:template match="/">

        <!-- show the results -->

        <div id="search_results">
            <xsl:call-template name="indexLink"/>
            <xsl:call-template name="indexLinkLoop">
                <xsl:with-param name="pos" select="'1'"/>
            </xsl:call-template>

            <xsl:apply-templates select="/search/searchResults/detail"/>
        </div>

    </xsl:template>

    <xsl:template match="searchResults/detail">

        <xsl:if test="$resourceCount &gt; 0">
            <table>
                <xsl:apply-templates select="$columnConfigObj"/>
                <xsl:apply-templates select="document">
                    <xsl:sort select="title"/>
                </xsl:apply-templates>
            </table>
        </xsl:if>

    </xsl:template>

    <xsl:template match="resultColumns"/>

    <xsl:template name="indexLink">
        <xsl:param name="value" select="'All'"/>
        <xsl:choose>
            <xsl:when test="($value=$category) or ($value='All' and $category='')">
                <span class="glossary-index">
                    <xsl:value-of select="$value"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="url">
                    <xsl:value-of select="$base-url"/>
                    <xsl:choose>
                        <xsl:when test="$value='All'">&amp;q=*</xsl:when>
                        <xsl:otherwise>&amp;cat=<xsl:value-of select="$value"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="string-length($glotype) &gt; 0">&amp;glotype=<xsl:value-of select="$glotype"/>
                    </xsl:if>
                </xsl:variable>
                <a class="glossary-index" href="{$url}">
                    <xsl:value-of select="$value"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="indexLinkLoop">
        <xsl:param name="pos"/>
        <xsl:call-template name="indexLink">
            <xsl:with-param name="value" select="substring($indexes,$pos,1)"/>
        </xsl:call-template>
        <xsl:if test="$pos &lt; string-length($indexes)">
            <xsl:call-template name="indexLinkLoop">
                <xsl:with-param name="pos" select="$pos+1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
