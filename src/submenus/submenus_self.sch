USING "core_menu.sch"
USING "core_globals.sch"
USING "features_self.sch"

PROC SUBMENUS_DRAW_SELF_WANTED_LEVEL()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_SELF_WANTED_LEVEL)
        IF MENU_BUTTON("Clear Wanted", "Clear your wanted level.", g_sFeatures.sSelfFeatures.bNeverWanted)
            FEATURES_SELF_SET_WANTED_LEVEL(0)
        ENDIF
        INT iWantedLevel = GET_PLAYER_WANTED_LEVEL(PLAYER_ID())
        IF MENU_SLIDER_INTEGER("Wanted Level", iWantedLevel, 0, 5, "Set your wanted level.", g_sFeatures.sSelfFeatures.bNeverWanted)
            FEATURES_SELF_SET_WANTED_LEVEL(iWantedLevel)
        ENDIF
        IF MENU_CHECKBOX("Never Wanted", g_sFeatures.sSelfFeatures.bNeverWanted, "Never gain a wanted level.")
            IF NOT g_sFeatures.sSelfFeatures.bNeverWanted
                FEATURES_SELF_NEVER_WANTED(FALSE)
            ENDIF
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_SELF()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_SELF)
        MENU_SUBMENU_BUTTON("Wanted Level", SUBMENUS_SELF_WANTED_LEVEL, "Wanted level options.")
        IF MENU_BUTTON("Heal", "Restores your health and armour.")
            FEATURES_SELF_HEAL()
        ENDIF
        IF MENU_BUTTON("Suicide", "Kills you.")
            FEATURES_SELF_SUICIDE()
        ENDIF
        IF MENU_BUTTON("Clear", "Clears all the dirt and blood on you.")
            FEATURES_SELF_CLEAR()
        ENDIF
        IF MENU_BUTTON("Skip Cutscene", "Skips any currently playing cutscene.")
            FEATURES_SELF_SKIP_CUTSCENE()
        ENDIF
        IF MENU_BUTTON("Remove Black Screen", "Remove black screen.")
            FEATURES_SELF_REMOVE_BLACK_SCREEN()
        ENDIF
        IF MENU_BUTTON("Refresh Interior", "Refresh the current interior you are inside.")
            FEATURES_SELF_REFRESH_INTERIOR()
        ENDIF
        IF MENU_CHECKBOX("Godmode", g_sFeatures.sSelfFeatures.bGodMode, "Blocks all incoming damage.")
            IF NOT g_sFeatures.sSelfFeatures.bGodMode
                FEATURES_SELF_GODMODE(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Invisibility", g_sFeatures.sSelfFeatures.bInvisibility, "Makes you invisible.")
            IF NOT g_sFeatures.sSelfFeatures.bInvisibility
                FEATURES_SELF_INVISIBILITY(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("No Clip", g_sFeatures.sSelfFeatures.bNoClip, "Fly through the map.")
        IF MENU_CHECKBOX("No Ragdoll", g_sFeatures.sSelfFeatures.bNoRagdoll, "Prevents you from ragdolling.")
            IF NOT g_sFeatures.sSelfFeatures.bNoRagdoll
                FEATURES_SELF_NO_RAGDOLL(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Fast Run", g_sFeatures.sSelfFeatures.bFastRun, "Run faster than normal.")
            IF NOT g_sFeatures.sSelfFeatures.bFastRun
                FEATURES_SELF_FAST_RUN(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Fast Swim", g_sFeatures.sSelfFeatures.bFastSwim, "Swim faster than normal.")
            IF NOT g_sFeatures.sSelfFeatures.bFastSwim
                FEATURES_SELF_FAST_SWIM(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("Super Jump", g_sFeatures.sSelfFeatures.bSuperJump, "Jump higher than normal.")
        IF MENU_CHECKBOX("Unlimited Oxygen", g_sFeatures.sSelfFeatures.bUnlimitedOxygen, "Stay underwater without losing oxygen.")
            IF NOT g_sFeatures.sSelfFeatures.bUnlimitedOxygen
                FEATURES_SELF_UNLIMITED_OXYGEN(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("Unlimited Ability", g_sFeatures.sSelfFeatures.bUnlimitedAbility, "Special ability bar never runs out.")
    ENDIF
	
    SUBMENUS_DRAW_SELF_WANTED_LEVEL()
ENDPROC
