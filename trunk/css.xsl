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


<xsl:template name="css">
<redirect:write select="concat($workdir, 'format.css')">
<xsl:text>
/* Javadoc style sheet */

/* Define colors, fonts and other style attributes here to override the defaults  */

/* Page background color
body { 	font-family: Arial;
	background-color: white;
	font-size: 10pt;
 }
td { 	font-family: Arial;
	font-size: 10pt;
 }*/
body.Frame { font-size: 80%; }

/* Table colors */
.TableHeadingColor     { background: #CCCCFF; font-size: 150%; font-weight: bold }
.TableSubHeadingColor  { background: #EEEEFF; font-size: 100%; font-weight: bold; }
.TableRowColor         { background: #FFFFFF }

/* Font used in left-hand frame lists */
.FrameTitleFont   { font-size: 120%; font-family: Arial; font-weight: bold }
.FrameHeadingFont { font-size: 120%; font-family: Arial }
.FrameItemFont    { font-size: normal; font-family: Arial }

/* Example of smaller, sans-serif font in frames */
/* .FrameItemFont  { font-size: 10pt; font-family: Helvetica, Arial, sans-serif } */

/* Navigation bar fonts and colors */
.NavBarCell1    { background-color:#EEEEFF;}
.NavBarCell1Rev { background-color:#00008B;}

.NavBarFont1    { font-family: Arial, Helvetica, sans-serif; color:#000000; font-weight: bold; }
.NavBarFont1Rev { font-family: Arial, Helvetica, sans-serif; color:#FFFFFF; font-weight: bold; }
.NavBarFontLogo { font-family: Arial, Helvetica, sans-serif; color:#000000; font-weight: bold; font-style: italic; }

.NavBarCell2    { font-family: Arial, Helvetica, sans-serif; background-color:#FFFFFF; font-weight: bold; font-size: 60%; }
.NavBarCell3    { font-family: Arial, Helvetica, sans-serif; background-color:#FFFFFF; font-size: 60%; }

A {
    color: #003399;
}

A:active {
    color: #003399;
}

A:visited {
    color: #888888;
}

P, OL, UL, LI, DL, DT, DD, BLOCKQUOTE {
    color: #000000;
}

TD, TH, SPAN {
    color: #000000;
}

BLOCKQUOTE {
    margin-right: 0px;
}


/*H1, H2, H3, H4, H5, H6    {
    color: #000000;
    font-weight:500;
    margin-top:10px;
    padding-top:15px;
}

H1 { font-size: 150%; }
H2 { font-size: 140%; }
H3 { font-size: 110%; font-weight: bold; }
H4 { font-size: 110%; font-weight: bold;}
H5 { font-size: 100%; font-style: italic; }
H6 { font-size: 100%; font-style: italic; }*/

TT {
font-size: 90%;
    font-family: "Courier New", Courier, monospace;
    color: #000000;
}

/*
PRE {
font-size: 90%;
    padding: 5px;
    border-style: solid;
    border-width: 1px;
    border-color: #CCCCCC;
    background-color: #F4F4F4;
}
*/

.ClassHierarchyThisClass {
  font-weight: bold; 
}

UL, OL, LI {
    list-style: disc;
}

HR  {
    width: 100%;
    height: 1px;
    background-color: #CCCCCC;
    border-width: 0px;
    padding: 0px;
    color: #CCCCCC;
}

.variablelist { 
    padding-top: 10; 
    padding-bottom:10; 
    margin:0;
}

.itemizedlist, UL { 
    padding-top: 0; 
    padding-bottom:0; 
    margin:0; 
}

.term { 
    font-weight:bold;
}

DT { font-weight: bold; }
DT.DocumentationNode { font-weight: normal; }

.Documentation {
    font-size: 90%;
    padding: 5px;
    border-style: solid;
    border-width: 1px;
    border-color: #CCCCCC;
    background-color: #F4F4F4;
} 

</xsl:text>
</redirect:write>
</xsl:template>
</xsl:stylesheet>