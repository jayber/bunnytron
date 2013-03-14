<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <!-- sc 23/10/2008 - if its in a defitem, add a trailing space so it doesn't run into the following para -->
    <xsl:template match="defterm[ancestor::precedent/@jurisdiction='US']">
        <b>"<xsl:apply-templates/>"
            <xsl:if test="parent::defitem">&#160;</xsl:if>
        </b>
    </xsl:template>

    <xsl:template match="para[parent::preamble and ancestor::precedent/@jurisdiction='US']">
        <p>
            <span class="indentSpacer">&#160;</span>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template
            match="para[parent::def and ancestor::party and not(preceding-sibling::para) and ancestor::precedent/@jurisdiction='US']">
        <p>
            <span class="indentSpacer">&#160;</span>
            <xsl:if test="ancestor::party/attribute::condition='optional'">[</xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template
            match="para[parent::clause and not(preceding-sibling::para) and ancestor::precedent/@jurisdiction='US']">
        <p>
            <xsl:variable name="parentClause" select="parent::clause"/>
            <!-- sc 17/10/2008 - ignore numbering if this is a recital in an lfa -->
            <!-- sc 23/10/2008 - ignore numbering in all cases in an lfa - handled by the "ARTICLE I" text -->
            <!--<xsl:if test="parent::clause[@numbering='none'] ">-->
            <xsl:if test="$parentClause/@numbering='none' or ($operativeType = 'uslfa' and not(ancestor::schedule))">
                <span class="indentSpacer">&#160;</span>
            </xsl:if>
            <!--<ul style="list-style-type:none;">-->
            <xsl:if test="not ($parentClause/@numbering='none') and (not($operativeType='uslfa') or ancestor::schedule)">
                <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            </xsl:if>
            <xsl:if test="$operativeType = 'ussfa' and not(ancestor::schedule)">
                <span class="indentSpacer">&#160;</span>
            </xsl:if>
            <xsl:if test="$parentClause/@condition='optional'">
                <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                notes are used. this bracket has therefore been wrapped in a span -->
                <span>[</span>
            </xsl:if>
            <xsl:apply-templates/>
            <!--</ul>-->
        </p>
    </xsl:template>

    <xsl:template
            match="para[parent::clause and not(preceding-sibling::para) and ancestor::operative/@properties='uslfa' and parent::clause/subclause1]">
        <p>
            <span class="indentSpacer">&#160;</span>
            <xsl:if test="parent::clause/attribute::condition='optional'">
                <span>[</span>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="para[parent::clause/parent::signature and ancestor::precedent/@jurisdiction='US']">
        <p>
            <!--(<xsl:value-of select="count(preceding::party)+1"/>)-->
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template
            match="para[parent::subclause1 and not(preceding-sibling::para) and ancestor::precedent/@jurisdiction='US']">
        <!-- add test to remove numbering for single subclause -->
        <!-- CB modified Jan 2005 -->

        <xsl:variable name="parentSubclause1" select="parent::subclause1"/>

        <xsl:choose>
            <xsl:when test="(ancestor::*/attribute::properties='preservesubtitles') and (preceding-sibling::title)">
                <!-- supress numbering where preceding subclause1/title and set up to use them-->
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:if test="not($operativeType='usmedium')">
                        <span class="indentSpacer">&#160;</span>
                    </xsl:if>
                    <!-- sc 24/10/2008 in uslfa or usmedium, subclauses are numbered even if they are the only subclause within a clause, so added condition -->
                    <xsl:if test="($parentSubclause1/preceding-sibling::subclause1) or ($parentSubclause1/following-sibling::subclause1) or $operativeType='uslfa' or $operativeType='usmedium'">
                        <xsl:choose>
                            <xsl:when test="ancestor::recitals">
                                <xsl:number level="multiple" format="(i) " count="subclause1"/>
                            </xsl:when>
                            <xsl:when test="$operativeType='uslfa' and preceding-sibling::*[1][self::title]">
                                <span class="sectionTitle">
                                    <xsl:if test="$parentSubclause1/attribute::condition='optional'">
                                        <span>[</span>
                                    </xsl:if>
                                    Section
                                    <xsl:number level="multiple" format="1.01 "
                                                count="clause[not (attribute::numbering='none')]|subclause1"/>
                                    <xsl:call-template name="converttitlecase">
                                        <xsl:with-param name="toconvert" select="$parentSubclause1/title"/>
                                    </xsl:call-template>
                                </span>
                                &#160;&#160;
                            </xsl:when>
                            <xsl:when test="$operativeType='usmedium'">
                                <span class="numbering">
                                    <xsl:number level="multiple" format="1.1 "
                                                count="clause[not (attribute::numbering='none')]|subclause1"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:number level="multiple" format="1.1 "
                                            count="clause[not (attribute::numbering='none')]|subclause1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="$parentSubclause1/attribute::condition='optional' and not($operativeType='uslfa' and preceding-sibling::*[1][self::title])">
                        <span>[</span>
                    </xsl:if>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="para[parent::recitals and ancestor::precedent/@jurisdiction='US']">
        <xsl:choose>
            <xsl:when test="$operativeType='uslfa'">
                <p>
                    <span class="indentSpacer">&#160;</span>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:number format="A. " count="para"/>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
            match="para[not (preceding-sibling::*) and parent::def/preceding-sibling::*[1][self::defterm] and not (ancestor::party) and ancestor::precedent/@jurisdiction='US']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="clause[parent::recitals]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template
            match="subclause1/title[following-sibling::*[1][not(self::para)] and ancestor::operative/@properties='uslfa']">
        <p>
            <span class="indentSpacer">&#160;</span>
            <span class="sectionTitle">Section
                <xsl:number level="multiple" format="1.01 "
                            count="clause[not (attribute::numbering='none')]|subclause1"/>
                <xsl:call-template name="converttitlecase">
                    <xsl:with-param name="toconvert" select="parent::subclause1/title"/>
                </xsl:call-template>
            </span>
            &#160;&#160;
        </p>
    </xsl:template>

    <xsl:template match="inlinetitle">
        <xsl:choose>
            <xsl:when test="$operativeType='uslfa' and not(ancestor::subclause3) ">
                <span class="inlineTitleUslfa">
                    <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="inlineTitle">
                    <xsl:value-of select="."/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="title[parent::clause][ancestor::operative/@properties='uslfa']">
        <xsl:if test="count(preceding::title[parent::clause]) &gt; 0">
            <div class="inline-top-nav">
                <a href="#top" title="Link to the top of the document">Top</a>
            </div>
        </xsl:if>
        <xsl:variable name="parentClause" select="parent::clause"/>
        <xsl:if test="$parentClause/@id">
            <!--<a name="{$parentClause/@id}" id="{$parentClause/@id}"/>-->
        </xsl:if>
        <xsl:if test="not ($parentClause/@numbering='none')">
            <h3 class="clauseTitleUS">
                <xsl:if test="$parentClause/@condition='optional'">
                    <span>[</span>
                </xsl:if>
                ARTICLE
                <xsl:number format="I" count="clause[not (attribute::numbering='none')]"/>
            </h3>
        </xsl:if>
        <xsl:if test="string-length(.) &gt; 0">
            <h3 class="clauseTitleUS">
                <xsl:if test="$parentClause/@condition='optional' and $parentClause/@numbering='none'">
                    <!-- changed sc 14/02/2008 - bare text cannot be hiiden when switching to notes only view when integrated drafting
                     notes are used. this bracket has therefore been wrapped in a span -->
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
                <!--<xsl:if test="parent::clause/attribute::condition='optional'">
        <span>]</span>
        </xsl:if>-->
            </h3>
        </xsl:if>
    </xsl:template>

    <xsl:template
            match="parties/title[ancestor::precedent/@jurisdiction='US']|recitals/title[ancestor::precedent/@jurisdiction='US']|operativeinformal/title[ancestor::precedent/@jurisdiction='US']|clauseholder/title[ancestor::precedent/@jurisdiction='US']|heading/title[ancestor::precedent/@jurisdiction='US']|preamble/title[ancestor::precedent/@jurisdiction='US']|appendix/title[ancestor::precedent/@jurisdiction='US']">
        <xsl:if test="string-length(.) &gt; 0">
            <h3 class="precedentTitleUS">
                <xsl:apply-templates/>
            </h3>
        </xsl:if>
    </xsl:template>

    <xsl:template match="disclosureschedule[ancestor::precedent/@jurisdiction='US']">
        <h3>DISCLOSURE SCHEDULE
            <xsl:if test="count(schedule) &gt; 1">S</xsl:if>
        </h3>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="schedule[string-length(numberingtitle) &gt; 0]">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                    disable-output-escaping="yes">" id="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of
                    select="concat('schedule', count(preceding-sibling::schedule)+1)"/><xsl:text
                    disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <h3 class="clauseTitleUS[ancestor::precedent/@jurisdiction='US']">
            <xsl:if test="attribute::condition='optional'">
                <span>[</span>
            </xsl:if>
            <xsl:value-of select="numberingtitle"/>
        </h3>

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="title[parent::schedule][ancestor::precedent/@jurisdiction='US']">
        <h3 class="clauseTitleUS">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="schedule/numberingtitle"/>

    <!-- override xref names in uslfa - use section instead of article -->
    <xsl:template match="xref[ancestor::precedent/@jurisdiction='US']">
        <xsl:variable name="xrefnode" select="key('xreflink', @link)"/>
        <xsl:variable name="xrefname" select="name($xrefnode)"/>

        <xsl:variable name="operativeXrefName" select="$operativeNode/@xrefname"/>

        <!-- CB refactored Aug 2006 - similar logic as word transform
            CB April 2007 added rule xrefname-->
        <xsl:variable name="xreflogicalname">
            <xsl:choose>
                <xsl:when test="$operativeXrefName='paragraph'">
                    <xsl:text>paragraph</xsl:text>
                </xsl:when>
                <xsl:when test="$operativeXrefName='condition'">
                    <xsl:text>condition</xsl:text>
                </xsl:when>
                <xsl:when test="$operativeXrefName='rule'">
                    <xsl:text>rule</xsl:text>
                </xsl:when>
                <xsl:when test="$operativeXrefName='article'">
                    <xsl:choose>
                        <xsl:when test="$operativeType = 'uslfa' and $xrefnode/ancestor-or-self::subclause1">
                            <xsl:text>Section</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Article</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::schedule">
                    <xsl:text>paragraph</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$xrefnode/ancestor::operative[@properties='uslfa'] and $xrefnode[self::clause]">
                            <xsl:text>Article</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Section</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="xreflogicalssname">
            <xsl:choose>
                <xsl:when test="$operativeXrefName='paragraph'">
                    <xsl:text>Paragraph</xsl:text>
                </xsl:when>
                <xsl:when test="$operativeXrefName='condition'">
                    <xsl:text>Condition</xsl:text>
                </xsl:when>
                <xsl:when test="$operativeXrefName='rule'">
                    <xsl:text>Rule</xsl:text>
                </xsl:when>
                <xsl:when test="$operativeXrefName='article'">
                    <xsl:choose>
                        <xsl:when test="$operativeType='uslfa' and $xrefnode/ancestor-or-self::subclause1">
                            <xsl:text>Section</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Article</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$xrefnode/ancestor::schedule">
                    <xsl:text>Paragraph</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$xrefnode/ancestor::operative[@properties='uslfa'] and $xrefnode[self::clause]">
                            <xsl:text>Article</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Section</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:if test="$xrefname='schedule' ">
            <xsl:if test="$precedentNode and count($precedentNode/schedule) &lt; 2">
                <xsl:text>the </xsl:text>
            </xsl:if>
            <xsl:if test="/letter and count(ancestor::letter/schedule) &lt; 2">
                <xsl:text>the </xsl:text>
            </xsl:if>
        </xsl:if>

        <xsl:variable name="ancestor_plcxlink" select="ancestor::plcxlink"/>

        <xsl:choose>
            <!-- capitalise link at start of element, but not in subclause2-->
            <xsl:when test="(($xrefname='clause') or ($xrefname='subclause1') or
	            	($xrefname='subclause2')) and not(ancestor::subclause2) and not (($ancestor_plcxlink/preceding-sibling::*) or (ancestor_plcxlink/preceding-sibling::text()))">
                <xsl:value-of select="$xreflogicalssname"/><xsl:text> </xsl:text>
            </xsl:when>
            <!-- capitalise link at start of sentence - a special case because def treated as inline-->
            <xsl:when
                    test="(($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2')) and (substring (ancestor_plcxlink/preceding-sibling::text()[1],string-length(ancestor_plcxlink/preceding-sibling::text()[1])-1,2)='. ')">
                <xsl:value-of select="$xreflogicalssname"/><xsl:text> </xsl:text>
            </xsl:when>
            <!-- uncapitalise link at start of def - a special case because def treated as inline-->
            <xsl:when
                    test="(($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2')) and (ancestor_plcxlink/parent::para[not (preceding-sibling::para)]/parent::def)">
                <xsl:value-of select="$xreflogicalname"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <!-- otherwise uncapitalise -->
            <xsl:when
                    test="($xrefname='clause') or ($xrefname='subclause1') or ($xrefname='subclause2') or ($xrefname='subclause3')">
                <xsl:value-of select="$xreflogicalname"/><xsl:text> </xsl:text>
            </xsl:when>

            <xsl:when test="$xrefname='schedule' and $precedentNode and count($precedentNode/schedule) &lt; 2">
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
                <xsl:call-template name="firstClauseParaNum_US">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause1'">
                <xsl:call-template name="firstSubclause1ParaNum_US">
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
                <xsl:call-template name="firstSubclause2ParaNum_US">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause2'">
                <xsl:call-template name="firstSingleSubclause2ParaNum_US">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause3'">
                <xsl:call-template name="firstSubclause3ParaNum_US">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xrefname='subclause4'">
                <xsl:call-template name="firstSubclause4ParaNum">
                    <xsl:with-param name="con_node" select="$xrefnode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="($xrefname='schedule') and $precedentNode">
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

    <!-- override numbering for articles -->
    <xsl:template name="firstClauseParaNum_US">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="$operativeType='uslfa'">
                    <xsl:number level="multiple" format="I{$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number format="1{$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- override numbering for sections -->
    <xsl:template name="firstSubclause1ParaNum_US">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="$operativeType='uslfa'">
                    <xsl:number level="multiple" format="1.01{$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number level="multiple" format="1.1{$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause2ParaNum_US">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="$operativeType='uslfa'">
                    <xsl:number level="multiple" format="1.01(a){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number level="multiple" format="1.1(a){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSingleSubclause2ParaNum_US">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="$operativeType='uslfa'">
                    <xsl:number level="multiple" format="1.01(a){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:when test="$operativeType='usmedium'">
                    <xsl:number level="multiple" format="1.1(a){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number level="multiple" format="1(a){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause2[not (@optionality='unselected')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="firstSubclause3ParaNum_US">
        <xsl:param name="con_node" select="current()"/>
        <xsl:param name="endWith"/>
        <xsl:for-each select="$con_node">
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="$operativeType='uslfa'">
                    <xsl:number level="multiple" format="1.01(a)(i){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]|subclause3[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:when test="$operativeType='ussfawithtitles'">
                    <xsl:number level="multiple" format="1(a)(i){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause2[not (@optionality='unselected')]|subclause3[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:when test="$operativeType='ussfa'">
                    <xsl:number level="multiple" format="1(a)(i){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause2[not (@optionality='unselected')]|subclause3[not (@optionality='unselected')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number level="multiple" format="1.1(a)(i){$endWith}"
                                count="clause[not (@optionality='unselected')][not (@numbering='none')]|subclause1[not (@optionality='unselected')]|subclause2[not (@optionality='unselected')]|subclause3[not (@optionality='unselected')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="plcxlink_suffix">
        <xsl:param name="locator"/>
        <xsl:if test="$locator/@xlink:label='disclosureschedule'">&#160;of the Disclosure Schedule</xsl:if>
    </xsl:template>

    <!-- *************************************************************************************************************************** -->
    <!-- US MEDIUM FORM AGREEMENTS -->
    <!-- *************************************************************************************************************************** -->

    <!-- TWO USMEDIUM TESTS IN THE SUBCLAUSE1 SECTION, SEARCH FOR '''<xsl:when test="$operativeType='usmedium'">''' and
        '''<xsl:if test="not($operativeType='usmedium')">''' -->

    <!-- WRAPPER -->

    <xsl:template match="operative[@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div id="usmediumAgreement">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- CLAUSES -->

    <xsl:template
            match="subclause2[ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template
            match="subclause3[ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template
            match="subclause4[ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <xsl:if test="self::node()[attribute::id]">
            <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="attribute::id"/><xsl:text
                disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- DEF TERM INDENTING -->
    <!-- tl 07/05/10 added parent::defitem qualifier as medium agreement defitems in para indenting too much -->
    <xsl:template
            match="defterm[ancestor::precedent/@jurisdiction='US'][parent::defitem][normalize-space(preceding-sibling::text())='']">
        <span class="defTermIndent">
            <b>"<xsl:apply-templates/>"
                <xsl:if test="parent::defitem">&#160;</xsl:if>
            </b>
        </span>
    </xsl:template>

    <!-- CLAUSE TITLE RUN IN-->

    <xsl:template
            match="title[parent::clause and following-sibling::para][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="runInTitleClause">
            <span class="numbering">
                <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            </span>
            <span class="underlined">
                <xsl:apply-templates/>
            </span>
            <span class="runInMargin">
                <xsl:text>.</xsl:text>
            </span>
            <xsl:apply-templates select="following-sibling::para[1]" mode="runin"/>
        </div>
    </xsl:template>

    <!-- stop para rendering because of above value-of select  (first para only, extra paras added at end should still render) -->

    <xsl:template
            match="para[parent::clause][preceding-sibling::title][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US'][position()=1]"/>

    <xsl:template
            match="para[parent::clause][preceding-sibling::title][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']"
            mode="runin">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- CLAUSE TITLE NO RUN IN-->

    <xsl:template
            match="title[parent::clause and not(following-sibling::para)][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="noRunInTitle">
            <span class="numbering">
                <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            </span>
            <span class="underlined">
                <xsl:apply-templates/>
            </span>
            <xsl:text>.</xsl:text>
        </div>
    </xsl:template>

    <!-- SUBCLAUSE1 TITLE RUN IN -->

    <xsl:template
            match="title[parent::subclause1 and following-sibling::para][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="runInTitle">
            <div class="clauseIndent">
                <span class="numbering">
                    <xsl:number level="multiple" format="1.1 "
                                count="clause[not (attribute::numbering='none')]|subclause1"/>
                </span>
                <span class="underlined">
                    <xsl:apply-templates/>
                </span>
                <span class="runInMargin">
                    <xsl:text>.</xsl:text>
                </span>
                <xsl:apply-templates select="following-sibling::para[1]" mode="runin"/>
            </div>
        </div>
    </xsl:template>

    <!-- stop para rendering because of above value-of select (first para only, extra paras added at end should still render) -->
    <xsl:template
            match="para[parent::subclause1][preceding-sibling::title][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US'][position()=1]"/>

    <xsl:template
            match="para[parent::subclause1][preceding-sibling::title][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']"
            mode="runin">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- keep all titles lower case -->
    <xsl:template
            match="text()[parent::title/parent::clause][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- SUBCLAUSE1 PARAS
    <xsl:template match="para[parent::subclause1][preceding-sibling::para][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Indent"><p>
            <xsl:apply-templates/>
        </p></div>
    </xsl:template>
    -->

    <!-- SUBCLAUSE2 PARAS -->
    <xsl:template
            match="para[parent::subclause2][not(preceding-sibling::para)][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Indent">
            <p>
                <span class="numbering">
                    <xsl:number level="multiple" format="(a) " count="subclause2"/>
                </span>
                <xsl:if test="parent::subclause2/attribute::condition='optional'">
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <!--<xsl:template match="para[parent::subclause2][preceding-sibling::para][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Para"><p><xsl:apply-templates/></p></div>
    </xsl:template>
    -->

    <!-- SUBCLAUSE3 PARAS -->
    <xsl:template
            match="para[parent::subclause3][not(preceding-sibling::para)][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause3Indent">
            <p>
                <span class="numbering">
                    <xsl:number level="multiple" format="(i) " count="subclause3"/>
                </span>
                <xsl:if test="parent::subclause2/attribute::condition='optional'">
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template
            match="para[parent::subclause3][preceding-sibling::para][ancestor::operative/@properties='usmedium'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause3Para">
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <!-- *************************************************************************************************************************** -->
    <!-- US MEDIUM FORM AGREEMENTS END END END -->
    <!-- *************************************************************************************************************************** -->

    <!-- *************************************************************************************************************************** -->
    <!-- SIGNATURE PARAGRAPH AND ATTACHMENTS -->
    <!-- *************************************************************************************************************************** -->

    <xsl:template match="attachments[ancestor::precedent/@jurisdiction='US']">
        <div id="attachments">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="attachment[parent::attachments][ancestor::precedent/@jurisdiction='US']">
        <h3>
            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='@attachmentname'/>
                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>
        </h3>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="title[parent::attachments][ancestor::precedent/@jurisdiction='US']">
        <h3>
            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='.'/>
                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>
        </h3>
    </xsl:template>

    <xsl:template match="title[parent::attachment][ancestor::precedent/@jurisdiction='US']">
        <h3>
            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='.'/>
                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>
        </h3>
    </xsl:template>

    <xsl:template
            match="para[parent::clause and ancestor::signature and preceding-sibling::table|following-sibling::table and ancestor::precedent/@jurisdiction='US']">
        <p>
            <span class="indentSpacer">&#160;</span>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- *************************************************************************************************************************** -->
    <!-- SIGNATURE PARAGRAPH AND ATTACHMENTS END END END -->
    <!-- *************************************************************************************************************************** -->

    <!-- *************************************************************************************************************************** -->
    <!-- US MEMORANDUM -->
    <!-- *************************************************************************************************************************** -->

    <!-- WRAPPER -->

    <xsl:template match="operative[@properties='usmemo'][ancestor::precedent/@jurisdiction='US']">
        <div id="usMemo">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- US MEMO HEADER -->

    <xsl:template match="memorandumheader[ancestor::precedent/@jurisdiction='US']">
        <div id="usMemoHeader">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template
            match="heading[following-sibling::operative/@properties='usmemo'][ancestor::precedent/@jurisdiction='US']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="title[parent::memorandumheader][ancestor::precedent/@jurisdiction='US']">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- SUBCLAUSE 1 TITLE RUN IN -->

    <xsl:template
            match="title[parent::subclause1 and following-sibling::para][ancestor::operative/@properties='usmemo'][ancestor::precedent/@jurisdiction='US']">
        <div class="runInTitle">
            <div class="clauseIndent">
                <span class="underlined heavyWeightText">
                    <xsl:apply-templates/>
                </span>
                <span class="runInMargin">
                    <xsl:text>.</xsl:text>
                </span>
                <xsl:apply-templates select="following-sibling::para[1]" mode="runin"/>
            </div>
        </div>
    </xsl:template>

    <!-- stop para rendering because of above value-of select (first para only, extra paras added at end should still render) -->

    <xsl:template
            match="para[parent::subclause1][preceding-sibling::title][ancestor::operative/@properties='usmemo'][ancestor::precedent/@jurisdiction='US'][position()=1]"/>

    <xsl:template
            match="para[parent::subclause1][preceding-sibling::title][ancestor::operative/@properties='usmemo'][ancestor::precedent/@jurisdiction='US']"
            mode="runin">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- keep all titles lower case -->

    <xsl:template
            match="text()[parent::title/parent::clause][ancestor::operative/@properties='usmemo'][ancestor::precedent/@jurisdiction='US']">
        <xsl:call-template name="parsetext">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- no link to the top for memos -->
    <xsl:template match="title[parent::clause][ancestor::operative/@properties='usmemo']">
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

    <!-- *************************************************************************************************************************** -->
    <!-- US MEMORANDUM END END END -->
    <!-- *************************************************************************************************************************** -->

    <!-- *************************************************************************************************************************** -->
    <!-- US SHORT FORM AGREEMENTS WITH TITLES-->
    <!-- *************************************************************************************************************************** -->

    <!-- WRAPPER -->

    <xsl:template match="operative[starts-with(@properties,'ussfawithtitles')][ancestor::precedent/@jurisdiction='US']">
        <div id="usSfaWithTitles">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template
            match="title[parent::clause and starts-with(ancestor::operative/@properties,'ussfawithtitles') and string-length(following-sibling::para)&gt;0]"/>

    <xsl:template
            match="title[parent::clause and starts-with(ancestor::operative/@properties,'ussfawithtitles') and string-length(following-sibling::para)=0]">
        <p>
            <xsl:if test="not(parent::clause/attribute::numbering='none')">
                <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
            </xsl:if>
            <span class="titleUssfawithtitles">
                <xsl:value-of select="."/>
            </span>
            .
        </p>
    </xsl:template>

    <!-- runin -->
    <xsl:template
            match="para[preceding-sibling::title and parent::clause and ancestor::operative/@properties='ussfawithtitles']">
        <p>
            <xsl:if test="string-length(.)&gt;0">
                <!-- sc 5/1/2010 FBT #11164 - added optionality -->
                <xsl:if test="parent::clause/@condition='optional'">
                    <span>[</span>
                </xsl:if>

                <xsl:choose>
                    <xsl:when test="not(preceding-sibling::para)">
                        <xsl:if test="not(parent::clause/attribute::numbering='none')">
                            <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
                        </xsl:if>
                        <span class="runInTitle">
                            <xsl:value-of select="preceding-sibling::title"/>
                        </span>
                        .&#160;&#160;
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="indentSpacer">&#160;</span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- norunin -->
    <xsl:template
            match="para[parent::clause and not (preceding-sibling::title) and ancestor::operative/@properties='ussfawithtitlesnorunin']">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::para)">
                <p>
                    <xsl:number format="1. " count="clause[not (attribute::numbering='none')]"/>
                    <span class="indentSpacer2">&#160;</span>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <span class="indentSpacer">
                        <xsl:apply-templates/>
                    </span>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- SUBCLAUSE2 PARAS -->

    <xsl:template
            match="para[parent::subclause2][not(preceding-sibling::para)][starts-with(ancestor::operative/@properties,'ussfawithtitles')][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Indent">
            <p>
                <span class="numbering">
                    <xsl:number level="multiple" format="(a) " count="subclause2"/>
                </span>
                <xsl:if test="parent::subclause2/attribute::condition='optional'">
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template
            match="para[parent::subclause2][preceding-sibling::para][starts-with(ancestor::operative/@properties,'ussfawithtitles')][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Para">
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <!-- SUBCLAUSE3 PARAS -->

    <xsl:template
            match="para[parent::subclause3][not(preceding-sibling::para)][starts-with(ancestor::operative/@properties,'ussfawithtitles')][ancestor::precedent/@jurisdiction='US']">
        <div class="clause3Indent">
            <p>
                <span class="numbering">
                    <xsl:number level="multiple" format="(i) " count="subclause3"/>
                </span>
                <xsl:if test="parent::subclause2/attribute::condition='optional'">
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template
            match="para[parent::subclause3][preceding-sibling::para][starts-with(ancestor::operative/@properties,'ussfawithtitles')][ancestor::precedent/@jurisdiction='US']">
        <div class="clause3Para">
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <!-- *************************************************************************************************************************** -->
    <!-- US SHORT FORM AGREEMENTS WITH TITLES END -->
    <!-- *************************************************************************************************************************** -->

    <!-- *************************************************************************************************************************** -->
    <!-- US SHORT FORM AGREEMENTS WITHOUT TITLES-->
    <!-- *************************************************************************************************************************** -->

    <!-- WRAPPER -->

    <xsl:template match="operative[@properties='ussfa'][ancestor::precedent/@jurisdiction='US']">
        <div id="usSfa">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- CLAUSE PARAS -->
    <xsl:template
            match="para[parent::clause and (preceding-sibling::para) and ancestor::operative/@properties='ussfa']">
        <p>
            <span class="indentSpacer2">&#160;</span>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- SUBCLAUSE2 PARAS -->
    <xsl:template
            match="para[parent::subclause2][not(preceding-sibling::para)][ancestor::operative/@properties='ussfa'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Indent">
            <p>
                <span class="numbering">
                    <xsl:number level="multiple" format="(a) " count="subclause2"/>
                </span>
                <xsl:if test="parent::subclause2/attribute::condition='optional'">
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template
            match="para[parent::subclause2][preceding-sibling::para][ancestor::operative/@properties='ussfa'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause2Para">
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <!-- SUBCLAUSE3 PARAS -->
    <xsl:template
            match="para[parent::subclause3][not(preceding-sibling::para)][ancestor::operative/@properties='ussfa'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause3Indent">
            <p>
                <span class="numbering">
                    <xsl:number level="multiple" format="(i) " count="subclause3"/>
                </span>
                <xsl:if test="parent::subclause2/attribute::condition='optional'">
                    <span>[</span>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template
            match="para[parent::subclause3][preceding-sibling::para][ancestor::operative/@properties='ussfa'][ancestor::precedent/@jurisdiction='US']">
        <div class="clause3Para">
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <!-- *************************************************************************************************************************** -->
    <!-- US SHORT FORM AGREEMENTS WITHOUT TITLES END -->
    <!-- *************************************************************************************************************************** -->

    <!-- *************************************************************************************************************************** -->
    <!-- US LETTER AGREEMENT -->
    <!-- *************************************************************************************************************************** -->

    <xsl:template match="heading/letterhead[ancestor::precedent/@jurisdiction='US']">
        <div class="letterHead">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="title[parent::letterhead][ancestor::precedent/@jurisdiction='US']">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <!-- *************************************************************************************************************************** -->
    <!-- US LETTER AGREEMENT END -->
    <!-- *************************************************************************************************************************** -->


</xsl:stylesheet>