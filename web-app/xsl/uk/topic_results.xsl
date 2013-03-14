<?xml version="1.0" encoding="UTF-8"?>
<!-- UK -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/topic_results.xsl"/>

    <xsl:param name="inBlocks"/>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:call-template name="narrowingDescription"/>

            <xsl:apply-templates select="resultsMetaData/keymatchList"/>
            <xsl:apply-templates select="resultsMetaData/spellingList"/>
            <xsl:apply-templates select="resultsMetaData/synonymList"/>

            <xsl:call-template name="searchFeedback"/>
            <xsl:if test="$resourceCount &gt; 0">
                <table>
                    <xsl:apply-templates select="$columnConfigObj"/>

                    <xsl:variable name="result" select="document"/>
                    <xsl:variable name="sortPriorityItems" select="$tabConfig[@name = 'All']/sortPriority/item"/>

                    <!-- For UK site, on the "All" tab, group the resources by Resource Type ONLY
                      for new Blocks pages, on the original topic pages they will remain ungrouped. -->
                    <xsl:choose>
                        <xsl:when test="string($sortOrder) = 'rt' and $currentTab = 'All' and $inBlocks = 'true'">
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
                                    <td colspan="{count($columnConfig)}" class="topic-section-header">Other Resources
                                    </td>
                                </tr>

                                <xsl:apply-templates select="$unfiltered_results">
                                    <xsl:sort
                                            select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))"
                                            data-type="number" order="descending"/>
                                    <xsl:sort select="title"/>
                                </xsl:apply-templates>

                            </xsl:if>

                        </xsl:when>

                        <xsl:otherwise>
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

                        </xsl:otherwise>

                    </xsl:choose>

                </table>
            </xsl:if>
            <xsl:if test="$resultsTotal &gt; $resourceCount and not($resourceCount &gt; $resultsPerPage)">
                <xsl:call-template name="pageLinks"/>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet>