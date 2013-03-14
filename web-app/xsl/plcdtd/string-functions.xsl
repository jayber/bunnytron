<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!--
========================================================================
                       CONVERT CASE FUNCTIONS
========================================================================
-->

    <!-- CB April 2008
    a new file with shared string functions -->

    <xsl:template name='convertcase'>
        <xsl:param name='toconvert'/>
        <xsl:param name='conversion'/>
        <xsl:choose>
            <xsl:when test='$conversion="lower"'>
                <xsl:value-of
                        select="translate($toconvert,$ucletters,$lcletters)"/>
            </xsl:when>

            <xsl:when test='$conversion="upper"'>
                <xsl:value-of
                        select="translate($toconvert,$lcletters,$ucletters)"/>
            </xsl:when>

            <xsl:when test='$conversion="sentence"'>
                <xsl:value-of
                        select="translate(substring($toconvert,1,1),$lcletters,$ucletters)"/>
                <xsl:value-of
                        select="translate(substring($toconvert,2,string-length($toconvert)-1),$ucletters,$lcletters)"/>
            </xsl:when>

            <xsl:when test='$conversion="proper"'>
                <xsl:call-template name='convertpropercase'>
                    <xsl:with-param name='toconvert'>
                        <xsl:value-of
                                select="translate($toconvert,$ucletters,$lcletters)"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select='$toconvert'/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name='convertpropercase'>
        <xsl:param name='toconvert'/>

        <xsl:if test="string-length($toconvert) > 0">
            <xsl:variable name='f'
                          select='substring($toconvert, 1, 1)'/>

            <xsl:variable name='s' select='substring($toconvert, 2)'/>

            <xsl:call-template name='convertcase'>
                <xsl:with-param name='toconvert' select='$f'/>

                <xsl:with-param name='conversion'>upper</xsl:with-param>
            </xsl:call-template>

            <xsl:choose>
                <xsl:when test="contains($s,' ')">
                    <xsl:value-of select='substring-before($s," ")'/>
                    <xsl:text> </xsl:text>

                    <xsl:call-template name='convertpropercase'>
                        <xsl:with-param name='toconvert'
                                        select='substring-after($s," ")'/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select='$s'/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <xsl:template
            name='converttitlecase'><!-- modified version of convertpropercase which doesn't covert certain words (eg. and) -->
        <xsl:param name='toconvert'/>

        <xsl:if test="string-length($toconvert) > 0">
            <xsl:variable name='f' select='substring($toconvert, 1, 1)'/>
            <xsl:variable name='s' select='substring($toconvert, 2)'/>
            <xsl:choose>
                <xsl:when
                        test="(starts-with($toconvert,'and ')) or (starts-with($toconvert,'or ')) or (starts-with($toconvert,'the ')) or (starts-with($toconvert,'this ')) or (starts-with($toconvert,'of ')) or (starts-with($toconvert,'for ')) or (starts-with($toconvert,'on ')) or (starts-with($toconvert,'to ')) or (starts-with($toconvert,'at ')) or (starts-with($toconvert,'in ')) or (starts-with($toconvert,'a ')) or (starts-with($toconvert,'be '))">
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert' select='$f'/>
                        <xsl:with-param name='conversion'>lower</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert' select='$f'/>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="contains($s,' ')">
                    <xsl:value-of select='substring-before($s," ")'/><xsl:text> </xsl:text>
                    <xsl:call-template name='converttitlecase'>
                        <xsl:with-param name='toconvert' select='substring-after($s," ")'/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select='$s'/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:if>

    </xsl:template>


</xsl:stylesheet>
