<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method='html'
                encoding="utf-8"
                omit-xml-declaration="yes"/>

    <xsl:param name="articleid"/>
    <xsl:param name="analyticsUri"/>

    <xsl:variable name="analytics" select="concat('email=', $articleid, '&amp;source=updateemail')"/>

    <xsl:template match="a/@href">
        <xsl:variable name="href" select="."/>

        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="contains($href, '?')">
                    <xsl:value-of select="substring-before($href, '?')"/>
                </xsl:when>
                <xsl:when test="contains($href, '#')">
                    <xsl:value-of select="substring-before($href, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="querystring">
            <xsl:if test="contains($href, '?')">
                <xsl:choose>
                    <xsl:when test="contains($href, '#')">
                        <xsl:value-of select="substring-before(substring-after($href, '?'), '#')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after($href, '?')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="fragment" select="substring-after($href, '#')"/>

        <xsl:attribute name="href">
            <xsl:choose>
                <xsl:when test="contains($href, 'whatsMarket.do') or contains($href, 'practicallaw.com/whatsmarket')">
                    <xsl:value-of select="$href"/>
                </xsl:when>
                <xsl:when
                        test="(contains($href, 'http://') or contains($href, 'https://')) and contains($href, 'practicallaw.com')">
                    <xsl:value-of select="$base"/>
                    <xsl:text>?</xsl:text>
                    <xsl:if test="string-length($querystring)">
                        <xsl:value-of select="$querystring"/>
                        <xsl:text>&amp;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$analytics"/>
                    <xsl:if test="string-length($fragment)">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="$fragment"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:choose>
                <xsl:when test="string-length($analyticsUri)">
                    <xsl:call-template name="webbug"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment>
                        <xsl:text>Analytics URI not set</xsl:text>
                        <xsl:call-template name="webbug"/>
                    </xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="webbug">
        <img src="{$analyticsUri}?siteName=plc&amp;objType=updateemailopen&amp;objID={$articleid}"
             style="display:none;"
             height="1"
             width="1"/>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>

