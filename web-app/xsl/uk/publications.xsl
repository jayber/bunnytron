<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:output method="xml" xml:space="default" omit-xml-declaration="yes"/>
    <xsl:template match="/" xml:space="default">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="serviceList">
        <category type="generic" name="Publications" key="PRODUCT_PLCREF">
            <xsl:apply-templates/>
        </category>
    </xsl:template>

    <xsl:template match="service[@publications='all']">

        <item>
            <name>
                <xsl:value-of select="name"/>
            </name>
            <id type="plcreference">
                <xsl:call-template name="getPlcRef"/>
            </id>
        </item>
    </xsl:template>

    <xsl:template match="service[@publications='books']">
        <item>
            <name>
                <xsl:value-of select="name"/>
            </name>
            <id type="plcreference">
                <xsl:call-template name="getPlcRef"/>
            </id>
            <!-- hack up some books content -->
            <category key="PRODUCT_PLCREF">
                <item>
                    <name>Local Government Law Scotland</name>
                    <id type="plcreference">9-517-3901</id>
                </item>
                <item>
                    <name>ET Handbook</name>
                    <id type="plcreference">1-515-0989</id>
                </item>
            </category>
        </item>
    </xsl:template>

    <xsl:template name="getPlcRef">
        <xsl:choose>
            <xsl:when test="id/@plcReference">
                <xsl:value-of select="id/@plcReference"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="plcReference"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="service"/>


</xsl:stylesheet>
