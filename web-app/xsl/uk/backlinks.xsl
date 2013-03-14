<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:output method="xml" doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd"
                doctype-public="-//Apple//DTD PLIST 1.0//EN" indent="no" encoding="UTF-8"/>

    <xsl:variable name="resourceTypeConfig" select="document($resourceTypeConfig-path)/resourceTypeList/resourceType"/>
    <xsl:variable name="resourceCount" select="count(/searchResults/detail/document)"/>
    <xsl:variable name="estTotal">
        <xsl:value-of select="/searchResults/detail/total"/>
    </xsl:variable>

    <xsl:template match="/">
        <plist version="1.0">
            <dict>
                <key>LegislationLinks</key>
                <dict>
                    <key>Links</key>
                    <array>
                        <xsl:if test="$resourceCount &gt; 0">
                            <xsl:apply-templates/>
                        </xsl:if>
                    </array>
                    <key>DocumentUri</key>
                    <string>The @DocumentURI identifying the context for the links</string>
                </dict>
            </dict>
        </plist>
    </xsl:template>

    <xsl:template match="searchResults/detail">
        <xsl:variable name="results"
                      select="document[resourceTypeFolderList/resourceTypeFolder=$resourceTypeConfig/name]"/>
        <xsl:for-each select="$resourceTypeConfig">
            <xsl:sort select="sortOrder" data-type="number"/>
            <xsl:variable name="sortResourceType" select="name"/>
            <xsl:if test="count($results[resourceTypeFolderList/resourceTypeFolder=$sortResourceType]) &gt; 0">
                <dict>
                    <key>Links</key>
                    <array>
                        <xsl:apply-templates
                                select="$results[resourceTypeFolderList/resourceTypeFolder=$sortResourceType]">
                            <xsl:sort select="title" order="ascending"/>
                        </xsl:apply-templates>
                    </array>
                    <key>PracticeAreaName</key>
                    <string>
                        <xsl:call-template name="pluralResourceTypeDescription">
                            <xsl:with-param name="resourceType" select="$sortResourceType"/>
                        </xsl:call-template>
                    </string>
                </dict>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="document">
        <dict>
            <key>LinkTitle</key>
            <string>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="title/text()"/>
                </xsl:call-template>
            </string>
            <key>LinkUrl</key>
            <string>http://www.practicallaw.com/<xsl:value-of select="plcReference"/>
            </string>
        </dict>
    </xsl:template>

    <xsl:template name="pluralResourceTypeDescription">
        <xsl:param name="resourceType"/>
        <xsl:choose>
            <xsl:when test="$resourceTypeConfig[name=$resourceType]">
                <xsl:value-of select="$resourceTypeConfig[name=$resourceType]/pluralName"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="contains ($this_string,'&lt;b&gt;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'&lt;b&gt;')"/>
                </xsl:call-template>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'&lt;b&gt;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains ($this_string,'&lt;/b&gt;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'&lt;/b&gt;')"/>
                </xsl:call-template>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'&lt;/b&gt;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>