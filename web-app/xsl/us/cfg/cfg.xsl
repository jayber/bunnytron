<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

    <xsl:import href="../../common/cfg/cfg.xsl"/>

    <xsl:variable name="resourcefile" select="document('../../../cfg/us/resource.xml')"/>
    <xsl:variable name="messagefile" select="document('../../../cfg/us/messages.xml')"/>

    <!-- loaded from main xsls - hence different path -->
    <xsl:variable name="local-config-path" select="'../../cfg/us/'"/>
    <xsl:variable name="facet-data-resource-types-path"
                  select="concat($local-config-path,'facet-data-resource-types.xml')"/>
    <xsl:variable name="facet-data-section-folders-path"
                  select="concat($local-config-path,'facet-data-section-folders.xml')"/>
    <xsl:variable name="resourceTypeConfig-path" select="concat($local-config-path,'resourceTypeConfig.xml')"/>
    <xsl:variable name="sectionConfig-path" select="concat($local-config-path,'sectionConfig.xml')"/>

    <!-- determine whether links displayed on us site-->
    <xsl:variable name="primarysourceon" select="document('../../../cfg/psconfig.xml')/psconfig/uslinkson"/>

</xsl:stylesheet>