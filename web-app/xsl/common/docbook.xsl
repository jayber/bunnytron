<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:db="http://docbook.org/ns/docbook"
                xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:atict="http://www.arbortext.com/namespace/atict" exclude-result-prefixes="xlink atict mml db">

    <xsl:import href="../docbook-xsl-ns-1.76.1/html/docbook.xsl"/>

    <!-- template avoids HTML and Head elements -->
    <xsl:template match="*" mode="process.root">
        <xsl:call-template name="root.messages"/>
        <xsl:apply-templates select="."/>
    </xsl:template>

    <!-- processing MML is not processed by these stylesheets, but passes through to HTML,
     this template will give an indication of the extent of this-->
    <xsl:template match="mml:math">
        <div class="plc-validation-error">Warning, unformatted equation!</div>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Docbook Revision history is "Almost" like PLC DTD,
    I have hijacked this template and used it to display resource history like the PLCDTD does -->
    <xsl:template match="db:chapter/db:info/db:revhistory" mode="titlepage.mode">
        <div id="resource_history_data" style="display:none">
            <div class="print-heading">Resource history</div>
            <a href="#null" class="meta-display-link">
                <span>Show resource history</span>
                <span class="meta-tool-item-hidden">Hide resource history</span>
            </a>
            <div class="meta-tool-item-content">
                <xsl:apply-templates mode="titlepage.mode"/>
            </div>
        </div>
    </xsl:template>

    <!-- as above -->
    <xsl:template match="db:revhistory/db:revision" mode="titlepage.mode">
        <div class="meta-history-item">
            <a href="#null" class="meta-history-link">
                <xsl:choose>
                    <xsl:when test="string-length(db:revnumber) &gt; 0">
                        <xsl:value-of select="db:revnumber"/>
                    </xsl:when>
                </xsl:choose>
            </a>
            <xsl:if test="string-length(db:revremark)&gt;0">
                <div class="meta-history-content">
                    <!-- wrapped in a P tag, as the remark is a Para in PLCDTD and cannot be in DocBook-->
                    <p>
                        <xsl:apply-templates select="db:revremark"/>
                    </p>
                </div>
            </xsl:if>
            <a class="meta-history-content meta-history-link" href="#null">Close</a>
        </div>
    </xsl:template>

    <!-- this template removes images and we will replace them later in the browser (as the URL is not known by this XSL) -->
    <xsl:template match="db:mediaobject[db:imageobject]">
        <img>
            <xsl:attribute name="class">docbook_image_target</xsl:attribute>
            <!-- wrinkle here is that for Books, sometimes the file extension is wmf, but we will convert these to gifs -->
            <xsl:attribute name="id">
                <xsl:value-of select="translate(db:imageobject/db:imagedata/@fileref,'.wmf', '.gif')"/>
            </xsl:attribute>
            <xsl:attribute name="src">/presentation/images/common/blank.gif</xsl:attribute>
        </img>
    </xsl:template>

</xsl:stylesheet>
