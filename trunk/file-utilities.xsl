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

<xsl:template name="filename">
  <xsl:param name="samepackage" select="false()" />
  <xsl:param name="input" select="." />
  <xsl:param name="relative" select="false()" />

  <xsl:variable name="relpath">
    <xsl:if test="$relative">
     <xsl:call-template name="topdir" />
    </xsl:if>
  </xsl:variable>
      
  <xsl:variable name="directory">
    <xsl:choose>
      <xsl:when test="$samepackage">
        <xsl:apply-templates select="$input/self::package" mode="directory"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$input/ancestor-or-self::package" mode="directory"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:apply-templates select="$input" mode="filename"/>
  </xsl:variable>

  <xsl:value-of select="concat($relpath, $directory, $filename)"/>
</xsl:template>

<xsl:template mode="filename" match="package" priority="2">
  <xsl:text>package-summary.html</xsl:text>
</xsl:template>

<xsl:template mode="filename" match="application" priority="2">
  <xsl:text>overview-summary.html</xsl:text>
</xsl:template>

<xsl:template mode="filename" match="package/*">
  <xsl:variable name="file">
    <xsl:call-template name="replace-slash">
      <xsl:with-param name="original" select="@name" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat($file, '.html')" />
</xsl:template>



<xsl:template mode="directory" match="package">
  <xsl:variable name="dir">
    <xsl:call-template name="replace-slash">
      <xsl:with-param name="original" select="@name" />
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:value-of select="concat($dir, '/')" />
</xsl:template>

<xsl:template name="topdir">
  <xsl:apply-templates select="ancestor-or-self::package" mode="parentdir" />
</xsl:template>

<xsl:template name="parentdir" mode="parentdir" match="package">
<!--  <xsl:variable name="dircat">
    <xsl:for-each select="ancestor-or-self::package">
      <xsl:value-of select="concat('../', $dircat)" />
    </xsl:for-each>
  </xsl:variable>-->
  <xsl:text>../</xsl:text>
</xsl:template>


<xsl:template name="write-href">
  <xsl:param name="input" select="current()/@type"/>
  <xsl:param name="types-only" select="true()" />

  <xsl:choose>
    <xsl:when test="contains($input, '-')">
      <xsl:variable name="node" select="//package/table[@name = substring-before($input, '-')]|structure[@name = substring-before($input, '-')]" />
      <xsl:choose>
    	<xsl:when test="$node">
      	  <xsl:variable name="filename">
            <xsl:call-template name="filename">
              <xsl:with-param name="input" select="$node" />
              <xsl:with-param name="relative" select="true()" />
            </xsl:call-template>     
          </xsl:variable>
          <a href="{$filename}#{substring-after($input,'-')}"><xsl:value-of select="$input"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$input"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>    
    <xsl:when test="contains($input, '~')">
      <xsl:variable name="suffix" select="substring-after($input,'~')"/>
      <xsl:variable name="node" select="//package/class[@name = substring-before($input, '~')]|//package/interface[@name = substring-before($input, '~')]" />
      <xsl:choose>
      <xsl:when test="$node">
          <xsl:variable name="filename">
            <xsl:call-template name="filename">
              <xsl:with-param name="input" select="$node" />
              <xsl:with-param name="relative" select="true()" />
            </xsl:call-template>     
          </xsl:variable>
          <a href="{$filename}#{$suffix}"><xsl:value-of select="$suffix"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$suffix"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>    
    <xsl:when test="contains($input, '=>')">
      <xsl:variable name="suffix" select="substring-after($input,'=>')"/>
      <xsl:variable name="node" select="//package/class[@name = substring-before($input, '=>')]|//package/interface[@name = substring-before($input, '=>')]" />
      <xsl:choose>
      <xsl:when test="$node">
          <xsl:variable name="filename">
            <xsl:call-template name="filename">
              <xsl:with-param name="input" select="$node" />
              <xsl:with-param name="relative" select="true()" />
            </xsl:call-template>     
          </xsl:variable>
          <a href="{$filename}#{$suffix}"><xsl:value-of select="$suffix"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$suffix"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>    
    <xsl:when test="starts-with($input, 'http://')">
      <a href="{$input} target='_top'"><xsl:value-of select="$input"/></a>
    </xsl:when>    
    <xsl:when test="starts-with($input, 'REF TO ')">
      <xsl:variable name="node" select="//package/class[@name = substring-after($input, 'REF TO ')]|//package/interface[@name = substring-after($input, 'REF TO ')]" />
      <xsl:choose>
    	<xsl:when test="$node">
      	  <xsl:variable name="filename">
            <xsl:call-template name="filename">
              <xsl:with-param name="input" select="$node" />
              <xsl:with-param name="relative" select="true()" />
            </xsl:call-template>     
          </xsl:variable>
          REF TO <a href="{$filename}"><xsl:value-of select="substring-after($input, 'REF TO ')"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$input"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>    
    <xsl:when test="$types-only">
      <xsl:variable name="node" select="//package/dataelem[@name = $input]" />
      <xsl:choose>
    	<xsl:when test="$node">
      	  <xsl:variable name="filename">
            <xsl:call-template name="filename">
              <xsl:with-param name="input" select="$node" />
              <xsl:with-param name="relative" select="true()" />
            </xsl:call-template>     
          </xsl:variable>
          <a href="{$filename}"><xsl:value-of select="$input"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$input"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="node" select="//package/*[@name = $input]" />
      <xsl:choose>
    	<xsl:when test="$node">
      	  <xsl:variable name="filename">
            <xsl:call-template name="filename">
              <xsl:with-param name="input" select="$node" />
              <xsl:with-param name="relative" select="true()" />
            </xsl:call-template>     
          </xsl:variable>
          <a href="{$filename}"><xsl:value-of select="$input"/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$input"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>


