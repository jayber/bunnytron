<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
        >

    <!--

    ========================================================================
    VERSION 1.1.1

    Author: CB
    Date: August 2003
    Function: Pre-process of PLC Precedents before E3
        Insert firm style idioms

        DP - Added defitems sorting

     Jan 2004
     CB - 	added clauseholder/para rule
                changes to executiondb sub file
         -	new routine for coversheet position
        -	minor fix to optional logic

    Mar 2004
    CB - Clausegroup list logic
         - Small fix for clause at beginning of sentence
         - Change to right bracket conditional logic

    April 2004

    CB - Amended to allow 'floating' clausegroup/defitems
       - parameterized subclause1/title
       - Refactoring of executiondb.xsl

     May 2004

    v1.1.1 Bug fix for partydefterm delimiter
            Added schxrefcase variable

    June 2004

    Added logic so that appendix with no para children gets automatic para child (to avoid word generation problem)
    Small bug fix for party defterm (bug id 877)

    Changes for conjunctive/disjunctive for automation templates

    July 2004

    Implementation of minutes logic
    Added 2 part appendix heading
    Changed insert Heading2 logic so doesn't happen if only 1 subclause
    Changed execution to process authored clause children
    Changed logic to put in rudimentary coversheet when there isn't one

    August 2004

    Add facility to have blank para in table def

    ========================================================================
    -->

    <!--
    ========================================================================
                              SET UP FIRM STYLE PARAMS

    This is the generic template so they will be set to false

    partiestitle: parties/title text. If left blank, take from document
    recitalstitle: parties/title text. If left blank, take from document
    operativetitle: operative/title text. If left blank, take from document

    ltbracchar: replacement for [ if any
    rtbracchar: replacement for ] if any
    condtextelement: used to define element mark up for conditional text(default is emphasis role='conditional'
        note - not yet implemented
    includeinfo: do we include info page?
    includelogo: do we include logo?

    deftermlfdelim: definition term left delimiter (e.g. ')
    deftermrgdelim: definition term right delimiter (e.g. ')

    partydeftermlfdelim: party definition term left delimiter (e.g. ')
    partydeftermrgdelim: party definition term right delimiter (e.g. ')

    NB: These 2 have been added to deal with a situation where a firm might have a different format for
    party defterms. The default is that they take the valuf of the general defterm delimiter instead.

    deftablergdelim: definition table right delimiter (e.g. :)
    removeinlinedef: remove in line def entirely so styles as normal para text

    convertlargecurly: convert single apostrophe
    convertsmallcurly: convert double apostrophe

    partyincthe: do we add 'the' in front of party definition
    deftermdefpara: preceeding character for def/para following defterm (eg. : )
    removelaststop: do we remove full stop at the end of sentences?
    convertprectypecase: do we convert precedent type (e.g. contract) to upper case (when preceded by 'this')?
    displaydeftable: do we convert the defterms into a table?
    adddeftablespace: set to yes to add a blank para at the end of each def

    partypunct: punctuation at end of party clause (eg . or ;)
    partypenulpunct: puntuation at end of penultimate party clause (usually 'and' if used)

    testcontwording: wording for testimonium contract form
    testdeedwording: wording for testimonium deed form
    testdeedndwording: wording for testimonium deed form when precedent is not a deed

    schheading2part: do we create two separate headings for the schedule (i.e. Schedule 1;The Actual Heading)
    appheading2part: same for appendix
    sch2partcase: the heading case where heading is divided into 2 parts
    schuppercase: display sch heading in upper case.default is no (requires schheading2part to be set to yes to work)
    appuppercase: same with appendix
    schheadtype: Xrefs to schedules for word docuements - are they to the heading or clause number?
    schstartcolon: Start schedule title with : if yes
    partheadtype: same for schheadtype
    partheadingformat: if noautonumber then we need to insert the part title manually
    schxrefcase: schedule cross reference case; default is sentence


    clausetitcase: clause title case. lower|upper|proper|sentence

    defend: eg. laytons ends with ; note that this character is not added to the last def

    incxref: whether to include xref. default is yet. may at some point require a more sophisticated approach here
    usenbs: do we use non-breaking space? an additional level of complexity would be to define where we use it
    coverpos: use for setting position of coversheet(eg. at end)

    spacechar: either space or non-breaking space depending on the answer above

    the 3 conjunctive list variables equate to penultimate, last and not penultimate or last (there is a variant of
    the end v2 where the list is followed by a paragraph
    clmain
    clpp
    clend
    clendv2

    the 3 disjunctive list variables equate to penultimate, last and not penultimate or last

    dlmain
    dlpp
    dlend
    dlendv2

    clause/subclause1 titles
    3 levels:
    1) always remove
    2) leave if there
    3) put in some text if not there (e.g the Laytons Heading 2

    sub1title: remove|leave|insert
    sub1titletext:


    execution_columns: columns in the execution table. Will normally be 2
    NB: this presupposes all firms are going to use a table for this.

    sub2xref:1 or (i) (only required in word where there is no dynamic xref
    sub3xref:1 or (i) (only required in word where there is no dynamic xref


    ========================================================================
    -->

    <xsl:variable name="partiestitle"/>
    <xsl:variable name="recitalstitle"/>
    <xsl:variable name="operativetitle"/>

    <xsl:variable name="ltbracchar">[</xsl:variable>
    <xsl:variable name="rtbracchar">]</xsl:variable>
    <xsl:variable name="condtextelement">off</xsl:variable>

    <xsl:variable name="includeinfo">yes</xsl:variable>
    <xsl:variable name="includelogo">no</xsl:variable>

    <xsl:variable name="deftermlfdelim"></xsl:variable>
    <xsl:variable name="deftermrgdelim"></xsl:variable>
    <xsl:variable name="deftablergdelim"></xsl:variable>
    <xsl:variable name="removeinlinedef">no</xsl:variable>

    <xsl:variable name="partydeftermlfdelim">
        <xsl:value-of select="$deftermlfdelim"/>
    </xsl:variable>
    <xsl:variable name="partydeftermrgdelim">
        <xsl:value-of select="$deftermrgdelim"/>
    </xsl:variable>

    <xsl:variable name="convertlargecurly">no</xsl:variable>
    <xsl:variable name="convertsmallcurly">no</xsl:variable>

    <xsl:variable name="partyincthe">no</xsl:variable>
    <xsl:variable name="deftermdefpara">
        <emphasis role="bold">:</emphasis>
        <xsl:text> </xsl:text>
    </xsl:variable>
    <xsl:variable name="removelaststop">no</xsl:variable>
    <xsl:variable name="convertprectypecase">no</xsl:variable>
    <xsl:variable name="displaydeftable">no</xsl:variable>
    <xsl:variable name="adddeftablespace">no</xsl:variable>

    <xsl:variable name="partypunct">.</xsl:variable>
    <xsl:variable name="partypenulpunct"></xsl:variable>

    <xsl:variable name="testcontwording">
        <para/>
        <para>This
            <xsl:value-of select="$precedenttype"/> has been entered into on the date stated at the beginning of it.
        </para>
    </xsl:variable>
    <xsl:variable name="testdeedwording">
        <para/>
        <para>This document has been executed as a deed and is delivered and takes effect on the date stated at the
            beginning of it.
        </para>
    </xsl:variable>
    <xsl:variable name="testdeedndwording">
        <para/>
        <xsl:value-of select="$testdeedwording"/>
    </xsl:variable>

    <xsl:variable name="schheading2part">no</xsl:variable>
    <xsl:variable name="appheading2part">no</xsl:variable>
    <xsl:variable name="schuppercase">no</xsl:variable>
    <xsl:variable name="appuppercase">no</xsl:variable>
    <xsl:variable name="sch2partcase">leave</xsl:variable>
    <xsl:variable name="schheadtype">numbering</xsl:variable>
    <xsl:variable name="schstartcolon">yes</xsl:variable>
    <xsl:variable name="partheadtype">numbering</xsl:variable>
    <xsl:variable name="partheadingformat">autonumbering</xsl:variable>
    <xsl:variable name="schxrefcase">title</xsl:variable>

    <xsl:variable name="clausetitcase">leave</xsl:variable>

    <xsl:variable name="defend"></xsl:variable>

    <xsl:variable name="incxref">yes</xsl:variable>

    <xsl:variable name="usenbs">no</xsl:variable>
    <xsl:variable name="coverpos"></xsl:variable>
    <xsl:variable name="spacechar">
        <xsl:choose>
            <xsl:when test="$usenbs='yes'">&#160;</xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="execution_columns">2</xsl:variable>

    <xsl:variable name="sub1title">remove</xsl:variable>
    <xsl:variable name="sub1titletext"/>

    <xsl:variable name="sub2xref">1.1(a)</xsl:variable>
    <xsl:variable name="sub3xref">(i)</xsl:variable>


    <xsl:output method="xml"/>
    <!--<xsl:strip-space elements="*"/>-->


    <xsl:include href="executiondb.xsl"/>
    <xsl:include href="cbadds.xsl"/>
    <xsl:include href="string.xsl"/>
    <xsl:include href="numbering.xsl"/>
    <xsl:include href="conjunct_render.xsl"/>


    <!--
    ========================================================================
                              KEY FOR XREF
    ========================================================================
    -->

    <xsl:key name="xreflink"
             match="//clause|//subclause1|//defitem|//subclause2|//schedule|//part|//subclause3"
             use="@id"/>

    <xsl:param name="precedenttype">
        <xsl:value-of select="//precedent/metadata/precedenttype/plcxlink/xlink:locator"/>
    </xsl:param>
    <xsl:param name="precedenttypewhole">this
        <xsl:value-of select="$precedenttype"/>
    </xsl:param>

    <!--
    ========================================================================
                            GLOBAL VARIABLES
    ========================================================================
    -->

    <xsl:variable name="lcletters">
        abcdefghijklmnopqrstuvwxyz
    </xsl:variable>

    <xsl:variable name="ucletters">
        ABCDEFGHIJKLMNOPQRSTUVWXYZ
    </xsl:variable>

    <xsl:variable name="largequote">"</xsl:variable>
    <xsl:variable name="opencurly">&#x201c;</xsl:variable>
    <xsl:variable name="closecurly">&#x201d;</xsl:variable>

    <xsl:variable name="smallquote">'</xsl:variable>
    <xsl:variable name="openscurly">&#x2018;</xsl:variable>
    <xsl:variable name="closescurly">&#x2019;</xsl:variable>

    <xsl:template match="/precedent">
	<xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <precedent>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:if test="$coverpos='end'">
                <xsl:call-template name="makecoversheet"/>
            </xsl:if>
        </precedent>
    </xsl:template>

    <xsl:template match="/miscdocument">
	<xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <miscdocument>
            <xsl:apply-templates select="node()|@*"/>
        </miscdocument>
    </xsl:template>

    <xsl:template match="/schedule">
	<xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <schedule>
            <xsl:apply-templates select="node()|@*"/>
        </schedule>
    </xsl:template>

    <xsl:template match="/letter">
	<xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <letter>
            <xsl:apply-templates select="node()|@*"/>
        </letter>
    </xsl:template>

    <xsl:template match="/minutes">
	<xsl:text disable-output-escaping="yes">&lt;!-- Fragment document type declaration subset: ArborText, Inc., 1988-2001, v.4002
&lt;!DOCTYPE plc PUBLIC "Practical Law Company//DTD PLC Doctype//EN" "plc.dtd">--></xsl:text>
        <minutes>
            <xsl:apply-templates select="node()|@*"/>
        </minutes>
    </xsl:template>

    <xsl:template match="metadata[not (ancestor::schedule/parent::precedent)]">
        <xsl:if test="($includelogo='yes') or ($includeinfo='yes')">
            <xsl:call-template name="makemetadata"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="metadata[not (ancestor::schedule/parent::precedent)]">
        <xsl:if test="($includelogo='yes') or ($includeinfo='yes')">
            <xsl:call-template name="makemetadata"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="metadata[parent::miscdocument]">
        <xsl:if test="not (following-sibling::coversheet) and not (preceding::metadata)">
            <xsl:call-template name="makeskeletoncoversheet"/>
            <xsl:if test="not (following-sibling::toc) and not (following-sibling::intro) ">
                <intro>
                    <para/>
                </intro>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="makeskeletoncoversheet">
    </xsl:template>

    <xsl:template name="makemetadata">
        <metadata>
            <xsl:if test="$includelogo='yes'">
                <para>
                    <graphic fileref="\\Metro\e3_work\xml\output\frontlogo.tif"/>
                </para>
            </xsl:if>
            <abstract>
                <xsl:if test="$includeinfo='yes'">
                    <para>PLC Resource A<xsl:value-of select="resourceid"/>. Full name: <xsl:value-of select="title"/>.
                        <xsl:if test="draftingnote">Drafting note at A<xsl:value-of
                                select="draftingnote/plcxlink/xlink:locator/attribute::xlink:href"/>
                        </xsl:if>
                    </para>
                    <xsl:if test="not (contains (identifier,'Property'))">
                        <para>Law Date: <xsl:value-of select="datevalid"/>.
                        </para>
                    </xsl:if>
                </xsl:if>
            </abstract>
        </metadata>
    </xsl:template>

    <xsl:template match="clauseholder">
        <operative>
            <xsl:apply-templates/>
        </operative>
    </xsl:template>

    <xsl:template match="clausegroup">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="para[attribute::xml:space='preserve'][not (parent::def/preceding-sibling::defterm)]">
        <para xml:space="preserve"><xsl:apply-templates/><xsl:call-template name="checkjunctive"/></para>
    </xsl:template>

    <xsl:template match="para">
        <para>
            <xsl:apply-templates/>
            <xsl:call-template name="checkjunctive"/>
        </para>
    </xsl:template>

    <xsl:template match="clauseholder/para">
        <para/>
        <para>
            <emphasis role="italic">
                <xsl:apply-templates/>
            </emphasis>
        </para>
    </xsl:template>

    <xsl:template match="para[preceding-sibling::para][parent::def/preceding-sibling::defterm]">
        <para>
            <xsl:apply-templates/>
            <xsl:call-template name="checkjunctive"/>
        </para>
    </xsl:template>

    <xsl:template match="para[not (preceding-sibling::para)][parent::def/preceding-sibling::defterm]">
        <para>
            <xsl:copy-of select="$deftermdefpara"/>
            <xsl:apply-templates/>
            <xsl:call-template name="checkjunctive"/>
        </para>
    </xsl:template>

    <!--
    ========================================================================
                           TOC
    ========================================================================
    -->

    <xsl:template match="toc">
        <toc>
            <title>Contents</title>
            <subtitle>Clause</subtitle>
            <toccontents consistsof='operative'/>
            <!--<xsl:choose><xsl:when test="following-sibling::schedule/following-sibling::schedule">
            <subtitle>Schedules</subtitle><toccontents consistsof='schedule' /></xsl:when>-->
            <xsl:choose>
                <xsl:when test="following-sibling::schedule">
                    <subtitle>Schedule</subtitle>
                    <toccontents consistsof='schedule'/>
                </xsl:when>
            </xsl:choose>
        </toc>
        <xsl:if test="not (following-sibling::intro)">
            <intro>
                <para/>
            </intro>
        </xsl:if>
    </xsl:template>

    <!--
    ========================================================================
                           COVERSHEET
    ========================================================================
    -->

    <xsl:template match="coversheet">
        <xsl:call-template name="makecoversheet"/>
        <xsl:if test="not (following-sibling::toc) and not (following-sibling::intro)">
            <intro>
                <para/>
            </intro>
        </xsl:if>
    </xsl:template>

    <xsl:template name="makecoversheet">
        <coversheet>
            <title>Dated</title>
            <para>------------</para>
            <firmaddresstitle>
                <xsl:value-of select="title[1]"/>
            </firmaddresstitle>
            <xsl:if test="subjectintro">
                <para/>
                <para>
                    <xsl:value-of select="subjectintro"/>
                </para>
                <para/>
            </xsl:if>
            <xsl:for-each select="subjects/subjecttext">
                <firmaddresstitle>
                    <xsl:value-of select="."/>
                </firmaddresstitle>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="$precedenttype='instrument'">
                    <para>issued by</para>
                </xsl:when>
                <xsl:otherwise>
                    <para/>
                    <para>between</para>
                    <para/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="coverparties/title">
                <title>
                    <xsl:value-of select="."/>
                </title>
                <xsl:if test="following-sibling::title">
                    <xsl:if test="count(//coversheet/coverparties/title)&lt; 4">
                        <para></para>
                    </xsl:if>
                    <para>and</para>
                    <xsl:if test="count(//coversheet/coverparties/title)&lt; 4">
                        <para></para>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </coversheet>
    </xsl:template>

    <xsl:template match="schedule/title">
        <xsl:variable name="convstr">
            <xsl:choose>
                <xsl:when test="starts-with(.,'[')">
                    <xsl:value-of select="substring-after(.,'[')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$schheading2part='yes'">
                <!-- create 2 separate title elements here-->
                <title>
                    <xsl:choose>
                        <xsl:when test="(count (parent::schedule/parent::*/schedule) &lt; 2)">
                            <xsl:choose>
                                <xsl:when test="$schuppercase='yes'">THE SCHEDULE</xsl:when>
                                <xsl:otherwise>The Schedule</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$schuppercase='yes'">SCHEDULE</xsl:when>
                                <xsl:otherwise>Schedule</xsl:otherwise>
                            </xsl:choose>
                            <xsl:number level="multiple" format="1" count="schedule"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </title>
                <xsl:variable name="pass0">
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert' select='$convstr'/>
                        <xsl:with-param name='conversion'>
                            <xsl:value-of select="sch2partcase"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <title2>
                    <xsl:call-template name="parsetext">
                        <xsl:with-param name="strToParse">
                            <xsl:value-of select="$pass0"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </title2>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <!--<xsl:if test="$schstartcolon='yes'">: </xsl:if>-->
                    <xsl:if test="starts-with(.,'[')">[</xsl:if>
                    <!-- changed CB Jan 2004 - don't convert schedule title to lower case -->
                    <xsl:value-of select="$convstr"/>

                    <!--<xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'><xsl:value-of select="$convstr"/></xsl:with-param>
                        <xsl:with-param name='conversion'>sentence</xsl:with-param></xsl:call-template>-->
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="appendix[not(para)][not (clause)]">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <para/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="appendix/title">
        <xsl:variable name="convstr">
            <xsl:choose>
                <xsl:when test="starts-with(.,'[')">
                    <xsl:value-of select="substring-after(.,'[')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$appheading2part='yes'">
                <!-- create 2 separate title elements here-->
                <title>
                    <xsl:choose>
                        <xsl:when test="(count (parent::appendix/parent::*/appendix) &lt; 2)">
                            <xsl:choose>
                                <xsl:when test="$appuppercase='yes'">THE ANNEX</xsl:when>
                                <xsl:otherwise>The Annex</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$appuppercase='yes'">ANNEX</xsl:when>
                                <xsl:otherwise>Annex</xsl:otherwise>
                            </xsl:choose>
                            <xsl:number level="multiple" format="A" count="appendix"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </title>
                <xsl:variable name="pass0">
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert' select='$convstr'/>
                        <xsl:with-param name='conversion'>
                            <xsl:value-of select="app2partcase"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <title2>
                    <xsl:call-template name="parsetext">
                        <xsl:with-param name="strToParse">
                            <xsl:value-of select="$pass0"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </title2>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:if test="starts-with(.,'[')">[</xsl:if>
                    <xsl:value-of select="$convstr"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="part/title">
        <xsl:variable name="convstr">
            <xsl:choose>
                <xsl:when test="starts-with(.,'[')">
                    <xsl:value-of select="substring-after(.,'[')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:if test="starts-with(.,'[')">[</xsl:if>
            <xsl:if test="$partheadingformat='noautonumber'">Part
                <xsl:number level="multiple" format="I" count="part"/>
                <xsl:text> - </xsl:text>
            </xsl:if>
            <!-- cb changed Jan 2004; assuming that part/title will be set up in sentence case-->
            <xsl:variable name="pass0">
                <xsl:value-of select="$convstr"/>
                <!--<xsl:call-template name='convertcase'>
                    <xsl:with-param name='toconvert' select='$convstr' />
                    <xsl:with-param name='conversion'>sentence</xsl:with-param>
                </xsl:call-template>-->
            </xsl:variable>
            <xsl:call-template name="parsetext">
                <xsl:with-param name="strToParse">
                    <xsl:value-of select="$pass0"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <!--
    ========================================================================
                          DEFTERM
           Will need to set up delimiter if this has been defined (eg. apostrophes)
           Note that defterm is an inline element ie. can only contain text
    ========================================================================
    -->

    <xsl:template match="defitems[@sort='true']">
        <xsl:if test="($displaydeftable='yes')">
            <xsl:if test="parent::clauseholder">
                <xsl:text disable-output-escaping="yes">&lt;subclause1></xsl:text>
            </xsl:if>
<xsl:text disable-output-escaping="yes">&lt;table frame="none">
&lt;tgroup cols="2">
&lt;colspec colname="c1" colwidth="6cm"/>
&lt;colspec colname="c2" colwidth="9.5cm"/>
&lt;tbody></xsl:text>
        </xsl:if>
        <xsl:apply-templates select="defitem">
            <xsl:sort select="defterm"/>
        </xsl:apply-templates>
        <xsl:if test="($displaydeftable='yes')">
      <xsl:text disable-output-escaping="yes">
&lt;/tbody>
&lt;/tgroup>
&lt;/table>
</xsl:text>
            <xsl:if test="parent::clauseholder">
                <xsl:text disable-output-escaping="yes">&lt;/subclause1></xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="defitems">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="party/defitem/defterm">(
        <xsl:choose>
            <xsl:when test="$removeinlinedef!='yes'">
                <xsl:copy>
                    <xsl:value-of select="$partydeftermlfdelim"/>
                    <xsl:if test="$partyincthe='yes'">the</xsl:if>
                    <xsl:apply-templates/>
                    <xsl:value-of select="$partydeftermrgdelim"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$partydeftermlfdelim"/>
                <xsl:if test="$partyincthe='yes'">the</xsl:if>
                <xsl:apply-templates/>
                <xsl:value-of select="$partydeftermrgdelim"/>
            </xsl:otherwise>
        </xsl:choose>
        )
        <xsl:choose>
            <xsl:when
                    test="($partypenulpunct!='') and (ancestor::party/following-sibling::party) and not (ancestor::party/following-sibling::party/following-sibling::party)">
                <xsl:value-of select="$partypunct"/><xsl:value-of select="$partypenulpunct"/>
            </xsl:when>
            <xsl:when test="ancestor::party/following-sibling::party">
                <xsl:value-of select="$partypunct"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="($removelaststop!='yes')">.</xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ancestor::party/attribute::condition='optional'">
            <xsl:value-of select="$rtbracchar"/>
        </xsl:if>
    </xsl:template>

    <!-- changed cb 20.2.04; include schedule defitem as well -->
    <xsl:template match="operative//subclause1/defitem|schedule//subclause1/defitem">
        <xsl:choose>
            <xsl:when
                    test="($displaydeftable='yes') and not (preceding-sibling::defitem) and not (following-sibling::defitem) and (defterm/following-sibling::def)">
<xsl:text disable-output-escaping="yes">&lt;table frame="none">
&lt;tgroup cols="2">
&lt;colspec colname="c1" colwidth="6cm"/>
&lt;colspec colname="c2" colwidth="9.5cm"/>
&lt;tbody></xsl:text>
                <row rowsep="0">
                    <xsl:apply-templates/>
                </row>
<xsl:text disable-output-escaping="yes">
&lt;/tbody>
&lt;/tgroup>
&lt;/table>
</xsl:text>
            </xsl:when>
            <xsl:when
                    test="($displaydeftable='yes') and not (preceding-sibling::defitem) and (defterm/following-sibling::def)">
<xsl:text disable-output-escaping="yes">&lt;table frame="none">
&lt;tgroup cols="2">
&lt;colspec colname="c1" colwidth="6cm"/>
&lt;colspec colname="c2" colwidth="9.5cm"/>
&lt;tbody></xsl:text>
                <row rowsep="0">
                    <xsl:apply-templates/>
                </row>
            </xsl:when>
            <xsl:when
                    test="($displaydeftable='yes') and not (following-sibling::defitem) and (defterm/following-sibling::def)">
                <row rowsep="0">
                    <xsl:apply-templates/>
                </row>
<xsl:text disable-output-escaping="yes">
&lt;/tbody>
&lt;/tgroup>
&lt;/table>
</xsl:text>
            </xsl:when>
            <xsl:when test="($displaydeftable='yes') and (defterm/following-sibling::def)">
                <row rowsep="0">
                    <xsl:apply-templates/>
                </row>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
            match="operative//subclause1/defitems/defitem|clauseholder/defitems/defitem|schedule//subclause1/defitems/defitem">
        <xsl:choose>
            <xsl:when test="($displaydeftable='yes') and (defterm/following-sibling::def)">
                <row rowsep="0">
                    <xsl:apply-templates/>
                </row>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="party/defitem/def">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="ancestor::party/attribute::condition='optional'">
                <xsl:value-of select="$ltbracchar"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template
            match="operative//subclause1/defitem/def|clauseholder/defitems/defitem/def|operative//subclause1/defitems/defitem/def|schedule//subclause1/defitem/def|schedule//subclause1/defitems/defitem/def">
        <xsl:choose>
            <xsl:when test="($displaydeftable='yes') and (preceding-sibling::defterm)">
                <entry rowsep="0" colsep="0">
                    <xsl:copy>
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates/>
                    </xsl:copy>
                    <xsl:if test="$adddeftablespace='yes'">
                        <para></para>
                    </xsl:if>
                </entry>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="defterm">
        <xsl:choose>
            <xsl:when
                    test="($displaydeftable='yes') and ((./parent::defitem/ancestor::subclause1) or (./parent::defitem/parent::defitems/parent::clauseholder)) and (following-sibling::def)">
                <xsl:text disable-output-escaping="yes">&lt;entry rowsep="0" colsep="0"></xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- optional clause logic. display it before the defterm if we're not in table form, otherwise after it-->
        <xsl:if test="($displaydeftable!='yes') and (parent::defitem/attribute::condition='optional')">
            <xsl:value-of select="$ltbracchar"/>
        </xsl:if>
        <xsl:if test="($removeinlinedef!='yes')">
            <xsl:text disable-output-escaping="yes">&lt;defterm></xsl:text>
        </xsl:if>
        <xsl:if test="($displaydeftable='yes') and (parent::defitem/attribute::condition='optional')">
            <xsl:value-of select="$ltbracchar"/>
        </xsl:if>
        <xsl:apply-templates select="@*"/>
        <xsl:choose>
            <xsl:when test="$deftermlfdelim!='' or $deftermrgdelim!=''">
                <!-- need to deal with situation where item starts with brackets -->
                <xsl:choose>
                    <xsl:when test="(starts-with(.,'(')) and (')' = substring(., string-length(.),1))">
                        (<xsl:value-of select="$deftermlfdelim"/>
                        <xsl:call-template name="parsetext">
                            <xsl:with-param name="strToParse">
                                <xsl:value-of select="substring(.,2,string-length(.)-2)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$deftermrgdelim"/>)
                    </xsl:when>
                    <xsl:when test="(starts-with(.,'(')) and (').' = substring(., string-length(.),2))">
                        (<xsl:value-of select="$deftermlfdelim"/>
                        <xsl:call-template name="parsetext">
                            <xsl:with-param name="strToParse">
                                <xsl:value-of select="substring(.,2,string-length(.)-3)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$deftermrgdelim"/>).
                    </xsl:when>
                    <xsl:when test="(starts-with(.,'[')) and (']' = substring(., string-length(.),1))">
                        <xsl:value-of select="$ltbracchar"/><xsl:value-of select="$deftermlfdelim"/>
                        <xsl:call-template name="parsetext">
                            <xsl:with-param name="strToParse">
                                <xsl:value-of select="substring(.,2,string-length(.)-2)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$deftermrgdelim"/><xsl:value-of select="$ltbracchar"/>
                    </xsl:when>
                    <xsl:when test="(starts-with(.,'['))">
                        <xsl:value-of select="$ltbracchar"/><xsl:value-of select="$deftermlfdelim"/>
                        <xsl:call-template name="parsetext">
                            <xsl:with-param name="strToParse">
                                <xsl:value-of select="substring-after(.,'[')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$deftermrgdelim"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$deftermlfdelim"/>
                        <xsl:call-template name="parsetext">
                            <xsl:with-param name="strToParse">
                                <xsl:value-of select="."/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:value-of select="$deftermrgdelim"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$deftablergdelim!=''">
                <xsl:apply-templates/>
                <xsl:if test="($displaydeftable='yes') and (./parent::defitem/ancestor::subclause1)">
                    <xsl:value-of select="$deftablergdelim"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="($removeinlinedef!='yes')">
            <xsl:text disable-output-escaping="yes">&lt;/defterm></xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when
                    test="($displaydeftable='yes') and ((./parent::defitem/ancestor::subclause1) or (./parent::defitem/parent::defitems/parent::clauseholder))">
                <xsl:text disable-output-escaping="yes">&lt;/entry></xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--
    <xsl:template match="node()[not (self::text())][not (self::para)]|@*">
       <xsl:copy><xsl:apply-templates select="@*"/><xsl:apply-templates/></xsl:copy>
     </xsl:template>
     -->
    <!-- * instead of node() here to filter out comments and processing instructions, text matches are dealt in another template -->
    <xsl:template match="*|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
    ========================================================================
                           PARTIES
    ========================================================================
    -->

    <xsl:template match="parties/title">
        <title>
            <xsl:choose>
                <xsl:when test="$partiestitle=''">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$partiestitle"/>
                </xsl:otherwise>
            </xsl:choose>
        </title>
    </xsl:template>

    <!--
    ========================================================================
                           RECITALS
    ========================================================================
    -->

    <xsl:template match="recitals/title">
        <title>
            <xsl:choose>
                <xsl:when test="$recitalstitle=''">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$recitalstitle"/>
                </xsl:otherwise>
            </xsl:choose>
        </title>
    </xsl:template>

    <!--
    ========================================================================
                           OPERATIVE
    ========================================================================
    -->

    <xsl:template match="operative/title">
        <title>
            <xsl:choose>
                <xsl:when test="$operativetitle=''">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$operativetitle"/>
                </xsl:otherwise>
            </xsl:choose>
        </title>
    </xsl:template>

    <xsl:template match="operative/clause/title|schedule/clause/title">
        <title>
            <xsl:if test="parent::clause/attribute::condition='optional'">
                <xsl:value-of select="$ltbracchar"/>
            </xsl:if>

            <xsl:variable name="pass0">
                <xsl:choose>
                    <xsl:when test="$clausetitcase='leave'">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name='convertcase'>
                            <xsl:with-param name='toconvert'>
                                <xsl:value-of select="."/>
                            </xsl:with-param>
                            <xsl:with-param name='conversion'>
                                <xsl:value-of select="$clausetitcase"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="parsetext">
                <xsl:with-param name="strToParse">
                    <xsl:value-of select="$pass0"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:if test="not (following-sibling::node()) and (parent::clause/attribute::condition='optional')">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </title>
    </xsl:template>


    <!--
    ========================================================================
                          The  subclause {heading 2} rule
                          This has now been parameterized
    ========================================================================
    -->

    <xsl:template match="clause/subclause1">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <!-- don't have a heading 2 for the 2nd schedule form -->
                <xsl:when
                        test="(ancestor::schedule) and not (parent::clause/title) and (subclause2) and not (following-sibling::*)"></xsl:when>
                <xsl:when test="$sub1title='remove'"></xsl:when>
                <xsl:when test="$sub1title='leave'"></xsl:when>
                <xsl:when
                        test="($sub1title='insert') and not (title) and ((preceding-sibling::subclause1) or (following-sibling::subclause1))">
                    <title>
                        <xsl:value-of select="$sub1titletext"/>
                    </title>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="clause/subclause1/title">
        <xsl:choose>
            <xsl:when test="$sub1title='remove'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    ========================================================================
                           TEXT
    ========================================================================
    -->

    <xsl:template match="text()">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="strToParse">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!--
    ========================================================================
                           OPTIONAL TEXT CLOSING BRACKET
    ========================================================================
    -->

    <!--
    ========================================================================
                           OPTIONAL PARA LOGIC
    ========================================================================
    -->

    <xsl:template
            match="text()[ancestor::*[attribute::condition='optional'][attribute::id]][(ancestor::precedent) or (ancestor::miscdocument) or (ancestor::schedule)]">
        <!--test for subclause3 optional-->
        <xsl:if test="ancestor::subclause3[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s3id">
                <xsl:value-of select="ancestor::subclause3[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s31">
                <xsl:value-of select="count(ancestor::subclause3[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="s32">
                <xsl:value-of select="count(preceding::text()[ancestor::subclause3/attribute::id=$s3id])"/>
            </xsl:variable>
            <xsl:if test="$s32 = 0">
                <xsl:value-of select="$ltbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for subclause2 optional-->
        <xsl:if test="ancestor::subclause2[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s2id">
                <xsl:value-of select="ancestor::subclause2[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s21">
                <xsl:value-of select="count(ancestor::subclause2[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="s22">
                <xsl:value-of select="count(preceding::text()[ancestor::subclause2/attribute::id=$s2id])"/>
            </xsl:variable>
            <xsl:if test="$s22 = 0">
                <xsl:value-of select="$ltbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for subclause1 optional-->
        <xsl:if test="ancestor::subclause1[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::subclause1[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of select="count(ancestor::subclause1[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of select="count(preceding::text()[ancestor::subclause1/attribute::id=$s1id])"/>
            </xsl:variable>
            <xsl:if test="$s12 = 0">
                <xsl:value-of select="$ltbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for clause optional-->
        <xsl:if test="ancestor::clause[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="cid">
                <xsl:value-of select="ancestor::clause[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="c1">
                <xsl:value-of select="count(ancestor::clause[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="c2">
                <xsl:value-of select="count(preceding::text()[ancestor::clause/attribute::id=$cid])"/>
            </xsl:variable>
            <xsl:if test="$c2 = 0">
                <xsl:value-of select="$ltbracchar"/>
            </xsl:if>
        </xsl:if>
        <xsl:call-template name="parsetext">
            <xsl:with-param name="strToParse">
                <xsl:value-of select="."/>
            </xsl:with-param>
        </xsl:call-template>

        <!--test for subclause3 optional-->
        <xsl:if test="ancestor::subclause3[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s3id">
                <xsl:value-of select="ancestor::subclause3[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s31">
                <xsl:value-of select="count(ancestor::subclause3[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="s32">
                <xsl:value-of select="count(preceding::text()[ancestor::subclause3/attribute::id=$s3id])"/>
            </xsl:variable>
            <xsl:if test="$s31 = $s32 + 1">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for subclause2 optional-->
        <xsl:if test="ancestor::subclause2[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s2id">
                <xsl:value-of select="ancestor::subclause2[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s21">
                <xsl:value-of select="count(ancestor::subclause2[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="s22">
                <xsl:value-of select="count(preceding::text()[ancestor::subclause2/attribute::id=$s2id])"/>
            </xsl:variable>
            <xsl:if test="$s21 = $s22 + 1">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for subclause1 optional-->
        <xsl:if test="ancestor::subclause1[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="s1id">
                <xsl:value-of select="ancestor::subclause1[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="s11">
                <xsl:value-of select="count(ancestor::subclause1[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="s12">
                <xsl:value-of select="count(preceding::text()[ancestor::subclause1/attribute::id=$s1id])"/>
            </xsl:variable>
            <xsl:if test="$s11 = $s12 + 1">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for clause1 optional-->
        <xsl:if test="ancestor::clause[attribute::condition='optional'][attribute::id][not (parent::recitals)]">
            <xsl:variable name="cid">
                <xsl:value-of select="ancestor::clause[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="c1">
                <xsl:value-of select="count(ancestor::clause[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="c2">
                <xsl:value-of select="count(preceding::text()[ancestor::clause/attribute::id=$cid])"/>
            </xsl:variable>
            <xsl:if test="$c1 = $c2 + 1">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for defitem optional-->
        <xsl:if test="ancestor::defitem[attribute::condition='optional'][attribute::id]">
            <xsl:variable name="did">
                <xsl:value-of select="ancestor::defitem[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="d1">
                <xsl:value-of select="count(ancestor::defitem[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="d2">
                <xsl:value-of select="count(preceding::text()[ancestor::defitem/attribute::id=$did])"/>
            </xsl:variable>
            <xsl:if test="$d1 = $d2 + 1">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for recitals/clause optional-->
        <xsl:if test="ancestor::clause[attribute::condition='optional'][attribute::id]/parent::recitals">
            <xsl:variable name="rcid">
                <xsl:value-of select="ancestor::clause[attribute::condition='optional']/attribute::id"/>
            </xsl:variable>
            <xsl:variable name="rc1">
                <xsl:value-of select="count(ancestor::clause[attribute::condition='optional']//text())"/>
            </xsl:variable>
            <xsl:variable name="rc2">
                <xsl:value-of select="count(preceding::text()[ancestor::clause/attribute::id=$rcid])"/>
            </xsl:variable>
            <xsl:if test="$rc1 = $rc2 + 1">
                <xsl:value-of select="$rtbracchar"/>
            </xsl:if>
        </xsl:if>
        <!--test for schedule/clause/para optional-->
        <!-- cb amended May 2004 don't see why we need this block - surely caught by clause rule above?-->
        <!--
        <xsl:if test="ancestor::clause[not (title)][attribute::condition='optional'][attribute::id]/parent::schedule">
            <xsl:variable name="s1id"><xsl:value-of select="ancestor::clause[attribute::condition='optional']/attribute::id"/></xsl:variable>
            <xsl:variable name="s11"><xsl:value-of select="count(ancestor::clause[attribute::condition='optional']//text())"/></xsl:variable>
            <xsl:variable name="s12"><xsl:value-of select="count(preceding::text()[ancestor::clause/attribute::id=$s1id])"/></xsl:variable>
            <xsl:if test="$s11 = $s12 + 1"><xsl:value-of select="$rtbracchar"/></xsl:if>
        </xsl:if>-->
    </xsl:template>

    <!--
    ========================================================================
                           PARSE TEXT FUNCTION
                           Generic text handling
    ========================================================================
    -->

    <xsl:template name="parsetext">
        <xsl:param name="strToParse"/>
        <!-- pass1 converts double quotes to curlies -->
        <xsl:variable name="pass1">
            <xsl:choose>
                <xsl:when test="$convertlargecurly='yes'">
                    <xsl:call-template name="convertToCurlies">
                        <xsl:with-param name="currentquote">
                            <xsl:value-of select="$largequote"/>
                        </xsl:with-param>
                        <xsl:with-param name="tochange" select="$strToParse"/>
                        <xsl:with-param name="nextquote">
                            <xsl:value-of select="$opencurly"/>
                        </xsl:with-param>
                        <xsl:with-param name="afterquote">
                            <xsl:value-of select="$closecurly"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$strToParse"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- pass2 converts single quotes to curlies -->

        <xsl:variable name="pass2">
            <xsl:choose>
                <xsl:when test="$convertsmallcurly='yes'">
                    <xsl:call-template name="convertToCurlies">
                        <xsl:with-param name="currentquote">
                            <xsl:value-of select="$smallquote"/>
                        </xsl:with-param>
                        <xsl:with-param name="tochange" select="$pass1"/>
                        <xsl:with-param name="nextquote">
                            <xsl:value-of select="$openscurly"/>
                        </xsl:with-param>
                        <xsl:with-param name="afterquote">
                            <xsl:value-of select="$closescurly"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pass1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- take off last full stop if required-->

        <xsl:variable name="pass3">
            <xsl:choose>
                <xsl:when test="($removelaststop='yes') and ('.' = substring($pass2, string-length($pass2)))">
                    <xsl:value-of select="substring($pass2,0,string-length($pass2))"/>
                    <xsl:if test="($defend!='') and (parent::para/parent::def/parent::defitem/following-sibling::defitem)">
                        <xsl:value-of select="$defend"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when
                        test="($removelaststop='yes') and ((']' = substring($pass2, string-length($pass2)))   and ('.' = substring($pass2, string-length($pass2)-1,1))   )">
                    <xsl:value-of select="substring($pass2,0,string-length($pass2)-1)"/><xsl:value-of
                        select="substring($pass2,string-length($pass2))"/>
                    <xsl:if test="($defend!='') and (parent::para/parent::def/parent::defitem/following-sibling::defitem)">
                        <xsl:value-of select="$defend"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when
                        test="($defend!='') and (parent::para/parent::def/parent::defitem/following-sibling::defitem) and ('.' = substring($pass2, string-length($pass2)))">
                    <xsl:value-of select="substring($pass2,0,string-length($pass2))"/><xsl:value-of select="$defend"/>
                </xsl:when>
                <xsl:when
                        test="($defend!='') and (parent::para/parent::def/parent::defitem/following-sibling::defitem) and ((']' = substring($pass2, string-length($pass2)))   and ('.' = substring($pass2, string-length($pass2)-1,1))   )">
                    <xsl:value-of select="substring($pass2,0,string-length($pass2)-1)"/><xsl:value-of
                        select="substring($pass2,string-length($pass2))"/><xsl:value-of select="$defend"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pass2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- convert precedent type to uc if required-->

        <xsl:variable name="pass4">
            <xsl:choose>
                <xsl:when test="($convertprectypecase='yes') and (contains($pass3,$precedenttypewhole))">
                    <xsl:call-template name="convert-prectype">
                        <xsl:with-param name="this_string" select="$pass3"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pass3"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- final pass call convert-chars for other conversions -->
        <xsl:call-template name="convert-chars">
            <xsl:with-param name="this_string" select="$pass4"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="convert-prectype">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="(contains ($this_string, $precedenttypewhole))">
                <xsl:call-template name="convert-prectype">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, $precedenttypewhole)"/>
                </xsl:call-template>
                this
                <xsl:value-of select="translate(substring($precedenttype,1,1),$lcletters,$ucletters)"/><xsl:value-of
                    select="substring($precedenttype,2,string-length($precedenttype)-1)"/>
                <xsl:call-template name="convert-prectype">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, $precedenttypewhole)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="convert-chars">
        <xsl:param name="this_string"/>
        <xsl:choose>
            <xsl:when test="(contains ($this_string, '[')) and ($ltbracchar!='')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, '[')"/>
                </xsl:call-template>
                <xsl:value-of select="$ltbracchar"/>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, '[')"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="(contains ($this_string, ']')) and ($rtbracchar!='')">
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-before ($this_string, ']')"/>
                </xsl:call-template>
                <xsl:value-of select="$rtbracchar"/>
                <xsl:call-template name="convert-chars">
                    <xsl:with-param name="this_string" select="substring-after ($this_string, ']')"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
    ========================================================================
                           CONVERT CURLIES
    ========================================================================
    -->


    <!--
    Converts straight quotes to curly quotes
    ie
    test "test" test
    gets converted to:
    test &#x201c;test&#x201d; test

    Added variables to top of stylesheet:	quote, containing the quote symbol
                        opencurly, containing the open curly quote
                        closecurly containing the close curly quote

    $tochange is the text to convert
    $nextquote will be the value of the opening quote - pass the $opencurly variable when calling the template
    $afterquote will be the value of the closing quote - pass the $closecurly variable when calling the template

    e.g.

    <xsl:call-template name="convertToCurlies">
        <xsl:with-param name="tochange">This is "some" text.</xsl:with-param>
        <xsl:with-param name="nextquote"><xsl:value-of select="$opencurly" /></xsl:with-param>
        <xsl:with-param name="afterquote"><xsl:value-of select="$closecurly" /></xsl:with-param>
    </xsl:call-template>

    -->
    <xsl:template name='convertToCurlies'>
        <xsl:param name='currentquote'/>
        <xsl:param name='tochange'/>
        <xsl:param name='nextquote'/>
        <xsl:param name='afterquote'/>
        <xsl:choose>
            <xsl:when test="contains($tochange, $currentquote)">
                <xsl:value-of select="substring-before($tochange, $currentquote)"/>
                <!-- cb amended Mar03 always change 's to small curly s -->
                <xsl:choose>
                    <xsl:when
                            test="(starts-with((substring-after($tochange,$currentquote)),'s')) and ($nextquote='&#x2018;')">
                        <xsl:value-of select="$afterquote"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$nextquote"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="convertToCurlies">
                    <xsl:with-param name="currentquote">
                        <xsl:value-of select="$currentquote"/>
                    </xsl:with-param>
                    <xsl:with-param name="tochange">
                        <xsl:value-of select="substring-after($tochange, $currentquote)"/>
                    </xsl:with-param>
                    <xsl:with-param name="nextquote">
                        <xsl:value-of select="$afterquote"/>
                    </xsl:with-param>
                    <xsl:with-param name="afterquote">
                        <xsl:value-of select="$nextquote"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$tochange"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
    ========================================================================
                          CLAUSEGROUP LOGIC
    ========================================================================
    -->


    <!--
    ========================================================================
                           LINKS
    ========================================================================
    -->

    <xsl:template match="plcxlink[descendant::xref]">
        <xsl:choose>
            <xsl:when test="$incxref='yes'">
                <xsl:variable name="xrefnode" select="key('xreflink', xlink:locator/xref/attribute::link)"/>
                <xsl:variable name="xrefname" select="name($xrefnode)"/>
                <xsl:choose>
                    <xsl:when
                            test="($xrefnode/ancestor::schedule) and (($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2'))">
                        paragraph<xsl:value-of select="$spacechar"/>
                    </xsl:when>
                    <xsl:when
                            test="(($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2')) and not (ancestor::subclause2) and not ((preceding-sibling::*) or (preceding-sibling::text()))">
                        Clause<xsl:value-of select="$spacechar"/>
                    </xsl:when>
                    <xsl:when
                            test="($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2') or ($xrefname='subclause3')">
                        clause<xsl:value-of select="$spacechar"/>
                    </xsl:when>
                    <xsl:when
                            test="($xrefname='schedule') and (ancestor::operative) and (count (ancestor::operative/following-sibling::schedule) &lt; 2) and ($schheadtype!='heading')">
                        the<xsl:value-of select="$spacechar"/>
                    </xsl:when>
                    <xsl:when
                            test="($xrefname='schedule') and (ancestor::parties) and (count (ancestor::parties/following-sibling::schedule) &lt; 2) and ($schheadtype!='heading')">
                        the<xsl:value-of select="$spacechar"/>
                    </xsl:when>
                    <xsl:when
                            test="($xrefname='schedule') and (ancestor::recitals) and (count (ancestor::recitals/following-sibling::schedule) &lt; 2) and ($schheadtype!='heading')">
                        the<xsl:value-of select="$spacechar"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:if test="(($xrefname='schedule') and ($schheadtype='heading')) or (($xrefname='part') and ($partheadtype='heading'))">
                        <xsl:attribute name="wordlinkinfo">heading</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="(($xrefname='subclause2') and ($xrefnode/parent::def))">
                        <xsl:attribute name="wordlinkinfo">defsubclause2</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xlink:locator">
        <xsl:choose>
            <xsl:when test="$incxref='yes'">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="xref"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xref">
        <xsl:choose>
            <xsl:when test="$incxref='yes'">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="insertxref"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- copied from plcdtd2xhtml -->
    <xsl:template name="insertxref">
        <xsl:variable name="xrefnode" select="key('xreflink', attribute::link)"/>
        <xsl:variable name="xrefname" select="name($xrefnode)"/>
        <xsl:choose>
            <xsl:when test="$xrefname='clause'">clause</xsl:when>
            <xsl:when test="$xrefname='subclause1'">clause</xsl:when>
            <xsl:when test="$xrefname='subclause2'">clause</xsl:when>
            <xsl:when test="$xrefname='schedule' and (count(ancestor::precedent/schedule) &lt; 2)">the Schedule
            </xsl:when>
            <xsl:when test="$xrefname='schedule'">
                <xsl:choose>
                    <xsl:when test="$schxrefcase='lower'">schedule</xsl:when>
                    <xsl:otherwise>Schedule</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$xrefname='part'">Part</xsl:when>
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
            <xsl:when test="$xrefname='subclause2'">
                <xsl:call-template name="firstSubclause2ParaNum">
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
            <xsl:when test="$xrefname='schedule'">
                <xsl:call-template name="firstScheduleParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='part'">
                <xsl:call-template name="firstPartParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--
    ========================================================================
                           LETTER DTD FUNCTIONS
    ========================================================================
    -->

    <xsl:template match="salutation">
        <para/>
        <para>
            <xsl:apply-templates/>
        </para>
    </xsl:template>

    <xsl:template match="letterhead[ancestor::letter]">
        <para/>
        <para>
            <emphasis role="italic">[On headed notepaper of <xsl:value-of select="attribute::partyhead"/>]
            </emphasis>
        </para>
        <para/>
    </xsl:template>

    <xsl:template match="addressline">
        <para>
            <xsl:apply-templates/>
        </para>
    </xsl:template>

    <xsl:template match="date">
        <para/>
        <xsl:choose>
            <xsl:when test="text()|*">
                <para>
                    <xsl:apply-templates/>
                </para>
            </xsl:when>
            <xsl:otherwise>
                <para>200[]</para>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="sincerely">
        <xsl:choose>
            <xsl:when test="text()|*">
                <para/>
                <para>
                    <xsl:apply-templates/>
                </para>
            </xsl:when>
            <xsl:otherwise>
                <para/>
                <para>Yours faithfully,</para>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    ========================================================================
                          MINUTES DTD FUNCTIONS
    ========================================================================
    -->

    <xsl:template match="minuteheader">
        <para>MINUTES of a Meeting of the Board of Directors of the [NAME OF COMPANY] (Company) held at [] on [],20 at
            am/pm.
        </para>
    </xsl:template>

    <xsl:template match="attendance">
        <para>
            <table frame="none" pgwide="1" tabstyle="tableShade">
                <tgroup cols="3">
                    <colspec colname='c1'/>
                    <colspec colname='c2'/>
                    <colspec colname='c3'/>
                    <tbody>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">PRESENT:</emphasis>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">NAME</emphasis>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">POSITION</emphasis>
                                </para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">IN ATTENDANCE:</emphasis>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">NAME</emphasis>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">POSITION</emphasis>
                                </para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                        </row>
                        <row rowsep="0">
                            <entry colsep="0" rowsep="0">
                                <para>
                                    <emphasis role="bold">[APOLOGIES FOR ABSENCE RECEIVED FROM:</emphasis>
                                </para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................</para>
                            </entry>
                            <entry colsep="0" rowsep="0">
                                <para>................................
                                    <emphasis role="bold">]</emphasis>
                                </para>
                            </entry>
                        </row>
                    </tbody>
                </tgroup>
            </table>
        </para>
    </xsl:template>


    <!--
    ========================================================================
                           CONVERT CASE FUNCTIONS
    ========================================================================
    -->

    <xsl:template name='convertcase'>
        <xsl:param name='toconvert'/>
        <xsl:param name='conversion'/>
        <xsl:choose>
            <xsl:when test='$conversion="lower"'>
                <xsl:value-of
                        select="translate($toconvert,$ucletters,$lcletters)"/>
            </xsl:when>

            <xsl:when test='$conversion="upper"'>
                <xsl:value-of
                        select="translate($toconvert,$lcletters,$ucletters)"/>
            </xsl:when>

            <xsl:when test='$conversion="sentence"'>
                <xsl:value-of
                        select="translate(substring($toconvert,1,1),$lcletters,$ucletters)"/>
                <xsl:value-of
                        select="translate(substring($toconvert,2,string-length($toconvert)-1),$ucletters,$lcletters)"/>
            </xsl:when>

            <xsl:when test='$conversion="proper"'>
                <xsl:call-template name='convertpropercase'>
                    <xsl:with-param name='toconvert'>
                        <xsl:value-of
                                select="$toconvert"/>
                    </xsl:with-param>
                    <!--<xsl:value-of
                    select="translate($toconvert,$ucletters,$lcletters)" />-->
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select='$toconvert'/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name='convertpropercase'>
        <xsl:param name='toconvert'/>

        <xsl:if test="string-length($toconvert) > 0">
            <xsl:variable name='f'
                          select='substring($toconvert, 1, 1)'/>

            <xsl:variable name='s' select='substring($toconvert, 2)'/>

            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='$f'/>

                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>

            <xsl:choose>
                <xsl:when test="contains($s,' ')">
                    <xsl:value-of select='substring-before($s," ")'/>
                    <xsl:text> </xsl:text>

                    <xsl:call-template name='convertpropercase'>
                        <xsl:with-param name='toconvert'
                                        select='substring-after($s," ")'/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select='$s'/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>