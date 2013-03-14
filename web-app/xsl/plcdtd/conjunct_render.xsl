<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>
    <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          XSL StyleSheet:   conjunct_render.xsl
          Description       cb sept 2004
                            now use this template to just handle conjunctive/disjunctive logic
                            new conj/disjunctive para function
          Author            Chris Beecham/Vasu Chakkera
          Dated             13 June 2005
             $Id: conjunct_render.xsl,v 1.3 2008/04/30 10:54:41 rothwed Exp $
               $Log: conjunct_render.xsl,v $
               Revision 1.3  2008/04/30 10:54:41  rothwed
               no message

               Revision 1.1  2007/06/18 13:03:43  beechamc
               *** empty log message ***

               Revision 1.1  2007/01/24 10:52:34  beechamc
               *** empty log message ***

               Revision 1.2  2006/09/11 14:26:48  stillr
               *** empty log message ***

               Revision 1.7  2005/11/30 15:08:56  chakkerav
               no message

               Revision 1.6  2005/10/28 13:59:13  chakkerav
               *** empty log message ***

               Revision 1.5  2005/09/07 14:38:24  chakkerav
               *** empty log message ***

               Revision 1.4  2005/09/07 11:03:12  chakkerav
               removed unwanted variable declaration punctchar

               Revision 1.3  2005/09/07 11:01:12  chakkerav
               This stylesheet was completely redone. only the template name remains same..

               Revision 1.2  2005/06/13 16:26:51  chakkerav
               *** empty log message ***

               Revision 1.1.1.1.2.1  2005/06/13 16:11:38  chakkerav
               additional conditions added to the templates




          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          -->
    <xsl:template name="checkjunctive">
        <xsl:variable name="current-node" select="name()"/>
        <xsl:variable name="last-node-of-topmost-clausegroup-ancestor"
                      select="count(ancestor::clausegroup/descendant::*[name()=$current-node])"/>
        <b>
            <!--<xsl:if test="not(following-sibling::*[1][self::table])">
                         1

            </xsl:if>
            <xsl:if test = " not(following-sibling::*[name() = $current-node])">
                            2
            </xsl:if>
            <xsl:if test = "not(ancestor::*[contains(name(),'subclause')][1][parent::clausegroup]/following-sibling::*[contains(name(),'subclause')]
             [not(@optionality) or @optionality = 'selected' ])">
             3
            </xsl:if>
            <xsl:if test = "not(parent::*[descendant::clausegroup])">
                                                          4
            </xsl:if>     -->
        </b>
        <xsl:choose>
            <xsl:when test="not(ancestor::clausegroup) and not(following-sibling::*[1][self::clausegroup])"/>
            <xsl:when test="following-sibling::*[1][self::clausegroup]">
                <xsl:text>:</xsl:text>
            </xsl:when>


            <xsl:when test="not(following-sibling::*[1][self::table])
			 and
			 not(following-sibling::*[name() = $current-node])
             and
             not(ancestor::*[contains(name(),'subclause')][1][parent::clausegroup]/following-sibling::*[contains(name(),'subclause')]
             [not(@optionality) or @optionality = 'selected' ])
             and
             not(parent::*[descendant::clausegroup])">
                <!--   This is for the last subclause/para
             Rule:
             1. If the next sibling is not a table  and
             If the current para is the last para of its subclause parent
                and if the subclause parent is the last subclause (that is not an unselected option) of its parent
                clausegroup. and if the ancestor clausegroup is the last clausegroup
                of its in the nested clausegroups, then the para ends with a
                punctuation : "."

             -->
                <xsl:variable name="punctuations" select="'.,!:;?'"/>
                <!--
                       This is a nested clausegroup and the para is the last para.
                       if the subclause that envelops the current clausegroup
                       is the second last subclause in the list of subclauses of the
                       clausegroup that is the ancestor of the current para's clausegroup
                       ancestor, then there could be two cases.

                        1. Clausegroup ancestor of the current para's clausegroup ancestor is
                           Conjunctive.
                             - the punctuation is ;and
                        2. Clausegroup ancestor of the current para's clausegroup ancestor is
                           Disjunctive.
                              - the punctuation is ;or

                    <b>
                          5
                    </b>     -->

                <xsl:choose>
                    <xsl:when test="(ancestor::clausegroup[1][ancestor::clausegroup] ) and
					 (count(ancestor::clausegroup[1]/parent::*[contains(name(),'subclause')]/following-sibling::*[contains(name(),'subclause')]
					 [not(@optionality) or @optionality = 'selected' ])=1)">
                        <!--
                             If the ancestor clausegroup has an ancestor clausegroup , apply punctuation rules
                              as per the list type of the ancestor clausegroup's ancestor clausegroup  and
                              if the subclause that envelops the ancestor clausegroup is the second last node
                             -->
                        <xsl:call-template name="apply-punctuations-for-second-last-subclause">
                            <xsl:with-param name="list-type"
                                            select="ancestor::clausegroup[1]/ancestor::clausegroup[1]/@listtype"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="not(contains($punctuations,substring(.,string-length(),1)))">
                        <xsl:text>.</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>;</xsl:text>
                <xsl:choose>
                    <xsl:when
                            test="ancestor::clausegroup[1]/@listtype = 'conjunctive' and count(parent::*[contains(name(),'subclause')]/following-sibling::*[contains(name(),'subclause')][not(@optionality) or @optionality = 'selected' ])=1">
                        <xsl:text> and</xsl:text>
                    </xsl:when>
                    <!--  <xsl:when test = "ancestor::clausegroup[2]/@listtype = 'conjunctive' and count(ancestor::clausegroup[1]/parent::*[contains(name(),'subclause')]/following-sibling::*[contains(name(),'subclause')][not(@optionality) or @optionality = 'selected' ])=1">

                             also give respect to the parent clause group's parent clausegroup's list type. if that is conjunctive and
                             if the parent clausegroup's parent subclause node has just one subclause following it, then we add "and"

                          <xsl:text> and</xsl:text>
                      </xsl:when> -->
                    <xsl:when test="ancestor::clausegroup[1]/@listtype = 'disjunctive'">
                        <xsl:text> or</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="apply-punctuations-for-second-last-subclause">
        <xsl:param name="list-type"/>
        <xsl:choose>
            <xsl:when test="$list-type = 'conjunctive'">
                <xsl:text>; and</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>; or</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>