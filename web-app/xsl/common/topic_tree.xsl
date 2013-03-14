<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:param name="serviceContext"/>
    <xsl:param name="topicId"/>
    <xsl:param name="topicParameters"/>

    <xsl:variable name="topic-url">/topic</xsl:variable>

    <xsl:template match="serviceList">

        <xsl:variable name="serviceTree"
                      select="count(service[siteName=$serviceContext and descendant::practiceArea[id/@assetId=$topicId]]) &gt; 0"/>

        <div class="content-inner">
            <div class="content-meta-header">
                <xsl:choose>
                    <xsl:when test="$serviceTree">
                        <xsl:value-of select="service[siteName=$serviceContext]/name"/> topic index
                    </xsl:when>
                    <xsl:otherwise>Topic index</xsl:otherwise>
                </xsl:choose>
            </div>
            <div id="topic_tree_content" style="position:relative">
                <xsl:if test="$serviceTree">
                    <a class="topic-index-link" href="#null">Show full topic index</a>
                </xsl:if>
                <xsl:apply-templates select="service">
                    <xsl:sort select="name"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="serviceList/service">
        <xsl:variable name="contextTopic"
                      select="parent::serviceList/service[siteName=$serviceContext and descendant::practiceArea[id/@assetId=$topicId]]"/>
        <xsl:variable name="hasOutOfContextTopic" select="not(siteName=$serviceContext) and $contextTopic=true()"/>
        <xsl:if test="practiceAreaList/practiceArea">
            <div>
                <xsl:if test="not(descendant::practiceArea[id/@assetId=$topicId]) or $hasOutOfContextTopic=true()">
                    <xsl:attribute name="class">topic-tree-collapsed
                        <xsl:if test="$hasOutOfContextTopic=true()">topic-tree-hidden</xsl:if>
                    </xsl:attribute>
                </xsl:if>
                <div>
                    <xsl:attribute name="class">topic-tree-branch
                        <xsl:if test="practiceAreaList/practiceArea">topic-tree-branch-expanded</xsl:if>
                        <xsl:if test="not(practiceAreaList/practiceArea)">topic-tree-leaf</xsl:if>
                    </xsl:attribute>
                    <strong>
                        <xsl:value-of select="name"/>
                    </strong>
                </div>
                <xsl:if test="practiceAreaList/practiceArea">
                    <div>
                        <xsl:attribute name="class">topic-tree-group</xsl:attribute>
                        <xsl:apply-templates select="practiceAreaList/practiceArea">
                            <xsl:sort select="name"/>
                        </xsl:apply-templates>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceAreaList/practiceArea">
        <div>
            <xsl:if test="not(descendant-or-self::practiceArea[id/@assetId=$topicId])">
                <xsl:attribute name="class">topic-tree-collapsed</xsl:attribute>
            </xsl:if>
            <div>
                <xsl:attribute name="class">topic-tree-branch
                    <xsl:if test="practiceAreaList/practiceArea">topic-tree-branch-expanded</xsl:if>
                    <xsl:if test="not(practiceAreaList/practiceArea)">topic-tree-leaf</xsl:if>
                    <xsl:if test="id/@assetId=$topicId">topic-tree-highlight</xsl:if>
                </xsl:attribute>
                <xsl:if test="practiceAreaList/practiceArea">
                    <xsl:value-of select="name"/>
                </xsl:if>
                <xsl:if test="not(practiceAreaList/practiceArea)">
                    <a class="topic-tree-link metadata-target:topic"
                       href="{$topic-url}{id/@plcReference}{$topicParameters}">
                        <xsl:value-of select="name"/>
                    </a>
                </xsl:if>
            </div>
            <xsl:if test="practiceAreaList/practiceArea">
                <div class="topic-tree-group">
                    <xsl:apply-templates select="practiceAreaList/practiceArea">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet>
