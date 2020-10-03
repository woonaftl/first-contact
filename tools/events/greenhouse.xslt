<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL/event[@name = document('../../result/data/sector_data.xml')/FTL/sectorDescription/startEvent][@name != 'START_GAME']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <choice blue="false" hidden="false" req="GREENHOUSE_LIST" lvl="0" max_group="0">
        <text id="continue"/>
        <event/>
      </choice>
      <choice blue="false" hidden="false" req="GREENHOUSE_LIST" max_group="0">
        <text id="continue"/>
        <event>
          <crewMember amount="1" class="orchid"/>
        </event>
      </choice>
    </xsl:copy>
  </xsl:template>
</xsl:transform>