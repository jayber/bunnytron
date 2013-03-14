<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
    ========================================================================
                             LETTER/BOARD MINUTES DTD
    ========================================================================
    -->

    <xsl:template match="salutation">
        <br/>
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="letterhead">
        <p>
            <i>[On headed notepaper of <xsl:value-of select="attribute::partyhead"/>]
            </i>
        </p>
    </xsl:template>

    <xsl:template match="addressline">
        <xsl:if test="string-length(.) &gt; 0">
            <xsl:apply-templates/>
            <br/>
        </xsl:if>
    </xsl:template>

    <!--
    <xsl:template match="letterhead[ancestor::minutes]">
        <p><i>[NAME OF COMPANY] LIMITED/PLC</i></p>
    </xsl:template>-->

    <xsl:template match="minuteheader">
        <xsl:choose>
            <xsl:when test="*">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>Minutes of a meeting of the Board of Directors of [NAME OF COMPANY] (<strong>Company</strong>) held
                    at [PLACE] on [DATE] at [TIME].
                </p>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="attendance">
        <xsl:choose>
            <xsl:when test="*">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <table cellpadding="5" cellspacing="0" class="Table" width="100%">
                    <tr>
                        <td width="20%" valign="top" align="left">
                            <p>
                                <strong>PRESENT:</strong>
                            </p>
                        </td>
                        <td width="40%" valign="top" align="left">
                            <p>
                                <strong>NAME</strong>
                            </p>
                        </td>
                        <td width="40%" valign="top" align="left">
                            <p>
                                <strong>POSITION</strong>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                            </p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                            </p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                            </p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="left">
                            <p>
                                <strong>IN ATTENDANCE:</strong>
                            </p>
                        </td>
                        <td valign="top" align="left">
                            <p>
                                <strong>NAME</strong>
                            </p>
                        </td>
                        <td valign="top" align="left">
                            <p>
                                <strong>POSITION</strong>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                            </p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                            </p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                            </p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                        <td valign="top">
                            <p>................................</p>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                                <strong>[APOLOGIES FOR ABSENCE RECEIVED FROM:</strong>
                            </p>
                        </td>
                        <td valign="bottom">
                            <p>................................</p>
                        </td>
                        <td valign="bottom">
                            <p>................................
                                <strong>]</strong>
                            </p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="date">
        <xsl:choose>
            <xsl:when test="text()|*">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>200[]</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="sincerely">
        <xsl:choose>
            <xsl:when test="text()|*">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>Yours faithfully,</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
