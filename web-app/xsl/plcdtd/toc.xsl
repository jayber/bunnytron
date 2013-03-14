<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:atict="http://www.arbortext.com/namespace/atict"
                exclude-result-prefixes="xlink atict">
    <xsl:template name="contents">
        <xsl:param name="nodeSet"/>
        <xsl:param name="embeddedNodeSet"/>
        <xsl:param name="embeddedContents" select="false()"/>
        <xsl:param name="precedentJurisdiction"/>
        <xsl:variable name="normalContents"
                      select="count($nodeSet/section1[string-length(title) &gt; 0]) &gt; 0 or count($nodeSet/section1/section2[string-length(title) &gt; 0])"/>
        <xsl:variable name="qandaContents" select="count($nodeSet/qandaset/section1/qandaentry/question) &gt; 0"/>
        <a id="contentsLink" name="contentsLink">
            <xsl:comment/>
        </a>
        <xsl:choose>
            <xsl:when test="$normalContents or $embeddedContents or $qandaContents">
                <div class="contents-heading">
                    Contents <!--<span class="hiddenScreenLink"> - <a href="javascript:void(0)" class="screenLink" onclick="contents()" id="contentsText">Hide contents</a></span>--> </div>
                <div id="contents">
                    <xsl:if test="$normalContents">
                        <xsl:for-each select="$nodeSet/child::*">
                            <xsl:choose>
                                <xsl:when test="local-name(.) = 'add'">
                                    <xsl:call-template name="contentsItems">
                                        <xsl:with-param select="child::node()" name="nodes"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="contentsItems">
                                        <xsl:with-param select="." name="nodes"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                    <!-- sc 7/1/2010 - now uses separate embedded contents node set, stops unecessary recursion and makes
                        things simpler -->
                    <xsl:if test="$embeddedContents">
                        <xsl:call-template name="embeddedContents">
                            <xsl:with-param name="nodeSet" select="$embeddedNodeSet"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$qandaContents">
                        <xsl:call-template name="qandaContents">
                            <xsl:with-param name="nodeSet" select="$nodeSet/qandaset"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:comment/>
                </div>
                <div class="separator">
                    <xsl:comment/>
                </div>
            </xsl:when>
            <xsl:when test="count($nodeSet/operative/clause) &gt; 0">
                <xsl:call-template name="operativeContents">
                    <xsl:with-param name="nodeSet" select="$nodeSet"/>
                    <xsl:with-param name="precedentJurisdiction" select="$precedentJurisdiction"/>
                </xsl:call-template>
                <div class="separator">
                    <xsl:comment/>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="operativeContents">
        <xsl:param name="nodeSet"/>
        <xsl:param name="precedentJurisdiction"/>

        <xsl:choose>
            <xsl:when test="$precedentJurisdiction='US'">

                <div class="contents-heading contents-heading-precedent-US">TABLE OF CONTENTS</div>
                <div id="contents">
                    <table>
                        <xsl:for-each select="$nodeSet/operative/clause">
                            <xsl:if test="string-length(title) &gt; 0">
                                <tr>
                                    <td class="contents-index">ARTICLE
                                        <xsl:number format="I " count="clause"/>
                                    </td>
                                    <td>
                                        <a>
                                            <xsl:choose>
                                                <xsl:when test="string-length(@id) &gt; 0">
                                                    <xsl:attribute name="href">#<xsl:value-of select="@id"/>
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat('#clause', position())"/>
                                                    </xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if test="@condition='optional'">[</xsl:if>
                                            <xsl:call-template name='convertcase'>
                                                <xsl:with-param name='toconvert' select="title"/>
                                                <xsl:with-param name='conversion' select="'upper'"/>
                                            </xsl:call-template>
                                            <xsl:if test="@condition='optional'">]</xsl:if>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </table>
                    <xsl:if test="count($nodeSet/schedule) &gt; 0">
                        <ul>
                            <xsl:for-each select="$nodeSet/schedule">
                                <xsl:if test="string-length(numberingtitle) &gt; 0 or string-length(title) &gt; 0">
                                    <li>
                                        <a class="contents-link">
                                            <xsl:choose>
                                                <xsl:when test="string-length(@id) &gt; 0">
                                                    <xsl:attribute name="href">#<xsl:value-of select="@id"/>
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat('#schedule', position())"/>
                                                    </xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if test="@condition='optional'">[</xsl:if>
                                            <xsl:if test="string-length(numberingtitle) &gt; 0">
                                                <xsl:value-of select="numberingtitle"/>
                                            </xsl:if>
                                            <xsl:if test="not(string-length(numberingtitle) &gt; 0)">
                                                <xsl:value-of select="title"/>
                                            </xsl:if>
                                            <xsl:if test="@condition='optional'">]</xsl:if>
                                        </a>
                                    </li>
                                </xsl:if>
                            </xsl:for-each>
                        </ul>
                    </xsl:if>
                </div>

            </xsl:when>
            <xsl:otherwise>

                <div class="contents-heading">
                    Contents <!--<span class="hiddenScreenLink"> - <a href="javascript:void(0)" class="screenLink" onclick="contents()" id="contentsText">Hide contents</a></span>--> </div>
                <div id="contents">
                    <ol>
                        <xsl:for-each select="$nodeSet/operative/clause">
                            <xsl:if test="string-length(title) &gt; 0">
                                <li>
                                    <a class="contents-link">
                                        <xsl:choose>
                                            <xsl:when test="string-length(@id) &gt; 0">
                                                <xsl:attribute name="href">#<xsl:value-of select="@id"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat('#clause', position())"/>
                                                </xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="@condition='optional'">[</xsl:if>
                                        <xsl:value-of select="title" disable-output-escaping="yes"/>
                                        <xsl:if test="@condition='optional'">]</xsl:if>
                                    </a>
                                </li>
                            </xsl:if>
                        </xsl:for-each>
                    </ol>
                    <xsl:if test="count($nodeSet/schedule) &gt; 0">
                        <span>Schedules</span>
                        <ol>
                            <xsl:for-each select="$nodeSet/schedule">
                                <xsl:if test="string-length(title) &gt; 0 and name(.) = 'schedule'">
                                    <li>
                                        <a class="contents-link">
                                            <xsl:choose>
                                                <xsl:when test="string-length(@id) &gt; 0">
                                                    <xsl:attribute name="href">#<xsl:value-of select="@id"/>
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat('#schedule', position())"/>
                                                    </xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if test="@condition='optional'">[</xsl:if>
                                            <xsl:value-of select="title" disable-output-escaping="yes"/>
                                            <xsl:if test="@condition='optional'">]</xsl:if>
                                        </a>
                                    </li>
                                </xsl:if>
                            </xsl:for-each>
                        </ol>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- This template generates TOC for documents made of parts-->
    <xsl:template name="embeddedContents">
        <xsl:param name="nodeSet"/>
        <xsl:for-each select="$nodeSet">
            <xsl:variable name="resourceNumber" select="position()"/>
            <div class="contents-node">
                <img src="/presentation/images/common/noExpandTopic.gif" class="noExpandTopic"/>
                <a href="#part{position()}" class="contents-link">
                    <xsl:value-of select="title" disable-output-escaping="yes"/>
                </a>
            </div>
            <!-- don't do this if its a casetracker (5-103-0961) -->
            <xsl:if test="(count(xml/*/fulltext/section1[string-length(title) &gt; 0]) &gt; 0 or count(xml/*/fulltext[string-length(bridgehead) &gt; 0]) &gt; 0) and $casetracker=false()">
                <div class="sub-contents">
                    <xsl:for-each select="xml/*/fulltext/child::*">
                        <xsl:choose>
                            <xsl:when test="local-name(.) = 'add'">
                                <xsl:call-template name="contentsItems">
                                    <xsl:with-param select="child::node()" name="nodes"/>
                                    <xsl:with-param name="resourceCount" select="$resourceNumber"/>
                                    <xsl:with-param name="isEmbedded" select="'true'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="contentsItems">
                                    <xsl:with-param select="." name="nodes"/>
                                    <xsl:with-param name="resourceCount" select="$resourceNumber"/>
                                    <xsl:with-param name="isEmbedded" select="'true'"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="contentsItems">
        <xsl:param name="nodes"/>
        <xsl:param name="resourceCount" select="1"/>
        <xsl:param name="isEmbedded" select="'false'"/>

        <xsl:if test="$isEmbedded = 'false'">
            <xsl:if test="local-name($nodes) = 'bridgehead'">
                <div class="contents-node-bridge">
                    <img src="/presentation/images/common/noExpandTopic.gif" class="noExpandTopic"/>
                    <xsl:variable name="anchorId">
                        <xsl:choose>
                            <xsl:when test="@id">
                                <xsl:value-of select="@id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('sect1pos', position(), 'res', $resourceCount)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <a href="#{$anchorId}" class="contents-link">
                        <xsl:value-of select="normalize-space(.)"/>
                    </a>
                </div>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($nodes/title)) &gt; 0">
                <div class="contents-node">
                    <img src="/presentation/images/common/noExpandTopic.gif" class="noExpandTopic"/>
                    <xsl:variable name="anchorId">
                        <xsl:choose>
                            <xsl:when test="@id">
                                <xsl:value-of select="@id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('sect1pos', position(), 'res', $resourceCount)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <a href="#{$anchorId}" class="contents-link">
                        <xsl:for-each select="$nodes/title/node()[not (local-name(.)='del')]">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </a>
                </div>
            </xsl:if>

            <xsl:if test="count($nodes/section2[string-length(title) &gt; 0])">
                <div class="sub-contents">
                    <xsl:for-each
                            select="$nodes/child::*[local-name(.) = 'section2' or local-name(child::*) = 'section2']">
                        <xsl:if test="string-length(title) &gt; 0 or string-length(child::section2/title) &gt; 0 ">
                            <xsl:variable name="sect2Node" select="child::section2"/>
                            <xsl:variable name="anchorIdSect2">
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
                            <xsl:variable name="titleSect2">
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
                            </xsl:variable>
                            <div class="contents-node">
                                <img src="/presentation/images/common/listBullet.gif" class="subTopicListBullet"/>
                                <a href="#{$anchorIdSect2}" class="contents-link">
                                    <xsl:value-of select="$titleSect2"/>
                                </a>
                            </div>
                        </xsl:if>
                    </xsl:for-each>
                </div>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$isEmbedded = 'true'">
            <xsl:if test="local-name($nodes) = 'bridgehead'">
                <div class="contents-node-bridge">
                    <img src="/presentation/images/common/noExpandTopic.gif" class="noExpandTopic"/>
                    <xsl:variable name="anchorId">
                        <xsl:choose>
                            <xsl:when test="@id">
                                <xsl:value-of select="@id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('sect1pos', position(), 'res', $resourceCount)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <a href="#{$anchorId}" class="contents-link">
                        <xsl:value-of select="normalize-space(.)"/>
                    </a>
                </div>
            </xsl:if>
            <xsl:if test="string-length($nodes/title) &gt; 0">
                <div class="contents-node">
                    <img src="/presentation/images/common/listBullet.gif" class="subTopicListBullet"/>
                    <xsl:variable name="anchorId">
                        <xsl:choose>
                            <xsl:when test="@id">
                                <xsl:value-of select="@id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- sc 11/01/2010 - modified predicate to match the actual output anchor. -->
                                <!--<xsl:value-of select="concat('sect1pos', count(preceding::*[(local-name(.) = 'section1' or local-name(.) = 'bridgehead') and not(ancestor::revdescription)])+1, 'res', $resourceCount)" />-->
                                <xsl:value-of
                                        select='concat( "sect1pos", count(preceding::*[(local-name(.) = "section1" or local-name(.) = "bridgehead") and not(ancestor::revdescription)])+1, "res", count(ancestor::embeddedResource/preceding-sibling::embeddedResource)+1)'/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <a href="#{$anchorId}" class="contents-link">
                        <xsl:for-each select="title/node()[not (local-name(.)='del')]">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </a>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="qandaContents">
        <xsl:param name="nodeSet"/>
        <xsl:for-each select="$nodeSet/section1">
            <xsl:call-template name="contentsItems">
                <xsl:with-param select="." name="nodes"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- This template displays contents for PLCDTD documents inlcuding documents based on the PRECEDENT class -->
</xsl:stylesheet>