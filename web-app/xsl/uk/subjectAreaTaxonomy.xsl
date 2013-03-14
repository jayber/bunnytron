<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:output method="xml" xml:space="default" omit-xml-declaration="yes"/>
    <xsl:template match="/" xml:space="default">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="serviceList">
        <category type="generic" name="Practice Area" key="PRODUCT_PLCREF">
            <xsl:apply-templates/>
        </category>
    </xsl:template>

    <xsl:template match="service">
        <xsl:if test="not (@filter='no')">
            <item>
                <name>
                    <xsl:value-of select="name"/>
                </name>
                <id type="plcreference">
                    <xsl:value-of select="id/@plcReference"/>
                </id>
                <xsl:apply-templates select="practiceAreaList"/>
            </item>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceAreaList">
        <xsl:if test="practiceArea">
            <category key="SUBJ_AREA_PLCREF">
                <xsl:apply-templates select="practiceArea"/>
            </category>
        </xsl:if>
    </xsl:template>

    <xsl:template match="practiceArea">
        <xsl:choose>
            <xsl:when test="poid=':0'">
                <xsl:apply-templates select="practiceAreaList/practiceArea"/>
            </xsl:when>
            <xsl:when test="not (@filter='no')">
                <item>
                    <name>
                        <xsl:value-of select="name"/>
                    </name>
                    <id type="plcreference">
                        <xsl:value-of select="id/@plcReference"/>
                    </id>
                    <xsl:apply-templates select="practiceAreaList"/>
                </item>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
