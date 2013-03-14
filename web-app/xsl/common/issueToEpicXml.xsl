<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:output method='xml' omit-xml-declaration="yes"/>

    <xsl:template match="@*|node()">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>


    <xsl:template match="issue">
        <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0"?>&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002 &lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd"> --></xsl:text>
        <topic xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:apply-templates select="topicMetaData"/>
            <editorial>
                <!--  we want the editor content always to appear at the top of the output because that's what's carried over when regenerating
                the issue content - the first section1 encountered -->
                <xsl:apply-templates select="editorContent"/>
                <xsl:apply-templates select="*[not(name(.)='topicMetaData' or name(.)='editorContent')]"/>
            </editorial>
        </topic>
    </xsl:template>

    <xsl:template match="topicMetaData">
        <metadata>
            <xsl:copy-of select="child::*"/>
        </metadata>
    </xsl:template>

    <xsl:template match="editorContent">
        <section1>
            <xsl:copy-of select="child::*"/>
        </section1>
    </xsl:template>

    <xsl:template match="sectionType">
        <section1>
            <title>
                <xsl:value-of select="displayName"/>
            </title>
            <xsl:apply-templates select="section"/>
        </section1>
    </xsl:template>

    <xsl:template match="section">
        <section2>
            <title>
                <xsl:value-of select="displayName"/>
            </title>
            <!-- SC 27/07/09 - these should display as a bulleted list -->
            <xsl:if test="count(resource)&gt;0">
                <itemizedlist>
                    <xsl:apply-templates select="resource"/>
                </itemizedlist>
            </xsl:if>
        </section2>
    </xsl:template>

    <xsl:template match="resource">
        <!-- SC 27/07/09 - these should display as a bulleted list -->
        <!--<para>-->
        <listitem>
            <plcxlink>
                <xlink:locator xlink:role="Article">
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="plcReference"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:title">
                        <xsl:value-of select="title"/>
                    </xsl:attribute>
                    <xsl:value-of select="title"/>
                </xlink:locator>
            </plcxlink>
        </listitem>
        <!--</para>-->
    </xsl:template>


    <!-- link syntax
      <plcxlink><xlink:locator xlink:href="8-107-4581" xlink:role="Article" xlink:title="Practice notes: multi-jurisdictional">Practice notes: multi-jurisdictional</xlink:locator></plcxlink>
    -->

</xsl:stylesheet>