<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[not(text)][not(textList)][choice] |
                       deacCrew[not(text)][not(textList)][choice] |
                       destroyed[not(text)][not(textList)][choice] |
                       escape[not(text)][not(textList)][choice] |
                       gotAway[not(text)][not(textList)][choice] |
                       surrender[not(text)][not(textList)][choice]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <text>dummy</text>
    </xsl:copy>
  </xsl:template>
</xsl:transform>