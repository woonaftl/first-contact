<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>
<!-- fix bug where enemy reactor is not limited by ion storm -->

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="found"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ship" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="done">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[not(choice)][ship/@hostile = 'true'][ancestor-or-self::event/environment/@type = 'storm']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <xsl:call-template name="new"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[choice][ship/@hostile = 'true'][ancestor-or-self::event/environment/@type = 'storm']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="found"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <status type="divide" target="enemy" system="reactor" amount="2"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="new">
    <choice hidden="true">
      <text id="continue"/>
      <event>
        <status type="divide" target="enemy" system="reactor" amount="2"/>
      </event>
    </choice>
  </xsl:template>
</xsl:transform>