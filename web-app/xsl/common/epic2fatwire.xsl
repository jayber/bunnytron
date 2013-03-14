<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">

    <!-- TRANSFORMS EPIC XML TO MAIN BODY CONTENT -->

    <xsl:import href="../plcdtd/plcdtd2html.xsl"/>
    <xsl:import href="../plcdtd/toc.xsl"/>
    <xsl:import href="embedded_resources.xsl"/>

    <!-- fatwire parameters -->
    <xsl:param name="pagename"/>
    <xsl:param name="childPageName"/>
    <xsl:param name="contentType"/>
    <xsl:param name="contentId"/>
    <xsl:param name="fwAction"/>
    <xsl:param name="view"/>
    <xsl:param name="pageType"/>
    <xsl:param name="host"/>

    <xsl:variable name="resource-root" select="resource"/>
    <xsl:variable name="resourceTypePlcReference" select="$resource-root/resourceType/plcReference"/>
    <!-- sc 7/1/2010 - explicit test for casetracker resource type as working it out from the document structure
        is not reliable -->
    <xsl:variable name="casetracker" select="$resourceTypePlcReference = '5-103-0961'"/>
    <xsl:variable name="qanda"
                  select="$resource-root/xml/*/metadata/relation/plcxlink/@xlink:role='crossborderqandaset' and descendant::qandaset"/>
    <xsl:variable name="intPN"
                  select="$resource-root/xml/*/metadata/relation/plcxlink[@xlink:role='qandaset' and @xlink:label='countryqaparts']"/>
    <xsl:variable name="plcReference" select="$resource-root/plcReference"/>
    <xsl:variable name="embeddedResources" select="$resource-root/embeddedResources/resource"/>
    <xsl:variable name="history" select="$resource-root/xml/*/metadata/revhistory"/>

    <xsl:variable name="precedentNode" select="$resource-root/xml/precedent"/>
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


    <xsl:variable name="questions" select="$resource-root/questions/question"/>
    <xsl:variable name="answers" select="$resource-root/answers/answer"/>

    <xsl:template match="/">
        <xsl:apply-templates select="resource/xml"/>
    </xsl:template>

    <xsl:template match="resource/xml">
        <!-- qanda options form -->
        <xsl:if test="$qanda = true()">
            <xsl:apply-templates select="*/fulltext" mode="qanda"/>
        </xsl:if>

        <!-- international PN selector -->
        <xsl:if test="$intPN = true()">
            <xsl:apply-templates
                    select="*/metadata/relation/plcxlink[@xlink:role='qandaset' and @xlink:label='countryqaparts']"
                    mode="intPN"/>
        </xsl:if>

        <!-- add a coversheet before the TOC. by default this is an empty template -->
        <xsl:call-template name="coversheet"/>

        <xsl:apply-templates select="descendant::speedread" mode="speedread"/>

        <!-- generate toc -->
        <xsl:if test="count($embeddedResources)=0 or $intPN=true()">
            <xsl:choose>
                <xsl:when test="*[not(name(.)='article' or name(.)='legalupdate')]/fulltext">
                    <xsl:call-template name="contents">
                        <xsl:with-param name="nodeSet" select="*/fulltext"/>
                        <xsl:with-param name="precedentJurisdiction" select="$precedentJurisdiction"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="precedent/toc">
                    <xsl:call-template name="contents">
                        <xsl:with-param name="nodeSet" select="precedent"/>
                        <xsl:with-param name="precedentJurisdiction" select="$precedentJurisdiction"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$intPN = true()">
                <xsl:apply-templates select="*/fulltext" mode="intPN"/>
            </xsl:when>
            <xsl:otherwise>

                <xsl:if test="count($embeddedResources) = 0">
                    <xsl:apply-templates/>
                </xsl:if>

                <xsl:if test="count($embeddedResources) &gt; 0">
                    <xsl:apply-templates select="$resource-root" mode="embedded-links"/>
                </xsl:if>

                <xsl:if test="count($history)&gt;0">
                    <xsl:call-template name="revisionhistory"/>
                </xsl:if>

                <xsl:if test="descendant::draftingnote">
                    <xsl:call-template name="generateDNoteLinks"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="speedread"/>

    <xsl:template match="speedread" mode="speedread">
        <xsl:if test="string-length(.) &gt; 50">
            <!--<div class="separator"><xsl:comment/></div>-->
            <h2>Speedread</h2>
            <xsl:variable name="speedreadTitle">
                <xsl:value-of select="title" disable-output-escaping="yes"/>
            </xsl:variable>
            <div id="speedread_intro">
                <xsl:value-of select="substring-before(substring-after(.,$speedreadTitle), '.')"/>&#160;
                <a href="#null" class="speedread-link">...show full speedread</a>
            </div>
            <div id="speedread">
                <xsl:apply-templates/>
                <a href="#null" class="speedread-link">Close speedread</a>
            </div>
            <div class="separator">
                <xsl:comment/>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- training course -->
    <xsl:template match="plcxlink[not(xlink:arc/@xlink:show='replace')][ancestor::trainingmodule]">

        <xsl:variable name="question" select="xlink:locator"/>
        <xsl:variable name="url">?pagename=<xsl:value-of select="$pagename"/>&amp;childpagename=<xsl:value-of
                select="$childPageName"/>&amp;c=PLC_Doc_C&amp;cid=<xsl:value-of select="$question/@xlink:href"/>&amp;courseId=<xsl:value-of
                select="$contentId"/>&amp;view=/CpdDetail
        </xsl:variable>

        <a href="{$url}">
            <xsl:value-of select="$question"/>
        </a>
        <br/>
    </xsl:template>
    <!-- training course: remove empty nodes -->
    <xsl:template match="listitem[string-length(para)=0][ancestor::trainingmodule]"/>

    <xsl:template name="revisionhistory">
        <div id="resource_history_data" style="display:none">
            <div class="print-heading">Resource history</div>
            <a href="#null" class="meta-display-link">
                <span>Show resource history</span>
                <span class="meta-tool-item-hidden">Hide resource history</span>
            </a>
            <div class="meta-tool-item-content">
                <xsl:apply-templates select="$history"/>
            </div>
        </div>

    </xsl:template>

    <xsl:template match="revhistory">
        <!-- changed sc 14/02/2008 - xml structure changed due to memcache -->
        <!--xsl:for-each select="xml/descendant::revision"-->
        <xsl:for-each select="revision[revdescription]">
            <!--<xsl:sort select="revnumber" order="descending" /> Sorting removed because we do not enfore a specific date type and so sorting would be unreliable. Instead we simply rely on the order -->
            <xsl:variable name="dateId">
                <xsl:variable name="uid">
                    <xsl:value-of select="position()"/>
                </xsl:variable>
                <xsl:variable name="repstr">'</xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length(revtitle) &gt; 0">
                        <xsl:value-of select="translate(revtitle,$repstr,'')"/>
                        <xsl:value-of select="$uid"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('id', translate(date, ' ', ''))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <div class="meta-history-item">
                <a href="#null" class="meta-history-link">
                    <xsl:choose>
                        <xsl:when test="string-length(revtitle) &gt; 0">
                            <xsl:value-of select="revtitle"/>
                        </xsl:when>
                        <!--<xsl:otherwise><xsl:value-of select="date" /></xsl:otherwise> removed for now as requested by jeremy -->
                    </xsl:choose>
                </a>
                <xsl:if test="string-length(revdescription)&gt;0">
                    <div class="meta-history-content">
                        <!--<div style="padding: 3px 0; font-style:italic">Author: <xsl:value-of select="author" /> (<xsl:value-of select="date" />)</div> removed for now as requested by Jeremy -->
                        <xsl:apply-templates select="revdescription"/>
                    </div>
                </xsl:if>
                <a class="meta-history-content meta-history-link" href="#null">Close</a>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="process_tracked_changes">
        <xsl:param name="node"/>
        <xsl:for-each select="$node/descendant::text()">
            <xsl:choose>
                <xsl:when test="parent::atict:del"></xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="generateDNoteLinks">
        <div id="resource_note_data" class="dnote-control-dn" style="display:none">
            <div class="meta-tool-item icon-dnotes-dn">
                <a id="dnote_action_dn" href="#null">
                    <span>View document and notes</span>
                </a>
                <span class="dnote-display-dn">Viewing document and notes</span>
                <a id="dnote_action_show" href="#null" class="dnote-display-dn dnote-display-show">
                    <span class="dnote-display-show">show all drafting notes</span>
                    <span>hide all drafting notes</span>
                </a>
            </div>
            <div class="meta-tool-item icon-dnotes-d">
                <a id="dnote_action_d" href="#null">
                    <span>View document only</span>
                </a>
                <span class="dnote-display-d">Viewing document</span>
            </div>
            <div class="meta-tool-item icon-dnotes-n">
                <a id="dnote_action_n" href="#null">
                    <span>View drafting notes only</span>
                </a>
                <span class="dnote-display-n">Viewing drafting notes</span>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="top-link">
        <div class="inline-top-nav">
            <a href="#top" title="Link to the top of the document">Top</a>
        </div>
    </xsl:template>

    <xsl:template name="separator">
        <div class="separator">
            <xsl:comment/>
        </div>
    </xsl:template>

    <!-- suppress the glossary term (displayed as title) -->
    <xsl:template match="glossitem/glossterm"/>

    <xsl:template name="coversheet">
        <xsl:if test="$precedentJurisdiction = 'US'">
            <xsl:for-each select="precedent/coversheet[not(parent::disclosureschedule)]">
                <div class="coversheetUS">
                    <h2>
                        <xsl:value-of select="title"/>
                    </h2>
                    <p>[between/among]</p>
                    <xsl:for-each select="coverparties/title">
                        <h3>
                            <xsl:value-of select="."/>
                        </h3>
                        <xsl:if test="position() &lt; count(../title)">
                            <p>and</p>
                        </xsl:if>
                    </xsl:for-each>
                    <p>dated as of</p>
                    <h3>[DATE]</h3>
                </div>
                <xsl:call-template name="separator"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template match="html/head/title"/>

</xsl:stylesheet>
