<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" method="xml"/>

    <!-- -Identify inline  and block level elements-->
    <xsl:template name="check_addblockstart">
        <!--<xsl:if test="(name(following-sibling::node()[1]) = 'BR') or (count(following-sibling::node()[1]/br)>0) or (count(following-sibling::node()[1]/BR)>0)"><xsl:text disable-output-escaping="yes">&lt;/para></xsl:text></xsl:if>-->

        <xsl:if test="(count(preceding-sibling::node()[1]/br)>0) or (count(preceding-sibling::node()[1]/BR)>0)">
            <xsl:text disable-output-escaping="yes">&lt;/para></xsl:text>
        </xsl:if>
        <xsl:if test="(count(preceding-sibling::node())=0) or (name(preceding-sibling::node()[1]) = 'br') or (name(preceding-sibling::node()[1]) = 'BR') or (count(preceding-sibling::node()[1]/br)>0) or (count(preceding-sibling::node()[1]/BR)>0) or (name(preceding-sibling::node()[1]) = 'OL') or (name(preceding-sibling::node()[1]) = 'ol') or (name(preceding-sibling::node()[1]) = 'Ol') or (name(preceding-sibling::node()[1]) = 'oL') or (name(preceding-sibling::node()[1]) = 'UL') or (name(preceding-sibling::node()[1]) = 'ul') or (name(preceding-sibling::node()[1]) = 'Ul') or (name(preceding-sibling::node()[1]) = 'uL')">
            <xsl:text disable-output-escaping="yes">&lt;para></xsl:text>
        </xsl:if>
        <!--		<xsl:if test="((count(./br)>0) or (count(preceding-sibling::node()[1]/br)>0)) and not((not (name(following-sibling::node()[1]) = 'I') and not (name(following-sibling::node()[1]) = 'i') and not (name(following-sibling::node()[1]) = 'B') and not (name(following-sibling::node()[1]) = 'b') and not (name(following-sibling::node()[1]) = 'U') and not (name(following-sibling::node()[1]) = 'u')  and not (name(following-sibling::node()[1]) = 'A') and not (name(following-sibling::node()[1]) = 'a') and not (following-sibling::node()[1][self::text()])))">
                    <xsl:text disable-output-escaping="yes">&lt;para></xsl:text>
                </xsl:if>
                <xsl:if test="(not (name(following-sibling::node()[1]) = 'I') and not (name(following-sibling::node()[1]) = 'i') and not (name(following-sibling::node()[1]) = 'B') and not (name(following-sibling::node()[1]) = 'b') and not (name(following-sibling::node()[1]) = 'U') and not (name(following-sibling::node()[1]) = 'u') and not (name(following-sibling::node()[1]) = 'A') and not (name(following-sibling::node()[1]) = 'a') and not (following-sibling::node()[1][self::text()]))">
                    <xsl:text disable-output-escaping="yes">&lt;para></xsl:text>
                </xsl:if>-->
    </xsl:template>

    <xsl:template name="check_addblockend">
        <xsl:if test="(count(following-sibling::node())=0) or (name(following-sibling::node()[1]) = 'br') or (name(following-sibling::node()[1]) = 'BR') or (name(following-sibling::node()[1]) = 'OL') or (name(following-sibling::node()[1]) = 'ol') or (name(following-sibling::node()[1]) = 'Ol') or (name(following-sibling::node()[1]) = 'oL') or (name(following-sibling::node()[1]) = 'UL') or (name(following-sibling::node()[1]) = 'ul') or (name(following-sibling::node()[1]) = 'Ul') or (name(following-sibling::node()[1]) = 'uL')">
            <xsl:text disable-output-escaping="yes">&lt;/para></xsl:text>
        </xsl:if>
        <!--		<xsl:if test="(name(preceding-sibling::node()[1]) = 'BR') or (count(preceding-sibling::node()[1]/br)>0) or (count(preceding-sibling::node()[1]/BR)>0)"><xsl:text disable-output-escaping="yes">&lt;para></xsl:text></xsl:if>
        -->
        <!--		<xsl:if test="(not (name(following-sibling::node()[1]) = 'I') and not (name(following-sibling::node()[1]) = 'i') and not (name(following-sibling::node()[1]) = 'B') and not (name(following-sibling::node()[1]) = 'b') and not (name(following-sibling::node()[1]) = 'U') and not (name(following-sibling::node()[1]) = 'u') and not (name(following-sibling::node()[1]) = 'A') and not (name(following-sibling::node()[1]) = 'a') and not (following-sibling::node()[1][self::text()]))">
                    <xsl:text disable-output-escaping="yes">&lt;/para></xsl:text>
                </xsl:if>
                <xsl:if test="((count(./br)>0) or (count(preceding-sibling::node()[1]/br)>0)) and not((not (name(following-sibling::node()[1]) = 'I') and not (name(following-sibling::node()[1]) = 'i') and not (name(following-sibling::node()[1]) = 'B') and not (name(following-sibling::node()[1]) = 'b') and not (name(following-sibling::node()[1]) = 'U') and not (name(following-sibling::node()[1]) = 'u') and not (name(following-sibling::node()[1]) = 'A') and not (name(following-sibling::node()[1]) = 'a') and not (following-sibling::node()[1][self::text()])))">
                    <xsl:text disable-output-escaping="yes">&lt;/para></xsl:text>
                </xsl:if>-->
    </xsl:template>


    <!-- block level -->
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

    <!-- to-do::What is this for ? Ask beecham !!!!-->
    <xsl:template match="p/p|P/p|p/P|P/P">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- to-do::how to handle br tags ? Ask beecham !!!!-->
    <xsl:template match="br|Br|bR|BR">
        <xsl:choose>
            <xsl:when
                    test="(name(ancestor::node())='li') or (name(ancestor::node())='LI') or (name(ancestor::node())='Li') or (name(ancestor::node())='lI')">
                <xsl:text disable-output-escaping="yes">&lt;/para>&lt;para></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="(name(preceding-sibling::node()[1]) = 'br') or (name(preceding-sibling::node()[1]) = 'Br') or (name(preceding-sibling::node()[1]) = 'bR') or (name(preceding-sibling::node()[1]) = 'BR')">
                    <para/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- LIST-->
    <xsl:template match="ul|UL|Ul|uL">
        <itemizedlist>
            <xsl:apply-templates/>
        </itemizedlist>
    </xsl:template>

    <xsl:template match="ol|OL|Ol|oL">
        <orderedlist>
            <xsl:choose>
                <xsl:when test="attribute::type='a'">
                    <xsl:attribute name="name">loweralpha</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </orderedlist>
    </xsl:template>

    <xsl:template match="li|LI|lI|Li">
        <xsl:choose>
            <xsl:when test="p|P">
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


    <!-- -Italics-->
    <xsl:template match="em|EM|i|I">
        <emphasis role="italic">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>
    <!-- -bold -->
    <xsl:template match="strong|STRONG|Strong|b|B">
        <emphasis role="bold">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>

    <!-- -underline-->
    <xsl:template match="u|U">
        <emphasis role="underline">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>

    <!-- links -->
    <xsl:template match="a|A">
        <xsl:apply-templates/>
        <xsl:text> [</xsl:text>
        <emphasis role="italic">
            <xsl:value-of select="attribute::href"/>
        </emphasis>
        <xsl:text>] </xsl:text>
    </xsl:template>

    <xsl:template match="span|SPAN">
        <xsl:variable name="formatting">
            <xsl:value-of select="@style"/>
        </xsl:variable>
        <xsl:if test="contains($formatting,'bold')">
            <xsl:text disable-output-escaping="yes">&lt;emphasis role="bold"></xsl:text>
        </xsl:if>
        <xsl:if test="contains($formatting,'underline')">
            <xsl:text disable-output-escaping="yes">&lt;emphasis role="underline"></xsl:text>
        </xsl:if>
        <xsl:if test="contains($formatting,'italic')">
            <xsl:text disable-output-escaping="yes">&lt;emphasis role="italic"></xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="contains($formatting,'italic')">
            <xsl:text disable-output-escaping="yes">&lt;/emphasis></xsl:text>
        </xsl:if>
        <xsl:if test="contains($formatting,'underline')">
            <xsl:text disable-output-escaping="yes">&lt;/emphasis></xsl:text>
        </xsl:if>
        <xsl:if test="contains($formatting,'bold')">
            <xsl:text disable-output-escaping="yes">&lt;/emphasis></xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>