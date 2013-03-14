<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:param name="host"/>

    <xsl:variable name="resourceTypeConfig" select="document($resourceTypeConfig-path)/resourceTypeList/resourceType"/>
    <xsl:variable name="resourceCount" select="count(/searchResults/detail/document)"/>
    <xsl:variable name="estTotal">
        <xsl:value-of select="/searchResults/detail/total"/>
    </xsl:variable>

    <xsl:template match="searchResults/detail">
        <xsl:variable name="results"
                      select="document[resourceTypeFolderList/resourceTypeFolder=$resourceTypeConfig/name]"/>
        <table>
            <xsl:for-each select="$resourceTypeConfig">
                <xsl:sort select="sortOrder" data-type="number"/>
                <xsl:variable name="sortResourceType" select="name"/>
                <xsl:if test="count($results[resourceTypeFolderList/resourceTypeFolder=$sortResourceType]) &gt; 0">
                    <tr>
                        <td colspan="1" class="ps-backlinks-section-header">
                            <xsl:call-template name="pluralResourceTypeDescription">
                                <xsl:with-param name="resourceType" select="$sortResourceType"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:apply-templates select="$results[resourceTypeFolderList/resourceTypeFolder=$sortResourceType]">
                    <xsl:sort select="title" order="ascending"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="searchResults/detail" mode="right-hand-pane">
        <xsl:variable name="results"
                      select="document[resourceTypeFolderList/resourceTypeFolder=$resourceTypeConfig/name]"/>

        <xsl:for-each select="$resourceTypeConfig">
            <xsl:sort select="sortOrder" data-type="number"/>
            <xsl:variable name="sortResourceType" select="name"/>
            <xsl:if test="count($results[resourceTypeFolderList/resourceTypeFolder=$sortResourceType]) &gt; 0">
                <div class="content-meta-inner-heading">
                    <xsl:call-template name="pluralResourceTypeDescription">
                        <xsl:with-param name="resourceType" select="$sortResourceType"/>
                    </xsl:call-template>
                </div>
            </xsl:if>

            <xsl:apply-templates select="$results[resourceTypeFolderList/resourceTypeFolder=$sortResourceType]"
                                 mode="right-hand-pane">
                <xsl:sort select="title" order="ascending"/>
            </xsl:apply-templates>

        </xsl:for-each>

    </xsl:template>

    <xsl:template match="document/resourceTypeFolderList">
        <xsl:variable name="resourceType" select="resourceTypeFolder"/>
        <xsl:call-template name="resourceTypeDescription">
            <xsl:with-param name="resourceType" select="$resourceType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="document">
        <tr>
            <xsl:if test="not(position() mod 2 = 0)">
                <xsl:attribute name="class">result-row-alt</xsl:attribute>
            </xsl:if>
            <td>&#160;
                <a>
                    <xsl:attribute name="href">/<xsl:value-of select="plcReference"/>
                    </xsl:attribute>
                    <xsl:value-of select="title/text()" disable-output-escaping="yes"/>
                </a>
                <span class="print-related-content">
                    <xsl:value-of select="title/text()" disable-output-escaping="yes"/> (http://<xsl:value-of
                        select="$host"/>/<xsl:value-of select="plcReference"/>)
                </span>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="document" mode="right-hand-pane">
        <xsl:if test="position()=1">
            <xsl:text disable-output-escaping="yes">&lt;ul></xsl:text>
        </xsl:if>
        <li>
            <a>
                <xsl:attribute name="href">/<xsl:value-of select="plcReference"/>
                </xsl:attribute>
                <xsl:value-of select="title/text()" disable-output-escaping="yes"/>
            </a>
            <span class="print-related-content">
                <xsl:value-of select="title/text()" disable-output-escaping="yes"/> (http://<xsl:value-of
                    select="$host"/>/<xsl:value-of select="plcReference"/>)
            </span>
        </li>
        <xsl:if test="position()=last()">
            <xsl:text disable-output-escaping="yes">&lt;/ul></xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="resourceTypeDescription">
        <xsl:param name="resourceType"/>
        <xsl:choose>
            <xsl:when test="$resourceTypeConfig[name=$resourceType]">
                <xsl:value-of select="$resourceTypeConfig[name=$resourceType]/singularName"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pluralResourceTypeDescription">
        <xsl:param name="resourceType"/>
        <xsl:choose>
            <xsl:when test="$resourceTypeConfig[name=$resourceType]">
                <xsl:value-of select="$resourceTypeConfig[name=$resourceType]/pluralName"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>