<?xml version="1.0" encoding="utf-8"?>

<!-- CB refactored Oct 2005 to deal with combo contract/deed execution -->
<!-- CB modified Mar 2008 to deal with companies act changes -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="signature">
        <xsl:choose>
            <xsl:when test="descendant::text()">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="ancestor::minutes">
                <p>...................................................</p>
                <p>Chairperson</p>
                <p>....................................................</p>
                <p>(Date)</p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <table class="tableShade" cellpadding="5" border="0" cellspacing="0">
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
                                                <xsl:value-of select="substring-after(defitem/defterm,'(')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="defitem/defterm"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="execdeedwording">
                                <xsl:text>Executed</xsl:text>
                            </xsl:variable>
                            <!-- CB Mar 2008 no longer use the word signed(discussed with Nick C-R)
                            <xsl:choose>
                            <xsl:when test="attribute::signatureformat='lrstandard'">Signed</xsl:when>
                            <xsl:otherwise>Executed</xsl:otherwise>
                            </xsl:choose>-->


                            <xsl:choose>
                                <!-- company execution -->
                                <xsl:when test="attribute::status='company'">
                                    <xsl:if test="attribute::executionmethod='contract'">
                                        <xsl:call-template name="comp-contract">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                    <xsl:if test="attribute::executionmethod='deed'">
                                        <xsl:call-template name="comp-deed">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                            <xsl:with-param name="execdeedwording" select="$execdeedwording"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                    <xsl:if test="attribute::executionmethod='both'">
                                        <xsl:call-template name="comp-contract">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeorrow"/>
                                        <xsl:call-template name="comp-deed">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                            <xsl:with-param name="execdeedwording" select="$execdeedwording"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                </xsl:when>
                                <!-- guarantor execution -->
                                <xsl:when test="attribute::status='guarantor'">
                                    <xsl:call-template name="makeblankspace"/>
                                    <tr>
                                        <td valign='top'>
                                            <p>
                                                <xsl:value-of select="$execdeedwording"/> as a deed by [NAME OF
                                                <xsl:call-template name='convertcase'>
                                                    <xsl:with-param name='toconvert'>
                                                        <xsl:value-of select="$partyname"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                </xsl:call-template>
                                                ]
                                                acting by [NAME OF FIRST DIRECTOR] and [NAME OF SECOND
                                                DIRECTOR/SECRETARY]
                                            </p>
                                        </td>
                                        <td>
                                            <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
                                        </td>
                                        <td>
                                            <p>....................</p>
                                            <p>Director</p>
                                            <p>....................</p>
                                            <p>Director/Secretary</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='2'>OR</td>
                                    </tr>
                                    <tr>
                                        <td valign='top'>
                                            <p>Signed as a deed by [NAME OF
                                                <xsl:call-template name='convertcase'>
                                                    <xsl:with-param name='toconvert'>
                                                        <xsl:value-of select="$partyname"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                </xsl:call-template>
                                                ]
                                                in the presence of [NAME OF WITNESS]
                                            </p>
                                        </td>
                                        <td>
                                            <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
                                        </td>
                                        <td>
                                            <p>....................</p>
                                            <p>[SIGNATURE OF
                                                <xsl:call-template name='convertcase'>
                                                    <xsl:with-param name='toconvert'>
                                                        <xsl:value-of select="$partyname"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                </xsl:call-template>
                                                ]
                                            </p>
                                            <p>....................</p>
                                            <p>[SIGNATURE OF WITNESS]</p>
                                            <p>....................</p>
                                            <p>[NAME OF WITNESS]</p>
                                            <p>....................</p>
                                            <p>....................</p>
                                            <p>[ADDRESS OF WITNESS]</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign='top'>
                                            <p>Signed as a deed by [NAME OF
                                                <xsl:call-template name='convertcase'>
                                                    <xsl:with-param name='toconvert'>
                                                        <xsl:value-of select="$partyname"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                </xsl:call-template>
                                                ]
                                                in the presence of [NAME OF WITNESS]
                                            </p>
                                        </td>
                                        <td>
                                            <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
                                        </td>
                                        <td>
                                            <p>....................</p>
                                            <p>[SIGNATURE OF
                                                <xsl:call-template name='convertcase'>
                                                    <xsl:with-param name='toconvert'>
                                                        <xsl:value-of select="$partyname"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                </xsl:call-template>
                                                ]
                                            </p>
                                            <p>....................</p>
                                            <p>[SIGNATURE OF WITNESS]</p>
                                            <p>....................</p>
                                            <p>[NAME OF WITNESS]</p>
                                            <p>....................</p>
                                            <p>....................</p>
                                            <p>[ADDRESS OF WITNESS]</p>
                                        </td>
                                    </tr>
                                </xsl:when>
                                <!-- individual execution -->
                                <xsl:when test="attribute::status='individual'">
                                    <xsl:if test="attribute::executionmethod='contract'">
                                        <xsl:call-template name="indiv-contract">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                    <xsl:if test="attribute::executionmethod='deed'">
                                        <xsl:call-template name="indiv-deed">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                    <xsl:if test="attribute::executionmethod='both'">
                                        <xsl:call-template name="indiv-contract">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeorrow"/>
                                        <xsl:call-template name="indiv-deed">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
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
                                        <xsl:call-template name="makeblankspace"/>
                                        <xsl:call-template name="indiv-contract">
                                            <xsl:with-param name="partyname" select="$singpn"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                        <xsl:call-template name="indiv-contract">
                                            <xsl:with-param name="partyname" select="$singpn"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                    <xsl:if test="attribute::executionmethod='deed'">
                                        <xsl:call-template name="indiv-deed">
                                            <xsl:with-param name="partyname" select="$singpn"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                        <xsl:call-template name="indiv-deed">
                                            <xsl:with-param name="partyname" select="$singpn"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                        <xsl:call-template name="indiv-deed">
                                            <xsl:with-param name="partyname" select="$singpn"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                    </xsl:if>
                                </xsl:when>
                                <!-- company/individual execution -->
                                <xsl:when test="attribute::status='individual-company'">
                                    <xsl:if test="attribute::executionmethod='contract'">
                                        <tr>
                                            <td valign='top'>
                                                <p>Signed by [NAME OF DIRECTOR]<br/>for and on behalf of [NAME OF
                                                    <xsl:call-template name='convertcase'>
                                                        <xsl:with-param name='toconvert'>
                                                            <xsl:value-of select="$partyname"/>
                                                        </xsl:with-param>
                                                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                    </xsl:call-template>
                                                    ]
                                                </p>
                                            </td>
                                            <td>
                                                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
                                            </td>
                                            <td>
                                                <p>....................</p>
                                                <p>Director</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign='top'>OR</td>
                                        </tr>
                                        <tr>
                                            <td valign='top'>
                                                <p>Signed by [NAME OF
                                                    <xsl:call-template name='convertcase'>
                                                        <xsl:with-param name='toconvert'>
                                                            <xsl:value-of select="$partyname"/>
                                                        </xsl:with-param>
                                                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                                                    </xsl:call-template>
                                                    ]
                                                </p>
                                            </td>
                                            <td>
                                                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
                                            </td>
                                            <td>
                                                <p>....................</p>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="attribute::executionmethod='deed'">
                                        <xsl:call-template name="indiv-deed">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeorrow"/>
                                        <xsl:call-template name="comp-deed">
                                            <xsl:with-param name="partyname" select="$partyname"/>
                                            <xsl:with-param name="execdeedwording" select="$execdeedwording"/>
                                        </xsl:call-template>
                                        <xsl:call-template name="makeblankspace"/>
                                        <!--<tr><td valign='top'>
                                        <p><xsl:value-of select="$execdeedwording"/> as a deed by [NAME OF <xsl:call-template name='convertcase'>
                    <xsl:with-param name='toconvert'><xsl:value-of select="$partyname"/></xsl:with-param>
                    <xsl:with-param name='conversion'>upper</xsl:with-param></xsl:call-template>]
                                        acting by [NAME OF FIRST DIRECTOR] and [NAME OF SECOND DIRECTOR/SECRETARY] </p>
                                        </td>
                                        <td><img src='/presentation/images/common/blank.gif' width='50' height='1' /></td>
                                        <td>
                                        <p>....................</p>
                                        <p>Director</p>
                                        <p>....................</p>
                                        <p>Director/Secretary</p>
                                        </td>
                                        </tr>
                                        <tr><td valign='top'>OR</td></tr>
                                        <tr><td valign='top'>
                                        <p>Signed as a deed by [NAME OF <xsl:call-template name='convertcase'>
                    <xsl:with-param name='toconvert'><xsl:value-of select="$partyname"/></xsl:with-param>
                    <xsl:with-param name='conversion'>upper</xsl:with-param></xsl:call-template>]</p>
                                        </td>
                                        <td><img src='/presentation/images/common/blank.gif' width='50' height='1' /></td>
                                        <td valign='top'>
                                        <p>....................</p>
                                        <p>[SIGNATURE OF <xsl:value-of select="$partyname"/>]</p>
                                        </td>
                                        </tr>
                                        <tr>
                                        <td valign='top'>
                                        <p>in the presence of [NAME OF WITNESS]</p>
                                        </td>
                                        <td><img src='/presentation/images/common/blank.gif' width='50' height='1' /></td>
                                        <td valign='top'>
                                        <p>....................</p>
                                        <p>[SIGNATURE OF WITNESS]</p>
                                        <p>....................</p>
                                        <p>[NAME OF WITNESS]</p>
                                        </td>
                                        </tr>-->
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                            <tr bgcolor="#ffffff">
                                <td colspan="3">
                                    <img src='/presentation/images/common/blank.gif' width='200' height='3'/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </p>
            </xsl:otherwise>
        </xsl:choose>
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

    <xsl:template name="indiv-deed">
        <xsl:param name="partyname"/>
        <tr>
            <td valign='top'>
                <p>Signed as a deed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ] in the presence of:
                </p>
            </td>
            <td>
                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
            </td>
            <td valign='top'>
                <p>....................</p>
                <p>[SIGNATURE OF <xsl:value-of select="$partyname"/>]
                </p>
            </td>
        </tr>
        <tr>
            <td valign='top'>
                <p>....................</p>
                <p>[SIGNATURE OF WITNESS]</p>
                <p>[NAME, ADDRESS [AND OCCUPATION] OF WITNESS]</p>
            </td>
            <!--<td valign='top'>
            <p>in the presence of [NAME OF WITNESS]</p>
            </td>-->
            <td>
                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
            </td>
            <td/>
        </tr>
    </xsl:template>

    <xsl:template name="indiv-contract">
        <xsl:param name="partyname"/>
        <tr>
            <td valign='top'>
                <p>Signed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </p>
            </td>
            <td>
                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
            </td>
            <td>
                <p>....................</p>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="comp-contract">
        <xsl:param name="partyname"/>
        <tr>
            <td valign='top'>
                <p>Signed by [NAME OF DIRECTOR]<br/>for and on behalf of [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                </p>
            </td>
            <td>
                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
            </td>
            <td>
                <p>....................</p>
                <p>Director</p>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="comp-deed">
        <xsl:param name="partyname"/>
        <xsl:param name="execdeedwording"/>
        <tr>
            <td valign='top'>
                <p>
                    <xsl:value-of select="$execdeedwording"/> as a deed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                    acting by [NAME OF FIRST DIRECTOR], a director and [NAME OF SECOND DIRECTOR/SECRETARY], [a director
                    OR its secretary]
                </p>
            </td>
            <td>
                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
            </td>
            <td>
                <p>....................</p>
                <p>[SIGNATURE OF FIRST DIRECTOR]</p>
                <p>Director</p>
                <p>....................</p>
                <p>[SIGNATURE OF SECOND DIRECTOR OR SECRETARY]</p>
                <p>[Director OR Secretary]</p>
            </td>
        </tr>
        <tr>
            <td valign='top'>OR</td>
        </tr>
        <!-- the new post April 2008 wording-->
        <tr>
            <td valign='top'>
                <p>
                    <xsl:value-of select="$execdeedwording"/> as a deed by [NAME OF
                    <xsl:call-template name='convertcase'>
                        <xsl:with-param name='toconvert'>
                            <xsl:value-of select="$partyname"/>
                        </xsl:with-param>
                        <xsl:with-param name='conversion'>upper</xsl:with-param>
                    </xsl:call-template>
                    ]
                    acting by [NAME OF DIRECTOR] a director, in the presence of:
                </p>
                <p>....................</p>
                <p>[SIGNATURE OF WITNESS]</p>
                <p>[NAME, ADDRESS [AND OCCUPATION] OF WITNESS]</p>
            </td>
            <td>
                <img src='/presentation/images/common/blank.gif' width='50' height='1'/>
            </td>
            <td>
                <p>....................</p>
                <p>[SIGNATURE OF DIRECTOR]</p>
                <p>Director</p>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="makeorrow">
        <tr>
            <td>OR</td>
        </tr>
    </xsl:template>

    <xsl:template name="makeblankspace">
        <tr>
            <td>&#160;</td>
        </tr>
    </xsl:template>

    <!--
    ========================================================================
                           CONVERT CASE FUNCTIONS
                           Should probably put this somewhere more sensible
    ========================================================================
    -->

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

</xsl:stylesheet>