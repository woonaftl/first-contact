<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

  <xsl:key name="eventList" match="eventList[*][ancestor::event or ancestor::eventList] | destroyedList[*] | deadCrewList[*] |
                                   gotawayList[*] | surrenderList[*] | escapeList[*]" use="."/>
  <xsl:key name="ship" match="ship[*]" use="."/>
  <xsl:key name="textList" match="textList[*][ancestor::event or ancestor::eventList]" use="."/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="eventList[*][ancestor::event or ancestor::eventList] | destroyedList[*] | deadCrewList[*] |
                       gotawayList[*] | surrenderList[*] | escapeList[*]">
    <xsl:element name="{substring-before(name(), 'List')}">
      <xsl:attribute name="load">
        <xsl:value-of select="generate-id(key('eventList', .))"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*[not(name() = 'load')][not(name() = 'name')]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ship[*]">
    <xsl:element name="{name()}">
      <xsl:attribute name="load">
        <xsl:value-of select="generate-id(key('ship', .))"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*[name() != 'name'][name() != 'auto_blueprint']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="textList[*][ancestor::event or ancestor::eventList]">
    <text>
      <xsl:attribute name="load">
        <xsl:value-of select="generate-id(key('textList', .))"/>
      </xsl:attribute>
    </text>
  </xsl:template>

  <xsl:template match="FTL">
    <xsl:copy>

      <xsl:apply-templates select="@* | node()"/>

      <xsl:for-each select="//eventList[ancestor::event or ancestor::eventList] | //destroyedList | //deadCrewList |
                                      //gotawayList | //surrenderList | //escapeList">
        <xsl:if test="generate-id(.) = generate-id(key('eventList', .))">
          <eventList>
            <xsl:attribute name="name">
              <xsl:value-of select="generate-id(key('eventList', .))"/>
            </xsl:attribute>
            <xsl:apply-templates select="@unique | node()"/>
          </eventList>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="//ship[*]">
        <xsl:if test="generate-id(.) = generate-id(key('ship', .))">
          <ship>
            <xsl:attribute name="auto_blueprint">
              <xsl:value-of select="generate-id(key('ship', auto_blueprint))"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="generate-id(key('ship', .))"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[name() != 'name'][name() != 'hostile'] | node()[name() != 'auto_blueprint']"/>
          </ship>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="//textList[*][ancestor::event or ancestor::eventList]">
        <xsl:if test="generate-id(.) = generate-id(key('textList', .))">
          <textList>
            <xsl:attribute name="name">
              <xsl:value-of select="generate-id(key('textList', .))"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[name() != 'name'] | node()"/>
          </textList>
        </xsl:if>
      </xsl:for-each>

    </xsl:copy>
  </xsl:template>
</xsl:transform>