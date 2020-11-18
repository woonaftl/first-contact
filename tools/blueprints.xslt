<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <!--TODO remove old blueprints for superluminal -->

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
      <xsl:when test="../../shipBlueprintEnemy[@name = $name]">
        <xsl:for-each select="../../shipBlueprintEnemy[@name = $name]/sector">
          <name>
            <xsl:value-of select="concat($name, '_', @id)"/>
          </name>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="../../shipBlueprintEnemy[concat(@name, '_ELITE') = $name]">
        <xsl:for-each select="../../shipBlueprintEnemy[concat(@name, '_ELITE') = $name]/sector">
          <name>
            <xsl:value-of select="concat($name, '_', @id)"/>
          </name>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="../../shipBlueprintEnemy[concat(@name, '_PIRATE') = $name]">
        <xsl:for-each select="../../shipBlueprintEnemy[concat(@name, '_PIRATE') = $name]/sector">
          <name>
            <xsl:value-of select="concat($name, '_', @id)"/>
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

  <xsl:template match="shipBlueprintEnemy">
    <xsl:variable name="maxPower">
      <xsl:value-of select="sum(systemList/engines[(not(@start)) or (@start != 'false')]/@power |
                                systemList/oxygen[(not(@start)) or (@start != 'false')]/@power |
                                systemList/shields[(not(@start)) or (@start != 'false')]/@power |
                                systemList/medbay[(not(@start)) or (@start != 'false')]/@power |
                                systemList/clonebay[(not(@start)) or (@start != 'false')]/@power |
                                systemList/teleporter[(not(@start)) or (@start != 'false')]/@power |
                                systemList/cloaking[(not(@start)) or (@start != 'false')]/@power |
                                systemList/artillery[(not(@start)) or (@start != 'false')]/@power |
                                systemList/hacking[(not(@start)) or (@start != 'false')]/@power |
                                systemList/mind[(not(@start)) or (@start != 'false')]/@power)"/>
    </xsl:variable>

    <xsl:apply-templates select="sector"/>

    <shipBlueprint name="OLD_{@name}" layout="{@layout}" img="{@img}">
      <xsl:comment>This shipBlueprint exists just for Superluminal to be able to load it</xsl:comment>
      <class>
        <xsl:apply-templates select="class/@* | class/node()"/>
      </class>
      <xsl:if test="sector[1]/@id &gt; 0">
        <minSector>
          <xsl:value-of select="sector[1]/@id"/>
        </minSector>
      </xsl:if>
      <xsl:if test="sector[last()]/@id &lt; 7">
        <maxSector>
          <xsl:value-of select="sector[last()]/@id"/>
        </maxSector>
      </xsl:if>
      <systemList>
        <xsl:apply-templates select="systemList/*[name() != 'weapons' and name() != 'drones']" mode="normal"/>
        <weapons power="2" max="8" room="{systemList/weapons/@room}"/>
        <xsl:if test="systemList/drones">
          <drones power="2" max="8" room="{systemList/drones/@room}"/>
        </xsl:if>
      </systemList>
      <weaponList load="WEAPONS_ANY_1" missiles="{sector[1]/weaponList/@missiles}"/>
      <xsl:if test="sector/droneList">
        <droneList load="DRONES_STANDARD" drones="{sector[1]/droneList/@drones}"/>
      </xsl:if>
      <xsl:apply-templates select="health"/>
      <maxPower amount="{2 + $maxPower}"/>
      <crewCount amount="{crewCount/@amount}" max="{crewCount/@max}" class="human"/>
      <xsl:apply-templates select="boardingAI | cloakImage"/>
    </shipBlueprint>
    <xsl:if test="class_elite">
      <shipBlueprint name="OLD_{@name}_ELITE" layout="{@layout}_pirate" img="{@img}_pirate">
        <xsl:comment>This shipBlueprint exists just for Superluminal to be able to load it</xsl:comment>
        <class>
          <xsl:apply-templates select="class_elite/@* | class_elite/node()"/>
        </class>
        <xsl:if test="sector[1]/@id &gt; 0">
          <minSector>
            <xsl:value-of select="sector[1]/@id"/>
          </minSector>
        </xsl:if>
        <xsl:if test="sector[last()]/@id &lt; 7">
          <maxSector>
            <xsl:value-of select="sector[last()]/@id"/>
          </maxSector>
        </xsl:if>
        <systemList>
          <xsl:apply-templates select="systemList/*[name() != 'weapons' and name() != 'drones']" mode="elite"/>
          <weapons power="4" max="8" room="{systemList/weapons/@room_elite}"/>
          <xsl:if test="systemList/drones">
            <drones power="4" max="8" room="{systemList/drones/@room_elite}"/>
          </xsl:if>
        </systemList>
        <weaponList load="WEAPONS_ANY_1" missiles="{weaponList[1]/@missiles}"/>
        <xsl:if test="sector/droneList">
          <droneList load="DRONES_STANDARD" drones="{sector[1]/droneList/@drones}"/>
        </xsl:if>
        <xsl:apply-templates select="health"/>
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
        <xsl:comment>This shipBlueprint exists just for Superluminal to be able to load it</xsl:comment>
        <class>
          <xsl:apply-templates select="class_pirate/@* | class_pirate/node()"/>
        </class>
        <minSector>
          <xsl:value-of select="sector[1]/@id"/>
        </minSector>
        <maxSector>
          <xsl:value-of select="sector[last()]/@id"/>
        </maxSector>
        <systemList>
          <xsl:apply-templates select="systemList/*[name() != 'weapons' and name() != 'drones']" mode="pirate"/>
          <weapons power="2" max="8" room="{systemList/weapons/@room_pirate}"/>
          <xsl:if test="systemList/drones">
            <drones power="2" max="8" room="{systemList/drones/@room_pirate}"/>
          </xsl:if>
        </systemList>
        <weaponList load="WEAPONS_ANY_1" missiles="{weaponList[1]/@missiles}"/>
        <xsl:if test="sector/droneList">
          <droneList load="DRONES_STANDARD" drones="{sector[1]/droneList/@drones}"/>
        </xsl:if>
        <xsl:apply-templates select="health"/>
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

  <xsl:template match="shipBlueprintEnemy/sector">
    <xsl:variable name="maxPower">
      <xsl:value-of select="sum(weaponList/@system_power |
                                droneList/@system_power |
                                ../systemList/engines[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/oxygen[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/shields[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/medbay[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/clonebay[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/teleporter[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/cloaking[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/artillery[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/hacking[(not(@start)) or (@start != 'false')]/@power |
                                ../systemList/mind[(not(@start)) or (@start != 'false')]/@power)"/>
    </xsl:variable>
    <shipBlueprint name="{../@name}_{@id}" layout="{../@layout}" img="{../@img}">
      <class>
        <xsl:apply-templates select="../class/@* | ../class/node()"/>
      </class>
      <xsl:if test="@id &gt; 0">
        <minSector>
          <xsl:value-of select="@id"/>
        </minSector>
      </xsl:if>
      <xsl:if test="@id &lt; 7">
        <maxSector>
          <xsl:value-of select="@id"/>
        </maxSector>
      </xsl:if>
      <systemList>
        <xsl:apply-templates select="../systemList/*[name() != 'weapons' and name() != 'drones']" mode="normal"/>
        <xsl:if test="../systemList/weapons">
          <weapons power="{weaponList/@system_power}" room="{../systemList/weapons/@room}"/>
        </xsl:if>
        <xsl:if test="../systemList/drones">
          <drones power="{droneList/@system_power}" room="{../systemList/drones/@room}"/>
        </xsl:if>
      </systemList>
      <xsl:if test="weaponList">
        <weaponList>
          <xsl:apply-templates select="weaponList/@missiles | weaponList/node()"/>
        </weaponList>
      </xsl:if>
      <xsl:if test="droneList">
        <droneList>
          <xsl:apply-templates select="droneList/@drones | droneList/@load | droneList/node()"/>
        </droneList>
      </xsl:if>
      <xsl:apply-templates select="../health"/>
      <maxPower amount="{$maxPower}"/>
      <xsl:apply-templates select="../crewCount | ../boardingAI | ../aug | ../cloakImage"/>
    </shipBlueprint>

    <xsl:if test="../class_elite">
      <shipBlueprint name="{../@name}_ELITE_{@id}" layout="{../@layout}_elite" img="{../@img}_elite">
        <class>
          <xsl:apply-templates select="../class_elite/@* | ../class_elite/node()"/>
        </class>
        <xsl:if test="@id &gt; 0">
          <minSector>
            <xsl:value-of select="@id"/>
          </minSector>
        </xsl:if>
        <xsl:if test="@id &lt; 7">
          <maxSector>
            <xsl:value-of select="@id"/>
          </maxSector>
        </xsl:if>
        <systemList>
          <xsl:apply-templates select="../systemList/*[name() != 'weapons' and name() != 'drones']" mode="elite"/>
          <xsl:if test="../systemList/weapons">
            <weapons power="{weaponList/@system_power}" room="{../systemList/weapons/@room}"/>
          </xsl:if>
          <xsl:if test="../systemList/drones">
            <drones power="{droneList/@system_power}" room="{../systemList/drones/@room}"/>
          </xsl:if>
        </systemList>
        <xsl:if test="weaponList">
          <weaponList missiles="{weaponList/@missiles + 3}">
            <xsl:for-each select="weaponList/weapon">
              <weapon name="{@name}_UPGRADED"/>
            </xsl:for-each>
          </weaponList>
        </xsl:if>
        <xsl:if test="droneList">
          <droneList drones="{droneList/@drones + 3}">
            <xsl:if test="droneList/@load">
              <xsl:attribute name="load">
                <xsl:value-of select="concat(droneList/@load, '_UPGRADED')"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="droneList/drone">
              <drone name="{@name}_UPGRADED"/>
            </xsl:for-each>
          </droneList>
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
      <shipBlueprint name="{../@name}_PIRATE_{@id}" layout="{../@layout}_pirate" img="{../@img}_pirate">
        <class>
          <xsl:apply-templates select="../class_pirate/@* | ../class_pirate/node()"/>
        </class>
        <xsl:if test="@id &gt; 0">
          <minSector>
            <xsl:value-of select="@id"/>
          </minSector>
        </xsl:if>
        <xsl:if test="@id &lt; 7">
          <maxSector>
            <xsl:value-of select="@id"/>
          </maxSector>
        </xsl:if>
        <systemList>
          <xsl:apply-templates select="../systemList/*[(name() != 'weapons') and (name() != 'drones') and @room_pirate]" mode="pirate"/>
          <xsl:if test="../systemList/weapons">
            <weapons power="{weaponList/@system_power}" room="{../systemList/weapons/@room_pirate}"/>
          </xsl:if>
          <xsl:if test="../systemList/drones">
            <drones power="{droneList/@system_power}" room="{../systemList/drones/@room_pirate}"/>
          </xsl:if>
        </systemList>
        <xsl:if test="weaponList">
          <weaponList>
            <xsl:apply-templates select="weaponList/@missiles | weaponList/node()"/>
          </weaponList>
        </xsl:if>
        <xsl:if test="droneList">
          <droneList>
            <xsl:apply-templates select="droneList/@drones | droneList/@load | droneList/node()"/>
          </droneList>
        </xsl:if>
        <xsl:apply-templates select="../health"/>
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

</xsl:transform>
