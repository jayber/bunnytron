<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="search_components.xsl"/>

    <xsl:variable name="plcPageType" select="'section'"/>

    <xsl:template match="/">
        <div class="content-results">
            <xsl:apply-templates select="/search/searchResults/detail"/>
        </div>
    </xsl:template>

    <xsl:template match="resultColumns"/>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:if test="$resourceCount &gt; 0">
                <table>
                    <xsl:apply-templates select="$columnConfigObj"/>

                    <xsl:variable name="results"
                                  select="document[resourceTypeList/resourceType=$resourceTypeConfig/name]"/>

                    <xsl:for-each select="$resourceTypeConfig">
                        <xsl:sort select="sortOrder" data-type="number"/>

                        <xsl:if test="name = $results/resourceTypeList/resourceType">
                            <xsl:variable name="sortResourceType" select="name"/>
                            <xsl:if test="count($results[resourceTypeList/resourceType = $sortResourceType])&gt;0">
                                <tr>
                                    <td colspan="{count($columnConfig)}" class="search-group-header">
                                        <xsl:value-of select="pluralName"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:apply-templates select="$results[resourceTypeList/resourceType=$sortResourceType]">
                                <xsl:sort select="resourceType"/>
                                <xsl:sort select="title" order="ascending"/>
                            </xsl:apply-templates>
                        </xsl:if>

                    </xsl:for-each>

                    <xsl:apply-templates select="$results[not(resourceTypeList/resourceType=$resourceTypeConfig/name)]"
                                         mode="unsorted">
                        <xsl:sort
                                select="number(maintained = 'true')*1000000000 + (number(not(maintained = 'true')))*number(sortDateStr)"
                                data-type="number" order="descending"/>
                        <xsl:sort select="title[not(parent::resourceItem/maintained = 'false')]" order="ascending"/>
                    </xsl:apply-templates>

                </table>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="document">
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

    <xsl:template match="document" mode="unsorted">
        <xsl:if test="count(. | key('resourceType',resourceType)[1]) = 1">
            <tr>
                <td colspan="{count($columnConfig)}" class="search-group-header">
                    <xsl:call-template name="resourceTypeDescription">
                        <xsl:with-param name="resourceTypes" select="resourceTypeList/resourceType"/>
                    </xsl:call-template>
                </td>
            </tr>
        </xsl:if>
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

</xsl:stylesheet>
