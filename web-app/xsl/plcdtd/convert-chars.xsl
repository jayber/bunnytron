<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

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
            <xsl:when test="contains ($this_string,'&#8722;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'&#8722;')"/>
                </xsl:call-template>
                <xsl:text disable-output-escaping="yes">&amp;#8722;</xsl:text>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'&#8722;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string,'&#324;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'&#324;')"/>
                </xsl:call-template>
                <xsl:text disable-output-escaping="yes">&amp;#324;</xsl:text>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'&#324;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>