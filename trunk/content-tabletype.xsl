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


  <xsl:template match="table-type" mode="content">
    <h2>Table type <xsl:value-of select="@name"/></h2>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
    <p><xsl:call-template name="changedOnAtBy"/></p>
    <hr/>

    <xsl:choose>
      <xsl:when test="@accessmode='T'">Standard table of</xsl:when>
      <xsl:when test="@accessmode='H'">Hashed table of</xsl:when>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:call-template name="write-href">
      <xsl:with-param name="input" select="@type"/>
      <xsl:with-param name="types-only" select="false()"/>
    </xsl:call-template>
    <p/>
    <xsl:if test="key">
      Keys:
      <ol>
        <xsl:for-each select="key">
        <xsl:sort select="@keyfdpos"/>
          <li><xsl:value-of select="@keyfield"/></li>
        </xsl:for-each>
      </ol>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
