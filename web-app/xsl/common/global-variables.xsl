<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

    <!-- Define XSl Keys -->
    <xsl:key match="/view/images/image" name="image" use="normalize-space(name)"/>
    <!-- Define Global Variables -->
    <!-- =========================================================================
               GLOBAL PATHS AND VARIABLES
    ============================================================================== -->

    <xsl:variable name="siteUser" select="/plcdata/header/siteUser"/>

    <xsl:variable name="userName" select="$siteUser/userName"/>
    <xsl:variable name="userLocale" select="$siteUser/userLocale"/>
    <xsl:variable name="appLocale" select="plcdata/header/applicationContextLocale"/>
    <xsl:variable name="softwareVersion" select="plcdata/header/version"/>
    <xsl:variable name="displayLocaleWarning" select="$siteUser/displayLocaleWarning"/>
    <xsl:variable name="isUserLoggedIn" select="$siteUser/isUserLoggedIn"/>
    <xsl:variable name="highlightSearchTerms" select="$siteUser/highlightSearchTerms"/>

    <xsl:variable name="globalimages-path" select="'../../images/common/'"/>
    <xsl:variable name="scripts-path" select="'../../script/'"/>

    <!-- SC 14/11/2008 - add support for different precedent jurisdictions and operative types -->
    <!-- moved to epic2fatwire.xsl -->
    <!--<xsl:variable name="precedentNode" select="/resource/xml/precedent"/>
    <xsl:variable name="operativeNode" select="$precedentNode/operative"/>
    <xsl:variable name="operativeType" select="$operativeNode/@properties"/>
    <xsl:variable name="precedentJurisdiction">
        <xsl:choose>
            <xsl:when test="$precedentNode/@jurisdiction"><xsl:value-of select="$precedentNode/@jurisdiction"/></xsl:when>
            <xsl:when test="$operativeType = 'ussfa' or $operativeType = 'ussfawithtitles' or $operativeType = 'uslfa'">US</xsl:when>
        </xsl:choose>
    </xsl:variable>-->

    <!-- sc 05/12/08 facet data -->
    <!--<xsl:variable name="facetData" select="/plcdata/contentSection/contentBody/facetData"/>
    <xsl:variable name="facetServices" select="$facetData/serviceList/service"/>
    <xsl:variable name="facetPracticeAreas" select="$facetData/serviceList/descendant::practiceArea"/>
    <xsl:variable name="facetJurisdictions" select="$facetData/jurisdictionList/jurisdiction"/>
	<xsl:variable name="facetResourceTypes" select="$facetData/resourceTypeList/resourceType"/>
    <xsl:variable name="facetSectionFolders" select="$facetData/sectionFolderList/sectionFolder"/>-->

    <!-- Define the service type e.g property etc -->

    <!--<xsl:variable name="site" select="plcdata/header/site" />-->
    <!-- hacky hack hacky - if its global, pretend its www -->
    <xsl:variable name="site">
        <xsl:choose>
            <xsl:when test="plcdata/header/site='global'">practicallaw</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="plcdata/header/site"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="serviceName" select="$resourcefile/page-resource/services/service[@site=$site]/serviceName"/>

    <xsl:variable name="applicationContextLocale" select="plcdata/header/applicationContextLocale"/>

    <xsl:variable name="dottedSeperator">
        <![CDATA[<div class="dottedSeperator"></div>]]>
    </xsl:variable>

    <xsl:variable name="clearLeftFloats">
        <![CDATA[<div style="clear:left"></div>]]>
    </xsl:variable>

    <xsl:variable name="clearBothFloats">
        <![CDATA[<div style="clear:both"></div>]]>
    </xsl:variable>

    <xsl:variable name="clearRightFloats">
        <![CDATA[<div style="clear:right"></div>]]>
    </xsl:variable>

    <!-- Define the type of document and get its label -->
    <xsl:variable name="resourceType" select="plcdata/contentSection/contentBody/articleHolder/metadata/documentType"/>
    <xsl:variable name="resourceLabel"
                  select="plcdata/contentSection/contentBody/articleHolder/resourceTopics/relationship[type='RESOURCETYPEFOLDER']/targetName"/>

    <xsl:variable name="resourceLabelSingular">
        <xsl:choose>
            <xsl:when
                    test="$resourceType = 'WEBLINK' and not($resourceLabel = 'Cases' or $resourceLabel = 'Forms' or $resourceLabel = 'Legislation' or $resourceLabel = 'Policy guidance and consultations')">
                <xsl:value-of
                        select="$resourcefile/page-resource/documentTypes/documentType[contains(@type, $resourceType)]"/>
            </xsl:when>
            <xsl:when test="string-length($resourceLabel) &gt; 0">
                <xsl:value-of
                        select="$resourcefile/page-resource/documentTypes/documentType[contains(@type, $resourceLabel)]"/>
            </xsl:when>
            <xsl:when test="string-length($resourceType) &gt; 0">
                <xsl:value-of select="$resourcefile/page-resource/documentTypes/documentType[@type = $resourceType]"/>
            </xsl:when>
            <xsl:when test="plcdata/header/xslFileName='web/plcHome'">
                <xsl:value-of select="$resourcefile/page-resource/documentTypes/documentType[@type = 'homePage']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>PLC Document</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="server-name" select="plcdata/header/serverName"/>
    <xsl:variable name="resource-poid" select="plcdata/contentSection/contentBody/articleHolder/metadata/articlePoid"/>
    <xsl:variable name="resource-plcRef"
                  select="plcdata/contentSection/contentBody/articleHolder/metadata/plcReference"/>

    <xsl:variable name="countryQandAJurisdiction"
                  select="plcdata/contentSection/contentBody/articleHolder/countryAnswersJurisdictionFilterId"/>
    <xsl:variable name="countryQandAJurisdictionName"
                  select="plcdata/contentSection/contentBody/articleHolder/resourceContent/resource/xml/child::*/metadata/relation/plcxlink[@xlink:role='qandaset']/xlink:locator[@xlink:href=normalize-space($countryQandAJurisdiction)]/@xlink:title"/>
    <xsl:variable name="countryQandAAuthor"
                  select="plcdata/contentSection/contentBody/articleHolder/countryAnswers/resource/author"/>

    <xsl:variable name="notLoggedIn">
        <xsl:if test="plcdata/contentSection/contentBody/articleHolder/resourceContent/resource/errors/plcError[errorClass = 'com.practicallaw.plcweb.exceptions.NotLoggedInException']">
            true
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="notSubscribed">
        <xsl:if test="plcdata/contentSection/contentBody/articleHolder/resourceContent/resource/errors/plcError[errorClass = 'com.practicallaw.plcweb.exceptions.NotSubscribedException']">
            true
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="isIfsException">
        <xsl:if test="plcdata/contentSection/contentBody/articleHolder/resourceContent/resource/errors/plcError[errorClass = 'oracle.ifs.common.IfsException']">
            true
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="resourceNotFoundException">
        <xsl:choose>
            <xsl:when
                    test="plcdata/contentSection/contentBody/articleHolder/resourceContent/resource/errors/plcError[errorClass = 'com.practicallaw.plcweb.exceptions.ResourceNotFoundException']">
                true
            </xsl:when>
            <xsl:when
                    test="plcdata/contentSection/contentBody/articleHolder/errors/plcError[errorClass = 'com.practicallaw.plcweb.exceptions.ResourceNotFoundException']">
                true
            </xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- Define Global Images -->
    <!--
     Define Global Labels
     -->
    <xsl:variable name="env" select="/plcdata/@env"/>
    <xsl:variable name="resId" select="'Resource ID1'"/>
    <xsl:variable name="resType" select="'Resource Type 1'"/>
    <xsl:variable name="last-amended" select="'last amended date'"/>
    <xsl:variable name="loggedin-text" select="'Logged in as '"/>
    <xsl:variable name="notloggedin-text" select="'Not logged in '"/>
    <xsl:variable name="search-title-text" select="'Search'"/>
    <xsl:variable name="search-default-option-text" select="'All PLC know-how'"/>
    <xsl:variable name="print-text" select="'Print'"/>
    <xsl:variable name="pdf-text" select="'Download PDF'"/>
    <xsl:variable name="email-text" select="'Download Word'"/>
    <xsl:variable name="word-text" select="'Email article'"/>
    <xsl:variable name="bookmark-text" select="'Bookmark page'"/>
    <xsl:variable name="breadcrumbs-title-text" select="'You are here: '"/>

    <xsl:variable name="assignments.gif" select="concat($globalimages-path,'icons/assignments.gif')"/>
    <xsl:variable name="print.gif" select="concat($globalimages-path,'print.gif')"/>
    <xsl:variable name="pdf.gif" select="concat($globalimages-path,'pdf.gif')"/>
    <xsl:variable name="word.gif" select="concat($globalimages-path,'word.gif')"/>
    <xsl:variable name="wordFs.gif" select="concat($globalimages-path,'wordFs.gif')"/>
    <xsl:variable name="email.gif" select="concat($globalimages-path,'email.gif')"/>
    <xsl:variable name="bookmark.gif" select="concat($globalimages-path,'bookmark.gif')"/>
    <xsl:variable name="white-spacer.bmp" select="concat($globalimages-path,'white-spacer')"/>
    <xsl:variable name="blank.gif" select="concat($globalimages-path,'blank.gif')"/>
    <xsl:variable name="diligence.gif" select="concat($globalimages-path,'diligence.gif')"/>
    <xsl:variable name="firmStyle.gif" select="concat($globalimages-path,'firmStyle.gif')"/>
    <xsl:variable name="toolkits.gif" select="concat($globalimages-path,'toolkits.gif')"/>
    <xsl:variable name="twoHundredby50PlaceHolder.gif"
                  select="concat($globalimages-path,'twoHundredby50PlaceHolder.gif')"/>
    <xsl:variable name="fortypxPlaceHolder.gif" select="concat($globalimages-path,'fortypxPlaceHolder.gif')"/>
    <xsl:variable name="fiftypxPlaceHolder.gif" select="concat($globalimages-path,'fiftypxPlaceHolder.gif')"/>
    <xsl:variable name="bullet.gif" select="concat($globalimages-path,'bullet.gif')"/>
    <xsl:variable name="bulleth.gif" select="concat($globalimages-path,'bulleth.gif')"/>
    <xsl:variable name="buttonBg.gif" select="concat($globalimages-path,'buttonBg.gif')"/>
    <xsl:variable name="codes.gif" select="concat($globalimages-path,'icons/codes.gif')"/>
    <xsl:variable name="collapseTopic.gif" select="concat($globalimages-path,'collapseTopic.gif')"/>
    <xsl:variable name="collapseTopicNav.gif" select="concat($globalimages-path,'collapseTopicNav.gif')"/>
    <xsl:variable name="compare.gif" select="concat($globalimages-path,'compare.gif')"/>
    <xsl:variable name="cpd.gif" select="concat($globalimages-path,'cpd.gif')"/>
    <xsl:variable name="cpseLogo.gif" select="concat($globalimages-path,'cpseLogo.gif')"/>
    <xsl:variable name="CVS.gif" select="concat($globalimages-path,'CVS.gif')"/>
    <xsl:variable name="document.gif" select="concat($globalimages-path,'document.gif')"/>
    <xsl:variable name="downArrowBlue.gif" select="concat($globalimages-path,'downArrowBlue.gif')"/>
    <xsl:variable name="downArrow.gif" select="concat($globalimages-path,'downArrow.gif')"/>
    <xsl:variable name="downArrowDisabled.gif" select="concat($globalimages-path,'downArrowDisabled.gif')"/>
    <xsl:variable name="draftAndNotes.gif" select="concat($globalimages-path,'draftAndNotes.gif')"/>
    <xsl:variable name="expandTopic.gif" select="concat($globalimages-path,'expandTopic.gif')"/>
    <xsl:variable name="expandTopicNav.gif" select="concat($globalimages-path,'expandTopicNav.gif')"/>
    <xsl:variable name="fdiLogo.gif" select="concat($globalimages-path,'fastDraftIntegration/fdiLogo.gif')"/>
    <xsl:variable name="fdiGo.gif" select="concat($globalimages-path,'fastDraftIntegration/go.gif')"/>
    <xsl:variable name="firmStyle15px.gif" select="concat($globalimages-path,'firmStyle15px.gif')"/>
    <xsl:variable name="fishes.gif" select="concat($globalimages-path,'fishes.gif')"/>
    <xsl:variable name="followUp.gif" select="concat($globalimages-path,'icons/followUp.gif')"/>
    <xsl:variable name="gcDec2004.gif" select="concat($globalimages-path,'gcDec2004.gif')"/>
    <xsl:variable name="headingBg.gif" select="concat($globalimages-path,'headingBg.gif')"/>
    <xsl:variable name="headingBgService.gif" select="concat($globalimages-path,'headingBgService.gif')"/>
    <xsl:variable name="horizDots.gif" select="concat($globalimages-path,'horizDots.gif')"/>
    <xsl:variable name="info.gif" select="concat($globalimages-path,'i.gif')"/>
    <xsl:variable name="leftTabOutlineOff.gif" select="concat($globalimages-path,'leftTabOutlineOff.gif')"/>
    <xsl:variable name="leftTabOutlineOn.gif" select="concat($globalimages-path,'leftTabOutlineOn.gif')"/>
    <xsl:variable name="leftTabOutlineOnHover.gif" select="concat($globalimages-path,'leftTabOutlineOnHover.gif')"/>
    <xsl:variable name="listBullet.gif" select="concat($globalimages-path,'listBullet.gif')"/>
    <xsl:variable name="listBulletResources.gif" select="concat($globalimages-path,'listBulletResources.gif')"/>
    <xsl:variable name="middleTabOutlineOff.gif" select="concat($globalimages-path,'middleTabOutlineOff.gif')"/>
    <xsl:variable name="middleTabOutlineOn.gif" select="concat($globalimages-path,'middleTabOutlineOn.gif')"/>
    <xsl:variable name="middleTabOutlineOnHover.gif" select="concat($globalimages-path,'middleTabOutlineOnHover.gif')"/>
    <xsl:variable name="resourceDetails.gif" select="concat($globalimages-path,'icons/newChecklist.gif')"/>
    <xsl:variable name="resourceHistory.gif" select="concat($globalimages-path,'icons/newDocument.gif')"/>
    <xsl:variable name="noExpandTopic.gif" select="concat($globalimages-path,'noExpandTopic.gif')"/>
    <xsl:variable name="noExpandTopicNav.gif" select="concat($globalimages-path,'noExpandTopicNav.gif')"/>
    <xsl:variable name="notesOnly.gif" select="concat($globalimages-path,'notesOnly.gif')"/>
    <xsl:variable name="PLCMag2004.gif" select="concat($globalimages-path,'PLCMag2004.gif')"/>
    <xsl:variable name="rightTabOutlineOff.gif" select="concat($globalimages-path,'rightTabOutlineOff.gif')"/>
    <xsl:variable name="rightTabOutlineOn.gif" select="concat($globalimages-path,'rightTabOutlineOn.gif')"/>
    <xsl:variable name="rightTabOutlineOnHover.gif" select="concat($globalimages-path,'rightTabOutlineOnHover.gif')"/>
    <xsl:variable name="siteChanges.gif" select="concat($globalimages-path,'siteChanges.gif')"/>
    <xsl:variable name="superScriptPLC.gif" select="concat($globalimages-path,'superScriptPLC.gif')"/>
    <xsl:variable name="superScriptPLCDark.gif" select="concat($globalimages-path,'superScriptPLCDark.gif')"/>
    <xsl:variable name="superScriptPLCDarkLarger.gif"
                  select="concat($globalimages-path,'superScriptPLCDarkLarger.gif')"/>
    <xsl:variable name="superScriptPLCDarkLargerBlack.gif"
                  select="concat($globalimages-path,'superScriptPLCDarkLargerBlack.gif')"/>
    <xsl:variable name="superScriptPLCHover.gif" select="concat($globalimages-path,'superScriptPLCHover.gif')"/>
    <xsl:variable name="superScriptPLCLarger.gif" select="concat($globalimages-path,'superScriptPLCLarger.gif')"/>
    <xsl:variable name="tabBg.gif" select="concat($globalimages-path,'tabBg.gif')"/>
    <xsl:variable name="upArrow.gif" select="concat($globalimages-path,'upArrow.gif')"/>
    <xsl:variable name="upArrowDisabled.gif" select="concat($globalimages-path,'upArrowDisabled.gif')"/>
    <xsl:variable name="url.gif" select="concat($globalimages-path,'url.gif')"/>
    <xsl:variable name="vertDots.gif" select="concat($globalimages-path,'vertDots.gif')"/>
    <xsl:variable name="whitePx.gif" select="concat($globalimages-path,'whitePx.gif')"/>
    <xsl:variable name="edit.gif" select="concat($globalimages-path,'edit.gif')"/>
    <xsl:variable name="help_icon.gif" select="concat($globalimages-path,'help_icon.gif')"/>
    <xsl:variable name="top.gif" select="concat($globalimages-path,'topnew.gif')"/>
    <xsl:variable name="noteInfo.gif" select="concat($globalimages-path,'i2.gif')"/>
    <xsl:variable name="editDocument.gif" select="concat($globalimages-path,'icons/editDocument.gif')"/>
    <xsl:variable name="editAnnotation.gif" select="concat($globalimages-path,'icons/editAnnotation.gif')"/>
    <xsl:variable name="newAnnotation.gif" select="concat($globalimages-path,'icons/newAnnotation.gif')"/>
    <xsl:variable name="annotationHistory.gif" select="concat($globalimages-path,'icons/annotationHistory.gif')"/>
    <xsl:variable name="save.gif" select="concat($globalimages-path,'icons/save.gif')"/>
    <xsl:variable name="cancel.gif" select="concat($globalimages-path,'icons/cancel.gif')"/>
    <xsl:variable name="delete.gif" select="concat($globalimages-path,'icons/delete.gif')"/>
    <xsl:variable name="fd-icon-white.gif" select="concat($globalimages-path,'icons/fd-icon-white.gif')"/>
    <xsl:variable name="fd-icon-grey.gif" select="concat($globalimages-path,'icons/fd-icon-grey.gif')"/>
    <xsl:variable name="listBranch.gif" select="concat($globalimages-path,'listBranch.gif')"/>

    <xsl:variable name="serviceimages-path" select="$resourcefile/page-resource/paths/images"/>

    <xsl:variable name="wl-search-path">http://whichlawyer.practicallaw.com/which/search.do</xsl:variable>

    <!-- Define  javascript files  -->
    <xsl:variable name="windowControl.js"
                  select="concat($scripts-path,'core/windowControl.js?version=',$softwareVersion)"/>
    <xsl:variable name="search.js" select="concat($scripts-path,'core/search.js?version=',$softwareVersion)"/>
    <xsl:variable name="searchhi.js" select="concat($scripts-path,'core/searchhi.js?version=',$softwareVersion)"/>

    <xsl:variable name="searchBrowseFor.js"
                  select="concat($scripts-path,'core/searchBrowseFor.js?version=',$softwareVersion)"/>
    <xsl:variable name="hideShowHelpDiv.js"
                  select="concat($scripts-path,'core/hideShowHelpDiv.js?version=',$softwareVersion)"/>
    <xsl:variable name="resource.js"
                  select="concat($scripts-path,'core/standardResource.js?version=',$softwareVersion)"/>
    <xsl:variable name="multilink.js" select="concat($scripts-path,'core/multilink.js?version=',$softwareVersion)"/>
    <xsl:variable name="annotate.js" select="concat($scripts-path,'annotate/annotate.js?version=',$softwareVersion)"/>
    <xsl:variable name="tiny_mce.js"
                  select="concat($scripts-path,'tinymce/jscripts/tiny_mce/tiny_mce.js?version=',$softwareVersion)"/>
    <xsl:variable name="draftingNotes.js"
                  select="concat($scripts-path,'core/draftingNotes.js?version=',$softwareVersion)"/>
    <xsl:variable name="google.js" select="concat($scripts-path,'core/google.js?version=',$softwareVersion)"/>


    <!-- concatenated and minified javascript -->
    <xsl:variable name="core.js" select="concat($scripts-path,'min/core.js?version=',$softwareVersion)"/>
    <xsl:variable name="PLC-min.js" select="concat($scripts-path,'../lib/PLC/PLC.js?version=',$softwareVersion)"/>
    <xsl:variable name="annotate-min.js"
                  select="concat($scripts-path,'minified/annotate.js?version=',$softwareVersion)"/>
    <xsl:variable name="searchAndTopics.js"
                  select="concat($scripts-path,'minified/searchAndTopics.js?version=',$softwareVersion)"/>

    <!-- define the entities -->
    <xsl:variable name="copyright" select="'&#169;'"/>
    <xsl:variable name="nbsp" select="'&#160;'"/>

    <!-- Any selective CrossBorder handbook questions and answers. -->
    <xsl:variable name="qaCrossBorder" select="plcdata/contentSection/contentBody/articleHolder/crossBorderQA"/>
    <xsl:variable name="qaQuestionsSelected" select="$qaCrossBorder/questionsSelected/questionsSelectedItem"/>
    <xsl:variable name="qaAnswers" select="$qaCrossBorder/answersSelected/jurisdictionAnswer"/>

    <!-- These decide whether there are any annotation notes to show and js scripts to include in the html header. -->
    <xsl:variable name="commentContents"
                  select="/plcdata/contentSection/contentBody/articleHolder/annotateNoteHolder/notes/annotateNote[string-length(normalize-space(contentText)) &gt; 0]"/>
    <xsl:variable name="noCommentContents"
                  select="/plcdata/contentSection/contentBody/articleHolder/annotateNoteHolder/notes/annotateNote[string-length(normalize-space(contentText)) = 0][isWriteable='true']"/>


    <!-- search config options and parameters -->
    <xsl:variable name="searchOptions"
                  select="$resourcefile/page-resource/searchConfig/searchOptions/options[@site=$site or (not(@site) and not($resourcefile/page-resource/searchConfig/searchOptions/options[@site=$site]))]"/>
    <xsl:variable name="searchParams" select="/plcdata/contentSection/contentBody/userSearchParameters"/>

    <xsl:variable name="topicParameters">
        <xsl:variable name="topicDefaults"
                      select="$resourcefile/page-resource/searchConfig/topicDefaults[@site=$site or (not(@site) and not($resourcefile/page-resource/searchConfig/topicDefaults[@site=$site]))]"/>
        <xsl:for-each select="$topicDefaults/resourceType">&amp;rt=<xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="topicDefaults/practiceArea">&amp;pa=<xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$topicDefaults/service">&amp;sv=<xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$topicDefaults/jurisdiction">&amp;ju=<xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:variable>


    <!-- labels - if overrides are present in the messages xml use them, otherwise use these -->

    <xsl:variable name="messagelabels" select="$messagefile/messages/label"/>

    <xsl:variable name="label-advancedSearch">
        <xsl:choose>
            <xsl:when test="$messagelabels[@name='advancedSearch']">
                <xsl:value-of select="$messagelabels[@name='advancedSearch']"/>
            </xsl:when>
            <xsl:otherwise>Advanced search (beta)</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="label-standardSearch">
        <xsl:choose>
            <xsl:when test="$messagelabels[@name='standardSearch']">
                <xsl:value-of select="$messagelabels[@name='standardSearch']"/>
            </xsl:when>
            <xsl:otherwise>Standard search</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="label-servicesAndTopics">
        <xsl:choose>
            <xsl:when test="$messagelabels[@name='servicesAndTopics']">
                <xsl:value-of select="$messagelabels[@name='servicesAndTopics']"/>
            </xsl:when>
            <xsl:otherwise>Services and topics</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="label-resourceTypes">
        <xsl:choose>
            <xsl:when test="$messagelabels[@name='resourceTypes']">
                <xsl:value-of select="$messagelabels[@name='resourceTypes']"/>
            </xsl:when>
            <xsl:otherwise>Resource types</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="label-resourceType">
        <xsl:choose>
            <xsl:when test="$messagelabels[@name='resourceType']">
                <xsl:value-of select="$messagelabels[@name='resourceType']"/>
            </xsl:when>
            <xsl:otherwise>Resource type</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <!-- UI Service -->

    <xsl:variable name="ui-service-path" select="'./service/plcui'"/>
    <xsl:variable name="ui-service-widget-path" select="concat($ui-service-path,'/widget')"/>
    <xsl:variable name="ui-service-version" select="$resourcefile/page-resource/uiservice/version"/>
    <!-- overridden by resource.xml -->

    <!-- messages -->
    <xsl:template match="messages/message">
        <xsl:copy-of select="*"/>
    </xsl:template>

</xsl:stylesheet>