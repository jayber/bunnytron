<!-- 
	plc2epic.xsl
	
	Stylesheet to transform metadata retrieved from PLCINDEXNEW via plcinfo COM objects
	into valid xml for the PLC DTD
	
	Created by:	NFM
	Date:		12-Feb-2002
		
	
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="resource">
        <resourceid>
            <xsl:value-of select="@resourceid"/>
        </resourceid>
        <title>
            <xsl:value-of select="title"/>
        </title>
        <identifier>
            <xsl:value-of select="reference"/>
        </identifier>
        <datecreated>
            <xsl:value-of select="date"/>
        </datecreated>
        <datevalid>
            <xsl:choose>
                <xsl:when test="lawdate[.='']">
                    <xsl:value-of select="date"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="lawdate"/>
                </xsl:otherwise>
            </xsl:choose>
        </datevalid>
        <author>
            <xsl:value-of select="author"/>
        </author>
        <contributor>
            <xsl:value-of select="contributor"/>
        </contributor>
        <abstract>
            <para>
                <xsl:value-of select="abstract"/>
            </para>
        </abstract>
        <xsl:apply-templates select="occurrences"/>
    </xsl:template>


    <xsl:template match="occurrences">
        <xsl:apply-templates select="occurrence"/>
    </xsl:template>

    <xsl:template match="occurrence">

        <xsl:choose>

            <xsl:when test="@name[.='HasResourceType']">
                <type>
                    <xsl:apply-templates select="topic"/>
                </type>
            </xsl:when>

            <xsl:when test="@name[.='HasJurisdiction']">
                <jurisdiction>
                    <xsl:apply-templates select="topic"/>
                </jurisdiction>
            </xsl:when>

            <xsl:when test="@name[.='HasSubject']">
                <subject>
                    <xsl:apply-templates select="topic"/>
                </subject>
            </xsl:when>

            <xsl:when test="@name[.='HasSection']">
                <relation>
                    <xsl:apply-templates select="topic"/>
                </relation>
            </xsl:when>


            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>

    <xsl:template match="topic">
        <!-- use plcxlink syntax for topics -->
        <plcxlink>
            <xlink:locator>
                <xsl:attribute name="xlink:href">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:attribute name="xlink:role">Topic</xsl:attribute>
                <xsl:attribute name="xlink:title">
                    <xsl:value-of select="title"/>
                </xsl:attribute>

                <xsl:attribute name="xlink:label">
                    <xsl:value-of select="../title"/>
                </xsl:attribute>
                <xsl:value-of select="title"/>
            </xlink:locator>
        </plcxlink>
    </xsl:template>


</xsl:stylesheet>
