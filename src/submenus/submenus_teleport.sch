USING "core_menu.sch"
USING "core_globals.sch"
USING "features_teleport.sch"

VECTOR vCustomTpCoords = <<0.0, 0.0, 0.0>>

PROC SUBMENUS_DRAW_TELEPORT_CUSTOM_TELEPORT()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_TELEPORT_CUSTOM_TELEPORT)
        MENU_KEYBOARD_FLOAT("X Axis:", vCustomTpCoords.x, "Enter target X position.")
        MENU_KEYBOARD_FLOAT("Y Axis:", vCustomTpCoords.y, "Enter target Y position.")
        MENU_KEYBOARD_FLOAT("Z Axis:", vCustomTpCoords.z, "Enter target Z position.")
        IF MENU_BUTTON("Teleport to Coords", "Teleport to the entered X, Y, Z coordinates.")
            SET_PED_COORDS_KEEP_VEHICLE(PLAYER_PED_ID(), vCustomTpCoords)
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_TELEPORT()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_TELEPORT)
        MENU_SUBMENU_BUTTON("Custom Teleport", SUBMENUS_TELEPORT_CUSTOM_TELEPORT, "Enter and teleport to custom coordinates.")
        VECTOR vPedPos = GET_ENTITY_COORDS(PLAYER_PED_ID(), TRUE)
        FLOAT xPos = vPedPos.x
        FLOAT yPos = vPedPos.y
        FLOAT zPos = vPedPos.z
        // Move these to features?
        IF MENU_SLIDER_FLOAT("X Axis", xPos, FLOAT_MIN, FLOAT_MAX, "Adjust your current X position.")
            FREEZE_ENTITY_POSITION(PLAYER_PED_ID(), TRUE)
            SET_ENTITY_COORDS(PLAYER_PED_ID(), <<xPos, vPedPos.y, vPedPos.z-1>>, TRUE, TRUE, TRUE, TRUE)
            FREEZE_ENTITY_POSITION(PLAYER_PED_ID(), FALSE)
        ENDIF
        IF MENU_SLIDER_FLOAT("Y Axis", yPos, FLOAT_MIN, FLOAT_MAX, "Adjust your current Y position.")
            FREEZE_ENTITY_POSITION(PLAYER_PED_ID(), TRUE)
            SET_ENTITY_COORDS(PLAYER_PED_ID(), <<vPedPos.x, yPos, vPedPos.z-1>>, TRUE, TRUE, TRUE, TRUE)
            FREEZE_ENTITY_POSITION(PLAYER_PED_ID(), FALSE)
        ENDIF
        IF MENU_SLIDER_FLOAT("Z Axis", zPos, FLOAT_MIN, FLOAT_MAX, "Adjust your current Z position.")
            FREEZE_ENTITY_POSITION(PLAYER_PED_ID(), TRUE)
            SET_ENTITY_COORDS(PLAYER_PED_ID(), <<vPedPos.x, vPedPos.y, zPos-1>>, TRUE, TRUE, TRUE, TRUE)
            FREEZE_ENTITY_POSITION(PLAYER_PED_ID(), FALSE)
        ENDIF
        IF MENU_BUTTON("Teleport to Waypoint", "Teleport to the waypoint.", g_sFeatures.sTeleportFeatures.bAutoTpToWaypoint)
            FEATURES_TELEPORT_TELEPORT_TO_WAYPOINT()
        ENDIF
        IF MENU_BUTTON("Teleport to Objective", "Teleport to the objective.")
            FEATURES_TELEPORT_TELEPORT_TO_OBJECTIVE()
        ENDIF
        IF MENU_BUTTON("Forward", "Teleport one meter forward.")
            FEATURES_TELEPORT_TELEPORT_TO_OFFSET(<<0, 1.000, 0>>)
        ENDIF
        IF MENU_BUTTON("Backward", "Teleport one meter backward.")
            FEATURES_TELEPORT_TELEPORT_TO_OFFSET(<<0, -1.000, 0>>)
        ENDIF
        IF MENU_BUTTON("Up", "Teleport one meter upwards.")
            FEATURES_TELEPORT_TELEPORT_TO_OFFSET(<<0, 0, 1.000>>)
        ENDIF
        IF MENU_BUTTON("Down", "Teleport one meter downwards.")
            FEATURES_TELEPORT_TELEPORT_TO_OFFSET(<<0, 0, -1.000>>)
        ENDIF
        MENU_CHECKBOX("Auto TP to Waypoint", g_sFeatures.sTeleportFeatures.bAutoTpToWaypoint, "Automatically teleport to the waypoint whenever it is set.")
    ENDIF
	
    SUBMENUS_DRAW_TELEPORT_CUSTOM_TELEPORT()
ENDPROC
