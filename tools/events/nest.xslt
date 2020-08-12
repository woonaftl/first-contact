<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

  <xsl:key name="event" match="FTL/event[@name] | FTL/eventList[@name]" use="@name"/>
  <xsl:key name="ship" match="FTL/ship[@name]" use="@name"/>

  <!--TODO wtf is this predicate hell -->
  <xsl:template match="FTL/event[not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name)]
                                [not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/startEvent)]
                                [not(@name = /FTL/eventList[@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name]/event/@load)]
                                [not(@name = //quest/@event)]
                                [not(@name = 'START_GAME')][not(@name = 'START_BEACON')]
                                [not(@name = 'BOARDERS')][not(@name = 'STALEMATE_SURRENDER')]
                                [not(@name = 'BOSS_STALEMATE')][not(@name = 'CREW_STUCK')]
                                [not(@name = 'FUEL_ESCAPE_SUN')][not(@name = 'FUEL_ESCAPE_STORM')]
                                [not(@name = 'FUEL_ESCAPE_ASTEROIDS')][not(@name = 'FUEL_ESCAPE_PULSAR')]
                                [not(@name = 'FUEL_ESCAPE_PDS')][not(@name = 'FUEL_ESCAPE_FLEET')]
                                [not(@name = 'AUGMENT_FULL')][not(@name = 'GAMEOVER')]
                                [not(@name = 'DUMMY')][not(@name = 'TOO_MANY_CREW')]
                                [not(@name = 'FINISH_BEACON')][not(@name = 'FINISH_BEACON_NEBULA')]
                                [not(@name = 'FLEET_EASY_NEBULA')][not(@name = 'FLEET_EASY')]
                                [not(@name = 'FLEET_EASY_DLC')][not(@name = 'FLEET_EASY_BEACON')]
                                [not(@name = 'FLEET_EASY_BEACON_DLC')][not(@name = 'FLEET_HARD')]
                                [not(@name = 'NO_FUEL_FLEET')][not(@name = 'NO_FUEL_FLEET_DLC')]
                                [not(@name = 'FEDERATION_BASE')][not(@name = 'BOSS_AUTOMATED')]
                                [not(@name = 'BOSS_DESTROYED')][not(@name = 'BOSS_ESCAPED')]
                                [not(@name = 'BOSS_TEXT_1')][not(@name = 'BOSS_TEXT_2')]
                                [not(@name = 'BOSS_TEXT_3')][not(@name = 'LAST_STAND_START')]
                                [not(@name = 'CHARACTER_TEST')]"/>
  <xsl:template match="FTL/eventList[not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name)]
                                    [not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/startEvent)]
                                    [not(@name = //quest/@event)]
                                    [not(@name = 'NON_HOSTILE')][not(@name = 'EXIT_LIST')]
                                    [not(@name = 'NEUTRAL_EXIT')][not(@name = 'NEUTRAL')]"/>
  <xsl:template match="FTL/ship"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[@load][not(parent::eventList[@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name])]
                                   [not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/startEvent)]
                                   [not(@name = 'NON_HOSTILE')][not(@name = 'EXIT_LIST')]
                                   [not(@name = 'NEUTRAL_EXIT')][not(@name = 'NEUTRAL')] |
                                   destroyed[@load] | deadCrew[@load] | gotaway[@load] | surrender[@load] | escape[@load]">
    <xsl:variable name="name">
      <xsl:value-of select="name()"/>
      <xsl:if test="name(key('event', @load)) = 'eventList'">
        <xsl:text>List</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="key('event', @load)/@*[name() != 'name'][name() != 'unique']"/>
      <xsl:apply-templates select="@*[name() != 'load'][name() != 'name']"/>
      <xsl:apply-templates select="key('event', @load)/node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ship[@load]">
    <xsl:copy>
      <xsl:apply-templates select="key('ship', @load)/@*[name() != 'name']"/>
      <xsl:apply-templates select="@*[name() != 'load']"/>
      <xsl:apply-templates select="key('ship', @load)/node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:transform>