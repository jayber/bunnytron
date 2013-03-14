<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="topic_components.xsl"/>
    <!-- plc reference of the jurisdiction being rendered as a country page -->
    <xsl:param name="juPlcref"/>
    <xsl:param name="locale"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:template match="/serviceList">
        <div id="topic_tree_content">
            <xsl:apply-templates select="service[siteName='gld']/practiceAreaList/practiceArea[not(name)='']"
                                 mode="country-topic-index">
                <xsl:sort select="name"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="practiceArea" mode="country-topic-index">
        <xsl:variable name="childTopics" select="practiceAreaList[@country=$juPlcref or not(@country)]/practiceArea"/>
        <xsl:variable name="parentTopics" select="ancestor::practiceArea/plcReference[string-length(.)&gt;0]"/>

        <!-- assemble the query string -->
        <xsl:variable name="topicFilters">
            <xsl:for-each select="$parentTopics">
                <xsl:if test="position()&gt;1">,</xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="queryString">?ju=<xsl:value-of select="$juPlcref"/>
            <xsl:if test="count($parentTopics)&gt;0">&amp;su_filter=<xsl:value-of select="$topicFilters"/>
            </xsl:if>
        </xsl:variable>

        <div class="topic-tree-collapsed">
            <div>
                <xsl:attribute name="class">topic-tree-branch
                    <xsl:if test="$childTopics">topic-tree-branch-expanded</xsl:if>
                    <xsl:if test="not($childTopics)">topic-tree-leaf</xsl:if>
                </xsl:attribute>
                <xsl:if test="$childTopics">
                    <xsl:value-of select="name"/>
                </xsl:if>
                <xsl:if test="not($childTopics)">
                    <a class="topic-tree-link metadata-target:topic" href="{$topic-url}{plcReference}{$queryString}">
                        <xsl:value-of select="name"/>
                    </a>
                </xsl:if>
            </div>
            <xsl:if test="$childTopics">
                <div class="topic-tree-group">
                    <xsl:apply-templates select="$childTopics[not(name)='']" mode="country-topic-index">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </div>
    </xsl:template>


</xsl:stylesheet>
    