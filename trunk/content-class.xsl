<?xml version="1.0"?>

<!--
APAP - Generate javadoc-style documentation for SAP repository objects
Copyright (C) 2007  Björn Harmen Gerth

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:key name="inh-att" match="attribute[@is_inherited='X' and not(@alias_for)]" use="inheritance/@clsname"/>
  <xsl:key name="inh-mth" match="method[@is_inherited='X' and not(@is_redefined='X') and not(@alias_for)]" use="inheritance/@clsname"/>
  <xsl:key name="inh-evt" match="event[@is_inherited='X' and not(@alias_for)]" use="inheritance/@clsname"/>


  <xsl:template match="class|package/interface" mode="navbar">
    <td class="NavBarCell3">
      SUMMARY:
      <xsl:choose>
        <!-- Here: test for attribute, since inherited attributes appear in the summary as well -->
        <xsl:when test="attribute[not(@alias_for)]"><a href="#attribute-summary">ATTRIBUTE</a></xsl:when>
        <xsl:otherwise>ATTRIBUTE</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <!-- As for attributes, inherited methods appear in the summary -->
        <xsl:when test="method"><a href="#method-summary">METHOD</a></xsl:when>
        <xsl:otherwise>METHOD</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <!-- As for attributes, inherited events appear in the summary -->
        <xsl:when test="event[not(@alias_for)]"><a href="#event-summary">EVENT</a></xsl:when>
        <xsl:otherwise>EVENT</xsl:otherwise>
      </xsl:choose>
    </td>
    <td class="NavBarCell3">
      DETAIL: 
      <xsl:choose>
        <!-- Here: test only for non-inherited attributes, others are left out of detail list -->
        <xsl:when test="attribute[not(@is_inherited='X')][not(@alias_for)]"><a href="#attribute-details">ATTRIBUTE</a></xsl:when>
        <xsl:otherwise>ATTRIBUTE</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="method[not(@is_inherited='X') or @is_redefined='X'][not(@alias_for)]"><a href="#method-details">METHOD</a></xsl:when>
        <xsl:otherwise>METHOD</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="event[not(@is_inherited='X')][not(@alias_for)]"><a href="#event-details">EVENT</a></xsl:when>
        <xsl:otherwise>EVENT</xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>

  <xsl:template match="class|package/interface" mode="content">
    <h2>
      <xsl:value-of select="translate(name(), 'ci', 'CI')"/><!-- translate class to Class and interface to Interface -->
      <xsl:text> </xsl:text>
      <xsl:value-of select="@name"/>
    </h2>
    
    <!-- the following lines are in such a weird notation because <pre> takes 
          CR/LF in the source into account -->
    <pre>
<xsl:for-each select="superclass"><xsl:sort select="@dist" order="descending"/><xsl:if test="position()!='1'"><xsl:call-template name="put_spaces"><xsl:with-param name="pos" select="position() - 1"/></xsl:call-template>+-- </xsl:if><xsl:call-template name="write-href"><xsl:with-param name="input" select="@name"/><xsl:with-param name="types-only" select="false()"/></xsl:call-template><br/>
<xsl:call-template name="put_spaces"/>|
</xsl:for-each>
<xsl:call-template name="put_spaces"><xsl:with-param name="pos" select="count(superclass)"/></xsl:call-template>+-- <span class="ClassHierarchyThisClass"><xsl:value-of select="@name"/></span><!-- Name of this class/intf -->
    </pre>
    
    <xsl:if test="interface">
      <dl>
        <dt>All implemented interfaces:</dt>
        <dd>
          <xsl:for-each select="interface">
            <xsl:call-template name="write-href">
                <xsl:with-param name="input" select="@name"/>
              <xsl:with-param name="types-only" select="false()"/>
            </xsl:call-template>
            <xsl:if test="position()!=last()">, </xsl:if>
          </xsl:for-each>
        </dd>
      </dl>
    </xsl:if>

    <xsl:if test="subclass">
      <dl>
        <dt>Direct known subclasses:</dt>
        <dd>
          <xsl:for-each select="subclass">
            <xsl:call-template name="write-href">
                <xsl:with-param name="input" select="@name"/>
              <xsl:with-param name="types-only" select="false()"/>
            </xsl:call-template>
            <xsl:if test="position()!=last()">, </xsl:if>
          </xsl:for-each>
        </dd>
      </dl>
    </xsl:if>
    <hr/>


    <!-- The first value-of writes either 'class' or 'interface' -->
    <xsl:value-of select="name()"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>
    <xsl:if test="superclass"> <!-- not possible for an interface -->
       inheriting from 
      <xsl:call-template name="write-href">
        <xsl:with-param name="input" select="superclass[1]/@name"/>
        <xsl:with-param name="types-only" select="false()" />
      </xsl:call-template>
    </xsl:if>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
<!--    
    <xsl:value-of select="documentation/functionality/text()"/>
    <xsl:if test="documentation/see-also">
    <br/>
    See also:
    <xsl:call-template name="resolveIDREFS">
      <xsl:with-param name="stringToTokenize" select="documentation/see-also/text()"/>
    </xsl:call-template>
    </xsl:if>
 --> 
    <p>
    <xsl:call-template name="createdOnBy"/>
    <xsl:call-template name="changedOnAtBy"/>
    </p>
        
    <hr/>

    <xsl:comment>=============== Attribute summary ===============</xsl:comment>
    <a name="attribute-summary"/>
    <xsl:if test="attribute">
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="2">Attribute summary</th>
      </tr>
      <xsl:for-each select="attribute[not(@is_inherited='X')][not(@alias_for)]">
        <tr CLASS="TableRowColor">
          <td>
            <code>
            <xsl:call-template name="att-att"/>
            </code>
          </td>
          <td>
            <code><a href="#{@name}"><xsl:value-of select="@name"/></a></code><br />
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    
    <xsl:for-each select="attribute[generate-id(.)=generate-id(key('inh-att', inheritance/@clsname))]">
    <xsl:sort select="inheritance/@clsname"/>
    <p>
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableSubHeadingColor">
          <Th>Attributes inherited from class
            <xsl:call-template name="write-href">
              <xsl:with-param name="input" select="inheritance/@clsname"/>
              <xsl:with-param name="types-only" select="false()"/>
            </xsl:call-template>
          </Th>
        </TR>
        <TR CLASS="TableRowColor">
          <TD>
            <code>
            <xsl:for-each select="../attribute[inheritance/@clsname=current()/inheritance/@clsname]">
            <xsl:call-template name="write-href">
              <xsl:with-param name="input" select="concat(inheritance/@clsname, '~', @name)"/>
            </xsl:call-template>
            <xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
            </code>
          </TD>
          </TR>
      </TABLE>
    </p>
    </xsl:for-each>
    </xsl:if>
    <p/>
    

    <xsl:comment>=============== Method summary ===============</xsl:comment>
    <a name="method-summary"/>
    <xsl:if test="method">
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="2">Method summary</th>
      </tr>
      <xsl:for-each select="method[not(@is_inherited='X') or @is_redefined='X'][not(@alias_for)]">
        <tr CLASS="TableRowColor">
          <td>
            <code>
            <xsl:call-template name="mth-att"/>
            </code>
          </td>
          <td>
            <code>
            <!-- <xsl:choose>
              <xsl:when test="@alias_for">
                <a href="#{@alias_for}"><xsl:value-of select="@name"/></a>
              </xsl:when>
              <xsl:otherwise> -->
                <a href="#{@name}"><xsl:value-of select="@name"/></a>
              <!-- </xsl:otherwise>
            </xsl:choose> -->
            </code>
            <br/>
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>

    <xsl:for-each select="method[generate-id(.)=generate-id(key('inh-mth', inheritance/@clsname))]">
    <xsl:sort select="inheritance/@clsname"/>
    <p>
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableSubHeadingColor">
          <TD>Methods inherited from class
            <xsl:call-template name="write-href">
              <xsl:with-param name="input" select="inheritance/@clsname"/>
              <xsl:with-param name="types-only" select="false()" />
            </xsl:call-template>
          </TD>
        </TR>
        <TR CLASS="TableRowColor">
          <TD>
            <code>
            <xsl:for-each select="../method[inheritance/@clsname=current()/inheritance/@clsname][not(@is_redefined)]">
              <xsl:call-template name="write-href">
                <xsl:with-param name="input" select="concat(inheritance/@clsname, '~', @name)"/>
              </xsl:call-template>
              <xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
            </code>
          </TD>
          </TR>
      </TABLE>
    </p>
    </xsl:for-each>
    </xsl:if>
    <p />


    <xsl:comment>=============== Event summary ===============</xsl:comment>
    <a name="event-summary"/>
    <xsl:if test="event">
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="2">Event summary</th>
      </tr>
      <xsl:for-each select="event[not(@is_inherited='X')][not(@alias_for)]">
        <tr CLASS="TableRowColor">
          <td>
            <code>
            <xsl:call-template name="mth-att"/>
            </code>
          </td>
          <td>
            <code>
            <!-- <xsl:choose>
              <xsl:when test="@alias_for">
                <a href="#{@alias_for}"><xsl:value-of select="@name"/></a>
              </xsl:when>
              <xsl:otherwise> -->
                <a href="#{@name}"><xsl:value-of select="@name"/></a>
              <!-- </xsl:otherwise>
            </xsl:choose> -->
            </code>
            <br/>
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>

    <xsl:for-each select="event[generate-id(.)=generate-id(key('inh-evt', inheritance/@clsname))]">
    <xsl:sort select="inheritance/@clsname"/>
    <p>
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableSubHeadingColor">
          <TD>Events inherited from class
            <xsl:call-template name="write-href">
              <xsl:with-param name="input" select="inheritance/@clsname"/>
              <xsl:with-param name="types-only" select="false()" />
            </xsl:call-template>
          </TD>
        </TR>
        <TR CLASS="TableRowColor">
          <TD>
            <code>
            <xsl:for-each select="../event[inheritance/@clsname=current()/inheritance/@clsname]">
              <xsl:call-template name="write-href">
                <xsl:with-param name="input" select="concat(inheritance/@clsname, '~', @name)"/>
              </xsl:call-template>
              <xsl:if test="position()!=last()">, </xsl:if>
            </xsl:for-each>
            </code>
          </TD>
          </TR>
      </TABLE>
    </p>
    </xsl:for-each>
    </xsl:if>
    <p />


    <xsl:comment>=============== Attribute details ===============</xsl:comment>
    <a name="attribute-details"/>
    <xsl:if test="attribute[not(@is_inherited='X')]">
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableHeadingColor">
          <Th>Attribute details</Th>
        </TR>
      </TABLE>
    </xsl:if>

    <xsl:for-each select="attribute[not(@is_inherited='X')][not(@alias_for)]">
      <a name="{@name}"><xsl:comment/></a>
      <h3><xsl:value-of select="@name"/></h3>
      <code>
        <xsl:call-template name="att-att"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@name" />
      </code>
      <xsl:for-each select="../attribute[@alias_for=current()/@name]">
        alias 
        <!-- <xsl:value-of select="@visibility"/><xsl:text> </xsl:text>-->
        <code><xsl:value-of select="@name"/></code>
      </xsl:for-each>
      <dl>
        <dd><xsl:value-of select="@description" /></dd>
        <dd><xsl:call-template name="documentation"/></dd>
        <xsl:if test="att-ddic/@attvalue">
          <dd>
            <dl>
              <dt>Value:</dt>
              <dd><xsl:value-of select="att-ddic/@attvalue"/></dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="@is_interface='X'">
          <dd>
            <dl>
              <dt>Specified by:</dt>
              <dd>
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="concat(inheritance/@refclsname, '~', @name)"/>
                  </xsl:call-template>
                </code> in interface 
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="inheritance/@refclsname"/>
                    <xsl:with-param name="types-only" select="false()" />
                  </xsl:call-template>
                </code>
              </dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="att-ddic/@author != ../@author or att-ddic/@createdon != ../@createdon">
          <dd>
            <xsl:call-template name="createdOnBy">
              <xsl:with-param name="input" select="att-ddic"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="att-ddic/@changedby != ../@changedby or att-ddic/@changedon != ../@changedon">
          <dd>
            <xsl:call-template name="changedOnAtBy">
              <xsl:with-param name="input" select="att-ddic"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
      </dl>
      <xsl:if test="position()!=last()"><hr /></xsl:if>
    </xsl:for-each>
    <p />

 
    <xsl:comment>=============== Method details ===============</xsl:comment>
    <a name="method-details"/>
    <xsl:if test="method[not(@is_inherited='X') or @is_redefined='X'][not(@alias_for)]">
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableHeadingColor">
          <Th>Method details</Th>
        </TR>
      </TABLE>
    </xsl:if>

    <xsl:for-each select="method[not(@is_inherited='X') or @is_redefined='X'][not(@alias_for)]">
      <a name="{@name}"><xsl:comment /></a>
      <h3><xsl:value-of select="@name"/></h3>
      <code>
      <xsl:call-template name="mth-att"/><xsl:text> </xsl:text>
      <xsl:value-of select="@name"/>
      </code>
      <xsl:for-each select="../method[@alias_for=current()/@name]">
        alias 
        <!-- <xsl:value-of select="@visibility"/><xsl:text> </xsl:text>-->
        <code><xsl:value-of select="@name"/></code>
      </xsl:for-each>
      <dl>
        <dd><xsl:value-of select="@description" /></dd>
        <dd><xsl:call-template name="documentation"/></dd>
        <xsl:if test="@for_event">
          <dd>
            <dl>
              <dt>Event handler for</dt>
              <dd>
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="concat(@of_class, '~', @for_event)"/>
                  </xsl:call-template>
                </code> of  
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="@of_class"/>
                    <xsl:with-param name="types-only" select="false()" />
                  </xsl:call-template>
                </code>
              </dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="@is_interface='X'">
          <dd>
            <dl>
              <dt>Specified by:</dt>
              <dd>
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="concat(inheritance/@refclsname, '~', @name)"/>
                  </xsl:call-template>
                </code> in interface 
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="inheritance/@refclsname"/>
                    <xsl:with-param name="types-only" select="false()" />
                  </xsl:call-template>
                </code>
              </dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="@is_redefined='X'">
          <dd>
            <dl>
              <dt>Overrides:</dt>
              <dd>
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="concat(inheritance/@clsname, '~', @name)"/>
                  </xsl:call-template>
                </code> in class 
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="inheritance/@clsname"/>
                    <xsl:with-param name="types-only" select="false()" />
                  </xsl:call-template>
                </code>
              </dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="parameter">
          <dd>
            <dl>
              <dt>Parameters:</dt>
              <dd>
                <xsl:call-template name="method-parameters">
                  <xsl:with-param name="pname" select="'Importing'"/>
                </xsl:call-template>
                <xsl:call-template name="method-parameters">
                  <xsl:with-param name="pname" select="'Exporting'"/>
                </xsl:call-template>
                <xsl:call-template name="method-parameters">
                  <xsl:with-param name="pname" select="'Returning'"/>
                </xsl:call-template>
                <xsl:call-template name="method-parameters">
                  <xsl:with-param name="pname" select="'Changing'"/>
                </xsl:call-template>
              </dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="exception">
          <dd>
            <dl>
              <dt>Exceptions:</dt>
              <xsl:for-each select="exception">
                <dd><code><xsl:value-of select="@name"/></code><br/><xsl:value-of select="@description"/></dd>
              </xsl:for-each>
            </dl>
          </dd>
        </xsl:if>
      </dl>
      <xsl:if test="position()!=last()"><hr /></xsl:if>
    </xsl:for-each>
    <p/>
    
    <xsl:comment>=============== Event details ===============</xsl:comment>
    <a name="event-details"/>
    <xsl:if test="event[not(@is_inherited='X')][not(@alias_for)]">
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableHeadingColor">
          <Th>Event details</Th>
        </TR>
      </TABLE>
    </xsl:if>

    <xsl:for-each select="event[not(@is_inherited='X')][not(@alias_for)]">
      <a name="{@name}"><xsl:comment /></a>
      <h3><xsl:value-of select="@name"/></h3>
      <code>
      <xsl:call-template name="mth-att"/><xsl:text> </xsl:text>
      <xsl:value-of select="@name"/>
      </code>
      <xsl:for-each select="../event[@alias_for=current()/@name]">
        alias 
        <!-- <xsl:value-of select="@visibility"/><xsl:text> </xsl:text>-->
        <code><xsl:value-of select="@name"/></code>
      </xsl:for-each>
      <dl>
        <dd><xsl:value-of select="@description" /></dd>
        <dd><xsl:call-template name="documentation"/></dd>
        <xsl:if test="@is_interface='X'">
          <dd>
            <dl>
              <dt>Specified by:</dt>
              <dd>
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="concat(inheritance/@refclsname, '~', @name)"/>
                  </xsl:call-template>
                </code> in interface 
                <code>
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="inheritance/@refclsname"/>
                    <xsl:with-param name="types-only" select="false()" />
                  </xsl:call-template>
                </code>
              </dd>
            </dl>
          </dd>
        </xsl:if>
        <xsl:if test="parameter">
          <dd>
            <xsl:call-template name="method-parameters">
              <xsl:with-param name="pname" select="'Importing'"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
      </dl>
      <xsl:if test="position()!=last()"><hr /></xsl:if>
    </xsl:for-each>
    
  </xsl:template>

  <xsl:template name="method-parameters" >
    <xsl:param name="pname" />
    <xsl:variable name="ptype" select="substring($pname, 1, 1)"/>

    <xsl:if test="parameter[@parm_kind=$ptype]">
      <dl>
        <dt><xsl:value-of select="$pname"/></dt>
        <xsl:for-each select="parameter[@parm_kind=$ptype]">
          <dd>
            <code><xsl:value-of select="@name" /></code>
            <xsl:if test="@by_value='X'"> by-value</xsl:if>
            type
            <xsl:if test="@type_kind='r'"> ref to</xsl:if>
            <code> 
            <xsl:call-template name="write-href">
              <xsl:with-param name="input" select="par-ddic/@type"/>
              <xsl:with-param name="types-only" select="false()" />
            </xsl:call-template>
            </code>
            <xsl:if test="@is_optional='X'"> optional</xsl:if>
            <br/>
            <xsl:value-of select="@description"/>
          </dd>
        </xsl:for-each>
      </dl>
    </xsl:if>
  </xsl:template>

<!-- 
<xsl:template name="resolveIDREFS">
  <xsl:param name="stringToTokenize"/>
  <xsl:variable name="normalizedString">
    <xsl:value-of select="concat(normalize-space($stringToTokenize), ' ')"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$normalizedString!=' '">
      <xsl:variable name="firstOfString" select="substring-before($normalizedString, ' ')"/>
      <xsl:variable name="restOfString" select="substring-after($normalizedString, ' ')"/>
      <xsl:call-template name="write-href">
        <xsl:with-param name="input" select="$firstOfString"/>
        <xsl:with-param name="types-only" select="false()" />
      </xsl:call-template>
      <xsl:if test="$restOfString!=''">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:call-template name="resolveIDREFS">
        <xsl:with-param name="stringToTokenize" select="$restOfString"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>.</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
 -->

  <xsl:template name="att-att">
    <xsl:call-template name="visibility"/>
    <xsl:text> </xsl:text>
    <xsl:if test="@is_read_only">read-only<xsl:text> </xsl:text></xsl:if>
    <xsl:choose>
      <xsl:when test="@is_constant='X'">constant</xsl:when>
      <xsl:when test="@is_class='X'">static</xsl:when>
      <!-- <xsl:otherwise>instance</xsl:otherwise> -->
    </xsl:choose>
    <xsl:text> </xsl:text>
    <!-- <br /> -->
    <xsl:call-template name="write-href">
      <xsl:with-param name="input" select="att-ddic/@type"/>
      <xsl:with-param name="types-only" select="false()" />
    </xsl:call-template>
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template name="mth-att">
    <xsl:call-template name="visibility"/>
    <xsl:text> </xsl:text>
    <xsl:if test="@is_abstract='X'">abstract<xsl:text> </xsl:text></xsl:if>
    <xsl:choose>
      <xsl:when test="@is_class='X'">static</xsl:when>
      <!-- <xsl:otherwise>instance</xsl:otherwise> -->
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

  
  <xsl:template name="visibility">
    <xsl:choose>
      <xsl:when test="@visibility='U'">public</xsl:when>
      <xsl:when test="@visibility='O'">protected</xsl:when>
      <xsl:when test="@visibility='I'">private</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="put_spaces">
    <xsl:param name="pos" select="position()"/>
    <xsl:call-template name="put_spaces2">
      <xsl:with-param name="pos" select="$pos * 6 - 4"/>
    </xsl:call-template> 
  </xsl:template>
  
  <xsl:template name="put_spaces2">
    <xsl:param name="pos"/>
    <xsl:text> </xsl:text>
    <xsl:if test="$pos > 0">
      <xsl:call-template name="put_spaces2">
        <xsl:with-param name="pos" select="$pos - 1"/>
      </xsl:call-template> 
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
