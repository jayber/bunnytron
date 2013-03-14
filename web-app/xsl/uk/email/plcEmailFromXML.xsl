<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <xsl:output method='xml' encoding="utf-8" omit-xml-declaration="yes"/>
    <!--set before style sheet used - style sheet is loaded into DOM, and the param nodes are given text-->
    <xsl:param name="articleTitle"></xsl:param>
    <xsl:param name="universal"></xsl:param>
    <!-- Chris-->
    <xsl:param name="site"></xsl:param>
    <!-- <xsl:param name="noimage"></xsl:param> -->
    <!--<xsl:param name="incImage"></xsl:param> -->
    <xsl:param name="abstract"></xsl:param>
    <xsl:param name="articleid"></xsl:param>
    <!--<xsl:param name="emailpropid"></xsl:param>-->
    <xsl:param name="plcreference"></xsl:param>
    <!-- TBD -->
    <!-- <xsl:param name="doclink"></xsl:param>-->
    <xsl:param name="isMultiJurisdictional"></xsl:param>
    <!-- <xsl:variable name="articleserver" select="concat('http://',$site,'.practicallaw.com')"/> -->
    <xsl:param name="delServerUri"></xsl:param>

    <xsl:variable name="articleserver" select="concat('http://',$site,'.',$delServerUri)"/>

    <xsl:variable name="nbsp">&#160;</xsl:variable>
    <xsl:variable name="copy">&#169;</xsl:variable>

    <xsl:variable name="emailtype" select="article/@emailtype"/>


    <!--	<xsl:variable name="articleserver">
            <xsl:choose>
                <xsl:when test="$site='www'"><xsl:value-of select="$delServerUri"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat($delServerUri,'/', $site)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable> -->

    <xsl:variable name="email-images-location">
        <xsl:value-of select="$delServerUri"/><xsl:text>/presentation/images/email</xsl:text>
    </xsl:variable>
    <xsl:variable name="common-images-location">
        <xsl:value-of select="$delServerUri"/><xsl:text>/presentation/images/common</xsl:text>
    </xsl:variable>


    <xsl:strip-space elements="*"/>

    <xsl:variable name="appLocale">
        <xsl:choose>
            <xsl:when test="substring($site,1,2) = 'us'">us</xsl:when>
            <xsl:otherwise>uk</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="styleFont"><![CDATA[font-family:verdana,arial,helvetica,sans-serif;]]></xsl:variable>
    <xsl:variable name="styleFontSize"><![CDATA[font-size:10pt; line-height: 1.6em;]]></xsl:variable>

    <xsl:variable name="cssA"><![CDATA[color:#0005E1;]]></xsl:variable>

    <xsl:variable name="headerTitle">
        <xsl:choose>
            <xsl:when test="$site='arbitration'">Arbitration</xsl:when>
            <xsl:when test="$site='commercial'">Commercial</xsl:when>
            <xsl:when test="$site='competition'">Competition</xsl:when>
            <xsl:when test="$site='construction'">Construction</xsl:when>
            <xsl:when test="$site='corporate'">Corporate</xsl:when>
            <xsl:when test="$site='crossborder'">Cross-border</xsl:when>
            <xsl:when test="$site='dispute'">Dispute Resolution</xsl:when>
            <xsl:when test="$site='employment'">Employment</xsl:when>
            <xsl:when test="$site='environment'">Environment</xsl:when>
            <xsl:when test="$site='finance'">Finance</xsl:when>
            <xsl:when test="$site='fs'">Financial Services</xsl:when>
            <xsl:when test="$site='incentives'">Share Schemes &amp; Incentives</xsl:when>
            <xsl:when test="$site='ipandit'">IPIT &amp; Communications</xsl:when>
            <xsl:when test="$site='ld'">Law Department</xsl:when>
            <xsl:when test="$site='pensions'">Pensions</xsl:when>
            <xsl:when test="$site='privateclient'">Private Client</xsl:when>
            <xsl:when test="$site='property'">Property</xsl:when>
            <xsl:when test="$site='publicsector'">Public Sector</xsl:when>
            <xsl:when test="$site='restructuringandinsolvency'">Restructuring and Insolvency</xsl:when>
            <xsl:when test="$site='tax'">Tax</xsl:when>
            <xsl:when test="$site='plc'">Magazine</xsl:when>
            <xsl:when test="$site='whichlawyer'">Which lawyer?</xsl:when>
            <xsl:when test="$site='usld'">Law Department</xsl:when>

            <xsl:otherwise>PRACTICAL LAW COMPANY</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pixelOne">
        <xsl:choose>
            <xsl:when test="$site='arbitration'">e56d72</xsl:when>
            <xsl:when test="$site='competition'">008382</xsl:when>
            <xsl:when test="$site='corporate'">005ea7</xsl:when>
            <xsl:when test="$site='crossborder'">ffc185</xsl:when>
            <xsl:when test="$site='dispute'">e56d72</xsl:when>
            <xsl:when test="$site='employment'">fce098</xsl:when>
            <xsl:when test="$site='environment'">10a843</xsl:when>
            <xsl:when test="$site='finance'">dee4e4</xsl:when>
            <xsl:when test="$site='fs'">eed5db</xsl:when>
            <xsl:when test="$site='incentives'">bb93b7</xsl:when>
            <xsl:when test="$site='ipandit'">ce003a</xsl:when>
            <xsl:when test="$site='ld'">b9e700</xsl:when>
            <xsl:when test="$site='pensions'">c50078</xsl:when>
            <xsl:when test="$site='property'">7f5db8</xsl:when>
            <xsl:when test="$site='restructuringandinsolvency'">dbe3e6</xsl:when>
            <xsl:when test="$site='tax'">00667c</xsl:when>
            <xsl:when test="$site='whichlawyer'">fff798</xsl:when>

            <xsl:when test="$site='gc100'">005941</xsl:when>

            <xsl:otherwise>ffe500</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pixelTwo">
        <xsl:choose>
            <xsl:when test="$site='arbitration'">e2373f</xsl:when>
            <xsl:when test="$site='competition'">00c6c4</xsl:when>
            <xsl:when test="$site='corporate'">00a2d2</xsl:when>
            <xsl:when test="$site='crossborder'">f89d44</xsl:when>
            <xsl:when test="$site='dispute'">e2373f</xsl:when>
            <xsl:when test="$site='employment'">fac833</xsl:when>
            <xsl:when test="$site='environment'">108236</xsl:when>
            <xsl:when test="$site='finance'">708d8c</xsl:when>
            <xsl:when test="$site='fs'">ca909c</xsl:when>
            <xsl:when test="$site='incentives'">e9cfe7</xsl:when>
            <xsl:when test="$site='ipandit'">e31f69</xsl:when>
            <xsl:when test="$site='ld'">8fbb34</xsl:when>
            <xsl:when test="$site='pensions'">cc559c</xsl:when>
            <xsl:when test="$site='property'">8178c8</xsl:when>
            <xsl:when test="$site='restructuringandinsolvency'">6e8e8b</xsl:when>
            <xsl:when test="$site='tax'">41a1ae</xsl:when>
            <xsl:when test="$site='whichlawyer'">f8975d</xsl:when>

            <xsl:when test="$site='gc100'">21725d</xsl:when>

            <xsl:otherwise>f9a53c</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pixelThree">
        <xsl:choose>
            <xsl:when test="$site='arbitration'">c9010a</xsl:when>
            <xsl:when test="$site='competition'">a2dfde</xsl:when>
            <xsl:when test="$site='corporate'">00b0f9</xsl:when>
            <xsl:when test="$site='crossborder'">e47406</xsl:when>
            <xsl:when test="$site='dispute'">c9010a</xsl:when>
            <xsl:when test="$site='employment'">e7983a</xsl:when>
            <xsl:when test="$site='environment'">036223</xsl:when>
            <xsl:when test="$site='finance'">567674</xsl:when>
            <xsl:when test="$site='fs'">a5636f</xsl:when>
            <xsl:when test="$site='incentives'">b260ac</xsl:when>
            <xsl:when test="$site='ipandit'">ff7171</xsl:when>
            <xsl:when test="$site='ld'">868d02</xsl:when>
            <xsl:when test="$site='pensions'">e7bad5</xsl:when>
            <xsl:when test="$site='property'">be9dff</xsl:when>
            <xsl:when test="$site='restructuringandinsolvency'">527674</xsl:when>
            <xsl:when test="$site='tax'">a3d2d9</xsl:when>
            <xsl:when test="$site='whichlawyer'">ee272c</xsl:when>

            <xsl:when test="$site='gc100'">508879</xsl:when>

            <xsl:otherwise>de0056</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="article">
        <!--<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">]]></xsl:text>-->
        <html>
            <head>
                <title>
                    <xsl:value-of select="$articleTitle"/><xsl:value-of select='$nbsp'/>
                </title>
                <style type="text/css">
                    a, a:link, a:visited {
                    text-decoration: none;
                    }
                    a:hover {
                    text-decoration: underline;
                    }
                </style>
            </head>

            <body style="margin:0px; padding: 10px">
                <a name="top"/>
                <xsl:if test="not($appLocale = 'us')">
                    <div style="position:absolute; width:320px; height:37px; top:9px">
                        <xsl:if test="not($site='gc100')">
                            <a href="{$email-images-location}" title="PLC Updates" style="text-decoration:none;">
                                <div style="margin: 0px; width: 290px; height: 37px; background: url('{$email-images-location}/{$site}Header.gif') no-repeat bottom left; cursor: pointer;cursor: hand;">
                                    <xsl:value-of select="$nbsp"/>
                                </div>
                            </a>
                        </xsl:if>
                        <xsl:if test="$site='gc100'">
                            <a href="{$delServerUri}" title="PLC Updates" style="text-decoration:none;">
                                <div style="margin: 0px; width: 320px; height: 37px; background: url('{$email-images-location}/GC100eMailHeader.gif') no-repeat top left; cursor: pointer;cursor: hand;">
                                    <xsl:value-of select="$nbsp"/>
                                </div>
                            </a>
                        </xsl:if>
                    </div>
                </xsl:if>
                <xsl:if test="$appLocale = 'us'">
                    <div style="position:absolute; width:320px; height:56px; top:9px;">
                        <a href="{$email-images-location}" title="PLC Updates" style="text-decoration:none;">
                            <!--<div style="margin: 0px; width: 290px; height: 56px; background: url('http://{$site}.practicallaw.com/img/email/{$site}Header.gif') no-repeat bottom left; cursor: pointer;cursor: hand;"><xsl:value-of select="$nbsp"/></div>-->
                            <div style="margin: 0px; width: 290px; height: 56px; background: url('{$email-images-location}/{$site}Header.gif') no-repeat bottom left; cursor: pointer;cursor: hand;">
                                <xsl:value-of select="$nbsp"/>
                            </div>
                        </a>
                    </div>
                </xsl:if>

                <table cellpadding="0" cellspacing="0" border="0">
                    <xsl:if test="not($appLocale = 'us')">
                        <xsl:attribute name="style">border: 1px solid #336; border-top: 0px solid;</xsl:attribute>
                    </xsl:if>
                    <!-- header -->


                    <xsl:if test="not($appLocale = 'us')">
                        <tr style=" background: #336">
                            <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color: #FFF">
                                    <tr>
                                        <td valign="top" width="320">
                                            <table border="0" cellspacing="0" cellpadding="0" height="36"
                                                   style="height: 36px; ">
                                                <tr>
                                                    <td style="padding: 3px 5px 0px 6px; font-size:14px; font-weight:bold;{$styleFont};color:#FFF"
                                                        valign="top">
                                                        <xsl:if test="not($headerTitle='PRACTICAL LAW COMPANY')">
                                                            <span style="font-size:9px; font-weight:normal;vertical-align:top;">
                                                                PLC
                                                            </span>
                                                        </xsl:if>
                                                        <xsl:value-of select="$headerTitle"/>
                                                    </td>
                                                    <xsl:if test="not($site='gc100')">
                                                        <td width="18" valign="bottom"
                                                            style="border-right: 1px solid #FFF; height: 36px;">
                                                            <table border="0" cellpadding="0" cellspacing="0" height="9"
                                                                   style="height: 9px">
                                                                <tr>
                                                                    <td width="9" bgcolor="#{$pixelOne}"
                                                                        style="line-height:0; height:9px">
                                                                        <xsl:value-of select="$nbsp"/>
                                                                    </td>
                                                                    <td width="9" bgcolor="#{$pixelTwo}"
                                                                        style="line-height:0">
                                                                        <xsl:value-of select="$nbsp"/>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width="9" valign="bottom">
                                                            <table border="0" cellpadding="0" cellspacing="0" height="9"
                                                                   style="height: 9px">
                                                                <tr>
                                                                    <td width="9" bgcolor="#{$pixelThree}"
                                                                        style="line-height:0; height:9px">
                                                                        <xsl:value-of select="$nbsp"/>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </xsl:if>
                                                    <xsl:if test="$site='gc100'">
                                                        <td width="27" valign="bottom"
                                                            style="border-right: 1px solid #FFF; height: 36px;">
                                                            <table border="0" cellpadding="0" cellspacing="0" height="9"
                                                                   style="height: 9px">
                                                                <tr>
                                                                    <td width="9" bgcolor="#005941"
                                                                        style="line-height:0; height:9px">
                                                                        <xsl:value-of select="$nbsp"/>
                                                                    </td>
                                                                    <td width="9" bgcolor="#21725d"
                                                                        style="line-height:0">
                                                                        <xsl:value-of select="$nbsp"/>
                                                                    </td>
                                                                    <td width="9" bgcolor="#508879"
                                                                        style="line-height:0; height:9px">
                                                                        <xsl:value-of select="$nbsp"/>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td valign="top" bgcolor="#005941"
                                                            style="border-right: 1px solid #FFF; height: 36px; color:#FFFFFF; padding: 0px 3px 0px 3px;">
                                                            <p style="margin: 0px; font: Arial; font-size: 12px;">GC</p>
                                                            <p style="margin: -3px 0px 0px 0px; font: Arial; font-size: 20px;">
                                                                100
                                                            </p>
                                                        </td>
                                                    </xsl:if>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="right"
                                            style="height:36px; padding-right: 5px; font-weight: bold;{$styleFont} font-size:75%;color:#FFF">
                                            <xsl:text></xsl:text><xsl:value-of select="$articleTitle"/><xsl:value-of
                                                select="$nbsp"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                    </xsl:if>
                    <xsl:if test="$appLocale = 'us'">

                        <tr style=" background: #003180">
                            <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="color: #FFF">
                                    <tr>
                                        <td valign="top" width="320">
                                            <table border="0" cellspacing="0" cellpadding="0" height="36"
                                                   style="height: 55px; ">
                                                <tr>
                                                    <td style="padding: 7px 5px 0px 7px; font-size:16px; font-weight:bold;{$styleFont};color:#FFF"
                                                        valign="top">
                                                        <xsl:if test="not($headerTitle='PRACTICAL LAW COMPANY')">
                                                            <span style="font-size:9px; font-weight:normal;vertical-align:top;">
                                                                PLC
                                                            </span>
                                                        </xsl:if>
                                                        <xsl:value-of select="$headerTitle"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="top" style="height: 25px;">
                                                        <table border="0" cellpadding="0" cellspacing="5" height="10"
                                                               style="height: 10px">
                                                            <tr>
                                                                <td width="10" bgcolor="#{$pixelOne}"
                                                                    style="line-height:0; height:10px">
                                                                    <xsl:value-of select="$nbsp"/>
                                                                </td>
                                                                <td width="10" bgcolor="#{$pixelTwo}"
                                                                    style="line-height:0">
                                                                    <xsl:value-of select="$nbsp"/>
                                                                </td>
                                                                <td width="10" bgcolor="#{$pixelThree}"
                                                                    style="line-height:0;">
                                                                    <xsl:value-of select="$nbsp"/>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>

                                                </tr>
                                            </table>
                                        </td>
                                        <td align="right"
                                            style="height:55px; padding-right: 5px; font-weight: bold;{$styleFont} font-size:75%;color:#FFF">
                                            <xsl:value-of select="$articleTitle"/><xsl:value-of select="$nbsp"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                    </xsl:if>
                    <!-- end of header -->

                    <xsl:if test="$isMultiJurisdictional='true'">
                        <tr>
                            <td style="padding: 20px 40px 0px 40px ">
                                <table width="100%" cellpadding="0" cellspacing="0" border="0"
                                       style="border-bottom: 1px dotted #ccc;{$styleFont} {$styleFontSize}">
                                    <tr>
                                        <td style="padding-bottom:20px">
                                            <p>This e-mail is part of the
                                                <a style="{$cssA}"
                                                   href="http://competition.practicallaw.com/jsp/article.jsp?item=3-102-4999">
                                                    PLC Competition
                                                </a>
                                                service and the
                                                <a style="{$cssA}"
                                                   href="http://competition.practicallaw.com/7-107-4727">PLC
                                                    Cross-border
                                                </a>
                                                service. It contains recent developments on competition law
                                                worldwide written by leading firms in conjunction with PLC Competition.
                                            </p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </xsl:if>

                    <!-- abstract -->
                    <xsl:apply-templates select="metadata/abstract"/>

                    <!-- toc -->
                    <xsl:if test="count(fulltext/section1/title) &gt; 0">
                        <xsl:call-template name="contents"/>
                    </xsl:if>

                    <!-- If PLC Magazine Email, then display a Read this online text-->
                    <xsl:if test="$site = 'plc'">
                        <tr>
                            <td style="padding: 20px 40px 0px 40px ">
                                <table width="100%" cellpadding="0" cellspacing="0" border="0"
                                       style="border-bottom: 1px dotted #ccc;{$styleFont} {$styleFontSize}">
                                    <tr>
                                        <td style="padding-bottom:20px">
                                            <p>Read this online at
                                                <a style="text-decoration:none">
                                                    <xsl:attribute name="href"><xsl:value-of select="$articleserver"/>/<xsl:value-of
                                                            select="$plcreference"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$articleserver"/>/<xsl:value-of
                                                        select="$plcreference"/>
                                                </a>
                                            </p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </xsl:if>

                    <!-- main content -->
                    <xsl:apply-templates/>

                    <!-- info links -->
                    <xsl:variable name="footer-tag">section=footer</xsl:variable>
                    <xsl:variable name="email-prefernces-page-url"><xsl:value-of select='$articleserver'/>/?pagename=PLCWrapper&amp;view=cselement%3APLC%2FAuthentication%2FMyAccount&amp;<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="feedback-page-url-uk"><xsl:value-of select='$articleserver'/>/?assetType=ServicePage&amp;view=cselement:PLC%2FCommon%2FSubscriberFeedback&amp;pagename=PLCWrapper&amp;<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="feedback-page-url-us"><xsl:value-of select='$articleserver'/>/about/contact-us?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="training-page-url-us"><xsl:value-of select='$articleserver'/>/about/request-training?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="password-reminder-page-url"><xsl:value-of select='$articleserver'/>/?pagename=PLCWrapper&amp;view=cselement%3APLC%2FAuthentication%2FPasswordReminder&amp;<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="terms-of-use-page-url"><xsl:value-of select='$articleserver'/>/1-386-5598?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="trademarks-page-url"><xsl:value-of select='$articleserver'/>/9-265-9958?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="privacy-page-url"><xsl:value-of select='$articleserver'/>/3-386-5597?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="twitter-info-url-uk"><xsl:value-of select='$articleserver'/>/1-503-9520?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="twitter-info-url-us">http://twitter.com/#!/practicallawus</xsl:variable>
                    <xsl:variable name="rss-info-url-uk"><xsl:value-of select='$articleserver'/>/9-501-3639?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>
                    <xsl:variable name="rss-info-url-us"><xsl:value-of select='$articleserver'/>/about/updates-feeds?<xsl:value-of
                            select="$footer-tag"/>
                    </xsl:variable>

                    <!-- Twitter and RSS-->
                    <xsl:if test="not(starts-with($site,'us'))">
                        <tr>
                            <td style="padding: 0px 20px">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0;">
                                    <tr>
                                        <td style="padding:5px 10px; background:#DDE1EF">
                                            <h1 style="{$styleFont} font-size: 0.9em; font-weight:bold; margin:0px">
                                                Follow us on Twitter and via RSS
                                            </h1>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 20px 20px 0px 20px;{$styleFont}{$styleFontSize}">
                                            <p>
                                                Did you know you can receive these updates on Twitter? Updates are
                                                tweeted when they are published, so you can keep up to date by following
                                                us on Twitter. See
                                                <a target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$twitter-info-url-uk"/>
                                                    </xsl:attribute>
                                                    details
                                                </a>
                                                on how to follow us on Twitter.
                                                <br/>
                                                <br/>
                                                All PLC updates are also available via RSS. See
                                                <a target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$rss-info-url-uk"/>
                                                    </xsl:attribute>
                                                    details
                                                </a>
                                                on how to subscribe to our RSS feeds.
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding:  10px 20px 20px 20px">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td style="{$styleFont}{$styleFontSize}border-top:1px dotted #ccc; padding-top:20px">
                                                        <a href="#top" style="color:#0005E1;font-weight:bold">Back to
                                                            top
                                                        </a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </xsl:if>

                    <tr>
                        <td style="padding: 0px 20px">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0;">
                                <xsl:if test="not(starts-with($site,'us'))">
                                    <tr>
                                        <td style="padding:5px 10px; background:#DDE1EF">
                                            <h1 style="{$styleFont} font-size: 0.9em; font-weight:bold; margin:0px">
                                                Further information
                                            </h1>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 20px 20px 0px 20px;{$styleFont}{$styleFontSize}">
                                            <p>
                                                Change your
                                                <a target="_blank" style="{$cssA}">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$email-prefernces-page-url"/>
                                                    </xsl:attribute>
                                                    preferences
                                                </a>
                                                /stop receiving e-mail.
                                                <a target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$feedback-page-url-uk"/>
                                                    </xsl:attribute>
                                                    Contact
                                                </a>
                                                editorial team.
                                                <a style="{$cssA}" target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$password-reminder-page-url"/>
                                                    </xsl:attribute>
                                                    Request
                                                </a>
                                                a password reminder.
                                                <br/>
                                                <br/>
                                                For other assistance including technical help contact
                                                <xsl:if test="$site='property'"><a style="{$cssA}"
                                                                                   href="mailto:propertyfeedback@practicallaw.com">
                                                    propertyfeedback@practicallaw.com</a>.
                                                </xsl:if>
                                                <xsl:if test="not ($site='property')"><a style="{$cssA}"
                                                                                         href="mailto:info@practicallaw.com">
                                                    info@practicallaw.com</a>.
                                                    <br/>
                                                </xsl:if>
                                                For more information on PLC products please contact<a style="{$cssA}"
                                                                                                      href="mailto:lisa.byers@practicallaw.com">
                                                lisa.byers@practicallaw.com</a>.
                                                <br/>
                                                <br/>
                                                Practical Law Company offers complimentary training on all of our
                                                professional support services to subscribing firms. If you are
                                                interested in having a trainer visit your offices or would like a remote
                                                demonstration please<a style="{$cssA}"
                                                                       href="{$articleserver}/about/training"
                                                                       target="_blank">click here</a>.
                                                <br/>
                                                <br/>
                                                <xsl:value-of select="$copy"/>
                                                <a style="{$cssA}" href="{$articleserver}/0-207-4980?{$footer-tag}">
                                                    Practical Law Publishing Limited</a>;
                                                <a style="{$cssA}" href="{$articleserver}/2-207-4979?{$footer-tag}">
                                                    Practical Law Company Limited</a>2012.
                                                <a style="{$cssA}text-decoration:none">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$terms-of-use-page-url"/>
                                                    </xsl:attribute>
                                                    Terms of use
                                                </a>
                                                .
                                                <a style="{$cssA}text-decoration:none">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$trademarks-page-url"/>
                                                    </xsl:attribute>
                                                    Trademarks
                                                </a>
                                                .
                                                <a style="{$cssA}text-decoration:none">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$privacy-page-url"/>
                                                    </xsl:attribute>
                                                    Privacy policy
                                                </a>
                                                .
                                            </p>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="starts-with($site,'us')">
                                    <tr>
                                        <td style="padding:5px 10px; background:#DDE1EF">
                                            <h1 style="{$styleFont} font-size: 0.9em; font-weight:bold; margin:0px">
                                                Further Information
                                            </h1>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 20px 20px 0px 20px;{$styleFont}{$styleFontSize}">
                                            <p>
                                                Change your
                                                <a target="_blank" style="{$cssA}">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$email-prefernces-page-url"/>
                                                    </xsl:attribute>
                                                    preferences
                                                </a>
                                                /stop receiving e-mail.
                                                <a target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$feedback-page-url-us"/>
                                                    </xsl:attribute>
                                                    Contact
                                                </a>
                                                editorial team.
                                                <a style="{$cssA}" target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$password-reminder-page-url"/>
                                                    </xsl:attribute>
                                                    Request
                                                </a>
                                                a password reminder.
                                                <br/>
                                                <br/>
                                                <a target="_blank" style="{$cssA}">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$twitter-info-url-us"/>
                                                    </xsl:attribute>
                                                    Follow
                                                </a>
                                                us on Twitter.
                                                <a target="_blank" style="{$cssA}">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$rss-info-url-us"/>
                                                    </xsl:attribute>
                                                    Subscribe
                                                </a>
                                                to our RSS feeds to receive legal updates on an RSS reader or your
                                                personal news page.
                                                <br/>
                                                <br/>
                                                For other assistance including technical help contact<a style="{$cssA}"
                                                                                                        href="mailto:info-us@practicallaw.com">
                                                info-us@practicallaw.com</a>.
                                                <br/>
                                                For more information on PLC products please contact<a style="{$cssA}"
                                                                                                      href="mailto:ian.nelson@practicallaw.com">
                                                ian.nelson@practicallaw.com</a>.
                                                <br/>
                                                <br/>
                                                Practical Law Company offers complimentary training on all of our
                                                professional support services to subscribing firms. If you are
                                                interested in having a trainer visit your offices or would like a remote
                                                demonstration please
                                                <a target="_blank">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$training-page-url-us"/>
                                                    </xsl:attribute>
                                                    click here
                                                </a>
                                                .
                                                <br/>
                                                <br/>
                                                Copyright
                                                <xsl:value-of select="$copy"/> 2012 Practical Law Publishing Limited and
                                                Practical Law Company, Inc. All Rights Reserved. Use of PLC websites and
                                                services is subject to the
                                                <a target="_blank" href="{$articleserver}/2-383-6690?{$footer-tag}">
                                                    Terms of Use (us.practicallaw.com/2-383-6690)
                                                </a>
                                                and<a target="_blank" href="{$articleserver}/8-383-6692?{$footer-tag}">
                                                Privacy Policy (us.practicallaw.com/8-383-6692)</a>.
                                            </p>

                                        </td>
                                    </tr>
                                </xsl:if>
                                <tr>
                                    <td style="padding:  10px 20px 20px 20px">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td style="{$styleFont}{$styleFontSize}border-top:1px dotted #ccc; padding-top:20px">
                                                    <a href="#top" style="color:#0005E1;font-weight:bold">Back to top
                                                    </a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="bridgehead"/>

    <xsl:template match="metadata/abstract">
        <xsl:if test="string-length(.)&gt;0">
            <tr>
                <td style="padding: 20px 40px 0px 40px ">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0"
                           style="border-bottom: 1px dotted #ccc">
                        <tr>
                            <td style="padding-bottom:20px;{$styleFont} {$styleFontSize}">
                                <xsl:apply-templates/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="para">
        <xsl:choose>
            <xsl:when test="$site='plc' ">
                <br/>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="section1">

        <xsl:if test="preceding-sibling::*[1][name()='bridgehead']">

            <tr>

                <td style="padding: 0px 20px 10px 20px;">

                    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#333366;">

                        <tr>

                            <td>

                                <h1 style="{$styleFont}font-size: 1em; font-weight:bold; margin: 0px; padding: 5px 10px;  color: #FFFFFF;">
                                    <xsl:value-of select="preceding-sibling::bridgehead[1]"/>
                                </h1>

                            </td>

                        </tr>

                    </table>

                </td>

            </tr>

        </xsl:if>

        <tr>
            <td style="padding: 0px 20px">
                <!--<a name="{translate(title, ' ', '')}"/>-->
                <a name="sect{position()-count(preceding-sibling::bridgehead)-count(preceding-sibling::processing-instruction())}"/>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="padding:5px 10px; background:#DDE1EF">
                            <h1 style="{$styleFont} font-size: 0.9em; font-weight:bold; margin:0px">
                                <xsl:value-of select="title"/>
                            </h1>
                        </td>
                    </tr>
                    <tr>
                        <td style="{$styleFont} {$styleFontSize}padding: 20px 20px 0px 20px;">
                            <xsl:apply-templates/>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:  10px 20px 20px 20px">
                            <xsl:if test="count(section2) = 0">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td style="{$styleFont}{$styleFontSize}border-top:1px dotted #ccc; padding-top:20px">
                                            <a href="#top" style="color:#0005E1;font-weight:bold">Back to top</a>
                                        </td>
                                    </tr>
                                </table>
                            </xsl:if>
                            <xsl:if test="count(section2) &gt; 0">
                                <a href="#top" style="{$styleFont}{$styleFontSize}color:#0005E1;font-weight:bold">Back
                                    to top
                                </a>
                            </xsl:if>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="section1/title"/>

    <xsl:template match="section2">

        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
                <td style="{$styleFont}{$styleFontSize} padding-bottom:20px">
                    <xsl:apply-templates/>
                </td>
            </tr>
            <tr>
                <td height="10" style="border-top: 1px dotted #ccc">
                    <xsl:value-of select="$nbsp"/>
                </td>
            </tr>
        </table>

    </xsl:template>

    <xsl:template match="section2/title">
        <xsl:choose>
            <xsl:when test="$emailtype='publicationsportal'">
                <xsl:call-template name="section2_pubportal"/>
            </xsl:when>
            <xsl:otherwise>
                <h2 style="{$styleFont} font-weight:bold; margin: 0px; font-size: 1em">
                    <xsl:value-of select="."/>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- contents menu -->
    <xsl:template name="contents">

        <tr>
            <td style="padding: 20px">

                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td style="padding:5px 10px; background: #e1e1e1 url(${common-images-location}/horizDots.gif) repeat-x bottom; background-color: #e1e1e1">
                            <xsl:if test="not($site='fs')">
                                <h1 style="{$styleFont} font-size: 0.9em; font-weight:bold; margin:0px">Contents</h1>
                            </xsl:if>
                            <xsl:if test="$site='fs'">
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <h1 style="{$styleFont} font-size: 0.9em; font-weight:bold; margin:0px">
                                                Contents
                                            </h1>
                                        </td>
                                        <td width="50%" align="right">
                                            <a href="http://{$site}.practicallaw.com/jsp/updates.jsp"
                                               style="{$styleFont}font-size:0.8em;font-weight:bold"
                                               title="Print these updates">Print updates
                                            </a>
                                        </td>
                                    </tr>
                                </table>
                            </xsl:if>
                        </td>
                    </tr>
                </table>
                <xsl:choose>
                    <xsl:when test="$emailtype='publicationsportal'">
                        <xsl:call-template name="maincontents_pubportal"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="maincontents"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="maincontents">
        <xsl:variable name="sect1" select="fulltext/section1"/>
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f5f5f5">
            <tr>
                <td style="padding: 10px 20px">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f5f5f5">
                        <tr>
                            <xsl:choose>
                                <xsl:when
                                        test="(count($sect1) &gt; 7 and count($sect1) &lt; 15 and $isMultiJurisdictional = 'true') or (count($sect1) &gt; 7 and $isMultiJurisdictional != 'true')">
                                    <td width="50%" valign="top">
                                        <ul style="margin:0px; padding: 0px">
                                            <xsl:for-each
                                                    select="$sect1[position() &lt;= round(count(../section1) div 2)]">
                                                <xsl:call-template name="contentsLink">
                                                    <xsl:with-param name="position" select="position()"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                    <td width="50%" valign="top">
                                        <ul style="margin:0px; padding: 0px">
                                            <xsl:for-each
                                                    select="$sect1[position() &gt; round(count(../section1) div 2)]">
                                                <xsl:call-template name="contentsLink">
                                                    <xsl:with-param name="position"
                                                                    select="position()+round(count(../section1) div 2)"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </xsl:when>
                                <xsl:when test="count($sect1) &gt;= 15 and $isMultiJurisdictional =  'true'">
                                    <td width="33%" valign="top">

                                        <ul style="margin:0px; padding: 0px">
                                            <xsl:for-each
                                                    select="$sect1[position() &lt;= round(count(../section1) div 3)]">
                                                <xsl:call-template name="contentsLink">
                                                    <xsl:with-param name="position" select="position()"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                    <td valign="top">
                                        <ul style="margin:0px; padding: 0px">
                                            <xsl:for-each
                                                    select="$sect1[position() &gt; round(count(../section1) div 3) and position() &lt;= (2 * round(count(../section1) div 3))]">
                                                <xsl:call-template name="contentsLink">
                                                    <xsl:with-param name="position"
                                                                    select="position()+round(count(../section1) div 3)"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                    <td width="33%" valign="top">
                                        <ul style="margin:0px; padding: 0px">
                                            <xsl:for-each
                                                    select="$sect1[position() &gt; (2 * round(count(../section1) div 3))]">
                                                <xsl:call-template name="contentsLink">
                                                    <xsl:with-param name="position"
                                                                    select="position()+(round(count(../section1) div 3) * 2)"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ul style="margin:0px; padding: 0px">
                                        <xsl:for-each select="$sect1">
                                            <xsl:call-template name="contentsLink">
                                                <xsl:with-param name="position" select="position()"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="contentsLink">
        <xsl:param name="position"/>
        <xsl:variable name="theTitle">
            <xsl:choose>
                <xsl:when test="contains(title,'&#xa0;')">
                    <xsl:value-of select="substring-before(title,'&#xa0;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li style="{$styleFont} {$styleFontSize}list-style:none">
            <!--<a href="#{translate($theTitle, ' ', '')}" style="{$cssA}font-weight:bold"><xsl:value-of select="$theTitle" /></a>-->
            <a href="#sect{$position}" style="{$cssA}font-weight:bold">
                <xsl:value-of select="$theTitle"/>
            </a>
        </li>
        <xsl:choose>
            <xsl:when test="$emailtype='publicationsportal'">
                <xsl:call-template name="make_subtitle_pubportal">
                    <xsl:with-param name="position" select="$position"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="make_subtitle">
                    <xsl:with-param name="position" select="$position"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- defalt is to do nothing -->
    <xsl:template name="make_subtitle">
        <xsl:param name="position"/>
    </xsl:template>

    <!-- next 5 taken from GENERIC.XSL -->
    <xsl:template match="br">
        <br/>
    </xsl:template>

    <xsl:template match="itemizedlist">
        <ul style="list-style-type:square;">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="orderedlist">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="listitem">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="emphasis[@role='bold']">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="emphasis[@role='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="emphasis[@role='bold-italic']">
        <strong>
            <em>
                <xsl:apply-templates/>
            </em>
        </strong>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="metadata"></xsl:template>

    <!--hide locator from output-->
    <xsl:template match="locator"></xsl:template>

    <!--links - take cover! -->
    <xsl:template match="simpleplcxlink">
        <a style="{$cssA}">
            <xsl:attribute name="href">
                <xsl:value-of select="@xlink:href"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>


    <xsl:template match="plclink">
        <xsl:variable name="sLinkText">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:element name="a">
            <xsl:attribute name="style">
                <xsl:value-of select="$cssA"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="locator/@role[.='Article']">
                    <xsl:choose>
                        <xsl:when test="contains($universal,'true')">
                            <!--							<xsl:attribute name="href">http://<xsl:value-of select="$site" />.practicallaw.com/jsp/article.jsp?item=<xsl:value-of select="locator/@href"/> -->
                            <xsl:attribute name="href">
                                <xsl:value-of select="$articleserver"/><xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--<xsl:attribute name="href">http://<xsl:value-of select="$site" />.practicallaw.com/jsp/article.jsp?item=<xsl:value-of select="locator/@href"/> -->
                            <xsl:attribute name="href">
                                <xsl:value-of select="$articleserver"/><xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--	<xsl:apply-templates />-->
                </xsl:when>
                <xsl:when test="@xml:link[.='simple']">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!--Apply-templates here would put in the link text. Instead, the title attribute is used.-->
            <!--Link text-->
            <xsl:apply-templates/>
            <!--end of link text-->
        </xsl:element>
    </xsl:template>

    <xsl:template match="a">
        <xsl:variable name="sHref">
            <xsl:value-of select="@href"/>
        </xsl:variable>
        <xsl:variable name="sName">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <a style="{$cssA}">

            <xsl:choose>
                <xsl:when test="starts-with($sHref, '/scripts/')">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$articleserver"/><xsl:value-of select="@href"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="starts-with($sHref, '/update/')">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$articleserver"/><xsl:value-of select="@href"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="starts-with($sHref, '/order/')">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$articleserver"/><xsl:value-of select="@href"/>
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
            <xsl:if test="not($sName='')">
                <xsl:attribute name="name">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="plcxlink">
        <!-- CB feb 2007 we need to allow xrefs with no text. this is because the text (e.g. clause x.x) is autogenerated from the link target -->

        <xsl:if test="(string-length(xlink:locator) &gt; 0) or (descendant::xref)"><!-- and string-length(xlink:locator/@xlink:href) &gt; 0 removed this logic so links with no href will render, this should help the document stay valid but really all links should  -->

            <a>
                <xsl:if test="string-length(xlink:locator) &gt; 50 and not(contains(xlink:locator, ' '))">
                    <xsl:attribute name="class">linkBreak</xsl:attribute>
                </xsl:if>
                <!-- *** dodgy test to open da links in new window - if too fuzzy, use separate parameter *** -->
                <!-- cb - added extra logic so that xrefs open in the same window -->
                <xsl:if test="($articleserver!='') and not (descendant::xref)">
                    <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:if>
                <!-- Is it a PLC Reference? we want to count the length of the href to see if it's a new plc ref,
                    but new plc ref might have a querystring hash locator tacked on the end. 'substring-before' returns
                    empty if the substring isn't found, otherwise it finds the first occurrence of the substring. so let's
                    stick a ? and hash at the end of the string regardless of whether there's one there already. Also test
                    it contains at least one dash, and it's numeric when the dashes are stripped.
                    -->
                <xsl:variable name="tempPlcRef2" select="substring-before(concat(xlink:locator/@xlink:href,'#'),'#')"/>
                <xsl:variable name="plcRefCandidate2" select="substring-before(concat($tempPlcRef2,'?'),'?')"/>
                <xsl:choose>
                    <xsl:when
                            test="string-length($plcRefCandidate2)=10 and contains($plcRefCandidate2, '-') and string(number(translate($plcRefCandidate2,'-','')))!='NaN' and not (xlink:arc/@xlink:show[.='embed'])">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="xlink:locator/@xlink:role[.='Organisation']">
                                <strong>
                                    <xsl:apply-templates/>
                                </strong>
                            </xsl:when>
                            <xsl:when test="xlink:locator/@xlink:role[.='Contact']">
                                <em>
                                    <!-- added -->
                                    <!-- eh? by whom? when? -->
                                    <xsl:choose>
                                        <xsl:when
                                                test="generate-id(parent::para)=generate-id(ancestor::subclause1[1]/para)">
                                            <xsl:call-template name="convert-case-with-index">
                                                <xsl:with-param name="letter-index" select="1"/>
                                                <xsl:with-param name="word" select="xlink:locator/text()"/>
                                                <xsl:with-param name="case" select="'upper'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </em>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- CB note a whole block of code has been omitted here - stuff with plcrefs - as follows
                        <xsl:text> (www.practicallaw.com/</xsl:text>
                                <xsl:value-of select="$plcRefCandidate"/>)
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$articleserver"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:attribute>
                                <xsl:apply-templates />
                            </xsl:otherwise>
                        </xsl:choose>
                        -->
                    </xsl:when>

                    <xsl:when test="xlink:locator/@xlink:role[.='Article'] and not (xlink:arc/@xlink:show[.='embed'])">
                        <xsl:choose>
                            <xsl:when test="starts-with(xlink:locator/@xlink:href, '#')">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$articleserver"/>
                                    <!--								<xsl:choose>
                                                                        <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                                                        <xsl:otherwise>/A</xsl:otherwise>
                                                                    </xsl:choose> -->
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>

                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="normalize-space(xlink:locator)"/>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='dbrecord']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="locator/@href"/>
                        </xsl:attribute>
                        <xsl:value-of select="xlink:locator"/>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Organisation']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/O</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <strong>
                            <xsl:value-of select="normalize-space(xlink:locator)"/>
                        </strong>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Topic']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/T</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(xlink:locator)"/>

                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Web']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/W</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(xlink:locator)"/>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Contact']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/C</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <em>
                            <xsl:value-of select="normalize-space(xlink:locator)"/>
                        </em>
                    </xsl:when>
                    <!-- ref xlink for precedents. -->
                    <!-- CB changed Spet 2003 to autogenerate link content -->
                    <xsl:when test="xlink:locator/@xlink:role[.='xref']">
                        <xsl:if test="contains(xlink:locator/@xlink:href, 'navigator')">
                            <xsl:attribute name="target">
                                <xsl:text>navigator</xsl:text>
                            </xsl:attribute>
                        </xsl:if>

                        <xsl:attribute name="href">
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>

                        <!--<xsl:attribute name="class">xref</xsl:attribute>-->
                        <em>
                            <xsl:apply-templates select="xlink:locator/xref"/>
                        </em>
                    </xsl:when>
                    <!-- non em version for da -->
                    <xsl:when test="xlink:locator/@xlink:role[.='defxref']">
                        <!--					<xsl:if test="contains(xlink:locator/@xlink:href, 'navigator')">
                                                <xsl:attribute name="target"><xsl:text>navigator</xsl:text></xsl:attribute>
                                            </xsl:if>	-->
                        <xsl:attribute name="href">
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">xref</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="ancestor::title and not(ancestor::letter)">
                                <xsl:call-template name="convert-case-with-index">
                                    <xsl:with-param name="word" select="xlink:locator/xref"/>
                                    <xsl:with-param name="whole-word" select="'yah-huh'"/>
                                    <xsl:with-param name="case" select="'upper'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="xlink:locator/xref"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Authority/ External File. Still in development stages. -->
                    <xsl:when test="xlink:locator/@xlink:role[.='AuthorityFile']">
                        <xsl:attribute name="href">
                            <xsl:text>javascript:openWindow('http://city/webtest/legalcitator/authority.asp?authority_id=</xsl:text>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                            <xsl:text>',450)</xsl:text>
                        </xsl:attribute>
                        <em>
                            <xsl:apply-templates/>
                        </em>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='External']">
                        <xsl:attribute name="href">
                            <xsl:text>/citatordemo/doitourl.asp?doi=</xsl:text>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <em>
                            <xsl:apply-templates/>
                        </em>
                    </xsl:when>
                    <!-- for plc files link -->
                    <xsl:when test="not (xlink:locator/@xlink:role)">
                        <xsl:attribute name="href">
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <em>
                            <xsl:apply-templates/>
                        </em>
                    </xsl:when>
                    <!--	This template will match when all else fails, generally when something has gone since one
                            of the other templates SHOULD match first but since people code incorrectly we have to have this template -->
                    <xsl:otherwise>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="string-length(xlink:locator/@xlink:href) &gt; 0">
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>javascript:void(0)</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>

        </xsl:if>
    </xsl:template>

    <!-- character conversion-->
    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <xsl:choose>
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
        </xsl:choose>
    </xsl:template>

    <xsl:template name="convert-case-with-index">
        <xsl:param name="letter-index"/>
        <xsl:param name="whole-word"/>
        <xsl:param name="word"/>
        <xsl:param name="case"/>
        <xsl:choose>
            <xsl:when test="string($whole-word)">
                <xsl:choose>
                    <xsl:when test="$case='lower'">
                        <xsl:value-of
                                select="translate($word,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                    </xsl:when>
                    <xsl:when test="$case='upper'">
                        <xsl:value-of
                                select="translate($word,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string($letter-index)">
                <xsl:variable name="string-before-index" select="substring($word,1,($letter-index)-1)"/>
                <xsl:variable name="string-after-index"
                              select="substring($word,($letter-index)+1,string-length($word))"/>
                <xsl:variable name="index-letter">
                    <xsl:choose>
                        <xsl:when test="$letter-index = string-length($word)">
                            <xsl:value-of select="substring($word,$letter-index)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                    select="substring-after(substring-before($word,$string-after-index),$string-before-index)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="lower-index-letter">
                    <xsl:choose>
                        <xsl:when test="$case='lower'">
                            <xsl:value-of
                                    select="translate($index-letter,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                        </xsl:when>
                        <xsl:when test="$case='upper'">
                            <xsl:value-of
                                    select="translate($index-letter,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($string-before-index,$lower-index-letter,$string-after-index)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- override the defaultcontents menu -->
    <xsl:template name="maincontents_pubportal">
        <xsl:variable name="sect1" select="fulltext/section1"/>
        <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f5f5f5">
            <tr>
                <td style="padding: 10px 20px">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f5f5f5">
                        <tr>
                            <td width="100%" valign="top">
                                <ul style="margin:0px; padding: 0px">
                                    <xsl:for-each select="$sect1">
                                        <xsl:call-template name="contentsLink">
                                            <xsl:with-param name="position" select="position()"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </ul>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!-- turn  section2/title into a link -->
    <xsl:template name="section2_pubportal">
        <xsl:variable name="plcreflinkarticle">
            <xsl:value-of
                    select="parent::section2/para/plcxlink/xlink:locator[contains(text(),'Read more')]/attribute::xlink:href"/>
        </xsl:variable>
        <h2 style="{$styleFont} font-weight:bold; margin: 0px; font-size: 1em">
            <a style="{$cssA}">
                <xsl:attribute name="href">
                    <xsl:value-of select="$articleserver"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$plcreflinkarticle"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </h2>
    </xsl:template>

    <!-- defalt is to do nothing -->
    <xsl:template name="make_subtitle_pubportal">
        <xsl:param name="position"/>
        <xsl:for-each select="section2/title">
            <li style="{$styleFont} {$styleFontSize}list-style:none">
                <a href="#sect{$position}" style="{$cssA}">
                    <xsl:value-of select="."/>
                </a>
            </li>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
