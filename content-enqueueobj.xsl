<?xml version="1.0" encoding="UTF-16"?>

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


  <xsl:template match="enqueue-object" mode="content">
    <h2>Enqueue object <xsl:value-of select="@name"/></h2>
    <p><xsl:value-of select="@description"/></p>
    <p><xsl:call-template name="documentation"/></p>
    <p><xsl:call-template name="changedOnAtBy"/></p>
    <hr/>

    <dl>
      <xsl:for-each select="base-table">
        <dt>
          <xsl:choose>
            <xsl:when test="@type = ../@roottab">Root table:</xsl:when>
            <xsl:otherwise>Base table:</xsl:otherwise>
          </xsl:choose>
        </dt>
        <dd>
          <code>
            <xsl:call-template name="write-href-tbl">
              <xsl:with-param name="input" select="@type"/>
            </xsl:call-template>
          </code><br/>
          Default enqueue mode <xsl:value-of select="@enqmode"/>
          <xsl:choose>
            <xsl:when test="@enqmode='S'"> (shared)</xsl:when>
            <xsl:when test="@enqmode='E'"> (exclusive)</xsl:when>
            <xsl:otherwise> (extended exclusive)</xsl:otherwise>
          </xsl:choose>
          <br/>
          Fields: 
          <xsl:for-each select="../lock-argument[@tabname=current()/@type]">
            <code>
            <xsl:call-template name="write-href">
              <xsl:with-param name="input" select="concat(@tabname, '-', @fieldname)"/>
            </xsl:call-template>
            </code>
            <xsl:if test="position()!=last()">, </xsl:if>
          </xsl:for-each>
        </dd>
      </xsl:for-each>
    </dl>
    
    <dl>  
      <dt>Lock parameters:</dt>
      <xsl:for-each select="lock-parameter">
        <dd>
          <code><xsl:value-of select="@viewfield"/></code>
          type
          <code>
          <xsl:call-template name="write-href">
            <xsl:with-param name="input" select="concat(@tabname, '-', @fieldname)"/>
          </xsl:call-template>
          </code>
          <br/>
          <xsl:value-of select="@description"/>          
        </dd>
      </xsl:for-each>
    </dl>
    
<!-- 
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
 -->
  </xsl:template>

</xsl:stylesheet>
