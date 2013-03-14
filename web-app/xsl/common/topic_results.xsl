<?xml version="1.0" encoding="UTF-8"?>
<!-- Common -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="search_components.xsl"/>
    <xsl:import href="topic_components.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:param name="topicId"/>
    <xsl:param name="serviceContext"/>

    <xsl:variable name="plcPageType" select="'topic'"/>
    <xsl:variable name="fullSorting" select="true()"/>

    <xsl:variable name="showServiceFilter" select="true()"/>

    <xsl:variable name="abstractDisplay" select="'tooltip'"/>

    <xsl:template match="/">

        <xsl:variable name="topicNode"
                      select="$serviceList/service[$serviceContext=siteName or count($serviceList/service[$serviceContext=siteName])=0]/practiceAreaList/practiceArea[id/@assetId=$topicId]"/>
        <xsl:choose>
            <xsl:when test="count($topicNode/practiceAreaList/practiceArea) &gt; 0">
                <div id="content_topic_index" class="content-inner">
                    <h2>Sub-topics</h2>
                    <xsl:if test="count($topicNode)=1">
                        <xsl:apply-templates select="$topicNode/practiceAreaList" mode="topic-index">
                            <xsl:sort select="name"/>
                        </xsl:apply-templates>
                    </xsl:if>
                    <xsl:if test="count($topicNode)&gt;1">
                        <xsl:apply-templates
                                select="$serviceList/service[practiceAreaList/practiceArea[id/@assetId=$topicId]]"
                                mode="sub-topic-list">
                            <xsl:with-param name="topicId" select="$topicId"/>
                            <xsl:sort select="name"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </div>
            </xsl:when>
            <xsl:otherwise>
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
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="service" mode="sub-topic-list">
        <xsl:param name="topicId"/>

        <h3>
            <xsl:value-of select="name"/>
        </h3>
        <xsl:apply-templates select="descendant::practiceArea[contains(id/@assetId,$topicId)]/practiceAreaList"
                             mode="topic-index"/>
    </xsl:template>

</xsl:stylesheet>
