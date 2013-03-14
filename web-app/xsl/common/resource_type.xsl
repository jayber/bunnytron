<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="search_components.xsl"/>

    <xsl:variable name="plcPageType" select="'resource-type'"/>

    <xsl:variable name="results" select="/search/searchResults/detail/document"/>
    <xsl:variable name="subjectAreas" select="$results/practiceAreaList/practiceArea"/>
    <xsl:variable name="abstractDisplay" select="'none'"/>

    <xsl:key name="resourceType" match="document" use="resourceType"/>

    <xsl:template match="/">
        <div class="content-results">
            <xsl:apply-templates select="/search/searchResults/detail"/>
        </div>
    </xsl:template>

    <xsl:template match="resultColumns"/>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:choose>
                <!-- If Topic filter (pa) specified in URL -->
                <xsl:when test="count($paramsPracticeAreas) &gt; 0">
                    <xsl:for-each
                            select="$paramsPracticeAreas[(.=$facetPracticeAreas/id/@assetId or .=$facetPracticeAreas/id/@plcReference)and .=$subjectAreas]">
                        <xsl:variable name="topic" select="."/>
                        <div class="results-section-header">
                            <xsl:value-of
                                    select="$facetPracticeAreas[id/@assetId=$topic or id/@plcReference=$topic]/name"/>
                        </div>
                        <div class="results-section">
                            <table>
                                <xsl:apply-templates select="$results[practiceAreaList/practiceArea=$topic]">
                                    <xsl:sort select="name" order="ascending"/>
                                </xsl:apply-templates>
                            </table>
                        </div>
                    </xsl:for-each>
                    <xsl:if test="count($results)=0">
                        <div class="results-section-header">No resources found</div>
                    </xsl:if>
                </xsl:when>

                <!-- If Service filter (sv) specified in URL -->
                <xsl:when test="count($paramsServices) &gt; 0">
                    <xsl:apply-templates
                            select="$facetServices[./id/@plcReference = $paramsServices]">
                    </xsl:apply-templates>
                </xsl:when>

                <!-- If neither Topic filter (pa) nor Service filter (sv) specified in URL -->
                <xsl:otherwise>
                    <!-- Process each service in taxonomy file with a Practice Area...? -->
                    <xsl:apply-templates
                            select="$facetServices[descendant::practiceArea/id/@assetId=$subjectAreas or descendant::practiceArea/id/@plcReference=$subjectAreas]">
                        <xsl:sort select="name" order="ascending"/>
                    </xsl:apply-templates>
                    <!-- Final section for each topic not in taxonomy file -->
                    <xsl:if test="$results[not(practiceAreaList/practiceArea=$subjectAreas)]">
                        <div class="results-section-header">Other resources</div>
                        <div class="results-section-content">
                            <table>
                                <xsl:apply-templates
                                        select="$results[not(practiceAreaList/practiceArea=$subjectAreas)]">
                                    <xsl:sort select="name" order="ascending"/>
                                </xsl:apply-templates>
                            </table>
                        </div>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="service">
        <xsl:if test="count(practiceAreaList/practiceArea[(id/@assetId=$subjectAreas and string-length(id/@assetId)&gt;0) or (id/@plcReference=$subjectAreas and string-length(id/@plcReference)&gt;0)])&gt;0">
            <div class="results-section-header">
                <xsl:value-of select="name"/>
            </div>
            <div class="results-section-content">
                <xsl:apply-templates
                        select="practiceAreaList/practiceArea[(id/@assetId=$subjectAreas and string-length(id/@assetId)&gt;0) or (id/@plcReference=$subjectAreas and string-length(id/@plcReference)&gt;0)]">
                    <xsl:sort select="name" order="ascending"/>
                </xsl:apply-templates>
            </div>
        </xsl:if>
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

    <xsl:template match="practiceArea">
        <xsl:variable name="subjectAreaId" select="id/@assetId"/>
        <xsl:variable name="subjectAreaPlcRef" select="id/@plcReference"/>
        <div class="results-section">
            <div class="results-section-content">
                <div class="results-section-header">
                    <xsl:value-of select="name"/>
                </div>
                <xsl:apply-templates
                        select="practiceAreaList/practiceArea[id/@assetId=$subjectAreas or id/@plcReference=$subjectAreas]"/>
                <xsl:if test="$results[practiceAreaList/practiceArea=$subjectAreaId or practiceAreaList/practiceArea=$subjectAreaPlcRef]">
                    <table>
                        <xsl:apply-templates
                                select="$results[practiceAreaList/practiceArea=$subjectAreaId or practiceAreaList/practiceArea=$subjectAreaPlcRef]">
                            <xsl:sort select="title" order="ascending"/>
                        </xsl:apply-templates>
                    </table>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="practiceArea[parent::practiceAreaList/parent::practiceArea]">
        <xsl:variable name="subjectAreaId" select="id/@assetId"/>
        <xsl:variable name="subjectAreaPlcRef" select="id/@plcReference"/>
        <div class="results-section-content">
            <div class="results-section-header">
                <xsl:value-of select="name"/>
            </div>
            <table>
                <xsl:apply-templates
                        select="$results[practiceAreaList/practiceArea=$subjectAreaId or practiceAreaList/practiceArea=$subjectAreaPlcRef]">
                    <xsl:sort select="title" order="ascending"/>
                </xsl:apply-templates>
            </table>
        </div>
    </xsl:template>

</xsl:stylesheet>
