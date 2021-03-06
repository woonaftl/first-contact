<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>
  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*">
        <xsl:sort select="name()"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="node()[not(name() = 'choice')]">
        <xsl:sort select="name()"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="choice"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="comment()"/>
</xsl:transform>