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


  <xsl:template match="table" mode="navbar">
    <td class="NavBarCell3">
      SUMMARY:
      <a href="#component-summary">COMPONENT</a>
      <!-- 
      | 
      <xsl:choose>
        <xsl:when test="technical-settings"><a href="#technical-settings">TECH</a></xsl:when>
        <xsl:otherwise>TECH</xsl:otherwise>
      </xsl:choose>
       -->
    </td>
    <td class="NavBarCell3">
      DETAIL: <a href="#component-details">COMPONENT</a>
      | 
      <xsl:choose>
        <xsl:when test="entry"><a href="#entries">ENTR</a></xsl:when>
        <xsl:otherwise>ENTR</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="technical-settings"><a href="#technical-settings">TECH</a></xsl:when>
        <xsl:otherwise>TECH</xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>




  <xsl:template match="table" mode="content">
    <h2>
    <xsl:choose>
      <xsl:when test="@contflag='S'">System configuration database table</xsl:when>
      <xsl:when test="@contflag='C'">Configuration database table</xsl:when>
      <xsl:when test="@contflag='A'">Application database table</xsl:when>
      <xsl:when test="@tabclass='INTTAB'">Structure</xsl:when>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@name"/>
    </h2>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
    <p><xsl:call-template name="changedOnAtBy"/></p>
    <hr/>
    
    <xsl:comment>=============== Summary ===============</xsl:comment>
    <a name="summary"/>
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="3">Component summary</th>
      </tr>
      <xsl:for-each select="component">
        <tr CLASS="TableRowColor">
          <xsl:choose>
            <xsl:when test="@precfield">
              <td colspan="2">
                Include <xsl:value-of select="@precfield"/>
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td>
                <a href="#{@name}"><xsl:value-of select="@name"/></a>
              </td>
              <td>
                <xsl:call-template name="write-href"/>
              </td>
            </xsl:otherwise>
          </xsl:choose>
          <td>
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <p/>

    <xsl:comment>=============== Component details ===============</xsl:comment>
    <a name="component-details"/>
    <xsl:if test="component[not(@precfield)]">
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableHeadingColor">
          <Th>Component details</Th>
        </TR>
      </TABLE>
    </xsl:if>

    <xsl:for-each select="component[not(@precfield)]">
      <a name="{@name}"><xsl:comment/></a>
      <h3><xsl:value-of select="@name"/></h3>
      <code>
        <xsl:call-template name="write-href"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@name" />
      </code>
      <dl>
        <dd><xsl:value-of select="@description" /></dd>
        <dd><xsl:call-template name="documentation"/></dd>
        <xsl:if test="@checktable">
          <dd>
            <dl>
              <dt>Check table:</dt>
              <dd>
                <xsl:call-template name="write-href">
                  <xsl:with-param name="input" select="@checktable"/>
                  <xsl:with-param name="types-only" select="false()"/>
                </xsl:call-template>
              </dd>
            </dl>
          </dd>
        </xsl:if>
      </dl>
      <xsl:if test="position()!=last()"><hr /></xsl:if>
    </xsl:for-each>
    <p/>


    <xsl:comment>=============== System table entries ===============</xsl:comment>
    <a name="entries"/>
    <xsl:if test="entry">
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableHeadingColor">
          <Th colspan="100%">Entries</Th>
        </TR>
        <xsl:for-each select="component[not(@precfield)]">
          <th><xsl:value-of select="@name"/></th>
        </xsl:for-each>
        <xsl:for-each select="entry">
          <tr>
            <xsl:for-each select="attribute::*">
              <td><xsl:value-of select="."/></td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </TABLE>
      
    </xsl:if>
    <p/>

    <xsl:comment>=============== Technical settings ===============</xsl:comment>
    <a name="technical-settings"/>
    <xsl:if test="technical-settings">
      <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <TR CLASS="TableHeadingColor">
          <Th>Technical settings</Th>
        </TR>
      </TABLE>
      <!--as4local="A" -->
      <!--as4vers="0000" -->
      Category: <xsl:value-of select="technical-settings/@tabkat"/>
      <br/> 
      Kind: <xsl:value-of select="technical-settings/@tabart"/> 
      <!--schfeldanz="000" -->
      <xsl:call-template name="changedOnAtBy"><xsl:with-param name="input" select="technical-settings"/></xsl:call-template>
      <!--bufallow="N"/>-->      
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
