<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL/eventList">
    <xsl:variable name="name" select="@name"/>
    <xsl:copy>
      <xsl:attribute name="name">
        <xsl:value-of select="$name"/>
      </xsl:attribute>
      <xsl:apply-templates select="../eventList[(@name = $name)]/*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL/eventList[@name = preceding-sibling::eventList/@name]"/>

  <xsl:template match="FTL">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:for-each select="descendant::eventList[*][ancestor::event | ancestor::eventList | ancestor::choice |
                                                     ancestor::surrender | ancestor::escape | ancestor::deadCrew |
                                                     ancestor::destroyed] |
                            descendant::textList[*][ancestor::event | ancestor::eventList | ancestor::choice |
                                                    ancestor::surrender | ancestor::escape | ancestor::deadCrew |
                                                    ancestor::destroyed] |
                            descendant::ship[*][ancestor::event | ancestor::eventList | ancestor::choice |
                                                ancestor::surrender | ancestor::escape | ancestor::deadCrew |
                                                ancestor::destroyed]">
        <xsl:copy>
          <xsl:if test="not(@name)">
            <xsl:attribute name="name">
              <xsl:value-of select="generate-id(.)"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="@*[name() !='hostile'] | node()"/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="eventList[ancestor::event | ancestor::eventList | ancestor::choice | ancestor::surrender |
                                 ancestor::escape | ancestor::deadCrew | ancestor::destroyed]">
    <event>
      <xsl:attribute name="load">
        <xsl:choose>
          <xsl:when test="@load">
            <xsl:value-of select="@load"/>
          </xsl:when>
          <xsl:when test="@name">
            <xsl:value-of select="@name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="generate-id(.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </event>
  </xsl:template>

  <xsl:template match="textList[ancestor::event | ancestor::eventList | ancestor::choice | ancestor::surrender |
                                ancestor::escape | ancestor::deadCrew | ancestor::destroyed]">
    <text>
      <xsl:attribute name="load">
        <xsl:choose>
          <xsl:when test="@load">
            <xsl:value-of select="@load"/>
          </xsl:when>
          <xsl:when test="@name">
            <xsl:value-of select="@name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="generate-id(.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </text>
  </xsl:template>

  <xsl:template match="ship[ancestor::event | ancestor::eventList | ancestor::choice]">
    <xsl:copy>
      <xsl:if test="@load or @name or @auto_blueprint">
        <xsl:attribute name="load">
          <xsl:choose>
            <xsl:when test="@load">
              <xsl:value-of select="@load"/>
            </xsl:when>
            <xsl:when test="@name">
              <xsl:value-of select="@name"/>
            </xsl:when>
            <xsl:when test="@auto_blueprint">
              <xsl:value-of select="generate-id(.)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@hostile"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event">
    <xsl:variable name="count">
      <xsl:choose>
        <xsl:when test="@count">
          <xsl:value-of select="@count"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="copies">
      <xsl:with-param name="node">
        <xsl:copy>
          <xsl:apply-templates select="@*[name()!='count'] | node()"/>
          <xsl:choose>
            <xsl:when test="(ship/@hostile = 'false') and (not((status/@target='enemy') and (status/@system='teleporter')))">
              <status type="limit" target="enemy" system="teleporter" amount="0"/>
            </xsl:when>
            <xsl:when test="(ship/@hostile = 'true') and (not((status/@target='enemy') and (status/@system='teleporter')))">
              <status type="clear" target="enemy" system="teleporter" amount="100"/>
            </xsl:when>
          </xsl:choose>
        </xsl:copy>
      </xsl:with-param>
      <xsl:with-param name="count" select="$count"/>
    </xsl:call-template>
  </xsl:template>

  <!--TODO if there's no surrender, use it to limit teleporter-->

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
