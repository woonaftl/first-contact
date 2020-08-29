<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="FTL">
    <xsl:copy>
      <xsl:apply-templates select="text[not(@id)]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text[not(@id)]">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:transform>