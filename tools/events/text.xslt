<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:key name="text" match="crewMember[not(@id)][string-length(text()) &gt; 0] | text[not(@id)][not(@load)]" use="."/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="crewMember[not(@id)][string-length(text()) &gt; 0]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id(key('text', .)[1])"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text[not(@id)][not(@load)]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id(key('text', .)[1])"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>

      <xsl:for-each select="//crewMember[not(@id)][string-length(text()) &gt; 0] | //text[not(@id)][not(@load)]">
        <xsl:if test="count(. | key('text', .)[1]) = 1">
          <text>
            <xsl:attribute name="name">
              <xsl:value-of select="generate-id(key('text', .)[1])"/>
            </xsl:attribute>
            <xsl:apply-templates select="key('text', .)[1]/node()"/>
          </text>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
</xsl:transform>