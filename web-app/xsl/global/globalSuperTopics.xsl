<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:output method="xml" xml:space="default" omit-xml-declaration="yes"/>
    <xsl:template match="/" xml:space="default">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="serviceList">
        <category type="generic" name="Global super topics" key="SUBJ_AREA_PLCREF">
            <xsl:apply-templates/>
        </category>
    </xsl:template>

    <xsl:template match="service[product='gld']">
        <xsl:for-each select="practiceAreaList/practiceArea">
            <xsl:if test="(name) and (name != '')">
                <item>
                    <name>
                        <xsl:value-of select="name"/>
                    </name>
                    <id type="plcreference">
                        <xsl:value-of select="id/@plcReference"/>
                    </id>
                </item>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="service"/>


</xsl:stylesheet>
