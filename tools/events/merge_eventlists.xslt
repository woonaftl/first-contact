<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL/eventList">
    <xsl:copy>
      <xsl:attribute name="name">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
      <xsl:apply-templates select="../eventList[(@name = current()/@name)]/*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL/eventList[@name = preceding-sibling::eventList/@name]"/>
</xsl:transform>