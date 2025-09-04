USING "core_menu.sch"
USING "core_globals.sch"
USING "features_world.sch"

TEXT_LABEL_63 tlCustomIPLName = ""

PROC INIT_IPL_SET_DATA()
    sIPLSetData.sIPLSetNames[0] = "North Yankton"
    sIPLSetData.sIPLSetNames[1] = "Cayo Perico"
    sIPLSetData.sIPLSetNames[2] = "Dignity Party Yacht"
    sIPLSetData.sIPLSetNames[3] = "Aircraft Carrier"
    sIPLSetData.sIPLSetNames[4] = "Sunken Cargo Ship"
    sIPLSetData.sIPLSetNames[5] = "Destroyed Pillbox Hospital"
    sIPLSetData.sIPLSetNames[6] = "O'Neil Farm Destroyed"
    sIPLSetData.sIPLSetNames[7] = "LifeInvader Interior"
    sIPLSetData.sIPLSetNames[8] = "Jewelry Store Interior"
    sIPLSetData.sIPLSetNames[9] = "Coroner Morgue Interior"
	
    sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_PROLOGUE_BY_INDEX
ENDPROC

PROC WEATHER_BUTTON(STRING weatherName, STRING codeName)
    IF MENU_BUTTON(weatherName)
        FEATURES_WORLD_SET_WEATHER(codeName)
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_WORLD_WEATHER()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WORLD_WEATHER)
        WEATHER_BUTTON("Clear", "CLEAR")
        WEATHER_BUTTON("Extra Sunny", "EXTRASUNNY")
        WEATHER_BUTTON("Clouds", "CLOUDS")
        WEATHER_BUTTON("Overcast", "OVERCAST")
        WEATHER_BUTTON("Rain", "RAIN")
        WEATHER_BUTTON("Clearing", "CLEARING")
        WEATHER_BUTTON("Thunder", "THUNDER")
        WEATHER_BUTTON("Smog", "SMOG")
        WEATHER_BUTTON("Foggy", "FOGGY")
        WEATHER_BUTTON("Xmas", "XMAS")
        WEATHER_BUTTON("Snow", "SNOW")
        WEATHER_BUTTON("Snow Light", "SNOWLIGHT")
        WEATHER_BUTTON("Blizzard", "BLIZZARD")
        WEATHER_BUTTON("Halloween", "HALLOWEEN")
        WEATHER_BUTTON("Neutral", "NEUTRAL")
        WEATHER_BUTTON("Rain Halloween", "RAIN_HALLOWEEN")
        WEATHER_BUTTON("Snow Halloween", "SNOW_HALLOWEEN")
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_WORLD_TIME()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WORLD_TIME)
        INT iHour = GET_CLOCK_HOURS()
        INT iMinute = GET_CLOCK_MINUTES()
        INT iSecond = GET_CLOCK_SECONDS()
        IF MENU_SLIDER_INTEGER("Hour", iHour, 0, 23, "Change the current hour (0–23).")
            FEATURES_WORLD_SET_TIME(iHour, iMinute, iSecond)
        ENDIF
        IF MENU_SLIDER_INTEGER("Minute", iMinute, 0, 59, "Change the current minute (0–59).")
            FEATURES_WORLD_SET_TIME(iHour, iMinute, iSecond)
        ENDIF
        IF MENU_SLIDER_INTEGER("Second", iSecond, 0, 59, "Change the current second (0–59).")
            FEATURES_WORLD_SET_TIME(iHour, iMinute, iSecond)
        ENDIF
        IF MENU_BUTTON("Midnight", "Set the time to midnight (00:00).")
            FEATURES_WORLD_SET_TIME(0, 0, 0)
        ENDIF
        IF MENU_BUTTON("Dawn", "Set the time to dawn (06:00).")
            FEATURES_WORLD_SET_TIME(6, 0, 0)
        ENDIF
        IF MENU_BUTTON("Noon", "Set the time to noon (12:00).")
            FEATURES_WORLD_SET_TIME(12, 0, 0)
        ENDIF
        IF MENU_BUTTON("Evening", "Set the time to evening (18:00).")
            FEATURES_WORLD_SET_TIME(18, 0, 0)
        ENDIF
        IF MENU_CHECKBOX("Pause Time", g_sFeatures.sWorldFeatures.bPauseTime, "Freeze the time and stop it from progressing.")
            IF NOT g_sFeatures.sWorldFeatures.bPauseTime
                FEATURES_WORLD_PAUSE_TIME(FALSE)
            ENDIF
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_WORLD_IPL_CUSTOM_IPL()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WORLD_CUSTOM_IPL)
        MENU_KEYBOARD_STRING("IPL Name", tlCustomIPLName, "Enter IPL name.")
        IF MENU_BUTTON("Load IPL", "Load a specific IPL by name.")
            WORLD_LOAD_IPL(tlCustomIPLName, TRUE)
        ENDIF
        IF MENU_BUTTON("Unload IPL", "Unoad a specific IPL by name.")
            WORLD_LOAD_IPL(tlCustomIPLName, FALSE)
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_WORLD_IPL()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WORLD_IPL)
        MENU_SUBMENU_BUTTON("Custom IPL", SUBMENUS_WORLD_CUSTOM_IPL, "Manually load or unload an IPL by name.")
        IF MENU_SLIDER_STRING("IPL Set", sIPLSetData.sIPLSetNames, sIPLSetData.iCurrentIPLSetIndex, "Select from preset IPLs.")
            SWITCH sIPLSetData.iCurrentIPLSetIndex
                CASE 0 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_PROLOGUE_BY_INDEX    BREAK
                CASE 1 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_ISLAND_BY_INDEX      BREAK
                CASE 2 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_SMBOAT_BY_INDEX      BREAK
                CASE 3 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_HEI_CARRIER_BY_INDEX BREAK
                CASE 4 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_SUNK_SHIP_BY_INDEX   BREAK
                CASE 5 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_HOSPITAL_BY_INDEX    BREAK
                CASE 6 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_FARM_BY_INDEX        BREAK
                CASE 7 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_LOBBY_BY_INDEX       BREAK
                CASE 8 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_JEWEL_BY_INDEX       BREAK
                CASE 9 sIPLSetData.fpGetIPLNameByIndex = &UTIL_WORLD_GET_IPL_NAME_CORONER_BY_INDEX     BREAK
            ENDSWITCH
        ENDIF
        IF MENU_BUTTON("Load IPL Set", "Load the currently selected IPL set.")
            WORLD_LOAD_IPL_SET(TRUE)
        ENDIF
        IF MENU_BUTTON("Unload IPL Set", "Unload the currently selected IPL set.")
            WORLD_LOAD_IPL_SET(FALSE)
        ENDIF
        IF MENU_BUTTON("Teleport to IPL Set", "Teleport to the location of the selected IPL set.")
            VECTOR vPos = UTIL_WORLD_GET_IPL_SET_COORDS(sIPLSetData.iCurrentIPLSetIndex)
            SET_PED_COORDS_KEEP_VEHICLE(PLAYER_PED_ID(), vPos)
        ENDIF
        IF MENU_BUTTON("Load MP Map", "Load GTA Online map parts.")
            ON_ENTER_MP()
        ENDIF
        IF MENU_BUTTON("Load SP Map", "Load Singleplayer map parts.")
            ON_ENTER_SP()
        ENDIF
    ENDIF
	
    SUBMENUS_DRAW_WORLD_IPL_CUSTOM_IPL()
ENDPROC

PROC SUBMENUS_DRAW_WORLD()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WORLD)
        MENU_SUBMENU_BUTTON("Weather", SUBMENUS_WORLD_WEATHER, "Change the current weather.")
        MENU_SUBMENU_BUTTON("Time", SUBMENUS_WORLD_TIME, "Set or freeze the current time.")
        MENU_SUBMENU_BUTTON("IPL", SUBMENUS_WORLD_IPL, "Load, unload, or teleport to IPLs.")
        IF MENU_BUTTON("Headshot Nearby Enemies", "Instantly kill nearby enemies with a headshot.")
            FEATURES_WORLD_HEADSHOT_NEARBY_ENEMIES()
        ENDIF
        IF MENU_CHECKBOX("Blackout", g_sFeatures.sWorldFeatures.bBlackout, "Disable all city lights and create a blackout.")
            IF NOT g_sFeatures.sWorldFeatures.bBlackout
                FEATURES_WORLD_BLACKOUT(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Night Vision", g_sFeatures.sWorldFeatures.bNightVision, "Enable night vision.")
            IF NOT g_sFeatures.sWorldFeatures.bNightVision
                FEATURES_WORLD_NIGHT_VISION(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Thermal Vision", g_sFeatures.sWorldFeatures.bThermalVision, "Enable thermal vision.")
            IF NOT g_sFeatures.sWorldFeatures.bThermalVision
                FEATURES_WORLD_THERMAL_VISION(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Riot Mode", g_sFeatures.sWorldFeatures.bRiotMode, "Make nearby NPCs riot.")
            IF NOT g_sFeatures.sWorldFeatures.bRiotMode
                FEATURES_WORLD_RIOT_MODE(FALSE)
            ENDIF
        ENDIF
    ENDIF
	
    SUBMENUS_DRAW_WORLD_WEATHER()
    SUBMENUS_DRAW_WORLD_TIME()
    SUBMENUS_DRAW_WORLD_IPL()
ENDPROC
