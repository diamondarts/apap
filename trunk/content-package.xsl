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

  <xsl:template match="package" mode="navbar">
    <td class="NavBarCell3">
      SUMMARY:
      <xsl:choose>
        <xsl:when test="package"><a href="#devc">DEVC</a></xsl:when>
        <xsl:otherwise>DEVC</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="table[@tabclass!='INTTAB']"><a href="#tabl">TABL</a></xsl:when>
        <xsl:otherwise>TABL</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="dataelem"><a href="#dtel">DTEL</a></xsl:when>
        <xsl:otherwise>DTEL</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="table[@tabclass='INTTAB']"><a href="#stru">STRU</a></xsl:when>
        <xsl:otherwise>STRU</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="table-type"><a href="#ttyp">TTYP</a></xsl:when>
        <xsl:otherwise>TTYP</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="domain"><a href="#doma">DOMA</a></xsl:when>
        <xsl:otherwise>DOMA</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="enqueue-object"><a href="#enqu">ENQU</a></xsl:when>
        <xsl:otherwise>ENQU</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="class"><a href="#clas">CLAS</a></xsl:when>
        <xsl:otherwise>CLAS</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="interface"><a href="#intf">INTF</a></xsl:when>
        <xsl:otherwise>INTF</xsl:otherwise>
      </xsl:choose>
      | 
      <xsl:choose>
        <xsl:when test="function-group"><a href="#fugr">FUGR</a></xsl:when>
        <xsl:otherwise>FUGR</xsl:otherwise>
      </xsl:choose>
    </td>
    <td class="NavBarCell3">
      <xsl:comment>DETAIL</xsl:comment>
    </td>
  </xsl:template>
  
  <xsl:template match="package" mode="content-frame">
    <a href="package-summary.html" target="detailFrame">
      <span class="FrameTitleFont"><xsl:value-of select="@name"/></span>
    </a>
    <p/>
    
    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Database tables'"/>
      <xsl:with-param name="input" select="table[@tabclass!='INTTAB']"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Data elements'"/>
      <xsl:with-param name="input" select="dataelem"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Structures'"/>
      <xsl:with-param name="input" select="table[@tabclass='INTTAB']"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Table types'"/>
      <xsl:with-param name="input" select="table-type"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Domains'"/>
      <xsl:with-param name="input" select="domain"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Enqueue objects'"/>
      <xsl:with-param name="input" select="enqueue-object"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Classes'"/>
      <xsl:with-param name="input" select="class"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Interfaces'"/>
      <xsl:with-param name="input" select="interface"/>
    </xsl:call-template>
    <p />

    <xsl:call-template name="subitems-frame">
      <xsl:with-param name="header" select="'Function groups'"/>
      <xsl:with-param name="input" select="function-group"/>
    </xsl:call-template>
    
  </xsl:template>





  <xsl:template match="package" mode="content">  
    <h2>Package <xsl:value-of select="@name"/></h2>
    

    <a name="devc"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Subpackage'"/>
      <xsl:with-param name="input" select="package"/>
    </xsl:call-template>

    <p />

    <a name="tabl"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'System configuration database table'"/>
      <xsl:with-param name="input" select="table[@contflag='S']"/>
    </xsl:call-template>

    <p />

    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Configuration database table'"/>
      <xsl:with-param name="input" select="table[@contflag='C']"/>
    </xsl:call-template>

    <p />

    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Application database table'"/>
      <xsl:with-param name="input" select="table[@contflag='A']"/>
    </xsl:call-template>

    <p />

    <a name="dtel"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Data element'"/>
      <xsl:with-param name="input" select="dataelem"/>
    </xsl:call-template>

    <p />

    <a name="stru"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Structure'"/>
      <xsl:with-param name="input" select="table[@tabclass='INTTAB']"/>
    </xsl:call-template>

    <p />

    <a name="ttyp"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Table type'"/>
      <xsl:with-param name="input" select="table-type"/>
    </xsl:call-template>

    <p />

    <a name="doma"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Domain'"/>
      <xsl:with-param name="input" select="domain"/>
    </xsl:call-template>

    <p />

    <a name="enqu"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Enqueue object'"/>
      <xsl:with-param name="input" select="enqueue-object"/>
    </xsl:call-template>

    <p />

    <a name="clas"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Class'"/>
      <xsl:with-param name="input" select="class"/>
    </xsl:call-template>

    <p />

    <a name="intf"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Interface'"/>
      <xsl:with-param name="input" select="interface"/>
    </xsl:call-template>

    <p />

    <a name="fugr"><xsl:comment/></a>
    <xsl:call-template name="subitems">
      <xsl:with-param name="header" select="'Function group'"/>
      <xsl:with-param name="input" select="function-group"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="subitems">
    <xsl:param name="header" />
    <xsl:param name="input" />

    <xsl:if test="$input">
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="2"><xsl:value-of select="$header"/> summary</th>
      </tr>
      <xsl:for-each select="$input">
        <tr CLASS="TableRowColor">
          <td width="15%">
            <xsl:variable name="filename">
              <xsl:call-template name="filename">
                <xsl:with-param name="samepackage" select="true()" />
              </xsl:call-template>
            </xsl:variable>
            <a href="{$filename}"><xsl:value-of select="@name"/></a>
          </td>
          <td>
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    </xsl:if>

  </xsl:template>

  <xsl:template name="subitems-frame">
    <xsl:param name="header" />
    <xsl:param name="input" />

    <xsl:if test="$input">
    <span class="FrameHeadingFont"><xsl:value-of select="$header"/></span>
    <p/>
    
    <xsl:for-each select="$input">
      <xsl:variable name="filename">
        <xsl:call-template name="filename">
          <xsl:with-param name="samepackage" select="true()" />
        </xsl:call-template>
      </xsl:variable>
      <a href="{$filename}" target="detailFrame">
        <span class="FrameItemFont"><xsl:value-of select="@name"/></span>
      </a>
      <br/>
    </xsl:for-each>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
