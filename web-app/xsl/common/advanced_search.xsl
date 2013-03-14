<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="/search/searchResults/detail" mode="advanced-search">
        <div class="content-inner">
            <h1>Advanced search (beta)</h1>
            <xsl:variable name="standard-search-url">/?view=cselement:PLC/Search/SearchTips</xsl:variable>
            <a href="{$standard-search-url}" id="standard_search_link">Standard search</a>

            <form action="/" id="advanced_search_form">
                <xsl:if test="string-length($pagename) &gt; 0">
                    <input type="hidden" name="pagename" value="{$pagename}"/>
                </xsl:if>
                <xsl:if test="string-length($childPageName) &gt; 0">
                    <input type="hidden" name="childpagename" value="{$childPageName}"/>
                </xsl:if>
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
                <input type="hidden" name="adv" value="true"/>

                <div id="advanced_search_form_controls">
                    <p>Find results</p>
                    <div class="advanced-search-input">
                        <div class="advanced-search-input-label">with
                            <strong>all</strong>
                            of the words
                        </div>
                        <input type="text" name="q" value='{$searchTerm}' class="advanced-search-input-field"/>
                    </div>
                    <div class="advanced-search-input">
                        <div class="advanced-search-input-label">with the
                            <strong>exact phrase</strong>
                        </div>
                        <input type="text" name="qp" value='{$searchTermPhrase}' class="advanced-search-input-field"/>
                    </div>
                    <div class="advanced-search-input">
                        <div class="advanced-search-input-label">with
                            <strong>any</strong>
                            of the words
                        </div>
                        <input type="text" name="qo" value='{$searchTermOr}' class="advanced-search-input-field"/>
                    </div>
                    <div class="advanced-search-input">
                        <div class="advanced-search-input-label">
                            <strong>without</strong>
                            the words
                        </div>
                        <input type="text" name="qe" value='{$searchTermExclude}' class="advanced-search-input-field"/>
                    </div>
                </div>

                <div id="advanced_search_tips">
                    <iframe class="shim" frameborder="0" src="about:blank">&#160;</iframe>
                    <div class="shim">
                        <xsl:value-of select="$messagefile/messages/message[@name='advancedSearchTips']"
                                      disable-output-escaping="yes"/>
                    </div>
                </div>

                <div class="separator">&#160;</div>
                <xsl:apply-templates select="$serviceList" mode="advanced-search"/>
                <xsl:apply-templates select="$resourceTypeList" mode="advanced-search"/>
                <xsl:apply-templates select="$jurisdictionList" mode="advanced-search"/>
                <div class="separator">&#160;</div>
            </form>
            <input type="button" id="advanced_search_submit" class="button button-positive" value="Search"/>
        </div>
    </xsl:template>

    <xsl:template match="serviceList" mode="advanced-search">

        <!-- should the filter be rendered open? -->
        <xsl:variable name="filterOpen">
            <!-- search not run yet -->
            <xsl:if test="string($newSearch) = 'true'">
                <!-- service is selected from the site -->
                <xsl:if test="$facetServices[siteName = $serviceContext]">1</xsl:if>
                <!-- default option -->
                <xsl:if test="$searchConfig/facetConfig[@facet='service']/item[@default = 'true']">2</xsl:if>
            </xsl:if>
            <!-- search run -->
            <xsl:if test="count($paramsServices|$paramsPracticeAreas) &gt; 0">3</xsl:if>
        </xsl:variable>

        <xsl:variable name="filterClass">advanced-search-filter
            <xsl:if test="not($filterOpen='')">advanced-search-filter-expanded</xsl:if>
        </xsl:variable>

        <div id="advanced_search_filter_sv" class="{$filterClass}">
            <a href="#null" class="advanced-search-filter-link">
                Services and topics -
                <span>
                    <span class="filter-collapsed">show</span>
                    <span class="filter-expanded">hide</span>
                    all services and topics
                </span>
            </a>
            <a class="advanced-search-select-link" href="#null">Select/deselect all</a>
            <div id="advanced_search_sv" class="advanced-search-filter advanced-search-priority">
                <xsl:apply-templates select="service" mode="advanced-search">
                    <xsl:with-param name="params" select="$paramsServices"/>
                    <xsl:with-param name="child-params" select="$paramsPracticeAreas"/>
                    <xsl:sort select="translate(name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="practiceAreaList" mode="advanced-search">
        <xsl:param name="allSelected"/>
        <xsl:variable name="selectedDescendants">
            <xsl:for-each select="descendant::*[not(id/@assetId='')]">
                <xsl:if test="count(id) = count(id[@assetId=$paramsPracticeAreas]) and count(id[@assetId=$paramsPracticeAreas]) &gt; 0">
                    <xsl:value-of select="id/@assetId"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="filterClass">advanced-search-filter
            <xsl:if test="not($selectedDescendants='')">advanced-search-filter-expanded</xsl:if>
        </xsl:variable>

        <div class="{$filterClass}">
            <xsl:apply-templates select="child::practiceArea" mode="advanced-search">
                <xsl:with-param name="facetData" select="$facetServices"/>
                <xsl:with-param name="params" select="$paramsPracticeAreas"/>
                <xsl:with-param name="parent-params" select="$paramsServices"/>
                <xsl:with-param name="allSelected" select="$allSelected"/>
                <xsl:sort select="translate(name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="resourceTypeList" mode="advanced-search">

        <!-- should the filter be rendered open? -->
        <xsl:variable name="filterOpen">
            <!-- search not run yet -->
            <xsl:if test="string($newSearch) = 'true'">
                <!-- default option -->
                <xsl:if test="$searchConfig/facetConfig[@facet='resourceType']/item[@default = 'true']">2</xsl:if>
            </xsl:if>
            <!-- search run -->
            <xsl:if test="count($paramsResourceTypes) &gt; 0">3</xsl:if>
        </xsl:variable>

        <xsl:variable name="filterClass">advanced-search-filter
            <xsl:if test="not($filterOpen='')">advanced-search-filter-expanded</xsl:if>
        </xsl:variable>

        <div id="advanced_search_filter_rt" class="{$filterClass}">
            <a href="#null" class="advanced-search-filter-link">
                Resource types -
                <span>
                    <span class="filter-collapsed">show</span>
                    <span class="filter-expanded">hide</span>
                    all resource types
                </span>
            </a>
            <a class="advanced-search-select-link" href="#null">Select/deselect all</a>

            <xsl:if test="$searchConfig/facetConfig[@facet='resourceType']/item/@priority">
                <div id="advanced_search_priority_rt" class="advanced-search-filter advanced-search-priority">
                    <xsl:apply-templates select="resourceType" mode="advanced-search">
                        <xsl:with-param name="params" select="$paramsResourceTypes"/>
                        <xsl:with-param name="priority" select="true()"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>

            <div id="advanced_search_rt" class="advanced-search-filter">
                <xsl:apply-templates select="resourceType" mode="advanced-search">
                    <xsl:with-param name="params" select="$paramsResourceTypes"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="jurisdictionList" mode="advanced-search">

        <!-- should the filter be rendered open? -->
        <xsl:variable name="filterOpen">
            <!-- search not run yet -->
            <xsl:if test="string($newSearch) = 'true'">
                <!-- default option -->
                <xsl:if test="$searchConfig/facetConfig[@facet='jurisdiction']/item[@default = 'true']">2</xsl:if>
            </xsl:if>
            <!-- search run -->
            <xsl:if test="count($paramsJurisdictions) &gt; 0">3</xsl:if>
        </xsl:variable>

        <xsl:variable name="filterClass">advanced-search-filter
            <xsl:if test="not($filterOpen='')">advanced-search-filter-expanded</xsl:if>
        </xsl:variable>

        <div id="advanced_search_filter_ju" class="{$filterClass}">
            <a href="#null" class="advanced-search-filter-link">
                Jurisdictions -
                <span>
                    <span class="filter-collapsed">show</span>
                    <span class="filter-expanded">hide</span>
                    all jurisdictions
                </span>
            </a>
            <a class="advanced-search-select-link" href="#null">Select/deselect all</a>
            <xsl:if test="$searchConfig/facetConfig[@facet='jurisdiction']/item/@priority and jurisdiction[string-length(id)&gt;0 or string-length(id/@assetId)&gt;0]">
                <div id="advanced_search_priority_ju" class="advanced-search-filter advanced-search-priority">
                    <xsl:apply-templates select="jurisdiction" mode="advanced-search">
                        <xsl:with-param name="params" select="$paramsJurisdictions"/>
                        <xsl:with-param name="priority" select="true()"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
            <div class="advanced-search-jumpers" id="advanced_search_jumper_ju">
                <a href="#null" class="jumperLink">Top</a>
                <a href="#null">A</a>
                <a href="#null">B</a>
                <a href="#null">C</a>
                <a href="#null">D</a>
                <a href="#null">E</a>
                <a href="#null">F</a>
                <a href="#null">G</a>
                <a href="#null">H</a>
                <a href="#null">I</a>
                <a href="#null">J</a>
                <a href="#null">K</a>
                <a href="#null">L</a>
                <a href="#null">M</a>
                <a href="#null">N</a>
                <a href="#null">O</a>
                <a href="#null">P</a>
                <a href="#null">Q</a>
                <a href="#null">R</a>
                <a href="#null">S</a>
                <a href="#null">T</a>
                <a href="#null">U</a>
                <a href="#null">V</a>
                <a href="#null">W</a>
                <a href="#null">X</a>
                <a href="#null">Y</a>
                <a href="#null">Z</a>
            </div>
            <xsl:if test="jurisdiction[string-length(id)&gt;0 or string-length(id/@assetId)&gt;0]">
                <div id="advanced_search_ju" class="advanced-search-filter advanced-search-filter-fixed">
                    <xsl:apply-templates select="jurisdiction" mode="advanced-search">
                        <xsl:with-param name="params" select="$paramsJurisdictions"/>
                        <xsl:sort select="translate(name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template
            match="node()[name() = 'service' or name() = 'practiceArea' or name() = 'resourceType' or name() = 'jurisdiction']"
            mode="advanced-search">
        <xsl:param name="params"/>
        <xsl:param name="child-params"/>
        <xsl:param name="parent-params"/>
        <xsl:param name="priority" select="false()"/>
        <xsl:param name="allSelected" select="false()"/>

        <xsl:variable name="facetNode" select="."/>

        <xsl:variable name="concat_id">
            <xsl:for-each select="id">
                <xsl:if test="position()&gt;1">,</xsl:if>
                <xsl:if test="@assetId">
                    <xsl:value-of select="@assetId"/>
                </xsl:if>
                <xsl:if test="not(@assetId)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="name" select="name"/>
        <xsl:variable name="facetName" select="name(.)"/>
        <xsl:variable name="facetConfig" select="$searchConfig/facetConfig[@facet=$facetName]/item"/>

        <xsl:variable name="input-id" select="generate-id()"/>

        <xsl:if test="not($facetConfig[@name=$name and @display='false']) and (($priority = false() and not($facetConfig[@name = $name and @priority = 'true'])) or ($priority = true() and $facetConfig[@name = $name and @priority = 'true']))">

            <xsl:variable name="paList" select="child::practiceAreaList"/>
            <xsl:variable name="ident">
                <xsl:choose>
                    <xsl:when test="$facetName='service'">sv</xsl:when>
                    <xsl:when test="$facetName='practiceArea'">pa</xsl:when>
                    <xsl:when test="$facetName='resourceType'">rt</xsl:when>
                    <xsl:when test="$facetName='jurisdiction'">ju</xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ancestorService" select="ancestor::service"/>

            <xsl:variable name="nodeSelected"
                          select="(count(id) = count(id[.=$params or @assetId=$params]) and count(id[.=$params or @assetId=$params]) &gt; 0)"/>

            <xsl:variable name="defaultSelected"
                          select="string($newSearch) = 'true' and ($serviceContext = siteName or $facetConfig[@name=$name and @default = 'true'])"/>

            <xsl:variable name="ancestorDefaultSelected"
                          select="string($newSearch) = 'true' and ($ancestorService/siteName = $serviceContext or $facetConfig[@name=ancestorService/name and @default = 'true'])"/>
            <!-- SC - if new search and ancestor selected by default, select it -->

            <xsl:variable name="selectedDescendants">
                <xsl:for-each select="descendant::*[string-length(id)&gt;0 and not(id/@assetId)]">
                    <xsl:if test="count(id) = count(id[.=$params or .=$child-params]) and count(id) &gt; 0">
                        <xsl:value-of select="id"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="descendant::*[string-length(id/@assetId)&gt;0]">
                    <xsl:if test="count(id) = count(id[@assetId=$params or @assetId=$child-params]) and count(id) &gt; 0">
                        <xsl:value-of select="id/@assetId"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="descendantSelected" select="not($selectedDescendants='')"/>

            <xsl:variable name="unselectedAncestor"
                          select="(count(ancestor::*[string-length(id/@assetId) &gt; 0 and id/@assetId=$parent-params]) = 0) and $ancestorDefaultSelected = false()"/>

            <xsl:variable name="isChecked"
                          select="$allSelected = true() or ($nodeSelected = true() and $unselectedAncestor = false()) or $defaultSelected = true() or $ancestorDefaultSelected = true() or (string-length(id/@assetId)=0 and $descendantSelected = true())"/>

            <xsl:variable name="filterClass">advanced-search-filter-el
                <xsl:if test="not(parent::*/child::*/child::*/child::*)">advanced-search-filter-el-col</xsl:if>
                <xsl:if test="$nodeSelected = true() and $descendantSelected = true()">
                    advanced-search-filter-el-expanded
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="inputClass">advanced-search
                <xsl:if test="child::*/child::*">-parent</xsl:if>
                <xsl:if test="parent::*/parent::*">-child</xsl:if>
            </xsl:variable>

            <div class="{$filterClass}">
                <xsl:if test="$isChecked=true()">
                    <input class="{$inputClass}" type="checkbox" id="{$ident}_{$input-id}" name="{$ident}"
                           value="{$concat_id}" checked="checked"/>
                </xsl:if>
                <xsl:if test="$isChecked=false()">
                    <input class="{$inputClass}" type="checkbox" id="{$ident}_{$input-id}" name="{$ident}"
                           value="{$concat_id}"/>
                </xsl:if>
                <xsl:if test="$paList/practiceArea">
                    <a href="#null" class="advanced-search-filter-link">
                        <xsl:value-of select="name"/> -
                        <span>show/hide<xsl:if test="$facetName='practiceArea'">sub-</xsl:if>topics
                        </span>
                    </a>
                    <a class="advanced-search-select-link" href="#null">Select/deselect all</a>
                </xsl:if>
                <xsl:if test="not($paList/practiceArea)">
                    <label for="{$ident}_{$input-id}">
                        <xsl:value-of select="name"/>
                    </label>
                </xsl:if>

                <xsl:apply-templates select="$paList[practiceArea]" mode="advanced-search">
                    <xsl:with-param name="params" select="$paramsPracticeAreas"/>
                    <xsl:with-param name="allSelected" select="$isChecked = true() and $descendantSelected = false()"/>
                </xsl:apply-templates>
            </div>

        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
