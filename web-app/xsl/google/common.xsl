<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:param name="nonLegacy"/>


    <xsl:template match="plcxlink">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Render justcite plcxlinks as an anchor link to facilitate resolution of PS backlinks. -->
    <xsl:template
            match="plcxlink[xlink:locator/attribute::xlink:role='PrimarySource'][xlink:locator/attribute::xlink:provider='justcite']">
        <xsl:variable name="link_id" select="xlink:locator/attribute::xlink:href"/>
        <xsl:choose>
            <xsl:when test="starts-with($link_id,'D')">
                <a name="primaryLink"
                   href="/casesGsa/del?plcRefToIndex={$link_id}">
                    <xsl:apply-templates select="xlink:locator//text()"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a name="primaryLink"
                   href="/cs/Satellite/?pagename=PLC/PLC_Doc_C/GoogleView&amp;c=PLC_Doc_C&amp;plcRefToIndex={$link_id}">
                    <xsl:apply-templates select="xlink:locator//text()"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="simpleplcxlink">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="a">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template name="contents"/>

    <xsl:template name="top-link"/>

    <xsl:template match="document">


        <xsl:variable name="resource-url">
            <xsl:choose>
                <xsl:when test="$nonLegacy = 'true' ">/cs/Satellite/?pagename=PLC/PLC_Doc_C/GoogleView&amp;c=PLC_Doc_C&amp;plcRefToIndex=<xsl:value-of
                        select="plcReference"/>
                </xsl:when>
                <xsl:otherwise>/servlet/Google?
                    <xsl:choose>
                        <xsl:when test="string-length(poid)&gt;0">poidToIndex=
                            <xsl:if test="not(starts-with(poid,':'))">:</xsl:if>
                            <xsl:value-of select="poid"/>
                        </xsl:when>
                        <xsl:otherwise>plcRefToIndex=<xsl:value-of select="plcReference"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>
        <tr>
            <td>
                <a href="{$resource-url}">
                    <xsl:choose>
                        <xsl:when test="string-length(metaTitle) &gt; 0 and string-length(mimeType) &gt; 0">
                            <xsl:value-of select="metaTitle"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="title" mode="google-keyword"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
