<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>
<!-- fix bug where the game crashes if player's reactor is limited and player has above 30 power, for example when activating lvl3 battery -->

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

  <xsl:template match="@* | node()" mode="add">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="add"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[not(choice)][(environment/@type = 'storm') or (status[@target = 'player'][@system = 'reactor'])]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <xsl:call-template name="new"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[choice][(environment/@type = 'storm') or (status[@target = 'player'][@system = 'reactor'])]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="found"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="choice[not(@req)][not(@max_group)]" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="blue">false</xsl:attribute>
      <xsl:attribute name="req">reactor</xsl:attribute>
      <xsl:attribute name="lvl">0</xsl:attribute>
      <xsl:attribute name="max_group">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates mode="done"/>
    </xsl:copy>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="blue">false</xsl:attribute>
      <xsl:attribute name="req">reactor</xsl:attribute>
      <xsl:attribute name="max_lvl">12</xsl:attribute>
      <xsl:attribute name="max_group">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates mode="done"/>
    </xsl:copy>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="blue">false</xsl:attribute>
      <xsl:attribute name="req">reactor</xsl:attribute>
      <xsl:attribute name="max_lvl">25</xsl:attribute>
      <xsl:attribute name="max_group">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates mode="add"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event" mode="add">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <status amount="2" system="battery" target="player" type="limit"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[not(choice)]" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <xsl:call-template name="new"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="new">
    <choice hidden="true" req="reactor" lvl="0" blue="false" max_group="0">
      <text id="continue"/>
      <event/>
    </choice>
    <choice hidden="true" req="reactor" max_lvl="12" blue="false" max_group="0">
      <text id="continue"/>
      <event/>
    </choice>
    <choice hidden="true" req="reactor" max_lvl="25" blue="false" max_group="0">
      <text id="continue"/>
      <event>
        <status amount="2" system="battery" target="player" type="limit"/>
      </event>
    </choice>
  </xsl:template>
</xsl:transform>