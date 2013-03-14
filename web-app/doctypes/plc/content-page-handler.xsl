<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
        >
    <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                get-XX-section Contents Templates
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
    <xsl:template name="get-main-contents-page">
        <fo:page-sequence master-reference="firstA4" master-name="layout"
                          force-page-count="no-force" format="i">
            <!-- Print Region Before-->
            <xsl:call-template name="get-region-before-block">
                <xsl:with-param name="block-title" select="'Contents'"/>
            </xsl:call-template>
            <!-- Print Region After-->
            <fo:static-content flow-name="xsl-region-after">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block space-before="8pt" text-align="center" font-size="9pt"
                                          font-family="'News Gothic MT, sans-serif'">
                                    <fo:page-number/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <!--Print Region Body-->
            <fo:flow flow-name="xsl-region-body">
                <fo:block border="thin black solid" text-align="left" width="150mm" height="100mm" margin-top="1cm"
                          margin-bottom="1cm" padding="0.5cm 0.5cm">
                    <fo:block border="thin" font-size="15pt" font-family="'News Gothic MT'">
                        <xsl:text>Contents</xsl:text>
                    </fo:block>
                    <xsl:call-template name="add-newlines">
                        <xsl:with-param name="newline-count" select="4"/>
                    </xsl:call-template>
                </fo:block>
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="2"/>
                </xsl:call-template>
                <!--Get Index-->
                <xsl:call-template name="print-complete-content-set"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <xsl:template name="get-individual-contents-page">
        <xsl:param name="sectionid"/>
        <xsl:variable name="sectiontitle">
            <xsl:choose>
                <xsl:when test="$sectionid = 1">
                    <xsl:text>Practice Notes</xsl:text>
                </xsl:when>
                <xsl:when test="$sectionid = 2">
                    <xsl:text>Documents</xsl:text>
                </xsl:when>
                <xsl:when test="$sectionid = 3">
                    <xsl:text>Checklists</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="blockid">
            <xsl:choose>
                <xsl:when test="$sectionid = 1">
                    <xsl:text>pnotes</xsl:text>
                </xsl:when>
                <xsl:when test="$sectionid = 2">
                    <xsl:text>sdocs</xsl:text>
                </xsl:when>
                <xsl:when test="$sectionid = 3">
                    <xsl:text>chklists</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <fo:page-sequence master-reference="firstA4" master-name="layout"
                          force-page-count="no-force" initial-page-number="1" format="1">
            <!-- Print Region Before-->
            <xsl:call-template name="get-region-before-block"/>
            <fo:static-content flow-name="xsl-region-after">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block space-before="8pt" text-align="center" font-size="9pt"
                                          font-family="'News Gothic MT, sans-serif'">
                                    <xsl:value-of select="$sectionid"/>
                                    <xsl:text>.</xsl:text>
                                    <fo:page-number/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <fo:block border="thin black solid" text-align="left" width="150mm" height="100mm"
                          margin-top="1cm" margin-bottom="1cm" padding="0.5cm 0.5cm">
                    <fo:block id="{$blockid}" border="thin" font-size="15pt" font-family="'News Gothic MT'">
                        <xsl:value-of select="$sectiontitle"/>
                    </fo:block>
                    <xsl:call-template name="add-newlines">
                        <xsl:with-param name="newline-count" select="4"/>
                    </xsl:call-template>
                </fo:block>
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="2"/>
                </xsl:call-template>
                <!-- Get Index -->
                <xsl:call-template name="print-individual-content-set">
                    <xsl:with-param name="header">
                        <xsl:choose>
                            <xsl:when test="$sectionid = 1">
                                <xsl:text>Note</xsl:text>
                            </xsl:when>
                            <xsl:when test="$sectionid = 2">
                                <xsl:text>Document</xsl:text>
                            </xsl:when>
                            <xsl:when test="$sectionid = 3">
                                <xsl:text>Checklist</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                print-XX-content-set  Templates
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
    <xsl:template name="print-complete-content-set">
        <!-- keep-together.within-page="auto"-->
        <fo:block text-align="left" width="150mm" height="100mm" padding="0.5cm 0.5cm" margin-top="0.5cm">
            <fo:table>
                <fo:table-column column-width="100mm" column-number="1"/>
                <fo:table-column column-number="2"/>
                <fo:table-column column-number="3"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold" font-size="12pt" font-family="'News Gothic MT, sans-serif'">
                                <xsl:text>Contents</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <fo:leader leader-pattern="space"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block font-weight="bold" font-size="12pt" font-family="'News Gothic MT, sans-serif'">
                                <xsl:text>Page</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <xsl:call-template name="add-newlines">
                                <xsl:with-param name="newline-count" select="1"/>
                            </xsl:call-template>
                        </fo:table-cell>
                        <fo:table-cell>
                            <xsl:call-template name="add-newlines">
                                <xsl:with-param name="newline-count" select="1"/>
                            </xsl:call-template>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="2"/>
            </xsl:call-template>
        </fo:block>
        <!--
 ________________________________________________________________
 
         Add Practice Notes Contents

________________________________________________________________

  -->
        <fo:block
                text-align="left"
                top="200mm"
                left="00mm"
                width="152mm"
                height="300mm"
                padding="0.5cm 0.5cm"
                font-size="9pt"
                font-family="'News Gothic MT, sans-serif'">
            <!-- Adding contents to the index page. -->
            <fo:block end-indent="0pt" last-line-end-indent="52.95pt" line-height="15.95pt"
                      start-indent="0pt" text-align="start" text-align-last="justify" text-indent="0pt">
                <fo:inline>
                    <fo:basic-link internal-destination="pnotes">
                        <fo:inline xsl:use-attribute-sets="titleindex">
                            <xsl:text>1. PRACTICE NOTES</xsl:text>
                        </fo:inline>
                    </fo:basic-link>
                    <fo:inline xsl:use-attribute-sets="titleindex">
                        <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                   leader-pattern="dots"/>
                    </fo:inline>
                    <fo:basic-link internal-destination="pnotes">
                        <fo:inline xsl:use-attribute-sets="titleindex">
                            <xsl:text>1.</xsl:text>
                            <fo:page-number-citation ref-id="pnotes"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:inline>
            </fo:block>
            <xsl:apply-templates select="practicenote" mode="index"/>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="3"/>
            </xsl:call-template>
        </fo:block>
        <!--
 ________________________________________________________________

         Add Standard Documents Contents

________________________________________________________________

  -->
        <fo:block
                text-align="left"
                top="200mm"
                left="00mm"
                width="152mm"
                height="300mm"
                padding="0.5cm 0.5cm"
                font-size="9pt"
                font-family="'News Gothic MT, sans-serif'">
            <!-- Adding contents to the index page. -->
            <fo:block end-indent="0pt" last-line-end-indent="52.95pt" line-height="15.95pt"
                      start-indent="0pt" text-align="start" text-align-last="justify" text-indent="0pt">
                <fo:inline>
                    <fo:basic-link internal-destination="pnotes">
                        <fo:inline xsl:use-attribute-sets="titleindex">
                            <xsl:text>2. Documents</xsl:text>
                        </fo:inline>
                    </fo:basic-link>
                    <fo:inline xsl:use-attribute-sets="titleindex">
                        <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                   leader-pattern="dots"/>
                    </fo:inline>
                    <fo:basic-link internal-destination="sdocs">
                        <fo:inline xsl:use-attribute-sets="titleindex">
                            <xsl:text>2.</xsl:text>
                            <fo:page-number-citation ref-id="sdocs"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:inline>
            </fo:block>
            <!--<xsl:apply-templates select="sdocs/practicenote" mode="index"/>-->
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="2"/>
            </xsl:call-template>
            <fo:block xsl:use-attribute-sets="titleindex">
                <xsl:text>STANDARD DOCUMENTS</xsl:text>
            </fo:block>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="2"/>
            </xsl:call-template>
            <fo:block>
                <xsl:apply-templates select="sdocs/precedent/metadata/title" mode="sdocsmainindex"/>
            </fo:block>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
            <fo:block font-size="8pt" font-style="italic">
                <xsl:text>* Each standard document is numbered individually</xsl:text>
            </fo:block>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="2"/>
            </xsl:call-template>
            <fo:block xsl:use-attribute-sets="titleindex">
                <xsl:text>DRAFTING NOTES</xsl:text>
            </fo:block>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
            <xsl:apply-templates select="dnotes/practicenote" mode="dnotesindex"/>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="3"/>
            </xsl:call-template>
        </fo:block>
        <!--
 ________________________________________________________________

         Add CheckList Notes Contents

________________________________________________________________

  -->
        <fo:block
                text-align="left"
                top="200mm"
                left="00mm"
                width="152mm"
                height="300mm"
                padding="0.5cm 0.5cm"
                font-size="9pt"
                font-family="'News Gothic MT, sans-serif'"
                >
            <fo:block end-indent="0pt" last-line-end-indent="52.95pt" line-height="15.95pt"
                      start-indent="0pt" text-align="start" text-align-last="justify" text-indent="0pt">
                <fo:inline>
                    <fo:basic-link internal-destination="chklists">
                        <fo:inline xsl:use-attribute-sets="titleindex">
                            <xsl:text>3. CHECKLISTS</xsl:text>
                        </fo:inline>
                    </fo:basic-link>
                    <fo:inline xsl:use-attribute-sets="titleindex">
                        <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                   leader-pattern="dots"/>
                    </fo:inline>
                    <fo:basic-link internal-destination="chklists">
                        <fo:inline xsl:use-attribute-sets="titleindex">
                            <xsl:text>3.</xsl:text>
                            <fo:page-number-citation ref-id="chklists"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:inline>
            </fo:block>
            <fo:block xsl:use-attribute-sets="titleindex"></fo:block>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
            <xsl:apply-templates select="checklist/practicenote" mode="index"/>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="3"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
    <xsl:template name="print-individual-content-set">
        <xsl:param name="header"/>
        <!-- keep-together.within-page="auto"-->
        <fo:block text-align="left" width="150mm" height="100mm" padding="0.5cm 0.5cm" margin-top="0.5cm">
            <fo:table>
                <fo:table-column column-width="100mm" column-number="1"/>
                <fo:table-column column-number="2"/>
                <fo:table-column column-number="3"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold" font-size="12pt" font-family="'News Gothic MT, sans-serif'">
                                <xsl:value-of select="$header"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <fo:leader leader-pattern="space"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block font-weight="bold" font-size="12pt" font-family="'News Gothic MT, sans-serif'">
                                <xsl:text>Page</xsl:text>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <xsl:call-template name="add-newlines">
                                <xsl:with-param name="newline-count" select="1"/>
                            </xsl:call-template>
                        </fo:table-cell>
                        <fo:table-cell>
                            <xsl:call-template name="add-newlines">
                                <xsl:with-param name="newline-count" select="1"/>
                            </xsl:call-template>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="2"/>
            </xsl:call-template>
        </fo:block>
        <!--
         Add Practice Notes Contents
        -->
        <fo:block break-after="page"
                  text-align="left"
                  top="200mm"
                  left="00mm"
                  width="152mm"
                  height="300mm"
                  padding="0.5cm 0.5cm"
                  font-size="9pt"
                  font-family="'News Gothic MT, sans-serif'">
            <!-- Adding contents to the index page. -->
            <xsl:choose>
                <xsl:when test="$header = 'Note'">
                    <xsl:apply-templates select="practicenote/metadata/title" mode="index">
                        <xsl:with-param name="caller" select="'pnotes-index'"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$header = 'Checklist'">
                    <xsl:apply-templates select="checklist/practicenote/metadata/title" mode="checklistindex">
                        <xsl:with-param name="caller" select="'pnotes-index'"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$header = 'Document'">
                    <xsl:call-template name="get-document-index"/>
                </xsl:when>
            </xsl:choose>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="3"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
    <xsl:template name="get-document-index">
        <fo:block>
            <fo:inline xsl:use-attribute-sets="section1index">
                <xsl:text>Standard documents</xsl:text>
            </fo:inline>
        </fo:block>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <xsl:apply-templates select="sdocs/precedent/metadata/title" mode="sdocsindex"/>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <fo:block>
            <fo:inline xsl:use-attribute-sets="section1index">
                <xsl:text>Drafting notes</xsl:text>
            </fo:inline>
        </fo:block>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <xsl:apply-templates select="dnotes/practicenote/metadata/title" mode="dnotesindex"/>
    </xsl:template>
    <xsl:template match="title" mode="dnotesindex">
        <xsl:variable name="refid" select="generate-id(parent::metadata/following-sibling::fulltext/section1)"/>
        <xsl:if test="string(normalize-space(text()))">
            <fo:block
                    end-indent="0pt"
                    last-line-end-indent="52.95pt"
                    line-height="15.95pt"
                    start-indent="0pt"
                    text-align="start"
                    text-align-last="justify"
                    text-indent="0pt">
                <fo:inline>
                    <fo:basic-link internal-destination="{$refid}">
                        <fo:inline xsl:use-attribute-sets="section1index">
                            <xsl:value-of select="concat(text(),':drafting note')"/>
                        </fo:inline>
                    </fo:basic-link>
                    <fo:inline xsl:use-attribute-sets="section1index">
                        <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                   leader-pattern="dots"/>
                    </fo:inline>
                    <fo:inline xsl:use-attribute-sets="section1index">
                        <fo:basic-link internal-destination="{$refid}">
                            <xsl:text>2.</xsl:text>
                            <fo:page-number-citation ref-id="{$refid}"/>
                        </fo:basic-link>
                    </fo:inline>
                </fo:inline>
            </fo:block>
        </xsl:if>
    </xsl:template>
    <xsl:template match="title" mode="checklistindex">
        <xsl:variable name="refid" select="generate-id(parent::metadata/following-sibling::fulltext/section1)"/>
        <xsl:if test="string(normalize-space(text()))">
            <fo:block
                    end-indent="0pt"
                    last-line-end-indent="52.95pt"
                    line-height="15.95pt"
                    start-indent="0pt"
                    text-align="start"
                    text-align-last="justify"
                    text-indent="0pt">
                <fo:inline>
                    <fo:basic-link internal-destination="{$refid}">
                        <fo:inline xsl:use-attribute-sets="section1index">
                            <xsl:value-of select="text()"/>
                        </fo:inline>
                    </fo:basic-link>
                    <fo:inline xsl:use-attribute-sets="section1index">
                        <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                   leader-pattern="dots"/>
                    </fo:inline>
                    <fo:basic-link internal-destination="{$refid}">
                        <fo:inline xsl:use-attribute-sets="section1index">
                            <xsl:text>3.</xsl:text>
                            <fo:page-number-citation ref-id="{$refid}"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:inline>
            </fo:block>
        </xsl:if>
    </xsl:template>
    <xsl:template name="get-glossary-contents">
        <fo:page-sequence master-reference="firstA4" master-name="layout" initial-page-number="1"
                          force-page-count="even">
            <fo:static-content flow-name="xsl-region-before">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block>
                                    <fo:external-graphic content-type="content-type:image/tiff"
                                                         src="d:\e3_work\images\input\logo.tif"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block space-before="20pt" text-align="right" font-size="9pt"
                                          font-family="'News Gothic MT'">
                                    <xsl:text>Glossary</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <fo:static-content flow-name="xsl-region-after">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block space-before="8pt" text-align="center" font-size="9pt"
                                          font-family="'News Gothic MT, sans-serif'">
                                    <fo:page-number/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <fo:block border="thin black solid" padding-left="0.5cm" padding-top="0.5cm" text-align="left"
                          width="150mm" height="100mm" margin-top="1cm" margin-bottom="1cm">
                    <!--<  0.7cm margin-left="1cm" margin-right="1cm"fo:block padding-left = "3cm" start-indent = "1cm" end-indent = "1cm" space-before="30pt" text-align="left" font-size="12pt" font-family="'News Gothic MT'">-->
                    <fo:block border="thin" font-size="15pt" font-family="'News Gothic MT'">
                        <xsl:text>Glossary</xsl:text>
                        <xsl:call-template name="add-newlines">
                            <xsl:with-param name="newline-count" select="5"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="5"/>
                </xsl:call-template>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
</xsl:stylesheet>