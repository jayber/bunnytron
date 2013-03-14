<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:output method="xml" xml:space="default" omit-xml-declaration="yes"/>
    <xsl:template match="/" xml:space="default">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="resourceTypeList">
        <category type="generic" name="Resource Type" key="RES_TYPE_GROUP_NAME">
            <xsl:apply-templates/>
        </category>
    </xsl:template>

    <xsl:template match="resourceType">
        <item>
            <xsl:if test="count (descendant::id) = 1">
                <xsl:attribute name="key">RES_TYPE_PLCREF</xsl:attribute>
            </xsl:if>
            <name>
                <xsl:value-of select="name"/>
            </name>
            <xsl:choose>
                <xsl:when test="count (descendant::id) = 1">
                    <xsl:variable name="id" select="descendant::id"/>
                    <id type="plcreference">
                        <xsl:value-of select="$id"/>
                    </id>
                </xsl:when>
                <xsl:otherwise>
                    <id type="googleName">
                        <xsl:value-of select="name"/>
                    </id>
                    <xsl:if test="id">
                        <category type="Resource Type" key="RES_TYPE_PLCREF">
                            <xsl:apply-templates select="id"/>
                        </category>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>

        </item>
    </xsl:template>

    <xsl:template match="id">
        <xsl:variable name="id" select="."/>
        <item>
            <name>
                <xsl:value-of select="@displayName"/>
            </name>
            <id type="plcreference">
                <xsl:value-of select="$id"/>
            </id>
        </item>
    </xsl:template>

</xsl:stylesheet>
