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


  <xsl:template match="function-group" mode="navbar">
    <td class="NavBarCell3">
      SUMMARY:
      <xsl:choose>
        <xsl:when test="function-module"><a href="#fm-summary">FUNC</a></xsl:when>
        <xsl:otherwise>FUNC</xsl:otherwise>
      </xsl:choose>
      <!-- 
      | 
      <xsl:choose>
        <xsl:when test="method"><a href="#method-summary">METHOD</a></xsl:when>
        <xsl:otherwise>METHOD</xsl:otherwise>
      </xsl:choose>
       -->
    </td>
    <td class="NavBarCell3">
      DETAIL: 
      <xsl:choose>
        <xsl:when test="function-module"><a href="#fm-details">FUNC</a></xsl:when>
        <xsl:otherwise>FUNC</xsl:otherwise>
      </xsl:choose>
      <!-- 
      | 
      <xsl:choose>
        <xsl:when test="method[not(@is_inherited='X') or @is_redefined='X'][not(@alias_for)]"><a href="#method-details">METHOD</a></xsl:when>
        <xsl:otherwise>METHOD</xsl:otherwise>
      </xsl:choose>
       -->
    </td>
  </xsl:template>



  <xsl:template match="function-group" mode="content">
    <h2>Function group <xsl:value-of select="@name"/></h2>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
    <hr/>
    
    <xsl:comment>=============== Function module summary ===============</xsl:comment>
    <a name="fm-details"/>
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="2">Function module summary</th>
      </tr>
      <xsl:for-each select="function-module">
        <tr CLASS="TableRowColor">
          <td>
            <code>
            <a href="#{@name}"><xsl:value-of select="@name"/></a>
            </code>
          </td>
          <td>
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <p />

    <xsl:comment>=============== Function module details ===============</xsl:comment>
    <a name="fm-details"/>
    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <TR CLASS="TableHeadingColor">
        <Th>Function module details</Th>
      </TR>
    </TABLE>

    <xsl:for-each select="function-module">
      <a name="{@name}"><xsl:comment/></a>
      <h3><xsl:value-of select="@name"/></h3>
      <dl>
        <dd><xsl:value-of select="@description"/></dd>
        <dd><xsl:call-template name="documentation"/></dd>
        <xsl:if test="importing or exporting or changing or tables">
          <dd>
            <dl>
              <dt>Parameters:</dt>
              <dd>
                <xsl:call-template name="parameters">
                  <xsl:with-param name="input" select="importing"/>
                </xsl:call-template>
                <xsl:call-template name="parameters">
                  <xsl:with-param name="input" select="exporting"/>
                </xsl:call-template>
                <xsl:call-template name="parameters">
                  <xsl:with-param name="input" select="changing"/>
                </xsl:call-template>
                <xsl:call-template name="parameters">
                  <xsl:with-param name="input" select="tables"/>
                </xsl:call-template>
                <xsl:call-template name="parameters">
                  <xsl:with-param name="input" select="exceptions"/>
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

  </xsl:template>



  <xsl:template name="parameters" >
    <xsl:param name="input" />
    <xsl:if test="$input">
      <dl>
        <dt>
          <xsl:value-of select="translate(substring(name($input),1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          <xsl:value-of select="substring(name($input),2)"/>
        </dt>
        <xsl:for-each select="$input">
          <dd>
            <code><xsl:value-of select="@name" /></code>
            <xsl:if test="name()!='exception'">
              <xsl:if test="not(@reference='X')"> by-value</xsl:if>
              type
              <xsl:choose>
                <xsl:when test="starts-with(@type, 'REF TO')">
                  ref to
                  <code> 
                  <xsl:call-template name="write-href">
                    <xsl:with-param name="input" select="substring(@type, 8)"/>
                    <xsl:with-param name="types-only" select="false()"/>
                  </xsl:call-template>
                  </code>
                </xsl:when>
                <xsl:otherwise>
                  <code><xsl:call-template name="write-href"/></code>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test="@optional='X'"> optional</xsl:if>
            <xsl:if test="@default">
              default
               <code> 
               <xsl:call-template name="write-href">
                 <xsl:with-param name="input" select="@default"/>
                 <xsl:with-param name="types-only" select="false()"/>
               </xsl:call-template>
               </code>
            </xsl:if>
            <br/><xsl:value-of select="@description"/>
            <br/><xsl:call-template name="documentation"/>
          </dd>
        </xsl:for-each>
      </dl>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
