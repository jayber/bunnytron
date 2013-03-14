<?xml version="1.0" encoding="UTF-8"?>
<!-- US -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/topic_results.xsl"/>
    <xsl:import href="search_components.xsl"/>

    <xsl:variable name="sortOrder">
        <xsl:choose>
            <xsl:when test="string-length($searchParams/sortOrder)=0 and $currentTab='All'">rt</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$searchParams/sortOrder"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:call-template name="narrowingDescription"/>

            <xsl:apply-templates select="resultsMetaData/keymatchList"/>
            <xsl:apply-templates select="resultsMetaData/spellingList"/>
            <xsl:apply-templates select="resultsMetaData/synonymList"/>

            <xsl:call-template name="searchFeedback"/>
            <xsl:if test="$resourceCount &gt; 0">

                <table class="topicTable">
                    <xsl:apply-templates select="$columnConfigObj"/>

                    <xsl:variable name="result" select="document"/>
                    <xsl:variable name="sortPriorityItems" select="$tabConfig[@name = 'All']/sortPriority/item"/>

                    <xsl:if test="string($sortOrder) = 'rt' and $currentTab = 'All'">
                        <xsl:for-each select="$sortPriorityItems">
                            <xsl:if test=". = $result/resourceTypeList/resourceType">
                                <tr>
                                    <td colspan="{count($columnConfig)}" class="topic-section-header">
                                        <xsl:if test="@displayname">
                                            <xsl:value-of select="@displayname"/>
                                        </xsl:if>
                                        <xsl:if test="not(@displayname)">
                                            <xsl:call-template name="resourceTypeDescription">
                                                <xsl:with-param name="resourceTypes" select="."/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </td>
                                </tr>
                                <xsl:variable name="sortPriorityItem" select="."/>

                                <xsl:variable name="filtered_results"
                                              select="$result[resourceTypeList/resourceType=$sortPriorityItem]"/>

                                <xsl:apply-templates select="$filtered_results">
                                    <xsl:sort
                                            select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))"
                                            data-type="number" order="descending"/>
                                    <xsl:sort select="title"/>
                                </xsl:apply-templates>

                            </xsl:if>

                        </xsl:for-each>

                        <!-- output "other resources" that aren't in the config -->
                        <xsl:variable name="unfiltered_results"
                                      select="$result[not(resourceTypeList/resourceType=$sortPriorityItems)]"/>

                        <xsl:if test="count($unfiltered_results)&gt;0">
                            <tr>
                                <td colspan="{count($columnConfig)}" class="topic-section-header">Other Resources</td>
                            </tr>

                            <xsl:apply-templates select="$unfiltered_results">
                                <xsl:sort
                                        select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))"
                                        data-type="number" order="descending"/>
                                <xsl:sort select="title"/>
                            </xsl:apply-templates>

                        </xsl:if>

                    </xsl:if>

                    <xsl:if test="not(string($sortOrder) = 'rt') or not($currentTab = 'All')">

                        <xsl:choose>
                            <xsl:when test="$sortOrder='date'">
                                <xsl:if test="$isasc=false()">
                                    <xsl:apply-templates select="document">
                                        <xsl:sort
                                                select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))"
                                                data-type="number" order="descending"/>
                                        <xsl:sort select="title"/>
                                    </xsl:apply-templates>
                                </xsl:if>
                                <xsl:if test="$isasc=true()">
                                    <xsl:apply-templates select="document">
                                        <xsl:sort
                                                select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))"
                                                data-type="number" order="ascending"/>
                                        <xsl:sort select="title"/>
                                    </xsl:apply-templates>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="document"/>
                            </xsl:otherwise>
                        </xsl:choose>


                        <!--<xsl:if test="$isasc=false()">
                            <xsl:apply-templates select="document">
                                <xsl:sort select="number($sortOrder = 'd')*(number(maintained = 'true')*1000000000 + (number(not(maintained = 'true')))*number(concat(substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2))))" data-type="number" order="descending"/>
                                <xsl:sort select="resourceTypeList/resourceType[$sortOrder='rt' and not($currentTab = 'All')]" data-type="text" order="descending"/>
                                <xsl:sort select="title[$sortOrder='' or $sortOrder = 'title']" data-type="text" order="descending"/>
                                <xsl:sort select="title[not($sortOrder='') and not($sortOrder = 'title') and not($sortOrder='rel')]" data-type="text" order="descending"/>
                            </xsl:apply-templates>
                        </xsl:if>
                        <xsl:if test="$isasc=true()">
                            <xsl:apply-templates select="document">
                                <xsl:sort select="number($sortOrder = 'd')*(number(maintained = 'true')*1000000000 + (number(not(maintained = 'true')))*number(concat(substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2))))" data-type="number" order="ascending"/>
                                <xsl:sort select="resourceTypeList/resourceType[$sortOrder='rt' and not($currentTab = 'All')]" data-type="text" order="ascending"/>
                                <xsl:sort select="title[not($sortOrder='rel')]" data-type="text" order="ascending"/>
                            </xsl:apply-templates>
                        </xsl:if>-->

                    </xsl:if>

                </table>
            </xsl:if>
            <!-- seems to cause page links to appear where there shouldn't be any. As topic pages aren't paginated,
                temporary workaround is to hide the page links (FBT #14267) -->
            <!--<xsl:if test="$resultsTotal &gt; $resourceCount and not($resourceCount &gt; 100)">-->
            <!--<xsl:call-template name="pageLinks"/>-->
            <!--</xsl:if>-->
        </div>

    </xsl:template>

    <!-- override narrowing decsription to not show the "Showing x of y" - this is a temporary fix because some
        topics seem to have different totals reported from Google than are actually returned. FBT #14266-->
    <xsl:template name="narrowingDescription">

        <xsl:if test="$estTotal = 0 and not(string($noNarrowing)='false') and not($tabConfig[@key=$currentTab]/dateFilter='true') and not($plcPageType = 'topic' or $plcPageType = 'handbook')">
            <p>
                <strong>No resources</strong>
            </p>
        </xsl:if>
        <xsl:if test="$estTotal &gt; 0 or string($noNarrowing)='false' or $tabConfig[@key=$currentTab]/dateFilter='true' or $plcPageType = 'topic' or $plcPageType = 'handbook'">

            <div id="search_results_info">
                <strong>
                    <xsl:if test="$resourceCount = 0">No resources</xsl:if>
                    <xsl:if test="$resourceCount &gt; 0">
                        <xsl:choose>
                            <xsl:when test="$estTotal = 1000">Over 1000</xsl:when>
                            <xsl:when
                                    test="$estTotal &lt; 1000 and $endIndex &lt; $estTotal and($estTotal &gt; $resultsStartIndex + $resultsPerPage)">
                                <xsl:value-of select="$estTotal"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$endIndex"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        resource
                        <xsl:if test="$resourceCount &gt; 1">s</xsl:if>
                    </xsl:if>
                </strong>
                <!--<xsl:if test="$resultsTotal &gt; $resourceCount">
                    <xsl:choose>
                        <xsl:when test="$resourceCount &gt; $resultsPerPage">
                            <p>Showing <strong><xsl:value-of select="$resultsStartIndex + 1"/></strong> - <strong><xsl:value-of select="$resourceCount"/></strong></p>
                        </xsl:when>
                        <xsl:otherwise>
                            <p>Showing <strong><xsl:value-of select="$resultsStartIndex + 1"/></strong> - <strong><xsl:value-of select="$endIndex"/></strong></p>
                <xsl:call-template name="pageLinks"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>-->
            </div>

            <xsl:call-template name="narrowingForm"/>

            <!--<xsl:if test="$searchParams/resultsCount &gt; 0"> (limited to <strong><xsl:value-of select="$searchParams/resultsCount"/></strong> results)</xsl:if>-->

        </xsl:if>

    </xsl:template>
</xsl:stylesheet>