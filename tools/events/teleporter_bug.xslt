<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <!--TODO maybe if there's no surrender, use it to limit teleporter-->

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[ship/@hostile = 'false'][not((status/@target='enemy') and (status/@system='teleporter'))]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <status type="limit" target="enemy" system="teleporter" amount="0"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[ship/@hostile = 'true'][not((status/@target='enemy') and (status/@system='teleporter'))]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <status type="clear" target="enemy" system="teleporter" amount="100"/>
    </xsl:copy>
  </xsl:template>
</xsl:transform>