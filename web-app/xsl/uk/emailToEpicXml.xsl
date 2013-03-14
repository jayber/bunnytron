<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fn="http://www.w3.org/2005/02/xpath-functions">

    <xsl:output omit-xml-declaration="yes" method="xml" encoding="UTF-8"/>

    <!-- Ordering:
        if ordering == 1 then sort by emailcategory/emailitem/pubDate, descending
        if ordering == 2 then sort by emailcategory/emailitem/title, descending
        if ordering == 3 then sort by emailcategory/emailitem/title, ascending
     -->
    <xsl:param name="ordering"></xsl:param>

    <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:template match="/wrapper">


        <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0"?>&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002 &lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd"> --></xsl:text>
        <article xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:if test="@emailtype != ''">
                <xsl:attribute name="emailtype">
                    <xsl:value-of select="@emailtype"/>
                </xsl:attribute>
            </xsl:if>
            <metadata/>
            <fulltext>

                <xsl:for-each select="emailcategory">
                    <xsl:sort select="translate(@sortname,$lower,$upper)" order="ascending"/>
                    <section1>
                        <title>
                            <xsl:value-of select="@name"/>
                        </title>

                        <xsl:if test="$ordering = 1">
                            <xsl:for-each select="emailitem">
                                <xsl:sort select="pubdate" order="ascending"/>
                                <section2>
                                    <xsl:apply-templates/>
                                </section2>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:if test="$ordering = 2">
                            <xsl:for-each select="emailitem">
                                <xsl:sort select="pubdate" order="descending"/>
                                <section2>
                                    <xsl:apply-templates/>
                                </section2>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:if test="$ordering = 3">
                            <xsl:for-each select="emailitem">

                                <xsl:sort select="translate(section2/title,$lower,$upper)" order="ascending"/>
                                <section2>
                                    <xsl:apply-templates/>
                                </section2>
                            </xsl:for-each>
                        </xsl:if>

                        <!-- <xsl:apply-templates/> -->
                    </section1>
                </xsl:for-each>


            </fulltext>
        </article>
    </xsl:template>


    <!--    <xsl:template match="emailcategory">
        </xsl:template> -->

    <xsl:template match="title">
        <title>
            <xsl:value-of select="."/>
        </title>
    </xsl:template>

    <xsl:template match="section2">
        <!--<xsl:value-of select="."/>            -->
        <!--				<xsl:copy> -->
        <xsl:apply-templates select="@*|node()" mode="content"/>
        <!--				</xsl:copy> -->
    </xsl:template>

    <xsl:template match="readmore">
        <para>
            <plcxlink>
                <xlink:locator>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:role">
                        <xsl:text>Article</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:title">
                        <xsl:value-of select="../title/text()"/>
                    </xsl:attribute>
                    <xsl:text>Read more.</xsl:text>
                </xlink:locator>
            </plcxlink>
        </para>
    </xsl:template>

    <xsl:template match="pubdate">
        <!-- ignore pubdate-->
    </xsl:template>

    <!--    <xsl:template match="SortName|Id"/> -->


    <!-- *** identity transform template * -->

    <xsl:template match="@*|node()" mode="content">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="content"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
