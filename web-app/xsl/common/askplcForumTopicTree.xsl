<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="serviceContext"/>
    <xsl:param name="resourceType"/>
    <xsl:param name="product"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:template match="serviceList">
        <h2 class="title">Browse queries by topic</h2>

        <div class="topic_tree_content">
            <xsl:choose>
                <xsl:when test="service[siteName=$serviceContext]/practiceAreaList/practiceArea">
                    <xsl:apply-templates select="service[siteName=$serviceContext]/practiceAreaList/practiceArea"
                                         mode="topicList">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <p>There is no topic available</p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="practiceArea" mode="topicList">
        <xsl:variable name="childTopics" select="practiceAreaList/practiceArea[not(name)='' and not(id)='']"/>
        <xsl:if test="not($childTopics)">
            <div class="topic-tree-collapsed">
                <div class="topic-tree-branch topic-tree-leaf">
                    <a class="topic-tree-link"
                       href='/resourcetype{$resourceType}?pa={id/@plcReference}&amp;sv={$product}'>
                        <xsl:value-of select="name"/>
                    </a>
                </div>
            </div>
        </xsl:if>
        <xsl:if test="$childTopics"> <!-- has child topic, do recursion -->
            <div class="topic-tree-collapsed">
                <div class="topic-tree-branch topic-tree-branch-expanded">
                    <xsl:value-of select="name"/>
                </div>
                <div class="topic-tree-group">
                    <xsl:if test="id/@plcReference"><!--current note has plcref, display it as first child note-->
                        <div class="topic-tree-collapsed">
                            <div class="topic-tree-branch topic-tree-leaf">
                                <a class="topic-tree-link"
                                   href='/resourcetype{$resourceType}?pa={id/@plcReference}&amp;sv={$product}'>
                                    <xsl:value-of select="name"/>
                                </a>
                            </div>
                        </div>
                    </xsl:if>
                    <xsl:apply-templates select="$childTopics" mode="topicGroup">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceArea" mode="topicGroup">
        <div class="topic-tree-collapsed">
            <div class="topic-tree-branch topic-tree-leaf">
                <a class="topic-tree-link" href='/resourcetype{$resourceType}?pa={id/@plcReference}&amp;sv={$product}'>
                    <xsl:value-of select="name"/>
                </a>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>