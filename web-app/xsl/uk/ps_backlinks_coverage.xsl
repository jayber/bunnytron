<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="cfg/cfg.xsl"/>
    <xsl:import href="../common/ps_backlinks_coverage.xsl"/>
    <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:variable name="dateFormat" select="'dd-mm-yyyy'"/>

    <xsl:param name="ps_plcreference"/>

    <xsl:template match="/">
        <xsl:if test="$resourceCount &gt; 0">
            <div class="content-meta-inner">
                <xsl:apply-templates mode="right-hand-pane"/>
                <xsl:if test="$resourceCount &lt; $estTotal">
                    <div class="meta-tool-item">
                        <a href="/{$ps_plcreference}">
                            <span>See more resources</span>
                        </a>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>