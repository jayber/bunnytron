<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xlink atict" version="1.0"
                xmlns:atict="http://www.arbortext.com/namespace/atict" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="resourceUrlPrefix" select="''"/>
    <!--<xsl:param name="sectionToExpand" select="''"/>-->

    <!--
    MB 2012: this is a new version of epic2fatwire.xsl, so that: Practice Area Resource Collections are interpreted slightly differently
    ( checklists, practice notes, standard docs and clauses, standard docs and drafts ) allowing contents table and just the current section.

    By default, the first section1 should be expanded.. An enhancement would be to make the toc recursive and what section is expanded configurable..

    TODO
      this should work with utility templates similiar to search prototype

    classify elements, to work out what properties they have:

      getNodeClassName

    -->

    <!--
    ========================================================================
                                    CONFIG
    ========================================================================
    -->

    <xsl:variable name="debug" select="false()"/>

    <xsl:variable name="cssClass_sectionDiv" select="'rcs'"/>
    <xsl:variable name="cssClass_tocResLink" select="'toggleResSection'"/>

    <xsl:variable name="cssClass_hideSection" select="'hide-resource'"/>
    <xsl:variable name="cssClass_showSection" select="'show-resource'"/>

    <!--
    ========================================================================
                                    OVERRIDES
    ========================================================================
    -->
    <xsl:template match="resource/xml">
        <!-- JS moved into: PLCBlock/ResourceCollection -->

        <div class="subcolumns mainContainer">
            <!-- ### contents table ### -->
            <div class="c30l slot1">
                <div id="toc" class="topic-list featured PLC-lightGrey generic-block askplc-topics toc">
                    <h2>Browse</h2>
                    <xsl:if test="count($embeddedResources)=0 or $intPN=true()">
                        <xsl:choose>
                            <xsl:when test="*[not(name(.)='article' or name(.) = 'legalupdate')]/fulltext">
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
                    <!-- state link -->
                    <p>
                        <a href="#" id="toggleAllResColl" class="collapsed">View all resources</a>
                    </p>
                </div>
            </div>
            <!-- ### resource link collections ### -->
            <div class="c70r slot2">
                <!-- the resource DIV used to be in: PLC_Doc_C/ResourceCollectionDetail now we need it here to match up with Web Productions
                mockup -->
                <div id="resource" class="res standarddoc-layout">
                    <!-- this code is from match=resource/xml in epic2fatwire.xsl -->
                    <xsl:choose>
                        <xsl:when test="$intPN = true()">
                            <xsl:apply-templates mode="intPN" select="*/fulltext"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="count($embeddedResources) = 0">
                                <xsl:apply-templates/>
                            </xsl:if>
                            <xsl:if test="count($embeddedResources) &gt; 0">
                                <xsl:apply-templates mode="embedded-links" select="$resource-root"/>
                            </xsl:if>
                            <xsl:if test="count($history)&gt;0">
                                <xsl:call-template name="revisionhistory"/>
                            </xsl:if>
                            <xsl:if test="descendant::draftingnote">
                                <xsl:call-template name="generateDNoteLinks"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>

        </div>
    </xsl:template>

    <!-- wrap the current output in a new DIV to simplify new requirements - this should have worked!!!
      for some reason it stops a section without an Id ( in the epic source ) from being generated correctly!!! ARGH -->
    <xsl:template match="section1">

        <xsl:element name="div">

            <!-- it would be great to avoid this, but I'm not happy comparing elements, returned from jQuery and the DOM.
              this I believe would be unreliable in some legacy browsers, better we just compare some ids; the old fashioned way -->
            <xsl:attribute name="aid">
                <xsl:value-of select="generate-id(.)"/>
            </xsl:attribute>

            <xsl:attribute name="class">
                <xsl:value-of select="$cssClass_sectionDiv"/><xsl:text> </xsl:text>
                <!-- TODO allow fatwire eventually to specify what section should be expanded by default -->
                <!--(($sectionToExpand = '') and (not(position() = 1))) or (@id = $sectionToExpand)-->
                <xsl:choose>
                    <xsl:when test="not(position() = 1)">
                        <xsl:value-of select="$cssClass_hideSection"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$cssClass_showSection"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <!-- MB: Strange bug. The xsl:import changes the context somehow so that anchors generated for elements which do
            not have an id attribute are not rendered and thus the contents table does not work. We have to generate the ids
            here instead. Added (self::[not(@id)]) and an attribute to indicate this. Its probably a reference to ancestor:: axis. -->
            <xsl:if test="not(ancestor::revdescription) and (self::node()[not(@id)])">
                <xsl:if test="self::node()[not (title)][@id]">
                    <!-- changed sc 11/07/07 - id attribute added to named anchors to solve linking to integrated notes bug -->
                    <xsl:text disable-output-escaping="yes"><![CDATA[<a name="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                        disable-output-escaping="yes"><![CDATA[" id="]]></xsl:text><xsl:value-of select="@id"/><xsl:text
                        disable-output-escaping="yes"><![CDATA["></a>]]></xsl:text>
                </xsl:if>
                <!-- generate an id for the contents if one is missing. Removed the following code as a fix for Bug 5630. This code
                should be added at the end of the next line, just after '[@id])' (without the quotes): 'and string-length(title) &gt; 0' -->
                <xsl:if test="not(self::node()[@id])">
                    <xsl:variable name="anchor"
                                  select="concat( 'sect1pos', count(preceding::*[(local-name(.) = 'section1' or local-name(.) = 'bridgehead') and not(ancestor::revdescription)])+1, 'res', count(ancestor::embeddedResource/preceding-sibling::embeddedResource)+1)"/>
                    <xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of select="$anchor"/><xsl:text
                        disable-output-escaping="yes">" id="</xsl:text><xsl:value-of select="$anchor"/><xsl:text
                        disable-output-escaping="yes">" mode="fix"&gt; &lt;/a&gt;</xsl:text>
                </xsl:if>
            </xsl:if>

            <xsl:apply-imports/>

        </xsl:element>
    </xsl:template>

    <xsl:template name="contents">
        <xsl:param name="nodeSet"/>
        <xsl:param name="embeddedNodeSet"/>
        <xsl:param name="embeddedContents" select="false()"/>
        <xsl:param name="precedentJurisdiction"/>

        <ul class="expandable-tree">
            <!-- MB: id like to do it this way: ( eventually )-->
            <!--<xsl:apply-templates select="$nodeSet/*" mode="toc"/>-->

            <!-- it appears for practice area resource collections we only need this call: the original toc.xsl has
              many more for various Epic XML subtypes.. -->
            <xsl:for-each select="$nodeSet/child::*">
                <xsl:choose>
                    <xsl:when test="local-name(.) = 'add'">
                        <xsl:call-template name="contentsItems">
                            <xsl:with-param name="nodes" select="child::node()"/>
                            <xsl:with-param name="pos" select="position()"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="contentsItems">
                            <xsl:with-param name="nodes" select="."/>
                            <xsl:with-param name="pos" select="position()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <!-- MB: Added parent and bookmark attributes for now, so we don't need to have too complex JS, and find a parent node etc ( which potentially is a little slow ) .. Keeps plc-behaviour code more simple.. -->
    <xsl:template name="contentsItems">
        <xsl:param name="pos"/>
        <!-- this appears to get an entire nodeset -->
        <xsl:param name="nodes"/>
        <!-- not sure at this juncture what resources are -->
        <xsl:param name="resourceCount" select="1"/>

        <!-- ### Process Bridgehead elements ### -->
        <xsl:if test="local-name($nodes) = 'bridgehead'">
            <xsl:element name="li">

                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>

                <xsl:attribute name="class">
                    <xsl:if test="position() = 1">
                        <xsl:text>first </xsl:text>
                    </xsl:if>
                    <xsl:text>section</xsl:text>
                </xsl:attribute>

                <xsl:element name="a">
                    <xsl:variable name="bridgeheadAnchor">
                        <xsl:choose>
                            <xsl:when test="@id">
                                <xsl:value-of select="@id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('sect1pos', position(), 'res', $resourceCount)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:attribute name="class">
                        <xsl:value-of select="$cssClass_tocResLink"/>
                    </xsl:attribute>
                    <xsl:attribute name="parent">
                        <xsl:value-of select="$bridgeheadAnchor"/>
                    </xsl:attribute>
                    <xsl:attribute name="bookmark">
                        <xsl:value-of select="$bridgeheadAnchor"/>
                    </xsl:attribute>

                    <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="$bridgeheadAnchor"/>
                    </xsl:attribute>

                    <xsl:value-of select="normalize-space(.)"/>

                </xsl:element>
            </xsl:element>
        </xsl:if>

        <!-- ### process section1 elements which have or don't have children ###  -->
        <xsl:if test="string-length(normalize-space($nodes/title)) &gt; 0">

            <!-- this is the same predicate which processes section2 nodes -->
            <xsl:variable name="hasChildren" select="count($nodes/section2[string-length(title) &gt; 0])"/>

            <xsl:if test="$debug">
                <xsl:message>
                    <xsl:text>hasChildren: </xsl:text>
                    <xsl:value-of select="$hasChildren"/>
                </xsl:message>
            </xsl:if>

            <xsl:variable name="section1anchor">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('sect1pos', position(), 'res', $resourceCount)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:element name="li">

                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>

                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="$hasChildren">
                            <xsl:attribute name="class">
                                <xsl:if test="$pos = 1">
                                    <xsl:text>first expanded </xsl:text>
                                </xsl:if>
                                <xsl:text>section expandable</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>section</xsl:text>
                            <xsl:if test="$pos = 1">
                                <xsl:text> first</xsl:text>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>

                <!-- indicates the LI has no link and a child tree -->
                <xsl:if test="$hasChildren">
                    <!-- process every title/node() -->
                    <!--<xsl:for-each select="$nodes/title/node()[not (local-name(.)='del')]">
                      <xsl:apply-templates select="."/>
                    </xsl:for-each>-->

                    <!-- section1 link should be clickable -->
                    <xsl:element name="a">

                        <xsl:attribute name="class">
                            <xsl:value-of select="$cssClass_tocResLink"/>
                        </xsl:attribute>
                        <xsl:attribute name="parent">
                            <xsl:value-of select="$section1anchor"/>
                        </xsl:attribute>
                        <xsl:attribute name="bookmark">
                            <xsl:value-of select="$section1anchor"/>
                        </xsl:attribute>

                        <xsl:attribute name="href">
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="$section1anchor"/>
                        </xsl:attribute>

                        <!-- process every title/node() -->
                        <xsl:for-each select="$nodes/title/node()[not (local-name(.)='del')]">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>

                <!--
                ### SECTION2 ### nodes,
                  currently the toc.xsl doesnt care about section3 elements or anythign deeper, so we also will ignore them
                -->
                <xsl:choose>
                    <xsl:when test="$hasChildren">
                        <!-- put this into the old structure, so it works with the new expandable tree stuff -->
                        <ul>
                            <!-- batch process each child section2 element -->
                            <xsl:for-each
                                    select="$nodes/child::*[local-name(.) = 'section2' or local-name(child::*) = 'section2']">
                                <xsl:if test="string-length(title) &gt; 0 or string-length(child::section2/title) &gt; 0 ">
                                    <xsl:variable name="sect2Node" select="child::section2"/>
                                    <li>

                                        <xsl:attribute name="id">
                                            <xsl:value-of select="generate-id(.)"/>
                                        </xsl:attribute>

                                        <xsl:element name="a">

                                            <xsl:variable name="section2anchor">
                                                <xsl:choose>
                                                    <xsl:when test="@id">
                                                        <xsl:value-of select="@id"/>
                                                    </xsl:when>
                                                    <xsl:when test="$sect2Node/@id">
                                                        <xsl:value-of select="$sect2Node/@id"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of
                                                                select="concat('sect2pos', count(preceding::section2[not(ancestor::revdescription)])+1, 'res', $resourceCount)"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>

                                            <xsl:attribute name="class">
                                                <xsl:value-of select="$cssClass_tocResLink"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="parent">
                                                <xsl:value-of select="$section1anchor"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="bookmark">
                                                <xsl:value-of select="$section2anchor"/>
                                            </xsl:attribute>

                                            <xsl:attribute name="href">
                                                <xsl:text>#</xsl:text>
                                                <!-- section2anchor -->
                                                <xsl:value-of select="$section2anchor"/>
                                            </xsl:attribute>

                                            <!-- text node -->
                                            <xsl:choose>
                                                <xsl:when test="title">
                                                    <xsl:call-template name="process_tracked_changes">
                                                        <xsl:with-param name="node" select="title"/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$sect2Node/title">
                                                    <xsl:call-template name="process_tracked_changes">
                                                        <xsl:with-param name="node" select="$sect2Node/title"/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:element>
                                    </li>
                                </xsl:if>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- no children nerd/geek singleton -->
                        <xsl:element name="a">

                            <xsl:variable name="anchor2nochildren">
                                <xsl:choose>
                                    <xsl:when test="@id">
                                        <xsl:value-of select="@id"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('sect1pos', position(), 'res', $resourceCount)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>

                            <xsl:attribute name="class">
                                <xsl:value-of select="$cssClass_tocResLink"/>
                            </xsl:attribute>
                            <xsl:attribute name="parent">
                                <xsl:value-of select="$section1anchor"/>
                            </xsl:attribute>
                            <xsl:attribute name="bookmark">
                                <xsl:value-of select="$anchor2nochildren"/>
                            </xsl:attribute>

                            <xsl:attribute name="href">
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="$anchor2nochildren"/>
                            </xsl:attribute>

                            <!-- process every title/node() -->
                            <xsl:for-each select="$nodes/title/node()[not (local-name(.)='del')]">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </xsl:element>

                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- override all generated links with new prefix, depending on how the block page is configured or what is decided.. -->
    <xsl:template match="plcxlink">

        <!-- CB feb 2007 we need to allow xrefs with no text. this is because the text (e.g. clause x.x) is autogenerated from the link target -->
        <xsl:if test="(string-length(xlink:locator) &gt; 0) or (descendant::xref)">
            <!-- and string-length(xlink:locator/@xlink:href) &gt; 0 removed this logic so links with no href will render, this should help the document stay valid but really all links should  -->
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

                        <!-- MB: XSLT processor is stupid .. -->
                        <xsl:variable name="normalised-href" xml:space="default">
                            <xsl:value-of select="$articleserver"/>
                            <!-- ### MB: add new resource pages prefix ### -->
                            <xsl:value-of select="$resourceUrlPrefix"/>
                            <xsl:text>/</xsl:text>
                            <!-- sc - don't return to the root until url assembler doesn't need cs/Satellite -->
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:variable>

                        <xsl:attribute name="href">
                            <xsl:value-of select="normalize-space($normalised-href)"/>
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
                                    <!-- added, eh? by whom? when? -->
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
                    <!-- ref xlink for precedents. CB changed Spet 2003 to autogenerate link content -->
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

                        <!-- MB: added for new Practice Area Resource Collection block -->
                        <xsl:variable name="normalised-href">
                            <xsl:value-of select="$resourceUrlPrefix"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="xlink:locator/@xlink:href"/>
                        </xsl:variable>

                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="string-length(xlink:locator/@xlink:href) &gt; 0">
                                    <xsl:value-of select="normalize-space($normalised-href)"/>
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
                            <span class="printLink"><xsl:text>&#160;</xsl:text>(
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
            <!-- sc 20/10/2008 - call a template to add additional text to the output, based on attributes in the xlink:locator -->
            <xsl:call-template name="plcxlink_suffix">
                <xsl:with-param name="locator" select="xlink:locator"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>