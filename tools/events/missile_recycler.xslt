<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

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

  <xsl:template match="destroyed[not(choice)] | deadCrew[not(choice)] |
                       destroyedList/event[not(choice)] | deadCrewList/event[not(choice)]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:call-template name="new"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="destroyed[choice] | deadCrew[choice] |
                       destroyedList/event[choice] | deadCrewList/event[choice]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="found"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="choice[not(@req)][not(@max_group)][not(event/autoReward)][not(event/item_modify)]" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="blue">false</xsl:attribute>
      <xsl:attribute name="hidden">true</xsl:attribute>
      <xsl:attribute name="req">MISSILE_RECYCLER</xsl:attribute>
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
      <xsl:attribute name="req">MISSILE_RECYCLER</xsl:attribute>
      <xsl:attribute name="max_group">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:apply-templates select="node()" mode="add"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[descendant::ship/@hostile = 'true']" mode="add">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <item_modify>
        <item type="missiles" min="2" max="2"/>
      </item_modify>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[not(choice)]" mode="found">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="done"/>
      <xsl:call-template name="new"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="new">
    <choice blue="false" hidden="false" req="MISSILE_RECYCLER" lvl="0" max_group="0">
      <text id="continue"/>
      <event/>
    </choice>
    <choice blue="false" hidden="false" req="MISSILE_RECYCLER" max_group="0">
      <text id="continue"/>
      <event>
        <item_modify>
          <item type="missiles" min="2" max="2"/>
        </item_modify>
      </event>
    </choice>
  </xsl:template>
</xsl:transform>