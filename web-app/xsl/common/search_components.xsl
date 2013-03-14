<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8"/>

    <!-- fatwire parameters -->
    <xsl:param name="pagename"/>
    <xsl:param name="childPageName"/>
    <xsl:param name="contentType"/>
    <xsl:param name="contentId"/>
    <xsl:param name="fwAction"/>
    <xsl:param name="view"/>

    <xsl:param name="requestUri"/>
    <xsl:param name="serviceContext"/>
    <xsl:param name="advancedSearch"/>
    <xsl:param name="currentDate"/>
    <xsl:param name="newSearch"/>

    <xsl:param name="practiceAreaXml"/>
    <xsl:param name="jurisdictionXml"/>

    <!-- user info -->
    <xsl:param name="userPreferencesXml"/>
    <xsl:param name="username"/>
    <xsl:param name="userEmail"/>
    <xsl:param name="extraResourceUrlPath"/>
    <xsl:variable name="abstractDisplay"
                  select="$userPreferencesXml/userPreferences/preference[name='SEARCH_RESULTS_ABSTRACT_DISPLAY']/value"/>

    <xsl:variable name="disableFacetedSearch"
                  select="$resourcefile/page-resource/searchConfig/facetedSearch/item[@site=$serviceContext] = 'false'"/>

    <!-- facet data -->
    <xsl:variable name="facet-data-practice-areas" select="$practiceAreaXml"/>
    <xsl:variable name="facet-data-jurisdictions" select="$jurisdictionXml"/>
    <!-- paths supplied via cfg.xsl -->
    <xsl:variable name="facet-data-resource-types" select="document($facet-data-resource-types-path)"/>
    <xsl:variable name="facet-data-section-folders" select="document($facet-data-section-folders-path)"/>

    <!-- resource type config - gives us the correct display names and sort orders etc (paths from cfg.xsl) -->
    <xsl:variable name="resourceTypeConfig" select="document($resourceTypeConfig-path)/resourceTypeList/resourceType"/>
    <xsl:variable name="sectionConfig" select="document($sectionConfig-path)/sectionList/section"/>

    <!-- identifies to the configuration whether this is search, topic or something else -->
    <xsl:variable name="plcPageType" select="'search'"/>

    <!-- define what sort links are available -->
    <xsl:variable name="fullSorting" select="false()"/>

    <!-- grouping keys, for grouped stuff that isn't sorted via configuration -->
    <xsl:key name="section" match="document" use="sectionList/section"/>
    <xsl:key name="resourceType" match="document" use="resourceType"/>

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

    <xsl:variable name="serviceList" select="$facet-data-practice-areas/serviceList"/>
    <xsl:variable name="resourceTypeList" select="$facet-data-resource-types/resourceTypeList"/>
    <xsl:variable name="jurisdictionList" select="$facet-data-jurisdictions/jurisdictionList"/>
    <xsl:variable name="sectionFolderList" select="$facet-data-section-folders/sectionFolderList"/>
    <xsl:variable name="facetServices" select="$serviceList/service"/>
    <xsl:variable name="facetPracticeAreas" select="$facetServices/descendant::practiceArea"/>
    <xsl:variable name="facetResourceTypes" select="$resourceTypeList/resourceType"/>
    <xsl:variable name="facetJurisdictions" select="$jurisdictionList/jurisdiction"/>
    <xsl:variable name="facetSectionFolders" select="$sectionFolderList/sectionFolder"/>

    <xsl:variable name="itemRef"/>

    <!-- config (path from cfg.xsl) -->
    <xsl:variable name="searchConfig" select="$resourcefile/page-resource/searchConfig"/>

    <!-- find all the configs that this can use based on site -->
    <xsl:variable name="siteTabConfig"
                  select="$searchConfig/resultTabs[@site=$serviceContext or (not($searchConfig/resultTabs[@site=$serviceContext]) and not(@site))]"/>
    <!-- find all the configs that this can used based on page type -->
    <xsl:variable name="pageTabConfig"
                  select="$searchConfig/resultTabs[@page=$plcPageType or (not($searchConfig/resultTabs[@page=$plcPageType]) and not(@page))]"/>
    <!-- check if any of these configs intersect -->
    <xsl:variable name="sitePageIntersect" select="$siteTabConfig[count(.|$pageTabConfig)=count($pageTabConfig)]"/>
    <!-- if there's an intersection, use it - otherwise use a config that doesn't have a specific site or page type (ie a global default) -->
    <xsl:variable name="tabConfigObj"
                  select="$sitePageIntersect|$searchConfig/resultTabs[count($sitePageIntersect) = 0 and not(@site) and not(@page)]"/>
    <!-- get the tabs from this config based on include/exclude attributes -->
    <xsl:variable name="tabConfig"
                  select="$tabConfigObj/tab[count(site) = 0 or (site = $serviceContext and site[@type='include'] and (page=$plcPageType or string(page)='')) or (not(site = $serviceContext) and site[@type='exclude'] and (page=$plcPageType or string(page)=''))]"/>

    <!-- find all the configs that this can use based on site -->
    <xsl:variable name="siteColumnConfig"
                  select="$searchConfig/resultColumns[@site=$serviceContext or (not($searchConfig/resultColumns[@site=$serviceContext]) and not(@site))]"/>
    <!-- find all the configs that this can used based on page type -->
    <xsl:variable name="pageColumnConfig"
                  select="$searchConfig/resultColumns[@page=$plcPageType or (not($searchConfig/resultColumns[@page=$plcPageType]) and not(@page))]"/>
    <!-- check if any of these configs intersect -->
    <xsl:variable name="sitePageColumnIntersect"
                  select="$siteColumnConfig[count(.|$pageColumnConfig)=count($pageColumnConfig)]"/>
    <!-- get the configs that are based on a style defined by the tab - this is independent of site/page -->
    <xsl:variable name="styleColumnConfig"
                  select="$searchConfig/resultColumns[@style=$tabConfig[@key=$currentTab]/columnStyle]"/>
    <!-- if there's a page/style intersection use it - if not, check if there's a style config and use it, if not use a default that doesn't have a specific site or page (ie a global default) -->
    <xsl:variable name="columnConfigObj"
                  select="$sitePageColumnIntersect|$styleColumnConfig[count($sitePageIntersect) = 0]|$searchConfig/resultColumns[count($sitePageIntersect) = 0 and count($styleColumnConfig) = 0 and not(@site) and not(@page)]"/>
    <xsl:variable name="columnConfig" select="$columnConfigObj/column"/>

    <!-- xpath to the user search parameters-->
    <xsl:variable name="searchParams" select="/search/userSearchParameters"/>

    <!-- specific user parameter facets -->
    <xsl:variable name="paramsPracticeAreas" select="$searchParams/practiceAreaList/practiceArea"/>
    <xsl:variable name="paramsJurisdictions" select="$searchParams/jurisdictionList/jurisdiction"/>
    <xsl:variable name="paramsServices" select="$searchParams/productList/product"/>
    <xsl:variable name="paramsResourceTypes" select="$searchParams/resourceTypeList/resourceType"/>
    <xsl:variable name="paramsSectionFolders" select="$searchParams/sectionFolderList/sectionFolder"/>

    <xsl:variable name="searchTerm" select="string($searchParams/searchTerm)"/>
    <xsl:variable name="searchTermOr" select="string($searchParams/searchTermOr)"/>
    <xsl:variable name="searchTermPhrase" select="string($searchParams/searchTermPhrase)"/>
    <xsl:variable name="searchTermExclude" select="string($searchParams/searchTermExclude)"/>

    <xsl:variable name="searchTermUrlEncoded" select="string($searchParams/searchTermUrlEncoded)"/>
    <xsl:variable name="searchTermOrUrlEncoded" select="string($searchParams/searchTermOrUrlEncoded)"/>
    <xsl:variable name="searchTermPhraseUrlEncoded" select="string($searchParams/searchTermPhraseUrlEncoded)"/>
    <xsl:variable name="searchTermExcludeUrlEncoded" select="string($searchParams/searchTermExcludeUrlEncoded)"/>

    <xsl:variable name="startDate" select="string($searchParams/startDate)"/>
    <xsl:variable name="endDate" select="string($searchParams/endDate)"/>

    <xsl:variable name="sortOrder" select="$searchParams/sortOrder"/>
    <xsl:variable name="isasc" select="$searchParams/isAscendingSortOrder='true'"/>

    <xsl:variable name="collections" select="$searchParams/collectionList/collection"/>

    <!-- results per page -->
    <xsl:variable name="resultsPerPage">
        <xsl:choose>
            <xsl:when test="string-length($searchParams/resultsCount)&gt;0">
                <xsl:value-of select="number($searchParams/resultsCount)"/>
            </xsl:when>
            <xsl:when test="$plcPageType='search'">20</xsl:when>
            <xsl:otherwise>100</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- base url for the current search query -->
    <!--<xsl:variable name="base-url">?pagename=<xsl:value-of select="$pagename"/>&amp;childpagename=<xsl:value-of select="$childPageName"/><xsl:if test="string-length($contentType)&gt;0">&amp;c=<xsl:value-of select="$contentType"/></xsl:if><xsl:if test="string-length($contentId)&gt;0">&amp;cid=<xsl:value-of select="$contentId"/></xsl:if><xsl:if test="string-length($fwAction)&gt;0">&amp;fwaction=<xsl:value-of select="$fwAction"/></xsl:if><xsl:if test="string-length($view)&gt;0">&amp;view=<xsl:value-of select="$view"/></xsl:if><xsl:if test="string($advancedSearch) = 'true'">&amp;adv=true</xsl:if></xsl:variable>-->
    <xsl:variable name="base-url">?params=true&amp;num=<xsl:value-of select="$resultsPerPage"/>&amp;
        <xsl:if test="string-length($view)&gt;0">&amp;view=<xsl:value-of select="$view"/>
        </xsl:if>
        <xsl:if test="string($advancedSearch) = 'true'">&amp;adv=true</xsl:if>&amp;_charset_=UTF-8
    </xsl:variable>

    <!-- query params url component -->
    <xsl:variable name="query-url">
        <xsl:if test="not($searchTerm='')">&amp;q=<xsl:value-of select="$searchTermUrlEncoded"/>
        </xsl:if>
        <xsl:if test="not($searchTermPhrase='')">&amp;qp=<xsl:value-of select="$searchTermPhraseUrlEncoded"/>
        </xsl:if>
        <xsl:if test="not($searchTermOr='')">&amp;qo=<xsl:value-of select="$searchTermOrUrlEncoded"/>
        </xsl:if>
        <xsl:if test="not($searchTermExclude='')">&amp;qe=<xsl:value-of select="$searchTermExcludeUrlEncoded"/>
        </xsl:if>
    </xsl:variable>

    <!-- service url component -->
    <xsl:variable name="service-url">
        <xsl:if test="count($paramsServices) &gt; 0">&amp;sv=
            <xsl:for-each select="$paramsServices">
                <xsl:if test="position() &gt; 1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

    <!-- resource type url component -->
    <xsl:variable name="resourcetype-url">
        <xsl:if test="count($paramsResourceTypes) &gt; 0">&amp;rt=
            <xsl:for-each select="$paramsResourceTypes">
                <xsl:if test="position() &gt; 1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="count($paramsResourceTypes) = 0 and not($plcPageType='search')">&amp;rt=All</xsl:if>
    </xsl:variable>

    <!-- resource type url component -->
    <xsl:variable name="jurisdictions-url">
        <xsl:if test="count($paramsJurisdictions) &gt; 0">&amp;ju=
            <xsl:for-each select="$paramsJurisdictions">
                <xsl:if test="position() &gt; 1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:if>
    </xsl:variable>

    <!-- full url without sorting or paging -->
    <xsl:variable name="unsorted-url">
        <xsl:value-of select="$base-url"/>
        <xsl:value-of select="$query-url"/>
        <xsl:value-of select="$service-url"/>
        <xsl:value-of select="$resourcetype-url"/>
        <xsl:value-of select="jurisdiction-url"/>
        <xsl:if test="not(string($startDate)='')">&amp;sd=<xsl:value-of select="$startDate"/>
        </xsl:if>
        <xsl:if test="not(string($endDate)='')">&amp;ed=<xsl:value-of select="$endDate"/>
        </xsl:if>
    </xsl:variable>

    <!-- full url without page data -->
    <xsl:variable name="unpaged-url">
        <xsl:value-of select="$unsorted-url"/>
        <xsl:if test="not(string($sortOrder)='')">&amp;sort=<xsl:value-of select="$sortOrder"/>
        </xsl:if>
    </xsl:variable>

    <!-- check if this tab allows sorting (search page only) -->
    <xsl:variable name="sortable" select="$fullSorting = true() or $tabConfig[@key=$currentTab]/sorting = 'true'"/>

    <!-- check if there are any narrowing filters applied -->
    <xsl:variable name="noNarrowing"
                  select="count($paramsPracticeAreas)=0 and count($paramsJurisdictions)=0 and count($paramsServices)=0 and $searchTerm='' and $searchTermOr='' and $searchTermPhrase='' and $searchTermExclude=''"/>

    <xsl:variable name="rt">
        <xsl:for-each select="$facetResourceTypes">
            <xsl:variable name="name" select="name"/>
            <xsl:if test="count(id) = count(id[.=$paramsResourceTypes]) and $tabConfig[@name = $name] and string-length(id) &gt; 0">
                <xsl:value-of select="name"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="sf">
        <xsl:for-each select="$facetSectionFolders">
            <xsl:variable name="name" select="name"/>
            <xsl:variable name="id" select="id"/>
            <xsl:if test="count(id) = count(id[.=$paramsSectionFolders]) and $tabConfig[@name = $name or @id=$id]">
                <xsl:value-of select="name"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="currentTab">
        <xsl:choose>
            <xsl:when test="$tabConfig/facet[@name='col' and .= $collections] and count($collections) = 1">
                <xsl:value-of select="$tabConfig[facet[@name='col' and .=$collections]]/@key"/>
            </xsl:when>
            <xsl:when test="count($paramsSectionFolders) &gt;0 and count($tabConfig[facet/@name='sf']) &gt; 0">
                <xsl:value-of select="$tabConfig[@name=$sf]/@key"/>
            </xsl:when>
            <xsl:when test="count($paramsResourceTypes) &gt;0 and count($tabConfig[@name=$rt]) &gt; 0">
                <xsl:value-of select="$tabConfig[@name=$rt]/@key"/>
            </xsl:when>
            <xsl:otherwise>All</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- construct our dates for narrowing by -->

    <xsl:variable name="currentDateNum"
                  select="concat(substring($currentDate,1,4),substring($currentDate,6,2),substring($currentDate,9,2))"/>

    <xsl:variable name="date6months">
        <xsl:if test="number(substring($currentDateNum,5,2)) &gt; 6">
            <xsl:call-template name="dateFormatter">
                <xsl:with-param name="dateString" select="($currentDateNum)-600"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="number(substring($currentDateNum,5,2)) &lt; 7">
            <xsl:call-template name="dateFormatter">
                <xsl:with-param name="dateString" select="($currentDateNum)-9400"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="date1year">
        <xsl:call-template name="dateFormatter">
            <xsl:with-param name="dateString" select="($currentDateNum)-10000"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="date2years">
        <xsl:call-template name="dateFormatter">
            <xsl:with-param name="dateString" select="($currentDateNum)-20000"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="date5years">
        <xsl:call-template name="dateFormatter">
            <xsl:with-param name="dateString" select="($currentDateNum)-50000"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- resultsMetaData -->
    <xsl:variable name="resultsMetaData"
                  select="/plcdata/contentSection/contentBody/plcSearchResults/xml/searchResults/detail/resultsMetaData"/>

    <xsl:variable name="resultsStartIndex" select="$searchParams/resultsStartIndex"/>

    <!-- get the end point -->
    <xsl:variable name="endIndex">
        <xsl:choose>
            <!-- if we get less than 100 resources, check if the estimate is more than 100 higher - if so, assume we will have another page and we're just missing a few from this one -->
            <xsl:when test="$estTotal - ($resultsStartIndex + $resourceCount) &gt; $resultsPerPage">
                <xsl:value-of select="$resultsStartIndex + $resultsPerPage"/>
            </xsl:when>
            <!-- otherwise, assume we've reached the end of the resulset asn cap it -->
            <xsl:otherwise>
                <xsl:value-of select="$resultsStartIndex + $resourceCount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!--<xsl:variable name="endIndex" select="$resultsStartIndex + $resourceCount"/>-->

    <!-- check if google's got it wrong - if there's less than 100 resources, the estimated total is higher but higher by less than 100, we can correct it -->
    <xsl:variable name="resultsTotal">
        <xsl:choose>
            <xsl:when
                    test="$resourceCount &lt; $resultsPerPage and $endIndex &lt; $estTotal and $endIndex &gt; $estTotal - $resultsPerPage">
                <xsl:value-of select="$endIndex"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$estTotal"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <!-- show the service filter - by default, don't -->
    <xsl:variable name="showServiceFilter" select="false()"/>

    <!-- date formatting -->

    <xsl:template name="format-date-month">
        <xsl:param name="month"/>
        <xsl:variable name="output">
            <xsl:choose>
                <xsl:when test="$month='01'">Jan</xsl:when>
                <xsl:when test="$month='02'">Feb</xsl:when>
                <xsl:when test="$month='03'">Mar</xsl:when>
                <xsl:when test="$month='04'">Apr</xsl:when>
                <xsl:when test="$month='05'">May</xsl:when>
                <xsl:when test="$month='06'">Jun</xsl:when>
                <xsl:when test="$month='07'">Jul</xsl:when>
                <xsl:when test="$month='08'">Aug</xsl:when>
                <xsl:when test="$month='09'">Sep</xsl:when>
                <xsl:when test="$month='10'">Oct</xsl:when>
                <xsl:when test="$month='11'">Nov</xsl:when>
                <xsl:when test="$month='12'">Dec</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$output"/>
    </xsl:template>

    <xsl:template name="dateFormatter">
        <xsl:param name="dateString"/>
        <xsl:param name="outputFormat" select="'yyyymmdd'"/>
        <xsl:param name="inputFormat"/>

        <xsl:variable name="dayIn">
            <xsl:choose>
                <xsl:when test="$inputFormat='yyyy-mm-dd'">
                    <xsl:value-of select="substring($dateString,9,2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring($dateString,7,2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="month">
            <xsl:choose>
                <xsl:when test="$inputFormat='yyyy-mm-dd'">
                    <xsl:value-of select="substring($dateString,6,2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring($dateString,5,2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="year" select="substring($dateString,1,4)"/>

        <xsl:variable name="day">
            <xsl:choose>
                <xsl:when test="$month='02' and number($dayIn) &gt; 28">28</xsl:when>
                <xsl:when test="($month='04' or $month='06' or $month='09' or $month='11') and $dayIn='31'">30
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dayIn"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$outputFormat='yyyymmdd'">
                <xsl:value-of select="$year"/><xsl:value-of select="$month"/><xsl:value-of select="$day"/>
            </xsl:when>
            <xsl:when test="$outputFormat='dd-mm-yyyy'"><xsl:value-of select="$day"/>-<xsl:value-of select="$month"/>-<xsl:value-of
                    select="$year"/>
            </xsl:when>
            <xsl:when test="$outputFormat='dd-MMM-yyyy'"><xsl:value-of select="$day"/>-
                <xsl:call-template name="format-date-month">
                    <xsl:with-param name="month" select="$month"></xsl:with-param>
                </xsl:call-template>
                -<xsl:value-of select="$year"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$day"/><xsl:value-of select="$month"/><xsl:value-of select="$year"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- advanced search inputs -->
    <xsl:template name="searchInput">
        <xsl:param name="fieldName" select="'q'"/>
        <xsl:param name="value" select="$searchTerm"/>
        <div class="advancedSearchInput">
            <div>
                <xsl:choose>
                    <xsl:when test="$fieldName='q'">with
                        <strong>all</strong>
                        of the words
                    </xsl:when>
                    <xsl:when test="$fieldName='qp'">with the
                        <strong>exact phrase</strong>
                    </xsl:when>
                    <xsl:when test="$fieldName='qo'">with
                        <strong>any</strong>
                        of the words
                    </xsl:when>
                    <xsl:when test="$fieldName='qe'">
                        <strong>without</strong>
                        the words
                    </xsl:when>
                    <xsl:when test="$fieldName='num'">Number of results:</xsl:when>
                </xsl:choose>
            </div>
            <input type="text" name="{$fieldName}" value="{$value}" class="advancedSearchInputField"/>
        </div>
    </xsl:template>

    <xsl:template name="advancedSearchTextInputs">
        <div class="advancedSearchInputSection" id="advancedSearchTextInputs">
            <xsl:call-template name="searchInput"/>
            <xsl:call-template name="searchInput">
                <xsl:with-param name="fieldName" select="'qp'"/>
                <xsl:with-param name="value" select="$searchTermPhrase"/>
            </xsl:call-template>
            <xsl:call-template name="searchInput">
                <xsl:with-param name="fieldName" select="'qo'"/>
                <xsl:with-param name="value" select="$searchTermOr"/>
            </xsl:call-template>
            <xsl:call-template name="searchInput">
                <xsl:with-param name="fieldName" select="'qe'"/>
                <xsl:with-param name="value" select="$searchTermExclude"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <!-- return a decsriptive version of the resource type contents - used for tooltips and the "displaying..." message -->
    <xsl:template name="resourceTypeDescription">
        <xsl:param name="resourceTypes"/>
        <xsl:choose>
            <xsl:when test="$resourceTypeConfig[name=$resourceTypes]">
                <xsl:value-of select="$resourceTypeConfig[name=$resourceTypes]/pluralName"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- return a decsriptive version of the section contents - used for tooltips and the "displaying..." message -->
    <xsl:template name="sectionDescription">
        <xsl:param name="sections"/>
        <xsl:choose>
            <xsl:when test="$sectionConfig[name=$sections]">
                <xsl:value-of select="$sectionConfig[name=$sections]/pluralName"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- date filter -->
    <xsl:template name="dateFilter">

        <select id="search_filter_date">
            <xsl:if test="string($endDate)=''">
                <xsl:attribute name="name">sd</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="$searchConfig/dateFilter/item">

                <xsl:variable name="currentDays" select="number(substring($currentDateNum,7,2))"/>
                <xsl:variable name="currentMonths" select="number(substring($currentDateNum,5,2))"/>
                <xsl:variable name="currentYears" select="number(substring($currentDateNum,1,4))"/>

                <xsl:variable name="dateValue">
                    <xsl:if test="@value and not(@value='0')">

                        <!-- convert weeks to days -->
                        <xsl:variable name="weekdays" select="self::item[@unit='w']/@value*7"/>

                        <!-- convert days to months, keep what's left -->
                        <xsl:variable name="days">
                            <xsl:choose>
                                <xsl:when test="@unit='d'">
                                    <xsl:value-of select="@value"/>
                                </xsl:when>
                                <xsl:when test="@unit='w'">
                                    <xsl:value-of select="@value*7"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <!-- convert months to years, keep what's left -->
                        <xsl:variable name="months">
                            <xsl:choose>
                                <xsl:when test="@unit='d'">
                                    <xsl:value-of select="floor(@value div 30)"/>
                                </xsl:when>
                                <xsl:when test="@unit='w'">
                                    <xsl:value-of select="floor(@value*7 div 30)"/>
                                </xsl:when>
                                <xsl:when test="@unit='m'">
                                    <xsl:value-of select="@value"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <!-- add up the years -->
                        <xsl:variable name="years">
                            <xsl:choose>
                                <xsl:when test="not(@unit)">
                                    <xsl:value-of select="@value"/>
                                </xsl:when>
                                <xsl:when test="@unit='m'">
                                    <xsl:value-of select="floor(@value div 12)"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <!-- create new bits of the date, checking if it drops below 0 -->

                        <xsl:variable name="newDays">
                            <xsl:if test="($currentDays - $days) &lt; 1">
                                <xsl:value-of select="($currentDays - $days) + (floor($days div 30)+1)*30"/>
                            </xsl:if>
                            <xsl:if test="($currentDays - $days) &gt; 0">
                                <xsl:value-of select="$currentDays - $days"/>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="newMonths">
                            <xsl:if test="$currentMonths - $months &lt; 1">
                                <xsl:value-of
                                        select="($currentMonths - $months) + (floor($months div 12)+1)*12 + number($currentDays - $days &lt; 1)"/>
                            </xsl:if>
                            <xsl:if test="$currentMonths - $months &gt; 0">
                                <xsl:value-of
                                        select="$currentMonths - ($months + number($currentDays - $days &lt; 1))"/>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:variable name="newYears"
                                      select="$currentYears - ($years + number($currentMonths - $months &lt; 1))"/>

                        <xsl:call-template name="dateFormatter">
                            <xsl:with-param name="dateString">
                                <xsl:value-of select="$newYears"/>
                                <xsl:if test="$newMonths &lt; 10">0</xsl:if>
                                <xsl:value-of select="$newMonths"/>
                                <xsl:if test="$newDays &lt; 10">0</xsl:if>
                                <xsl:value-of select="$newDays"/>
                            </xsl:with-param>
                        </xsl:call-template>

                    </xsl:if>
                    <xsl:if test="@value='0'">0</xsl:if>
                </xsl:variable>

                <option>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$dateValue"/>
                    </xsl:attribute>
                    <xsl:if test="($startDate=$dateValue and $endDate='') or ($dateValue='0' and not($endDate=''))">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="@label"/>
                </option>
            </xsl:for-each>

        </select>
        <div id="search_filter_date_range">
            <xsl:if test="$endDate=''">
                <xsl:attribute name="class">hidden</xsl:attribute>
            </xsl:if>
            <span>from</span>
            <input id="date_range_start_display" readonly="readonly" class="calendarWidget"/>
            <span>to</span>
            <input id="date_range_end_display" readonly="readonly" class="calendarWidget"/>
            <input type="hidden" id="date_range_end" name="ed" value="{$endDate}"/>
            <input type="hidden" id="date_range_start" name="sd" value="{$startDate}"/>

        </div>

    </xsl:template>

    <xsl:template name="stripTags">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '&lt;')">
                <xsl:value-of select="substring-before($text, '&lt;')"/>
                <xsl:call-template name="stripTags">
                    <xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getRelative">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, 'practicallaw.com/')">
                <xsl:call-template name="getRelative">
                    <xsl:with-param name="text" select="substring-after($text, 'practicallaw.com/')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pageLinks">
        <xsl:param name="location" select="'1'"/>
        <p class="search-page-links">
            <span>Page</span>
            <br/>
            <xsl:if test="$resultsStartIndex &gt; 0">
                <a href="{$unpaged-url}&amp;start={$resultsStartIndex - $resultsPerPage}"
                   title="Show previous page of results">&lt;</a>
            </xsl:if>
            <xsl:call-template name="searchPage">
                <xsl:with-param name="start" select="1"/>
            </xsl:call-template>
            <xsl:if test="$endIndex &lt; $resultsTotal and $resultsStartIndex &lt; (1000-$resultsPerPage)">
                <a href="{$unpaged-url}&amp;start={$resultsStartIndex +$resultsPerPage}"
                   title="Show next page of results">&gt;</a>
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template name="searchPage">
        <xsl:param name="start"/>
        <xsl:variable name="page" select="$resultsStartIndex div $resultsPerPage + 1"/>
        <xsl:if test="($start &lt; $page +6 or $start &lt; 11) and $start &gt; $page -5">
            <xsl:choose>
                <xsl:when test="$start = $page">
                    <span>
                        <xsl:value-of select="$start"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$unpaged-url}&amp;start={($start -1)*$resultsPerPage}"
                       title="Show page {$start} of results">
                        <xsl:value-of select="$start"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
            &#160;
        </xsl:if>

        <xsl:if test="$start * $resultsPerPage &lt; $resultsTotal and $start &lt; (1000 div $resultsPerPage)">
            <xsl:call-template name="searchPage">
                <xsl:with-param name="start" select="$start+1"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <xsl:template name="urlEncode">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="contains($input,'&amp;')">
                <xsl:call-template name="urlEncode">
                    <xsl:with-param name="input" select="substring-before($input,'&amp;')"/>
                </xsl:call-template>
                <xsl:text disable-output-escaping="yes">%26</xsl:text>
                <xsl:call-template name="urlEncode">
                    <xsl:with-param name="input" select="substring-after($input,'&amp;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="narrowingForm">

        <div id="search_filters">

            <form method="get">
                <xsl:if test="string-length($contentType) &gt; 0">
                    <input type="hidden" name="c" value="{$contentType}"/>
                </xsl:if>
                <xsl:if test="string-length($contentId) &gt; 0">
                    <input type="hidden" name="cid" value="{$contentId}"/>
                </xsl:if>
                <xsl:if test="string-length($fwAction) &gt; 0">
                    <input type="hidden" name="fwaction" value="{$fwAction}"/>
                </xsl:if>
                <xsl:if test="string-length($view) &gt; 0">
                    <input type="hidden" name="view" value="{$view}"/>
                </xsl:if>
                <xsl:if test="string-length($pagename) &gt; 0">
                    <input type="hidden" name="pagename" value="{$pagename}"/>
                </xsl:if>
                <xsl:if test="string-length($childPageName) &gt; 0">
                    <input type="hidden" name="childpagename" value="{$childPageName}"/>
                </xsl:if>

                <xsl:if test="string($advancedSearch) = 'true'">
                    <input type="hidden" name="adv" value="true"/>
                </xsl:if>

                <xsl:if test="not($searchTerm='')">
                    <input type="hidden" name="q" value="{$searchTerm}"/>
                </xsl:if>
                <xsl:if test="not($searchTermPhrase='')">
                    <input type="hidden" name="qp" value="{$searchTermPhrase}"/>
                </xsl:if>
                <xsl:if test="not($searchTermOr='')">
                    <input type="hidden" name="qo" value="{$searchTermOr}"/>
                </xsl:if>
                <xsl:if test="not($searchTermExclude='')">
                    <input type="hidden" name="qe" value="{$searchTermExclude}"/>
                </xsl:if>

                <xsl:if test="count($paramsServices) &gt; 0 and $showServiceFilter = false()">
                    <xsl:variable name="serviceVal">
                        <xsl:for-each select="$paramsServices">
                            <xsl:if test="position() &gt; 1">,</xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:variable>
                    <input type="hidden" name="sv" value="{$serviceVal}"/>
                </xsl:if>

                <xsl:if test="count($paramsResourceTypes) &gt; 0">
                    <xsl:variable name="resourceTypeVal">
                        <xsl:for-each select="$paramsResourceTypes">
                            <xsl:if test="position() &gt; 1">,</xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:variable>
                    <input type="hidden" name="rt" value="{$resourceTypeVal}"/>
                </xsl:if>
                <xsl:if test="count($paramsResourceTypes) = 0 and $currentTab = 'All'">
                    <input type="hidden" name="rt" value="All"/>
                </xsl:if>


                <xsl:if test="not($searchTerm='') or not($searchTermPhrase='') or not($searchTermOr='') or not($searchTermExclude='')">
                    <div class="search-filter">
                        <div class="search-filter-label">Keywords:</div>
                        <div>
                            <xsl:if test="not($searchTerm='')">
                                with all of the words
                                <strong>
                                    <xsl:value-of select="$searchTerm"/>
                                </strong>
                                <br/>
                            </xsl:if>
                            <xsl:if test="not($searchTermPhrase='')">
                                with the exact phrase&#160;
                                <strong>
                                    <xsl:value-of select="$searchTermPhrase"/>
                                </strong>
                                <br/>
                            </xsl:if>
                            <xsl:if test="not($searchTermOr='')">
                                with any of the words
                                <strong>
                                    <xsl:value-of select="$searchTermOr"/>
                                </strong>
                                <br/>
                            </xsl:if>
                            <xsl:if test="not($searchTermExclude='')">
                                without the words
                                <strong>
                                    <xsl:value-of select="$searchTermExclude"/>
                                </strong>
                                <br/>
                            </xsl:if>
                        </div>
                    </div>
                </xsl:if>

                <div class="search-filter">
                    <div class="search-filter-label"><xsl:value-of select="$label-resourceType"/>:
                    </div>
                    <div>
                        <xsl:if test="count($paramsResourceTypes) &gt;0 and not($paramsResourceTypes='')">
                            <xsl:for-each select="$paramsResourceTypes">
                                <xsl:variable name="value" select="."/>
                                <xsl:if test="$facetResourceTypes[id[1]=$value]">
                                    <xsl:if test="position() &gt; 1">
                                        <xsl:choose>
                                            <xsl:when test="position() = count($paramsResourceTypes)">and</xsl:when>
                                            <xsl:otherwise>,</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <strong>
                                        <xsl:value-of select="$facetResourceTypes[id[1]=$value]/name"/>
                                    </strong>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="count($paramsResourceTypes) = 0 or $paramsResourceTypes=''">
                            <xsl:if test="$messagefile/messages/label[@name='allPlcResources']">
                                <strong>
                                    <xsl:value-of select="$messagefile/messages/label[@name='allPlcResources']"
                                                  disable-output-escaping="yes"/>
                                </strong>
                            </xsl:if>
                            <xsl:if test="not($messagefile/messages/label[@name='allPlcResources'])">
                                <xsl:choose>
                                    <xsl:when test="$tabConfig[@key=$currentTab]/description/@filter">
                                        <strong>
                                            <xsl:value-of select="$tabConfig[@key=$currentTab]/description/@filter"/>
                                        </strong>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <strong>all PLC resources</strong>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:if>
                    </div>
                </div>

                <xsl:variable name="filter" select="$searchConfig/serviceFilters/filter[@site=$serviceContext]"/>

                <xsl:if test="(count($paramsServices) &gt;0 and $facetServices[count(id) = count(id[@assetId=$paramsServices or @plcReference=$paramsServices]) and (string-length(id/@assetId) &gt; 0 or string-length(id/@plcReference) &gt; 0)]) or $showServiceFilter=true()">
                    <div class="search-filter">
                        <xsl:variable name="searchedProducts"
                                      select="$facetServices[count(id)=1 and id/@plcReference = $paramsServices]/product"/>

                        <xsl:for-each select="$filter/service">
                            <xsl:variable name="prodcount"/>
                            <xsl:copy-of select="$searchedProducts[count(id)=$prodcount]"/>
                        </xsl:for-each>
                        <div class="search-filter-label">Service:</div>
                        <div>
                            <xsl:if test="$showServiceFilter=true()">
                                <select name="sv" id="search_filter_service">
                                    <xsl:choose>
                                        <xsl:when test="count($filter/service) &gt; 0">

                                            <xsl:for-each select="$filter/service">
                                                <xsl:variable name="id">
                                                    <xsl:for-each select="product">
                                                        <xsl:variable name="product" select="."/>
                                                        <xsl:if test="position()&gt;1">,</xsl:if>
                                                        <xsl:for-each
                                                                select="$facetServices[product=$product]/id/@plcReference">
                                                            <xsl:if test="position()&gt;1">,</xsl:if>
                                                            <xsl:value-of select="."/>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </xsl:variable>

                                                <option value="{$id}">
                                                    <xsl:if test="count(product[.=$searchedProducts]) = count(product) and count(product) = count($searchedProducts)">
                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="siteName=$serviceContext">
                                                        <xsl:attribute name="class">topicOptionHighlight</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="@name"/>
                                                </option>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each
                                                    select="$facetServices[$filter[@type='full'] or siteName=$serviceContext]">
                                                <xsl:sort select="name"/>
                                                <xsl:variable name="serviceId" select="id/@plcReference"/>
                                                <xsl:variable name="product" select="product"/>
                                                <xsl:if test="not($searchConfig/facetConfig[@facet='service']/item[@product = $product and @display='false'])">
                                                    <option value="{$serviceId}">
                                                        <xsl:if test="$paramsServices = $serviceId">
                                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:if test="siteName=$serviceContext">
                                                            <xsl:attribute name="class">topicOptionHighlight
                                                            </xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="name"/>
                                                    </option>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <option value="All">
                                        <xsl:if test="string($paramsServices)='' or string($paramsServices)='All'">
                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="$messagefile/messages/label[@name='allPlcServices']">
                                            <xsl:value-of select="$messagefile/messages/label[@name='allPlcServices']"
                                                          disable-output-escaping="yes"/>
                                        </xsl:if>
                                        <xsl:if test="not($messagefile/messages/label[@name='allPlcServices'])">
                                            all PLC services
                                        </xsl:if>
                                    </option>
                                </select>
                            </xsl:if>
                            <xsl:if test="not($showServiceFilter=true())">
                                <xsl:call-template name="displayText">
                                    <xsl:with-param name="params" select="$paramsServices"/>
                                    <xsl:with-param name="config" select="$facetServices"/>
                                </xsl:call-template>
                            </xsl:if>
                        </div>
                    </div>
                </xsl:if>

                <xsl:if test="count($paramsPracticeAreas) &gt;0  and $facetPracticeAreas[count(id) = count(id[@assetId=$paramsPracticeAreas or @plcReference=$paramsPracticeAreas]) and (string-length(id/@assetId) &gt; 0 or string-length(id/@plcReference) &gt; 0) and (ancestor::service/id/@assetId=$paramsServices or ancestor::service/id/@plcReference=$paramsServices)]">
                    <div class="search-filter">
                        <div class="search-filter-label">Topic:</div>
                        <xsl:call-template name="displayText">
                            <xsl:with-param name="params" select="$paramsPracticeAreas"/>
                            <xsl:with-param name="config" select="$facetPracticeAreas"/>
                            <xsl:with-param name="parent-params" select="$paramsServices"/>
                        </xsl:call-template>
                    </div>
                </xsl:if>

                <xsl:if test="count($paramsJurisdictions) &gt;0  and $facetJurisdictions[count(id) = count(id[@assetId=$paramsJurisdictions or @plcReference=$paramsJurisdictions]) and (string-length(id/@assetId) &gt; 0 or string-length(id/@plcReference) &gt; 0)]">
                    <div class="search-filter">
                        <div class="search-filter-label">Jurisdiction:</div>
                        <div>
                            <xsl:call-template name="displayText">
                                <xsl:with-param name="params" select="$paramsJurisdictions"/>
                                <xsl:with-param name="config" select="$facetJurisdictions"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </xsl:if>

                <xsl:if test="$tabConfig[@key=$currentTab]/dateFilter='true'">
                    <div class="search-filter">
                        <div class="search-filter-label">Date:</div>
                        <div>
                            <xsl:call-template name="dateFilter"/>
                        </div>
                    </div>
                </xsl:if>

            </form>
        </div>

    </xsl:template>

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
                <xsl:if test="$resultsTotal &gt; $resourceCount">
                    <xsl:choose>
                        <xsl:when test="$resourceCount &gt; $resultsPerPage">
                            <p>Showing
                                <strong>
                                    <xsl:value-of select="$resultsStartIndex + 1"/>
                                </strong>
                                -
                                <strong>
                                    <xsl:value-of select="$resourceCount"/>
                                </strong>
                            </p>
                        </xsl:when>
                        <xsl:otherwise>
                            <p>Showing
                                <strong>
                                    <xsl:value-of select="$resultsStartIndex + 1"/>
                                </strong>
                                -
                                <strong>
                                    <xsl:value-of select="$endIndex"/>
                                </strong>
                            </p>
                            <xsl:call-template name="pageLinks"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </div>

            <xsl:call-template name="narrowingForm"/>

            <!--<xsl:if test="$searchParams/resultsCount &gt; 0"> (limited to <strong><xsl:value-of select="$searchParams/resultsCount"/></strong> results)</xsl:if>-->

        </xsl:if>

    </xsl:template>

    <xsl:template name="displayText">
        <xsl:param name="params"/>
        <xsl:param name="config"/>
        <xsl:param name="parent-params"/>

        <xsl:variable name="mappedParams"
                      select="$config[count(id) = count(id[.=$params or @assetId=$params or @plcReference=$params]) and (string-length(id) &gt; 0 or string-length(id/@assetId)&gt;0 or string-length(id/@plcReference)&gt;0)]"/>
        <xsl:variable name="mappedSuperParams" select="$mappedParams[count(id)&gt;1]"/>
        <xsl:variable name="intersectedParams"
                      select="$mappedParams[not(id[string-length(.)&gt;0]=$mappedSuperParams/id or id/@assetId[string-length(.)&gt;0] = $mappedSuperParams/id/@assetId or id/@plcReference[string-length(.)&gt;0] = $mappedSuperParams/id/@plcReference)]|$mappedSuperParams"/>
        <xsl:variable name="validParams"
                      select="$intersectedParams[ancestor::*/id = $parent-params or ancestor::*/id/@assetId = $parent-params or ancestor::*/id/@plcReference = $parent-params or not($parent-params)]"/>

        <xsl:for-each select="$validParams">
            <xsl:sort select="name"/>
            <xsl:if test="position()&gt;1 and position() &lt; count($intersectedParams)">,</xsl:if>
            <xsl:if test="position()&gt;1 and position() = count($intersectedParams)">and</xsl:if>
            <strong>
                <xsl:value-of select="name"/>
            </strong>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="advancedSearchTips">
        <xsl:param name="class"/>
        <div id="advancedSearchTips">
            <xsl:attribute name="class">searchTips
                <xsl:value-of select="$class"/>
            </xsl:attribute>
            <iframe class="shimIframe" frameborder="0" src="about:blank">&#160;</iframe>
            <div class="shimDiv">
                <xsl:value-of select="$messagefile/messages/message[@name='advancedSearchTips']"
                              disable-output-escaping="yes"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="searchTips">
        <xsl:param name="class"/>
        <div id="searchTips">
            <xsl:attribute name="class">searchTips
                <xsl:value-of select="$class"/>
            </xsl:attribute>
            <iframe class="shimIframe" frameborder="0" src="about:blank">&#160;</iframe>
            <div class="shimDiv">
                <xsl:value-of disable-output-escaping="yes" select="$messagefile/messages/message[@name='searchTips']"/>
            </div>
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

    <xsl:template match="resultColumns">
        <tr class="results-header">
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="column[text()='icon' or text()='index']">
        <td class="result-col-icon">&#160;</td>
    </xsl:template>

    <xsl:template match="column[text()='title']">
        <td>
            <xsl:if test="$fullSorting=true()">
                <xsl:choose>
                    <xsl:when
                            test="$searchTerm='' and $searchTermPhrase='' and $searchTermExclude='' and $searchTermOr=''">
                        <xsl:call-template name="sort-link">
                            <xsl:with-param name="label" select="'Title'"/>
                            <xsl:with-param name="value" select="'title'"/>
                            <xsl:with-param name="reorder" select="true()"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="sort-link">
                            <xsl:with-param name="value" select="'title'"/>
                            <xsl:with-param name="reorder" select="true()"/>
                            <xsl:with-param name="label" select="'Title'"/>
                        </xsl:call-template>
                        /
                        <xsl:call-template name="sort-link"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$fullSorting=false()">Title /
                <xsl:call-template name="sort-link"/>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template match="column[text()='resourceType']">
        <td>
            <xsl:if test="$fullSorting=true()">
                <xsl:call-template name="sort-link">
                    <xsl:with-param name="value" select="'rt'"/>
                    <xsl:with-param name="label" select="'Resource type'"/>
                    <xsl:with-param name="reorder" select="true()"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$fullSorting=false()">Resource type</xsl:if>
        </td>
    </xsl:template>

    <xsl:template match="column[text()='date']">
        <td>
            <xsl:if test="$fullSorting=true()">
                <xsl:call-template name="sort-link">
                    <xsl:with-param name="value" select="'date'"/>
                    <xsl:with-param name="label" select="'Date'"/>
                    <xsl:with-param name="reorder" select="true()"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$fullSorting=false()">
                <xsl:call-template name="sort-link">
                    <xsl:with-param name="value" select="'date'"/>
                    <xsl:with-param name="label" select="'Date'"/>
                </xsl:call-template>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template match="column[text()='firm']">
        <td>Firm</td>
    </xsl:template>

    <xsl:template match="column">
        <td>&#160;</td>
    </xsl:template>

    <xsl:template match="column" mode="results">
        <xsl:param name="result"/>
        <xsl:variable name="colType" select="text()"/>
        <xsl:apply-templates select="$result/title[$colType='title']">
            <xsl:with-param name="rowType" select="position() mod 2"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$result/resourceTypeList[$colType='resourceType']"/>
        <xsl:apply-templates select="$result/publicationDate[$colType='date']"/>
        <xsl:apply-templates select="$result/mimeType[$colType='icon']"/>
        <xsl:apply-templates select="$result/ldPortalFirm[$colType='firm']"/>
    </xsl:template>

    <xsl:template match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']">
        <xsl:variable name="rowClass">
            <xsl:if test="not(position() mod 2 = 0)">result-row-alt</xsl:if>
            <xsl:if test="resourceTypeList/resourceType='9-103-2005'">result-row-highlight</xsl:if>
        </xsl:variable>
        <tr>
            <xsl:if test="string-length($rowClass)&gt;0">
                <xsl:attribute name="class">
                    <xsl:value-of select="$rowClass"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$columnConfig = 'index'">
                <td class="result-col-index">
                    <xsl:value-of select="position()+$resultsStartIndex"/>
                </td>
            </xsl:if>
            <xsl:apply-templates select="$columnConfig" mode="results">
                <xsl:with-param name="result" select="."/>
            </xsl:apply-templates>
        </tr>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/title">
        <xsl:param name="rowType"/>
        <xsl:variable name="result" select="parent::*"/>
        <xsl:variable name="resType" select="$result/resourceTypeList/resourceType"/>
        <xsl:variable name="isFd" select="string($result/fdLink)='true' or not(string($result/fdProxyId)='')"/>
        <xsl:variable name="abstract" select="$result/abstract"/>
        <xsl:variable name="id" select="$result/id"/>

        <xsl:variable name="products" select="$result/productList/product"/>

        <!-- what a beautiful test for pubportal docs -->
        <xsl:variable name="isPubPortal"
                      select="contains($resType,'PORTALPUB') or contains($resType,'portalpubweblink') or (count($products) = 1 and $products = 'PLC Law Department Portal')"></xsl:variable>

        <!-- remove assembler logic when meta tag available -->

        <xsl:variable name="formattedAssetId"><xsl:value-of select="substring($result/id,1,4)"/>-<xsl:value-of
                select="substring($result/id,5,4)"/>-<xsl:value-of select="substring($result/id,9,5)"/>
        </xsl:variable>
        <!--<xsl:variable name="assetUrl">?pagename=PLCWrapper&amp;c=PLC_Doc_C&amp;cid=<xsl:value-of select="$result/id"/></xsl:variable>-->
        <!--<xsl:variable name="resource-url">/<xsl:choose><xsl:when test="string-length($result/plcReference)&gt;0"><xsl:value-of select="$result/plcReference"/></xsl:when><xsl:otherwise><xsl:value-of select="$formattedAssetId"/></xsl:otherwise></xsl:choose></xsl:variable>-->

        <xsl:variable name="resource-url">
            <xsl:if test="$isPubPortal = true()">http://ldportal.practicallaw.com/</xsl:if>
            <xsl:choose>
                <xsl:when test="string-length($result/plcReference)&gt;0">/<xsl:value-of select="$result/plcReference"/>
                </xsl:when>
                <xsl:otherwise>/<xsl:value-of select="$formattedAssetId"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="columnAbstract" select="$columnConfig[text()='title']/@abstract"/>
        <!--<xsl:variable name="forceAbstract" select="$columnConfig[text()='title']/@forceAbstract='true'"/>-->
        <xsl:variable name="inlineAbstract"
                      select="$abstractDisplay = 'inline' or ($abstractDisplay='' and $columnAbstract='inline')"/>

        <td>
            <xsl:variable name="link-class">
                topicLink resource-id:<xsl:value-of select="$result/id"/>
                <!--<xsl:if test="(not($columnAbstract='inline') and not($abstractDisplay='inline' or $abstractDisplay='none')) or $abstractDisplay='tooltip' or ($columnAbstract='tooltip' and $forceAbstract=true())">-->
                <xsl:if test="(not($columnAbstract='inline') and not($abstractDisplay='inline' or $abstractDisplay='none')) or $abstractDisplay='tooltip'">
                    <xsl:if test="$resType='1-103-0963'">metadata-target:glossitem</xsl:if>
                    <xsl:if test="not($resType='1-103-0963')">metadata-target:article</xsl:if>
                </xsl:if>
            </xsl:variable>

            <!-- Additional path to be put in Resource URL links for Blocks pages using new resource page -->
            <xsl:variable name="extra-url-resource-path" select="$extraResourceUrlPath"/>

            <a class="{$link-class}"
               href="{$extra-url-resource-path}{$resource-url}?q={$searchTermUrlEncoded}&amp;qp={$searchTermPhraseUrlEncoded}&amp;qo={$searchTermOrUrlEncoded}&amp;qe={$searchTermExcludeUrlEncoded}">
                <xsl:if test="not($abstract='null' or $abstract='') and not($abstractDisplay='inline' or $abstractDisplay='none')">
                    <xsl:attribute name="id">metadata-preload:<xsl:value-of select="generate-id()"/>:<xsl:value-of
                            select="$id"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="string-length($result/metaTitle) &gt; 0 and string-length($result/mimeType) &gt; 0">
                        <xsl:value-of select="$result/metaTitle"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="google-keyword"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$isFd=true()">
                    <span class="search-result-fastdraft">
                        <xsl:comment/>
                    </span>
                </xsl:if>
            </a>

            <xsl:if test="not($abstract='null' or $abstract='')">
                <div id="metadata:{generate-id()}:{$id}">
                    <!--<xsl:if test="$columnAbstract='inline' or ($abstractDisplay='inline' and not($columnAbstract='tooltip' and $forceAbstract=true()))">-->
                    <xsl:if test="$columnAbstract='inline' or $abstractDisplay='inline'">
                        <xsl:attribute name="class">inlineMetadata</xsl:attribute>
                    </xsl:if>
                    <!--<xsl:if test="not($inlineAbstract) or ($columnAbstract='tooltip' and $forceAbstract=true())">-->
                    <xsl:if test="not($inlineAbstract)">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$abstract"/>
                </div>
            </xsl:if>
        </td>
    </xsl:template>

    <!-- for displaying the xml google keywords -->
    <xsl:template match="title" mode="google-keyword">
        <xsl:apply-templates mode="google-keyword"/>
    </xsl:template>

    <xsl:template match="metaTitle" mode="google-keyword">
        <xsl:apply-templates mode="google-keyword"/>
    </xsl:template>

    <xsl:template match="b" mode="google-keyword">
        <b>
            <xsl:value-of select="."/>
        </b>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/resourceTypeList">
        <xsl:variable name="result" select="parent::*"/>
        <!--<xsl:variable name="resType">
            <xsl:choose>
                <xsl:when test="not(string($result/sectionFolders/sectionFolderDetails/sectionFolderName)='')">
                    <xsl:value-of select="$result/sectionFolders/sectionFolderDetails[not(sectionFolderName='Features' and count(parent::sectionFolders/sectionFolderDetails)&gt;1)]/sectionFolderName"/>
                </xsl:when>
                <xsl:when test="not(string($result/resourceTypeFolderList/resourceTypeFolder)='') and not(.='PORTALPUB')"><xsl:value-of select="$result/resourceTypeFolderList/resourceTypeFolder"/></xsl:when>
                <xsl:when test="not(string(.)='')"><xsl:value-of select="."/></xsl:when>
                <xsl:when test="not(string($result/documentType)='')"><xsl:value-of select="$result/documentType"/></xsl:when>
            </xsl:choose>
        </xsl:variable>-->
        <td>
            <xsl:attribute name="class">result-col-resource
                <xsl:if test=".='Practice note: overview'">result-col-highlight</xsl:if>
            </xsl:attribute>
            <xsl:call-template name="resourceTypeDescription">
                <xsl:with-param name="resourceTypes" select="resourceType"/>
            </xsl:call-template>
        </td>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'resourceItem' or name(.) = 'document' or name(.) = 'handbookResourceItem']/publicationDate">
        <xsl:variable name="maintained" select="parent::*/maintained"/>
        <xsl:variable name="displayDate" select="parent::*/displayDate"/>
        <td>
            <xsl:attribute name="class">result-col-date
                <xsl:if test="$maintained='true'">maintained</xsl:if>
            </xsl:attribute>
            <xsl:if test="$maintained='true'">Maintained</xsl:if>
            <xsl:if test="not(parent::*/sortDateStr = '19700101') and not($maintained='true')">
                <xsl:choose>
                    <xsl:when test="not(string($displayDate)='')">
                        <xsl:value-of select="$displayDate"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="dateFormatter">
                            <xsl:with-param name="dateString" select="."/>
                            <xsl:with-param name="inputFormat" select="'yyyy-mm-dd'"/>
                            <xsl:with-param name="outputFormat" select="'dd-MMM-yyyy'"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/mimeType[text() = 'application/pdf']">
        <td class="icon-pdf">&#160;</td>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/mimeType[text() = 'application/msword']">
        <td class="icon-word">&#160;</td>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/mimeType">
        <td class="icon-url">&#160;</td>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/ldPortalFirm">
        <td class="result-col-firm">
            <xsl:if test="string(.)=''">PLC</xsl:if>
            <xsl:value-of select="."/>
        </td>
    </xsl:template>

    <xsl:template match="resultTabs">
        <div id="tabs">
            <xsl:apply-templates select="$tabConfig"/>
        </div>
    </xsl:template>

    <xsl:template match="tab">

        <xsl:variable name="tabName">
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
            <xsl:choose>
                <xsl:when test="facet/@name='sf'">
                    <xsl:if test="count($facetSectionFolders[name=$name]/id) &gt; 0 and string-length(facet) = 0">
                        <xsl:for-each select="$facetSectionFolders[name=$name]/id">
                            <xsl:if test="position() &gt; 1">,</xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="count($facetSectionFolders[name=$name]/id) = 0 or string-length(facet) &gt; 0">All
                    </xsl:if>
                </xsl:when>
                <xsl:when test="string-length(facet) &gt; 0 and not(facet/@name='sf')">
                    <xsl:value-of select="facet"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="count($facetResourceTypes[name=$name]/id) &gt; 0">
                        <xsl:for-each select="$facetResourceTypes[name=$name]/id">
                            <xsl:if test="position() &gt; 1">,</xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="count($facetResourceTypes[name=$name]/id) = 0">All</xsl:if>
                </xsl:otherwise>
            </xsl:choose>
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
                            <xsl:if test="not($plcPageType='search')">
                                <xsl:if test="defaultOrder='-1'">&amp;isasc=0</xsl:if>
                                <xsl:if test="string-length(defaultSort)&gt;0">&amp;sort=<xsl:value-of
                                        select="defaultSort"/>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="not(string($tabVal)='')">&amp;<xsl:value-of select="$facet"/>=<xsl:value-of
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
            <a href="mailto:feedback@practicallaw.com?subject=Search feedback&amp;body=Username: {$username}%0DUser email: {$userEmail}%0DSearch query: {$searchQueryString}%0D%0D%0D%0DPlease tell us what you wanted to find"
               class="search-feedback-link" title="Send us feedback about these results">Did you find what you were
                looking for?
            </a>
        </xsl:if>

    </xsl:template>

    <xsl:template match="resultsMetaData">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="keymatchList[count(keymatch) &gt; 0]">
        <div class="search-results-keymatch">
            <p>Related topics:</p>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="keymatchList/keymatch">
        <xsl:variable name="relUrl">
            <xsl:call-template name="getRelative">
                <xsl:with-param name="text" select="keymatchUrl"/>
            </xsl:call-template>
        </xsl:variable>
        <a href="/{$relUrl}" class="searchSponsoredLink">
            <xsl:value-of select="keymatchDescription"/>
        </a>
        <br/>
    </xsl:template>

    <xsl:template match="spellingList[count(spelling) &gt; 0]">
        <div class="search-results-suggestion">
            <span>Did you mean:</span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="spellingList/spelling">
        <xsl:variable name="href">
            <xsl:value-of select="$base-url"/><xsl:value-of select="$service-url"/><xsl:value-of
                select="$resourcetype-url"/>&amp;start=<xsl:value-of select="$resultsStartIndex"/>&amp;q=
            <xsl:call-template name="stripTags">
                <xsl:with-param name="text" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <a href="{$href}">
            <xsl:value-of select="." disable-output-escaping="yes"/>
        </a>
    </xsl:template>

    <xsl:template match="synonymList[count(synonym) &gt; 0]">
        <div class="search-results-suggestion">
            <p>
                <span>You could also try:</span>
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </p>
        </div>
    </xsl:template>

    <xsl:template match="synonymList/synonym">
        <xsl:variable name="href">
            <xsl:value-of select="$base-url"/><xsl:value-of select="$service-url"/><xsl:value-of
                select="$resourcetype-url"/>&amp;start=<xsl:value-of select="$resultsStartIndex"/>&amp;q=
            <xsl:call-template name="stripTags">
                <xsl:with-param name="text" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <li>
            <a href="{$href}">
                <xsl:value-of select="." disable-output-escaping="yes"/>
            </a>
        </li>
    </xsl:template>

    <xsl:template name="sort-link">
        <xsl:param name="value"/>
        <xsl:param name="label" select="'Relevance'"/>
        <xsl:param name="reorder"/>

        <xsl:variable name="sortMatch" select="string($sortOrder) = string($value)"/>

        <xsl:variable name="linkClass">
            <xsl:if test="$isasc=false()">results-sorted-desc</xsl:if>
            <xsl:if test="$isasc=true()">results-sorted-asc</xsl:if>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$sortMatch = true() and not($reorder=true())">
                <span class="{$linkClass}">
                    <xsl:value-of select="$label"/>
                </span>
            </xsl:when>
            <xsl:when test="(not($sortMatch=true()) or $reorder=true()) and $sortable = true()">
                <!-- SC 15/12/09 - added condition to make the default for date sorting descending. This should be in configuration really -->
                <xsl:variable name="link-url">
                    <xsl:value-of select="$unsorted-url"/>
                    <xsl:if test="$value">&amp;sort=<xsl:value-of select="$value"/>
                    </xsl:if>
                    <xsl:if test="($isasc=true() and ($sortMatch=true() or $label='Title')) or ($sortMatch=false() and $label='Date' and $reorder=true())">
                        &amp;isasc=0
                    </xsl:if>
                </xsl:variable>
                <a href="{$link-url}" title="Sort results by {$label}">
                    <xsl:if test="$sortMatch = true()">
                        <xsl:attribute name="class">
                            <xsl:value-of select="$linkClass"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$label"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:value-of select="$label"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
