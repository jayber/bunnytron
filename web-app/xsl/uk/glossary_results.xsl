<?xml version="1.0" encoding="UTF-8"?>
<!-- UK -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="../us/glossary_results.xsl"/>

    <xsl:param name="extraResourceUrlPath"/>

    <xsl:template match="/">

        <!-- show the results -->

        <div id="search_results">
            <div class="glossary-indexes">
                <xsl:call-template name="indexLinkLoop">
                    <xsl:with-param name="pos" select="'1'"/>
                </xsl:call-template>
            </div>
            <xsl:apply-templates select="/search/searchResults/detail"/>
        </div>

    </xsl:template>

    <xsl:template match="column[text()='icon' or text()='index']"/>

    <xsl:template match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']">

        <tr>
            <xsl:if test="not(position() mod 2 = 0)">
                <xsl:attribute name="class">result-row-alt</xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="$columnConfig" mode="results">
                <xsl:with-param name="result" select="."/>
            </xsl:apply-templates>

        </tr>
    </xsl:template>

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/title">
        <xsl:param name="rowType"/>
        <xsl:variable name="result" select="parent::*"/>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="string-length($result/metaTitle) &gt; 0 and string-length($result/mimeType) &gt; 0">
                    <xsl:value-of select="$result/metaTitle"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Additional path to be put in Resource URL links for Blocks glossary using new resource page -->
        <xsl:variable name="extra-url-resource-path" select="$extraResourceUrlPath"/>

        <td class="glossary-item">
            <!--<xsl:variable name="url">/<xsl:value-of select="$serviceContext"/>/?pagename=XMLWrapper&amp;childpagename=PLC/PLC_Doc_C/ResourceXMLView&amp;cid=<xsl:value-of select="$result/id"/>&amp;c=PLC_Doc_C</xsl:variable>-->
            <a href="{$extra-url-resource-path}/{$result/plcReference}"
               class="glossary-item-link resource-id:{$result/id}">
                <xsl:value-of select="$title" disable-output-escaping="yes"/>
            </a>
            <div class="glossary-item-abstract">
                <xsl:comment/>
            </div>
        </td>
    </xsl:template>

    <xsl:template match="searchResults/detail">

        <div id="search_results_info">
            <strong>
                <xsl:if test="$resourceCount = 0">No resources</xsl:if>
                <xsl:if test="$resourceCount &gt; 0">
                    <xsl:choose>
                        <xsl:when test="$estTotal = 1000">Over 1000</xsl:when>
                        <xsl:when
                                test="$estTotal &lt; 1000 and $endIndex &lt; $estTotal and($estTotal &gt; $resultsStartIndex + 100)">
                            <xsl:value-of select="$estTotal"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$endIndex"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    resource
                    <xsl:if test="$resourceCount &gt; 1">s</xsl:if>
                </xsl:if>
            </strong>
            <xsl:if test="$resultsTotal &gt; $resourceCount">
                <p>Showing
                    <strong>
                        <xsl:value-of select="$resultsStartIndex + 1"/>
                    </strong>
                    -
                    <strong>
                        <xsl:value-of select="$endIndex"/>
                    </strong>
                </p>
                <xsl:call-template name="pageLinks"/>
            </xsl:if>
        </div>

        <xsl:if test="$resourceCount &gt; 0">
            <table>
                <xsl:apply-templates select="$columnConfigObj"/>
                <xsl:apply-templates select="document">
                    <xsl:sort select="title"/>
                </xsl:apply-templates>
            </table>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
