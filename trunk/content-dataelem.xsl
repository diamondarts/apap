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


  <xsl:template match="dataelem" mode="content">
    <h2>Data element <xsl:value-of select="@name"/></h2>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
    <p><xsl:call-template name="changedOnAtBy"/></p>
    <hr/>

    <xsl:choose>
      <xsl:when test="@domname">    
        Domain
        <xsl:variable name="node" select="//domain[@name = current()/@domname]" />
        <xsl:choose>
          <xsl:when test="$node">
            <xsl:variable name="filename">
              <xsl:call-template name="filename">
                <xsl:with-param name="input" select="$node" />
                <xsl:with-param name="relative" select="true()" />
              </xsl:call-template>     
            </xsl:variable>
            <a href="{$filename}"><xsl:value-of select="@domname"/></a>
          </xsl:when>
    	  <xsl:otherwise>
            <xsl:value-of select="@domname"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
    (data type <xsl:value-of select="@datatype"/>, length <xsl:value-of select="@leng"/>
    <xsl:if test="@decimals!='000000'">, decimals <xsl:value-of select="@decimals"/></xsl:if>)

    <p/>
    Labels:<br/>
    <ul>
    <li><xsl:value-of select="@scrtext_s"/></li>
    <li><xsl:value-of select="@scrtext_m"/></li>
    <li><xsl:value-of select="@scrtext_l"/></li>
    <li><xsl:value-of select="@reptext"/></li>
    </ul>

  </xsl:template>

</xsl:stylesheet>
