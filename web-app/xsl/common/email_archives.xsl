<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="search_components.xsl"/>

    <xsl:variable name="plcPageType" select="'email-archive'"/>
    <xsl:variable name="abstractDisplay" select="'none'"/>

    <xsl:template match="/">
        <div class="content-results">
            <xsl:apply-templates select="/search/searchResults/detail"/>
        </div>
    </xsl:template>

    <xsl:template match="resultColumns"/>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:if test="string-length($startDate)&gt;0">
                <div class="results-section-header">
                    <xsl:value-of select="substring($startDate,1,4)"/>
                </div>
            </xsl:if>
            <xsl:if test="$resourceCount &gt; 0">
                <div class="results-section">
                    <table>
                        <xsl:apply-templates select="$columnConfigObj"/>
                        <xsl:apply-templates select="document">
                            <xsl:sort select="substring(publicationDate,1,4)" data-type="number" order="descending"/>
                            <xsl:sort select="substring(publicationDate,6,2)" data-type="number" order="descending"/>
                            <xsl:sort select="substring(publicationDate,9,2)" data-type="number" order="descending"/>
                        </xsl:apply-templates>
                    </table>
                </div>
            </xsl:if>
            <xsl:if test="$resourceCount = 0">
                <p>No resources found</p>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet>
