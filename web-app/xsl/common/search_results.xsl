<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="search_components.xsl"/>
    <xsl:import href="advanced_search.xsl"/>
    <xsl:import href="topic_components.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:template match="/">

        <xsl:if test="string($advancedSearch) = 'true'">
            <xsl:apply-templates select="/search/searchResults/detail" mode="advanced-search"/>
        </xsl:if>

        <xsl:variable name="topicNode"
                      select="$serviceList/service/practiceAreaList/practiceArea[id=$paramsPracticeAreas]"/>

        <xsl:if test="not(string($newSearch) = 'true')">
            <!-- show the results -->
            <xsl:variable name="results-class">content-results
                <xsl:if test="$advancedSearch = 'true'">content-results-advanced</xsl:if>
            </xsl:variable>
            <div class="{$results-class}">
                <xsl:apply-templates select="$tabConfigObj"/>
                <xsl:apply-templates select="/search/searchResults/detail"/>
            </div>
        </xsl:if>

    </xsl:template>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:call-template name="narrowingDescription"/>

            <xsl:apply-templates select="resultsMetaData/keymatchList"/>
            <xsl:apply-templates select="resultsMetaData/spellingList"/>
            <xsl:apply-templates select="resultsMetaData/synonymList"/>

            <xsl:call-template name="searchFeedback"/>

            <xsl:if test="not($disableFacetedSearch)">
                <xsl:call-template name="switchSearch"/>
            </xsl:if>

            <xsl:if test="$resourceCount &gt; 0">
                <table>
                    <xsl:apply-templates select="$columnConfigObj"/>
                    <xsl:apply-templates select="document"/>
                </table>
            </xsl:if>
            <xsl:if test="$resultsTotal &gt; $resourceCount and not($resourceCount &gt; $resultsPerPage)">
                <xsl:call-template name="pageLinks"/>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template name="switchSearch">
        <div id="switch_search_new_container">
            <a id="switch_search_link_new" href="#null" class="switch-search-link-new">Switch to new faceted search</a>
        </div>
    </xsl:template>
</xsl:stylesheet>
