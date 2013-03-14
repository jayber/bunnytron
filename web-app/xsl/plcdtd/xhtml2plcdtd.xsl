<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <!-- stylesheet for converting abstracts to plcdtd
    ColinC/ChrisB-->


    <!-- <xsl:output method="html"/> -->
    <xsl:output omit-xml-declaration="yes" method="xml"/>

    <!--<xsl:preserve-space elements="*" />-->
    <xsl:strip-space elements="*"/>

    <!--
    ========================================================================
                              TOP LEVEL ELEMENTS
    ========================================================================
    -->

    <xsl:template match="abstract">
        <!-- iterate through all children. test for each whether opening and closing block level tags need to be added-->
        <abstract>
            <xsl:call-template name="process_abstract"/>
        </abstract>
        <!--
        <xsl:choose>
            <xsl:when test="(count(child::p) &gt; 0) or (count(child::P) &gt; 0)">
                <abstract><xsl:apply-templates/></abstract>
            </xsl:when>
            <xsl:otherwise>
                <abstract><para><xsl:apply-templates/></para></abstract>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>

    <xsl:template name="check_addblockstart">
        <xsl:if test="not (name(preceding-sibling::node()[1]) = 'i') and not (name(preceding-sibling::node()[1]) = 'b') and not (name(preceding-sibling::node()[1]) = 'a')  and not (name(preceding-sibling::node()[1]) = 'plclink') and not (preceding-sibling::node()[1][self::text()])">
            <xsl:text disable-output-escaping="yes">&lt;para></xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="check_addblockend">
        <!--<xsl:if test="not (name(following-sibling::node()[1]) = 'i') and not (name(following-sibling::node()[1]) = 'b') and not (name(preceding-sibling::node()[1]) = 'a')  and not (name(following-sibling::node()[1]) = 'plclink') and not (preceding-sibling::node()[1][self::text()])">
            <xsl:text disable-output-escaping="yes">&lt;/para></xsl:text>
        </xsl:if>-->
        <xsl:if test="not (name(following-sibling::node()[1]) = 'i') and not (name(following-sibling::node()[1]) = 'b') and not (name(following-sibling::node()[1]) = 'a')  and not (name(following-sibling::node()[1]) = 'plclink') and not (following-sibling::node()[1][self::text()])">
            <xsl:text disable-output-escaping="yes">&lt;/para></xsl:text>
        </xsl:if>
    </xsl:template>


    <xsl:template match="html">
  <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0"?>&lt;!-- Fragment document type declaration subset: 
ArborText, Inc., 1988-2001, v.4002 
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">
-->
</xsl:text>
        <practicenote>
            <metadata>
            </metadata>
            <fulltext>
                <section1>
                    <xsl:apply-templates/>
                    <xsl:if test="(count(preceding-sibling::h4[1]/following-sibling::*) &lt; count(preceding-sibling::h3[1]/following-sibling::*)) and (count(preceding-sibling::h4[1]/following-sibling::*) != 0)">
                        <xsl:text disable-output-escaping="yes">&lt;/section2></xsl:text>
                    </xsl:if>
                </section1>
            </fulltext>
        </practicenote>
    </xsl:template>

    <xsl:template match="head">
    </xsl:template>

    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
    ========================================================================
                              HEADINGS
    ========================================================================
    -->

    <xsl:template match="h1|h2">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xsl:template match="h3">
        <xsl:if test="(count(preceding-sibling::h4[1]/following-sibling::*) &lt; count(preceding-sibling::h3[1]/following-sibling::*)) and (count(preceding-sibling::h4[1]/following-sibling::*) != 0)">
            <xsl:text disable-output-escaping="yes">&lt;/section2></xsl:text>
        </xsl:if>
        <xsl:text disable-output-escaping="yes">&lt;/section1></xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;section1</xsl:text>
        <xsl:if test="a/attribute::id">
            <xsl:text disable-output-escaping="yes"> id='</xsl:text><xsl:value-of select="a/attribute::id"/><xsl:text
                disable-output-escaping="yes">'</xsl:text>
        </xsl:if>
        <xsl:text disable-output-escaping="yes">></xsl:text>
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xsl:template match="h4">
        <xsl:if test="(count(preceding-sibling::h4[1]/following-sibling::*) &lt; count(preceding-sibling::h3[1]/following-sibling::*)) and (count(preceding-sibling::h4[1]/following-sibling::*) != 0)">
            <xsl:text disable-output-escaping="yes">&lt;/section2></xsl:text>
        </xsl:if>
        <!--
        <num1>
        <xsl:value-of select="count(preceding-sibling::h4[1]/following-sibling::*)"/>
        </num1>
        <num2>
        <xsl:value-of select="count(preceding-sibling::h3[1]/following-sibling::*)"/>
        </num2>
        -->
        <xsl:text disable-output-escaping="yes">&lt;section2</xsl:text>
        <xsl:if test="a/attribute::id">
            <xsl:text disable-output-escaping="yes"> id='</xsl:text><xsl:value-of select="a/attribute::id"/><xsl:text
                disable-output-escaping="yes">'</xsl:text>
        </xsl:if>
        <xsl:text disable-output-escaping="yes">></xsl:text>
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <!--
    ========================================================================
                              TABLES
    ========================================================================
    -->
    <!--
    match: table, informaltable
    ===========================
    Convert an XML table into an HTML table.
    Taken from Learning XML
    -->
    <xsl:template match="table">
        <table>
            <tgroup>
                <xsl:attribute name="cols">
                    <xsl:value-of select="count(descendant::tr[1]/td)"/>
                </xsl:attribute>
                <tbody>
                    <xsl:apply-templates/>
                </tbody>
            </tgroup>
        </table>
    </xsl:template>

    <xsl:template match="tr">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>


    <xsl:template match="td">
        <entry>
            <xsl:choose>
                <xsl:when test="not (descendant::para)">
                    <para>
                        <xsl:apply-templates/>
                    </para>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </entry>
    </xsl:template>

    <!--
    ========================================================================
                              LISTS
                              modified 17.1.03 to deal with new list structure
    ========================================================================
    -->
    <xsl:template match="ul|UL">
        <itemizedlist>
            <xsl:apply-templates/>
        </itemizedlist>
    </xsl:template>

    <xsl:template match="ol|OL">
        <orderedlist>
            <xsl:choose>
                <xsl:when test="attribute::type='a'">
                    <xsl:attribute name="name">loweralpha</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </orderedlist>
    </xsl:template>

    <xsl:template match="li|LI">
        <xsl:choose>
            <xsl:when test="p">
                <listitem>
                    <xsl:apply-templates/>
                </listitem>
            </xsl:when>
            <xsl:otherwise>
                <listitem>
                    <para>
                        <xsl:apply-templates/>
                    </para>
                </listitem>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
    ========================================================================
                              PARAGRAPH
    ========================================================================
    -->
    <xsl:template match="para[preceding-sibling::*[1]/attribute::class='runIn']">
        <p class="runin">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="p|P">
        <para>
            <xsl:apply-templates/>
        </para>
    </xsl:template>

    <xsl:template match="p/p|P/p|p/P|P/P">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="br|Br|bR|BR">
        <xsl:value-of select="'&lt;/para&gt;&lt;para&gt;'" disable-output-escaping="yes"/>
        <xsl:apply-templates/>
    </xsl:template>


    <!--
    ========================================================================
                              INLINE
    ========================================================================
    -->

    <xsl:template match="em|i|I">
        <xsl:choose>
            <xsl:when test="parent::plclink|plclink">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="parent::a">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <emphasis role="italic">
                    <xsl:apply-templates/>
                </emphasis>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="strong|b">
        <emphasis role="bold">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>

    <xsl:template match="blockquote|Blockquote">
        <blockquote>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>

    <xsl:template match="img|IMG">
        <graphic>
            <xsl:choose>
                <xsl:when test="@src">
                    <xsl:attribute name="fileref">
                        <xsl:value-of select="@src"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@SRC">
                    <xsl:attribute name="fileref">
                        <xsl:value-of select="@SRC"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@align">
                <xsl:attribute name="align">
                    <xsl:value-of select="@align"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@width">
                <xsl:attribute name="width">
                    <xsl:value-of select="@width"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@height">
                <xsl:attribute name="depth">
                    <xsl:value-of select="@height"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@alt">
                <xsl:attribute name="srccredit">
                    <xsl:value-of select="@alt"/>
                </xsl:attribute>
            </xsl:if>
        </graphic>
    </xsl:template>
    <!--
    ========================================================================
                              Q AND A
    ========================================================================
    -->

    <xsl:template match="div[@class='qanda']">
        <qandaentry>
            <xsl:apply-templates/>
        </qandaentry>
    </xsl:template>

    <!--
    ========================================================================
                              TEXT
    ========================================================================
    -->

    <xsl:template match="text()">
        <xsl:call-template name="convert-ndash">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!--
    ========================================================================
                              XLINKS
    ========================================================================
    -->

    <!--turn a into plcxlinks-->
    <xsl:template match="a[attribute::href]">
        <!-- if the link contains em tags, wrap the link with emphasis - the em tag will be removed in the em part of the style sheet.-->
        <xsl:if test="(self::node()/em) and (not(parent::em|i))">
            <xsl:text disable-output-escaping="yes">&lt;emphasis role="italic"></xsl:text>
        </xsl:if>

        <xsl:variable name="href">
            <xsl:value-of select="attribute::href"/>
        </xsl:variable>

        <xsl:variable name="hrefPathName">
            <xsl:call-template name="urlPathName">
                <xsl:with-param name="url" select="$href"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="isPlcReference">
            <xsl:call-template name="isPlcReference">
                <xsl:with-param name="inValue" select="$hrefPathName"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="self::node()[contains($href,'gcdisplay.asp')]">
                <simpleplcxlink>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="attribute::href"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:title">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </simpleplcxlink>
            </xsl:when>
            <xsl:when test="self::node()[contains($href,'topic') or contains($href,'article')]">
                <plcxlink>
                    <xlink:locator>
                        <xsl:choose>
                            <xsl:when test="self::node()[contains($href,'topic')]">
                                <xsl:attribute name="xlink:role">Topic</xsl:attribute>
                                <xsl:attribute name="xlink:title">
                                    <xsl:call-template name="convert-chars">
                                        <xsl:with-param name="this_string" select="."/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="substring-after($href,'topic_id=')"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="self::node()[contains($href,'article')]">
                                <xsl:attribute name="xlink:role">Article</xsl:attribute>
                                <xsl:attribute name="xlink:title">
                                    <xsl:call-template name="convert-all">
                                        <xsl:with-param name="this_string" select="."/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="substring-after($href,'article_id=')"/>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:apply-templates/>
                    </xlink:locator>
                </plcxlink>
            </xsl:when>
            <xsl:when test="$isPlcReference='true'">
                <plcxlink>
                    <xlink:locator>
                        <xsl:attribute name="xlink:role">Article</xsl:attribute>
                        <xsl:attribute name="xlink:title">
                            <xsl:value-of select="''"/>
                        </xsl:attribute>
                        <xsl:attribute name="xlink:href">
                            <xsl:value-of select="$hrefPathName"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xlink:locator>
                </plcxlink>
            </xsl:when>
            <xsl:when test="contains($hrefPathName,'binaryContent.jsp')">
                <simpleplcxlink>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="attribute::href"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:title">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </simpleplcxlink>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="self::node()/img">
                        <xsl:variable name='imghref'>
                            <xsl:value-of
                                    select="translate(self::node()/img/attribute::src, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                        </xsl:variable>
                        <xsl:if test="not(contains($imghref, 'top.gif'))">
                            <simpleplcxlink>
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="attribute::href"/>
                                </xsl:attribute>
                                <xsl:attribute name="xlink:title">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                                <xsl:apply-templates/>
                            </simpleplcxlink>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <simpleplcxlink>
                            <xsl:attribute name="xlink:href">
                                <xsl:value-of select="attribute::href"/>
                            </xsl:attribute>
                            <xsl:attribute name="xlink:title">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </simpleplcxlink>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="(self::node()/em) and (not(parent::em|i))">
            <xsl:text disable-output-escaping="yes">&lt;/emphasis></xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="a[not (attribute::href)]">
        <xsl:apply-templates/>
    </xsl:template>

    <!--turn plclink into plcxlinks-->
    <xsl:template match="plclink">
        <plcxlink>
            <xlink:locator>
                <xsl:attribute name="xlink:role">
                    <xsl:value-of select="locator/attribute::role"/>
                </xsl:attribute>
                <xsl:attribute name="xlink:title">
                    <xsl:call-template name="convert-all">
                        <xsl:with-param name="this_string" select="locator/attribute::title"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="xlink:href">
                    <xsl:value-of select="locator/attribute::href"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xlink:locator>
        </plcxlink>
    </xsl:template>

    <xsl:template match="address">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
    ========================================================================
                              CONVERT LINE BREAKS TO SPACES
    ========================================================================
    -->


    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="contains ($this_string, '&#13;&#10;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#13;&#10;')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#13;&#10;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#10;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#10;')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#10;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#13;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#13;')"/>
                </xsl:call-template>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#13;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="convert-all">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="contains ($this_string, '&#13;&#10;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#13;&#10;')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#13;&#10;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#10;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#10;')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#10;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#13;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#13;')"/>
                </xsl:call-template>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#13;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x2019;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x2019;')"/>
                </xsl:call-template>
                <xsl:text>'</xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x2019;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x201c;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x201c;')"/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x201c;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x201d;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x201d;')"/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x201d;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x2013;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x2013;')"/>
                </xsl:call-template>
                <xsl:text>'</xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x2013;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#xb4;')">
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#xb4;')"/>
                </xsl:call-template>
                <xsl:text>'</xsl:text>
                <xsl:call-template name="convert-all">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#xb4;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="convert-ndash">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="contains ($this_string, '&#x2019;')">
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x2019;')"/>
                </xsl:call-template>
                <xsl:text>'</xsl:text>
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x2019;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x201c;')">
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x201c;')"/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x201c;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x201d;')">
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x201d;')"/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x201d;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x2013;')">
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x2013;')"/>
                </xsl:call-template>
                <xsl:text>'</xsl:text>
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x2013;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#xb4;')">
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#xb4;')"/>
                </xsl:call-template>
                <xsl:text>'</xsl:text>
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#xb4;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string, '&#x2026;')">
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x2019;')"/>
                </xsl:call-template>
                <xsl:text>...</xsl:text>
                <xsl:call-template name="convert-ndash">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x2019;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="urlPathName">
        <xsl:param name="url"/>
        <xsl:choose>
            <xsl:when test="starts-with($url,'http://')">
                <xsl:value-of select="substring-after(substring-after($url,'http://'),'/')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-after($url,'/')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="isPlcReference">
        <xsl:param name="inValue"/>
        <xsl:choose>
            <xsl:when test="string-length($inValue)=10 and substring($inValue,2,1)='-' and substring($inValue,6,1)='-'">
                <xsl:value-of select="'true'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'false'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ignore this-->
    <xsl:template match="graphic"/>

    <!--
      <xsl:value-of select="'Unhandled graphic tag'" />
    </xsl:template>-->


    <xsl:template name="process_abstract">
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <xsl:call-template name="check_addblockstart"/>
                    <xsl:apply-templates select="."/>
                    <xsl:call-template name="check_addblockend"/>
                </xsl:when>
                <xsl:when test="self::i|self::b|self::plclink|self::a">
                    <xsl:call-template name="check_addblockstart"/>
                    <xsl:apply-templates select="."/>
                    <xsl:call-template name="check_addblockend"/>
                </xsl:when>
                <xsl:when test="self::br">
                    <para/>
                </xsl:when>
                <xsl:when test="self::li">
                    <xsl:if test="not (name(preceding-sibling::node()[1]) = 'li')">
                        <xsl:text disable-output-escaping="yes">&lt;itemizedlist></xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="."/>
                    <xsl:if test="not (name(following-sibling::node()[1]) = 'li')">
                        <xsl:text disable-output-escaping="yes">&lt;/itemizedlist></xsl:text>
                    </xsl:if>
                </xsl:when>

                <!--assume everything else is a block level element may need to modify this logic for floating inlines-->
                <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>