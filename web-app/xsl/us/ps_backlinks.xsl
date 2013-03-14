<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/ps_backlinks.xsl"/>
    <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:variable name="dateFormat" select="'dd-MMM-yyyy'"/>

    <xsl:template match="/">
        <xsl:if test="$resourceCount &gt; 0">
            <div id="ps_backlinks">
                <div class="separator"></div>
                <h2>PLC content referring to this primary source</h2>
                <div class="search-results-info">
                    <xsl:choose>
                        <xsl:when test="$resourceCount &lt; $estTotal">
                            There are more than
                            <xsl:value-of select="$resourceCount"/> PLC resources which refer to this primary source.
                            The first
                            <xsl:value-of select="$resourceCount"/> resources are listed below. Please use the search
                            function, or browse the linked resources above, to help you find the resources you need.
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$resourceCount"/> result
                            <xsl:if test="$resourceCount &gt; 1">s</xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>