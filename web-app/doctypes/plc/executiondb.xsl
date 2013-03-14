<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>

    <xsl:template match="precedent/signature|precedentform/signature|closing/signature">
        <signature>
            <xsl:choose>
                <xsl:when test="text()">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="clause">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="ancestor::minutes">
                    <table frame="none" pgwide="1" tabstyle="tableShade">
                        <tgroup cols="1">
                            <colspec colname='c1'/>
                            <tbody>
                                <row rowsep="0">
                                    <entry colsep="0" rowsep="0">
                                        <para>&#160;</para>
                                    </entry>
                                </row>
                                <row rowsep="0">
                                    <entry colsep="0" rowsep="0">
                                        <para>...................................................</para>
                                    </entry>
                                </row>
                                <row rowsep="0">
                                    <entry colsep="0" rowsep="0">
                                        <para>Chairperson</para>
                                        <para>....................................................</para>
                                        <para>(Date)</para>
                                    </entry>
                                </row>
                            </tbody>
                        </tgroup>
                    </table>
                </xsl:when>
                <xsl:otherwise>
                    <para>
                        <table frame="none" pgwide="1" tabstyle="tableShade">
                            <tgroup>
                                <xsl:attribute name="cols">
                                    <xsl:value-of select="$execution_columns"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="$execution_columns='3'">
                                        <!--
                                        <colspec colname='c1' colwidth='52*'/>
                                        <colspec colname='c2' colwidth='8*'/>
                                        <colspec colname='c3' colwidth='40*'/>	-->
                                        <colspec colname='c1' colwidth='7.87cm'/>
                                        <colspec colname='c2' colwidth='1.43cm'/>
                                        <colspec colname='c3' colwidth='6.23cm'/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <colspec colname='c1'/>
                                        <colspec colname='c2'/>
                                    </xsl:otherwise>
                                </xsl:choose>

                                <tbody>
                                    <xsl:for-each select="preceding-sibling::parties/party">
                                        <xsl:variable name="partyname">
                                            <xsl:choose>
                                                <xsl:when test="starts-with(defitem/defterm,'(')">
                                                    <xsl:choose>
                                                        <xsl:when test="contains(defitem/defterm,')')">
                                                            <xsl:value-of
                                                                    select="substring-after((substring-before(defitem/defterm,')')),'(')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of
                                                                    select="substring-after(defitem/defterm,'(')"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="defitem/defterm"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="execdeedwording">
                                            <xsl:choose>
                                                <xsl:when test="attribute::signatureformat='lrstandard'">Signed
                                                </xsl:when>
                                                <xsl:otherwise>Executed</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <!-- company execution -->
                                            <xsl:when test="attribute::status='company'">
                                                <xsl:if test="attribute::executionmethod='contract'">
                                                    <xsl:call-template name="comp-contract">
                                                        <xsl:with-param name="partyname" select="$partyname"/>
                                                    </xsl:call-template>
                                                </xsl:if>
                                                <xsl:if test="attribute::executionmethod='deed'">
                                                    <xsl:call-template name="comp-deed">
                                                        <xsl:with-param name="partyname" select="$partyname"/>
                                                        <xsl:with-param name="execdeedwording"
                                                                        select="$execdeedwording"/>
                                                    </xsl:call-template>
                                                </xsl:if>
                                            </xsl:when>
                                            <!-- guarantor execution -->
                                            <xsl:when test="attribute::status='guarantor'">
                                                <xsl:call-template name="guarantor">
                                                    <xsl:with-param name="partyname" select="$partyname"/>
                                                    <xsl:with-param name="execdeedwording" select="$execdeedwording"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <!-- individual execution -->
                                            <xsl:when test="attribute::status='individual'">
                                                <xsl:if test="attribute::executionmethod='contract'">
                                                    <xsl:call-template name="indiv-contract">
                                                        <xsl:with-param name="partyname" select="$partyname"/>
                                                    </xsl:call-template>
                                                </xsl:if>
                                                <xsl:if test="attribute::executionmethod='deed'">
                                                    <xsl:call-template name="indiv-deed">
                                                        <xsl:with-param name="partyname" select="$partyname"/>
                                                    </xsl:call-template>
                                                </xsl:if>
                                            </xsl:when>
                                            <!-- individual several execution -->
                                            <xsl:when test="attribute::status='individual-several'">
                                                <xsl:variable name="singpn">
                                                    <xsl:call-template name="makesingular">
                                                        <xsl:with-param name="strinput" select="$partyname"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="attribute::executionmethod='contract'">
                                                    <xsl:call-template name="indiv-contract">
                                                        <xsl:with-param name="partyname" select="$singpn"/>
                                                    </xsl:call-template>
                                                    <xsl:call-template name="makeemptyrow"/>
                                                    <xsl:call-template name="indiv-contract">
                                                        <xsl:with-param name="partyname" select="$singpn"/>
                                                    </xsl:call-template>
                                                    <xsl:call-template name="makeemptyrow"/>
                                                    <xsl:call-template name="indiv-contract">
                                                        <xsl:with-param name="partyname" select="$singpn"/>
                                                    </xsl:call-template>
                                                    <xsl:call-template name="makeemptyrow"/>
                                                </xsl:if>
                                                <xsl:if test="attribute::executionmethod='deed'">
                                                    <xsl:call-template name="indiv-deed">
                                                        <xsl:with-param name="partyname" select="$singpn"/>
                                                    </xsl:call-template>
                                                    <xsl:call-template name="makeemptyrow"/>
                                                    <xsl:call-template name="indiv-deed">
                                                        <xsl:with-param name="partyname" select="$singpn"/>
                                                    </xsl:call-template>
                                                    <xsl:call-template name="makeemptyrow"/>
                                                    <xsl:call-template name="indiv-deed">
                                                        <xsl:with-param name="partyname" select="$singpn"/>
                                                    </xsl:call-template>
                                                    <xsl:call-template name="makeemptyrow"/>
                                                </xsl:if>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </tbody>
                            </tgroup>
                        </table>
                    </para>
                </xsl:otherwise>
            </xsl:choose>
        </signature>
    </xsl:template>

    <!--<xsl:template name="makeemptyrow">
        <row rowsep="0"><entry colsep="0" rowsep="0" namest="c1">
        <xsl:attribute name="nameend"><xsl:choose>
            <xsl:when test="$execution_columns='3'">c3</xsl:when>
            <xsl:otherwise>c2</xsl:otherwise>
        </xsl:choose></xsl:attribute>
        <para/><para/></entry></row>
    </xsl:template>-->

    <xsl:template name="makeemptyrow">
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para/>
                <para/>
            </entry>
            <entry colsep="0" rowsep="0"></entry>
            <xsl:if test="$execution_columns='3'">
                <entry colsep="0" rowsep="0"></entry>
            </xsl:if>
        </row>
    </xsl:template>


    <!-- The following templates define the wording for the execution choices
    i.e.
    indiv-deed
    indiv-contract
    comp-contract
    comp-deed
    guarantor
    -->

    <xsl:template name="indiv-deed">
        <xsl:param name="partyname"/>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para>Signed as a deed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>&#160;</para>
                <para>[SIGNATURE OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </para>
                <para>&#160;</para>
            </entry>
        </row>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para>in the presence of [NAME OF WITNESS]</para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>[SIGNATURE OF WITNESS]</para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>[NAME OF WITNESS]</para>
                <para>&#160;</para>
                <para>&#160;</para>
            </entry>
        </row>
    </xsl:template>

    <xsl:template name="indiv-contract">
        <xsl:param name="partyname"/>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para>Signed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
            </entry>
        </row>
    </xsl:template>

    <xsl:template name="comp-contract">
        <xsl:param name="partyname"/>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para>Signed by [NAME OF DIRECTOR]</para>
                <para xml:space="preserve">for and on behalf of [NAME OF <xsl:call-template name='convertcase'>
    <xsl:with-param name='toconvert'><xsl:value-of select="$partyname"/></xsl:with-param>
	<xsl:with-param name='conversion'>upper</xsl:with-param></xsl:call-template>]
	</para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>Director</para>
            </entry>
        </row>
    </xsl:template>

    <xsl:template name="comp-deed">
        <xsl:param name="partyname"/>
        <xsl:param name="execdeedwording"/>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para xml:space="preserve"><xsl:value-of select="$execdeedwording"/> as a deed by [NAME OF <xsl:call-template name='convertcase'>
    <xsl:with-param name='toconvert'><xsl:value-of select="$partyname"/></xsl:with-param>
	<xsl:with-param name='conversion'>upper</xsl:with-param></xsl:call-template>] acting by [NAME OF FIRST DIRECTOR] and [NAME OF SECOND DIRECTOR/SECRETARY]
</para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>Director</para>
                <para>.......................................</para>
                <para>Director/Secretary</para>
            </entry>
        </row>
    </xsl:template>

    <xsl:template name="guarantor">
        <xsl:param name="partyname"/>
        <xsl:param name="execdeedwording"/>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para xml:space="preserve"><xsl:value-of select="$execdeedwording"/> as a deed by [NAME OF <xsl:call-template 	name='convertcase'>
		    <xsl:with-param name='toconvert'><xsl:value-of select="$partyname"/></xsl:with-param>
			<xsl:with-param name='conversion'>upper</xsl:with-param></xsl:call-template>] acting by [NAME OF FIRST DIRECTOR] and 		[NAME OF SECOND DIRECTOR/SECRETARY]
			</para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>Director</para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>&#160;</para>
                <para>Director/Secretary</para>
            </entry>
        </row>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para>&#160;</para>
                <para>OR</para>
                <para>&#160;</para>
            </entry>
        </row>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para xml:space="preserve">Signed as a deed by [NAME OF <xsl:call-template name='convertcase'>
    <xsl:with-param name='toconvert'><xsl:value-of select="$partyname"/></xsl:with-param>
	<xsl:with-param name='conversion'>upper</xsl:with-param></xsl:call-template>]
					in the presence of [NAME OF WITNESS]
</para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>[SIGNATURE OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>[SIGNATURE OF WITNESS]</para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>[NAME OF WITNESS]</para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>.......................................</para>
                <para>[ADDRESS OF WITNESS]</para>
            </entry>
        </row>
        <row rowsep="0">
            <entry colsep="0" rowsep="0">
                <para>Signed as a deed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                    in the presence of [NAME OF WITNESS]
                </para>
            </entry>

            <entry colsep="0" rowsep="0">
                <para>.......................................</para>
                <para>[SIGNATURE OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>[SIGNATURE OF WITNESS]</para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>[NAME OF WITNESS]</para>
                <para>&#160;</para>
                <para>.......................................</para>
                <para>.......................................</para>
                <para>[ADDRESS OF WITNESS]</para>
            </entry>
        </row>
    </xsl:template>

    <xsl:template name="makesingular">
        <xsl:param name="strinput"/>
        <xsl:choose>
            <xsl:when test="substring($strinput, string-length($strinput) - 2) = 'ies' "><xsl:value-of
                    select="substring($strinput,0,string-length($strinput) - 2)"/>y
            </xsl:when>
            <xsl:when test="substring($strinput, string-length($strinput)) = 's' ">
                <xsl:value-of select="substring($strinput,0,string-length($strinput))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$strinput"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>