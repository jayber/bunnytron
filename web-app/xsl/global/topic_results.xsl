<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/topic_results.xsl"/>

    <xsl:param name="su_filter"/>
    <xsl:variable name="topic_filters" select="$su_filter/su_filter/filter"/>

    <!-- jurisdiction url component -->
    <xsl:variable name="jurisdiction-url">
        <xsl:if test="count($paramsJurisdictions) &gt; 0">&amp;ju=
            <xsl:for-each select="$paramsJurisdictions">
                <xsl:if test="position() &gt; 1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

    <!-- filter topics -->
    <xsl:variable name="filtertopic-url">
        <xsl:if test="count($topic_filters[string-length(.)&gt;0]) &gt; 0">&amp;su_filter=
            <xsl:for-each select="$topic_filters">
                <xsl:if test="position() &gt; 1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

    <!-- redefine base url for topic pages to always include jurisdiction and filter topics -->
    <xsl:variable name="base-url">?params=true&amp;_charset_=UTF-8<xsl:value-of select="$filtertopic-url"/><xsl:value-of
            select="$jurisdiction-url"/>
    </xsl:variable>

    <xsl:variable name="sortOrder">
        <xsl:choose>
            <xsl:when test="string-length($searchParams/sortOrder)=0 and $currentTab='All'">rt</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$searchParams/sortOrder"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="grouping" select="$tabConfig[@key=$currentTab]/grouping"/>

    <xsl:template match="/">

        <!-- show the results -->
        <xsl:variable name="results-class">content-results
            <xsl:if test="$advancedSearch = 'true'">content-results-advanced</xsl:if>
        </xsl:variable>
        <div class="{$results-class}">
            <xsl:apply-templates select="$tabConfigObj"/>
            <xsl:apply-templates select="/search/searchResults/detail"/>
        </div>

    </xsl:template>

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

                    <xsl:choose>
                        <!-- do the grouping - only if group condition matches current sort (or there is no restriction) -->
                        <xsl:when test="$grouping and ($sortOrder = $grouping/@sort or not($grouping/@sort))">

                            <xsl:for-each select="$grouping/group">

                                <xsl:variable name="multisort" select="multisort"/>
                                <xsl:variable name="multisort_rt" select="$multisort/sort[.='rt']"/>
                                <xsl:variable name="multisort_date" select="$multisort/sort[.='date']"/>
                                <xsl:variable name="multisort_name" select="$multisort/sort[.='name']"/>

                                <xsl:if test="plcReference = $result/resourceTypeList/resourceType">
                                    <tr>
                                        <td colspan="{count($columnConfig)}" class="topic-section-header">
                                            <xsl:if test="@displayname">
                                                <xsl:value-of select="@displayname"/>
                                            </xsl:if>
                                            <xsl:if test="not(@displayname)">
                                                <xsl:call-template name="resourceTypeDescription">
                                                    <xsl:with-param name="resourceTypes" select="plcReference"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </td>
                                    </tr>

                                    <xsl:variable name="groupPlcReference" select="plcReference"/>

                                    <xsl:variable name="filtered_results"
                                                  select="$result[$groupPlcReference = resourceTypeList/resourceType]"/>

                                    <xsl:apply-templates select="$filtered_results">
                                        <xsl:sort select="resourceTypeList/resourceType[$multisort/sort='rt']"
                                                  order="descending"/>
                                        <xsl:sort
                                                select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))[$multisort/sort='date']"
                                                data-type="number" order="descending"/>
                                        <xsl:sort select="title[$multisort/sort='name' or not($multisort)]"
                                                  order="ascending"/>
                                    </xsl:apply-templates>

                                </xsl:if>

                                <xsl:if test="not(plcReference)">
                                    <xsl:variable name="unfiltered_results"
                                                  select="$result[not(resourceTypeList/resourceType=$grouping/group/plcReference)]"/>
                                    <xsl:if test="count($unfiltered_results)&gt;0">
                                        <tr>
                                            <td colspan="{count($columnConfig)}" class="topic-section-header">Other
                                                Resources
                                            </td>
                                        </tr>

                                        <xsl:apply-templates select="$unfiltered_results">
                                            <xsl:sort select="resourceTypeList/resourceType[$multisort/sort='rt']"
                                                      order="descending"/>
                                            <xsl:sort
                                                    select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))[$multisort/sort='date']"
                                                    data-type="number" order="descending"/>
                                            <xsl:sort select="title[$multisort/sort='name' or not($multisort)]"
                                                      order="ascending"/>
                                        </xsl:apply-templates>

                                    </xsl:if>
                                </xsl:if>

                            </xsl:for-each>

                        </xsl:when>
                        <!-- don't group -->
                        <xsl:otherwise>

                            <xsl:variable name="multisort"
                                          select="$tabConfig[@key=$currentTab]/multisort[@sort = $sortOrder]"/>

                            <xsl:if test="$multisort">
                                <xsl:apply-templates select="document">
                                    <xsl:sort select="resourceTypeList/resourceType[$multisort/sort='rt']"
                                              order="descending"/>
                                    <xsl:sort
                                            select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))[$multisort/sort='date']"
                                            data-type="number" order="descending"/>
                                    <xsl:sort select="title[$multisort/sort='name']" order="ascending"/>
                                </xsl:apply-templates>
                            </xsl:if>

                            <xsl:if test="not($multisort/@sort = $sortOrder)">
                                <xsl:choose>
                                    <xsl:when test="$sortOrder='date'">
                                        <xsl:apply-templates select="document">
                                            <xsl:sort
                                                    select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))[$isasc=false()]"
                                                    data-type="number" order="descending"/>
                                            <xsl:sort
                                                    select="(number(maintained = 'true')*1000000000) + (number(not(maintained = 'true')))*number(concat('0',substring(publicationDate,1,4),substring(publicationDate,6,2),substring(publicationDate,9,2)))[$isasc=true()]"
                                                    data-type="number" order="ascending"/>
                                            <xsl:sort select="title"/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="document"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>

                        </xsl:otherwise>
                    </xsl:choose>
                </table>

            </xsl:if>

        </div>

    </xsl:template>


    <!-- override narrowing decsription to not show the "Showing x of y" - this is a temporary fix because some
    topics seem to have different totals reported from Google than are actually returned. FBT #14266 -->

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
            </div>

        </xsl:if>

    </xsl:template>

    <xsl:template match="document/resourceTypeList">
        <xsl:variable name="result" select="parent::*"/>
        <xsl:variable name="resourceType" select="resourceType"/>
        <td>
            <xsl:attribute name="class">result-col-resource
                <xsl:if test=".='Practice note: overview'">result-col-highlight</xsl:if>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$tabConfig[@key=$currentTab]/@resultsdisplayname">
                    <xsl:value-of select="$tabConfig[@key=$currentTab]/@resultsdisplayname"/>
                </xsl:when>
                <xsl:when test="$grouping/group[plcReference = $resourceType]/@resultsdisplayname">
                    <xsl:value-of select="$grouping/group[plcReference = $resourceType]/@resultsdisplayname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="resourceTypeDescription">
                        <xsl:with-param name="resourceTypes" select="$resourceType"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </td>
    </xsl:template>

    <!-- this is using some more flexible/better config than the rest of the site and is starting to diverge - 
    need to bring all the tab/search/topic stuff together -->
    <!-- also, the whole tab matching stuff is crazy complicated. surely it would be easier just passing a tab parameter? -->
    <xsl:template match="tab">

        <xsl:variable name="tabName">
            <!-- is this necessary any more? What's the point of the name field if its not used as a label??? -->
            <xsl:if test="not(string(@label)='')">
                <xsl:value-of select="@label"/>
            </xsl:if>
            <xsl:if test="string(@label)=''">
                <xsl:value-of select="@name"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="tabTooltip">
            <xsl:if test="string(description)=''">
                <xsl:value-of select="$tabName"/>
            </xsl:if>
            <xsl:if test="not(string(description)='')">
                <xsl:value-of select="description"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="name" select="@name"/>

        <xsl:variable name="tabVal">
            <xsl:if test="count(plcReference) &gt; 0">
                <xsl:for-each select="plcReference">
                    <xsl:if test="position() &gt; 1">,</xsl:if>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="count(plcReference) = 0">All</xsl:if>
        </xsl:variable>

        <xsl:variable name="facet">
            <xsl:if test="facet">
                <xsl:value-of select="facet/@name"/>
            </xsl:if>
            <xsl:if test="not(facet)">rt</xsl:if>
        </xsl:variable>

        <xsl:variable name="tabClass">tab
            <xsl:if test="@key=$currentTab">tab-selected</xsl:if>
        </xsl:variable>

        <div class="{$tabClass}">
            <div class="tab-left">
                <div class="tab-right">
                    <xsl:if test="@key=$currentTab">
                        <xsl:value-of select="$tabName"/>
                    </xsl:if>
                    <xsl:if test="not(@key=$currentTab)">

                        <xsl:variable name="tabHref">
                            <xsl:value-of select="$base-url"/>
                            <xsl:value-of select="$query-url"/>
                            <xsl:value-of select="$service-url"/>
                            <xsl:if test="defaultOrder='-1'">&amp;isasc=0</xsl:if>
                            <xsl:if test="string-length(defaultSort)&gt;0">&amp;sort=<xsl:value-of
                                    select="defaultSort"/>
                            </xsl:if>
                            <xsl:if test="string-length($tabVal)&gt;0">&amp;<xsl:value-of select="$facet"/>=<xsl:value-of
                                    select="$tabVal"/>
                            </xsl:if>
                        </xsl:variable>

                        <a href="{$tabHref}" id="tab_{@key}_{$tabVal}" title="{$tabTooltip}" class="tab-link">
                            <xsl:value-of select="$tabName"/>
                        </a>
                    </xsl:if>
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>