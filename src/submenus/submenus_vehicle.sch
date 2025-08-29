USING "core_menu.sch"
USING "core_globals.sch"
USING "features_vehicle.sch"

VEHICLE_CLASS eSelectedVehicleClass = VC_COMPACT

PROC SUBMENUS_DRAW_VEHICLE_CLASS()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_VEHICLE_CLASS)
        INT iMaxVehicles = UTIL_VEHICLE_GET_NUM_VEHICLES_IN_CLASS(eSelectedVehicleClass)
        INT iIndex = 0
        REPEAT iMaxVehicles iIndex
            INT iVehicleHash = UTIL_VEHICLE_GET_VEHICLE_HASH_FROM_CLASS_BY_INDEX(eSelectedVehicleClass, iIndex)
            STRING sButtonName = GET_FILENAME_FOR_AUDIO_CONVERSATION(GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(iVehicleHash))
            IF MENU_BUTTON(sButtonName)
                VEHICLE_SPAWN_VEHICLE(iVehicleHash)
            ENDIF
        ENDREPEAT
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_VEHICLE_SPAWN()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_VEHICLE_SPAWN)
        INT iIndex = 0
        REPEAT COUNT_OF(VEHICLE_CLASS) iIndex
            TEXT_LABEL tlLabel = "VEH_CLASS_"
            tlLabel += iIndex
            STRING sClassName = GET_FILENAME_FOR_AUDIO_CONVERSATION(tlLabel)
            IF MENU_SUBMENU_BUTTON(sClassName, SUBMENUS_VEHICLE_CLASS)
                eSelectedVehicleClass = INT_TO_ENUM(VEHICLE_CLASS, iIndex)
            ENDIF
        ENDREPEAT
    ENDIF
	
    SUBMENUS_DRAW_VEHICLE_CLASS()
ENDPROC

PROC SUBMENUS_DRAW_VEHICLE()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_VEHICLE)
        MENU_SUBMENU_BUTTON("Spawn", SUBMENUS_VEHICLE_SPAWN, "Spawn Vehicle.")
        IF MENU_BUTTON("Repair", "Repair any damage to the vehicle.", g_sFeatures.sVehicleFeatures.bAlwaysRepaired)
            FEATURES_VEHICLE_REPAIR()
        ENDIF
        IF MENU_BUTTON("Max Mods", "Max out vehicle mods.")
            FEATURES_VEHICLE_MAX_MODS(UTIL_VEHICLE_GET_CURRENT())
        ENDIF
        IF MENU_BUTTON("Teleport into PV", "Teleport into your personal vehicle.")
            FEATURES_VEHICLE_TELEPORT(UTIL_VEHICLE_GET_CURRENT_PV())
        ENDIF
        IF MENU_BUTTON("Bring PV", "Bring your personal vehicle to your position.")
            FEATURES_VEHICLE_BRING(UTIL_VEHICLE_GET_CURRENT_PV())
        ENDIF
        IF MENU_CHECKBOX("Godmode", g_sFeatures.sVehicleFeatures.bGodmode, "Block all incoming damage to the vehicle.")
            IF NOT g_sFeatures.sVehicleFeatures.bGodmode
                FEATURES_VEHICLE_GODMODE(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Seatbelt", g_sFeatures.sVehicleFeatures.bSeatbelt, "Never fall out of the vehicle.")
            IF NOT g_sFeatures.sVehicleFeatures.bSeatBelt
                FEATURES_VEHICLE_SEATBELT(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("Always Repaired", g_sFeatures.sVehicleFeatures.bAlwaysRepaired, "Keep the vehicle repaired.")
        MENU_CHECKBOX("Horn Boost", g_sFeatures.sVehicleFeatures.bHornBoost, "Boost the vehicle speed when the horn is held.")
        MENU_CHECKBOX("Speedo Meter", g_sFeatures.sVehicleFeatures.bSpeedoMeter, "Display a speedometer on the screen.")
    ENDIF
	
    SUBMENUS_DRAW_VEHICLE_SPAWN()
ENDPROC
