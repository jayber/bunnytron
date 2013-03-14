<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:template
            match="node()[name(.) = 'document' or name(.) = 'resourceItem' or name(.) = 'handbookResourceItem']/title">
        <xsl:param name="rowType"/>
        <xsl:variable name="result" select="parent::*"/>

        <xsl:variable name="resource-url">/?pagename=PLC/PLC_Doc_C/GoogleResourceDetail&amp;cid=<xsl:value-of
                select="$result/plcReference"/>
        </xsl:variable>

        <td>
            <a href="{$resource-url}">
                <xsl:choose>
                    <xsl:when test="string-length($result/metaTitle) &gt; 0 and string-length($result/mimeType) &gt; 0">
                        <xsl:value-of select="$result/metaTitle"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="google-keyword"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </td>
    </xsl:template>

    <xsl:template match="searchResults/detail">
        <div id="search_results">
            <xsl:if test="$resourceCount &gt; 0">
                <table>
                    <xsl:apply-templates select="document"/>
                </table>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="resultTabs"/>

    <xsl:template match="resultsMetaData"/>


</xsl:stylesheet>
