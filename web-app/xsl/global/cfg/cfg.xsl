<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

    <xsl:import href="../../common/cfg/cfg.xsl"/>

    <xsl:variable name="resourcefile" select="document('../../../cfg/global/resource.xml')"/>
    <xsl:variable name="messagefile" select="document('../../../cfg/global/messages.xml')"/>

    <!-- loaded from main xsls - hence different path -->
    <xsl:variable name="local-config-path" select="'../../cfg/global/'"/>
    <xsl:variable name="facet-data-resource-types-path"
                  select="concat($local-config-path,'facet-data-resource-types.xml')"/>
    <xsl:variable name="facet-data-section-folders-path"
                  select="concat($local-config-path,'facet-data-section-folders.xml')"/>
    <xsl:variable name="resourceTypeConfig-path" select="concat($local-config-path,'resourceTypeConfig.xml')"/>
    <xsl:variable name="sectionConfig-path" select="concat($local-config-path,'sectionConfig.xml')"/>

</xsl:stylesheet>