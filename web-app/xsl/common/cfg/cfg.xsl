<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="../global-variables.xsl"/>

    <xsl:variable name="common-messagefile" select="document('../../../cfg/common-messages.xml')"/>
    <xsl:variable name="primarysourceon" select="document('../../../cfg/psconfig.xml')/psconfig/commonlinkson"/>
    <xsl:variable name="display-direct-link"
                  select="document('../../../cfg/psconfig.xml')/psconfig/display_direct_link"/>
    <xsl:variable name="cases-popup" select="document('../../../cfg/psconfig.xml')/psconfig/cases_popup"/>
    <xsl:variable name="cases-links-on" select="document('../../../cfg/psconfig.xml')/psconfig/cases_links_on"/>


</xsl:stylesheet>
