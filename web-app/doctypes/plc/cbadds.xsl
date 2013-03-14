<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:output method="xml"/>


    <xsl:template match="testimonium">
        <testimonium>
            <xsl:choose>
                <xsl:when test="para|text()">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="attribute::wording='contract'">
                    <xsl:copy-of select="$testcontwording"/>
                </xsl:when>
                <xsl:when test="(attribute::wording='deed') and ($precedenttype!='deed')">
                    <xsl:copy-of select="$testdeedndwording"/>
                </xsl:when>
                <xsl:when test="attribute::wording='deed'">
                    <xsl:copy-of select="$testdeedwording"/>
                </xsl:when>
            </xsl:choose>
        </testimonium>
    </xsl:template>

    <xsl:template match="intro">
        <intro>
            <xsl:choose>
                <xsl:when test="starts-with(descendant::text(),'HM Land')">
                    <para>This
                        <xsl:value-of select="$precedenttype"/> is dated
                    </para>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="./para">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <para>
                        <emphasis role="bold">THIS
                            <xsl:call-template name='convertcase'>
                                <xsl:with-param name='toconvert' select='$precedenttype'/>
                                <xsl:with-param name='conversion'>upper</xsl:with-param>
                            </xsl:call-template>
                        </emphasis>
                        is dated [DATE]
                    </para>
                </xsl:otherwise>
            </xsl:choose>
        </intro>
    </xsl:template>

    <xsl:template match="precedentform/intro">
        <intro>
            <xsl:choose>
                <xsl:when test="./para">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <para>
                        <emphasis role="bold">THIS
                            <xsl:call-template name='convertcase'>
                                <xsl:with-param name='toconvert'
                                                select='parent::precedentform/attribute::precedenttype'/>
                                <xsl:with-param name='conversion'>upper</xsl:with-param>
                            </xsl:call-template>
                        </emphasis>
                        is dated [DATE]
                    </para>
                </xsl:otherwise>
            </xsl:choose>
        </intro>
    </xsl:template>

    <xsl:template match="attribute::xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="substring-after(.,'#')"/>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>