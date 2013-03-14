<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">
    <!--<xsl:import href="convert-chars.xsl"/>-->
    <xsl:output method="text" encoding="utf-8"/>
    <!--set before style sheet used - style sheet is loaded into DOM, and the param nodes are given text-->
    <xsl:param name="articleTitle"/>
    <xsl:param name="universal"/>
    <xsl:param name="site"/>
    <!--	<xsl:param name="noimage"/>
        <xsl:param name="incImage"/>-->
    <xsl:param name="abstract"/>
    <xsl:param name="articleid"/>
    <xsl:param name="emailpropid"/>
    <xsl:param name="plcreference"/>
    <!--	<xsl:param name="doclink"/>-->
    <xsl:param name="delServerUri"></xsl:param>
    <xsl:variable name="articleserver" select="concat('http://',$site,'.',$delServerUri)"/>

    <xsl:variable name="emailtype" select="article/@emailtype"/>


    <xsl:template match="text()">
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="html|article">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="body|fulltext">
        <!--		<xsl:text>&#010;&#013;</xsl:text> -->
        <xsl:value-of select="$articleTitle"/>
        <xsl:text>&#010;&#013;</xsl:text>
        <xsl:choose>
            <xsl:when test="$emailtype='publicationsportal'"/>
            <xsl:otherwise>
                <xsl:if test="not($emailpropid='3')">
                    <xsl:if test="not($plcreference='')">
                        <xsl:text>Read this online at </xsl:text><xsl:value-of select='$articleserver'/>/<xsl:value-of
                            select="$plcreference"/>
                        <xsl:text>&#010;&#013;</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>


        <xsl:apply-templates/>

        <xsl:variable name="email-prefernces-page-url"><xsl:value-of select='$articleserver'/>/?pagename=PLCWrapper&amp;view=cselement%3APLC%2FAuthentication%2FMyAccount
        </xsl:variable>
        <xsl:variable name="feedback-page-url"><xsl:value-of select='$articleserver'/>/?pagename=PLCWrapper&amp;view=cselement%3APLC%2FAuthentication%2FMyAccount
        </xsl:variable>
        <xsl:variable name="password-reminder-page-url"><xsl:value-of select='$articleserver'/>/?pagename=PLCWrapper&amp;view=cselement%3APLC%2FAuthentication%2FPasswordReminder
        </xsl:variable>
        <xsl:variable name="terms-of-use-page-url"><xsl:value-of select='$articleserver'/>/1-386-5598
        </xsl:variable>
        <xsl:variable name="trademarks-page-url"><xsl:value-of select='$articleserver'/>/9-265-9958
        </xsl:variable>
        <xsl:variable name="privacy-page-url"><xsl:value-of select='$articleserver'/>/3-386-5597
        </xsl:variable>
        <xsl:variable name="twitter-info-url"><xsl:value-of select='$articleserver'/>/1-503-9520
        </xsl:variable>
        <xsl:variable name="rss-info-url"><xsl:value-of select='$articleserver'/>/9-501-3639
        </xsl:variable>

        <xsl:text>Follow us on Twitter and via RSS&#010;&#013;</xsl:text>Did you know you can receive these updates on
        Twitter? Updates are tweeted when they are published, so you can keep up to date by following us on Twitter. See
        <xsl:value-of select="$twitter-info-url"/> on how to follow us on Twitter. <xsl:text>&#010;&#013;</xsl:text>All
        PLC updates are also available via RSS. See
        <xsl:value-of select="$rss-info-url"/> on how to subscribe to our RSS feeds.<xsl:text>&#010;&#013;</xsl:text>
        <xsl:text>Further information&#010;&#013;===================&#010;&#013;To alter your preferences, or to stop receiving email, visit </xsl:text><xsl:value-of
            select="$email-prefernces-page-url"/>.<xsl:text>&#010;&#013;</xsl:text>For technical help please email
        info@practicallaw.com. For more information on PLC products please email lisa.byers@practicallaw.com.(c)
        Practical Law Publishing Limited (<xsl:value-of
            select="$articleserver"/>/0-207-4980);<xsl:text>&#010;&#013;</xsl:text>Practical Law Company Limited
        (<xsl:value-of select="$articleserver"/>/2-207-4979) 2012. Terms of use (<xsl:value-of
            select="$terms-of-use-page-url"/>) and Privacy Policy (<xsl:value-of select="$privacy-page-url"/>).
    </xsl:template>
    <xsl:template match="abstract"/>
    <xsl:template match="p|section2">
        <xsl:text>&#010;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#013;</xsl:text>
    </xsl:template>
    <xsl:template match="i|emphasis">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ul|itemizedlist">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="li|listitem">
        <xsl:text>-</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#013;</xsl:text>
    </xsl:template>
    <xsl:template match="b">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="td">
        <td style="font-size:14px; font-family:Verdana,Geneva,Helvetica,Arial,sans-serif">
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    <xsl:template match="div">
        <xsl:apply-templates/>
    </xsl:template>
    <!--<xsl:template match="a"><xsl:text><xsl:apply-templates />LINK:</xsl:text></xsl:template>-->
    <xsl:template match="h1|h2|h3|title|para">
        <xsl:text>&#013;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#013;</xsl:text>
    </xsl:template>
    <xsl:template match="h4">
        <xsl:text>&#013;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#013;</xsl:text>
    </xsl:template>
    <xsl:template match="h5">
        <xsl:text>&#013;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text/>
    </xsl:template>
    <xsl:template match="img">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="h2">
        <xsl:text/>
        <xsl:apply-templates/>
        <xsl:text/>
    </xsl:template>
    <xsl:template match="br">
        <xsl:text>&#013;&#010;</xsl:text>
    </xsl:template>
    <xsl:template match="locator"/>
    <!--turn plclinks into anchors-->
    <xsl:template match="plclink">
        <xsl:variable name="sLinkText">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:element name="a">
            <xsl:attribute name="style">text-decoration:none</xsl:attribute>
            <xsl:choose>
                <xsl:when test="locator/@role[.='Article']">
                    <xsl:value-of select="."/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/article.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="locator/@role[.='Organisation']">
                    <xsl:value-of select="locator/@title"/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/organisation.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="strong/locator/@role[.='Organisation']">
                    <xsl:value-of select="locator/@title"/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/organisation.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="locator/@role[.='Topic']">
                    <xsl:value-of select="locator/@title"/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/topic.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="locator/@role[.='Web']">
                    <xsl:value-of select="locator/@title"/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/web.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="locator/@role[.='Contact']">
                    <xsl:value-of select="locator/@title"/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/contact.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="locator/@role[.='Individual']">
                    <xsl:value-of select="locator/@title"/>
                    <xsl:text> [http://</xsl:text>
                    <xsl:value-of select="$site"/>
                    <xsl:text>.practicallaw.com/jsp/contact.jsp?item=</xsl:text>
                    <xsl:value-of select="locator/@href"/>
                    <xsl:text> ]</xsl:text>
                </xsl:when>
                <xsl:when test="@xml:link[.='simple']">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <!--this taken out because otherwise the link text appears twice-->
                    <!--<xsl:apply-templates />-->
                </xsl:when>
            </xsl:choose>
            <!--Apply-templates here would put in the link text. Instead, the title attribute is used.-->
            <!--end of link text-->
        </xsl:element>
    </xsl:template>
    <xsl:template match="plcxlink">
        <xsl:apply-templates/>
        [<xsl:value-of select='$articleserver'/>/<xsl:value-of select="xlink:locator/@xlink:href"/>]
    </xsl:template>
    <!--
        <xsl:template match="text()">
            <xsl:value-of select="."/>
        </xsl:template> -->
    <xsl:template match="a">
        <xsl:variable name="sHref">
            <xsl:value-of select="@href"/>
        </xsl:variable>
        <xsl:variable name="sName">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <a>
            <xsl:attribute name="style">text-decoration:none</xsl:attribute>
            <xsl:choose>
                <xsl:when test="starts-with($sHref, '/scripts/')">
                    <xsl:attribute name="href">http://<xsl:value-of select="$site"/>.practicallaw.com<xsl:value-of
                            select="@href"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="starts-with($sHref, '/update/')">
                    <xsl:attribute name="href">http://<xsl:value-of select="$site"/>.practicallaw.com<xsl:value-of
                            select="@href"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="starts-with($sHref, '/order/')">
                    <xsl:attribute name="href">http://<xsl:value-of select="$site"/>.practicallaw.com<xsl:value-of
                            select="@href"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="@href">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@href"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="contains($sName, '#')">
                    <xsl:attribute name="name">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="metadata"/>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <!--<xsl:choose>
                    <xsl:when test="contains ($this_string,'&#8216;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8216;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8216;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8216;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#8217;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8217;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8217;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8217;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x2019;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x2019;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8217;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x2019;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x2022;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x2022;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x2022;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x2022;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x2012;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x2012;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x2012;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x2012;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#8211;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8211;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8211;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8211;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#8230;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8230;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8230;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8230;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x2014;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x2014;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x2014;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x2014;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#8220;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8220;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8220;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8220;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#8221;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8221;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#8221;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8221;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x014d;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x014d;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x014d;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x014d;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#10;') and (ancestor::node()/@xml:space='preserve')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#10;')"/>
                        </xsl:call-template>
                        <br/>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#10;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x14d;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x14d;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x014d;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x14d;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x119;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x119;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x0119;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x119;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x016b;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x016b;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x016b;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x016b;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x159;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x159;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x159;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x159;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#0163;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#0163;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#0163;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#0163;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x10c;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x10c;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x10c;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x10c;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x10d;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x10d;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x10d;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x10d;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x105;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x105;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x105;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x105;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x107;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x107;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x107;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x107;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains ($this_string,'&#x15b;')">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x15b;')"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;#x15b;</xsl:text>
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x15b;')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$this_string"/>
                    </xsl:otherwise>
                </xsl:choose>-->
        <xsl:value-of select="$this_string"/>
    </xsl:template>
</xsl:stylesheet>
