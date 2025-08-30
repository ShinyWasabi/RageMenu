USING "core_menu.sch"
USING "core_globals.sch"
USING "features_self.sch"

PROC SUBMENUS_DRAW_SELF_WANTED_LEVEL()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_SELF_WANTED_LEVEL)
        IF MENU_BUTTON("Clear Wanted", "Clear your wanted level.", g_sFeatures.sSelfFeatures.bNeverWanted)
            FEATURES_SELF_SET_WANTED_LEVEL(0)
        ENDIF
        INT iWantedLevel = GET_PLAYER_WANTED_LEVEL(PLAYER_ID())
        IF MENU_SLIDER_INTEGER("Wanted Level", iWantedLevel, 0, 5, "Set your wanted level from 0 to 5.", g_sFeatures.sSelfFeatures.bNeverWanted)
            FEATURES_SELF_SET_WANTED_LEVEL(iWantedLevel)
        ENDIF
        IF MENU_CHECKBOX("Never Wanted", g_sFeatures.sSelfFeatures.bNeverWanted, "Prevent your wanted level from ever increasing.")
            IF NOT g_sFeatures.sSelfFeatures.bNeverWanted
                FEATURES_SELF_NEVER_WANTED(FALSE)
            ENDIF
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_SELF()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_SELF)
        MENU_SUBMENU_BUTTON("Wanted Level", SUBMENUS_SELF_WANTED_LEVEL, "Options to control your wanted level.")
        IF MENU_BUTTON("Heal", "Restore your health and armor to full.")
            FEATURES_SELF_HEAL()
        ENDIF
        IF MENU_BUTTON("Suicide", "Kill your character.")
            FEATURES_SELF_SUICIDE()
        ENDIF
        IF MENU_BUTTON("Clear", "Remove all blood, dirt, and damage from your character.")
            FEATURES_SELF_CLEAR()
        ENDIF
        IF MENU_BUTTON("Skip Cutscene", "Skip any cutscene that is currently playing.")
            FEATURES_SELF_SKIP_CUTSCENE()
        ENDIF
        IF MENU_BUTTON("Remove Black Screen", "Remove any black screen.")
            FEATURES_SELF_REMOVE_BLACK_SCREEN()
        ENDIF
        IF MENU_BUTTON("Refresh Interior", "Refresh the interior you are currently inside.")
            FEATURES_SELF_REFRESH_INTERIOR()
        ENDIF
        IF MENU_CHECKBOX("Godmode", g_sFeatures.sSelfFeatures.bGodMode, "Become invincible.")
            IF NOT g_sFeatures.sSelfFeatures.bGodMode
                FEATURES_SELF_GODMODE(FALSE)
            ENDIF
        ENDIF
        IF MENU_CHECKBOX("Invisibility", g_sFeatures.sSelfFeatures.bInvisibility, "Make your character invisible.")
            IF NOT g_sFeatures.sSelfFeatures.bInvisibility
                FEATURES_SELF_INVISIBILITY(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("No Clip", g_sFeatures.sSelfFeatures.bNoClip, "Fly or move through objects freely without collision.")
        IF MENU_CHECKBOX("No Ragdoll", g_sFeatures.sSelfFeatures.bNoRagdoll, "Prevent your character from being knocked down or ragdolling.")
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
        IF MENU_CHECKBOX("Unlimited Oxygen", g_sFeatures.sSelfFeatures.bUnlimitedOxygen, "Stay underwater indefinitely without losing oxygen.")
            IF NOT g_sFeatures.sSelfFeatures.bUnlimitedOxygen
                FEATURES_SELF_UNLIMITED_OXYGEN(FALSE)
            ENDIF
        ENDIF
        MENU_CHECKBOX("Unlimited Ability", g_sFeatures.sSelfFeatures.bUnlimitedAbility, "Special ability bar never runs out.")
    ENDIF
	
    SUBMENUS_DRAW_SELF_WANTED_LEVEL()
ENDPROC
