<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

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
                        <td colspan="4" class="ps-backlinks-section-header">
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
            <td class="result-col-index" width="20px">
                <xsl:value-of select="position()"/>
            </td>
            <td>&#160;
                <a>
                    <xsl:attribute name="href">/<xsl:value-of select="plcReference"/>
                    </xsl:attribute>
                    <xsl:value-of select="title/text()" disable-output-escaping="yes"/>
                </a>
            </td>
            <td class="result-col-resource">
                <xsl:apply-templates select="resourceTypeFolderList"/>
            </td>
            <xsl:apply-templates select="publicationDate"/>
        </tr>
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

    <xsl:template match="publicationDate">
        <xsl:variable name="maintained" select="parent::*/maintained"/>
        <xsl:variable name="displayDate" select="parent::*/displayDate"/>
        <td>
            <xsl:attribute name="class">result-col-date
                <xsl:if test="$maintained='true'">maintained</xsl:if>
            </xsl:attribute>
            <xsl:if test="not(parent::*/sortDateStr = '19700101') and not($maintained='true')">
                <xsl:choose>
                    <xsl:when test="not(string($displayDate)='')">
                        <xsl:value-of select="$displayDate"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="dateFormatter">
                            <xsl:with-param name="dateString" select="."/>
                            <xsl:with-param name="outputFormat" select="$dateFormat"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$maintained='true'">
                Maintained
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template name="dateFormatter">
        <xsl:param name="dateString"/>
        <xsl:param name="outputFormat" select="'yyyymmdd'"/>

        <xsl:variable name="dayIn">
            <xsl:value-of select="substring($dateString,9,2)"/>
        </xsl:variable>
        <xsl:variable name="month">
            <xsl:value-of select="substring($dateString,6,2)"/>
        </xsl:variable>
        <xsl:variable name="year" select="substring($dateString,1,4)"/>
        <xsl:variable name="day">
            <xsl:choose>
                <xsl:when test="$month='02' and number($dayIn) &gt; 28">28</xsl:when>
                <xsl:when test="($month='04' or $month='06' or $month='09' or $month='11') and $dayIn='31'">30
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dayIn"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$outputFormat='yyyymmdd'">
                <xsl:value-of select="$year"/><xsl:value-of select="$month"/><xsl:value-of select="$day"/>
            </xsl:when>
            <xsl:when test="$outputFormat='dd-mm-yyyy'"><xsl:value-of select="$day"/>-<xsl:value-of select="$month"/>-<xsl:value-of
                    select="$year"/>
            </xsl:when>
            <xsl:when test="$outputFormat='dd-MMM-yyyy'"><xsl:value-of select="$day"/>-
                <xsl:call-template name="format-date-month">
                    <xsl:with-param name="month" select="$month"></xsl:with-param>
                </xsl:call-template>
                -<xsl:value-of select="$year"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$day"/><xsl:value-of select="$month"/><xsl:value-of select="$year"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="format-date-month">
        <xsl:param name="month"/>
        <xsl:variable name="output">
            <xsl:choose>
                <xsl:when test="$month='01'">Jan</xsl:when>
                <xsl:when test="$month='02'">Feb</xsl:when>
                <xsl:when test="$month='03'">Mar</xsl:when>
                <xsl:when test="$month='04'">Apr</xsl:when>
                <xsl:when test="$month='05'">May</xsl:when>
                <xsl:when test="$month='06'">Jun</xsl:when>
                <xsl:when test="$month='07'">Jul</xsl:when>
                <xsl:when test="$month='08'">Aug</xsl:when>
                <xsl:when test="$month='09'">Sep</xsl:when>
                <xsl:when test="$month='10'">Oct</xsl:when>
                <xsl:when test="$month='11'">Nov</xsl:when>
                <xsl:when test="$month='12'">Dec</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$output"/>
    </xsl:template>

</xsl:stylesheet>