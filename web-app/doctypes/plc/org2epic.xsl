<!-- 
	org2epic.xsl
	
	Stylesheet to transform organisation metadata retrieved from 
	PLCINDEXNEW via plcinfo COM objects into valid xml for the PLC DTD
	
	Created by:	NFM
	Date:		6-Jun-2002
		
	
	http://www.w3.org/1999/XSL/Transform

	
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

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
        <abstract>
            <para xml:space="preserve"><xsl:value-of select="postaladdress"/>
T <xsl:value-of select="telephone"/>
F <xsl:value-of select="facsimile"/>
E <xsl:value-of select="email"/>
W <xsl:value-of select="identifier"/>
Total partners: <xsl:value-of select="partners"/>
Total lawyers: <xsl:value-of select="lawyers"/>
Partners worldwide: <xsl:value-of select="worldwide"/>
Lawyers worldwide: <xsl:value-of select="lawyersworldwide"/></para>
        </abstract>
    </xsl:template>


</xsl:stylesheet>
