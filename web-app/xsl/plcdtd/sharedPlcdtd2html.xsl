<?xml version="1.0" encoding="utf-8"?>
<!-- CB Jan 2007 v1.0
we should give this a plc_MVC version as well
this is the new reshared sharedPlcdtd2html with
core stylesheet functionality for both plcmvc and da/dd
commented out blocks should be removed
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                xmlns:da="http://practicallaw.com/plc/da" xmlns:xhtml="http://www.w3.org/TR/xhtml1"
                exclude-result-prefixes="xlink atict da xhtml">

    <!--
    these now come from plcdtd2html.xsl which has nothing else
    <xsl:import href="numbering.xsl"/>
    <xsl:import href="plcfPrecxhtml.xsl"/>
    <xsl:import href="convert-chars.xsl"/>
    -->

    <xsl:import href="execution.xsl"/>


    <!-- not 100% sure what output type would be. could be sarvega issues-->
    <xsl:output method="html"/>
    <!--<xsl:output method="xml" omit-xml-declaration="yes" media-type=""/>-->

    <xsl:param name="processincludes"/>
    <xsl:param name="displaymode"/>
    <xsl:param name="toc"/>
    <xsl:param name="mainimage"/>
    <xsl:param name="countryfilter"/>
    <xsl:param name="countryname"/>
    <xsl:param name="precedenttype" select="'agreement'"/>
    <xsl:param name="articleserver"/>

    <!--
    ========================================================================
                             GLOBAL VARIABLES
    ========================================================================
    -->

    <xsl:variable name="lcletters" select="'abcdefghijklmnopqrstuvwxyz'"/>

    <xsl:variable name="ucletters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:variable name="qanda"
                  select="/resource/xml/*/metadata/relation/plcxlink/@xlink:role='crossborderqandaset' and descendant::qandaset"/>

    <!--
========================================================================
                          KEY FOR XREF
========================================================================
-->
    <xsl:key name="xreflink"
             match="//clause|//subclause1|//defitem|//subclause2|//schedule|//part|//subclause3|//appendix" use="@id"/>
    <xsl:key name="colspec" match="//tgroup/colspec" use="position()"/>

    <!--
========================================================================
                          SUPPRESS METADATA
========================================================================
-->
    <xsl:template match="metadata"/>

    <!--
    ========================================================================
                              TRAINING PARAMS
    ========================================================================
    -->
    <xsl:param name="haveQuestionsBeenAnswered"></xsl:param>
    <xsl:param name="studentLoggedIn"></xsl:param>
    <xsl:param name="studentAnswer"></xsl:param>
    <xsl:param name="courseId"></xsl:param>
    <xsl:param name="moduleId"></xsl:param>
    <!--
========================================================================
                          TOP LEVEL
========================================================================
-->

    <xsl:variable name="debug" select="'false'"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match='html|article|orgprofile|xhtml:html'>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match='body|xhtml:body'>
        <xsl:call-template name='copy'/>
    </xsl:template>


    <!--CB the copy template is very different from the old shared version. Need to check whether this is going to affect da (probably no since its designed for
    outputting html content)-->
    <!--this template simply copies an HTML document embedded in the XML response. This HTML should be, but does not appear to be, valid XHTML
        this causes a lot of problems and this template will need to be developed to ensure valid XHTML is produced-->
    <xsl:template name='copy'>
        <xsl:choose>
            <!--		This test looks to see if the current element is empty, if it is, it writies it out so that it has a proper closing tag.
                        It does not do this for img tags or line breaks because the minimised version is allowed for these types-->
            <xsl:when
                    test="not (string-length() &gt; 0) and not(local-name(.) = 'img') and not(local-name(.) = 'br') and not(local-name(.) = 'plclink')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="local-name(.)"/>
                <xsl:if test="string-length(./@name) &gt; 0">name="<xsl:value-of select="./@name"/>"
                </xsl:if>
                <xsl:if test="string-length(./@id) &gt; 0">id="<xsl:value-of select="./@id"/>"
                </xsl:if>
                <xsl:text disable-output-escaping="yes">&gt;&lt;/</xsl:text><xsl:value-of select="local-name(.)"/><xsl:text
                    disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:for-each select='node()'>
                    <xsl:call-template name='copy'/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="local-name(.) = 'plclink'">
                <xsl:apply-templates select="."/>
            </xsl:when>
            <!-- simple test to stop the body tag being duplicated -->
            <xsl:when test="local-name(.) = 'body'">
                <xsl:for-each select='node()'>
                    <xsl:call-template name='copy'/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!--			<xsl:value-of select="local-name(self::*)" />-->
                <xsl:copy>
                    <xsl:for-each select='@*|node()'>
                        <xsl:call-template name='copy'/>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="strapline"/>


    <!--
    ========================================================================
                             WRAPPERS
    ========================================================================
    -->

    <xsl:template match="generic|practicenote|glossitem|glossary|glossdef|glossterm|precedent|letter|keyword|fulltext">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
========================================================================
                         SECTIONS
========================================================================
-->

    <!-- the CDATA stuff whilst inelegant is used to prevent tag minimisation (ie. <a/> which can cause problems with some browsers-->

    <xsl:template match="section1">
        <xsl:if test="not(ancestor::revdescription)">
            <xsl:if test="self::node()[not (title)][@id]">
                <!-- changed sc 11/07/07 - id attribute added to named anchors to solve linking to integrated notes bug -->
                <xsl:text disable-output-escaping="yes"><![CDATA[<a name="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                    disable-output-escaping="yes"><![CDATA[" id="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                    disable-output-escaping="yes"><![CDATA["></a>]]></xsl:text>
            </xsl:if>
            <!--		generate and id for the contents if one is missing-->
            <!--    Removed the following code as a fix for Bug 5630. -->
            <!--    This code should be added at the end of the next line, just after '[@id])' (without the quotes): 'and string-length(title) &gt; 0' -->
            <xsl:if test="not(self::node()[@id])">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select='concat( "sect1pos", count(preceding::*[(local-name(.) = "section1" or local-name(.) = "bridgehead") and not(ancestor::revdescription)])+1, "res", count(ancestor::embeddedResource/preceding-sibling::embeddedResource)+1)'/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>&#160;
    </xsl:template>

    <xsl:template match="section1[@layout='box']">
        <xsl:if test="not (preceding-sibling::section1)">
            <br clear="all"/>
        </xsl:if>

        <xsl:if test="(title and count(preceding::title[parent::section1]) &gt; 0)">
            <div class="inline-top-nav">
                <a href="#top" title="Link to the top of the document">Top</a>
            </div>
        </xsl:if>

        <div class="resource-content-box">
            <xsl:apply-templates/>
        </div>
        <br clear="all"/>
    </xsl:template>

    <!-- the stuff below is needed for the Competition case tracker articles.
    An example is 3-102-3867-->

    <xsl:template match="section1[@layout='lhcell']">
        <xsl:if test="string-length(.) &gt; 0">
            <div class="embedded-resource-col">
                <div class="embedded-resource-content">
                    <xsl:apply-templates/>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="section1[@layout='rhcell']">
        <xsl:if test="string-length(.) &gt; 0">
            <div class="embedded-resource-col embedded-resource-col-right">
                <div class="embedded-resource-content">
                    <xsl:apply-templates/>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="section1[preceding-sibling::section1[@layout='rhcell']]">
        <xsl:if test="string-length(.) &gt; 0">
            <div class="embedded-resource-row">
                <div class="embedded-resource-content">
                    <xsl:apply-templates/>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="section2">
        <xsl:if test="not(ancestor::revdescription)">
            <xsl:if test="self::node()[not (title)][@id]">
                <!-- changed sc 11/07/07 - id attribute added to named anchors to solve linking to integrated notes bug -->
                <xsl:text disable-output-escaping="yes"><![CDATA[<a name="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                    disable-output-escaping="yes"><![CDATA[" id="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                    disable-output-escaping="yes"><![CDATA["></a>]]></xsl:text>
            </xsl:if>
            <!-- generate and id for the contents if one is missing, this also has to take into account embedded resources so it counts them as well.-->
            <xsl:if test="not(self::node()[@id])">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select='concat( "sect2pos", count(preceding::section2[not(ancestor::revdescription)])+1, "res", count(ancestor::embeddedResource/preceding-sibling::embeddedResource)+1)'/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="section2[@layout='box'][not (parent::section1/@layout='box')]">
        <xsl:if test="string-length() &gt; 0">
            <div class="resource-content-box">
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="section3[@layout='box'][not (parent::section2/@layout='box')]">
        <xsl:if test="string-length() &gt; 0">
            <div class="resource-content-box">
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="section3">
        <xsl:if test="self::node()[not (title)][@id]">
            <!-- changed sc 11/07/07 - id attribute added to named anchors to solve linking to integrated notes bug -->
            <xsl:text disable-output-escaping="yes"><![CDATA[<a name="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                disable-output-escaping="yes"><![CDATA[" id="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                disable-output-escaping="yes"><![CDATA["></a>]]></xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <!--
========================================================================
                          HEADINGS
========================================================================
-->
    <!-- added by CB 18.2.03 -->
    <xsl:template match="bridgehead">
        <xsl:choose>
            <xsl:when test="@id">
                <!-- changed sc 11/07/07 - id attribute added to named anchors to solve linking to integrated notes bug -->
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select='@id'/><xsl:text
                    disable-output-escaping="yes">" id="</xsl:text><xsl:value-of select='@id'/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

                <h2>
                    <xsl:value-of select="translate(., $lcletters, $ucletters)"/>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select='concat("sect1pos", count(preceding-sibling::*[local-name(.) = "section1" or local-name(.) = "bridgehead"])+1)'/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

                <h2>
                    <xsl:attribute name="name">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:value-of select="translate(., $lcletters, $ucletters)"/>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="section1/title|section1/atict:add/title">
        <xsl:choose>

            <xsl:when test="(self::node()[parent::section1/@id])">
                <!-- add a to-top link if not the first section 1 -->

                <xsl:if test="count(preceding::title[parent::section1]) &gt; 0 and not(ancestor::section1/@layout = 'box')">
                    <div class="inline-top-nav">
                        <a href="#top" title="Link to the top of the document">Top</a>
                    </div>
                </xsl:if>

                <!--add a named anchor, if no id exists the create one-->
                <xsl:text disable-output-escaping="yes">&lt;a </xsl:text>
                <xsl:choose>
                    <xsl:when test="parent::section1/@id">id="<xsl:value-of select="parent::section1/@id"/>" name="<xsl:value-of
                            select="parent::section1/@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>name="sect1title</xsl:text>
                        <xsl:number value="count(preceding::title[parent::section1])+1" format="01"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

                <xsl:if test="string-length(.) &gt; 0">
                    <h2>
                        <xsl:if test="(self::node()[@type='arttitle'])">
                            <xsl:attribute name="class">shaded</xsl:attribute>
                        </xsl:if>

                        <xsl:apply-templates/>

                    </h2>
                </xsl:if>
            </xsl:when>

            <xsl:when test="parent::section1/@layout='inline'">
                <h3 class="runin">
                    <xsl:apply-templates/>
                    <xsl:text>. </xsl:text>
                </h3>
            </xsl:when>

            <xsl:otherwise>
                <xsl:if test="string-length(.) &gt; 0">
                    <h2>
                        <xsl:if test="(self::node()[@type='arttitle'])">
                            <xsl:attribute name="class">bigger</xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </h2>
                </xsl:if>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>
    <xsl:template match="article/title">
        <xsl:choose>
            <xsl:when test="(self::node()[parent::section1/@id]) or ($toc='true')">
                <xsl:if test="(count(preceding::title[parent::section1]) &gt; 0) and ($displaymode != 'print')">

                    <div class="inline-top-nav">
                        <a href="#top" title="Link to the top of the document">Top</a>
                    </div>

                </xsl:if>
                <h2>
                    <xsl:if test="(self::node()[@type='arttitle'])">
                        <xsl:attribute name="class">shaded</xsl:attribute>
                    </xsl:if>
                    <xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
                    <xsl:choose>
                        <xsl:when test="parent::section1/@id">id="<xsl:value-of select="parent::section1/@id"/>" name="<xsl:value-of
                                select="parent::section1/@id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> name="sect1title</xsl:text>
                            <xsl:number value="count(preceding::title[parent::section1])+1" format="01"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                    <xsl:call-template name="convert-chars">
                        <xsl:with-param name="this_string" select="."/>
                    </xsl:call-template>
                    <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
                    &#160;
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <h2>
                    <xsl:if test="(self::node()[@type='arttitle'])">
                        <xsl:attribute name="class">bigger</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>&#160;
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="section2/title|section2/atict:add/title">
        <xsl:choose>
            <xsl:when test="(self::node()[parent::section2/@id]) or ($toc='true')">

                <xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
                <xsl:choose>
                    <xsl:when test="parent::section2/@id">id="<xsl:value-of select="parent::section2/@id"/>" name="<xsl:value-of
                            select="parent::section2/@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> name="sect2title</xsl:text>
                        <xsl:number value="count(preceding::section2/title)+1" format="01"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                <xsl:if test="string-length(.) &gt; 0">
                    <h3>
                        <xsl:apply-templates/>
                    </h3>
                </xsl:if>
            </xsl:when>
            <xsl:when test="parent::section2/@layout='inline'">
                <xsl:if test="string-length(.) &gt; 0">
                    <h3 class="runin">
                        <xsl:call-template name="convert-chars">
                            <xsl:with-param name="this_string" select="."/>
                        </xsl:call-template>
                    </h3>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="string-length(.) &gt; 0">
                    <h3>
                        <xsl:apply-templates/>
                    </h3>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="section3/title|section3/atict:add/title">
        <xsl:choose>
            <xsl:when test="self::node()[parent::section3/@id]">
                <xsl:text disable-output-escaping="yes">&lt;a id="</xsl:text><xsl:value-of
                    select="parent::section3/@id"/>" name="<xsl:value-of select="parent::section3/@id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;h4&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text disable-output-escaping="yes">&lt;/h4&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;h4&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text disable-output-escaping="yes">&lt;/h4&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="section4/title|section4/atict:add/title">
        <xsl:choose>
            <xsl:when test="self::node()[parent::section4/@id]">
                <xsl:text disable-output-escaping="yes">&lt;a id="</xsl:text><xsl:value-of
                    select="parent::section4/@id"/>" name="<xsl:value-of select="parent::section4/@id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;h5&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text disable-output-escaping="yes">&lt;/h5&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;h5&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text disable-output-escaping="yes">&lt;/h5&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="title[@class='runIn']">
        <h3 class="runin">
            <xsl:apply-templates/>&#160;
        </h3>
    </xsl:template>

    <xsl:template match="title[parent::figure]">
        <p>
            <b>
                <xsl:apply-templates/>
            </b>
        </p>
    </xsl:template>


    <!--
========================================================================
                          Q AND A
========================================================================
    -->

    <xsl:variable name="answers"/>

    <!-- Supress short style questions for new style cross border QA pages -->
    <xsl:template match="shortquestion"/>

    <!-- SC this is now all handled in embeddedResources.xsl -->
    <!-- New template to match the Q and A in MVC -->
    <xsl:template match="plcxlink[xlink:locator/@xlink:role = 'qandaentry']">
        <!--<xsl:variable name="qaset" select="concat('W_q', xlink:locator/@xlink:href)" />
        <xsl:variable name="qasetNoPrepend" select="xlink:locator/@xlink:href" />-->

        <!-- Unsure of what makes some questions have a label with W_q and some not so have to try and match both -->
        <!--<div class="qanda">
            <xsl:apply-templates select="/plcdata/contentSection/contentBody/child::*/countryAnswers/resource/xml/child::*/fulltext/qandaset/section1/qandaentry[question/@label=$qaset]" />
            <xsl:apply-templates select="/plcdata/contentSection/contentBody/child::*/countryAnswers/resource/xml/child::*/fulltext/qandaset/section1/qandaentry[question/@label=$qasetNoPrepend]" />
        </div>-->

        <!--		<div class="qanda">
                    <xsl:apply-templates select="/plcdata/contentSection/contentBody/child::*/embeddedResources/embeddedResource[plcReference=$qaset]/xml" />
                    <xsl:apply-templates select="/plcdata/contentSection/contentBody/child::*/embeddedResources/embeddedResource[plcReference=$qasetNoPrepend]/xml" />
                </div>-->

    </xsl:template>


    <xsl:template match="qandaset">
        <!--<h1>Qandaset</h1>-->
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="qandaentry">
        <xsl:choose>
            <xsl:when test="self::node()[ancestor::qandaset]">
                <xsl:apply-templates/>
                <xsl:if test="name(following-sibling::*[position()=1])='qandaentry'">&#160;</xsl:if>
            </xsl:when>
            <xsl:otherwise>

                <xsl:choose>
                    <xsl:when test="($countryfilter != 'all') or not(preceding-sibling::node())">
                        <xsl:text disable-output-escaping="yes">&lt;div class="qanda"></xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates/>
                <!--filter:<xsl:value-of select="$countryfilter"/>-->
                <xsl:choose>
                    <xsl:when
                            test="($countryfilter != 'all') or name(following-sibling::node()[position()=1])!='qandaentry'">
                        <xsl:text disable-output-escaping="yes">&lt;/div>&lt;br clear='all' /></xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="name(following-sibling::*[position()=1])='qandaentry'">&#160;</xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="question">
        <xsl:choose>
            <xsl:when test="ancestor::qandaset">
                <div class="qanda-question">
                    <a name="{@label}"/>
                    <xsl:apply-templates/>
                </div>
                <!--<br clear="all"/>-->
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="answer">

        <xsl:if test="string-length($countryQandAJurisdictionName) &gt; 0">
            <div class="countryReminder">
                <xsl:value-of select="$countryQandAJurisdictionName"/>
            </div>
        </xsl:if>

        <xsl:if test="@country">
            <div class="countryReminder">
                <xsl:value-of select="$countryQandAJurisdictionName"/>
            </div>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <!--
========================================================================
                          LISTS
========================================================================
-->
    <xsl:template match="itemizedlist">
        <xsl:if test="self::node()[count(parent::para/child::*) &gt; 1][ancestor::answer][preceding-sibling::text()]">
            <xsl:text disable-output-escaping="yes">&lt;/p></xsl:text>
        </xsl:if>
        <ul>
            <xsl:choose>
                <xsl:when test="@mark='none'">
                    <xsl:attribute name="class">no-list-mark</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </ul>
        <!--
  <xsl:if test="self::node()[preceding-sibling::text()]">
     <xsl:text disable-output-escaping="yes">&lt;p> </xsl:text>
  </xsl:if>
  -->
    </xsl:template>
    <xsl:template match="orderedlist">
        <ol>
            <!--<xsl:if test="self::node()[ancestor::section2/@layout='inline']">
    <xsl:attribute name="class">runin</xsl:attribute>
  </xsl:if>-->
            <xsl:choose>
                <xsl:when test="@numeration='loweralpha'">
                    <xsl:attribute name="type">a</xsl:attribute>
                </xsl:when>
                <xsl:when test="@numeration='upperalpha'">
                    <xsl:attribute name="type">A</xsl:attribute>
                </xsl:when>
                <xsl:when test="@numeration='lowerroman'">
                    <xsl:attribute name="type">i</xsl:attribute>
                </xsl:when>
                <xsl:when test="@numeration='upperroman'">
                    <xsl:attribute name="type">I</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    <xsl:template match="orderedlist[ancestor::section2/@layout='inline']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="listitem">
        <li>
            <xsl:if test="self::node()[ancestor::question]">
                <xsl:attribute name="class">Bold</xsl:attribute>
            </xsl:if>
            <xsl:if test="self::node()[ancestor::answer]">
                <xsl:attribute name="class">a</xsl:attribute>
            </xsl:if>
            <!--<xsl:if test="self::node()[ancestor::section2/@layout='inline']">
        <xsl:attribute name="class">runin</xsl:attribute>
    </xsl:if>-->
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="listitem[ancestor::section2/@layout='inline']">
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="self::node()[ancestor::question][parent::orderedlist/@numeration='loweralpha']">
                <b>
                    <xsl:number format="a." count="listitem"/>
                </b>
            </xsl:when>
            <xsl:when test="self::node()[parent::orderedlist/@numeration='loweralpha']">
                <xsl:number format="a." count="listitem"/>
            </xsl:when>
            <xsl:when test="self::node()[parent::orderedlist/@numeration='upperalpha']">
                <xsl:number format="A." count="listitem"/>
            </xsl:when>
            <xsl:when test="self::node()[parent::orderedlist/@numeration='lowerroman']">
                <xsl:number format="i." count="listitem"/>
            </xsl:when>
            <xsl:when test="self::node()[parent::orderedlist/@numeration='upperroman']">
                <xsl:number format="I." count="listitem"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <!--<xsl:if test="self::node()[ancestor::section2/@layout='inline']">
           <xsl:attribute name="class">runin</xsl:attribute>
       </xsl:if>-->
        <xsl:apply-templates/>
    </xsl:template>
    <!--
========================================================================
                          PARAGRAPH
========================================================================
-->
    <xsl:template match="para[preceding-sibling::*[1]/@class='runIn']">
        <p class="runin">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[parent::section1/@layout='inline']">
        <p class="runin">
            <xsl:apply-templates/>
        </p>
        <br/>

    </xsl:template>
    <xsl:template match="para[parent::section2/@layout='inline']">
        <p class="runin">
            <xsl:apply-templates/>
        </p>
        <br/>
    </xsl:template>
    <xsl:template
            match="para[not(parent::def)][not (parent::clause)][not (parent::operativeinformal)][not (parent::clauseholder)][not (parent::subclause1)][not (parent::subclause2)][not (parent::subclause3)][not (parent::subclause4)]">

        <!-- CB  this bit of optionality has been removed
        <xsl:if test="attribute::optionality"><xsl:call-template name="opSpanSta"/></xsl:if> -->
        <xsl:choose>
            <xsl:when
                    test="self::node()[not (preceding-sibling::para)][parent::listitem/parent::orderedlist/@spacing='compact']">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when
                    test="self::node()[not (preceding-sibling::para)][parent::listitem/parent::itemizedlist/@spacing='compact']">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <!--
               if parent has an oplink[ @ pos = start ] as its immediate preceding-sibling , then
               use <span> instead of <p> as <p> would add extra new lines.

            -->
                <xsl:choose>
                    <!--optionality code-->
                    <xsl:when
                            test="not(preceding-sibling::*) and parent::*/preceding-sibling::*[1][self::oplink[@pos='start']]">
                        <span>
                            <xsl:if test="$debug = 'true'">
                                <xsl:attribute name="type">
                                    <xsl:text>para-replaced</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string-length(.) &gt; 0 or count(child::*) &gt; 0">
                            <p>
                                <xsl:apply-templates/>
                            </p>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <!-- CB  this bit of optionality has also been removed
        <xsl:if test="attribute::optionality"><xsl:call-template name="opSpanEnd"/></xsl:if>-->
    </xsl:template>


    <!-- para for q and a set -->
    <xsl:template match="para[1][ancestor::question][parent::section2][not (ancestor::trainingquestion)]">
        <div class="q">
            <xsl:choose>
                <xsl:when test="starts-with (ancestor::question/@label, 'W')">
                    <xsl:value-of select="substring-after(ancestor::question/@label,'W_q')"/>.
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::question/@label"/>.
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template
            match="para[1][ancestor::question][ancestor::section2/@layout='inline'][parent::section2][not (ancestor::trainingquestion)]">
        <p class="qil">
            <xsl:choose>
                <xsl:when test="starts-with (ancestor::question/@label, 'W')">
                    <xsl:value-of select="substring-after(ancestor::question/@label,'W_q')"/>.
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::question/@label"/>.
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template
            match="para[ancestor::question][parent::listitem/parent::node()/@spacing='compact'][not (parent::section2)]">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template
            match="para[1][ancestor::question][not (parent::section2)][not (parent::listitem/parent::node()/@spacing='compact')]">
        <p class="q">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[position() &gt; 1][ancestor::question]">
        <div class="q">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="para[position() &gt; 1][ancestor::question][ancestor::section2/@layout='inline']">
        <p class="qil">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[1][ancestor::question][not (parent::section2)][not (parent::listitem)]">
        <div class="q">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="para[1][ancestor::question][ancestor::section2/@layout='inline'][not (parent::section2)]">
        <p class="qil">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[ancestor::answer][not (parent::listitem/parent::node()/@spacing='compact')]">
        <p class="a">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="answer/section2/para">
        <xsl:if test="string-length(.) &gt; 0">
            <p class='a'>
                <xsl:apply-templates/>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="answer/section2/section3">

        <xsl:if test="string-length(.) &gt; 0">
            <div class='answer'>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="answer/section2/itemizedlist">
        <div class='answer'>
            <ul>
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="answer/section2/para[@xml:space='preserve']">
        <div class='answer'>
            <!--			not sure why there was a pre tage here, possibly from WL buts its a complete disaster for the normal website-->
            <!--<pre>-->
            <xsl:apply-templates/>
            <!--</pre>-->
        </div>
    </xsl:template>


    <xsl:template match="para[ancestor::answer][parent::listitem/parent::node()/@spacing='compact']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="para[itemizedlist]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="para[qandaentry]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- checks for blockquotes, uses paraDiv instead of p to prevent invalid HTML -->
    <xsl:template match="para[child::blockquote]">
        <div class="paraDiv">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- if blockquote is the last child of a para, bottom margin is removed to prevent double spacing -->
    <xsl:template match="blockquote[parent::para][position() = last()]">
        <blockquote class="noBottomMargin">
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>

    <xsl:template match="blockquote">
        <blockquote>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>
    <!--
========================================================================
                          INLINE
========================================================================
-->
    <xsl:template match="emphasis|emphasis[@role='italic']|foreignphrase">
        <xsl:if test="string-length(.) &gt; 0">
            <em>
                <xsl:apply-templates/>
            </em>
        </xsl:if>
    </xsl:template>

    <xsl:template match="emphasis[@role='bold'][not (ancestor::row)]">
        <xsl:if test="string-length(.) &gt; 0">
            <strong>
                <xsl:apply-templates/>
            </strong>
        </xsl:if>
    </xsl:template>

    <xsl:template match="emphasis[@role='bold'][ancestor::row]">
        <xsl:if test="string-length(.) &gt; 0">
            <strong>
                <xsl:variable name="row-position" select="count(ancestor::row[1]/preceding-sibling::row)+1"/>
                <!--
               CB this is used for DA - see Vasu's comment below
             entry
               para
                 emphasis

                 if there is a colspec with the optionality attribute and if its position is equal to the  position of the
                 ancestor entry then the current entry.para/emphasis is optional.

                 1. find the position of the ancestor entry..
                    count(ancestor::entry[1]/preceeding-sibling::entry)+1

                 2. is there a colspec with the position as above and does it have an optionality attribute???
                       is .. string(ancestor::tgroup[1]/colspec[$entry-pos]/@optionality)
                 3. is the current row the first row??
                 4. is the ancestor entry child of row??

                  if above satisfies, cool.. get the other attributes and put the '['

                 -->
                <xsl:variable name="ent-pos" select="count(ancestor::entry[1]/preceding-sibling::entry)+1"/>
                <xsl:variable name="is-column-optional" select="ancestor::tgroup[1]/colspec[$ent-pos]/@optionality"/>
                <xsl:if test="ancestor::entry[parent::row] and $row-position =1 and string($is-column-optional)">
                    <xsl:variable name="href" select="ancestor::tgroup[1]/colspec[$ent-pos]/@href"/>
                    <xsl:variable name="onclick" select="ancestor::tgroup[1]/colspec[$ent-pos]/@onclick"/>
                    <!--				<a name = "{ancestor::tgroup[1]/colspec[$ent-pos]/@return-anchor}"/>-->
                    <a href="{$href}"
                       onclick="{$onclick}"
                       onmouseover="ho({concat('&#34;','col',$ent-pos,'&#34;')},'on')"
                       onmouseout="ho({concat('&#34;','col',$ent-pos,'&#34;')},'off')">[
                    </a>
                </xsl:if>
                <xsl:apply-templates/>
            </strong>
        </xsl:if>
    </xsl:template>


    <xsl:template match="emphasis[@role='none']">
        <xsl:if test="string-length(.) &gt; 0">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="emphasis[@role='bold-italic']">
        <strong>
            <em>
                <xsl:apply-templates/>
            </em>
        </strong>
    </xsl:template>

    <xsl:template match="emphasis[@role='underline']">
        <xsl:if test="string-length(.) &gt; 0">
            <u>
                <xsl:apply-templates/>
            </u>
        </xsl:if>
    </xsl:template>

    <xsl:template match="emphasis[@role='doubleunderline']">
        <span class="dunderline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="emphasis[@role='amend']">
        <xsl:if test="string-length(.) &gt; 0">
            <span class="amend">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="superscript">
        <xsl:if test="string-length(.) &gt; 0">
            <sup>
                <xsl:apply-templates/>
            </sup>
        </xsl:if>
    </xsl:template>

    <xsl:template match="subscript">
        <xsl:if test="string-length(.) &gt; 0">
            <sub>
                <xsl:apply-templates/>
            </sub>
        </xsl:if>
    </xsl:template>

    <!-- cb added processing for figure and print graphics -->
    <xsl:template match="figure">
        <xsl:apply-templates select="title"/>
        <xsl:apply-templates select="graphic"/>
    </xsl:template>

    <xsl:template match="graphic[@format='tiff']"></xsl:template>

    <xsl:template match="graphic[@format='print']"></xsl:template>


    <!--<xsl:template match="graphic">
        <xsl:choose>
            <xsl:when test="not(parent::source/parent::metadata)">
                <xsl:if test="not(ancestor::table)">
                    <xsl:text disable-output-escaping="yes">&lt;div style="width:100%; overflow:auto"></xsl:text>
                </xsl:if>
                    <img border="0">
                        <xsl:attribute name="src"><xsl:value-of select="concat('/cs/Satellite?pagename=PLC/Media_C/PLCDisplayMedia&amp;c=Media_C&amp;cid=' , @fileref)"/></xsl:attribute>
                        <xsl:if test="@width and string-length (@width) &gt; 0">
                            <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@depth">
                            <xsl:attribute name="height"><xsl:value-of select="@depth"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@srccredit">
                            <xsl:attribute name="alt"><xsl:value-of select="@srccredit"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@align">
                            <xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@format='ownpage'">
                            <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat('/cs/Satellite?pagename=PLC/Media_C/PLCDisplayMedia&amp;c=Media_C&amp;cid=' , @fileref)"/>','image','toolbar=0,location=0');</xsl:attribute>
                        </xsl:if>
                    </img>
                <xsl:if test="not(ancestor::table)">
                    <xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <img border="0">
                    <xsl:attribute name="src"><xsl:value-of select="concat('/cs/Satellite?pagename=PLC/Media_C/PLCDisplayMedia&amp;c=Media_C&amp;cid=' , @fileref)"/></xsl:attribute>
                    <xsl:if test="@width and string-length (@width) &gt; 0">
                        <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@depth">
                        <xsl:attribute name="height"><xsl:value-of select="@depth"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@srccredit">
                        <xsl:attribute name="alt"><xsl:value-of select="@srccredit"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@align">
                        <xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@format='ownpage'">
                        <xsl:attribute name="onclick">window.open('<xsl:value-of select="concat('/cs/Satellite?pagename=PLC/Media_C/PLCDisplayMedia&amp;c=Media_C&amp;cid=' , @fileref)"/>','image','toolbar=0,location=0');</xsl:attribute>
                    </xsl:if>
                </img>
            </xsl:otherwise>

        </xsl:choose>
        </xsl:template>-->

    <xsl:template match="graphic">

        <!-- don't need this, can do in script - just remove binaryContent -->
        <xsl:variable name="identifier">
            <xsl:choose>
                <xsl:when test="contains(@fileref,'binaryContent.jsp?item=:')">imageref=<xsl:value-of
                        select="substring-after(@fileref,'binaryContent.jsp?item=:')"/>
                </xsl:when>
                <xsl:when test="contains(@fileref,'binaryContent.jsp?item=')">imageref=<xsl:value-of
                        select="substring-after(@fileref,'binaryContent.jsp?item=')"/>
                </xsl:when>
                <xsl:when test="contains(@fileref,'-')">imageref=<xsl:value-of select="@fileref"/>
                </xsl:when>
                <xsl:otherwise>cid=<xsl:value-of select="@fileref"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="ref">
            <xsl:choose>
                <xsl:when test="contains(@fileref,'item=')">
                    <xsl:if test="not(contains(@fileref,'-')) and not(contains(@fileref,':'))">:</xsl:if>
                    <xsl:value-of select="substring-after(@fileref,'item=')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@fileref"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="string-length(@width)&gt;0">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="height">
            <xsl:choose>
                <xsl:when test="string-length(@depth)&gt;0">
                    <xsl:value-of select="@depth"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="alt" select="@srccredit"/>
        <xsl:variable name="align" select="@align"/>

        <xsl:if test="not(ancestor::table)">
            <xsl:text disable-output-escaping="yes">&lt;div class="inline-image"></xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="contains($ref,'presentation/images')">
                <img src="{$ref}" alt="{$alt}" width="{$width}" height="{$height}" align="{$align}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ident" select="concat('image_',generate-id(),'_imageref[',$ref,']')"/>
                <xsl:variable name="class">remote-image
                    <xsl:if test="@format='ownpage'">inline-image-opener</xsl:if>
                </xsl:variable>
                <img id="{$ident}" src="/presentation/images/common/blank.gif" alt="{$alt}" width="{$width}"
                     height="{$height}" align="{$align}" class="{$class}"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(ancestor::table)">
            <xsl:text disable-output-escaping="yes">&lt;/div></xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()[not (ancestor::precedent)][not (ancestor::miscdocument)]">
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template
            match="text()[parent::para][not (count(parent::para/child::*) &gt; 1)][not (child::*)][following-sibling::itemizedlist]">
        <p>
            <xsl:call-template name="convert-chars">
                <xsl:with-param name="this_string" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    <xsl:template
            match="text()[parent::para][not (count(parent::para/child::*) &gt; 1)][following-sibling::itemizedlist][ancestor::answer]">
        <p class="a">
            <xsl:call-template name="convert-chars">
                <xsl:with-param name="this_string" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    <xsl:template
            match="text()[parent::para][count(parent::para/child::*) &gt; 1][not(preceding-sibling::text())][following-sibling::itemizedlist][ancestor::answer]">
        <xsl:text disable-output-escaping="yes">&lt;p class="a"></xsl:text>
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!--
========================================================================
                          TABLES
========================================================================
-->
    <!--
match: table, informaltable
===========================
Convert an XML table into an HTML table.
Taken from Learning XML
-->
    <xsl:template match="table|informaltable">
        <!-- CB The tableWrapper div is a new plc_mvc thing. Need to test very carefully whether this works with da/dd-->
        <div class="tableWrapper">
            <table id="{generate-id()}" cellpadding="5" cellspacing="0">
                <xsl:if test="@frame='all'">
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:if>
                <!-- April 2011.
                Have reimplemented the class attribute
                to support an additional class name
                in the case of a table that includes a colGroup
                -->
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="@tabstyle">
                            <xsl:value-of select="@tabstyle"/>
                        </xsl:when>
                        <xsl:otherwise>Table</xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="tgroup/colspec/@colname">colgroupTable</xsl:if>
                </xsl:attribute>
                <!-- CB March 2005. Have reimplemented the pgwide attribute at the
                request of automation editors -->
                <xsl:if test="@pgwide='1'">
                    <xsl:attribute name="width">100%</xsl:attribute>
                </xsl:if>
                <!--
                    VChak : March 2005. The xpath in the test below is changed from
                    tgroup/colspec/@colwidth to tgroup/colspec/@colname.
                    This is because, some tables wanted the colgroup/col even if the
                    width of the table is not specified.
                -->
                <xsl:if test="tgroup/colspec/@colname">
                    <xsl:call-template name="makecolgroup"/>
                </xsl:if>
                <xsl:apply-templates/>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="tgroup|thead|tbody">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="row">
        <tr id="{generate-id()}">
            <xsl:if test="@rowstyle">
                <xsl:attribute name="class">
                    <xsl:value-of select="@rowstyle"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="thead//entry">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    <xsl:template match="entry">
        <td>
            <xsl:if test="@entrystyle">
                <xsl:attribute name="class">
                    <xsl:value-of select="@entrystyle"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@valign">
                    <xsl:attribute name="valign">
                        <xsl:value-of select="@valign"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="valign">top</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@align">
                <xsl:attribute name="align">
                    <xsl:value-of select="@align"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@namest">
                <xsl:attribute name="colspan">
                    <xsl:call-template name="calculate.colspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@spanname">
                <xsl:attribute name="colspan">
                    <xsl:call-template name="getspan">
                        <xsl:with-param name="spanname">
                            <xsl:value-of select="@spanname"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan">
                    <xsl:value-of select="@morerows + 1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    <!-- cb the current logic for this looks funny for subsequent paras in a table cell
    have modified  
    -->
    <xsl:template match="para[parent::entry]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template name="makecolgroup">
        <colgroup>
            <xsl:for-each select="tgroup/colspec[not(provenances/@optionality = 'unselected')]">
                <col id="{concat('col',position())}">
                    <xsl:if test="$debug = 'true'">
                        <xsl:attribute name="type">
                            <xsl:value-of select="provenances/@optionality"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="width">
                        <xsl:value-of select="@colwidth"/>
                    </xsl:attribute>
                    <xsl:if test="contains(@colwidth,'*')">
                        <xsl:attribute name="align">
                            <xsl:value-of select="@align"/>
                        </xsl:attribute>
                    </xsl:if>
                </col>
            </xsl:for-each>
        </colgroup>
    </xsl:template>
    <xsl:template match="entry[parent::row]">
        <xsl:variable name="ent-pos" select="count(preceding-sibling::entry)+1"/>
        <xsl:variable name="optionality" select="ancestor::tgroup[1]/colspec[$ent-pos]/@optionality"/>
        <xsl:choose>
            <xsl:when test="string($optionality)">
                <!--
                This when condition is for the case when the current entry is optional. This is decided by checking
                if the colspec node of the same position as the current entry position has a value
                for the optionality attribute ( only optional columns ( colspec nodes ) will have  an optionality
                attribute)

             -->
                <xsl:choose>
                    <xsl:when test="$optionality = 'unselected'">
                        <xsl:call-template name="print-table-columns">
                            <xsl:with-param name="caller" select="'option-unsel'"/>
                            <xsl:with-param name="optional-colspec-position" select="$ent-pos"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$optionality = 'selected'">
                        <xsl:call-template name="print-table-columns">
                            <xsl:with-param name="caller" select="'option-sel'"/>
                            <xsl:with-param name="optional-colspec-position" select="$ent-pos"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="print-table-columns">
                    <xsl:with-param name="caller" select="3"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="print-table-columns">
        <xsl:param name="caller"/>
        <xsl:param name="optional-colspec-position"/>
        <xsl:variable name="row-position" select="count(parent::row/preceding-sibling::row)+1"/>
        <xsl:variable name="total-rows" select="count(ancestor::tbody//row)"/>


        <td>
            <xsl:if test="string($optional-colspec-position)">
                <xsl:attribute name="id">
                    <xsl:value-of select="$optional-colspec-position"/>
                </xsl:attribute>


            </xsl:if>
            <xsl:if test="$debug = 'true'">
                <xsl:attribute name="count">
                    <xsl:value-of select="count(preceding-sibling::entry)+1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$caller = 'option-unsel'">
                <xsl:attribute name="class">
                    <xsl:text>optionUnselected</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@entrystyle">
                <xsl:attribute name="class">
                    <xsl:value-of select="@entrystyle"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@valign">
                    <xsl:attribute name="valign">
                        <xsl:value-of select="@valign"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="valign">top</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@align">
                <xsl:attribute name="align">
                    <xsl:value-of select="@align"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@namest">
                <xsl:attribute name="colspan">
                    <xsl:call-template name="calculate.colspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@spanname">
                <xsl:attribute name="colspan">
                    <xsl:call-template name="getspan">
                        <xsl:with-param name="spanname">
                            <xsl:value-of select="@spanname"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan">
                    <xsl:value-of select="@morerows + 1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="$row-position = $total-rows and contains($caller,'option')">
                <xsl:variable name="href" select="ancestor::tgroup[1]/colspec[$optional-colspec-position]/@href"/>
                <xsl:variable name="onclick" select="ancestor::tgroup[1]/colspec[$optional-colspec-position]/@onclick"/>
                <a name="ancestor::tgroup[1]/colspec[$optional-colspec-position]/@return-anchor"/>
                <a href="{$href}" onclick="{$onclick}"
                   onmouseover="ho({concat('&#34;','col',$optional-colspec-position,'&#34;')},'on')"
                   onmouseout="ho({concat('&#34;','col',$optional-colspec-position,'&#34;')},'off')">
                    <xsl:text>]</xsl:text>
                </a>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template name="calculate.colspan">
        <xsl:param name="entry" select="."/>
        <xsl:variable name="namest" select="$entry/@namest"/>
        <xsl:variable name="nameend" select="$entry/@nameend"/>
        <xsl:variable name="scol">
            <xsl:call-template name="colspec.colnum">
                <xsl:with-param name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ecol">
            <xsl:call-template name="colspec.colnum">
                <xsl:with-param name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$ecol - $scol + 1"/>
    </xsl:template>
    <xsl:template name="colspec.colnum">
        <xsl:param name="colspec" select="."/>
        <xsl:choose>
            <xsl:when test="$colspec/@colnum">
                <xsl:value-of select="$colspec/@colnum"/>
            </xsl:when>
            <xsl:when test="$colspec/preceding-sibling::colspec">
                <xsl:variable name="prec.colspec.colnum">
                    <xsl:call-template name="colspec.colnum">
                        <xsl:with-param name="colspec" select="$colspec/preceding-sibling::colspec[1]"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$prec.colspec.colnum + 1"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="getspan">
        <xsl:param name="spanname"/>
        <xsl:variable name="colstart">
            <xsl:for-each select="ancestor::tgroup/spanspec[@spanname='$spanname']">
                <xsl:value-of select="@namest"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="colend">
            <xsl:for-each select="ancestor::tgroup/spanspec[@spanname='$spanname']">
                <xsl:value-of select="@nameend"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="colstartnum">
            <xsl:for-each select="ancestor::tgroup/colspec[@colname='$colst']">
                <xsl:value-of select="@colnum"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="colendnum">
            <xsl:for-each select="ancestor::tgroup/colspec[@colname='$colend']">
                <xsl:value-of select="@colnum"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$colendnum - $colstartnum"/>
    </xsl:template>
    <xsl:template name="colspec.colwidth">
        <!-- when this macro is called, the current context must be an entry -->
        <xsl:param name="colname"/>
        <!-- .. = row, ../.. = thead|tbody, ../../.. = tgroup -->
        <xsl:param name="colspecs" select="../../../../tgroup/colspec"/>
        <xsl:param name="count">1</xsl:param>
        <xsl:choose>
            <xsl:when test="$count>count($colspecs)"/>
            <xsl:otherwise>
                <xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
                <h2>
                    <xsl:value-of select="$colspec"/>
                </h2>
                <xsl:choose>
                    <xsl:when test="$colspec/@colname=$colname">
                        <xsl:value-of select="$colspec/@colwidth"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="colspec.colwidth">
                            <xsl:with-param name="colname" select="$colname"/>
                            <xsl:with-param name="colspecs" select="$colspecs"/>
                            <xsl:with-param name="count" select="$count+1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
========================================================================
                      PLCLINKS
========================================================================
-->

    <!-- the plclinks stuff is new for plc_mvc - would be nice to put into a different module-->
    <!-- there is now a duplicate namespaced prefixed version - very messy-->

    <!--added this dupliacte template to match against old articles that have an xhtml namespace, basically an exact duplicate, really nasty businesss this-->
    <xsl:template match="xhtml:plclink">
        <xsl:element name="a">
            <xsl:if test="string-length(xlink:locator) &gt; 50 and not(contains(xlink:locator, ' '))">
                <xsl:attribute name="class">linkBreak</xsl:attribute>
            </xsl:if>
            <xsl:variable name="tempPlcRef" select="substring-before(concat(xhtml:locator/@href,'#'),'#')"/>
            <xsl:variable name="plcRefCandidate" select="substring-before(concat($tempPlcRef,'?'),'?')"/>
            <xsl:choose>
                <xsl:when
                        test="string-length($plcRefCandidate)=10 and contains($plcRefCandidate, '-') and string(number(substring(translate($plcRefCandidate,'-',''), 2,7))) != 'NaN'">
                    <xsl:attribute name="href">/<xsl:value-of select="xhtml:locator/@href"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="xhtml:locator/@role[.='Article']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/A</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>

                        <xsl:when test="xhtml:locator/@role[.='dbrecord']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/A</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="xhtml:locator/@role[.='Organisation']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/O</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <em>
                                <xsl:apply-templates/>
                            </em>
                        </xsl:when>
                        <xsl:when test="strong/xhtml:locator/@role[.='Organisation']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/O</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="strong/xhtml:locator/@href"/>
                            </xsl:attribute>
                            <em>
                                <xsl:apply-templates/>
                            </em>
                        </xsl:when>
                        <xsl:when test="xhtml:locator/@role[.='Topic']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/T</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="xhtml:locator/@role[.='Web']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/W</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="xhtml:locator/@role[.='Contact']">
                            <xsl:attribute name="href">/C<xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="xhtml:locator/@role[.='Individual']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/C</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="xhtml:locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="strong/xhtml:locator/@role[.='Contact']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/C</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="strong/xhtml:locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="strong/xhtml:locator/@role[.='Individual']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(xhtml:locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/C</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="strong/xhtml:locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="@xml:link[.='simple']">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>


    <xsl:template match="plclink">
        <xsl:element name="a">
            <xsl:if test="string-length(xlink:locator) &gt; 50 and not(contains(xlink:locator, ' '))">
                <xsl:attribute name="class">linkBreak</xsl:attribute>
            </xsl:if>
            <xsl:variable name="tempPlcRef" select="substring-before(concat(locator/@href,'#'),'#')"/>
            <xsl:variable name="plcRefCandidate" select="substring-before(concat($tempPlcRef,'?'),'?')"/>
            <xsl:choose>
                <xsl:when
                        test="string-length($plcRefCandidate)=10 and contains($plcRefCandidate, '-') and string(number(translate($plcRefCandidate,'-','')))!='NaN'">
                    <xsl:attribute name="href">/<xsl:value-of select="locator/@href"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="locator/@role[.='Article']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/A</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>

                        <xsl:when test="locator/@role[.='dbrecord']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/A</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="locator/@role[.='Organisation']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/O</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <em>
                                <xsl:apply-templates/>
                            </em>
                        </xsl:when>
                        <xsl:when test="strong/locator/@role[.='Organisation']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/O</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="strong/locator/@href"/>
                            </xsl:attribute>
                            <em>
                                <xsl:apply-templates/>
                            </em>
                        </xsl:when>
                        <xsl:when test="locator/@role[.='Topic']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/T</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="locator/@role[.='Web']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/W</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="locator/@role[.='Contact']">
                            <xsl:attribute name="href">/C<xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="locator/@role[.='Individual']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/C</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="strong/locator/@role[.='Contact']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/C</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="strong/locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="strong/locator/@role[.='Individual']">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="contains(locator/@href, ':')">/resource.do?item=</xsl:when>
                                    <xsl:otherwise>/C</xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="strong/locator/@href"/>
                            </xsl:attribute>
                            <strong>
                                <xsl:apply-templates/>
                            </strong>
                        </xsl:when>
                        <xsl:when test="@xml:link[.='simple']">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@href"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!--
========================================================================
                          XLINKS
========================================================================
-->
    <!--turn plcxlinks into anchors-->
    <xsl:template match="plcxlink">
        <!-- CB feb 2007 we need to allow xrefs with no text. this is because the text (e.g. clause x.x) is autogenerated from the link target -->

        <xsl:if test="(string-length(xlink:locator) &gt; 0) or (descendant::xref)"><!-- and string-length(xlink:locator/@xlink:href) &gt; 0 removed this logic so links with no href will render, this should help the document stay valid but really all links should  -->

            <xsl:variable name="linkbreak"
                          select="string-length(xlink:locator) &gt; 50 and not(contains(xlink:locator, ' '))"/>
            <xsl:variable name="qaQuestionLink"
                          select="starts-with(xlink:locator/@xlink:href, '#') and $qanda and count($answers)&gt;0"/>

            <xsl:variable name="linkClass">
                <xsl:if test="$linkbreak=true()">linkBreak</xsl:if>
                <xsl:if test="$qaQuestionLink=true()">qa-question-link</xsl:if>
            </xsl:variable>

            <a>
                <xsl:if test="string-length($linkClass)&gt;0">
                    <xsl:attribute name="class">
                        <xsl:value-of select="$linkClass"/>
                    </xsl:attribute>
                </xsl:if>

                <!-- *** dodgy test to open da links in new window - if too fuzzy, use separate parameter *** -->
                <!-- cb - added extra logic so that xrefs open in the same window -->
                <xsl:if test="($articleserver!='') and not (descendant::xref)">
                    <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:if>
                <!-- Is it a PLC Reference? we want to count the length of the href to see if it's a new plc ref,
                    but new plc ref might have a querystring hash locator tacked on the end. 'substring-before' returns
                    empty if the substring isn't found, otherwise it finds the first occurrence of the substring. so let's
                    stick a ? and hash at the end of the string regardless of whether there's one there already. Also test
                    it contains at least one dash, and it's numeric when the dashes are stripped.
                    -->
                <xsl:variable name="tempPlcRef2" select="substring-before(concat(xlink:locator/@xlink:href,'#'),'#')"/>
                <xsl:variable name="plcRefCandidate2" select="substring-before(concat($tempPlcRef2,'?'),'?')"/>
                <xsl:choose>
                    <!-- sc 23/03/2009 - check 15 digit refs too (new fatwire pub refs) -->
                    <xsl:when
                            test="(string-length($plcRefCandidate2)=10 or string-length($plcRefCandidate2)=15) and contains($plcRefCandidate2, '-') and string(number(substring(translate($plcRefCandidate2,'-',''), 2,7))) != 'NaN' and not (xlink:arc/@xlink:show[.='embed'])">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <!--<xsl:text>/</xsl:text>--> <!-- sc - don't return to the root until url assembler doesn't need cs/Satellite -->
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:if test="xlink:locator/@xlink:popup='yes'">
                            <xsl:attribute name="target">_blank</xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="xlink:locator/@xlink:role[.='Organisation']">
                                <strong>
                                    <xsl:apply-templates/>
                                </strong>
                            </xsl:when>
                            <xsl:when test="xlink:locator/@xlink:role[.='Contact']">
                                <em>
                                    <!-- added -->
                                    <!-- eh? by whom? when? -->
                                    <xsl:choose>
                                        <xsl:when
                                                test="generate-id(parent::para)=generate-id(ancestor::subclause1[1]/para)">
                                            <xsl:call-template name="convert-case-with-index">
                                                <xsl:with-param name="letter-index" select="1"/>
                                                <xsl:with-param name="word" select="xlink:locator/text()"/>
                                                <xsl:with-param name="case" select="'upper'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </em>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- CB note a whole block of code has been omitted here - stuff with plcrefs - as follows
                        <xsl:text> (www.practicallaw.com/</xsl:text>
                                <xsl:value-of select="$plcRefCandidate"/>)
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$articleserver"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:attribute>
                                <xsl:apply-templates />
                            </xsl:otherwise>
                        </xsl:choose>
                        -->
                    </xsl:when>

                    <xsl:when test="xlink:locator/@xlink:role[.='Article'] and not (xlink:arc/@xlink:show[.='embed'])">
                        <xsl:choose>
                            <xsl:when test="$countryfilter!=''">
                                <xsl:choose>
                                    <xsl:when test="starts-with(xlink:locator/@xlink:href,'#')">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$articleserver"/>
                                            <xsl:choose>
                                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">
                                                    /resource.do?item=
                                                </xsl:when>
                                                <xsl:otherwise>/A</xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                                            <xsl:text>&amp;jurisFilter=</xsl:text>
                                            <xsl:value-of select="$countryfilter"/>
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="starts-with(xlink:locator/@xlink:href, '#')">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$articleserver"/>
                                    <xsl:choose>
                                        <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=
                                        </xsl:when>
                                        <xsl:otherwise>/A</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="normalize-space(xlink:locator)"/>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='dbrecord']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="locator/@href"/>
                        </xsl:attribute>
                        <xsl:value-of select="xlink:locator"/>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Organisation']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/O</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <strong>
                            <xsl:value-of select="normalize-space(xlink:locator)"/>
                        </strong>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Topic']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/T</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(xlink:locator)"/>

                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Web']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/W</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(xlink:locator)"/>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='Contact']">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$articleserver"/>
                            <xsl:choose>
                                <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=</xsl:when>
                                <xsl:otherwise>/C</xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <em>
                            <xsl:value-of select="normalize-space(xlink:locator)"/>
                        </em>
                    </xsl:when>
                    <!-- ref xlink for precedents. -->
                    <!-- CB changed Spet 2003 to autogenerate link content -->
                    <xsl:when test="xlink:locator/@xlink:role[.='xref']">
                        <xsl:if test="contains(xlink:locator/@xlink:href, 'navigator')">
                            <xsl:attribute name="target">
                                <xsl:text>navigator</xsl:text>
                            </xsl:attribute>
                        </xsl:if>

                        <xsl:attribute name="href">
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>

                        <!--<xsl:attribute name="class">xref</xsl:attribute>-->
                        <em>
                            <xsl:apply-templates select="xlink:locator/xref"/>
                        </em>
                    </xsl:when>
                    <!-- non em version for da -->
                    <xsl:when test="xlink:locator/@xlink:role[.='defxref']">
                        <!--					<xsl:if test="contains(xlink:locator/@xlink:href, 'navigator')">
                                                <xsl:attribute name="target"><xsl:text>navigator</xsl:text></xsl:attribute>
                                            </xsl:if>	-->
                        <xsl:attribute name="href">
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">xref</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="ancestor::title and not(ancestor::letter)">
                                <xsl:call-template name="convert-case-with-index">
                                    <xsl:with-param name="word" select="xlink:locator/xref"/>
                                    <xsl:with-param name="whole-word" select="'yah-huh'"/>
                                    <xsl:with-param name="case" select="'upper'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="xlink:locator/xref"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Authority/ External File. Still in development stages. -->
                    <xsl:when test="xlink:locator/@xlink:role[.='AuthorityFile']">
                        <xsl:attribute name="href">
                            <xsl:text>javascript:window.open('http://city/webtest/legalcitator/authority.asp?authority_id=</xsl:text>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                            <xsl:text>',450)</xsl:text>
                        </xsl:attribute>
                        <em>
                            <xsl:apply-templates/>
                        </em>
                    </xsl:when>
                    <xsl:when test="xlink:locator/@xlink:role[.='External']">
                        <xsl:attribute name="href">
                            <xsl:text>/citatordemo/doitourl.asp?doi=</xsl:text>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <em>
                            <xsl:apply-templates/>
                        </em>
                    </xsl:when>
                    <!-- for plc files link -->
                    <xsl:when test="not (xlink:locator/@xlink:role)">
                        <xsl:attribute name="href">
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:attribute>
                        <em>
                            <xsl:apply-templates/>
                        </em>
                    </xsl:when>
                    <!--	This template will match when all else fails, generally when something has gone since one
                            of the other templates SHOULD match first but since people code incorrectly we have to have this template -->
                    <xsl:otherwise>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="string-length(xlink:locator/@xlink:href) &gt; 0">
                                    <xsl:value-of select="xlink:locator/@xlink:href"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>javascript:void(0)</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="not(contains(xlink:locator, 'www'))">
                    <xsl:variable name="tempPlcRef3"
                                  select="substring-before(concat(xlink:locator/@xlink:href,'#'),'#')"/>
                    <xsl:variable name="plcRefCandidate3" select="substring-before(concat($tempPlcRef3,'?'),'?')"/>
                    <xsl:choose>
                        <xsl:when
                                test="string-length($plcRefCandidate3)=10 and contains($plcRefCandidate3, '-') and string(number(translate(substring($plcRefCandidate3,2),'-','')))!='NaN' and not (xlink:arc/@xlink:show[.='embed'])">
                            <span class="printLink"><xsl:text
                                    >&#160;</xsl:text>(
                                <xsl:call-template name="getPrintLinkRoot"/>
                                <xsl:text>.practicallaw.com/</xsl:text><xsl:value-of select="$plcRefCandidate3"/>)
                            </span>
                        </xsl:when>

                        <xsl:when
                                test="xlink:locator/@xlink:role[.='Article'] and not (xlink:arc/@xlink:show[.='embed'])">
                            <xsl:if test="not (starts-with(xlink:locator/@xlink:href,'#'))">
                                <span class="printLink"><xsl:text>&#160;</xsl:text>(
                                    <xsl:call-template name="getPrintLinkRoot"/>
                                    <xsl:text>.practicallaw.com</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=
                                        </xsl:when>
                                        <xsl:otherwise>/A</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="xlink:locator/@refid">
                                            <xsl:value-of select="xlink:locator/@refid"/>
                                        </xsl:when>
                                        <xsl:when test="contains(xlink:locator/@xlink:href,'#')">
                                            <xsl:value-of select="substring-before(xlink:locator/@xlink:href,'#')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>)</xsl:text>
                                </span>
                            </xsl:if>
                        </xsl:when>

                        <xsl:when test="xlink:locator/@xlink:role[.='Topic']">

                            <span class="printLink"><xsl:text>&#160;</xsl:text>(
                                <xsl:call-template name="getPrintLinkRoot"/>
                                <xsl:text>.practicallaw.com</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=
                                    </xsl:when>
                                    <xsl:otherwise>/T</xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains(xlink:locator/@xlink:href,'#')">
                                        <xsl:value-of select="substring-before(xlink:locator/@xlink:href,'#')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="xlink:locator/@xlink:href"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>)</xsl:text>
                            </span>
                        </xsl:when>

                        <xsl:when test="xlink:locator/@xlink:role[.='Web']">
                            <span class="printLink"><xsl:text>&#160;</xsl:text>(
                                <xsl:call-template name="getPrintLinkRoot"/>
                                <xsl:text>.practicallaw.com</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(xlink:locator/@xlink:href, ':')">/resource.do?item=
                                    </xsl:when>
                                    <xsl:otherwise>/T</xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains(xlink:locator/@xlink:href,'#')">
                                        <xsl:value-of select="substring-before(xlink:locator/@xlink:href,'#')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="xlink:locator/@xlink:href"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>)</xsl:text>
                            </span>
                        </xsl:when>

                    </xsl:choose>
                </xsl:if>
            </a>
            <!-- sc 20/10/2008 - call a template to add additional text to the output, based on attributes
                in the xlink:locator -->
            <xsl:call-template name="plcxlink_suffix">
                <xsl:with-param name="locator" select="xlink:locator"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- sc 20/10/2008 - added support for adding extra text to plcxlinks -->
    <!-- currently unused by default, this template is overridden in the us plcfPrecxhtml.xsl -->
    <xsl:template name="plcxlink_suffix"/>

    <xsl:template match="xref">
        <xsl:variable name="xrefnode" select="key('xreflink', @link)"/>
        <xsl:variable name="xrefname" select="name($xrefnode)"/>
        <!-- CB refactored Aug 2006 - similar logic as word transform
        CB April 2007 added rule xrefname-->
        <xsl:variable name="xreflogicalname">
            <xsl:choose>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='paragraph'">
                    <xsl:text>paragraph</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='condition'">
                    <xsl:text>condition</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='rule'">
                    <xsl:text>rule</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='section'">
                    <xsl:text>section</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='article'">
                    <xsl:text>Article</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::schedule">
                    <xsl:text>paragraph</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>clause</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="xreflogicalssname">
            <xsl:choose>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='paragraph'">
                    <xsl:text>Paragraph</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='condition'">
                    <xsl:text>Condition</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='rule'">
                    <xsl:text>Rule</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='section'">
                    <xsl:text>Section</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::operative/attribute::xrefname='article'">
                    <xsl:text>Article</xsl:text>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::schedule">
                    <xsl:text>Paragraph</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Clause</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:if test="$xrefname='schedule' and (/precedent) and (count(ancestor::precedent/schedule) &lt; 2)">
            <xsl:text>the </xsl:text>
        </xsl:if>
        <xsl:if test="$xrefname='schedule' and (/letter) and (count(ancestor::letter/schedule) &lt; 2)">
            <xsl:text>the </xsl:text>
        </xsl:if>
        <xsl:choose>
            <!-- capitalise link at start of element, but not in subclause2-->
            <xsl:when test="(($xrefname='clause') or ($xrefname='subclause1') or
                    ($xrefname='subclause2')) and not(ancestor::subclause2) and not ((ancestor::plcxlink/preceding-sibling::*) or (ancestor::plcxlink/preceding-sibling::text()))">
                <xsl:value-of select="$xreflogicalssname"/><xsl:text> </xsl:text>
            </xsl:when>
            <!-- capitalise link at start of sentence - a special case because def treated as inline-->
            <xsl:when
                    test="(($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2')) and (substring (ancestor::plcxlink/preceding-sibling::text()[1],string-length(ancestor::plcxlink/preceding-sibling::text()[1])-1,2)='. ')">
                <xsl:value-of select="$xreflogicalssname"/><xsl:text> </xsl:text>
            </xsl:when>
            <!-- uncapitalise link at start of def - a special case because def treated as inline-->
            <xsl:when
                    test="(($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2')) and (ancestor::plcxlink/parent::para[not (preceding-sibling::para)]/parent::def)">
                <xsl:value-of select="$xreflogicalname"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <!-- otherwise uncapitalise -->
            <xsl:when
                    test="($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2') or ($xrefname='subclause3')">
                <xsl:value-of select="$xreflogicalname"/><xsl:text> </xsl:text>
            </xsl:when>

            <xsl:when test="$xrefname='schedule' and (/precedent) and (count(ancestor::precedent/schedule) &lt; 2)">
                <xsl:text>Schedule</xsl:text>
            </xsl:when>
            <xsl:when test="$xrefname='schedule' and (/letter) and (count(ancestor::letter/schedule) &lt; 2)">
                <xsl:text>Schedule</xsl:text>
            </xsl:when>
            <xsl:when test="$xrefname='schedule'">
                <xsl:text>Schedule </xsl:text>
            </xsl:when>
            <xsl:when test="$xrefname='part'">
                <xsl:text> Part </xsl:text>
            </xsl:when>
            <xsl:when test="$xrefname='appendix'">
                <xsl:text>Annex </xsl:text>
            </xsl:when>
            <xsl:when test="$xrefname='defitem'">
                <!-- RW changed from value-of select="." to
                apply-templates so that text will get capitalised like
                it ought to; lesson: favour letting the stylesheet continue
                with its transform by calling apply templates rather than
                stopping it with xsl:value-of -->
                <!--				<xsl:value-of select="."/>-->
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="$xrefname=''">
                <xsl:text>[CROSS-REFERENCE] </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$xrefname='recitals'">
                <xsl:call-template name="recitalsParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='clause'">
                <xsl:call-template name="firstClauseParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause1'">
                <xsl:call-template name="firstSubclause1ParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="($xrefname='subclause2') and ($xrefnode/parent::def)">
                <xsl:call-template name="firstSubclause2DefParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="($xrefname='subclause2') and (count ($xrefnode/ancestor::clause/descendant::subclause1) &gt; 1)">
                <xsl:call-template name="firstSubclause2ParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause2'">
                <xsl:call-template name="firstSingleSubclause2ParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause3'">
                <xsl:call-template name="firstSubclause3ParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause4'">
                <xsl:call-template name="firstSubclause4ParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="($xrefname='schedule') and (ancestor::precedent)">
                <xsl:call-template name="firstScheduleParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="($xrefname='schedule')">
                <xsl:call-template name="firstScheduleParaNumLet">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='part'">
                <xsl:call-template name="firstPartParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='appendix'">
                <xsl:call-template name="appendixNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='defitem' and (normalize-space(text())='' or not (text()))">
                <xsl:call-template name="defitemNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <!--</em>-->
    </xsl:template>


    <!--multilink-->
    <xsl:template match="plcxlink[xlink:locator/following-sibling::xlink:locator]">
        <xsl:variable name="header">&lt;table cellpadding=3 border=1 bgcolor=#FBFAE1></xsl:variable>
        <xsl:variable name="footer">&lt;/table></xsl:variable>
        <a>
            <xsl:attribute name="href">javascript:displayOptions('
                <xsl:value-of select="$header"/><xsl:text>&lt;td></xsl:text>
                <xsl:call-template
                        name="xlink2html-create-list"><!-- <xsl:with-param name="nodes" select="."/>--></xsl:call-template>
                <xsl:text>&lt;/td></xsl:text><xsl:value-of select="$footer"/>
                ');
            </xsl:attribute>
            <xsl:apply-templates select="text()"/>
        </a>
    </xsl:template>

    <!-- new mvc primary source links-->
    <!--multilink: refactored for financial services linking Mar 2006-->
    <!--second refactoring for MVC-->
    <xsl:template
            match="plcxlink[xlink:locator/attribute::xlink:role='PrimarySource'][not(xlink:locator/attribute::xlink:provider)]">
        <xsl:variable name="link_id" select="xlink:locator/attribute::xlink:href"/>
        <xsl:variable name="link_article">
            <xsl:value-of select="substring-before($link_id,  '#')"/>
        </xsl:variable>
        <xsl:variable name="link_anchor">
            <xsl:value-of select="substring-after($link_id,  '#')"/>
        </xsl:variable>
        <xsl:variable name="isMenu">
            <xsl:value-of select="not(@xlink:label='hasnopopup')"/>
        </xsl:variable>
        <a name="primaryLink" href="javascript:void(0)"
           onclick="plc.widget.primarysource.get(this,{$isMenu},'{$link_anchor}','plc');">
            <xsl:apply-templates select="xlink:locator//text()"/>
        </a>
    </xsl:template>

    <xsl:template
            match="plcxlink[xlink:locator/attribute::xlink:role='PrimarySource'][xlink:locator/attribute::xlink:provider='justcite']">
        <xsl:variable name="link_id" select="xlink:locator/attribute::xlink:href"/>
        <xsl:variable name="link_provider" select="xlink:locator/attribute::xlink:provider"/>
        <xsl:variable name="pit" select="xlink:locator/attribute::xlink:pit"/>
        <xsl:variable name="case" select="starts-with($link_id,'D')"/>

        <!-- new logic - configure in various ways -->
        <xsl:choose>
            <xsl:when test="$case='true'">
                <xsl:choose>
                    <xsl:when test="$cases-links-on='true'">
                        <xsl:choose>
                            <xsl:when test="$cases-popup='true'">
                                <a class="-plc-multilink" href="{$link_id}">
                                    <xsl:apply-templates select="xlink:locator//text()"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{$link_id}">
                                    <xsl:apply-templates select="xlink:locator//text()"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="xlink:locator//text()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$primarysourceon='true'">
                <xsl:choose>
                    <xsl:when test="$display-direct-link='true'">
                        <a href="{$link_id}?pit={$pit}">
                            <xsl:apply-templates select="xlink:locator//text()"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a class="-plc-multilink" href="{$link_id}?pit={$pit}">
                            <xsl:apply-templates select="xlink:locator//text()"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="xlink:locator//text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- CB fix for changing 3D site to 3d site-->
    <xsl:template name="xlink2html-create-list">
        <xsl:param name="link_node"/>
        <xsl:for-each select="$link_node/para/simpleplcxlink">
            <xsl:value-of select="@xlink:href"/>
            <xsl:text disable-output-escaping="yes">,</xsl:text>
            <xsl:choose>
                <xsl:when test=".='3D site'">
                    <xsl:text>3d site</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>|</xsl:text>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="artinc|endinc">
        <!-- <hr style='border:solid 1px #eeeeee;' /> -->
        <!-- insert anchor for linking purposes -->

        <xsl:text disable-output-escaping="yes">&lt;a name="#</xsl:text><xsl:value-of select="@ref"/><xsl:text
            disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        <!--
    <h6 class="tableShade">The following article has been included. Fulltext <a><xsl:attribute name="href"><xsl:value-of select="$articleserver"/>/jsp/article.jsp?item=<xsl:value-of select="@ref"/></xsl:attribute>here</a> (www.practicallaw.com/A<xsl:value-of select="@ref"/>)</h6>
    -->
    </xsl:template>
    <!--turn simpleplcxlinks into anchors-->
    <xsl:template match="simpleplcxlink">
        <a>
            <xsl:if test="string-length(.) &gt; 50 and not(contains(., ' '))">
                <xsl:attribute name="class">linkBreak</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="href">
                <xsl:value-of select="@xlink:href"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>


    <!--
========================================================================
                       TRAINING MODULE
========================================================================
-->
    <xsl:template match="plcxlink[xlink:arc/@xlink:show='replace'][ancestor::trainingmodule]">
        <xsl:variable name="trainingq">
            <xsl:value-of select="xlink:locator/@xlink:href"/>
        </xsl:variable>
        <xsl:variable name="traininglink"><xsl:value-of select="$articleserver"/>/jsp/trainques.jsp?qitem=<xsl:value-of
                select="//metadata/relation/plcxlink/xlink:locator[position()=$trainingq]/@xlink:href"/>&amp;item=<xsl:value-of
                select="$moduleId"/>
        </xsl:variable>
        <font size="4">
            <xsl:apply-templates/>
        </font>
        -
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="$traininglink"/>
            </xsl:attribute>
            <xsl:value-of select="//metadata/relation/plcxlink/xlink:locator[position()=$trainingq]/@xlink:title"/>
        </a>
        <br/>
    </xsl:template>

    <!--
    ========================================================================
                           TRAINING QUESTIONS
    ========================================================================
    -->
    <xsl:template match="training">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="source">
        <p>
            <strong>Required pre-reading for this question :</strong>
        </p>
        <ul>
            <li>
                <xsl:apply-templates/>
            </li>
        </ul>
    </xsl:template>

    <xsl:template match="question[ancestor::trainingquestion]">
        <xsl:choose>
            <xsl:when test="$haveQuestionsBeenAnswered='false'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <h3>Question</h3>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="multiplechoice">
        <h3>Answers</h3>
        <form method="get" action="Satellite" id="cpd_answer_from">
            <xsl:if test="string-length($contentType) &gt; 0">
                <input type="hidden" name="c" value="{$contentType}"/>
            </xsl:if>
            <xsl:if test="string-length($contentId) &gt; 0">
                <input type="hidden" name="cid" value="{$contentId}"/>
            </xsl:if>
            <xsl:if test="string-length($fwAction) &gt; 0">
                <input type="hidden" name="fwaction" value="{$fwAction}"/>
            </xsl:if>
            <xsl:if test="string-length($view) &gt; 0">
                <input type="hidden" name="view" value="{$view}"/>
            </xsl:if>
            <input type="hidden" name="pagename" value="{$pagename}"/>
            <input type="hidden" name="childpagename" value="{$childPageName}"/>
            <input type="hidden" name="courseId" value="{$courseId}"/>

            <xsl:apply-templates/>
            <xsl:if test="$haveQuestionsBeenAnswered='false'">
                <xsl:if test="$studentLoggedIn='true'">
                    <p>
                        <b>Choose your response and press
                            <INPUT TYPE="SUBMIT" id="cpd_answer" NAME="cmdConfirm" VALUE="Answer"/>
                        </b>
                    </p>
                </xsl:if>
            </xsl:if>
        </form>
    </xsl:template>
    <xsl:template match="choice">
        <xsl:choose>
            <xsl:when test="$haveQuestionsBeenAnswered='false'">
                <p>
                    <b>
                        <xsl:number format="A" count="choice"/>
                    </b>
                    <input type="radio" name="radAns">
                        <xsl:attribute name="value">
                            <xsl:number format="A" count="choice"/>
                        </xsl:attribute>
                    </input>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="choicenumber">
                    <xsl:number format="A" count="choice"/>
                </xsl:variable>
                <p>
                    <b>
                        <xsl:value-of select="$choicenumber"/>
                    </b>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates/>
                    <xsl:choose>
                        <xsl:when test="@correct='1'">
                            <img src="/cs/presentation/images/common/tick.gif"/>
                        </xsl:when>
                        <xsl:when test="$choicenumber=$studentAnswer">
                            <img src="/cs/presentation/images/common/wrong.gif"/>
                        </xsl:when>
                    </xsl:choose>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="para[ancestor::choice][not (preceding-sibling::para)]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="para[ancestor::question][parent::section2][position()=1][ancestor::trainingquestion]">
        <div class="q">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="reason">
        <xsl:choose>
            <xsl:when test="$haveQuestionsBeenAnswered='true'">
                <h3>Reason</h3>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
========================================================================
                        CHANGE TRACKING
                        Changed CB April 2004
                        Deleted text no longer displays
========================================================================
-->
    <!--<xsl:template match="atict:del[namespace-uri()='http://www.arbortext.com/namespace/atict']">
        <span class="delete">
            <xsl:apply-templates />
        </span>
    </xsl:template>-->

    <xsl:template match="atict:del[namespace-uri()='http://www.arbortext.com/namespace/atict']">
        <!--		in order to stop xml tag minimisation we have to add this, otherwise something like an "emphasis" tag will match
                and allow rendering because it only looks for simple empty tags. This then is the simplest way to overcome the problem-->
        <xsl:text disable-output-escaping="yes">&lt;span&gt;&lt;/span&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="atict:add">
        <!--		<span class="amend">-->
        <xsl:apply-templates/>
        <!--		</span>-->
    </xsl:template>

    <xsl:template match="atict:del"/>
    <!--
========================================================================
                        NOT PART OF PLCDTD BUT ADDED FOR PROFILES
========================================================================
-->
    <xsl:template match="address">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="title[@style='address']">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="orgname">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="phone">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="fax">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="email">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="url">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="br">
        <br/>
    </xsl:template>

    <xsl:template name="convert-case-with-index">
        <xsl:param name="letter-index"/>
        <xsl:param name="whole-word"/>
        <xsl:param name="word"/>
        <xsl:param name="case"/>
        <xsl:choose>
            <xsl:when test="string($whole-word)">
                <xsl:choose>
                    <xsl:when test="$case='lower'">
                        <xsl:value-of
                                select="translate($word,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                    </xsl:when>
                    <xsl:when test="$case='upper'">
                        <xsl:value-of
                                select="translate($word,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string($letter-index)">
                <xsl:variable name="string-before-index" select="substring($word,1,($letter-index)-1)"/>
                <xsl:variable name="string-after-index"
                              select="substring($word,($letter-index)+1,string-length($word))"/>
                <xsl:variable name="index-letter">
                    <xsl:choose>
                        <xsl:when test="$letter-index = string-length($word)">
                            <xsl:value-of select="substring($word,$letter-index)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                    select="substring-after(substring-before($word,$string-after-index),$string-before-index)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="lower-index-letter">
                    <xsl:choose>
                        <xsl:when test="$case='lower'">
                            <xsl:value-of
                                    select="translate($index-letter,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                        </xsl:when>
                        <xsl:when test="$case='upper'">
                            <xsl:value-of
                                    select="translate($index-letter,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($string-before-index,$lower-index-letter,$string-after-index)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getPrintLinkRoot">
        <xsl:choose>
            <xsl:when test="/plcdata/header/applicationContextLocale = 'us'">
                <xsl:value-of select="/plcdata/header/applicationContextLocale"/>
            </xsl:when>
            <xsl:otherwise>www</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
