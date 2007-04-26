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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:redirect="org.apache.xalan.xslt.extensions.Redirect"
  extension-element-prefixes="redirect">
  
  <xsl:param name="workdir" select="'./'" />

  <xsl:include href="string-utilities.xsl"/>
  <xsl:include href="file-utilities.xsl"/>
  <xsl:include href="content-package.xsl"/>
  <xsl:include href="content-table.xsl"/>
  <xsl:include href="content-tabletype.xsl"/>
  <xsl:include href="content-dataelem.xsl"/>
  <xsl:include href="content-domain.xsl"/>
  <xsl:include href="content-class.xsl"/>
  <xsl:include href="content-functiongroup.xsl"/>
  <xsl:include href="css.xsl"/>

  <xsl:output method="html"/>
  <xsl:template match="/">
    <xsl:message>
      APAP version 1, Copyright (C) 2007 Björn Harmen Gerth
      APAP comes with ABSOLUTELY NO WARRANTY; for details 
      see the attached LICENSE. This is free software, and 
      you are welcome to redistribute it under certain 
      conditions; see the attached LICENSE for details.
    </xsl:message>

    <xsl:message>Processing structure</xsl:message>
    <xsl:apply-templates select="application" mode="structure"/>
    <xsl:message>Processing frame</xsl:message>
    <xsl:apply-templates select="//package" mode="frame"/>
    <xsl:call-template name="frameset"/>
    <!-- <xsl:call-template name="overview-summary"/>     -->
    <xsl:call-template name="overview-frame"/>    
    <xsl:call-template name="allobjects-frame"/>   
    <xsl:call-template name="css"/> 
  </xsl:template>



  <xsl:template match="application|package|package/*" mode="structure">
    <xsl:message>Processing node <xsl:value-of select="name()" />  name=<xsl:value-of select="@name"/></xsl:message>
    <xsl:variable name="filename">
      <xsl:variable name="suffix">
        <xsl:call-template name="filename" />
      </xsl:variable>
      <xsl:value-of select="concat($workdir, $suffix)" />
    </xsl:variable>
    <xsl:variable name="topdir">
      <xsl:call-template name="topdir" />
    </xsl:variable>
    <xsl:message>
      <xsl:text> -> </xsl:text><xsl:value-of select="$filename"/>
    </xsl:message>
    <redirect:write select="$filename">
      <html>
        <xsl:call-template name="html-head">
          <xsl:with-param name="topdir" select="$topdir"/>
        </xsl:call-template>
        <body>
          <xsl:call-template name="navbar">
            <xsl:with-param name="topdir" select="$topdir"/>
          </xsl:call-template>
          <hr/>
         
          <xsl:apply-templates select="." mode="content" />

          <hr/>
          <xsl:call-template name="navbar">
            <xsl:with-param name="topdir" select="$topdir"/>
          </xsl:call-template>
        </body>
      </html>
    </redirect:write>

    <xsl:apply-templates select="*" mode="structure"/>

  </xsl:template>



  <xsl:template match="package" mode="frame">
    <xsl:message>Frame for <xsl:value-of select="name()" />  <xsl:value-of select="@name"/></xsl:message>
    <xsl:variable name="filename">
      <xsl:variable name="suffix">
        <xsl:call-template name="filename" />
      </xsl:variable>
      <xsl:value-of select="concat($workdir, substring-before($suffix,'package-summary.html'), 'package-frame.html')" />
    </xsl:variable>
    <xsl:variable name="topdir">
      <xsl:call-template name="topdir" />
    </xsl:variable>
    <redirect:write select="$filename">
      <html>
        <head>
           <title>Package <xsl:value-of select="@name"/></title>
           <link rel="stylesheet" type="text/css" href="{$topdir}format.css" />
        </head>
        <body class="Frame">
          <xsl:apply-templates select="." mode="content-frame" />
        </body>
      </html>
    </redirect:write>

  </xsl:template>

  <xsl:template name="frameset">
    <redirect:write select="concat($workdir, 'index.html')">
<!-- <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN""http://www.w3.org/TR/REC-html40/loose.dtd>-->
    <HTML>
      <xsl:call-template name="html-head"/>
      <FRAMESET cols="20%,80%">
        <FRAMESET rows="30%,70%">
          <FRAME src="overview-frame.html" name="packageListFrame"/>
          <FRAME src="allobjects-frame.html" name="packageFrame"/>
        </FRAMESET>
        <FRAME src="overview-summary.html" name="detailFrame"/>
      </FRAMESET>
      <NOFRAMES>
        <H2>Frame Alert</H2>
        <P/>
        This document is designed to be viewed using the frames feature. If you see this message, you are using a non-frame-capable web client.
        <BR/>
        Link to <A HREF="overview-summary.html">Non-frame version.</A>
      </NOFRAMES>
    </HTML>
    </redirect:write>
  </xsl:template>

  <xsl:template match="application" mode="content">
    <h1><xsl:value-of select="@name"/> API documentation</h1>
    <table border="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
      <tr CLASS="TableHeadingColor">
        <th colspan="2">Packages</th>
      </tr>
      <xsl:for-each select="//package">
        <xsl:sort select="@name"/>
        <tr CLASS="TableRowColor">
          <td>
            <xsl:variable name="filename">
              <xsl:call-template name="filename"/>
            </xsl:variable>
            <a href="{$filename}"><xsl:value-of select="@name"/></a>
          </td>
          <td>
            <xsl:value-of select="@description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <xsl:template match="application" mode="navbar">
  </xsl:template>

  <xsl:template name="overview-frame">
    <redirect:write select="concat($workdir, 'overview-frame.html')">
    <HTML>
      <xsl:call-template name="html-head"/>
      <body class="Frame">
        <p class="FrameTitleFont"><xsl:value-of select="/application/@name"/></p>
        
        <a href="allobjects-frame.html" target="packageFrame"><p class="FrameItemFont">All objects</p></a>        
        <p class="FrameHeadingFont">Packages</p>
        <xsl:for-each select="//package">
          <xsl:sort select="@name"/>
          <xsl:variable name="filename">
            <xsl:call-template name="filename"/>
          </xsl:variable>
          <a href="{concat(substring-before($filename,'package-summary.html'), 'package-frame.html')}" target="packageFrame">
            <span class="FrameItemFont"><xsl:value-of select="@name"/></span>
          </a>
          <br/>
        </xsl:for-each>
      </body>
    </HTML>
    </redirect:write>
  </xsl:template>

  <xsl:template name="allobjects-frame">
    <redirect:write select="concat($workdir, 'allobjects-frame.html')">
    <HTML>
      <xsl:call-template name="html-head"/>
      <body class="Frame">
        <p class="FrameHeadingFont">All objects</p>
        <xsl:for-each select="//package/*[name()!='package']">
          <xsl:sort select="@name"/>
          <xsl:variable name="filename">
            <xsl:call-template name="filename"/>
          </xsl:variable>
          <!-- <xsl:value-of select="name()"/> -->
          <a href="{$filename}" target="detailFrame">
            <span class="FrameItemFont"><xsl:value-of select="@name"/></span>
          </a>
          <br/>
        </xsl:for-each>
      </body>
    </HTML>
    </redirect:write>
  </xsl:template>

  <xsl:template name="html-head">
    <xsl:param name="topdir" select="''"/>
    <HEAD>
      <TITLE><xsl:value-of select="/application/@name"/> API documentation</TITLE>
      <link rel="stylesheet" type="text/css" href="{$topdir}format.css" />
    </HEAD>
  </xsl:template>

  <xsl:template name="navbar">
    <xsl:param name="topdir"/>
    
    <xsl:comment>========== START OF NAVBAR ==========</xsl:comment>
    <A NAME="navbar_top"><xsl:comment/></A>
    <TABLE BORDER="0" WIDTH="100%" CELLPADDING="1" CELLSPACING="0">
      <TR>
        <TD COLSPAN="2" CLASS="NavBarCell1">
          <A NAME="navbar_top_firstrow"><xsl:comment/></A>
          <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
            <TR ALIGN="center" VALIGN="top">
              <!-- First tab: Overview -->
              <xsl:choose>
                <xsl:when test=".=/application">
                  <TD CLASS="NavBarCell1Rev"><span class="NavBarFont1Rev">Overview</span></TD>
                </xsl:when>
                <xsl:otherwise>
                  <TD CLASS="NavBarCell1"><span class="NavBarFont1"><A HREF="{$topdir}overview-summary.html">Overview</A></span></TD>
                </xsl:otherwise>
              </xsl:choose>
              <!-- Second tab: Package -->
              <xsl:choose>
                <xsl:when test="name()='package'">
                  <TD CLASS="NavBarCell1Rev"><span class="NavBarFont1Rev">Package</span></TD>
                </xsl:when>
                <xsl:when test=".=/application">
                  <TD CLASS="NavBarCell1"><span class="NavBarFont1">Package</span></TD>
                </xsl:when>
                <xsl:otherwise>
                  <TD CLASS="NavBarCell1"><A HREF="package-summary.html"><span class="NavBarFont1">Package</span></A></TD>
                </xsl:otherwise>
              </xsl:choose>
              <!-- <TD CLASS="NavBarCell1Rev"><FONT CLASS="NavBarFont1Rev"><B>Class</B></FONT>&nbsp;</TD>-->
              <!-- <TD CLASS="NavBarCell1">    <A HREF="class-use/AppenderAttachableImpl.html"><FONT CLASS="NavBarFont1"><B>Use</B></FONT></A>&nbsp;</TD>-->
              <!-- <TD CLASS="NavBarCell1">    <A HREF="package-tree.html"><FONT CLASS="NavBarFont1"><B>Tree</B></FONT></A>&nbsp;</TD>-->
              <!-- <TD CLASS="NavBarCell1">    <A HREF="../../../../deprecated-list.html"><FONT CLASS="NavBarFont1"><B>Deprecated</B></FONT></A>&nbsp;</TD>-->
              <!-- <TD CLASS="NavBarCell1">    <A HREF="../../../../index-all.html"><FONT CLASS="NavBarFont1"><B>Index</B></FONT></A>&nbsp;</TD>-->
              <!-- <TD CLASS="NavBarCell1">    <A HREF="../../../../help-doc.html"><FONT CLASS="NavBarFont1"><B>Help</B></FONT></A>&nbsp;</TD>-->
            </TR>               
          </TABLE>
        </TD>
        <TD ALIGN="right" VALIGN="top" ROWSPAN="3">
          <span class="NavBarFontLogo"><xsl:value-of select="/application/@name"/></span>
        </TD>
      </TR>
      <tr>
        <td class="NavBarCell2">
          <xsl:comment/>
        </td>
        <td class="NavBarCell2">
          <a href="concat($topdir, 'index.html')" target="_top">Frames</a> |    
          <a href="concat($topdir, 'overview-summary.html')" target="_top">No frames</a>
        </td>
      </tr>
      <tr>
        <xsl:apply-templates select="." mode="navbar" />
      </tr>
    </TABLE>
    <xsl:comment>=========== END OF NAVBAR ===========</xsl:comment>
  </xsl:template>
  
  <xsl:template name="changedOnAtBy">
    <xsl:param name="input" select="."/>
    
    <xsl:if test="$input/@changedon or $input/@as4time or $input/@changedby">
      <dl>
        <dt>Changed</dt>
        <dd>
          <xsl:if test="$input/@changedon">
            on <xsl:value-of select="$input/@changedon"/>
          </xsl:if>
          <xsl:if test="$input/@as4time">
            at <xsl:value-of select="$input/@as4time"/>
          </xsl:if>
          <xsl:if test="$input/@changedby">
            by <xsl:value-of select="$input/@changedby"/>
          </xsl:if>
        </dd>
      </dl>
    </xsl:if>
  </xsl:template>

  <xsl:template name="createdOnBy">
    <xsl:param name="input" select="."/>
    
    <xsl:if test="$input/@author or $input/@createdon">
      <dl>
        <dt>Created</dt>
        <dd>
          <xsl:if test="$input/@createdon">
            on <xsl:value-of select="$input/@createdon"/>
          </xsl:if>
          <xsl:if test="$input/@author">
            by <xsl:value-of select="$input/@author"/>
          </xsl:if>
        </dd>
      </dl>
    </xsl:if>
  </xsl:template>


  <xsl:template name="documentation">
    <xsl:if test="documentation/*[normalize-space()]">
      <div class="Documentation">
        <!-- Take all subnodes which contain a text with something else than whitespaces -->
        <xsl:for-each select="documentation/*[normalize-space()]">
          <dl>
            <dt class="DocumentationNode">
              <!-- Print out name of node, capitalised -->
              <xsl:value-of select="translate(substring(name(),1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
              <xsl:value-of select="substring(name(),2)"/>
            </dt>
            <dd><xsl:value-of select="text()"/></dd>
          </dl>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
      
</xsl:stylesheet>
