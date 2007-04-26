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

<xsl:template name="replace-slash">
  <xsl:param name="original"/>

  <xsl:call-template name="replace-substring">
        <xsl:with-param name="original" select="$original" />
        <xsl:with-param name="substring" select="'/'"/>
        <xsl:with-param name="replacement" select="'_'"/>
  </xsl:call-template>

</xsl:template>

<xsl:template name="replace-substring">
  <xsl:param name="original"/>
  <xsl:param name="substring"/>
  <xsl:param name="replacement" select="''"/>
  <xsl:variable name="first">
    <xsl:choose>
      <xsl:when test="contains($original, $substring)">
        <xsl:value-of select="substring-before($original, $substring)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$original"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="middle">
    <xsl:choose>
      <xsl:when test="contains($original, $substring)">
        <xsl:value-of select="$replacement"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="last">
    <xsl:choose>
      <xsl:when test="contains($original, $substring)">
        <xsl:choose>
          <xsl:when test="contains(substring-after($original, $substring),
                                   $substring)">
            <xsl:call-template name="replace-substring">
              <xsl:with-param name="original">
                <xsl:value-of select="substring-after($original, $substring)"/>
              </xsl:with-param>
              <xsl:with-param name="substring">
                <xsl:value-of select="$substring"/>
              </xsl:with-param>
              <xsl:with-param name="replacement">
                <xsl:value-of select="$replacement"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-after($original, $substring)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="concat($first, $middle, $last)"/>
</xsl:template>


</xsl:stylesheet>
