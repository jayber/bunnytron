<?xml version="1.0" encoding="utf-8"?>

<!-- CB modified Mar 2004
     addressline added
     
     CB modified Mar 2004
    major changes to text processing loic to encompass conjunctive/disjunctive clauses

    CB July 2004
    more conj/disj changes. SPlit into separate stylesheet
    
    CB Jan 2005
    changes for subclause1/title
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="conjunct_render.xsl"/>
    <xsl:import href="letterminutes.xsl"/>
    <xsl:import href="string-functions.xsl"/>


    <!-- SC 14/11/2008 - add support for different precedent jurisdictions and operative types -->

    <xsl:variable name="precedentNode"
                  select="plcdata/contentSection/contentBody/articleHolder/resourceContent/resource/xml/precedent"/>
    <xsl:variable name="operativeNode" select="$precedentNode/operative"/>
    <xsl:variable name="operativeType" select="$operativeNode/@properties"/>
    <xsl:variable name="precedentJurisdiction">
        <xsl:choose>
            <xsl:when test="$precedentNode/@jurisdiction">
                <xsl:value-of select="$precedentNode/@jurisdiction"/>
            </xsl:when>
            <xsl:when test="$operativeType = 'ussfa' or $operativeType = 'ussfawithtitles' or $operativeType = 'uslfa'">
                US
            </xsl:when>
        </xsl:choose>
    </xsl:variable>

    <!--
    ========================================================================
                              PRECEDENTS
    ========================================================================
    -->

    <!-- cb Aug 2008 - changes designed to enable CPSE coversheets to be displayed-->

    <xsl:template match="coversheet">
        <xsl:if test="@outputtype='printweb'">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="coversheet/title">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>

    <xsl:template match="coversheet/para">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <xsl:template match="intro">
        <xsl:variable name="introPrecedentType" select="$precedentNode/@precedenttype"/>
        <xsl:variable name="introtext">
            <xsl:value-of select="."/>
        </xsl:variable>
        <!--<xsl:if test="contains ($introtext,'HM Land')">YUUUU</xsl:if>-->
        <xsl:choose>
            <xsl:when test="contains($introtext,'HM Land')">
                <p>This
                    <xsl:value-of select="$introPrecedentType"/> is dated [DATE]
                </p>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="contains($introtext,'LR1')">
                <p>&#160;</p>
                <div class="boxNormal boxIntro">
                    <xsl:apply-templates/>
                </div>
                <p>This
                    <xsl:value-of select="$introPrecedentType"/> is dated [DATE]
                </p>
            </xsl:when>
            <xsl:when test="text()">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="para">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>This
                    <xsl:value-of select="$introPrecedentType"/> is dated [DATE]
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="precedentform/intro">
        <xsl:choose>
            <xsl:when test="text()">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="para">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>This
                    <xsl:value-of select="parent::precedentform/attribute::precedenttype"/> is dated
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="parties">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="recitals">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="operative">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="operativeinformal">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="clauseholder">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="clausegroup">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="testimonium">
        <xsl:variable name="precedentType" select="$precedentNode/@precedenttype"/>
        <xsl:choose>
            <xsl:when test="text()">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="para">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="section1">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="attribute::wording='contract'">
                <p>This
                    <xsl:value-of select="$precedentType"/> has been entered into on the date stated at the beginning of
                    it.
                </p>
            </xsl:when>
            <xsl:when test="attribute::wording='deed'">
                <p>This document has been executed as a deed and is delivered and takes effect on the date stated at the
                    beginning of it.
                </p>
            </xsl:when>
            <xsl:when test="attribute::wording='contractanddeed'">
                <p>This
                    <xsl:value-of select="$precedentType"/> has been entered into on the date stated at the beginning of
                    it.
                </p>
                <p>
                    <b>OR</b>
                </p>
                <p>This document has been executed as a deed and is delivered and takes effect on the date stated at the
                    beginning of it.
                </p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="para[parent::recitals]">
        <p>
            <xsl:number format="A. " count="para"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <!--
    ========================================================================
                              CLAUSE - SUBCLAUSE4
    ========================================================================
    -->

    <xsl:template match="clause">
        <!--<xsl:if test="self::node()[attribute::id]">
            <a>
                <xsl:attribute name="name"><xsl:value-of select="attribute::id"/></xsl:attribute>
            </a>
        </xsl:if>-->
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                    disable-output-escaping="yes">" id="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select="concat('clause', count(preceding-sibling::clause)+1)"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="subclause1">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="subclause2">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <div class="indented">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="subclause3">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <div class="indented">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="subclause4">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <div class="indented">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
    ========================================================================
                             PARA, at various levels
    ========================================================================
    -->

    <xsl:template match="para[parent::clauseholder][ancestor::miscdocument]">
        <p>
            <i>
                <xsl:apply-templates/>
            </i>
        </p>
    </xsl:template>

    <xsl:template
            match="para[parent::clause][not(preceding-sibling::para)][not(preceding-sibling::title)][not(ancestor::recitals)][not(ancestor::parties)]">
        <p>
            <xsl:if test="parent::clause/attribute::condition='optional'">
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                notes are used. this bracket has therefore been wrapped in a span -->
                <span>[</span>
            </xsl:if>
            <xsl:if test="not (parent::clause[@numbering='none'])">
                <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template
            match="para[parent::clause][not(preceding-sibling::para)][preceding-sibling::title][not(ancestor::recitals)][not(ancestor::parties)]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!--
<xsl:template match="para[parent::clause][not(preceding-sibling::para)][ancestor::parties]">
  <p><xsl:number format="(1)" count="clause"/> 
     <xsl:apply-templates />
  </p>
</xsl:template>
-->
    <xsl:template match="para[parent::clause/parent::recitals]">
        <p>
            <xsl:if test="(parent::clause/following-sibling::clause) or (parent::clause/preceding-sibling::clause)">
                <xsl:number format="(A) " count="clause"/>
            </xsl:if>
            <!--<ul style="list-style-type:none;">-->
            <xsl:if test="parent::clause/attribute::condition='optional'">
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                notes are used. this bracket has therefore been wrapped in a span -->
                <span>[</span>
            </xsl:if>
            <xsl:apply-templates/>
            <!--</ul>-->
        </p>
    </xsl:template>
    <xsl:template match="para[parent::clause][preceding-sibling::para]">
        <p>         <!--<ul style="list-style-type:none;">-->
            <xsl:apply-templates/>
            <!--</ul>-->
        </p>
    </xsl:template>
    <xsl:template match="para[parent::subclause1][not(preceding-sibling::para)]">
        <!-- add test to remove numbering for single subclause -->
        <!-- CB modified Jan 2005 -->
        <xsl:choose>
            <xsl:when test="(ancestor::*/attribute::properties='preservesubtitles') and (preceding-sibling::title)">
                <!-- supress numbering where preceding subclause1/title and set up to use them-->
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:if test="(parent::subclause1/preceding-sibling::subclause1) or (parent::subclause1/following-sibling::subclause1)">
                        <xsl:number level="multiple" format="1.1 "
                                    count="clause[not (attribute::numbering='none')]|subclause1"/>
                    </xsl:if>
                    <xsl:if test="parent::subclause1/attribute::condition='optional'">
                        <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                        notes are used. this bracket has therefore been wrapped in a span -->
                        <span>[</span>
                    </xsl:if>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>
    <xsl:template match="para[parent::subclause1][preceding-sibling::para]">
        <p>         <!--<ul style="list-style-type:none;">-->
            <xsl:apply-templates/>
            <!--</ul>-->
        </p>
    </xsl:template>
    <xsl:template match="para[parent::subclause2][not(preceding-sibling::para)]">
        <p>
            <xsl:number level="multiple" format="(a) " count="subclause2"/>
            <xsl:if test="parent::subclause2/attribute::condition='optional'">
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                notes are used. this bracket has therefore been wrapped in a span -->
                <span>[</span>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- added from dp's stylesheet -->
    <!-- This makes up for an omission in base xsl, whereby all paras in subclause 2 get numbered  -->
    <xsl:template match="para[parent::subclause2][preceding-sibling::para]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[parent::subclause3][not(preceding-sibling::para)]">
        <p>
            <xsl:number level="multiple" format="(i) " count="subclause3"/>
            <xsl:if test="parent::subclause3/attribute::condition='optional'">
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                notes are used. this bracket has therefore been wrapped in a span -->
                <span>[</span>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[parent::subclause3][preceding-sibling::para]">
        <p>        <!-- <ul style="list-style-type:none;">-->
            <xsl:apply-templates/>
            <!-- </ul>   -->
        </p>
    </xsl:template>
    <xsl:template match="para[parent::subclause4]">
        <p>
            <xsl:number level="multiple" format="(A) " count="subclause4"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- informaloperative para -->
    <xsl:template match="para[parent::operativeinformal]">
        <p>
            <xsl:number format="1. " count="para"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!--
    ========================================================================
                            OPTIONAL TEXT, at various levels
    ========================================================================
    -->

    <xsl:template match="text()[ancestor::precedent]">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()[ancestor::letter]">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()[ancestor::miscdocument]">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()[parent::title/parent::clause]">
        <xsl:variable name="pass0">
            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='.'/>
                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="$pass0"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()[parent::title/parent::intro]">
        <xsl:variable name="pass0">
            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='.'/>
                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="$pass0"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="text()[ancestor::clause][not (parent::title)]">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
            match="text()[(parent::title/parent::recitals) or (parent::title/parent::parties) or (parent::title/parent::operative) or (parent::title/parent::schedule)]">
        <xsl:variable name="pass0">
            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='.'/>
                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="$pass0"/>
        </xsl:call-template>
    </xsl:template>


    <!-- changed sc 26/06/2008 - ignore all text within a draftingnote when dealing with optionality, ensures the brackets render in the correct place -->
    <xsl:template
            match="text()[ancestor::*[attribute::condition='optional'][attribute::id]][(ancestor::precedent) or (ancestor::miscdocument) or (ancestor::schedule) or (ancestor::clause)][not(ancestor::draftingnote)]">
        <xsl:choose>
            <!-- convert clause/title to upper case -->
            <xsl:when test="(parent::title/parent::clause) or (parent::title/parent::schedule)">
                <xsl:variable name="pass0">
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert' select='.'/>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="parsetext">
                    <xsl:with-param name="this_string" select="$pass0"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="parsetext">
                    <xsl:with-param name="this_string" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <!-- sc 9/7/2008 - ignore text in tables to prevent closing optional bracket disappearing -->
        <!-- sc 9/7/2008 - optional brackets wrapped in spans to allow hiding when in notes only view -->
        <!-- sc 9/7/2008 - ignore empty text nodes in calculations and only render bracket after non-empty text node - stops whitespace destroying the rendering -->

        <!--test for subclause3 optional-->
        <xsl:if test="ancestor::subclause3[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s3id">
                <xsl:value-of select="ancestor::subclause3[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s31">
                <xsl:value-of
                        select="count(ancestor::subclause3[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s32">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::subclause3/attribute::id=$s3id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s31 = $s32 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for subclause2 optional-->
        <xsl:if test="ancestor::subclause2[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s2id">
                <xsl:value-of select="ancestor::subclause2[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s21">
                <xsl:value-of
                        select="count(ancestor::subclause2[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s22">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::subclause2/attribute::id=$s2id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s21 = $s22 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for subclause1 optional-->
        <xsl:if test="ancestor::subclause1[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::subclause1[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::subclause1[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::subclause1/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for recitals/clause optional-->
        <xsl:if test="ancestor::clause[attribute::condition='optional'][attribute::id]/parent::recitals">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::clause[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::clause[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::clause/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for schedule/clause/para optional-->
        <!-- changed sc 13/06/2008 - took out restriction of title element -->
        <!--<xsl:if test="ancestor::clause[not (title)][attribute::condition='optional'][attribute::id][not (parent::recitals)]">-->
        <xsl:if test="ancestor::clause[attribute::condition='optional'][attribute::id][not (parent::recitals)]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::clause[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::clause[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::clause/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for part optional - added sc 9/7/2008 -->
        <xsl:if test="ancestor::part[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::part[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::part[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::part/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for schedule optional - added sc 9/7/2008 -->
        <xsl:if test="ancestor::schedule[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::schedule[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::schedule[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::schedule/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for defitem optional - added sc 9/7/2008 -->
        <xsl:if test="ancestor::defitem[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::defitem[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::defitem[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::defitem/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>
        <!--test for appendix optional - added sc 9/7/2008 -->
        <xsl:if test="ancestor::appendix[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::appendix[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of
                        select="count(ancestor::appendix[attribute::condition='optional']//text()[not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of
                        select="count(preceding::text()[ancestor::appendix/attribute::id=$s1id][not(ancestor::draftingnote)][not(ancestor::table)][not(normalize-space(.)='')])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1 and not(normalize-space(.)='')">
                <span>]</span>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <!--<xsl:template match="text()[parent::para/parent::*[attribute::listtype='conjunctive']][ancestor::*[not (attribute::condition='optional')][attribute::id]][ancestor::precedent]">
    DDDD
    <xsl:call-template name="parsetext"><xsl:with-param name="strToParse"><xsl:value-of select="."/></xsl:with-param></xsl:call-template>
    </xsl:template>-->


    <!--
    ========================================================================
                            END OF OPTIONAL TEXT
    ========================================================================
    -->


    <xsl:template match="title[parent::clause]">
        <xsl:if test="count(preceding::title[parent::clause]) &gt; 0">
            <div class="inline-top-nav">
                <a href="#top" title="Link to the top of the document">Top</a>
            </div>
        </xsl:if>
        <h4>
            <xsl:if test="parent::clause[attribute::id]">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select="parent::clause/attribute::id"/><xsl:text disable-output-escaping="yes">" id="</xsl:text><xsl:value-of
                    select="parent::clause/attribute::id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:if>
            <xsl:if test="not (parent::clause/attribute::numbering='none')">
                <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            </xsl:if>
            <xsl:if test="parent::clause/attribute::condition='optional'">
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                 notes are used. this bracket has therefore been wrapped in a span -->
                <span>[</span>
            </xsl:if>
            <xsl:apply-templates/>
            <!-- sc 13/06/2008 - we don't want to show a bracket at the end of the title -->
            <!--<xsl:if test="parent::clause/attribute::condition='optional'">-->
            <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
            notes are used. this bracket has therefore been wrapped in a span -->
            <!--<span>]</span>
            </xsl:if>-->
        </h4>
    </xsl:template>

    <xsl:template match="title[parent::intro]">
        <h3>
            <xsl:if test="parent::intro[attribute::id]">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select="parent::intro/attribute::id"/><xsl:text disable-output-escaping="yes">" id="</xsl:text><xsl:value-of
                    select="parent::intro/attribute::id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="para[parent::clause/parent::signature]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="para[parent::def][ancestor::party][not(preceding-sibling::para)]">
        <span>
            <!--(<xsl:value-of select="count(preceding::party)+1"/>)-->
            <xsl:if test="ancestor::party/attribute::condition='optional'">[</xsl:if>
            <xsl:number format="(1) " count="party"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="para[preceding-sibling::para][parent::def/preceding-sibling::defterm][not (ancestor::party)]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- changed cb June 2004
    replaced (preceding-sibling::para) with (preceding-sibling::*) to cater for da structure -->

    <!-- changed sc 30 Jan 2007
    replaced [parent::def/preceding-sibling::defterm] with [parent::def/preceding-sibling::*[1][self::defterm]]
    to allow for drafting notes to appear after a defterm -->
    <xsl:template
            match="para[not (preceding-sibling::*)][parent::def/preceding-sibling::*[1][self::defterm]][not (ancestor::party)]">
        <!-- changed sc 24 May 2007 - this text now wrapped in a span - previously it was output as just text, meaning
        that if a drafting note was contained in the defitem it was impossible to hide the text and show the note, only both
        or neither could be shown. -->
        <span>
            <strong>:</strong>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- added sc 30 Jan 2007 -->
    <xsl:template
            match="para[not (preceding-sibling::*)][parent::def/preceding-sibling::*[1][self::draftingnote]][not (ancestor::party)]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="para[parent::def][not (parent::def/preceding-sibling::defterm)][not (ancestor::party)]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- added sc 31 May 2007 - drafting note fix. If multiple paras were inside a def, any other than the first (which is
    displayed inline with the defterm) would be output as text, with no containing element, meaning they couldn't be hidden.
    This wraps all paras in a def that aren't the first child in p tags -->
    <xsl:template
            match="para[parent::def][not(ancestor::party)][parent::def/preceding-sibling::defterm][preceding-sibling::*]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="defitems">
        <xsl:variable name="doSort">
            <xsl:value-of select="@sort"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($doSort, 'true')">
                <xsl:apply-templates select="defitem">
                    <xsl:sort select="defterm"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="defitem"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="defitem">
        <xsl:if test="@id">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select='@id'/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="attribute::condition='optional'">

                <!-- sc 19/02/07 - changed <p> to para-emulating <div> to allow legal insertion of block-level elements later in the
                stylesheet -->

                <!-- sc 11/06/2008 - if optional clauses do not contain a darfting note, give them an additional class on the paraDiv to allow
                it to be hidden in notes-only view -->
                <div>
                    <xsl:attribute name="class">paraDiv
                        <xsl:if test="not(descendant::draftingnote)">paraDivCollapsible</xsl:if>
                    </xsl:attribute>
                    <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                        notes are used. this bracket has therefore been wrapped in a span -->
                    <span>[</span>
                    <xsl:apply-templates/>
                    <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                        notes are used. this bracket has therefore been wrapped in a span -->

                    <!-- sc 9/7/2008 - moved to optional text rendering to bring in line with other ways of rendering optional text -->
                    <!--<span>]</span>-->
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:attribute name="class">paraDiv
                        <xsl:if test="not(descendant::draftingnote)">paraDivCollapsible</xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        <!-- add draftingnotes only if defitem is within a defitems tag (otherwise will appear twice) -->
        <xsl:apply-templates
                select="following-sibling::*[1][self::draftingnote and ancestor::defitems][not(ancestor::party)]"/>
    </xsl:template>

    <xsl:template match="defitem[parent::clause/following-sibling::clause][not(preceding-sibling::*)]">
        <xsl:if test="@id">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="@id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <p>
            <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            <xsl:apply-templates/>
            and
        </p>
    </xsl:template>
    <xsl:template
            match="defitem[parent::clause][not (parent::clause/following-sibling::clause)][not(preceding-sibling::*)]">
        <xsl:if test="@id">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="@id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <p>
            <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- cb changed 24 Feb 04 -->
    <xsl:template match="defitem[parent::subclause1][not(preceding-sibling::*)]">
        <p>
            <xsl:number level="multiple" format="1.1 " count="clause|subclause1"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="defterm[ancestor::party/following-sibling::party]">
        <!--(<b>
                  <xsl:apply-templates/>
              </b>).<xsl:if test="ancestor::party/attribute::condition='optional'">]</xsl:if>
      </xsl:template>
          <xsl:template match="defterm[ancestor::party][not(ancestor::party/following-sibling::party)]">
        (<b>
                  <xsl:apply-templates/>
              </b>).<xsl:if test="ancestor::party/attribute::condition='optional'">]</xsl:if>-->


        <!-- changed sc 31 May 2007 - wraps some stuff in  spans so that text can be hidden when viewing in notes only
        mode -->

        <span>(
            <b>
                <xsl:apply-templates/>
            </b>
            ).
            <xsl:if test="ancestor::party/attribute::condition='optional'">]</xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="defterm[ancestor::party][not(ancestor::party/following-sibling::party)]">
        <span>(
            <b>
                <xsl:apply-templates/>
            </b>
            ).
            <xsl:if test="ancestor::party/attribute::condition='optional'">]</xsl:if>
        </span>

    </xsl:template>
    <xsl:template match="defterm">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <!-- cb added 29/6/04 -->
    <!-- modified jan 06 - now we preserve it but only if the preserve attribute is set on the operative-->
    <xsl:template match="subclause1/title">
        <xsl:if test="ancestor::*/attribute::properties='preservesubtitles'">
            <h4>
                <!--<xsl:if test="parent::subclause1[attribute::id]">
                    <a>
                        <xsl:attribute name="name"><xsl:value-of select="parent::subclause1/attribute::id"/></xsl:attribute>
                        <xsl:attribute name="id"><xsl:value-of select="parent::subclause1/attribute::id"/></xsl:attribute>
                    </a>
                </xsl:if>-->
                <xsl:if test="not (ancestor::clause/attribute::numbering='none')">
                    <xsl:number level="multiple" format="1.1 "
                                count="clause[not (attribute::numbering='none')]|subclause1"/>
                </xsl:if>
                <!-- changed sc 13/06/2008 - this is testing for an optional clause, should be an optional subclause1 -->
                <!--<xsl:if test="parent::clause/attribute::condition='optional'">-->
                <xsl:if test="parent::subclause1/attribute::condition='optional'">
                    <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                     notes are used. this bracket has therefore been wrapped in a span -->
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
                <!-- changed sc 13/06/2008 - don't want to have a bracket after the title -->
                <!--<xsl:if test="parent::subclause1/attribute::condition='optional'">-->
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                notes are used. this bracket has therefore been wrapped in a span -->
                <!--<span>]</span>
                </xsl:if>-->
            </h4>

        </xsl:if>
    </xsl:template>

    <xsl:template
            match="parties/title|recitals/title|operativeinformal/title|clauseholder/title|heading/title|preamble/title|appendix/title">
        <xsl:if test="string-length(.) &gt; 0">
            <h3>
                <xsl:apply-templates/>
            </h3>
        </xsl:if>
    </xsl:template>

    <xsl:template match="operative/title">
        <xsl:text disable-output-escaping="yes">&lt;a name="title</xsl:text>
        <xsl:number format="1" count="title[not (attribute::numbering='none')]"/>
        <xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

        <xsl:if test="string-length(.) &gt; 0">
            <h3>
                <xsl:apply-templates/>
            </h3>
        </xsl:if>

    </xsl:template>
    <xsl:template match="schedule">
        <xsl:choose>
            <!--<xsl:when test="(not (title))">
            </xsl:when>--><!-- What is the point of this?? -->
            <xsl:when test="(following-sibling::schedule) or (preceding-sibling::schedule)">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                            select="attribute::id"/><xsl:text disable-output-escaping="yes">" id="</xsl:text><xsl:value-of
                            select="attribute::id"/><xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                            select="concat('schedule', count(preceding-sibling::schedule)+1)"/><xsl:text
                            disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <h3>
                    <!-- sc 9/7/2008 - added support for optional schedule -->
                    <xsl:if test="attribute::condition='optional'">
                        <span>[</span>
                    </xsl:if>
                    SCHEDULE
                    <xsl:number format="1" count="schedule"/>
                </h3>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                            select="attribute::id"/><xsl:text disable-output-escaping="yes">" id="</xsl:text><xsl:value-of
                            select="attribute::id"/><xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                            select="concat('schedule', count(preceding-sibling::schedule)+1)"/><xsl:text
                            disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <h3>
                    THE SCHEDULE
                </h3>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="appendix">
        <xsl:choose>
            <xsl:when test="(following-sibling::appendix) or (preceding-sibling::appendix)">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                <h3>
                    <xsl:if test="attribute::condition='optional'">
                        <span>[</span>
                    </xsl:if>
                    ANNEX
                    <xsl:number format="A" count="appendix"/>
                </h3>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
                <h3>
                    <xsl:if test="attribute::condition='optional'">
                        <span>[</span>
                    </xsl:if>
                    ANNEX
                </h3>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="part[@numbering='none']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="part">
        <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
            disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        <h4>
            <!-- sc 9/7/2008 - added support for optional part -->
            <xsl:if test="attribute::condition='optional'">
                <span>[</span>
            </xsl:if>
            PART
            <xsl:number format="1" count="part"/>
        </h4>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="title[parent::schedule]">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="title[parent::part]">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    <!-- This makes up for an omission in base xsl, whereby all paras in subclause 4 get numbered  -->
    <xsl:template match="para[parent::subclause4][preceding-sibling::para]">
        <p>
            <!--<ul style="list-style-type:none;">-->
            <xsl:apply-templates/>
            <!-- </ul>-->
        </p>
    </xsl:template>


    <!--
    ========================================================================
                           PARSE TEXT FUNCTION
                           From precedent preprocess
                           designed to deal with conjunctive disjunctive text logic
    ========================================================================
    -->

    <xsl:template name="parsetext">
        <xsl:param name="this_string"/>
        <!-- pass5 call convert-chars for other conversions -->
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="$this_string"/>
        </xsl:call-template>
    </xsl:template>


    <!--
    ========================================================================
                        DRAFTINGNOTE
    ========================================================================
    -->

    <!-- sc 11/7/2008 - moved id into parent element to improve positioning, updated hideshownote function as a result -->

    <xsl:template match="draftingnote">
        <xsl:variable name="dNoteId" select="generate-id()"/>

        <xsl:variable name="noteTitle">
            <xsl:if test="string-length(title) &gt; 0">
                <xsl:value-of select="title"/>
            </xsl:if>
            <xsl:if test="string-length(title) = 0 and string-length(parent::*/title) &gt; 0">
                <xsl:value-of select="parent::*/title"/>
            </xsl:if>
        </xsl:variable>

        <div class="draftingNote">
            <!--<div class="draftingNoteTop" onclick="hideShowNote('{$dNoteId}');">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select='$dNoteId'/>" id="<xsl:value-of select='$dNoteId'/>"<xsl:text disable-output-escaping="yes">>&lt;/a></xsl:text>
                <img class="dNoteImage" src="{$notesOnly.gif}"/>
                <a href="#null" id="{$dNoteId}note" class="selBut">Note</a>
                <span class="noteTitlePrint">Note</span>
            </div>-->
            <xsl:if test="attribute::id">
                <xsl:text disable-output-escaping="yes">&lt;a id="</xsl:text><xsl:value-of select="@id"/>" name="<xsl:value-of
                    select="@id"/><xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:if>
            <!--<div class="draftingNoteTop" onclick="hideShowNote(this.parentNode);">-->
            <div class="draftingNoteTop">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select='$dNoteId'/>"
                id="<xsl:value-of select='$dNoteId'/>"<xsl:text disable-output-escaping="yes">>&lt;/a></xsl:text>

                <a href="#null" id="{$dNoteId}note" class="selBut draftingNoteControlLink">
                    <span class="hiddenNoteText">Hide</span>
                    <!--<xsl:value-of select="title"/>-->Note
                    <xsl:if test="string-length($noteTitle) &gt; 0">
                        <span class="fullNoteTitle">:
                            <xsl:value-of select="$noteTitle"/>
                        </span>
                    </xsl:if>
                </a>
                <span class="noteTitlePrint">Note
                    <xsl:if test="string-length($noteTitle) &gt; 0">:
                        <xsl:value-of select="$noteTitle"/>
                    </xsl:if>
                </span>
            </div>

            <div class="docAndNotes" id="{$dNoteId}noteText">
                <xsl:choose>
                    <!-- sc 9/7/2008 - added support for getting numbering/title of party, parties, definitions and schedules -->
                    <xsl:when test="parent::parties">
                        <div class="noteTitle noteTitleIndex">
                            <xsl:value-of select="parent::*/title"/>:
                            <xsl:if test="string-length(title) &gt; 0">
                                <xsl:value-of select="title"/>
                            </xsl:if>
                        </div>
                    </xsl:when>
                    <xsl:when test="parent::party">
                        <div class="noteTitle noteTitleIndex">
                            Party
                            <xsl:number count="party[not(attribute::numbering='none')]"/>
                            <xsl:if test="string-length(title) &gt; 0">:
                                <xsl:value-of select="title"/>
                            </xsl:if>
                            <xsl:if test="not(string-length(title) &gt; 0)">
                                <xsl:if test="parent::*/title and string-length(parent::*/title) &gt; 0">:
                                    <xsl:value-of select="parent::*/title"/>
                                </xsl:if>
                            </xsl:if>
                        </div>
                        <xsl:if test="string-length(title) > 0">
                            <div class="noteTitle">
                                <xsl:value-of select="title"/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="ancestor::defitem or ancestor::defitems">
                        <div class="noteTitle noteTitleIndex">
                            Definition
                            <xsl:if test="string-length(title) &gt; 0">:
                                <xsl:value-of select="title"/>
                            </xsl:if>
                            <xsl:if test="not(string-length(title) &gt; 0)">
                                <xsl:if test="parent::*/title and string-length(parent::*/title) &gt; 0">:
                                    <xsl:value-of select="parent::*/title"/>
                                </xsl:if>
                            </xsl:if>
                        </div>
                        <xsl:if test="string-length(title) > 0">
                            <div class="noteTitle">
                                <xsl:value-of select="title"/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="ancestor::schedule">
                        <div class="noteTitle noteTitleIndex">

                            Schedule
                            <xsl:number count="schedule[not(attribute::numbering='none')]"/>
                            <xsl:if test="ancestor::part or ancestor::clause">,</xsl:if>
                            <xsl:if test="ancestor::part">Part
                                <xsl:number count="part[not(attribute::numbering='none')]"/>
                                <xsl:if test="ancestor::clause">,</xsl:if>
                            </xsl:if>
                            <xsl:if test="ancestor::clause">paragraph
                                <xsl:choose>
                                    <xsl:when test="parent::subclause2">
                                        <xsl:number format="1.1(a) " level="multiple"
                                                    count="clause[not(attribute::numbering='none')]|subclause1[not(attribute::numbering='none')]|subclause2[not(attribute::numbering='none')]"/>
                                    </xsl:when>
                                    <xsl:when test="parent::subclause3">
                                        <xsl:number format="1.1(a)(i) " level="multiple"
                                                    count="clause[not(attribute::numbering='none')]|subclause1[not(attribute::numbering='none')]|subclause2[not(attribute::numbering='none')]|subclause3[not(attribute::numbering='none')]"/>
                                    </xsl:when>
                                    <xsl:when test="parent::subclause4">
                                        <xsl:number format="1.1(a)(i)(A) " level="multiple"
                                                    count="clause[not(attribute::numbering='none')]|subclause1[not(attribute::numbering='none')]|subclause2[not(attribute::numbering='none')]|subclause3[not(attribute::numbering='none')]|subclause4[not(attribute::numbering='none')]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:number format="1.1 " level="multiple"
                                                    count="clause[not(attribute::numbering='none')]|subclause1[not(attribute::numbering='none')]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="string-length(title) > 0">:
                                <xsl:value-of select="title"/>
                            </xsl:if>
                            <xsl:if test="not(string-length(title) > 0)">
                                <xsl:if test="parent::*/title and string-length(parent::*/title) > 0">:
                                    <xsl:value-of select="parent::*/title"/>
                                </xsl:if>
                            </xsl:if>


                        </div>
                        <xsl:if test="string-length(title) > 0">
                            <div class="noteTitle">
                                <xsl:value-of select="title"/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="ancestor::recitals">
                        <xsl:if test="string-length(ancestor::recitals/title) &gt; 0 or ancestor::clause or string-length(title) &gt; 0">
                            <div class="noteTitle noteTitleIndex">
                                <xsl:if test="string-length(ancestor::recitals/title) &gt; 0"><xsl:value-of
                                        select="ancestor::recitals/title"/>:
                                </xsl:if>
                                <xsl:if test="ancestor::clause"><xsl:number
                                        count="clause[not(attribute::numbering='none')]"/>:
                                </xsl:if>
                                <xsl:value-of select="title"/>
                            </div>
                            <xsl:if test="string-length(title) > 0">
                                <div class="noteTitle">
                                    <xsl:value-of select="title"/>
                                </div>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when
                            test="parent::clause or parent::subclause1 or parent::subclause2 or parent::subclause3 or parent::subclause4">
                        <div class="noteTitle noteTitleIndex">
                            <xsl:choose>
                                <xsl:when test="parent::subclause4">
                                    <xsl:if test="ancestor::subclause1[@numbering='none']">
                                        <xsl:number level="multiple" format="1(a)(i)(A) "
                                                    count="clause[not (attribute::numbering='none')]|subclause1|subclause2|subclause3|subclause4"/>
                                    </xsl:if>
                                    <xsl:if test="not(ancestor::subclause1[@numbering='none'])">
                                        <xsl:number level="multiple" format="1.1(a)(i)(A) "
                                                    count="clause[not (attribute::numbering='none')]|subclause1|subclause2|subclause3|subclause4"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="parent::subclause3">
                                    <xsl:if test="ancestor::subclause1[@numbering='none']">
                                        <xsl:number level="multiple" format="1(a)(i) "
                                                    count="clause[not (attribute::numbering='none')]|subclause1|subclause2|subclause3"/>
                                    </xsl:if>
                                    <xsl:if test="not(ancestor::subclause1[@numbering='none'])">
                                        <xsl:number level="multiple" format="1.1(a)(i) "
                                                    count="clause[not (attribute::numbering='none')]|subclause1|subclause2|subclause3"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="parent::subclause2">
                                    <xsl:if test="not(ancestor::subclause1/preceding-sibling::subclause1) and not(ancestor::subclause1/following-sibling::subclause1)">
                                        <xsl:number level="multiple" format="1(a) "
                                                    count="clause[not (attribute::numbering='none')]|subclause2"/>
                                    </xsl:if>
                                    <xsl:if test="ancestor::subclause1/preceding-sibling::subclause1 or ancestor::subclause1/following-sibling::subclause1">
                                        <xsl:number level="multiple" format="1.1(a) "
                                                    count="clause[not (attribute::numbering='none')]|subclause1|subclause2"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="parent::subclause1">
                                    <xsl:number level="multiple" format="1.1 "
                                                count="clause[not (attribute::numbering='none')]|subclause1"/>
                                </xsl:when>
                                <!--cb 2/12/10 there was a problem with the previous rule here - the count function was always returning 0 so no numbering was
                               ever displayed on drafting note titles-->
                                <xsl:when test="parent::clause[not (attribute::numbering='none')]">
                                    <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="string-length(title) > 0">
                                <xsl:value-of select="title"/>
                            </xsl:if>
                            <xsl:if test="not(string-length(title) > 0)">
                                <xsl:if test="parent::*/title and string-length(parent::*/title) > 0">
                                    <xsl:value-of select="parent::*/title"/>
                                </xsl:if>
                            </xsl:if>
                        </div>
                        <xsl:if test="string-length(title) > 0">

                            <div class="noteTitle">
                                <xsl:value-of select="title"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="not(string-length(title) > 0)">
                            <xsl:if test="parent::*/title and string-length(parent::*/title) > 0">
                                <div class="noteTitle">
                                    <xsl:value-of select="parent::*/title"/>
                                </div>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string-length(title) > 0">
                            <div class="noteTitle">
                                <xsl:value-of select="title"/>
                            </div>
                            <div class="noteTitle noteTitleIndex">
                                <xsl:value-of select="title"/>
                            </div>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
                <!--<div class="draftingNoteTop draftingNoteClose" onclick="hideShowNote('{$dNoteId}', true);">
                    <img class="dNoteImage" src="{$notesOnly.gif}"/>
                    <a class="selBut" href="#null">Hide Note</a>
                </div>-->
                <!--<div class="draftingNoteClose" onclick="hideShowNote(this.parentNode.parentNode, '{$dNoteId}');">-->
                <div class="draftingNoteClose">

                    <a class="selBut draftingNoteControlLink" href="#null">Hide Note</a>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- note title is shown as part of the link, so is suppressed here -->
    <xsl:template match="draftingnote/title"/>


    <!--
    ========================================================================
                         OPTIONALITY STUBS
                         These do nothing
                         Added CB Oct 2004
    ========================================================================
    -->

    <xsl:template name="opSpanSta">
    </xsl:template>

    <xsl:template name="opSpanEnd">
    </xsl:template>


</xsl:stylesheet>