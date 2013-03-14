<?xml version='1.0'?>
<!--
========================================================================
Name:	SAMPLEFO.XSL
Author:	Chris Beecham
Description:	Main stylesheet for transforming PLCDTD documents to
PDF using xsl-fo
Version: 1.3.2
Last modified:	28.5.2003
Known issues: Table spacing, bullet point positioning, left quotes. 

cb modified 28.4.2003
added proportional widths for table columns       

cb modified 10.11.2003
changed filepaths to work on e3/metro                
========================================================================
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
        >
    <!--
========================================================================
                          PAGE SETUP AND HEADER
========================================================================
-->
    <xsl:param name="type">
        <xsl:value-of select="/*/metadata/type/plcxlink/*[1]"/>
    </xsl:param>
    <xsl:param name="usetif">yes</xsl:param>
    <xsl:param name="usebox">yes</xsl:param>
    <!--
    ========================================================================
                              KEY FOR PLCXLINK
    ========================================================================
    -->
    <!--
    <xsl:key name="reflink1" match="//plcxlink[not(ancestor::metadata)][not (starts-with (*[1]/attribute::*[1], '#'))]"
    use="*[1]/attribute::*[1]"/>

    <xsl:key name="reflink2" match="//plcxlink[not(ancestor::metadata)][not (starts-with (*[1]/attribute::*[1], '#'))]"
    use="substring-before(*[1]/attribute::*[1],'#')"/>
    -->
    <!--
    <xsl:for-each select="//plcxlink[not(ancestor::metadata)][not (starts-with (*[1]/attribute::*[1], '#'))]">
    <xsl:choose>
    <xsl:key name="reflink" match="." use="*[1]/attribute::*[1]"/>
    </xsl:choose>
    </xsl:for-each>
    -->
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="firstA4"
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
            <fo:page-sequence master-name="layout">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:table>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="$type='Skills Checklist'">
                                                <fo:external-graphic content-type="content-type:image/tiff"
                                                                     src="d:\e3_work\images\input\skills.tif"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <fo:external-graphic content-type="content-type:image/tiff"
                                                                     src="d:\e3_work\images\input\logo.tif"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block space-before="20" text-align="right" font-size="9pt"
                                              font-family="'News Gothic MT'">
                                        <xsl:value-of select="practicenote/metadata/title"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                    <!--
        <fo:block>	
        <fo:external-graphic content-type="content-type:image/tiff" src="d:\e3_work\images\input\logo.tif"/>
        </fo:block>
         <fo:block  text-align="right" font-size="9pt" font-family="'News Gothic MT'">
        <xsl:value-of select="practicenote/metadata/title"/>
       </fo:block>-->
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <fo:table>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block space-before="8" text-align="left" font-size="9pt" font-weight="bold"
                                              font-family="'News Gothic MT'">
                                        <xsl:if test="$type!='Skills Checklist'">www.practicallaw.com/</xsl:if>
                                        <xsl:if test="string-length (*/metadata/resourceid) &lt; 10">A</xsl:if>
                                        <xsl:value-of select="*/metadata/resourceid"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block space-before="8" text-align="right" font-size="9pt"
                                              font-family="'News Gothic MT', sans-serif">
                                        <fo:page-number/>
                                    </fo:block>
                                </fo:table-cell>
                                <!--<fo:table-cell><fo:block  space-before="8" text-align="right" font-size="9pt" font-family="'News Gothic MT', sans-serif"></fo:block></fo:table-cell>-->
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <!--
========================================================================
                          TOP LEVEL
========================================================================
-->
    <xsl:template match="metadata">
        <xsl:apply-templates/>
    </xsl:template>
    <!--
========================================================================
                          MAIN RULE INCLUDES FOOTER BOLOCK
========================================================================
-->
    <xsl:template match="fulltext">
        <!--
========================================================================
                         CHECKLIST BLOCK
========================================================================
-->
        <xsl:if test="$type='Skills Checklist'">
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">sect3title</xsl:with-param>
                </xsl:call-template>
                Employee:
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">sect3title</xsl:with-param>
                </xsl:call-template>
                Date:
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">sect3title</xsl:with-param>
                </xsl:call-template>
                Employee Signature:
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">sect3title</xsl:with-param>
                </xsl:call-template>
                Reviewer:
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">Body</xsl:with-param>
                </xsl:call-template>
                <fo:inline font-weight="bold">
                    In order to assess your level of competency please tick the boxes where you
                    feel you are confident in carrying out the task.
                </fo:inline>
            </fo:block>
        </xsl:if>
        <!--
========================================================================
                          MAIN BLOCK
========================================================================
-->
        <xsl:apply-templates/>
        <!--
========================================================================
                          CHECKLIST BLOCK
========================================================================
-->
        <xsl:if test="$type='Skills Checklist'">
            <fo:block>
                <fo:external-graphic content-type="content-type:image/tiff">
                    <xsl:attribute name="src">d:\e3_work\images\input\lines.tif</xsl:attribute>
                </fo:external-graphic>
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">BodyESA</xsl:with-param>
                </xsl:call-template>
                Please give us any comments to help us improve this level (e.g. too easy/difficult etc.)
            </fo:block>
        </xsl:if>
        <!--
        <xsl:if test="$type='Skills Checklist'">
         <fo:table>
           <xsl:attribute name="border-left">solid</xsl:attribute>
        <xsl:attribute name="border-right">solid</xsl:attribute>
        <xsl:attribute name="border-top">solid</xsl:attribute>
        <xsl:attribute name="border-bottom">solid</xsl:attribute>
          <fo:table-body>
             <fo:table-row>
              <fo:table-cell>
                <fo:block>
                   <xsl:call-template name="make-block">
                   <xsl:with-param name="blockstyle">Body</xsl:with-param>
                   </xsl:call-template>
                   Please give us any comments to help us improve this level (e.g. too easy/difficult etc.)
                  </fo:block>
              </fo:table-cell>
              </fo:table-row>
        </fo:table-body>
        </fo:table>
        </xsl:if>
        -->
        <!--
========================================================================
                          FIGURES
========================================================================
-->
        <xsl:if test="//graphic">
            <fo:block break-before="page"></fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">SectionHead</xsl:with-param>
                </xsl:call-template>
                Figures
            </fo:block>
            <xsl:for-each select="//graphic">
                <xsl:if test="(position() &gt; 1)">
                    <fo:block break-before="page"></fo:block>
                </xsl:if>
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">figure</xsl:with-param>
                    </xsl:call-template>
                    Figure
                    <xsl:number format="1" value="position()"/>
                </fo:block>
                <fo:block>
                    <xsl:variable name="img_fullpath">
                        <xsl:choose>
                            <xsl:when test="starts-with(attribute::fileref,'..')">
                                <xsl:value-of select="substring-after(attribute::fileref,'..')"/>
                            </xsl:when>
                            <xsl:when test="starts-with(attribute::fileref,'binaryContent.jsp?item=')">
                                <xsl:value-of select="substring-after(attribute::fileref,'binaryContent.jsp?item=')"/>
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
                        <xsl:choose>
                            <xsl:when test="$usetif='yes'">d:\e3_work\images\input\<xsl:value-of select="$imageid"/>.tif
                            </xsl:when>
                            <xsl:otherwise>d:\e3_work\images\input\<xsl:value-of select="$imageid"/>.gif
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- debugging code for image path
        img_fullpath=<xsl:value-of select="$img_fullpath" />
        img_relpath=<xsl:value-of select="$img_relpath" />
        imageid=<xsl:value-of select="$img_relpath" />
        full_img=<xsl:value-of select="$full_img" />-->
                    <fo:external-graphic content-type="content-type:image/tiff">
                        <xsl:attribute name="src">http://circle/data/it_training/17807_1.tif</xsl:attribute>
                    </fo:external-graphic>
                </fo:block>
            </xsl:for-each>
        </xsl:if>
        <!--
========================================================================
                         BOXES
========================================================================
-->
        <xsl:if test="(//section1[attribute::layout='box']) and ($usebox='yes')">
            <fo:block break-before="page"></fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">SectionHead</xsl:with-param>
                </xsl:call-template>
                Boxes
            </fo:block>
            <xsl:for-each select="//section1[attribute::layout='box']">
                <fo:block>
                    <fo:external-graphic content-type="content-type:image/tiff">
                        <xsl:attribute name="src">d:\e3_work\images\input\line.tif</xsl:attribute>
                    </fo:external-graphic>
                </fo:block>
                <fo:block space-before="8pt" space-after="8pt">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:for-each>
        </xsl:if>
        <!--
========================================================================
                          ARTICLE INFO
========================================================================
-->
        <xsl:if test="$type!='Skills Checklist'">
            <fo:block break-before="page"></fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">SectionHead</xsl:with-param>
                </xsl:call-template>
                Article Information
            </fo:block>
            <!--<fo:table border-top="solid" border-bottom="solid">
     <fo:table-body>
      <fo:table-row>
        <fo:table-cell>-->
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">XHDUpper</xsl:with-param>
                </xsl:call-template>
                Resource information
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">Body</xsl:with-param>
                </xsl:call-template>
                The fulltext is available at http://www.practicallaw.com/
                <xsl:if test="string-length (preceding-sibling::metadata/resourceid) &lt; 10">A</xsl:if>
                <xsl:value-of select="preceding-sibling::metadata/resourceid"/>
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">XHDLower</xsl:with-param>
                </xsl:call-template>
                General
            </fo:block>
            <xsl:if test="preceding-sibling::metadata/identifier!=''">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">Body</xsl:with-param>
                    </xsl:call-template>
                    &#183;
                    <xsl:value-of select="preceding-sibling::metadata/identifier"/>
                </fo:block>
            </xsl:if>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">Body</xsl:with-param>
                </xsl:call-template>
                &#183; Information stated at
                <xsl:value-of select="preceding-sibling::metadata/datevalid"/>
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">Body</xsl:with-param>
                </xsl:call-template>
                &#183; Article ID:
                <xsl:if test="string-length (preceding-sibling::metadata/resourceid) &lt; 10">A</xsl:if>
                <xsl:value-of select="preceding-sibling::metadata/resourceid"/>
            </fo:block>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">Body</xsl:with-param>
                </xsl:call-template>
                &#183; Document Generated:
                <xsl:value-of select="preceding-sibling::metadata/dateexpiry"/>
            </fo:block>
            <xsl:if test="preceding-sibling::metadata/type">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">XHDLower</xsl:with-param>
                    </xsl:call-template>
                    Resource Type
                </fo:block>
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">Body</xsl:with-param>
                    </xsl:call-template>
                    &#183;
                    <xsl:value-of select="preceding-sibling::metadata/type/plcxlink/*[1]"/>
                    &#183; http://www.practicallaw.com/
                    <xsl:if test="string-length (preceding-sibling::metadata/type/plcxlink/*[1]/attribute::*[1]) &lt; 10">
                        T
                    </xsl:if>
                    <xsl:value-of select="preceding-sibling::metadata/type/plcxlink/*[1]/attribute::*[1]"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="preceding-sibling::metadata/section">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">XHDLower</xsl:with-param>
                    </xsl:call-template>
                    Section
                </fo:block>
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">Body</xsl:with-param>
                    </xsl:call-template>
                    &#183;
                    <xsl:value-of select="preceding-sibling::metadata/section/plcxlink/*[1]"/>
                    &#183; http://www.practicallaw.com/
                    <xsl:if test="string-length (*[1]/attribute::*[1]) &lt; 10">T</xsl:if>
                    <xsl:value-of select="preceding-sibling::metadata/type/plcxlink/*[1]/attribute::*[1]"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="preceding-sibling::metadata/jurisdiction">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">XHDLower</xsl:with-param>
                    </xsl:call-template>
                    Jurisdiction
                </fo:block>
                <xsl:for-each select="preceding-sibling::metadata/jurisdiction/plcxlink">
                    <fo:block>
                        <xsl:call-template name="make-block">
                            <xsl:with-param name="blockstyle">Body</xsl:with-param>
                        </xsl:call-template>
                        &#183;
                        <xsl:value-of select="*[1]"/>
                        &#183; http://www.practicallaw.com/
                        <xsl:if test="string-length (*[1]/attribute::*[1]) &lt; 10">T</xsl:if>
                        <xsl:value-of select="*[1]/attribute::*[1]"/>
                    </fo:block>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="preceding-sibling::metadata/subject">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">XHDLower</xsl:with-param>
                    </xsl:call-template>
                    Subject
                </fo:block>
                <xsl:for-each select="preceding-sibling::metadata/subject/plcxlink">
                    <fo:block>
                        <xsl:call-template name="make-block">
                            <xsl:with-param name="blockstyle">Body</xsl:with-param>
                        </xsl:call-template>
                        &#183;
                        <xsl:value-of select="*[1]"/>
                        &#183; http://www.practicallaw.com/
                        <xsl:if test="string-length (*[1]/attribute::*[1]) &lt; 10">T</xsl:if>
                        <xsl:value-of select="*[1]/attribute::*[1]"/>
                    </fo:block>
                </xsl:for-each>
            </xsl:if>
            <!-- added CB May 2003 references -->
            <xsl:if test="//plcxlink[not(ancestor::metadata)]">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">XHDLower</xsl:with-param>
                    </xsl:call-template>
                    References
                </fo:block>
                <xsl:for-each
                        select="//plcxlink[not(ancestor::metadata)][not (starts-with (*[1]/attribute::*[1], '#'))]">
                    <xsl:sort select="*[1]/attribute::*[1]"/>
                    <xsl:variable name="refart">
                        <xsl:choose>
                            <xsl:when test="contains (*[1]/attribute::*[1], '#')">
                                <xsl:value-of select="substring-before (*[1]/attribute::*[1],'#')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="*[1]/attribute::*[1]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- test for dupes -->
                    <xsl:choose>
                        <xsl:when
                                test="preceding::plcxlink[not(ancestor::metadata)][starts-with (*[1]/attribute::*[1], $refart)]"></xsl:when>
                        <!-- don't print empty title -->
                        <xsl:when test="normalize-space(*[1]/attribute::*[3])=''"></xsl:when>
                        <!-- don't print title with script in it-->
                        <xsl:when test="contains(*[1]/attribute::*[3],'scripts')"></xsl:when>
                        <!-- topic -->
                        <xsl:when test="(*[1]/attribute::*[2]='Topic') or (*[1]/attribute::*[2]='topic')">
                            <fo:block>
                                <xsl:call-template name="make-block">
                                    <xsl:with-param name="blockstyle">BodyLA</xsl:with-param>
                                </xsl:call-template>
                                &#183;
                                <xsl:value-of select="normalize-space(*[1]/attribute::*[3])"/>
                                (http://www.practicallaw.com/
                                <xsl:if test="string-length ($refart) &lt; 10">T</xsl:if>
                                <xsl:value-of select="$refart"/>)
                            </fo:block>
                        </xsl:when>
                        <!-- weblink -->
                        <xsl:when test="(*[1]/attribute::*[2]='Web') or (*[1]/attribute::*[2]='web')">
                            <fo:block>
                                <xsl:call-template name="make-block">
                                    <xsl:with-param name="blockstyle">BodyLA</xsl:with-param>
                                </xsl:call-template>
                                &#183;
                                <xsl:value-of select="normalize-space(*[1]/attribute::*[3])"/>
                                (http://www.practicallaw.com/
                                <xsl:if test="string-length ($refart) &lt; 10">W</xsl:if>
                                <xsl:value-of select="$refart"/>)
                            </fo:block>
                        </xsl:when>
                        <xsl:otherwise>
                            <fo:block>
                                <xsl:call-template name="make-block">
                                    <xsl:with-param name="blockstyle">BodyLA</xsl:with-param>
                                </xsl:call-template>
                                &#183;
                                <xsl:value-of select="normalize-space(*[1]/attribute::*[3])"/>
                                (http://www.practicallaw.com/
                                <xsl:if test="string-length ($refart) &lt; 10">A</xsl:if>
                                <xsl:value-of select="$refart"/>)
                            </fo:block>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">XHDUpper</xsl:with-param>
                </xsl:call-template>
                &#160;
                <!-- spacer block -->
            </fo:block>
            <!--</fo:table-cell>
            </fo:table-row>
          </fo:table-body>
         </fo:table>-->
        </xsl:if>
        <!--
========================================================================
                         COPYRIGHT
========================================================================
-->
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">BodyNoSpaceAfter</xsl:with-param>
            </xsl:call-template>
            &#169; Legal &amp; Commercial Publishing Limited 1990 - 2005. http://www.practicallaw.com.
        </fo:block>
        <xsl:choose>
            <xsl:when test="$type='Skills Checklist'">
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">Body</xsl:with-param>
                    </xsl:call-template>
                    Issued
                    <xsl:value-of select="//metadata/datevalid"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">BodyNoSpace</xsl:with-param>
                    </xsl:call-template>
                    Subscription enquiries +44 (0)20 7202 1210 or email lisa.byers@practicallaw.com
                </fo:block>
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">BodyNoSpace</xsl:with-param>
                    </xsl:call-template>
                    Please read our licence and disclaimer, and privacy policy.
                    To access the document on our site type in www.practicallaw.com followed by '/a' and the universal
                    reference id (e.g. www.practicallaw.com/a23451) in your browser.
                    To access a topic type '/t' and the universal reference id (e.g. www.practicallaw.com/t588).
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
========================================================================
                        END OF FOOTER INFO
========================================================================
-->
    <!--
========================================================================
                        SECTION
========================================================================
-->
    <xsl:template match="section1">
        <fo:block space-before="8pt" space-after="8pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section2">
        <fo:block space-before="8pt" space-after="8pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section3">
        <fo:block space-before="8pt" space-after="8pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!--
========================================================================
                        PARA
========================================================================
-->
    <xsl:template
            match="para[parent::entry][not[(ancestor::*/@rowstyle='bglightblue') or (ancestor::*/@rowstyle='headblue')]]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellBodyAlign</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!-- although in theory bglightblue shouldn't be left aligned, apppear to be doing this on the web
so am doing the same here for consistency -->
    <xsl:template match="para[parent::entry][(ancestor::*/@rowstyle='bglightblue')]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellBodyAlign</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry][(ancestor::*/@rowstyle='headblue')]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellBody</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry/@entrystyle='headblue']">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellBody</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry][ancestor::table/@tabstyle='TableSmall']">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellBodySmall</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::entry][ancestor::thead]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellHead</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">Body</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::listitem/parent::itemizedlist][ancestor::entry]">
        <!--<fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">CellBody</xsl:with-param>
            </xsl:call-template>-->
        <xsl:apply-templates/>
        <!--</fo:block>-->
    </xsl:template>
    <xsl:template match="para[parent::listitem/parent::itemizedlist][not(ancestor::entry)]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">Body</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="para[parent::abstract]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">Abstract</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!--
========================================================================
                          METADATA AND DOC START
========================================================================
-->
    <xsl:template match="title[parent::metadata]">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">MainHead</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">Abstract</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="following-sibling::abstract"/>
        </fo:block>
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">Author</xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="following-sibling::author"/>
        </fo:block>
        <xsl:if test="following-sibling::contributor !=''">
            <fo:block>
                <xsl:call-template name="make-block">
                    <xsl:with-param name="blockstyle">Author</xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="following-sibling::contributor"/>
            </fo:block>
        </xsl:if>
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">Reference</xsl:with-param>
            </xsl:call-template>
            Reference:
            <xsl:if test="$type!='Skills Checklist'">www.practicallaw.com/</xsl:if>
            <xsl:if test="string-length (parent::metadata/resourceid) &lt; 10">A</xsl:if>
            <xsl:value-of select="parent::metadata/resourceid"/>
        </fo:block>
    </xsl:template>
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
    <xsl:template name="make-block">
        <xsl:param name="blockstyle"/>
        <xsl:choose>
            <xsl:when test="$blockstyle='arttitle'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">6pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">6pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">16pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='sect1title'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">6pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">6pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">14pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='sect1titleMS'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">6pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">18pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">14pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='sect2title'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">6pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">3pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='figure'">
                <xsl:attribute name="text-align">center</xsl:attribute>
                <xsl:attribute name="space-before">20pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">20pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">10pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='sect3title'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">6pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">3pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='MainHead'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">20pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">20pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT', sans-serif</xsl:attribute>
                <xsl:attribute name="font-size">30pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='SectionHead'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">6pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">11pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">20pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='XHDUpper'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="text-transform">uppercase</xsl:attribute>
                <xsl:attribute name="space-before">16pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">8pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">10pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='XHDLower'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">10pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">3</xsl:attribute>
                <xsl:attribute name="space-after">6pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">10pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='Author'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">8pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="space-after">8pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='Abstract'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">12pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="space-after">10pt</xsl:attribute>
                <xsl:attribute name="font-style">italic</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='Reference'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">5pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="space-after">40pt</xsl:attribute>
                <xsl:attribute name="font-family">'News Gothic MT', sans-serif</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
                <xsl:attribute name="font-size">9.5pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='Body'">
                <xsl:attribute name="text-align">justify</xsl:attribute>
                <xsl:attribute name="space-before">8pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">12pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='BodyLA'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">8pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">12pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='BodyESA'">
                <xsl:attribute name="text-align">justify</xsl:attribute>
                <xsl:attribute name="space-before">8pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">50pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='BodyNSB'">
                <xsl:attribute name="text-align">justify</xsl:attribute>
                <xsl:attribute name="space-before">0pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">0pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='CellHead'">
                <xsl:attribute name="space-before">2pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">12pt</xsl:attribute>
                <xsl:attribute name="font-weight">bold</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='CellBodyAlign'">
                <xsl:attribute name="text-align">left</xsl:attribute>
                <xsl:attribute name="space-before">2pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">12pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='CellBody'">
                <xsl:attribute name="text-align">center</xsl:attribute>
                <xsl:attribute name="space-before">2pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">12pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='CellBodySmall'">
                <xsl:attribute name="space-before">2pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="line-height">14pt</xsl:attribute>
                <xsl:attribute name="space-after">12pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">9pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='BodyNoSpaceAfter'">
                <xsl:attribute name="text-align">justify</xsl:attribute>
                <xsl:attribute name="space-before">8pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="space-after">0pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='BodyNoSpace'">
                <xsl:attribute name="text-align">justify</xsl:attribute>
                <xsl:attribute name="space-before">0pt</xsl:attribute>
                <xsl:attribute name="space-after.precedence">2</xsl:attribute>
                <xsl:attribute name="space-after">0pt</xsl:attribute>
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="$blockstyle='ListMarker'">
                <xsl:attribute name="font-family">'Sabon MT', serif</xsl:attribute>
                <xsl:attribute name="font-size">11pt</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--
========================================================================
                          HEADINGS
========================================================================
-->
    <xsl:template match="section1/title">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">
                    <xsl:choose>
                        <xsl:when test="$type='Skills Checklist'">sect1titleMS</xsl:when>
                        <xsl:otherwise>sect1title</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section1[attribute::layout='box']">
        <xsl:choose>
            <xsl:when test="$usebox='yes'"></xsl:when>
            <xsl:otherwise>
                <fo:block background-color="yellow">
                    <xsl:apply-templates/>
                </fo:block>
                <!--
        <fo:table padding-top="0pt" padding-bottom="0pt" padding-after="0pt" space-after="0pt" space-before="0pt" margin-top="0pt" margin-bottom="0pt">
        <fo:table-column column-width="14.7cm"/>
        <fo:table-body>
         <fo:table-row>
          <xsl:attribute name="background-color">gray</xsl:attribute>
          <fo:table-cell>
         <fo:block font-family="'Sabon MT', 'Arial', sans-serif"
   space-before="0.1in" space-after="0.1in"
    space-before.conditionality="retain" space-after.conditionality="retain"
    border-before-style="hidden" border-after-style="hidden"
   border-right-style="hidden" border-start-style="hidden" border-end-style="hidden"
   margin-left="0.2in" margin-right="0.2in">
           <xsl:apply-templates/>
           </fo:block>
            </fo:table-cell>
           </fo:table-row>
        </fo:table-body>
        </fo:table>
        -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="section2/title">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">sect2title</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="section3/title">
        <fo:block>
            <xsl:call-template name="make-block">
                <xsl:with-param name="blockstyle">sect3title</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="bridgehead">
        <xsl:choose>
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
                <fo:block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">sect1title</xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
========================================================================
                          INLINE
========================================================================
-->
    <xsl:template match="emphasis[@role='bold']">
        <fo:inline font-weight="bold">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="emphasis[@role='italic']">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="emphasis[@role='bold-italic']">
        <fo:inline font-style="italic" font-weight="bold">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <!-- float allows graphics to appear in main text flow
comment this out for now -->
    <!-- the float construct allows the image to appear on the top of the page-->
    <!--<xsl:template match="graphic">
  <fo:float float="before">
<fo:block>
    <xsl:call-template name="make-block">
    <xsl:with-param name="blockstyle">Body</xsl:with-param>
    </xsl:call-template>
   <xsl:variable name="img_fullpath">
        <xsl:choose>
        <xsl:when test="starts-with(attribute::fileref,'..')"><xsl:value-of select="substring-after(attribute::fileref,'..')" /></xsl:when>
        <xsl:when test="starts-with(attribute::fileref,'/data/e3_4.3/graphics/')"><xsl:value-of select="substring-after(attribute::fileref,'/data/e3_4.3/graphics/')" /></xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="attribute::fileref" />
        </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:variable name="img_relpath"><xsl:value-of select="substring-before($img_fullpath,'.')" /></xsl:variable>
        <xsl:variable name="img_extension"><xsl:value-of select="substring-after($img_fullpath,'.')" /></xsl:variable>
        <xsl:variable name="imageid"><xsl:call-template name="getpath"><xsl:with-param name="fileref"><xsl:value-of select="$img_relpath"/></xsl:with-param></xsl:call-template></xsl:variable>
        <xsl:variable name="full_img">
            <xsl:choose>
            <xsl:when test="$usetif='yes'">d:\e3_work\images\input\<xsl:value-of select="$imageid"/>.tif</xsl:when>
            <xsl:otherwise>d:\e3_work\images\input\<xsl:value-of select="$imageid"/>.jpg</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        FILEPATH=<xsl:value-of select="$full_img"/>
        <fo:external-graphic content-type="image/jpg"><xsl:attribute name="src"><xsl:value-of select="$full_img"/></xsl:attribute></fo:external-graphic>
  </fo:block>
  </fo:float>
</xsl:template>-->
    <!--
========================================================================
                          CHANGE TRACKING
========================================================================
Doesn't work!

-->
    <!--
<xsl:template match="foo:add">
 hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
 <fo:inline font-weight="bold" text-decoration="underline">
  <xsl:apply-templates/>
 </fo:inline> 
</xsl:template>

<xsl:template match="add[namespace::foo]">
 hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
 <fo:inline font-weight="bold" text-decoration="underline">
  <xsl:apply-templates/>
 </fo:inline> 
</xsl:template>


<xsl:template match="foo:del">
 <fo:inline text-decoration="strikethrough">
  <xsl:apply-templates/>
 </fo:inline> 
</xsl:template>

<xsl:template match="del[namespace::foo]">
 <fo:inline text-decoration="strikethrough">
  <xsl:apply-templates/>
 </fo:inline> 
</xsl:template>

<xsl:template match="*[attribute::user][attribute::time]">
    dddddddddddddddddddd
    name          <xsl:value-of select="name(.)"/>
   local-name    <xsl:value-of select="local-name(.)"/>
   namespace-uri <xsl:value-of select="namespace-uri(.)"/>
 <fo:inline text-decoration="strikethrough">
  ddddddddddddddddddddddddd
  <xsl:apply-templates/>
 </fo:inline> 
</xsl:template>

<xsl:template match="*[namespace::foo]">
 gggggggggggggggggggggggggggg
 <fo:inline text-decoration="strikethrough">
  <xsl:apply-templates/>
 </fo:inline> 
</xsl:template>

-->
    <!--
========================================================================
                          LISTS
========================================================================
-->
    <xsl:template match="orderedlist|itemizedlist">
        <xsl:choose>
            <xsl:when test="$type='Skills Checklist'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="ancestor::entry">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <!-- CB changed for 5.1 Taking out these attributes seems to make it display ok
                <fo:list-block provisional-distance-between-starts="0.4cm"
   provisional-label-separation="0.1cm">-->
                <fo:list-block>
                    <xsl:call-template name="make-block">
                        <xsl:with-param name="blockstyle">ListMarker</xsl:with-param>
                    </xsl:call-template>
                    <!--<fo:block  space-before="6pt">-->
                    <xsl:apply-templates/>
                    <!--</fo:block>-->
                </fo:list-block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="listitem">
        <xsl:choose>
            <xsl:when test="$type='Skills Checklist'">
                <xsl:apply-templates/>
            </xsl:when>
            <!--CB changed for 5.1
                dont have block inside entry-->
            <xsl:when test="ancestor::entry">
                <fo:block>
                    <xsl:choose>
                        <xsl:when test="parent::itemizedlist">&#x2022;</xsl:when>
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
                            <xsl:number format="1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <!--	<xsl:choose>
                        <xsl:when test="parent::itemizedlist">&#x2022;</xsl:when>
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
                            <xsl:number format="1"/>
                        </xsl:otherwise>
                </xsl:choose>
                </fo:block>
            </xsl:when>-->
            <xsl:otherwise>
                <fo:list-item>
                    <fo:list-item-label start-indent="0.5cm" end-indent="label-end()">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="parent::itemizedlist">&#x2022;</xsl:when>
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
                                    <xsl:number format="1"/>
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
    <xsl:template
            match="//para[text()][not (itemizedlist)][parent::listitem][//metadata/type/plcxlink/*[1]/text()='Skills Checklist']">
        <fo:table padding-top="0pt" padding-bottom="0pt" padding-after="0pt" space-after="0pt" space-before="0pt"
                  margin-top="0pt" margin-bottom="0pt">
            <!--
    <xsl:attribute name="border-left">solid</xsl:attribute>
    <xsl:attribute name="border-right">solid</xsl:attribute>
    <xsl:attribute name="border-top">solid</xsl:attribute>
    <xsl:attribute name="border-bottom">solid</xsl:attribute>
    -->
            <fo:table-column column-width="13cm"/>
            <fo:table-column column-width="2cm"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:call-template name="make-block">
                                <xsl:with-param name="blockstyle">BodyNoSpace</xsl:with-param>
                            </xsl:call-template>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <fo:external-graphic content-type="content-type:image/tiff"
                                                 src="d:\e3_work\images\input\box.tif"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    <!--
========================================================================
                          TABLES
========================================================================
-->
    <!--
match: table, informaltable
===========================
-->
    <xsl:template match="table|informaltable">
        <fo:table-and-caption>
            <fo:table border-spacing="6pt">
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
                <xsl:apply-templates/>
            </fo:table>
        </fo:table-and-caption>
    </xsl:template>
    <xsl:template match="tgroup">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="colspec[contains(attribute::colwidth,'%')]">
        <fo:table-column>
            <xsl:attribute name="column-width">proportional-column-width(
                <xsl:value-of select="substring-before(attribute::colwidth,'%')"/>)
            </xsl:attribute>
            column-width="10cm"/>
        </fo:table-column>
    </xsl:template>
    <xsl:template match="thead">
        <fo:table-header>
            <xsl:apply-templates/>
        </fo:table-header>
    </xsl:template>
    <xsl:template match="tbody">
        <!--<xsl:if test="not(parent::tgroup/preceding-sibling::tgroup/tbody)">
  <xsl:text disable-output-escaping="yes">&lt;fo:table-body></xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="not(parent::tgroup/following-sibling::tgroup/tbody)">
  <xsl:text disable-output-escaping="yes">&lt;/fo:table-body></xsl:text>
   </xsl:if>-->
        <fo:table-body>
            <xsl:apply-templates/>
        </fo:table-body>
    </xsl:template>
    <xsl:template match="row">
        <fo:table-row>
            <xsl:choose>
                <xsl:when test="@rowstyle='headblueleft'">
                    <xsl:attribute name="background-color">blue</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="entry">
        <!--<fo:table-cell padding-before="0.4in" padding-after="0.4in" padding-start="0.4in"
   padding-end="0.4in" border-before-style="hidden" border-after-style="hidden"
   border-right-style="hidden" border-right.conditionality="retain" border-start-style="hidden" border-end-style="hidden" border-right-width="2in">-->
        <fo:table-cell>
            <xsl:choose>
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
                <!--
     <xsl:when test="parent::row/@rowstyle='headblueleft'">
  <xsl:attribute name="background-color">blue</xsl:attribute>
    </xsl:when>
    -->
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
            <fo:block font-family="'Sabon MT', 'Arial', sans-serif"
                      space-before="0.1in" space-after="0.1in"
                      space-before.conditionality="retain" space-after.conditionality="retain"
                      border-before-style="hidden" border-after-style="hidden"
                      border-right-style="hidden" border-start-style="hidden" border-end-style="hidden">
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
                <!--<fo:block font-family="'Sabon MT', 'Arial', sans-serif">-->
                <xsl:choose>
                    <xsl:when test="ancestor::table/attribute::tabstyle='TableSmall'">
                        <xsl:attribute name="font-size">9</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="font-size">10.5</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
    <!-- duplicate functions from plcdtd2html for calculating colspan  -->
    <xsl:template name="calculate.colspan">
        <xsl:param name="entry" select="."/>
        <xsl:variable name="namest" select="$entry/@namest"/>
        <xsl:variable name="nameend" select="$entry/@nameend"/>
        <xsl:variable name="scol">
            <xsl:call-template name="colspec.colnum">
                <xsl:with-param name="colspec"
                                select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ecol">
            <xsl:call-template name="colspec.colnum">
                <xsl:with-param name="colspec"
                                select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
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
                        <xsl:with-param name="colspec"
                                        select="$colspec/preceding-sibling::colspec[1]"/>
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
    <xsl:template match="plcxlink">
        <xsl:choose>
            <xsl:when test="contains (*[1]/attribute::*[1], '#')">
                <xsl:value-of select="*[1]"/>
                <!--(<xsl:if test="$type!='Skills Checklist'">www.practicallaw.com/</xsl:if> A<xsl:value-of select="substring-before (*[1]/attribute::*[1],'#')"/>)-->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="*[1]"/>
                <!--(<xsl:if test="$type!='Skills Checklist'">www.practicallaw.com/</xsl:if>A<xsl:value-of select="*[1]/attribute::*[1]"/>)-->
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="plcxlink/*[1]"></xsl:template>
    <!--
<xsl:template match="xlink:locator">
  <xsl:apply-templates/>
  ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
  <xsl:choose>
  <xsl:when test="contains (attribute::xlink:href, '#')">
  fish
  (www.practicallaw.com/A<xsl:value-of select="substring-before (attribute::xlink:href,'#')"/>)
  </xsl:when>
  <xsl:otherwise>
 chips
  www.practicallaw.com/A<xsl:value-of select="attribute::xlink:href"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->
    <!--
========================================================================
                          TEXT
========================================================================
-->
    <xsl:template match="text()">
        <xsl:call-template name="convert-quotes">
            <xsl:with-param name="this_string" select="."/>
        </xsl:call-template>
        <!--<xsl:value-of select="."/>-->
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
            <xsl:when test="contains ($this_string,'&#x2014;')">
                <xsl:call-template name="convert-quotes">
                    <xsl:with-param name="this_string" select="substring-before ($this_string,'&#x2014;')"/>
                </xsl:call-template>
                <xsl:text>&#x2014;</xsl:text>
                <xsl:call-template name="convert-quotes">
                    <xsl:with-param name="this_string" select="substring-after ($this_string,'&#x2014;')"/>
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
</xsl:stylesheet>