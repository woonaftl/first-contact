<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="event[@count]">
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
        </xsl:copy>
      </xsl:with-param>
      <xsl:with-param name="count" select="$count"/>
    </xsl:call-template>
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