<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="repeat">
    <xsl:call-template name="copies">
      <xsl:with-param name="node">
        <xsl:apply-templates select="node()"/>
      </xsl:with-param>
      <xsl:with-param name="count" select="@count"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="rarityListExcept">
    <xsl:variable name="current" select="."/>
    <rarityList>
      <xsl:apply-templates select="node()"/>
      <xsl:if test="@crew = 0">
        <xsl:for-each select="document('../result/data/blueprints.xml')/FTL/crewBlueprint[rarity &gt; 0][not(@name = $current/blueprint/@name)]">
          <blueprint name="{@name}" rarity="0"/>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="@drones = 0">
        <xsl:for-each select="document('../result/data/blueprints.xml')/FTL/droneBlueprint[rarity &gt; 0][not(@name = $current/blueprint/@name)]">
          <blueprint name="{@name}" rarity="0"/>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="@weapons = 0">
        <xsl:for-each select="document('../result/data/blueprints.xml')/FTL/weaponBlueprint[rarity &gt; 0][not(@name = $current/blueprint/@name)]">
          <blueprint name="{@name}" rarity="0"/>
        </xsl:for-each>
      </xsl:if>
    </rarityList>
  </xsl:template>

  <xsl:template name="copies">
    <xsl:param name="node"/>
    <xsl:param name="count"/>
    <xsl:if test="number($count) &gt; 0">
      <xsl:copy-of select="$node"/>
      <xsl:call-template name="copies">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="count" select="number($count) - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:transform>