<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:attribute-set name="arttitle">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">6pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">6pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="sect1title">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">6pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">6pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="sect1titleMS">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">6pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">18pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="sect2title">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">6pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="figure">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">20pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="sect3title">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">6pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="MainHead">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">20pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT, sans-serif'</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="jurisHead">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">20pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT, sans-serif'</xsl:attribute>
        <xsl:attribute name="font-size">15pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="SectionHead">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">6pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">11pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="XHDUpper">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-transform">uppercase</xsl:attribute>
        <xsl:attribute name="space-before">16pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">8pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="XHDLower">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">3</xsl:attribute>
        <xsl:attribute name="space-after">6pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="Author">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">8pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="Abstract">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">12pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="Reference">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">5pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">40pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT, sans-serif'</xsl:attribute>
        <xsl:attribute name="font-size">9.5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="Body">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="BodyLA">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="BodyESA">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">50pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="BodyNSB">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="CellHead">
        <xsl:attribute name="space-before">2pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="CellBodyAlign">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">2pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="CellBody">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="space-before">2pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="CellBodySmall">
        <xsl:attribute name="space-before">2pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="BodyNoSpaceAfter">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="BodyNoSpace">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="articleinfo">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="titleindex">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section1index">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="checklisttitleindex">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section1pnotesindex">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section1qaindex">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section2index">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section3index">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="ListMarker">
        <xsl:attribute name="font-family">'Sabon MT, serif'</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="box-table">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after.precedence">2</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="font-family">'News Gothic MT'</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>