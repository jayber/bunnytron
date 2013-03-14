<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/topic_components.xsl"/>

    <xsl:param name="serviceContext"/>
    <xsl:param name="topicId"/>
    <xsl:param name="topicParameters"/>

    <xsl:template match="/">
        <xsl:apply-templates select="serviceList" mode="topic-index"/>
    </xsl:template>

</xsl:stylesheet>