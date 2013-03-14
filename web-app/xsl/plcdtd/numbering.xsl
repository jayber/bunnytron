<?xml version="1.0" encoding="utf-8"?>

<!-- cb Jan 2004: some modifcations for optional numbering-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- named numbering templates -->
    <xsl:template name="recitalsParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number format="A{$endWith}" count="para"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="appendixNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number format="A{$endWith}" count="appendix"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstClauseParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number format="1{$endWith}" count="clause[not (@optionality='unselected')][not (@numbering='none')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause1ParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="1.1{$endWith}"
                        count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause2DefParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="(a){$endWith}" count="subclause2[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause2ParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="1.1(a){$endWith}"
                        count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSingleSubclause2ParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="1(a){$endWith}"
                        count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause2[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause3ParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="1.1(a)(i){$endWith}"
                        count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]|subclause3[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause4ParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="(A){$endWith}" count="subclause4[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstScheduleParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:choose>
                <xsl:when test="count(ancestor::precedent/schedule) &gt; 1">
                    <xsl:text> </xsl:text>
                    <xsl:number level="multiple" format="1{$endWith}"
                                count="schedule[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:when test="count(ancestor::report/schedule) &gt; 1">
                    <xsl:text> </xsl:text>
                    <xsl:number level="multiple" format="1{$endWith}"
                                count="schedule[not (@optionality='unselected')]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstScheduleParaNumLet">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:if test="count(ancestor::letter/schedule) &gt; 1">
                <xsl:text> </xsl:text>
                <xsl:number level="multiple" format="1{$endWith}" count="schedule[not (@optionality='unselected')]"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstPartParaNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:number level="multiple" format="1{$endWith}" count="part[not (@optionality='unselected')]"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="defitemNum">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text><xsl:value-of select="defterm"/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>