<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

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

  <xsl:template match="event[ship/@hostile = 'true'][not(choice)][not(status[@target = 'enemy'][@system = 'engines'])]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()[not(name() = 'ship')]" mode="done"/>
      <xsl:call-template name="new"/>
      <xsl:apply-templates select="ship" mode="done"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[ship][choice][descendant::ship/@hostile = 'true']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()[not(name() = 'ship')]" mode="found"/>
      <xsl:apply-templates select="ship" mode="done"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="choice[not(@req)][not(@max_group)][not(event/status[@target = 'enemy'][@system = 'engines'])]
                             [descendant::ship/@hostile = 'true']" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="blue">false</xsl:attribute>
      <xsl:attribute name="hidden">true</xsl:attribute>
      <xsl:attribute name="req">ENGINE_DISABLER</xsl:attribute>
      <xsl:attribute name="lvl">0</xsl:attribute>
      <xsl:attribute name="max_group">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates select="node()" mode="done"/>
    </xsl:copy>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="blue">false</xsl:attribute>
      <xsl:attribute name="hidden">true</xsl:attribute>
      <xsl:attribute name="req">ENGINE_DISABLER</xsl:attribute>
      <xsl:attribute name="max_group">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates select="node()" mode="add"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[descendant::ship/@hostile = 'true']" mode="add">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <status type="limit" target="enemy" system="engines" amount="1"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[not(choice)][not(status[@target = 'enemy'][@system = 'engines'])]
                            [descendant::ship/@hostile = 'true']" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <xsl:call-template name="new"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="new">
    <choice blue="false" hidden="true" req="ENGINE_DISABLER" lvl="0" max_group="0">
      <text id="continue"/>
      <event/>
    </choice>
    <choice blue="false" hidden="true" req="ENGINE_DISABLER" max_group="0">
      <text id="continue"/>
      <event>
        <status type="limit" target="enemy" system="engines" amount="1"/>
      </event>
    </choice>
  </xsl:template>
</xsl:transform>