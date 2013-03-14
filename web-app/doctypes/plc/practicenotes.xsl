<?xml version='1.0'?>
<!--
========================================================================
Name:	SAMPLEFO.XSLAuthor:	Chris BeechamDescription:	Main stylesheet for transforming PLCDTD documents toPDF using xsl-foVersion: 1.3.2Last modified:	28.5.2003Known issues: Table spacing, bullet point positioning, left quotes. cb modified 28.4.2003added proportional widths for table columns       cb modified 10.11.2003changed filepaths to work on e3/metro
========================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
    <!--
========================================================================
         KEY FOR PLCXLINK
========================================================================
    -->
    <xsl:include href="attribute-sets.xsl"/>
    <xsl:include href="content-page-handler.xsl"/>
    <xsl:key match="//section1[@layout = 'box']" name="box-num" use="@id"/>
    <xsl:key match="//plcxlink" use="xlink:locator/@xlink:href" name="unique-xlinks"/>
    <xsl:key match="//section3[ancestor::dnotes]" name="section3-index" use="."/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="type" select="/*/metadata/type/plcxlink/*[1]"/>
    <xsl:param name="usetif">yes</xsl:param>
    <xsl:param name="usebox">yes</xsl:param>
    <xsl:param name="double.sided" select="1"/>
    <xsl:template match="volume">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="firstA4" page-width="21.0cm" page-height="29.7cm" margin-top="1.0cm"
                                       margin-left="3.4cm" margin-right="2.5cm">
                    <fo:region-before extent="1.5cm"/>
                    <fo:region-body margin-top="2.5cm" margin-bottom="2.0cm"/>
                    <fo:region-after extent="1.5cm"/>
                </fo:simple-page-master>
                <fo:simple-page-master master-name="A4" page-width="21.0cm" page-height="29.7cm" margin-top="1.0cm"
                                       margin-left="3.4cm" margin-right="2.5cm">
                    <fo:region-before extent="1.5cm"/>
                    <fo:region-body margin-top="2.5cm" margin-bottom="2.0cm"/>
                    <fo:region-after extent="1.5cm"/>
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="layout" initial-page-number="1" language="en" country="uk">
                    <fo:single-page-master-reference master-reference="firstA4"/>
                    <fo:repeatable-page-master-reference master-reference="A4"/>
                </fo:page-sequence-master>
            </fo:layout-master-set>
            <!--
            =========================================================================
                 PRINT THE CONTENTS    ( complete section with PNotes, Checklists etc )
            ==============================================================================
            -->
            <xsl:call-template name="get-main-contents-page"/>
            <!--
                =========================================================================
                     PRINT THE Contents for the Practice notes Section ( section1s only )
                ==============================================================================

             <xsl:call-template name="empty-page">
                <xsl:with-param name="page-number-format" select="'i'"/>

            </xsl:call-template>
            -->
            <!-- Print the Individual Content Page  and the main Articles -->
            <!--
             ____________________________________________________
             
               First Content- Section : Practice Notes

             ____________________________________________________
            
            -->
            <xsl:call-template name="get-individual-contents-page">
                <xsl:with-param name="sectionid" select="1"/>
            </xsl:call-template>
            <xsl:call-template name="empty-page">
                <xsl:with-param name="page-number-format" select="'1'"/>
                <xsl:with-param name="page-number-prefix" select="'1'"/>
            </xsl:call-template>
            <xsl:apply-templates select="practicenote"/>
            <!--
              ____________________________________________________
              
               Second  Content- Section : Standard Documents
              ____________________________________________________
              
            -->
            <xsl:call-template name="empty-page">
                <xsl:with-param name="page-number-format" select="'1'"/>
                <xsl:with-param name="page-number-prefix" select="'1'"/>
            </xsl:call-template>
            <xsl:call-template name="get-individual-contents-page">
                <xsl:with-param name="sectionid" select="2"/>
            </xsl:call-template>
            <xsl:call-template name="empty-page">
                <xsl:with-param name="page-number-format" select="'1'"/>
                <xsl:with-param name="page-number-prefix" select="'2'"/>
            </xsl:call-template>
            <xsl:apply-templates select="dnotes/practicenote"/>
            <!--
            ____________________________________________________

               Third   Content- Section : CheckLists
            ____________________________________________________

            -->
            <xsl:call-template name="get-individual-contents-page">
                <xsl:with-param name="sectionid" select="3"/>
            </xsl:call-template>
            <xsl:apply-templates select="checklist/practicenote"/>
            <!--
            ____________________________________________________

               Fourth   Content- Section : Glossary
            ____________________________________________________

            -->
            <xsl:call-template name="get-glossary-contents"/>
            <xsl:apply-templates select="glossary/glossitem"/>
        </fo:root>
    </xsl:template>
    <xsl:template name="get-region-before-block">
        <xsl:param name="block-title"/>
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
                                <xsl:value-of select="$block-title"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:static-content>
    </xsl:template>
    <xsl:template name="empty-page">
        <xsl:param name="page-number-format"/>
        <xsl:param name="page-number-prefix"/>
        <fo:page-sequence master-reference="firstA4" master-name="layout"
                          force-page-count="no-force" format="{$page-number-format}">
            <!-- Print Region Before-->
            <xsl:call-template name="get-region-before-block"/>
            <!-- Print Region After-->
            <fo:static-content flow-name="xsl-region-after">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block space-before="8pt" text-align="center" font-size="9pt"
                                          font-family="'News Gothic MT, sans-serif'">
                                    <xsl:if test="number($page-number-prefix) and string($page-number-prefix)">
                                        <xsl:value-of select="concat($page-number-prefix,'.')"/>
                                    </xsl:if>
                                    <fo:page-number/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <!--Print Region Body-->
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="1"/>
                </xsl:call-template>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <xsl:template match="glossitem">
        <fo:block text-align="justify" width="150mm">
            <xsl:apply-templates/>
        </fo:block>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="glossterm">
        <fo:inline font-weight="bold" font-style="italic">
            <xsl:value-of select="."/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="glossdef">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="qa">
        <xsl:apply-templates select="practicenote" mode="qa"/>
    </xsl:template>
    <xsl:template match="practicenote" mode="qa">
        <xsl:variable name="page-num-prefix">
            <xsl:choose>
                <xsl:when test="parent::checklist">
                    <xsl:text>3.</xsl:text>
                </xsl:when>
                <xsl:when test="parent::dnotes">
                    <xsl:text>2.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>1.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:layout-master-set>
            <fo:simple-page-master master-name="firstA4"
                                   page-width="21.0cm"
                                   page-height="29.7cm"
                                   margin-top="1.0cm"
                                   margin-left="3.4cm"
                                   margin-right="2.5cm">
                <fo:region-before extent="1.5cm"/>
                <fo:region-body margin-top="2.5cm" margin-bottom="2.0cm"/>
                <fo:region-after extent="1.5cm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="A4"
                                   page-width="21.0cm"
                                   page-height="29.7cm"
                                   margin-top="1.0cm"
                                   margin-left="3.4cm"
                                   margin-right="2.5cm">
                <fo:region-before extent="1.5cm"/>
                <fo:region-body margin-top="2.5cm"
                                margin-bottom="2.0cm"/>
                <fo:region-after extent="1.5cm"/>
            </fo:simple-page-master>
            <fo:page-sequence-master master-name="layout"
                                     initial-page-number="1" language="en" country="uk">
                <fo:single-page-master-reference master-reference="firstA4"/>
                <fo:repeatable-page-master-reference master-reference="A4"/>
            </fo:page-sequence-master>
        </fo:layout-master-set>
        <fo:page-sequence master-reference="firstA4" master-name="layout" force-page-count="even">
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
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="metadata/title"/>
                                    </fo:inline>
                                    <fo:inline>
                                        <xsl:value-of select="concat(' ',metadata/jurisdiction,' ')"/>
                                    </fo:inline>
                                    <fo:inline>
                                        <xsl:text>Country Questions</xsl:text>
                                    </fo:inline>
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
                                    <xsl:value-of select="$page-num-prefix"/>
                                    <fo:page-number/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <fo:block id="{generate-id(metadata/jurisdiction)}" border="thin black solid" text-align="left"
                          width="150mm" height="100mm" margin-top="1cm" margin-bottom="1cm" padding-top="0.5cm"
                          padding-left="0.5cm">
                    <fo:block border="thin" xsl:use-attribute-sets="MainHead">
                        <xsl:value-of select="metadata/title"/>
                        <fo:block xsl:use-attribute-sets="jurisHead">
                            <xsl:text>Country questions:</xsl:text>
                            <xsl:value-of select="metadata/jurisdiction"/>
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="Author">
                            <xsl:value-of select="metadata/author"/>
                        </fo:block>
                        <xsl:call-template name="add-newlines">
                            <xsl:with-param name="newline-count" select="1"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
                <fo:block text-align="left" width="150mm" height="100mm" margin-top="1cm" margin-bottom="1cm"
                          padding-top="0.5cm" padding-left="0.5cm">
                    <xsl:apply-templates select="*[not(self::metadata)]"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <xsl:template match="practicenote">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="firstA4"
                                   page-width="21.0cm"
                                   page-height="29.7cm"
                                   margin-top="1.0cm"
                                   margin-left="3.4cm"
                                   margin-right="2.5cm">
                <fo:region-before extent="1.5cm"/>
                <fo:region-body margin-top="2.5cm" margin-bottom="2.0cm"/>
                <fo:region-after extent="1.5cm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="A4"
                                   page-width="21.0cm"
                                   page-height="29.7cm"
                                   margin-top="1.0cm"
                                   margin-left="3.4cm"
                                   margin-right="2.5cm">
                <fo:region-before extent="1.5cm"/>
                <fo:region-body margin-top="2.5cm"
                                margin-bottom="2.0cm"/>
                <fo:region-after extent="1.5cm"/>
            </fo:simple-page-master>
            <fo:page-sequence-master master-name="layout"
                                     language="en" country="uk">
                <fo:single-page-master-reference master-reference="firstA4"/>
                <fo:repeatable-page-master-reference master-reference="A4"/>
            </fo:page-sequence-master>
        </fo:layout-master-set>
        <fo:page-sequence master-reference="firstA4" master-name="layout" force-page-count="no-force" format="1">
            <xsl:if test="parent::checklist and count(preceding-sibling::practicenote) =0">
                <xsl:attribute name="initial-page-number">
                    <xsl:text>1</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="page-num-prefix">
                <xsl:choose>
                    <xsl:when test="parent::checklist">
                        <xsl:text>3.</xsl:text>
                    </xsl:when>
                    <xsl:when test="parent::dnotes">
                        <xsl:text>2.</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
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
                                <fo:block id="{generate-id()}" space-before="20pt" text-align="right" font-size="9pt"
                                          font-family="'News Gothic MT'">
                                    <fo:inline>
                                        <xsl:value-of select="metadata/title"/>
                                    </fo:inline>
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
                                    <xsl:value-of select="$page-num-prefix"/>
                                    <fo:page-number/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <xsl:apply-templates select="metadata"/>
                <xsl:apply-templates select="fulltext"/>
            </fo:flow>
        </fo:page-sequence>
        <!--
         Qa must have a separate page sequence.
        -->
        <xsl:apply-templates select="qa"/>
    </xsl:template>
    <xsl:template match="practicenote" mode="index">
        <!-- Loop all practice notes children -->
        <xsl:apply-templates select="metadata/title" mode="index"/>
        <xsl:apply-templates select="fulltext//section1" mode="index"/>
        <!--<xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        -->
        <!-- Loop all question-answer sections -->
        <xsl:apply-templates select="qa/section1" mode="index"/>
        <xsl:apply-templates select="qa/practicenote" mode="index"/>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="practicenote" mode="dnotesindex">
        <!-- Loop all practice notes children -->
        <xsl:apply-templates select="metadata/title" mode="index"/>
        <xsl:apply-templates select="fulltext//*" mode="index"/>
        <!--<xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template> -->
    </xsl:template>
    <xsl:template match="practicenote[parent::qa]" mode="index">
        <xsl:apply-templates select="metadata/jurisdiction" mode="index"/>
    </xsl:template>
    <xsl:template match="section1[parent::qa]" mode="index">
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <fo:block>
            <fo:inline xsl:use-attribute-sets="section1qaindex">
                <xsl:value-of select="title"/>
            </fo:inline>
        </fo:block>
    </xsl:template>
    <xsl:template match="*" mode="index"/>
    <xsl:template match="section1|section2|title[parent::metadata]|jurisdiction[parent::metadata]|bridgehead"
                  mode="index">
        <xsl:param name="caller"/>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$caller = 'pnotes-index'">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="self::title">
                    <xsl:value-of select="translate(.,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:when>
                <xsl:when test="self::section1 and ancestor::checklist">
                    <xsl:value-of select="translate(title,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:when>
                <xsl:when test="self::section1 and ancestor::dnotes">
                    <xsl:value-of select="translate(title,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:when>
                <xsl:when test="self::section1 and section2">
                    <xsl:value-of select="translate(title,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:when>
                <xsl:when test="self::jurisdiction">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="self::bridgehead">
                    <xsl:value-of select="translate(.,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="page-num-prefix">
            <xsl:choose>
                <xsl:when test="ancestor::checklist">
                    <xsl:text>3.</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor::dnotes">
                    <xsl:text>2.</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor::sdocs"/>
                <xsl:otherwise>
                    <xsl:text>1.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="refid" select="generate-id()"/>
        <xsl:if test="string(normalize-space($title))">
            <xsl:if test="self::title">
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="1"/>
                </xsl:call-template>
            </xsl:if>
            <!--
                        =========================================================================
                             Block to print the titles and their page numbers.
                        =========================================================================
                        -->
            <fo:block
                    end-indent="0pt"
                    last-line-end-indent="52.95pt"
                    line-height="15.95pt"
                    start-indent="0pt"
                    text-align="start"
                    text-align-last="justify"
                    text-indent="0pt">
                <!-- setting the fo:inline properties based on the conditions below -->
                <xsl:choose>
                    <xsl:when test="$caller = 'pnotes-index'">
                        <fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="section1pnotesindex">
                                    <xsl:value-of select="$title"/>
                                </fo:inline>
                            </fo:basic-link>
                            <fo:inline xsl:use-attribute-sets="section1pnotesindex">
                                <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                           leader-pattern="dots"/>
                            </fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="section1pnotesindex">
                                    <xsl:value-of select="$page-num-prefix"/>
                                    <fo:page-number-citation ref-id="{$refid}"/>
                                </fo:inline>
                            </fo:basic-link>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="self::bridgehead or self::section1 or self::jurisdiction">
                        <fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="section1index">
                                    <xsl:value-of select="$title"/>
                                </fo:inline>
                            </fo:basic-link>
                            <fo:inline xsl:use-attribute-sets="section1index">
                                <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                           leader-pattern="dots"/>
                            </fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="section1index">
                                    <xsl:value-of select="$page-num-prefix"/>
                                    <fo:page-number-citation ref-id="{$refid}"/>
                                </fo:inline>
                            </fo:basic-link>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="self::section2">
                        <fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="section2index">
                                    <xsl:value-of select="$title"/>
                                </fo:inline>
                            </fo:basic-link>
                            <fo:inline xsl:use-attribute-sets="section2index">
                                <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                           leader-pattern="dots"/>
                            </fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="section2index">
                                    <xsl:value-of select="$page-num-prefix"/>
                                    <fo:page-number-citation ref-id="{$refid}"/>
                                </fo:inline>
                            </fo:basic-link>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="self::title">
                        <fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="titleindex">
                                    <xsl:value-of select="$title"/>
                                </fo:inline>
                            </fo:basic-link>
                            <fo:inline xsl:use-attribute-sets="titleindex">
                                <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                           leader-pattern="dots"/>
                            </fo:inline>
                            <fo:basic-link internal-destination="{$refid}">
                                <fo:inline xsl:use-attribute-sets="titleindex">
                                    <xsl:value-of select="$page-num-prefix"/>
                                    <fo:page-number-citation ref-id="{$refid}"/>
                                </fo:inline>
                            </fo:basic-link>
                        </fo:inline>
                    </xsl:when>
                </xsl:choose>

            </fo:block>
            <!-- Title of each practice note has a newline after it -->
            <xsl:if test="self::title">
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="1"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="section2[not(ancestor::qa)]" mode="index"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="title[ancestor::checklist]" mode="index">
        <xsl:variable name="refid" select="generate-id(parent::metadata/following-sibling::fulltext/section1)"/>
        <xsl:if test="string(normalize-space(text()))">
            <fo:block end-indent="0pt" last-line-end-indent="52.95pt" line-height="15.95pt"
                      start-indent="0pt" text-align="start" text-align-last="justify" text-indent="0pt">
                <fo:inline>
                    <fo:basic-link internal-destination="{$refid}">
                        <fo:inline xsl:use-attribute-sets="checklisttitleindex">
                            <xsl:value-of
                                    select="translate(text(),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                        </fo:inline>
                    </fo:basic-link>
                    <fo:inline xsl:use-attribute-sets="checklisttitleindex">
                        <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                                   leader-pattern="dots"/>
                    </fo:inline>
                    <fo:basic-link internal-destination="{$refid}">
                        <fo:inline xsl:use-attribute-sets="checklisttitleindex">
                            <xsl:text>3.</xsl:text>
                            <fo:page-number-citation ref-id="{$refid}"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:inline>
            </fo:block>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="section1[@layout ='box']" mode="index"/>
    <xsl:template match="section2[parent::section1/@layout ='box']" mode="index"/>
    <xsl:template match="section3[ancestor::section1/@layout ='box']" mode="index"/>
    <!--
========================================================================
     TOP LEVEL
========================================================================
      -->
    <xsl:template match="metadata">
        <fo:block id="{generate-id(title)}" border="thin black solid"
                  text-align="left" width="150mm" height="100mm" margin-top="1cm"
                  margin-bottom="1cm" padding-top="0.5cm" padding-left="0.5cm">
            <fo:block border="thin" xsl:use-attribute-sets="MainHead">
                <xsl:value-of select="title"/>
            </fo:block>
            <!--
            print abstract
            -->
            <fo:block xsl:use-attribute-sets="Abstract">
                <xsl:value-of select="abstract"/>
            </fo:block>
            <!--

               print Author
            -->
            <fo:block xsl:use-attribute-sets="Author">
                <xsl:value-of select="author"/>
            </fo:block>
            <!--

               print Contributor
            -->
            <xsl:if test="string(contributor)">
                <fo:block xsl:use-attribute-sets="Author">
                    <xsl:value-of select="contributor"/>
                </fo:block>
            </xsl:if>
            <fo:block xsl:use-attribute-sets="Reference">
                <!--Reference:-->
                <xsl:choose>
                    <xsl:when test="ancestor::checklist">
                        <fo:block xsl:use-attribute-sets="sect2title">
                            <xsl:text>Checklist</xsl:text>
                            <xsl:call-template name="add-newlines">
                                <xsl:with-param name="newline-count" select="6"/>
                            </xsl:call-template>
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="add-newlines">
                            <xsl:with-param name="newline-count" select="3"/>
                        </xsl:call-template>
                        <xsl:if test="../resourceid">
                            <fo:inline font-style="italic">
                                <xsl:text>www.practicallaw.com/</xsl:text>
                                <xsl:value-of select="concat('A',../resourceid)"/>
                            </fo:inline>
                        </xsl:if>
                        <xsl:call-template name="add-newlines">
                            <xsl:with-param name="newline-count" select="4"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </fo:block>
    </xsl:template>
    <!--
========================================================================
     MAIN RULE INCLUDES FOOTER BOLOCK
========================================================================
-->
    <xsl:template match="fulltext">
        <!--
========================================================================
     MAIN BLOCK
========================================================================
-->
        <xsl:apply-templates/>
        <!--
========================================================================
     ARTICLE INFO
========================================================================
-->
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="5"/>
        </xsl:call-template>
        <fo:block xsl:use-attribute-sets="articleinfo">
            <xsl:text>The Law is stated as at </xsl:text>
            <xsl:value-of select="preceding-sibling::metadata/datevalid"/>
            <xsl:text>.</xsl:text>
            <xsl:text>This practice note is also available online at http://www.practicallaw.com/A</xsl:text>
            <xsl:value-of select="../metadata/resourceid"/>
            <xsl:text>.</xsl:text>
            <xsl:text>The online version is updated as developments occur and contains links to the other </xsl:text>
            <xsl:text>relevant information and resources. For further information, please call +44 20 7202 1200.</xsl:text>
        </fo:block>
    </xsl:template>
    <!--
========================================================================
   SECTION
========================================================================
-->
    <xsl:template match="section1">
        <!--
        space-before="8pt"  space-after="8pt"    keep-together.within-page="always"
    -->
        <fo:block id="{generate-id()}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section2|section3">
        <fo:block space-before="8pt" space-after="8pt" id="{generate-id()}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section2[ancestor::qandaentry]|section3[ancestor::qandaentry]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="section1[ancestor::checklist]">
        <xsl:if test="not(preceding-sibling::section1[ancestor::checklist])">
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="4"/>
            </xsl:call-template>
        </xsl:if>
        <!--
              keep-with-next.within-page="always"
        -->
        <fo:block xsl:use-attribute-sets="sect1title" id="{generate-id()}">
            <xsl:apply-templates select="title"/>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
        </fo:block>
        <xsl:apply-templates select="*[not(self::title)]"/>
    </xsl:template>
    <xsl:template match="section1[ancestor::checklist][title]">
        <xsl:if test="not(preceding-sibling::section1[ancestor::checklist])">
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="4"/>
            </xsl:call-template>
        </xsl:if>
        <!--
              keep-with-next.within-page="always"
        -->
        <fo:block xsl:use-attribute-sets="sect1title" id="{generate-id()}">
            <xsl:number value="count(preceding-sibling::section1[title])+1" format="A"/>
            <xsl:text>. </xsl:text>
            <xsl:apply-templates select="title"/>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
        </fo:block>
        <fo:block keep-with-previous.within-page="always">
            <xsl:apply-templates select="*[not(self::title)]"/>
        </fo:block>
    </xsl:template>
    <!--
        ========================================================================
           PARA
        ========================================================================
        -->
    <xsl:template
            match="para[parent::entry][not[(ancestor::*/@rowstyle='bglightblue') or (ancestor::*/@rowstyle='headblue')]]">
        <fo:block xsl:use-attribute-sets="CellBodyAlign">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!-- although in theory bglightblue shouldn't be left aligned, apppear to be doing this on the webso am doing the same here for consistency -->
    <xsl:template match="para[parent::entry][(ancestor::*/@rowstyle='bglightblue')]">
        <fo:block xsl:use-attribute-sets="CellBodyAlign">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry][(ancestor::*/@rowstyle='headblue')]">
        <fo:block xsl:use-attribute-sets="CellBody">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry/@entrystyle='headblue']">
        <fo:block xsl:use-attribute-sets="CellBody">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry][ancestor::table/@tabstyle='TableSmall']">
        <fo:block xsl:use-attribute-sets="CellBodySmall">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry][ancestor::thead]">
        <fo:block xsl:use-attribute-sets="CellHead">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section1[@layout='box']/para">
        <fo:block id="{@id}" text-align="left" width="150mm" margin-top="1cm" margin-bottom="1cm">
            <fo:block xsl:use-attribute-sets="Body" text-align="left" text-indent="0.5cm">
                <xsl:apply-templates/>
            </fo:block>
        </fo:block>
        <xsl:if test="following-sibling::table">
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newfline-count" select="1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="para">
        <fo:block xsl:use-attribute-sets="Body">
            <xsl:choose>
                <xsl:when test="graphic or preceding-sibling::*[1][self::title]">
                    <xsl:attribute name="keep-with-previous.within-page">
                        <xsl:text>always</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="parent::entry">
                        <xsl:attribute name="keep-together.within-page">
                            <xsl:text>always</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </fo:block>
        <xsl:if test="following-sibling::table">
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--    rule-style="solid" rule-thickness="1cm"-->
    <xsl:template match="para[ancestor::question]">
        <fo:block>
            <fo:leader leader-pattern="rule" leader-length="15cm" rule-thickness="0.2px"/>
        </fo:block>
        <fo:block keep-with-previous.within-page="always" xsl:use-attribute-sets="Body">
            <fo:inline font-weight="bold">
                <xsl:number format="1. " value="count(ancestor::qandaentry/preceding-sibling::qandaentry)+1"/>
                <xsl:apply-templates/>
            </fo:inline>
        </fo:block>
        <fo:block keep-with-previous.within-page="always">
            <fo:leader leader-pattern="rule" leader-length="15cm" rule-thickness="0.2px"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[contains(plcxlink/xlink:locator,'see Question')]">
        <!--
      What are we doing here???
      some para nodes have the value of  plcxlink/xlink:locator as see Question x ( x= 1,2,3, etc.)...
      If there are consequitive para nodes that have this value, then we print (see Questions :1,2,3 and 4 ).
      for 4 paras with that value. if there is only one then we print (see Question 1).
      The following code does that!!!
       -->
        <xsl:choose>
            <xsl:when test="count(preceding-sibling::para[contains(plcxlink/xlink:locator,'see Question')])>0"/>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="Body">
                    <xsl:text>(see Question</xsl:text>
                    <xsl:if test="following-sibling::para[contains(plcxlink/xlink:locator,'see Question')]">
                        <xsl:text>s :</xsl:text>
                    </xsl:if>
                    <xsl:value-of
                            select="substring-before(substring-after(normalize-space(plcxlink/xlink:locator),'see Question'),')')"/>
                    <xsl:for-each select="following-sibling::para[contains(plcxlink/xlink:locator,'see Question')]">

                        <!-- Add punctuations -->
                        <xsl:if test="position()=1 and not(position = last()-1) and not(position()=last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="position()=last()">
                            <xsl:text> and</xsl:text>
                        </xsl:if>


                        <!-- End of punctuations -->

                        <!-- Add the content-->
                        <xsl:value-of
                                select="substring-before(substring-after(normalize-space(plcxlink/xlink:locator),'see Question'),')')"/>


                        <!-- Add punctuations -->
                        <xsl:if test="position() = last()-1">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>).</xsl:text>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="para[ancestor::answer]">
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <fo:block keep-with-previous.within-page="always">
            <fo:inline>
                <xsl:apply-templates/>
            </fo:inline>
        </fo:block>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="para[parent::listitem/parent::itemizedlist][ancestor::entry]">
        <fo:inline keep-together.within-page="always">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="para[parent::listitem[parent::itemizedlist]][not(ancestor::entry)]">
        <xsl:if test="string(normalize-space(text())) or child::*">
            <fo:block xsl:use-attribute-sets="Body" text-align="justify" text-indent="1px">
                <!-- add bullets -->
                <xsl:choose>
                    <xsl:when test="contains(plcxlink/xlink:locator,'see Question')">
                        <xsl:choose>
                            <xsl:when
                                    test="count(parent::listitem/preceding-sibling::listitem/para[contains(plcxlink/xlink:locator,'see Question')])>0"/>
                            <xsl:otherwise>
                                <!--

                                   Add the bullets
                                -->
                                <xsl:choose>
                                    <xsl:when test="graphic">
                                        <xsl:attribute name="keep-with-previous.within-page">
                                            <xsl:text>always</xsl:text>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="following-sibling::para[1][graphic]"/>
                                    <xsl:otherwise>
                                        <xsl:text>&#x2022; </xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--
                                   Add see questions.. see the comment on template
                                   <xsl:template match="para[contains(plcxlink/xlink:locator,'see Question')]">
                                -->
                                <xsl:text>(see Question</xsl:text>
                                <xsl:if test="parent::listitem/following-sibling::listitem/para[contains(plcxlink/xlink:locator,'see Question')]">
                                    <xsl:text>s :</xsl:text>
                                </xsl:if>
                                <xsl:value-of
                                        select="substring-before(substring-after(normalize-space(plcxlink/xlink:locator),'see Question'),')')"/>
                                <xsl:for-each
                                        select="parent::listitem/following-sibling::listitem/para[contains(plcxlink/xlink:locator,'see Question')]">
                                    <xsl:if test="position()=1">,</xsl:if>
                                    <xsl:if test="not(position = last()-1) and not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of
                                            select="substring-before(substring-after(normalize-space(plcxlink/xlink:locator),'see Question'),')')"/>
                                    <xsl:if test="position() = last()-1">
                                        <xsl:text> and </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:text>).</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--

                       Add the bullets

                    -->
                        <xsl:choose>
                            <xsl:when test="graphic">
                                <xsl:attribute name="keep-with-previous.within-page">
                                    <xsl:text>always</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="following-sibling::para[1][graphic]"/>
                            <xsl:otherwise>
                                <xsl:text>&#x2022; </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:if>
    </xsl:template>
    <xsl:template match="para[parent::listitem[parent::itemizedlist]][ancestor::checklist]">
        <fo:block xsl:use-attribute-sets="Body" text-align="justify" text-indent="1px">
            <xsl:if test="count(preceding-sibling::para)=0
					   and
					   count(parent::listitem/preceding-sibling::listitem) = 0
					   and ancestor::itemizedlist/preceding-sibling::*[1][self::title]">
                <!--
                          if the current para is the first para child of

                          list item  and the parent list item is the first listitem child of its

                          parent   itemizedlist and if there is a title node before the itemizedlist
                          node then the current para must allways be with the title.
                       -->
                <xsl:attribute name="keep-with-previous.within-page">
                    <xsl:text>always</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="ancestor::listitem[ancestor::listitem]">
                    <xsl:text>&#x2022; </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number value="count(parent::listitem/preceding-sibling::listitem)+1" format="1"/>
                    <xsl:text>. </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::abstract]">
        <fo:block xsl:use-attribute-sets="Abstract">
            <xsl:if test="graphic">
                <xsl:attribute name="keep-with-previous.within-page">
                    <xsl:text>always</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::glossdef]">
        <xsl:apply-templates/>
    </xsl:template>
    <!--
========================================================================
     METADATA AND DOC START
========================================================================
-->
    <xsl:template match="author[parent::metadata]"></xsl:template>
    <xsl:template match="contributor[parent::metadata]"></xsl:template>
    <xsl:template match="metadata/abstract"></xsl:template>
    <xsl:template match="metadata/datecreated"></xsl:template>
    <xsl:template match="metadata/datevalid"></xsl:template>
    <xsl:template match="metadata/resourceid"></xsl:template>
    <xsl:template match="metadata/identifier"></xsl:template>
    <xsl:template match="metadata/jurisdiction"></xsl:template>
    <xsl:template match="metadata/subject"></xsl:template>
    <xsl:template match="metadata/section"></xsl:template>
    <xsl:template match="metadata/relation"></xsl:template>
    <xsl:template match="metadata/dateexpiry"></xsl:template>
    <xsl:template match="metadata/type"></xsl:template>
    <!--
========================================================================
     HEADINGS
========================================================================
-->
    <xsl:template match="section1/title">
        <!--
         keep-with-next="always"
    -->
        <fo:block xsl:use-attribute-sets="sect1title">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="title[parent::section1[ancestor::checklist]]">
        <!--

        -->
        <fo:inline keep-with-next="always">
            <xsl:value-of select="translate(text(),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="section1[@layout='box']">
        <xsl:choose>
            <xsl:when test="$usebox='yes'"></xsl:when>
            <xsl:otherwise>
                <fo:block background-color="yellow">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="section2/title">
        <fo:block xsl:use-attribute-sets="sect2title">
            <xsl:if test="parent::section2/preceding-sibling::*[1][self::title]">
                <xsl:attribute name="keep-with-previous.within-page">
                    <xsl:text>always</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section2[ancestor::checklist]/title">
        <fo:block xsl:use-attribute-sets="sect1title">
            <xsl:if test="parent::section2/preceding-sibling::*[1][self::title]">
                <xsl:attribute name="keep-with-previous.within-page">
                    <xsl:text>always</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section3/title">
        <fo:block xsl:use-attribute-sets="sect3title" keep-with-next="always">
            <xsl:if test="parent::section3/preceding-sibling::*[1][self::title]">
                <xsl:attribute name="keep-with-previous.within-page">
                    <xsl:text>always</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section3[ancestor::checklist]/title">
        <fo:block xsl:use-attribute-sets="sect3title">
            <xsl:if test="parent::section3/preceding-sibling::*[1][self::title]">
                <xsl:attribute name="keep-with-previous.within-page">
                    <xsl:text>always</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="bridgehead">
        <!--<xsl:choose>
            <xsl:when test="attribute::renderas">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">
                            <xsl:value-of select="attribute::renderas"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>

            </xsl:otherwise>
        </xsl:choose>
        -->
        <fo:block id="{generate-id()}" xsl:use-attribute-sets="sect1title">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!--
========================================================================
     INLINE
========================================================================
-->
    <xsl:template match="emphasis[@role='bold']">
        <fo:inline xsl:use-attribute-sets="box-table">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="emphasis[@role='italic']">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
        <xsl:apply-templates select="plcxlink" mode="boxes"/>
    </xsl:template>
    <xsl:template match="plcxlink" mode="boxes">
        <xsl:choose>
            <xsl:when test="key('box-num',substring-after(xlink:locator/@xlink:href,'#'))">
                <xsl:variable name="preceding-text" select="preceding-sibling::text()[1]"/>
                <xsl:variable name="following-text" select="following-sibling::text()[1]"/>
                <xsl:choose>
                    <xsl:when test="normalize-space($preceding-text) = 'and'"/>
                    <xsl:when test="following-sibling::plcxlink"/>
                    <xsl:otherwise>
                        <xsl:text>).</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!--<xsl:value-of select = "following-sibling::text()"/>-->
                <xsl:if test="generate-id(.) = generate-id(key('unique-xlinks',xlink:locator/@xlink:href)[1])">
                    <xsl:apply-templates select="key('box-num',substring-after(xlink:locator/@xlink:href,'#'))"
                                         mode="boxes"/>
                </xsl:if>
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(' (www.practicallaw.com/a',xlink:locator/@xlink:href,')')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="plcxlink">
        <xsl:choose>
            <xsl:when test="contains (*[1]/attribute::*[1], '#')">
                <xsl:if test="not(generate-id(.) = generate-id(key('unique-xlinks',xlink:locator/@xlink:href)[1]))">
                    <fo:inline font-style="italic">
                        <xsl:text> above,</xsl:text>
                    </fo:inline>
                </xsl:if>
                <xsl:value-of select="*[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="*[1]"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="section1[table]" mode="boxes">
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <fo:block id="{@id}" border="thin black solid" text-align="left" width="150mm" border-color="#DDDDDD">
            <fo:block border="thin black solid" text-allign="justify" text-indent="0.5cm" font-size="9pt">
                <xsl:apply-templates/>
            </fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template match="section1" mode="boxes">
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
        <fo:block id="{@id}" border="thin black solid" text-align="left" width="150mm"
                  margin-top="1cm" margin-bottom="1cm" space-before="3cm" space-after="3cm" padding="0.5cm 0.5cm"
                  border-color="#DDDDDD">
            <fo:block font-size="9pt" border="thin">
                <xsl:apply-templates/>
            </fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template match="emphasis[@role='bold-italic']">
        <fo:inline font-style="italic" font-weight="bold">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <!--
========================================================================
             LISTS
========================================================================
        -->
    <xsl:template match="orderedlist|itemizedlist">
        <xsl:choose>
            <xsl:when test="ancestor::entry">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <!-- CB changed for 5.1 Taking out these attributes seems to make it display ok                -->
                <fo:block keep-with-previous.within-page="always">
                    <fo:list-block xsl:use-attribute-sets="ListMarker">
                        <!--<fo:block  space-before="6pt">-->
                        <xsl:apply-templates/>
                        <!--</fo:block>-->
                    </fo:list-block>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="listitem">
        <xsl:choose>
            <!--CB changed for 5.1				dont have block inside entry-->
            <xsl:when test="ancestor::entry">
                <fo:block keep-together.within-page="always">
                    <xsl:choose>
                        <xsl:when test="parent::itemizedlist">
                            <xsl:text>&#x2022;</xsl:text>
                        </xsl:when>
                        <xsl:when test="parent::orderedlist/attribute::numeration='upperalpha'">
                            <xsl:number format="A"/>
                        </xsl:when>
                        <xsl:when test="parent::orderedlist/attribute::numeration='loweralpha'">
                            <xsl:number format="a"/>
                        </xsl:when>
                        <xsl:when test="parent::orderedlist/attribute::numeration='upperroman'">
                            <xsl:number format="I"/>
                        </xsl:when>
                        <xsl:when test="parent::orderedlist/attribute::numeration='lowerroman'">
                            <xsl:number format="i"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:number format="1. "/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:list-item>
                    <fo:list-item-label start-indent="0.5cm" end-indent="label-end()">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="parent::itemizedlist[ancestor::checklist]"/>
                                <xsl:when test="parent::itemizedlist"/>
                                <xsl:when test="parent::orderedlist/attribute::numeration='upperalpha'">
                                    <xsl:number format="A"/>
                                </xsl:when>
                                <xsl:when test="parent::orderedlist/attribute::numeration='loweralpha'">
                                    <xsl:number format="a"/>
                                </xsl:when>
                                <xsl:when test="parent::orderedlist/attribute::numeration='upperroman'">
                                    <xsl:number format="I"/>
                                </xsl:when>
                                <xsl:when test="parent::orderedlist/attribute::numeration='lowerroman'">
                                    <xsl:number format="i"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <fo:inline>
                                        <xsl:text>.</xsl:text>
                                    </fo:inline>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="body-start()">
                        <xsl:apply-templates/>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
========================================================================
     TABLES
========================================================================
-->
    <xsl:template match="table|informaltable">
        <fo:block width="150mm" keep-with-previous.within-page="always">
            <fo:table-and-caption>
                <fo:table-caption></fo:table-caption>
                <fo:table>
                    <xsl:if test="@frame='all'">
                        <xsl:attribute name="border-left">solid</xsl:attribute>
                        <xsl:attribute name="border-right">solid</xsl:attribute>
                        <xsl:attribute name="border-top">solid</xsl:attribute>
                        <xsl:attribute name="border-bottom">solid</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@tabstyle='tableBorder tableShade'">
                        <xsl:attribute name="border-left">solid</xsl:attribute>
                        <xsl:attribute name="border-right">solid</xsl:attribute>
                        <xsl:attribute name="border-top">solid</xsl:attribute>
                        <xsl:attribute name="border-bottom">solid</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@tabstyle='tableBorder'">
                        <xsl:attribute name="border-left">solid</xsl:attribute>
                        <xsl:attribute name="border-right">solid</xsl:attribute>
                        <xsl:attribute name="border-top">solid</xsl:attribute>
                        <xsl:attribute name="border-bottom">solid</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor::section1[1]/@layout='box'">
                        <xsl:attribute name="background-color">white</xsl:attribute>
                        <xsl:attribute name="border-style">solid</xsl:attribute>
                        <xsl:attribute name="border-width">0.1pt</xsl:attribute>
                        <xsl:attribute name="border-color">#DDDDDD</xsl:attribute>
                        <xsl:attribute name="table-in-box">yes</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates/>
                </fo:table>
            </fo:table-and-caption>
        </fo:block>
        <xsl:call-template name="add-newlines">
            <xsl:with-param name="newline-count" select="1"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="tgroup">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="colspec[contains(attribute::colwidth,'%')]">
        <fo:table-column>
            <xsl:attribute name="column-width">
                <xsl:text>proportional-column-width(</xsl:text>
                <xsl:value-of select="substring-before(attribute::colwidth,'%')"/>
                <xsl:text>)</xsl:text>
            </xsl:attribute>
        </fo:table-column>
    </xsl:template>
    <xsl:template match="thead">
        <fo:table-header>
            <xsl:apply-templates/>
        </fo:table-header>
    </xsl:template>
    <xsl:template match="tbody">
        <fo:table-body>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>
    <xsl:template match="row">
        <xsl:if test="entry/@nameend">
            <fo:table-row>
                <xsl:apply-templates mode="space"/>
            </fo:table-row>
        </xsl:if>
        <fo:table-row>
            <xsl:choose>
                <xsl:when test="@rowstyle='headblueleft'">
                    <xsl:attribute name="background-color">blue</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="entry" mode="space">
        <fo:table-cell>
            <xsl:attribute name="number-columns-spanned">
                <xsl:call-template name="calculate.colspan"/>
            </xsl:attribute>
            <xsl:call-template name="add-newlines">
                <xsl:with-param name="newline-count" select="2"/>
            </xsl:call-template>
        </fo:table-cell>
    </xsl:template>
    <xsl:template match="entry">
        <fo:table-cell>
            <xsl:choose>
                <xsl:when test="ancestor::section1[1]/@layout='box'">
                    <xsl:attribute name="border-style">solid</xsl:attribute>
                    <xsl:attribute name="border-width">0.1pt</xsl:attribute>
                </xsl:when>
                <xsl:when test="ancestor::table/@tabstyle='TableShade'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="ancestor::table/@tabstyle='TableShadeBox'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="ancestor::table/@tabstyle='tableBorder tableShade'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='bglightblue'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='bglightblueleft'">
                    <xsl:attribute name="background-color">blue</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='bglightgreen'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='bgyellow'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="ancestor::table/@tabstyle='bgyellow'">
                    <xsl:attribute name="background-color">gray</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='headred'">
                    <xsl:attribute name="background-color">red</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='headblue'">
                    <xsl:attribute name="background-color">blue</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::row/@rowstyle='headgreen'">
                    <xsl:attribute name="background-color">green</xsl:attribute>
                </xsl:when>
                <xsl:when test="@entrystyle='headgreen'">
                    <xsl:attribute name="background-color">green</xsl:attribute>
                </xsl:when>
                <xsl:when test="@entrystyle='headblue'">
                    <xsl:attribute name="background-color">blue</xsl:attribute>
                </xsl:when>
                <xsl:when test="@entrystyle='headblueleft'">
                    <xsl:attribute name="background-color">blue</xsl:attribute>
                </xsl:when>
                <xsl:when test="@entrystyle='headred'">
                    <xsl:attribute name="background-color">red</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!-- need to calculate whether it spans more than one cell -->
            <xsl:if test="@namest">
                <xsl:attribute name="number-columns-spanned">
                    <xsl:call-template name="calculate.colspan"/>
                </xsl:attribute>
            </xsl:if>
            <!--
               If the table is in the box , then add a new line before and after the cell. This is for a better
               visible  quality.. also, no newline is added for the first row of the table. and not(count(parent::row/preceding-sibling::row)=0)
            -->
            <xsl:if test="ancestor::section1[1]/@layout='box'">
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="1"/>
                    <xsl:with-param name="keep-with-previous" select="1"/>
                </xsl:call-template>
            </xsl:if>
            <fo:block font-family="'Sabon MT', 'Arial', 'sans-serif'"
                      space-before="0.1in"
                      space-after="0.1in"
                      space-before.conditionality="retain"
                      space-after.conditionality="retain"
                      border-before-style="hidden"
                      border-after-style="hidden"
                      border-right-style="hidden"
                      border-start-style="hidden"
                      keep-with-previous.within-page="always"
                      border-end-style="hidden">
                <xsl:if test="not(preceding-sibling::entry)">
                    <xsl:attribute name="margin-left">0.05in</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="following-sibling::entry">
                        <xsl:attribute name="margin-right">0.4in</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="margin-right">0.05in</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <!--<fo:block font-family="'Sabon MT', 'Arial', 'sans-serif'">-->
                <xsl:choose>
                    <xsl:when test="ancestor::table/attribute::tabstyle='TableSmall'">
                        <xsl:attribute name="font-size">9pt</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="font-size">11pt</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
            </fo:block>
            <xsl:if test="ancestor::section1[1]/@layout='box'">
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="1"/>
                    <xsl:with-param name="keep-with-previous" select="1"/>
                </xsl:call-template>
            </xsl:if>
        </fo:table-cell>
    </xsl:template>
    <!-- duplicate functions from plcdtd2html for calculating colspan  -->
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
    <!--
========================================================================
     LINKS
========================================================================
-->
    <xsl:template match="plcxlink/*[1]"></xsl:template>
    <!--
========================================================================
     TEXT
========================================================================
-->

    <xsl:template match="text()">
        <xsl:variable name="this-string">
            <xsl:call-template name="convert-quotes">
                <xsl:with-param name="this_string" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when
                    test="contains(preceding-sibling::emphasis[last()]/plcxlink/xlink:locator/text(),'see box') or contains(preceding-sibling::emphasis/plcxlink/xlink:locator/text(),'See box') ">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) &lt;3">
                        <xsl:choose>
                            <xsl:when
                                    test="starts-with($this-string,')') or starts-with($this-string,').') or starts-with($this-string,'.)')"/>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="starts-with($this-string,').') or starts-with($this-string,'.)')">
                        <xsl:value-of select="substring(3,string-length($this-string))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($this-string,'.') or starts-with($this-string,')')">
                        <xsl:value-of select="substring(2,string-length($this-string))"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when
                    test="preceding-sibling::emphasis[plcxlink] and contains(preceding-sibling::emphasis/text(),'see box') or contains(preceding-sibling::emphasis/text(),'See box') ">
                <xsl:choose>
                    <xsl:when test="starts-with($this-string,').') or starts-with($this-string,'.)')">
                        <xsl:value-of select="substring(3,string-length($this-string))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($this-string,'.') or starts-with($this-string,')')">
                        <xsl:value-of select="substring(2,string-length($this-string))"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($this-string,'see box')">
                <xsl:call-template name="replaceCharsInString">
                    <xsl:with-param name="stringIn" select="$this-string"/>
                    <xsl:with-param name="to-replace" select="'see box,'"/>
                    <xsl:with-param name="replace-with" select="'see box'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($this-string,'See box')">
                <xsl:call-template name="replaceCharsInString">
                    <xsl:with-param name="stringIn" select="$this-string"/>
                    <xsl:with-param name="to-replace" select="'See box,'"/>
                    <xsl:with-param name="replace-with" select="'See box'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="check-first-char">
        <xsl:param name="text"/>
        <xsl:variable name="first-rep">
            <xsl:if test="starts-with($text,')')">
                <xsl:value-of select="substring(2,string-length())"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="second-rep">
            <xsl:if test="string($first-rep) and starts-with($first-rep,'.')">
                <xsl:value-of select="substring(2,string-length())"/>
            </xsl:if>
        </xsl:variable>
    </xsl:template>
    <xsl:template name="convert-quotes">
        <xsl:param name="this_string"/>
        <xsl:variable name="quote">'</xsl:variable>
        <xsl:choose>
            <xsl:when test="contains ($this_string,'$quote')">
                <xsl:call-template name="convert-quotes">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'$quote')"/>
                </xsl:call-template>
                <xsl:text>&#39;</xsl:text>
                <xsl:call-template name="convert-quotes">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'$quote')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$this_string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
========================================================================
     HELPER FUNCTION FOR PARSING FILEPATH
========================================================================
-->
    <xsl:template name="getpath">
        <xsl:param name="fileref"/>
        <xsl:choose>
            <xsl:when test="contains($fileref,'\')">
                <xsl:call-template name="getpath">
                    <xsl:with-param name="fileref">
                        <xsl:value-of select="substring-after($fileref,'\')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($fileref,'/')">
                <xsl:call-template name="getpath">
                    <xsl:with-param name="fileref">
                        <xsl:value-of select="substring-after($fileref,'/')"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fileref"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="add-newlines">
        <xsl:param name="newline-count"/>
        <xsl:param name="start" select="1"/>
        <xsl:param name="keep-with-previous"/>
        <xsl:param name="keep-with-next"/>
        <xsl:choose>
            <xsl:when test="$start &lt;= $newline-count">
                <fo:block>
                    <xsl:if test="$keep-with-previous = 1">
                        <xsl:attribute name="keep-with-previous.within-page">
                            <xsl:text>always</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$keep-with-next = 1">
                        <xsl:attribute name="keep-with-next.within-page">
                            <xsl:text>always</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                    <fo:leader leader-pattern="space" leader-length="20mm"/>
                </fo:block>
                <xsl:call-template name="add-newlines">
                    <xsl:with-param name="newline-count" select="$newline-count"/>
                    <xsl:with-param name="start" select="$start+1"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="add-empty-columns">
        <xsl:param name="colscount"/>
        <xsl:param name="border-style"/>
        <xsl:param name="border-width"/>
        <xsl:param name="start" select="1"/>
        <xsl:choose>
            <xsl:when test="$start &lt;= $colscount">
                <fo:table-cell padding="6pt" border-style="{$border-style}" border-width="{$border-width}">
                    <fo:block>
                        <fo:leader leader-pattern="space" leader-length="20mm"/>
                    </fo:block>
                </fo:table-cell>
                <xsl:call-template name="add-empty-columns">
                    <xsl:with-param name="colscount" select="$colscount"/>
                    <xsl:with-param name="start" select="$start+1"/>
                    <xsl:with-param name="border-style" select="$border-style"/>
                    <xsl:with-param name="border-width" select="$border-width"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="test-block">
        <fo:table border="0.5pt solid black" text-align="center">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell padding="6pt" border="0.5pt solid black">(1)
                        <fo:block>upper left</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="6pt" border="0.5pt solid black">
                        <fo:block>upper right</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="6pt" border="0.5pt solid black">
                        <fo:block>lower left</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="6pt" border="0.5pt solid black">
                        <fo:block>lower right</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    <xsl:template match="blockquote">
        <fo:block text-align="left" width="150mm" height="100mm" margin-top="1cm" margin-bottom="1cm">
            <fo:block start-indent="1cm" end-indent="1cm">
                <xsl:apply-templates/>
            </fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template name="get-fo-space">
        <fo:leader leader-pattern="space" leader-length="2mm"/>
    </xsl:template>
    <xsl:template name="replaceCharsInString">
        <xsl:param name="stringIn"/>
        <xsl:param name="to-replace"/>
        <xsl:param name="replace-with"/>
        <xsl:choose>
            <xsl:when test="contains($stringIn,$to-replace)">
                <xsl:value-of select="concat(substring-before($stringIn,$to-replace),$replace-with)"/>
                <xsl:call-template name="replaceCharsInString">
                    <xsl:with-param name="stringIn" select="substring-after($stringIn,$to-replace)"/>
                    <xsl:with-param name="to-replace" select="$to-replace"/>
                    <xsl:with-param name="replace-with" select="$replace-with"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$stringIn"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="footer.content">
        <xsl:param name="pageclass" select="''"/>
        <xsl:param name="sequence" select="''"/>
        <xsl:param name="position" select="''"/>
        <xsl:param name="gentext-key" select="''"/>
        <xsl:variable name="RevInfo">
            <xsl:choose>
                <xsl:when test="//edition">
                    <xsl:text>AXitd, Edition: </xsl:text>
                    <xsl:value-of select="//edition"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- nop -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:block>
            <!-- pageclass can be front, body, back -->
            <!-- sequence can be odd, even, first, blank -->
            <!-- position can be left, center, right -->
            <xsl:choose>
                <xsl:when test="$pageclass = 'titlepage'">
                    <!-- nop; no footer on title pages -->
                </xsl:when>
                <xsl:when test="$double.sided != 0 and $sequence = 'even' and $position='left'">
                    <fo:page-number/>
                </xsl:when>
                <xsl:when test="$double.sided != 0 and $sequence = 'even' and $position='center'">
                    <xsl:value-of select="$RevInfo"/>
                </xsl:when>
                <xsl:when
                        test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='right'">
                    <fo:page-number/>
                </xsl:when>
                <xsl:when
                        test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='center'">
                    <xsl:value-of select="$RevInfo"/>
                </xsl:when>
                <xsl:when test="$double.sided = 0 and $position='center'">
                    <fo:page-number/>
                </xsl:when>
                <xsl:when test="$sequence='blank'">
                    <xsl:choose>
                        <xsl:when test="$double.sided != 0 and $position = 'left'">
                            <fo:page-number/>
                        </xsl:when>
                        <xsl:when test="$double.sided != 0 and $position='center'">
                            <xsl:value-of select="$RevInfo"/>
                        </xsl:when>
                        <xsl:when test="$double.sided = 0 and $position = 'center'">
                            <fo:page-number/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- nop -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <!-- nop -->
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>
    <xsl:template match="graphic">
        <!--
========================================================================
     FIGURES
========================================================================
-->
        <!--<fo:block xsl:use-attribute-sets="figure">
            <xsl:text>Figure</xsl:text>
            <xsl:number format="1" value="position()"/>
        </fo:block>
        -->
        <fo:block keep-with-previous.within-page="always">
            <xsl:variable name="img_fullpath">
                <xsl:choose>
                    <xsl:when test="starts-with(attribute::fileref,'..')">
                        <xsl:value-of select="substring-after(attribute::fileref,'..')"/>
                    </xsl:when>
                    <xsl:when test="starts-with(attribute::fileref,'/data/e3_4.3/graphics/')">
                        <xsl:value-of select="substring-after(attribute::fileref,'/data/e3_4.3/graphics/')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="attribute::fileref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="img_relpath">
                <xsl:value-of select="substring-before($img_fullpath,'.')"/>
            </xsl:variable>
            <xsl:variable name="img_extension">
                <xsl:value-of select="substring-after($img_fullpath,'.')"/>
            </xsl:variable>
            <!-- need extra function here for E3 to get text after last slash in img_relpath -->
            <xsl:variable name="imageid">
                <xsl:call-template name="getpath">
                    <xsl:with-param name="fileref">
                        <xsl:value-of select="$img_relpath"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="full_img">
                <xsl:value-of select="concat('d:\e3_work\images\input\',$imageid)"/>
                <xsl:choose>
                    <xsl:when test="$usetif='yes'">
                        <xsl:text>.tif</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>.gif</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- debugging code for image path	-->
            <!--
                    <xsl:text>img_fullpath=</xsl:text>
                    <xsl:value-of select="$img_fullpath" />
                    <xsl:text>img_relpath=</xsl:text>
                    <xsl:value-of select="$img_relpath" />
                    <xsl:text>imageid=</xsl:text>
                    <xsl:value-of select="$img_relpath" />
                    <xsl:text>full_img=</xsl:text>
                    <xsl:value-of select="$full_img" />
            -->
            <fo:external-graphic display-align="center" text-align="center" content-type="content-type:image/tiff">
                <xsl:attribute name="src">
                    <xsl:value-of select="$full_img"/>
                </xsl:attribute>
            </fo:external-graphic>
        </fo:block>
    </xsl:template>
    <xsl:template match="title[parent::metadata][normalize-space(text())]" mode="sdocsindex">
        <fo:block
                end-indent="0pt"
                last-line-end-indent="52.95pt"
                line-height="15.95pt"
                start-indent="0pt"
                text-align="start"
                text-align-last="justify"
                text-indent="0pt">
            <fo:inline>
                <fo:inline xsl:use-attribute-sets="section1index">
                    <xsl:value-of select="concat(normalize-space(text()),':standard document')"/>
                </fo:inline>
                <fo:leader leader-length.maximum="380pt" leader-length.optimum="0pt"
                           leader-pattern="dots"/>
                <xsl:text> numbered individually</xsl:text>
            </fo:inline>
        </fo:block>
    </xsl:template>
    <xsl:template match="title[parent::metadata][normalize-space(text())]" mode="sdocsmainindex">
        <fo:block>
            <xsl:value-of select="concat(text(),':standard document')"/>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>