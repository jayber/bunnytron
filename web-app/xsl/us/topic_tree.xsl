<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- US/TOPIC_TREE -->
    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/topic_tree.xsl"/>

    <xsl:variable name="topic-tree-config" select="$resourcefile/page-resource/searchConfig/topicTree"/>
    <xsl:variable name="service-topic-tree" select="$topic-tree-config/item[@site=$serviceContext]"/>
    <xsl:variable name="shown-services" select="$topic-tree-config/item[@show='true']"/>

    <xsl:variable name="serviceList" select="serviceList"/>
    <xsl:variable name="services" select="$serviceList/service"/>

    <xsl:variable name="context-service" select="$services[siteName=$serviceContext]"/>
    <xsl:variable name="context-service-full" select="$service-topic-tree/@type='full'"/>

    <xsl:template match="serviceList">

        <xsl:variable name="serviceTree"
                      select="count(service[siteName=$serviceContext and descendant::practiceArea[id/@assetId=$topicId]]) &gt; 0"/>

        <div class="content-inner">
            <div class="content-meta-header">
                <xsl:choose>
                    <xsl:when test="$serviceTree or $service-topic-tree/@type='full'">
                        <xsl:value-of select="service[siteName=$serviceContext]/name"/> Topic Index
                    </xsl:when>
                    <xsl:otherwise>Topic Index</xsl:otherwise>
                </xsl:choose>
            </div>
            <div id="topic_tree_content" style="position:relative">

                <xsl:if test="$serviceTree = false()">
                    <xsl:attribute name="class">topic-tree-unfiltered</xsl:attribute>
                </xsl:if>

                <xsl:if test="$serviceTree and not($service-topic-tree/@type='full')">
                    <a class="topic-index-link" href="#null">Show full topic index</a>
                </xsl:if>
                <!--<xsl:apply-templates select="service">
                    <xsl:sort select="name"/>
                    </xsl:apply-templates>-->

                <xsl:variable name="tree-service-config" select="$topic-tree-config/item[@show='true']"/>
                <xsl:variable name="tree-services" select="service[siteName=$tree-service-config/@site]"/>
                <xsl:variable name="tree-topics" select="service[not(.=$tree-services)]/practiceAreaList/practiceArea"/>

                <xsl:variable name="tree-items" select="$tree-services|$tree-topics"/>

                <xsl:apply-templates select="$tree-items">
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
            <xsl:variable name="class">
                <xsl:if test="siteName=$serviceContext">topic-tree-service</xsl:if>
                <xsl:if test="not(descendant::practiceArea[id/@assetId=$topicId]) or $hasOutOfContextTopic=true()">
                    topic-tree-collapsed
                    <xsl:if test="$hasOutOfContextTopic=true() and not($context-service-full)">topic-tree-hidden
                    </xsl:if>
                </xsl:if>
            </xsl:variable>
            <div class="{$class}">
                <div>
                    <xsl:attribute name="class">topic-tree-branch
                        <xsl:if test="siteName=$serviceContext">topic-tree-service-branch</xsl:if>
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

        <xsl:variable name="is-in-context-service" select="ancestor::service=$context-service"/>
        <xsl:variable name="service-is-shown" select="ancestor::service[siteName=$shown-services/@site]"/>

        <xsl:variable name="is-hidden"
                      select="$service-is-shown = false() and $is-in-context-service = false() and $context-service-full = false() and count($context-service) &gt; 0"/>

        <xsl:variable name="class">
            <xsl:if test="not(descendant-or-self::practiceArea[id/@assetId=$topicId])">topic-tree-collapsed</xsl:if>
            <xsl:if test="$is-hidden = true()">topic-tree-hidden</xsl:if>
        </xsl:variable>

        <div>

            <xsl:if test="string-length($class)&gt;0">
                <xsl:attribute name="class">
                    <xsl:value-of select="$class"/>
                </xsl:attribute>
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
