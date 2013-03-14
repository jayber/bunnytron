<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
        >

    <xsl:output method="xml" encoding="utf-8"/>

    <!--<xsl:strip-space elements="*"/>-->

    <xsl:template match="practicenote">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <practicenote>
            <xsl:apply-templates select="node()|@*"/>
        </practicenote>
    </xsl:template>

    <xsl:template match="orgprofile">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <orgprofile>
            <xsl:apply-templates select="node()|@*"/>
        </orgprofile>
    </xsl:template>

    <xsl:template match="article">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <orgprofile>
            <xsl:apply-templates select="node()|@*"/>
        </orgprofile>
    </xsl:template>

    <xsl:template match="checklist">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <checklist>
            <xsl:apply-templates select="node()|@*"/>
        </checklist>
    </xsl:template>

    <xsl:template match="precedent">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <precedent>
            <xsl:apply-templates select="node()|@*"/>
        </precedent>
    </xsl:template>

    <xsl:template match="training">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <training>
            <xsl:apply-templates select="node()|@*"/>
        </training>
    </xsl:template>

    <xsl:template match="trainingquestion">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <training>
            <xsl:apply-templates select="node()|@*"/>
        </training>
    </xsl:template>

    <xsl:template match="legalupdate">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <legalupdate>
            <xsl:apply-templates select="node()|@*"/>
        </legalupdate>
    </xsl:template>

    <xsl:template match="topic">
 <xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <topic>
            <xsl:apply-templates select="node()|@*"/>
        </topic>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="para/@*">
    </xsl:template>

    <xsl:template match="metadata">
        <metadata></metadata>
    </xsl:template>

    <xsl:template match="section2[contains(title,'[')][contains(title,']')]">
        <xsl:variable name="prefirmid">
            <xsl:value-of select="substring-after(title,'[')"/>
        </xsl:variable>
        <xsl:variable name="firm_title">
            <xsl:value-of select="substring-before(title,'[')"/>
        </xsl:variable>
        <xsl:variable name="firm_id">
            <xsl:value-of select="substring-before($prefirmid,']')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string(number($firm_id))='NaN'">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <section2>
                    <title>
                        <xsl:value-of select="$firm_title"/>
                    </title>
                    <para>
                        <plcxlink>
                            <xlink:locator xlink:role="Organisation" xlink:title="Firm Office">
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="$firm_id"/>
                                </xsl:attribute>
                                <xsl:value-of select="$firm_title"/>
                            </xlink:locator>
                            <xlink:arc xlink:arcrole="Part Of" xlink:show="embed" xlink:actuate="onLoad"
                                       xlink:from="source" xlink:to="target"/>
                        </plcxlink>
                    </para>
                </section2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()[starts-with(.,'&#9;')]">
        <xsl:value-of select="substring-after(.,'&#9;')"/>
    </xsl:template>

</xsl:stylesheet>
