<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="../common/topic_results.xsl"/>
    <xsl:include href="common.xsl"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:param name="topicId"/>

    <xsl:template match="/">

        <xsl:variable name="topicNode"
                      select="$serviceList/service/practiceAreaList/practiceArea[id/@assetId=$topicId]"/>
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
                                mode="topic-index">
                            <xsl:with-param name="topicId" select="$paramsPracticeAreas"/>
                            <xsl:sort select="name"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(string($newSearch) = 'true')">
                    <!-- show the results -->
                    <div>
                        <xsl:apply-templates select="/search/searchResults/detail"/>
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="searchResults/detail">
        <xsl:if test="$resourceCount &gt; 0">
            <table>
                <xsl:apply-templates select="document"/>
            </table>
        </xsl:if>
    </xsl:template>

    <xsl:template match="resultTabs"/>

    <xsl:template match="resultsMetaData"/>

    <xsl:variable name="topic-url">/?pagename=PLC/PLC_P/GoogleResourceDetail&amp;c=PLC_P&amp;cid=</xsl:variable>

    <xsl:template match="practiceArea" mode="topic-index">
        <li>
            <xsl:if test="practiceAreaList/practiceArea">
                <h3>
                    <xsl:value-of select="name"/>
                </h3>
                <xsl:apply-templates select="practiceAreaList" mode="topic-index"/>
            </xsl:if>
            <xsl:if test="not(practiceAreaList/practiceArea)">
                <a href="{$topic-url}{id/@assetId}">
                    <xsl:value-of select="name"/>
                </a>
            </xsl:if>
        </li>
    </xsl:template>

</xsl:stylesheet>
