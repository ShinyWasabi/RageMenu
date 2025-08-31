USING "submenus_self.sch"
USING "submenus_vehicle.sch"
USING "submenus_weapons.sch"
USING "submenus_teleport.sch"
USING "submenus_world.sch"
USING "submenus_debug.sch"

PROC SUBMENUS_DRAW_MAIN()
    IF MENU_BEGIN()
        IF MENU_BEGIN_SUBMENU(SUBMENUS_MAIN)
            MENU_SUBMENU_BUTTON("Self", SUBMENUS_SELF, "Self options.")
            MENU_SUBMENU_BUTTON("Vehicle", SUBMENUS_VEHICLE, "Vehicle options.")
            MENU_SUBMENU_BUTTON("Weapons", SUBMENUS_WEAPONS, "Weapon options.")
            MENU_SUBMENU_BUTTON("Teleport", SUBMENUS_TELEPORT, "Teleport options.")
            MENU_SUBMENU_BUTTON("World", SUBMENUS_WORLD, "World options.")
            MENU_SUBMENU_BUTTON("Debug", SUBMENUS_DEBUG, "Debug options.")
        ENDIF

        SUBMENUS_DRAW_SELF()
        SUBMENUS_DRAW_VEHICLE()
        SUBMENUS_DRAW_WEAPONS()
        SUBMENUS_DRAW_TELEPORT()
        SUBMENUS_DRAW_WORLD()
        SUBMENUS_DRAW_DEBUG()

        MENU_END()
    ENDIF
ENDPROC
