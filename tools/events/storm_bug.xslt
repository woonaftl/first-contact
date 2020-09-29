<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[ship/@hostile = 'true'][ancestor-or-self::event/environment/@type = 'storm']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <status type="divide" target="enemy" system="reactor" amount="2"/>
    </xsl:copy>
  </xsl:template>
</xsl:transform>