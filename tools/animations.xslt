<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>
  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL">
    <xsl:copy>
      <xsl:apply-templates select="animSheet"/>
      <xsl:apply-templates select="anim"/>
      <xsl:apply-templates select="node()[not(name() = 'anim')][not(name() = 'animSheet')]"/>
    </xsl:copy>
  </xsl:template>
</xsl:transform>