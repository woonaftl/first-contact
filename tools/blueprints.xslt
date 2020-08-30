<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL">
    <xsl:copy>
      <xsl:for-each select="shipBlueprint[(contains(@name, 'PLAYER_SHIP')) and (not(contains(@name, 'HARD'))) and
                                          (not(contains(@name, 'CIRCLE'))) and (not(contains(@name, 'FED'))) and
                                          (not(contains(@name, 'ENERGY'))) and (not(contains(@name, 'MANTIS'))) and
                                          (not(contains(@name, 'JELLY'))) and (not(contains(@name, 'ROCK'))) and
                                          (not(contains(@name, 'STEALTH'))) and (not(contains(@name, 'CRYSTAL'))) and
                                          (not(contains(@name, 'ANAEROBIC')))]">
        <shipBlueprint name="PLAYER_SHIP_HARD">
          <xsl:apply-templates select="@*[not(name() = 'name')]"/>
          <xsl:comment>This shipBlueprint exists just for Superluminal to be able to load it</xsl:comment>
          <xsl:apply-templates select="node()[not(name() = 'crewCount')]"/>
          <crewCount amount="3" class="human"/>
        </shipBlueprint>
      </xsl:for-each>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="blueprintList">
    <xsl:variable name="name" select="@name"/>
    <xsl:copy>
      <xsl:attribute name="name">
        <xsl:value-of select="$name"/>
      </xsl:attribute>
      <xsl:apply-templates select="../blueprintList[(@name = $name)]/*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="blueprintList[@name = preceding-sibling::blueprintList/@name]"/>

  <xsl:template match="blueprintList/name">
    <xsl:variable name="name" select="."/>
    <xsl:choose>
      <xsl:when test="../../shipBlueprintSuper[@name = $name]">
        <xsl:for-each select="../../shipBlueprintSuper[@name = $name]/weaponList">
          <name>
            <xsl:value-of select="concat($name, '_', @sector)"/>
          </name>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="../../shipBlueprintSuper[concat(@name, '_ELITE') = $name]">
        <xsl:for-each select="../../shipBlueprintSuper[concat(@name, '_ELITE') = $name]/weaponList">
          <name>
            <xsl:value-of select="concat($name, '_', @sector)"/>
          </name>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="../../shipBlueprintSuper[concat(@name, '_PIRATE') = $name]">
        <xsl:for-each select="../../shipBlueprintSuper[concat(@name, '_PIRATE') = $name]/weaponList">
          <name>
            <xsl:value-of select="concat($name, '_', @sector)"/>
          </name>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="weaponBlueprintInherit">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="base" select="@base"/>
    <weaponBlueprint name="{$name}">
      <xsl:for-each select="../weaponBlueprint[@name = $base]/node()">
        <xsl:variable name="element" select="name()"/>
        <xsl:choose>
          <xsl:when test="../../weaponBlueprintInherit[@name = $name]/node()[name() = $element]">
            <xsl:apply-templates select="../../weaponBlueprintInherit[@name = $name]/node()[name() = $element]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="identity"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </weaponBlueprint>
  </xsl:template>

  <xsl:template match="droneBlueprintInherit">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="base" select="@base"/>
    <droneBlueprint name="{$name}">
      <xsl:for-each select="../droneBlueprint[@name = $base]/node()">
        <xsl:variable name="element" select="name()"/>
        <xsl:choose>
          <xsl:when test="../../droneBlueprintInherit[@name = $name]/node()[name() = $element]">
            <xsl:apply-templates select="../../droneBlueprintInherit[@name = $name]/node()[name() = $element]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="identity"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </droneBlueprint>
  </xsl:template>

  <xsl:template match="augBlueprintInherit">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="base" select="@base"/>
    <augBlueprint name="{$name}">
      <xsl:for-each select="../augBlueprint[@name = $base]/node()">
        <xsl:variable name="element" select="name()"/>
        <xsl:choose>
          <xsl:when test="../../augBlueprintInherit[@name = $name]/node()[name() = $element]">
            <xsl:apply-templates select="../../augBlueprintInherit[@name = $name]/node()[name() = $element]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="identity"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </augBlueprint>
  </xsl:template>

  <xsl:template match="shipBlueprint/systemList/clonebay[not(slot)][@slot]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <slot>
        <number>
          <xsl:value-of select="@slot"/>
        </number>
      </slot>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="shipBlueprint/systemList/doors | engines | medbay | pilot | sensors | shields| weapons[not(slot)]">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="@img">
          <xsl:value-of select="substring(@img, 6)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <slot>
        <xsl:if test="not(name() = 'medbay')">
          <direction>
            <xsl:value-of select="translate(document('../result/data/rooms.xml')/FTL/roomLayout[@name=$name]/computerGlow/@dir, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
          </direction>
        </xsl:if>
        <number>
          <xsl:value-of select="document('../result/data/rooms.xml')/FTL/roomLayout[@name=$name]/computerGlow/@slot"/>
        </number>
      </slot>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="shipBlueprintSuper">
    <xsl:variable name="maxPower">
      <xsl:value-of select="sum(@system_power | systemList/engines[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/oxygen[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/shields[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/medbay[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/clonebay[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/drones[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/teleporter[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/cloaking[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/artillery[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/hacking[(not(@start)) or (@start != 'false')]/@power |
                                                systemList/mind[(not(@start)) or (@start != 'false')]/@power)"/>
    </xsl:variable>

    <xsl:apply-templates select="weaponList"/>

    <shipBlueprint name="OLD_{@name}" layout="{@layout}" img="{@img}">
      <xsl:comment>This shipBlueprint exists just for Superluminal to be able to load it</xsl:comment>
      <class>
        <xsl:apply-templates select="class/@* | class/node()"/>
      </class>
      <xsl:if test="weaponList[1]/@sector &gt; 0">
        <minSector>
          <xsl:value-of select="weaponList[1]/@sector"/>
        </minSector>
      </xsl:if>
      <xsl:if test="weaponList[last()]/@sector &lt; 7">
        <maxSector>
          <xsl:value-of select="weaponList[last()]/@sector"/>
        </maxSector>
      </xsl:if>
      <systemList>
        <xsl:apply-templates select="systemList/*[name() != 'weapons']" mode="normal"/>
        <weapons power="2" max="8" room="{systemList/weapons/@room}"/>
      </systemList>
      <weaponList load="WEAPONS_ANY_1" missiles="{weaponList[1]/@missiles}"/>
      <xsl:apply-templates select="droneList | health"/>
      <maxPower amount="{2 + $maxPower}"/>
      <crewCount amount="{crewCount/@amount}" max="{crewCount/@max}" class="human"/>
      <xsl:apply-templates select="boardingAI | cloakImage"/>
    </shipBlueprint>
    <xsl:if test="class_elite">
      <shipBlueprint name="OLD_{@name}_ELITE" layout="{@layout}_pirate" img="{@img}_pirate">
        <class>
          <xsl:apply-templates select="class_elite/@* | class_elite/node()"/>
        </class>
        <minSector>
          <xsl:value-of select="weaponList[1]/@sector"/>
        </minSector>
        <maxSector>
          <xsl:value-of select="weaponList[last()]/@sector"/>
        </maxSector>
        <systemList>
          <xsl:apply-templates select="systemList/*[name() != 'weapons']" mode="elite"/>
          <weapons power="4" max="8" room="{systemList/weapons/@room_elite}"/>
        </systemList>
        <weaponList load="WEAPONS_ANY_1" missiles="{weaponList[1]/@missiles}"/>
        <xsl:apply-templates select="droneList | health"/>
        <maxPower amount="{6 + $maxPower}"/>
        <crewCount amount="{crewCount/@amount}" max="{crewCount/@max}" class="human"/>
        <xsl:apply-templates select="boardingAI"/>
        <xsl:choose>
          <xsl:when test="cloakImage_elite">
            <xsl:apply-templates select="cloakImage_elite"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="cloakImage"/>
          </xsl:otherwise>
        </xsl:choose>
      </shipBlueprint>
    </xsl:if>
    <xsl:if test="class_pirate">
      <shipBlueprint name="OLD_{@name}_PIRATE" layout="{@layout}_pirate" img="{@img}_pirate">
        <class>
          <xsl:apply-templates select="class_pirate/@* | class_pirate/node()"/>
        </class>
        <minSector>
          <xsl:value-of select="weaponList[1]/@sector"/>
        </minSector>
        <maxSector>
          <xsl:value-of select="weaponList[last()]/@sector"/>
        </maxSector>
        <systemList>
          <xsl:apply-templates select="systemList/*[name() != 'weapons']" mode="pirate"/>
          <weapons power="2" max="8" room="{systemList/weapons/@room_pirate}"/>
        </systemList>
        <weaponList load="WEAPONS_ANY_1" missiles="{weaponList[1]/@missiles}"/>
        <xsl:apply-templates select="droneList | health"/>
        <maxPower amount="{2 + $maxPower}"/>
        <crewCount amount="{crewCount/@amount}" max="{crewCount/@max}" class="random"/>
        <xsl:apply-templates select="boardingAI"/>
        <xsl:choose>
          <xsl:when test="cloakImage_pirate">
            <xsl:apply-templates select="cloakImage_pirate"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="cloakImage"/>
          </xsl:otherwise>
        </xsl:choose>
      </shipBlueprint>
    </xsl:if>
  </xsl:template>

  <xsl:template match="shipBlueprintSuper/weaponList">
    <xsl:variable name="maxPower">
      <xsl:value-of select="sum(@system_power | ../systemList/engines[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/oxygen[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/shields[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/medbay[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/clonebay[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/drones[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/teleporter[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/cloaking[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/artillery[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/hacking[(not(@start)) or (@start != 'false')]/@power |
                                                ../systemList/mind[(not(@start)) or (@start != 'false')]/@power)"/>
    </xsl:variable>
    <shipBlueprint name="{../@name}_{@sector}" layout="{../@layout}" img="{../@img}">
      <class>
        <xsl:apply-templates select="../class/@* | ../class/node()"/>
      </class>
      <xsl:if test="@sector &gt; 0">
        <minSector>
          <xsl:value-of select="@sector"/>
        </minSector>
      </xsl:if>
      <xsl:if test="@sector &lt; 7">
        <maxSector>
          <xsl:value-of select="@sector"/>
        </maxSector>
      </xsl:if>
      <systemList>
        <xsl:apply-templates select="../systemList/*[name() != 'weapons']" mode="normal"/>
        <weapons power="{@system_power}" room="{../systemList/weapons/@room}"/>
      </systemList>
      <weaponList>
        <xsl:apply-templates select="@missiles | node()"/>
      </weaponList>
      <xsl:apply-templates select="../droneList | ../health"/>
      <maxPower amount="{$maxPower}"/>
      <xsl:apply-templates select="../crewCount | ../boardingAI | ../aug | ../cloakImage"/>
    </shipBlueprint>

    <xsl:if test="../class_elite">
      <shipBlueprint name="{../@name}_ELITE_{@sector}" layout="{../@layout}_elite" img="{../@img}_elite">
        <class>
          <xsl:apply-templates select="../class_elite/@* | ../class_elite/node()"/>
        </class>
        <xsl:if test="@sector &gt; 0">
          <minSector>
            <xsl:value-of select="@sector"/>
          </minSector>
        </xsl:if>
        <xsl:if test="@sector &lt; 7">
          <maxSector>
            <xsl:value-of select="@sector"/>
          </maxSector>
        </xsl:if>
        <systemList>
          <xsl:apply-templates select="../systemList/*[name() != 'weapons']" mode="elite"/>
          <weapons power="{@system_power}" room="{../systemList/weapons/@room_elite}"/>
        </systemList>
        <weaponList missiles="{@missiles}">
          <xsl:for-each select="weapon">
            <weapon name="{@name}_UPGRADED"/>
          </xsl:for-each>
        </weaponList>
        <xsl:if test="../droneList">
          <droneList drones="{../droneList/@drones}" load="{../droneList/@load}_UPGRADED"/>
        </xsl:if>
        <health amount="{number(../health/@amount) + 4}"/>
        <maxPower amount="{number($maxPower) + 6}"/>
        <xsl:choose>
          <xsl:when test="../crewCount_elite">
            <crewCount>
              <xsl:apply-templates select="../crewCount_elite/@*"/>
            </crewCount>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="../crewCount"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="../boardingAI | ../aug"/>
        <xsl:choose>
          <xsl:when test="../cloakImage_elite">
            <xsl:apply-templates select="../cloakImage_elite"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="../cloakImage"/>
          </xsl:otherwise>
        </xsl:choose>
      </shipBlueprint>
    </xsl:if>

    <xsl:if test="../class_pirate">
      <shipBlueprint name="{../@name}_PIRATE_{@sector}" layout="{../@layout}_pirate" img="{../@img}_pirate">
        <class>
          <xsl:apply-templates select="../class_pirate/@* | ../class_pirate/node()"/>
        </class>
        <xsl:if test="@sector &gt; 0">
          <minSector>
            <xsl:value-of select="@sector"/>
          </minSector>
        </xsl:if>
        <xsl:if test="@sector &lt; 7">
          <maxSector>
            <xsl:value-of select="@sector"/>
          </maxSector>
        </xsl:if>
        <systemList>
          <xsl:apply-templates select="../systemList/*[(name() != 'weapons') and @room_pirate]" mode="pirate"/>
          <weapons power="{@system_power}" room="{../systemList/weapons/@room_pirate}"/>
        </systemList>
        <weaponList>
          <xsl:apply-templates select="@missiles | node()"/>
        </weaponList>
        <xsl:apply-templates select="../droneList | ../health"/>
        <maxPower amount="{$maxPower}"/>
        <crewCount amount="{../crewCount/@amount}" max="{../crewCount/@max}" class="random"/>
        <xsl:apply-templates select="../boardingAI | ../aug"/>
        <xsl:choose>
          <xsl:when test="../cloakImage_pirate">
            <xsl:apply-templates select="../cloakImage_pirate"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="../cloakImage"/>
          </xsl:otherwise>
        </xsl:choose>
      </shipBlueprint>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@* | node()" mode="normal">
    <xsl:copy>
      <xsl:apply-templates select="@power | @max | @room | @start | node()" mode="normal"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="engines | shields" mode="elite">
    <xsl:copy>
      <xsl:attribute name="power">
        <xsl:value-of select="@power + 2"/>
      </xsl:attribute>
      <xsl:apply-templates select="@max" mode="elite"/>
      <xsl:attribute name="room">
        <xsl:value-of select="@room_elite"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="elite">
    <xsl:copy>
      <xsl:apply-templates select="@power | @max" mode="elite"/>
      <xsl:attribute name="room">
        <xsl:value-of select="@room_elite"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="pirate">
    <xsl:copy>
      <xsl:apply-templates select="@power | @max" mode="pirate"/>
      <xsl:attribute name="room">
        <xsl:value-of select="@room_pirate"/>
      </xsl:attribute>
      <xsl:apply-templates select="@start | node()" mode="pirate"/>
    </xsl:copy>
  </xsl:template>

</xsl:transform>
