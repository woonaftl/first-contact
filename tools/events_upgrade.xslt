<?xml version="1.0" encoding="utf-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>

  <xsl:variable name="tip_text">&#10;&#10;Tip: Upgraded weapons require 1 less power and charge faster, than stock weapons. Drone schematics can be upgraded too, lowering power usage by 1. Upgraded equipment and equipment that uses only 1 power cannot be upgraded.</xsl:variable>

  <xsl:template match="@* | node()" name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="FTL">
    <xsl:copy>
      <xsl:comment>This file is generated automatically from blueprint files! Change events in xslt file!</xsl:comment>

      <eventList name="UPGRADE_LIST_ALL">
        <event load="UPGRADE_LIST_LEGIT"/>
        <event load="UPGRADE_LIST_SKETCHY"/>
      </eventList>
      <eventList name="UPGRADE_LIST_LEGIT">
        <event load="UPGRADE_SCRAP"/>
        <event load="UPGRADE_SCRAP_CREW"/>
        <event load="UPGRADE_SCRAP_DRONEPARTS"/>
        <event load="UPGRADE_SCRAP_FUEL"/>
        <event load="UPGRADE_SCRAP_MISSILES"/>
      </eventList>
      <eventList name="UPGRADE_LIST_SKETCHY">
        <event load="UPGRADE_FREE_FAKE"/>
        <event load="UPGRADE_FREE_TRUE"/>
      </eventList>
      <eventList name="UPGRADE_LIST_NEBULA">
        <event load="UPGRADE_FREE_FAKE_NEBULA"/>
        <event load="UPGRADE_FREE_TRUE_NEBULA"/>
      </eventList>

      <event name="UPGRADE_FREE_FAKE" unique="false">
        <text>
          <xsl:text>You arrived at the huge station captured by pirates. The pirates did not attack you immediately but offered to upgrade any of your weapons instead. For free.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>The pirates have taken your weapon to their station to install necessary modifications.</text>
              <remove name="{@name}"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_FAKE_WEAPON_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>The pirates have taken your drone to their station to install necessary modifications.</text>
              <remove name="{@name}"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_FAKE_DRONE_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>
      <event name="UPGRADE_FREE_FAKE_NEBULA" unique="false">
        <text>
          <xsl:text>You arrived at the huge station captured by pirates. The pirates did not attack you immediately but offered to upgrade any of your weapons instead. For free.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <environment type="nebula"/>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>The pirates have taken your weapon to their station to install necessary modifications.</text>
              <remove name="{@name}"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_FAKE_WEAPON_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>The pirates have taken your drone to their station to install necessary modifications.</text>
              <remove name="{@name}"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_FAKE_DRONE_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>
      <eventList name="UPGRADE_FREE_FAKE_WEAPON_LIST">
        <event>
          <text>Your weapon did not return to your ship. The station does not respond to your demands to give the weapon back.</text>
        </event>
        <event>
          <text>After hours of working on your weapon, the pirates bring it back. As you open the casing, you realize that it's the different weapon. The delivery workers are long gone and the station does not respond.</text>
          <weapon name="RANDOM"/>
        </event>
        <event>
          <text>The pirates have spent a lot of time working on upgrading your weapon, but bring nothing but bring nothing but a hulk of scrap as a result. At least, they allowed you to keep it.</text>
          <item_modify>
            <item type="scrap" min="15" max="20"/>
          </item_modify>
        </event>
        <event>
          <text>As you open the casing which was meant to contain your upgraded weapon, you find nothing but some ammunition inside. You shouldn't have trusted those pirates!</text>
          <item_modify>
            <item type="missiles" min="4" max="6"/>
          </item_modify>
        </event>
      </eventList>
      <eventList name="UPGRADE_FREE_FAKE_DRONE_LIST">
        <event>
          <text>Your drone did not return to your ship. The station does not respond to your demands to give the drone back.</text>
        </event>
        <event>
          <text>After hours of working on your drone, the pirates bring it back. As you open the casing, you realize that it's the different drone. The delivery workers are long gone and the station does not respond.</text>
          <drone name="RANDOM"/>
        </event>
        <event>
          <text>The pirates have spent a lot of time working on upgrading your drone schematic, but bring nothing but bring nothing but a hulk of scrap as a result. At least, they allowed you to keep it.</text>
          <item_modify>
            <item type="scrap" min="15" max="20"/>
          </item_modify>
        </event>
        <event>
          <text>As you open the casing which was meant to contain your upgraded drone, you find nothing but some drone parts inside. You shouldn't have trusted those pirates!</text>
          <item_modify>
            <item type="drones" min="3" max="5"/>
          </item_modify>
        </event>
      </eventList>

      <event name="UPGRADE_FREE_TRUE" unique="false">
        <text>
          <xsl:text>You arrived at the huge station captured by pirates. The pirates did not attack you immediately but offered to upgrade any of your weapons instead. For free.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>While pirates looked sketchy at first, they installed some newest modifications to your weapon making it charge faster and use less power.</text>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_TRUE_WEAPON_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>While pirates looked sketchy at first, they installed some newest modifications to your drone making it charge faster and use less power.</text>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_TRUE_DRONE_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>
      <event name="UPGRADE_FREE_TRUE_NEBULA" unique="false">
        <text>
          <xsl:text>You arrived at the huge station captured by pirates. The pirates did not attack you immediately but offered to upgrade any of your weapons instead. For free.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <environment type="nebula"/>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>While pirates looked sketchy at first, they installed some newest modifications to your weapon making it charge faster and use less power.</text>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_TRUE_WEAPON_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}" hidden="true">
            <text>
              <xsl:text>Risk it: ask to upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>While pirates looked sketchy at first, they installed some newest modifications to your drone making it charge faster and use less power.</text>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
              <choice hidden="true">
                <text id="continue"/>
                <event load="UPGRADE_FREE_TRUE_DRONE_LIST"/>
              </choice>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>
      <eventList name="UPGRADE_FREE_TRUE_WEAPON_LIST">
        <event>
          <text>The pirates did not take anything in return. "This one on the house."</text>
        </event>
        <event>
          <text>The pirates did not ask anything for their service, but, as they left, they emptied your hold without any of your crew noticing.</text>
          <item_modify steal="true">
            <item type="scrap" min="-999" max="-999"/>
          </item_modify>
        </event>
        <event>
          <text>The pirates did not ask anything in exchange for upgrading your weapon. After they left, you received a warning about incoming Rebel fleet. These pirate station seems to be sponsored by Rebels.</text>
          <modifyPursuit amount="2"/>
        </event>
        <event>
          <text>After upgrading your weapon, the pirates decided that they would like to take over your ship.</text>
          <damage amount="8" system="weapons" effect="fire"/>
          <boarders min="4" max="5" class="random"/>
          <ship auto_blueprint="SHIPS_PIRATE" hostile="true">
            <destroyed>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </destroyed>
            <deadCrew>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </deadCrew>
          </ship>
        </event>
        <event>
          <text>While the pirates did upgrade your weapon, after they did their job, a Rebel ship with weapons online has entered the system. The pirate station seems to be working with Rebels since it fires at you with anti-ship battery.</text>
          <environment type="PDS" target="player"/>
          <ship auto_blueprint="SHIPS_REBEL" hostile="true">
            <destroyed>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </destroyed>
            <deadCrew>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </deadCrew>
          </ship>
        </event>
      </eventList>
      <eventList name="UPGRADE_FREE_TRUE_DRONE_LIST">
        <event>
          <text>The pirates did not take anything in return. "This one on the house."</text>
        </event>
        <event>
          <text>The pirates did not ask anything for their service, but, as they left, they emptied your hold without any of your crew noticing.</text>
          <item_modify steal="true">
            <item type="scrap" min="-999" max="-999"/>
          </item_modify>
        </event>
        <event>
          <text>The pirates did not ask anything in exchange for upgrading your drone. After they left, you received a warning about incoming Rebel fleet. These pirate station seems to be sponsored by Rebels.</text>
          <modifyPursuit amount="2"/>
        </event>
        <event>
          <text>After upgrading your drone, the pirates decided that they would like to take over your ship.</text>
          <damage amount="8" system="drones" effect="fire"/>
          <boarders min="4" max="5" class="random"/>
          <ship auto_blueprint="SHIPS_PIRATE" hostile="true">
            <destroyed>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </destroyed>
            <deadCrew>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </deadCrew>
          </ship>
        </event>
        <event>
          <text>While the pirates did upgrade your drone, after they did their job, a Rebel ship with weapons online has entered the system. The pirate station seems to be working with Rebels since it fires at you with anti-ship battery.</text>
          <environment type="PDS" target="player"/>
          <ship auto_blueprint="SHIPS_REBEL" hostile="true">
            <destroyed>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </destroyed>
            <deadCrew>
              <text>There's no time to salvage the enemy ship. The anti-ship battery keeps firing at you.</text>
            </deadCrew>
          </ship>
        </event>
      </eventList>

      <event name="UPGRADE_SCRAP" unique="false">
        <text>
          <xsl:text>You arrive at the factory providing both Rebels and Federation with weapons. You can optimize any equipment here in exchange for some scrap.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>The engineers at the factory upgraded your weapon. It uses less power now, and charges faster.</text>
              <item_modify>
                <item type="scrap" min="-80" max="-60"/>
              </item_modify>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>The engineers at the factory upgraded your weapon. It uses less power now, and charges faster.</text>
              <item_modify>
                <item type="scrap" min="-65" max="-50"/>
              </item_modify>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>

      <event name="UPGRADE_SCRAP_CREW" unique="false">
        <text>
          <xsl:text>You arrive at the scientific station. The station severely lacks workforce but offers to optimize any of your weapons or drones in exchange for one of your crewmembers and some scrap.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your weapon is upgraded at the scientific station. It uses less power now, and charges faster.</text>
              <item_modify>
                <item type="scrap" min="-40" max="-30"/>
              </item_modify>
              <removeCrew>
                <clone>false</clone>
                <text>Since your lost crewmember is still alive, you cannot clone them.</text>
              </removeCrew>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your drone is upgraded at the scientific station. It uses less power now.</text>
              <item_modify>
                <item type="scrap" min="-30" max="-20"/>
              </item_modify>
              <removeCrew>
                <clone>false</clone>
                <text>Since your lost crewmember is still alive, you cannot clone them.</text>
              </removeCrew>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>

      <event name="UPGRADE_SCRAP_DRONEPARTS" unique="false">
        <text>
          <xsl:text>An automated station greets you with a pre-recorded message. "Upgrade your equipment here. Requested payment: drone parts."</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your weapon is upgraded at the automated station. It uses less power now, and charges faster.</text>
              <item_modify>
                <item type="scrap" min="-40" max="-30"/>
                <item type="drones" min="-12" max="-8"/>
              </item_modify>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your drone is upgraded at the automated station. It uses less power now.</text>
              <item_modify>
                <item type="scrap" min="-35" max="-25"/>
                <item type="drones" min="-8" max="-5"/>
              </item_modify>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>

      <event name="UPGRADE_SCRAP_FUEL" unique="false">
        <text>
          <xsl:text>A friendly cruiser contacts you and suggests to optimize any of your weapons or drones in exchange for some scrap and fuel.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your weapon is upgraded. It uses less power now, and charges faster. The friendly ship jumps away.</text>
              <item_modify>
                <item type="scrap" min="-40" max="-30"/>
                <item type="fuel" min="-12" max="-8"/>
              </item_modify>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your drone is upgraded. It uses less power now. The friendly ship jumps away.</text>
              <item_modify>
                <item type="scrap" min="-35" max="-25"/>
                <item type="fuel" min="-8" max="-5"/>
              </item_modify>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>

      <event name="UPGRADE_SCRAP_MISSILES" unique="false">
        <text>
          <xsl:text>The system you arrived to specializes in mining asteroids and forging extracted metals into weapons. They are ready to upgrade any of your weapons or drones in exchange for some scrap and explosives.</xsl:text>
          <xsl:value-of select="$tip_text"/>
        </text>
        <xsl:for-each select="weaponBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'ARTILLERY'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your weapon is upgraded. It uses less power now, and charges faster.</text>
              <item_modify>
                <item type="scrap" min="-35" max="-25"/>
                <item type="missiles" min="-20" max="-15"/>
              </item_modify>
              <remove name="{@name}"/>
              <weapon name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <xsl:for-each select="droneBlueprint[not(contains(@name, 'UPGRADED'))][not(contains(@name, 'BOARDER_ION'))][power &gt; 1]">
          <choice req="{@name}">
            <text>
              <xsl:text>Upgrade&#32;</xsl:text>
              <xsl:value-of select="title"/>
              <xsl:text>.</xsl:text>
            </text>
            <event>
              <text>Your drone is upgraded. It uses less power now.</text>
              <item_modify>
                <item type="scrap" min="-35" max="-25"/>
                <item type="missiles" min="-14" max="-9"/>
              </item_modify>
              <remove name="{@name}"/>
              <drone name="{@name}_UPGRADED"/>
            </event>
          </choice>
        </xsl:for-each>
        <choice hidden="true">
          <text>Leave.</text>
          <event/>
        </choice>
      </event>
    </xsl:copy>
  </xsl:template>
</xsl:transform>