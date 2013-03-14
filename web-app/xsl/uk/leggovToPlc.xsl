<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:default="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--<xsl:param name="legislation.relative.path" select="'/ukpga/2006/46/section/19?plc1=value&amp;timeline=true&amp;view=extent'"/>-->
    <xsl:param name="legislation.relative.path"/>

    <xsl:variable name="legtype">
        <xsl:choose>
            <xsl:when test="contains($legislation.relative.path,'uksi')">uksi</xsl:when>
            <xsl:when test="contains($legislation.relative.path,'wsi')">uksi</xsl:when>
            <xsl:when test="contains($legislation.relative.path,'ukmo')">uksi</xsl:when>
            <xsl:otherwise>ukpga</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="presentation.path" select="'/presentation/leggov'"/>
    <xsl:variable name="leggov_url" select="'www.legislation.gov.uk'"/>
    <!--<xsl:param name="wrapper.path" select="'legislation?relpath='"/>-->

    <!--<xsl:param name="wrapper.path" select="'http://corporate.d37edi.dev.practicallaw.com/ukleg'"/>-->
    <xsl:param name="wrapper.path"/>


    <xsl:output method="html"/>

    <!-- identity rule - modified to take out sitestat jscript-->

    <xsl:template match="node()|@*">
        <xsl:choose>
            <xsl:when
                    test="(preceding-sibling::comment()[contains (.,'Sitestat4')] )and (following-sibling::comment()[contains (.,'Sitestat4')])"></xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="default:div[@id='layout2']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <div id="betaStatusWarning">
                <h2>Legislation pages</h2>
                <p class="intro">are in development and are not available via our search...<a
                        href=" /about/uklegislation">find out more</a>.
                </p>
            </div>
            <div class="contentderivedmessage">
                <img alt="Legislation content from legislation.gov.uk"
                     src="/presentation/leggov/images/chrome/legGovDelivered.gif"/>
            </div>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- create leggovbody div wrapper round all  leggov output-->

    <!-- horrible hack to stop minimised br being converted to unminimised br, to be looked at again when we
         move to the xsl approach-->
    <xsl:template match="default:br">
        <xsl:text disable-output-escaping="yes">&lt;br /></xsl:text>
    </xsl:template>

    <xsl:template match="default:body">
        <!-- need to add layout1 div as its referred to by leggov in chrome.js -->
        <!-- add body classes -->
        <div id="leggovbody">
            <div>
                <xsl:attribute name="class">
                    <xsl:value-of select="@class"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <!-- take out html head -->

    <xsl:template match="default:head"/>


    <xsl:template match="default:html">
        <xsl:apply-templates/>
    </xsl:template>


    <!-- take out leggov nav, header and footer-->

    <xsl:template match="default:div[@id='header']"/>


    <xsl:template match="default:div[@id='footer']"/>

    <xsl:template match="default:div[@id='primaryNav']"/>

    <xsl:template match="default:div[@class='contentFooter']"/>

    <xsl:template match="default:p[@class='backToTop']"/>

    <!--this is never going to be called
<xsl:template match="attribute::class[parent::default:body]">
        <xsl:attribute name="class"><xsl:value-of select="."/><xsl:text> service-property</xsl:text></xsl:attribute>
    </xsl:template>-->


    <xsl:template match="default:form[@id='contentSearch']"/>

    <!-- manipulate inline URLs to go via the wapper
    some of this is a bit hacky - may need some refactoring-->
    <xsl:template match="default:a/attribute::href">

        <!--<xsl:variable name="encoded_ref"><xsl:value-of select="translate(.,'&amp;','*')"/></xsl:variable>-->

        <xsl:variable name="encoded_ref">
            <xsl:value-of select="."/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="starts-with(.,'http://')">
                <xsl:copy/>
            </xsl:when>
            <!--<xsl:when test="parent::default:a/@class='LegDS noteLink'">
                <xsl:attribute name="href">http://<xsl:value-of select="$leggov_url"/><xsl:value-of select="."/></xsl:attribute>
            </xsl:when>-->
            <xsl:when test="starts-with(.,'?')">
                <xsl:choose>
                    <xsl:when test="contains($legislation.relative.path,'?')">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$wrapper.path"/><xsl:value-of
                                select="substring-before($legislation.relative.path,'?')"/><xsl:value-of
                                select="$encoded_ref"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$wrapper.path"/><xsl:value-of select="$legislation.relative.path"/><xsl:value-of
                                select="$encoded_ref"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(.,'#')">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(.,'.pdf')">
                <xsl:attribute name="href">http://<xsl:value-of select="$leggov_url"/><xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(.,'european')">
                <xsl:attribute name="href">http://<xsl:value-of select="$leggov_url"/><xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with(.,'/id/')">
                <xsl:attribute name="href">
                    <xsl:value-of select="$wrapper.path"/><xsl:value-of select="substring-after($encoded_ref,'/id')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">
                    <xsl:value-of select="$wrapper.path"/><xsl:value-of select="$encoded_ref"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- fixes for the html timeline - these are reduced to 60%-->
    <xsl:template match="attribute::style">
        <xsl:attribute name="style">
            <xsl:call-template name="parse_style">
                <xsl:with-param name="styletoparse" select="translate(.,'&#x20;&#x9;&#xD;&#xA;', '')"/>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="parse_style">
        <xsl:param name="styletoparse"/>
        <xsl:choose>
            <xsl:when test="contains($styletoparse,'width:') and contains($styletoparse,'px')">
                <xsl:call-template name="change-width">
                    <xsl:with-param name="widthatt" select="$styletoparse"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($styletoparse,'margin-left:') and contains($styletoparse,'px')">
                <xsl:call-template name="change-marleft">
                    <xsl:with-param name="widthatt" select="$styletoparse"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$styletoparse"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="change-width">
        <xsl:param name="widthatt"/>
        <xsl:variable name="widthnum" select="substring-after($widthatt,'width:')"/>
        <xsl:variable name="widthnum2" select="substring-before($widthnum,'px')"/>
        <xsl:text>width:</xsl:text><xsl:value-of select="$widthnum2 * 0.6"/><xsl:text>px;</xsl:text>
    </xsl:template>

    <xsl:template name="change-marleft">
        <xsl:param name="widthatt"/>
        <xsl:variable name="widthnum" select="substring-after($widthatt,'margin-left:')"/>
        <xsl:variable name="widthnum2" select="substring-before($widthnum,'px')"/>
        <xsl:text>margin-left:</xsl:text><xsl:value-of select="$widthnum2 * 0.6 - 20"/><xsl:text>px;</xsl:text>
    </xsl:template>


    <!-- take out crests -->
    <xsl:template match="default:p[@class='crest']"/>


    <!-- manipulate image path - this is necessary as some of the images are of a whole si-->
    <xsl:template match="attribute::src[parent::default:img]">
        <xsl:choose>
            <xsl:when test="contains(.,'chrome')">
                <xsl:attribute name="src">
                    <xsl:value-of select="$presentation.path"/><xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="src">http://<xsl:value-of select="$leggov_url"/><xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- change leggov content class - it clashes with a plc class -->

    <xsl:template match="attribute::class[.='content']">
        <xsl:attribute name="class">
            <xsl:text>leggov_content</xsl:text>
        </xsl:attribute>
    </xsl:template>

    <!-- take out further information/next steps on more resources tab-->
    <xsl:template match="default:div[@class='relDocs colSection p_one']"/>

    <!-- take out list of all changes-->
    <xsl:template match="default:div[@class='allChanges']"/>

    <!-- take out affecting links-->
    <xsl:template match="default:div[@class='colSection p_one s_7']"/>


</xsl:stylesheet>
