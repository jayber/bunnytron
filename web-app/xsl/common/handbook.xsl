<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- COMMON/HANDBOOK -->

    <xsl:import href="search_components.xsl"/>
    <xsl:import href="advanced_search.xsl"/>
    <xsl:import href="topic_components.xsl"/>

    <xsl:param name="stupidFakeSearchResults"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:variable name="plcPageType" select="'handbook'"/>
    <xsl:variable name="fullSorting" select="true()"/>

    <xsl:variable name="abstractDisplay" select="'none'"/>

    <xsl:variable name="results" select="/search/searchResults/detail/document"/>

    <xsl:key name="resourceTypeList" match="document" use="resourceTypeList/resourceType"/>

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
        <xsl:variable name="showLawyerProfiles"
                      select="(count($paramsResourceTypes)=0 and count($paramsSectionFolders)=0) or $paramsSectionFolders='1-103-1986'"/>
        <div id="search_results">
            <xsl:if test="$resourceCount &gt; 0 or (count($stupidFakeSearchResults/root/lawyerList/descendant::tr)&gt;0 and $showLawyerProfiles=true())">

                <table>
                    <xsl:apply-templates select="$columnConfigObj"/>

                    <!--<xsl:variable name="sectionResults" select="$results[sectionList/section=$sectionConfig/name]"/>-->

                    <xsl:for-each select="$sectionConfig">
                        <xsl:sort select="sortOrder" data-type="number"/>
                        <xsl:variable name="sectionName" select="name"/>

                        <xsl:if test="count($results[sectionList/section=$sectionName])&gt;0">
                            <tr>
                                <td colspan="{count($columnConfig)}" class="search-group-header">
                                    <xsl:value-of select="pluralName"/>
                                </td>
                            </tr>

                            <xsl:apply-templates select="$results[sectionList/section = $sectionName]">
                                <xsl:sort select="resourceType"/>
                                <xsl:sort select="title" order="ascending"/>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:for-each>

                    <!-- SC 07/09/2009 - don't show any resources that aren't coded to a section in the section config -->

                    <!--<xsl:for-each select="$resourceTypeConfig">
                        <xsl:sort select="sortOrder" data-type="number"/>
                        <xsl:variable name="resourceTypeName" select="name"></xsl:variable>
                        
                        <xsl:if test="count($results[not(sectionList/section=$sectionConfig/name) and resourceTypeList/resourceType =$resourceTypeName])&gt;0">
                            <tr>
                                <td colspan="{count($columnConfig)}" class="search-group-header"><xsl:value-of select="pluralName"/></td>
                            </tr>    
                            <xsl:apply-templates select="$results[resourceTypeList/resourceType = $resourceTypeName and not(sectionList/section=$sectionConfig/name)]">
                                <xsl:sort select="resourceType"/>
                                <xsl:sort select="title" order="ascending"/>
                            </xsl:apply-templates>
                        </xsl:if>
                        
                    </xsl:for-each>
                    
                    <xsl:if test="$results[count(sectionList/section[.=$sectionConfig/name])=0 and count(resourceTypeList/resourceType[.=$resourceTypeConfig/name])=0]">
                        <tr>
                            <td colspan="{count($columnConfig)}" class="search-group-header">Other resources</td>
                        </tr>
                        
                        <xsl:apply-templates select="$results[count(sectionList/section[.=$sectionConfig/name])=0 and count(resourceTypeList/resourceType[.=$resourceTypeConfig/name])=0]">
                            <xsl:sort select="title" order="ascending"/>
                        </xsl:apply-templates>
                    </xsl:if>-->

                    <xsl:if test="$showLawyerProfiles=true()">
                        <xsl:apply-templates select="$stupidFakeSearchResults/root/lawyerList" mode="lawyer-profiles"/>
                    </xsl:if>

                </table>
            </xsl:if>

        </div>
    </xsl:template>

    <xsl:template match="document/resourceTypeList">
        <xsl:variable name="result" select="parent::*"/>
        <td>
            <xsl:attribute name="class">result-col-resource
                <xsl:if test=".='9-103-2005'">result-col-highlight</xsl:if>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$result/sectionList/section =$sectionConfig/name">
                    <xsl:call-template name="sectionDescription">
                        <xsl:with-param name="sections" select="$result/sectionList/section"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="resourceTypeDescription">
                        <xsl:with-param name="resourceTypes" select="resourceType"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </td>
    </xsl:template>

    <xsl:template match="document" mode="unsorted-section">
        <xsl:variable name="sections" select="sectionList/section"/>
        <xsl:variable name="resourceTypes" select="resourceTypeList/resourceType"/>

        <xsl:choose>
            <xsl:when test="count($sections)&gt;0">
                <xsl:if test="count(. | key('section',$sections[not(.='Features')])[1]) = 1">
                    <xsl:if test="(count($sections[not(.='Features')]) = 0 and . = key('section',$sections[.='Features'])[count($sections[not(.='Features')])=0][1]) or count($sections[not(.='Features')]) &gt; 0">
                        <tr>
                            <td colspan="{count($columnConfig)}" class="search-group-header">
                                <xsl:call-template name="sectionDescription">
                                    <xsl:with-param name="sections" select="sectionList/section"/>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>

                <xsl:if test="count(. | key('resourceTypeList',$resourceTypes)[1]) = 1">
                    <tr>
                        <td colspan="{count($columnConfig)}" class="search-group-header">
                            <xsl:call-template name="resourceTypeDescription">
                                <xsl:with-param name="resourceTypes" select="resourceTypeList/resourceType"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <tr>
            <xsl:if test="not(position() mod 2 = 0)">
                <xsl:attribute name="class">result-row-alt</xsl:attribute>
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

    <xsl:template match="lawyerList" mode="lawyer-profiles">
        <xsl:if test="count(descendant::tr)&gt;0">
            <xsl:if test="not($paramsSectionFolders='Lawyer profiles')">
                <tr>
                    <td colspan="{count($columnConfig)}" class="search-group-header">Lawyer profiles</td>
                </tr>
            </xsl:if>
            <xsl:apply-templates select="descendant::tr" mode="lawyer-profiles">
                <xsl:sort select="name"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tr" mode="lawyer-profiles">
        <tr>
            <xsl:if test="not(position() mod 2 = 0)">
                <xsl:attribute name="class">result-row-alt</xsl:attribute>
            </xsl:if>
            <xsl:if test="$columnConfig = 'index'">
                <td class="result-col-index">
                    <xsl:value-of select="position()+$resultsStartIndex"/>
                </td>
            </xsl:if>
            <xsl:variable name="id" select="normalize-space(td[@class='lawyerprofile-id'])"/>
            <td>
                <a href="http://whichlawyer.practicallaw.com/resource.do?item={$id}">
                    <xsl:value-of select="td[@class='lawyerprofile-name']"/>
                </a>
            </td>
            <td class="result-col-resource">Lawyer profiles</td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
