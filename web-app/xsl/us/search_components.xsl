<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="column[text()='resourceType']">
        <td>
            <xsl:if test="$fullSorting=true()">
                <xsl:call-template name="sort-link">
                    <xsl:with-param name="value" select="'rt'"/>
                    <xsl:with-param name="label" select="'Resource Type'"/>
                    <xsl:with-param name="reorder" select="true()"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$fullSorting=false()">Resource Type</xsl:if>
        </td>
    </xsl:template>

    <xsl:template name="searchFeedback">
        <xsl:if test="not($tabConfig[@key=$currentTab]/dateFilter='true') and $resourceCount &gt; 0">
            <p class="search-feedback-maintained">These resources are<span class="maintained">maintained</span>, meaning
                that we monitor developments on a regular
                basis and update them as soon as possible.
            </p>
        </xsl:if>

        <xsl:if test="not($searchTerm='' and $searchTermPhrase='' and $searchTermOr='' and $searchTermExclude='')">
            <xsl:variable name="searchQueryString">
                <xsl:call-template name="urlEncode">
                    <xsl:with-param name="input" select="$requestUri"/>
                </xsl:call-template>
            </xsl:variable>
            <a href="mailto:usfeedback@practicallaw.com?subject=Search feedback&amp;body=Username: {$username}%0DUser email: {$userEmail}%0DSearch query: {$searchQueryString}%0D%0D%0D%0DPlease tell us what you wanted to find"
               class="search-feedback-link" title="Send us feedback about these results">Did you find what you were
                looking for?
            </a>
        </xsl:if>

    </xsl:template>

    <xsl:template name="narrowingForm">
        <!-- Do not show the filter form for US topic page. -->
    </xsl:template>

</xsl:stylesheet>
