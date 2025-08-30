USING "core_menu.sch"
USING "core_globals.sch"
USING "features_weapons.sch"

PROC SUBMENUS_DRAW_WEAPONS_AMMUNATION()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WEAPONS_AMMUNATION)
        INT iIndex = 0
        REPEAT NUM_WEAPONS iIndex
            STRING sButtonName = GET_WEAPON_DISPLAY_NAME_BY_INDEX(iIndex)
            IF MENU_BUTTON(sButtonName)
                INT iWeaponHash = GET_WEAPON_HASH_BY_INDEX(iIndex)
                FEATURES_WEAPONS_GIVE_WEAPON(iWeaponHash)
            ENDIF
        ENDREPEAT
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_WEAPONS()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_WEAPONS)
        MENU_SUBMENU_BUTTON("Ammu-Nation", SUBMENUS_WEAPONS_AMMUNATION, "Select and get any weapon.")
        IF MENU_BUTTON("Fill Ammo", "Refill all your weapons to maximum ammo.")
            FEATURES_WEAPONS_FILL_AMMO()
        ENDIF
        IF MENU_BUTTON("Get All Weapons", "Give yourself every weapon available in the game.")
            FEATURES_WEAPONS_GET_ALL_WEAPONS()
        ENDIF
        IF MENU_BUTTON("Remove All Weapons", "Remove all of your weapons.")
            FEATURES_WEAPONS_REMOVE_ALL_WEAPONS()
        ENDIF
        IF MENU_BUTTON("Remove Current Weapon", "Remove the weapon you are currently holding.")
            FEATURES_WEAPONS_REMOVE_CURRENT_WEAPON()
        ENDIF
        IF MENU_CHECKBOX("Infinite Ammo", g_sFeatures.sWeaponsFeatures.bInfiniteAmmo, "Never run out of ammo.")
            IF NOT g_sFeatures.sWeaponsFeatures.bInfiniteAmmo
                FEATURES_WEAPONS_INFINITE_AMMO(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Infinite Clip", g_sFeatures.sWeaponsFeatures.bInfiniteClip, "Your gun’s clip never depletes.")
            IF NOT g_sFeatures.sWeaponsFeatures.bInfiniteClip
                FEATURES_WEAPONS_INFINITE_CLIP(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("Explosive Ammo", g_sFeatures.sWeaponsFeatures.bExplosiveAmmo, "Every bullet you fire causes an explosion on impact.")
        MENU_CHECKBOX("Explosive Melee", g_sFeatures.sWeaponsFeatures.bExplosiveMelee, "Melee attacks trigger explosions on impact.")
        MENU_CHECKBOX("Fire Ammo", g_sFeatures.sWeaponsFeatures.bFireAmmo, "Bullets ignite targets, setting them on fire.")
    ENDIF
	
    SUBMENUS_DRAW_WEAPONS_AMMUNATION()
ENDPROC
