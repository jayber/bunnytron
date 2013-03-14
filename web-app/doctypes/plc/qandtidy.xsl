<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <!-- v1.1

    modified CB May 2005
    - added doctype declaration
    - whitespace modifications
    -->

    <!-- v1.2

    modified CB Jan 2006
    - fix for emphasis/plcxlink issue
      -->


    <xsl:template match="/article">
        <xsl:text disable-output-escaping="yes">&#xa;&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002 &#xa;&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <article>
            <xsl:apply-templates select="node()|@*"/>
        </article>
    </xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="emphasis[@role='bold']/emphasis[@role='italic']">
        <emphasis role="bold-italic">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>

    <xsl:template match="emphasis[@role='italic']/emphasis[@role='bold']">
        <emphasis role="bold-italic">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>

    <xsl:template match="emphasis[@role='italic'][emphasis/@role='bold']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="emphasis[plcxlink/following-sibling::plcxlink]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()[parent::emphasis/plcxlink/following-sibling::plcxlink]">
        <emphasis>
            <xsl:apply-templates select="parent::emphasis/attribute::*"/>
            <xsl:call-template name="convert-chars">
                <xsl:with-param name="this_string" select="."/>
            </xsl:call-template>
        </emphasis>
    </xsl:template>

    <xsl:template match="plcxlink[parent::emphasis/plcxlink/following-sibling::plcxlink]">
        <emphasis>
            <xsl:apply-templates select="parent::emphasis/attribute::*"/>
            <plcxlink xlink:type="extended">
                <xsl:apply-templates/>
            </plcxlink>
        </emphasis>
    </xsl:template>

    <!--
    <xsl:template match="emphasis[plcxlink/following-sibling::plcxlink]">
           <xsl:for-each select="node()">
           <xsl:choose>
         <xsl:when test="self::plcxlink"><emphasis><xsl:apply-templates select="@"/><xsl:apply-templates select="plcxlink"/></emphasis></xsl:when>
         <xsl:when test="self::text()"><emphasis><xsl:apply-templates select="@"/><xsl:value-of select="."/></emphasis></xsl:when>
         </xsl:choose>
         </xsl:for-each>
      </xsl:template>-->

    <xsl:template match="metadata">
    </xsl:template>

    <xsl:template match="article">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="qandaset/section1/title">
        <line>
            <xsl:apply-templates/>
        </line>
    </xsl:template>

    <xsl:template match="qandaset">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="section1">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="section2">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="section3">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="itemizedlist">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="listitem">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="answer">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="qandaentry/question/section2/para">
        <xsl:choose>
            <xsl:when
                    test="self::node()[not (preceding-sibling::para)][not (following-sibling::para)][not (following-sibling::itemizedlist)]">
                <question>
                    <xsl:apply-templates/>
                </question>
            </xsl:when>
            <xsl:when
                    test="self::node()[(following-sibling::para) or (following-sibling::itemizedlist)][not (preceding-sibling::para)]">
                <questionstart>
                    <xsl:apply-templates/>
                </questionstart>
            </xsl:when>
            <xsl:when
                    test="self::node()[(following-sibling::para) or (following-sibling::itemizedlist)][preceding-sibling::para]">
                <qpara>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qpara>
            </xsl:when>
            <xsl:when test="self::node()[not (following-sibling::para)]">
                <questionend>
                    <xsl:apply-templates/>
                </questionend>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="qandaentry/question/section2/itemizedlist/listitem/para">
        <xsl:choose>
            <xsl:when test="self::node()[parent::listitem/following-sibling::listitem/para]">
                <qbulleted1>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulleted1>
            </xsl:when>
            <xsl:otherwise>
                <questionbulend>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </questionbulend>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="question">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="qandaentry">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
    <xsl:template match="para[not(text())][itemizedlist]">
       <xsl:apply-templates/>
    </xsl:template>
    -->

    <xsl:template match="para[not (text())]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="para">
        <xsl:choose>
            <xsl:when test="count(text())=1 and text()=' '">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <para>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </para>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="para[attribute::*='preserve']">
        <xsl:choose>
            <xsl:when test="count(text())=1 and text()=' '">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <para>
                    <xsl:attribute name="xml:space">preserve</xsl:attribute>
                    <xsl:apply-templates/>
                </para>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="section2/title">
        <heading2>
            <xsl:apply-templates/>
        </heading2>
    </xsl:template>

    <xsl:template match="section3/title">
        <RunInHead>
            <xsl:apply-templates/>
        </RunInHead>
    </xsl:template>

    <xsl:template match="itemizedlist[not (ancestor::question)][not (parent::listitem)]/listitem/para[1]">
        <xsl:choose>
            <xsl:when test="ancestor::question">
                <qbulleted1>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulleted1>
            </xsl:when>
            <xsl:otherwise>
                <bulleted1>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </bulleted1>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="itemizedlist/listitem/para[not (position()=1)][text()]">
        <xsl:choose>
            <xsl:when test="ancestor::question">
                <qbulletedfup>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulletedfup>
            </xsl:when>
            <xsl:otherwise>
                <bulletedfup>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </bulletedfup>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="itemizedlist/listitem/itemizedlist/listitem/para[1]">
        <xsl:choose>
            <xsl:when test="ancestor::question">
                <qbulleted2>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulleted2>
            </xsl:when>
            <xsl:otherwise>
                <bulleted2>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </bulleted2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="itemizedlist/listitem/itemizedlist/listitem/para[not (position()=1)][text()]">
        <xsl:choose>
            <xsl:when test="ancestor::question">
                <qbulleted2fup>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulleted2fup>
            </xsl:when>
            <xsl:otherwise>
                <bulleted2fup>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </bulleted2fup>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="itemizedlist/listitem/itemizedlist/listitem/itemizedlist/listitem/para[1]">
        <xsl:choose>
            <xsl:when test="ancestor::question">
                <qbulleted3>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulleted3>
            </xsl:when>
            <xsl:otherwise>
                <bulleted3>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </bulleted3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
            match="itemizedlist/listitem/itemizedlist/listitem/itemizedlist/listitem/para[not (position()=1)][text()]">
        <xsl:choose>
            <xsl:when test="ancestor::question">
                <qbulleted3fup>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </qbulleted3fup>
            </xsl:when>
            <xsl:otherwise>
                <bulleted3fup>
                    <xsl:for-each select="attribute::*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </bulleted3fup>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="text()[.=' ']">
       <xsl:apply-templates/>
   </xsl:template>-->

    <xsl:template match="text()[contains (.,'&#x20ac;')]">
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()[contains (.,'&#x20ac;')][starts-with (.,'&#9;')]">
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="substring-after(.,'&#9;')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()[starts-with (.,'&#9;')]">
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="substring-after(.,'&#9;')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*|@*[not (xml:space)]|text()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|comment()"/>
        </xsl:copy>
    </xsl:template>

    <!-- <xsl:template match="attribute::*">
         <xsl:choose>
          <xsl:when test="name(.)='xml:space'"><xsl:attribute name="xml:space"><xsl:value-of select="."/></xsl:attribute></xsl:when>
          <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
      </xsl:choose>
     </xsl:template>-->


    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <xsl:variable name="quote">'</xsl:variable>
        <xsl:choose>
            <xsl:when test="contains ($this_string,'&#x20ac;')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '&#x20ac;')"/>
                </xsl:call-template>
                <eurostyle>&#xa7;</eurostyle>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '&#x20ac;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>