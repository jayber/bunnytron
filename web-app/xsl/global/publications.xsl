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
                <xsl:value-of select="plcReference"/>
            </id>
        </item>
    </xsl:template>

    <xsl:template match="service[@publications='global']">
        <item>
            <name>
                <xsl:value-of select="name"/>
            </name>
            <id type="plcreference">
                <xsl:value-of select="plcReference"/>
            </id>
        </item>
    </xsl:template>

    <xsl:template match="service[@publications='books']">
        <item>
            <name>
                <xsl:value-of select="name"/>
            </name>
            <id type="plcreference">
                <xsl:value-of select="plcReference"/>
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

    <xsl:template match="service"/>


</xsl:stylesheet>
