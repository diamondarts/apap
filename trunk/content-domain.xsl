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


  <xsl:template match="package/domain" mode="content">
    <h2>Domain <xsl:value-of select="@name"/></h2>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
    <p><xsl:call-template name="changedOnAtBy"/></p>
    <hr/>

    <p>Data type <xsl:value-of select="@datatype"/> length <xsl:value-of select="@leng"/></p>
    <xsl:if test="@entitytab">
      <dl>
        <dt>Value table:</dt>
        <dd>
          <xsl:call-template name="write-href">
            <xsl:with-param name="input" select="@entitytab"/>
            <xsl:with-param name="types-only" select="false()"/>
          </xsl:call-template>
        </dd>
      </dl>
    </xsl:if>

    <xsl:if test="fixed-value">
      <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
        <tr CLASS="TableHeadingColor">
          <th colspan="2">Fixed values</th>
        </tr>
        <xsl:for-each select="fixed-value">
          <tr CLASS="TableRowColor">
            <td>
              <xsl:value-of select="@domvalue_l"/>
            </td>
            <td>
              <xsl:value-of select="@description"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
    

  </xsl:template>

</xsl:stylesheet>
