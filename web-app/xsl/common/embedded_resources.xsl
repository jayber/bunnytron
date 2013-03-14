<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <!-- fatwire parameters -->
    <xsl:param name="pagename"/>
    <xsl:param name="childPageName"/>
    <xsl:param name="contentType"/>
    <xsl:param name="contentId"/>
    <xsl:param name="fwAction"/>
    <xsl:param name="view"/>

    <xsl:template match="resource[embeddedResources]" mode="embedded-links">
        <!-- sc 7/1/2010 - modified to use casetracker variable instead of !qanda - prevents these links being generated
            for concatenated docs that are not casetrackers -->
        <xsl:if test="$casetracker = true()">
            <div id="embedded_links">
                <xsl:apply-templates select="xml/descendant::fulltext" mode="embedded-links"/>
            </div>
        </xsl:if>
        <xsl:apply-templates select="embeddedResources"/>
        <xsl:if test="$qanda">
            <xsl:call-template name="answer_oddends">
                <xsl:with-param name="embeddedresources" select="$resource-root/embeddedResources/resource"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <xsl:template match="fulltext" mode="embedded-links">
        <xsl:if test="section1">
            <ul>
                <xsl:apply-templates select="section1" mode="embedded-links"/>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="section1" mode="embedded-links">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="section1" mode="non-embedded">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="embeddedResources">
        <div id="embedded_resources">
            <xsl:if test="$qanda = false()">
                <xsl:call-template name="contents">
                    <!-- sc 7/1/2010 - pass the embedded resources eparately from the normal nodeset, stops unnecessary
                        recursion and makes things simpler -->
                    <xsl:with-param name="nodeSet" select="$resource-root/xml/*/fulltext"/>
                    <xsl:with-param name="embeddedNodeSet" select="resource"/>
                    <xsl:with-param name="embeddedContents" select="true()"/>
                    <xsl:with-param name="precedentJurisdiction" select="$precedentJurisdiction"/>
                </xsl:call-template>
                <xsl:apply-templates select="$resource-root/xml/*/fulltext/section1[string-length(title)&gt;0]"
                                     mode="non-embedded"/>
            </xsl:if>

            <!-- this isn't the best test - will there be a casetracker resource type? -->
            <xsl:variable name="embedded-plcxlinks" select="parent::resource/xml/article/fulltext/section1/*/plcxlink"/>
            <xsl:variable name="isCaseTracker"
                          select="count($embedded-plcxlinks) &gt; 0 and count($embedded-plcxlinks) = count($embedded-plcxlinks[xlink:locator/@xlink:role='Competition'])"/>

            <xsl:choose>
                <xsl:when test="$isCaseTracker = true()">
                    <xsl:apply-templates select="resource" mode="casetracker"/>
                </xsl:when>
                <xsl:when test="$qanda">
                    <xsl:apply-templates select="$resource-root/xml/descendant::qandaset" mode="qanda-answers"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="resource"/>
                </xsl:otherwise>
            </xsl:choose>

        </div>
    </xsl:template>

    <!-- casetracker embedded reosurces -->
    <xsl:template match="embeddedResources/resource" mode="casetracker">
        <a name="part{position()}">
            <xsl:comment/>
        </a>
        <h2>
            <xsl:value-of select="title"/>
        </h2>
        <xsl:if test="descendant::fulltext">
            <div class="embedded-resource embedded-case">
                <xsl:apply-templates select="descendant::fulltext"/>
            </div>
        </xsl:if>
        <xsl:call-template name="top-link"/>
        <xsl:call-template name="separator"/>
    </xsl:template>

    <!-- non-casetracker embedded resources -->
    <xsl:template match="embeddedResources/resource">
        <a name="part{position()}">
            <xsl:comment/>
        </a>
        <h2>
            <xsl:value-of select="title"/>
        </h2>
        <xsl:choose>
            <!-- glossary -->
            <xsl:when test="descendant::glossitem/glossdef">
                <div class="embedded-resource">
                    <xsl:apply-templates select="descendant::glossitem/glossdef"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="descendant::fulltext">
                    <div class="embedded-resource">
                        <xsl:apply-templates select="descendant::fulltext"/>
                    </div>
                </xsl:if>
                <xsl:call-template name="top-link"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="separator"/>
    </xsl:template>

    <!-- country qanda -->
    <xsl:template match="fulltext" mode="qanda">

        <xsl:variable name="form-action">
            <xsl:if test="string-length($plcReference) &gt; 0">
                <xsl:value-of select="$plcReference"/>
            </xsl:if>
            <xsl:if test="string-length($plcReference) = 0">Satellite</xsl:if>
        </xsl:variable>

        <form id="qanda_form" action="{$form-action}">
            <xsl:if test="string-length($pagename) &gt; 0">
                <input type="hidden" name="pagename" value="{$pagename}"/>
            </xsl:if>
            <xsl:if test="string-length($childPageName) &gt; 0">
                <input type="hidden" name="childpagename" value="{$childPageName}"/>
            </xsl:if>
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

            <p class="qanda-heading">Choose your questions -<a href="#null" id="qanda_select_questions">Select all</a>/
                <a href="#null" id="qanda_deselect_questions">De-select all</a>
            </p>
            <div id="qanda_options_questions">
                <xsl:apply-templates select="descendant::qandaentry" mode="qanda-questions"/>
            </div>
            <p class="qanda-heading">Choose your jurisdictions -<a href="#null" id="qanda_select_jurisdictions">Select
                all</a>/
                <a href="#null" id="qanda_deselect_jurisdictions">De-select all</a>
            </p>
            <div id="qanda_options_jurisdictions">
                <xsl:apply-templates select="parent::*/metadata/relation/plcxlink/xlink:locator"
                                     mode="qanda-questions"/>
            </div>
            <input type="submit" class="button" value="Submit"/>
        </form>
        <div class="separator">
            <xsl:comment/>
        </div>

    </xsl:template>

    <xsl:template match="qandaset" mode="qanda-answers">
        <xsl:apply-templates select="*[descendant::question/@label = $resource-root/questions/question]"
                             mode="qanda-answers"/>
    </xsl:template>

    <xsl:template match="qandaset/section1/title" mode="qanda-answers">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- Fix headings - PER-277 -->
    <xsl:template match="qandaset/section1/section2/title" mode="qanda-answers">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="qandaentry" mode="qanda-questions">
        <xsl:variable name="qLabel" select="question/@label"/>
        <xsl:variable name="checked" select="$qLabel = $resource-root/questions/question"/>
        <xsl:variable name="class">qanda-option
            <xsl:if test="$checked=true()">qanda-option-selected</xsl:if>
        </xsl:variable>
        <div class="{$class}">
            <xsl:if test="$checked = true()">
                <input id="qaq_{$qLabel}" type="checkbox" name="qaq" value="{$qLabel}" checked="checked"/>
            </xsl:if>
            <xsl:if test="$checked = false()">
                <input id="qaq_{$qLabel}" type="checkbox" name="qaq" value="{$qLabel}"/>
            </xsl:if>
            <label for="qaq_{$qLabel}"><xsl:value-of select="position()"/>.
                <xsl:value-of select="shortquestion"/>
            </label>
        </div>
    </xsl:template>

    <xsl:template match="xlink:locator" mode="qanda-questions">
        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when
                        test="not(contains(@xlink:href,':') or contains(@xlink:href,'-')) and @xlink:role='Article' or @xlink:role='article' and not(starts-with(@xlink:href,'A'))">
                    A<xsl:value-of select="normalize-space(@xlink:href)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(@xlink:href)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="qaid" select="@xlink:href"/>
        <xsl:variable name="checked"
                      select="$embeddedResources/id = $qaid or $embeddedResources/plcReference = $qaid or $answers  = $qaid"/>
        <xsl:variable name="class">qanda-option
            <xsl:if test="$checked=true()">qanda-option-selected</xsl:if>
        </xsl:variable>
        <div class="{$class}">
            <xsl:if test="$checked = true()">
                <input id="qaid_{$value}" type="checkbox" name="qaid" value="{$value}" checked="checked"/>
            </xsl:if>
            <xsl:if test="$checked = false()">
                <input id="qaid_{$value}" type="checkbox" name="qaid" value="{$value}"/>
            </xsl:if>
            <label for="qaid_{$value}">
                <xsl:value-of select="@xlink:label"/>
            </label>
        </div>
    </xsl:template>

    <xsl:template match="qandaentry" mode="qanda-answers">

        <xsl:variable name="qLabel" select="question/@label"/>

        <xsl:if test="$resource-root/questions/question = $qLabel">
            <xsl:apply-templates select="question"/>
            <div class="qanda-embedded-answers">
                <xsl:apply-templates select="$embeddedResources" mode="qanda-answers">
                    <xsl:with-param name="qLabel" select="$qLabel"/>
                </xsl:apply-templates>
            </div>
            <div class="separator">&#160;</div>
        </xsl:if>

    </xsl:template>

    <xsl:template match="embeddedResources/resource" mode="qanda-answers">
        <xsl:param name="qLabel"/>
        <xsl:variable name="plcRef" select="plcReference"/>
        <xsl:variable name="poid" select="poid"/>
        <xsl:variable name="locator"
                      select="$resource-root/xml/*/metadata/relation/plcxlink/xlink:locator[(contains(@xlink:href,$plcRef) and not($plcRef='')) or (contains(@xlink:href,$poid) and not($poid=''))]"/>
        <xsl:if test="$locator">
            <h1>
                <xsl:value-of select="$locator/@xlink:title"/>
            </h1>
        </xsl:if>
        <xsl:if test="string-length(author) &gt; 0">
            <div class="resource-author">
                <xsl:apply-templates select="author" mode="qanda-answers"/>
            </div>
        </xsl:if>
        <xsl:if test="string-length(lawdate) &gt; 0">
            <div class="resource-author">Law stated as at
                <xsl:value-of select="lawdate"/>
            </div>
        </xsl:if>
        <xsl:apply-templates select="descendant::qandaentry[question/@label = $qLabel]/answer"/>
    </xsl:template>

    <xsl:template match="author" mode="qanda-answers">
        <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:template>

    <!-- international PN -->
    <xsl:template match="plcxlink" mode="intPN">
        <form id="intpn_jurisdiction_form" action="{$resource-root/plcReference}">
            <p class="jurisdiction-filter">Select a jurisdiction:
                <select id="intpn_jurisdiction_filter" name="qaid">
                    <xsl:if test="count($embeddedResources)=0">
                        <option value="" selected="selected">Please select...</option>
                    </xsl:if>
                    <xsl:if test="count($embeddedResources)&gt;0">
                        <option value="">Please select...</option>
                    </xsl:if>
                    <xsl:apply-templates select="xlink:locator" mode="intPN"/>
                </select>
                <span>Use drop-down box to view other jurisdictions</span>
            </p>
            <xsl:if test="count($embeddedResources)&gt;0">
                <xsl:variable name="locator"
                              select="xlink:locator[$answers=@xlink:href or ($answers = concat('A',@xlink:href)) or @xlink:href = $embeddedResources/plcReference]"></xsl:variable>
                <xsl:if test="$locator">
                    <p>See all
                        <a href="{$embeddedResources/plcReference}">
                            <xsl:value-of select="$locator/@xlink:title"/> country questions
                        </a>
                    </p>
                    <p class="resource-author">
                        <strong>
                            <xsl:value-of select="$locator/@xlink:title"/> contributor:
                        </strong>
                        &#160;<xsl:value-of select="$embeddedResources/author"/>
                    </p>
                </xsl:if>
            </xsl:if>
        </form>
        <xsl:call-template name="separator"/>
    </xsl:template>

    <xsl:template match="xlink:locator" mode="intPN">
        <!--<xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="not(contains(@xlink:href,':') or contains(@xlink:href,'-')) and @xlink:role='Article' or @xlink:role='article'">A<xsl:value-of select="@xlink:href"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="@xlink:href"/></xsl:otherwise>
            </xsl:choose>    
            </xsl:variable>-->
        <xsl:variable name="value" select="@xlink:href"/>
        <xsl:variable name="checked"
                      select="$embeddedResources/id = $value or concat(':',$embeddedResources/id) = $value or $embeddedResources/plcReference = $value or $answers = $value"/>
        <xsl:if test="$checked=true()">
            <option value="{$value}" selected="selected">
                <xsl:value-of select="@xlink:label"/>
            </option>
        </xsl:if>
        <xsl:if test="$checked=false()">
            <option value="{$value}">
                <xsl:value-of select="@xlink:label"/>
            </option>
        </xsl:if>
    </xsl:template>

    <xsl:template match="fulltext" mode="intPN">
        <xsl:apply-templates select="section1" mode="intPN"/>
    </xsl:template>

    <xsl:template match="section1" mode="intPN">
        <!--<xsl:apply-templates select="*[not(name(.)='plcxlink' and xlink:locator[@xlink:role='qandaentry'])]"/>
        <xsl:apply-templates select="descendant::plcxlink[xlink:locator/@xlink:role='qandaentry']" mode="intPN-question"/>-->
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="plcxlink[xlink:locator/@xlink:role='qandaentry']">
        <xsl:variable name="questionId" select="number(xlink:locator/@xlink:href)"/>
        <xsl:apply-templates select="$embeddedResources/descendant::qandaentry[$questionId]" mode="intPN-question"/>
    </xsl:template>

    <xsl:template match="qandaentry" mode="intPN-question">
        <div class="qanda-question qanda-question-intpn">
            <xsl:apply-templates select="question" mode="intPN"/>
            <p class="qanda-jurisdiction">
                <xsl:variable name="locator"
                              select="$intPN/xlink:locator[$answers=@xlink:href or ($answers = concat('A',@xlink:href)) or @xlink:href = $embeddedResources/plcReference]"/>
                <xsl:choose>
                    <xsl:when test="$locator">
                        <xsl:value-of select="$locator/@xlink:title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$embeddedResources/title"/>
                    </xsl:otherwise>
                </xsl:choose>
            </p>
            <div class="qanda-question-answer">
                <xsl:apply-templates select="answer" mode="intPN"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="question" mode="intPN">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="answer" mode="intPN">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="answer_oddends">
        <xsl:param name="embeddedresources"/>
        <xsl:for-each select="$embeddedresources">
            <xsl:variable name="qandasetends" select="./xml/article/fulltext/qandaset[not(descendant::qandaentry)]"/>
            <xsl:if test="$qandasetends">
                <xsl:variable name="plcRef" select="./plcReference"/>
                <xsl:variable name="poid" select="./poid"/>
                <xsl:variable name="locator"
                              select="$resource-root/xml/*/metadata/relation/plcxlink/xlink:locator[(contains(@xlink:href,$plcRef) and not($plcRef='')) or (contains(@xlink:href,$poid) and not($poid=''))]"/>
                <xsl:if test="$locator">
                    <h1>
                        <xsl:value-of select="$locator/@xlink:title"/>
                    </h1>
                </xsl:if>
                <xsl:apply-templates select="$qandasetends"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
