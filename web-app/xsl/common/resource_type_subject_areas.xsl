<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="topic_components.xsl"/>
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="resourceTypeId"/>

    <xsl:template match="practiceArea" mode="topic-index">
        <li>
            <xsl:if test="practiceAreaList/practiceArea">
                <h3>
                    <xsl:value-of select="name"/>
                </h3>
                <xsl:apply-templates select="practiceAreaList" mode="topic-index"/>
            </xsl:if>
            <xsl:if test="not(practiceAreaList/practiceArea)">
                <a href="/resourcetype{$resourceTypeId}?pa={id/@assetId}">
                    <xsl:value-of select="name"/>
                </a>
            </xsl:if>
        </li>
    </xsl:template>

</xsl:stylesheet>