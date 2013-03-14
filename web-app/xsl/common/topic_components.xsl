<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:variable name="topic-url">/topic</xsl:variable>

    <xsl:template match="serviceList" mode="topic-index">
        <div id="topic_index_content" class="content-inner">
            <xsl:apply-templates select="service" mode="topic-index">
                <xsl:sort select="name"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="service" mode="topic-index">
        <xsl:param name="topicId"/>
        <xsl:variable name="product" select="product"/>
        <xsl:variable name="hidden"
                      select="$resourcefile/page-resource/searchConfig/facetConfig[@facet='service']/item[@display='false' and @product = $product]"/>
        <xsl:if test="not($hidden) and practiceAreaList/practiceArea">
            <h3>
                <xsl:value-of select="name"/>
            </h3>
            <xsl:apply-templates
                    select="child::practiceAreaList[(parent::service and string($topicId)='') or parent::practiceArea[contains(id/@assetId,$topicId)]]"
                    mode="topic-index"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceAreaList" mode="topic-index">
        <xsl:if test="practiceArea">
            <ul>
                <xsl:apply-templates select="practiceArea" mode="topic-index">
                    <xsl:sort select="name"/>
                </xsl:apply-templates>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceArea" mode="topic-index">
        <li>
            <xsl:if test="practiceAreaList/practiceArea">
                <h4>
                    <xsl:value-of select="name"/>
                </h4>
                <xsl:apply-templates select="practiceAreaList" mode="topic-index"/>
            </xsl:if>
            <xsl:if test="not(practiceAreaList/practiceArea)">
                <a href="{$topic-url}{id/@plcReference}">
                    <xsl:value-of select="name"/>
                </a>
            </xsl:if>
        </li>
    </xsl:template>

</xsl:stylesheet>