<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="serviceContext"/>
    <xsl:param name="resourceType"/>
    <xsl:param name="product"/>
    <xsl:param name="productSeparator"/>

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

    <xsl:variable name="productsUrlParam">
        <xsl:call-template name="UrlMultiParam">
            <xsl:with-param name="key" select="'sv'"/>
            <xsl:with-param name="values" select="$product"/>
            <xsl:with-param name="valuesSeparator" select="$productSeparator"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:template match="serviceList">
        <ul class="expandable-tree">
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
        </ul>
    </xsl:template>

    <xsl:template match="practiceArea" mode="topicList">
        <xsl:variable name="childTopics" select="practiceAreaList/practiceArea[not(name)='' and not(id)='']"/>
        <xsl:if test="not($childTopics)">
            <li>
                <a href='/resourcetype{$resourceType}?pa={id/@plcReference}{$productsUrlParam}'>
                    <xsl:value-of select="name"/>
                </a>
            </li>
        </xsl:if>
        <xsl:if test="$childTopics"> <!-- has child topic, do recursion -->
            <li class="expandable">
                <xsl:value-of select="name"/>
                <ul>
                    <xsl:if test="id/@plcReference"><!--current note has plcref, display it as first child note-->
                        <li>
                            <a href='/resourcetype{$resourceType}?pa={id/@plcReference}{$productsUrlParam}'>
                                <xsl:value-of select="name"/>
                            </a>
                        </li>
                    </xsl:if>
                    <xsl:apply-templates select="$childTopics" mode="topicGroup">
                        <xsl:sort select="name"/>
                    </xsl:apply-templates>
                </ul>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceArea" mode="topicGroup">
        <li>
            <a href='/resourcetype{$resourceType}?pa={id/@plcReference}{$productsUrlParam}'>
                <xsl:value-of select="name"/>
            </a>
        </li>
    </xsl:template>


    <xsl:template name="UrlMultiParam">
        <xsl:param name="key"/>
        <xsl:param name="values"/>
        <xsl:param name="valuesSeparator"/>
        <xsl:choose>
            <xsl:when test="contains($values,$valuesSeparator)">
                <xsl:value-of select="concat('&amp;',$key,'=',substring-before($values,$valuesSeparator))"/>
                <xsl:call-template name="UrlMultiParam">
                    <xsl:with-param name="key" select="$key"/>
                    <xsl:with-param name="values" select="substring-after($values,$valuesSeparator)"/>
                    <xsl:with-param name="valuesSeparator" select="$valuesSeparator"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('&amp;',$key,'=',$values)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>