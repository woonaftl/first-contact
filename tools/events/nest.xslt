<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

  <xsl:key name="event" match="FTL/event[@name] | FTL/eventList[@name]" use="@name"/>
  <xsl:key name="ship" match="FTL/ship[@name]" use="@name"/>

  <xsl:template match="FTL/event[not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name)]
                                [not(@name = /FTL/eventList[@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name]/event/@load)]
                                [not(@name = //quest/@event)]"/>
  <xsl:template match="FTL/eventList[not(@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name)]
                                    [not(@name = //quest/@event)]"/>
  <xsl:template match="FTL/ship"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[@load][not(parent::eventList[@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/event/@name])] |
                       destroyed[@load] | deadCrew[@load] | gotaway[@load] | surrender[@load] | escape[@load]">
    <xsl:variable name="name">
      <xsl:value-of select="name()"/>
      <xsl:if test="name(key('event', @load)) = 'eventList'">
        <xsl:text>List</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:element name="{$name}">
      <xsl:apply-templates select="key('event', @load)/@*[name() != 'name'][name() != 'unique']"/>
      <xsl:apply-templates select="@*[name() != 'load']"/>
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