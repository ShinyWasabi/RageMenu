USING "core_globals.sch"
USING "features_self.sch"
USING "features_vehicle.sch"
USING "features_weapons.sch"
USING "features_teleport.sch"
USING "features_world.sch"

PROC FEATURES_RUN_SELF()
    IF g_sFeatures.sSelfFeatures.bGodMode
        FEATURES_SELF_GODMODE(TRUE)
    ENDIF
    IF g_sFeatures.sSelfFeatures.bInvisibility
        FEATURES_SELF_INVISIBILITY(TRUE)
    ENDIF
    FEATURES_SELF_NO_CLIP(g_sFeatures.sSelfFeatures.bNoClip)
    IF g_sFeatures.sSelfFeatures.bNoRagdoll
        FEATURES_SELF_NO_RAGDOLL(TRUE)
    ENDIF
    IF g_sFeatures.sSelfFeatures.bFastRun
        FEATURES_SELF_FAST_RUN(TRUE)
    ENDIF
    IF g_sFeatures.sSelfFeatures.bFastSwim
        FEATURES_SELF_FAST_SWIM(TRUE)
    ENDIF
    IF g_sFeatures.sSelfFeatures.bSuperJump
        FEATURES_SELF_SUPER_JUMP()
    ENDIF
    IF g_sFeatures.sSelfFeatures.bUnlimitedOxygen
        FEATURES_SELF_UNLIMITED_OXYGEN(TRUE)
    ENDIF
    IF g_sFeatures.sSelfFeatures.bUnlimitedAbility
        FEATURES_SELF_UNLIMITED_ABILITY()
    ENDIF
    IF g_sFeatures.sSelfFeatures.bNeverWanted
        FEATURES_SELF_NEVER_WANTED(TRUE)
    ENDIF
ENDPROC

PROC FEATURES_RUN_VEHICLE()
    IF g_sFeatures.sVehicleFeatures.bGodMode
        FEATURES_VEHICLE_GODMODE(TRUE)
    ENDIF
    IF g_sFeatures.sVehicleFeatures.bSeatbelt
        FEATURES_VEHICLE_SEATBELT(TRUE)
    ENDIF
    IF g_sFeatures.sVehicleFeatures.bAlwaysRepaired
        FEATURES_VEHICLE_REPAIR()
    ENDIF
    IF g_sFeatures.sVehicleFeatures.bHornBoost
        FEATURES_VEHICLE_HORN_BOOST()
    ENDIF
    IF g_sFeatures.sVehicleFeatures.bSpeedoMeter
        FEATURES_VEHICLE_SPEEDO_METER()
    ENDIF
ENDPROC

PROC FEATURES_RUN_WEAPONS()
    IF g_sFeatures.sWeaponsFeatures.bInfiniteAmmo
        FEATURES_WEAPONS_INFINITE_AMMO(TRUE)
    ENDIF
    IF g_sFeatures.sWeaponsFeatures.bInfiniteClip
        FEATURES_WEAPONS_INFINITE_CLIP(TRUE)
    ENDIF
    IF g_sFeatures.sWeaponsFeatures.bExplosiveAmmo
        FEATURES_WEAPONS_EXPLOSIVE_AMMO()
    ENDIF
    IF g_sFeatures.sWeaponsFeatures.bExplosiveMelee
        FEATURES_WEAPONS_EXPLOSIVE_MELEE()
    ENDIF
    IF g_sFeatures.sWeaponsFeatures.bFireAmmo
        FEATURES_WEAPONS_FIRE_AMMO()
    ENDIF
ENDPROC

PROC FEATURES_RUN_TELEPORT()
    IF g_sFeatures.sTeleportFeatures.bAutoTpToWaypoint
        FEATURES_TELEPORT_TELEPORT_TO_WAYPOINT()
    ENDIF
ENDPROC

PROC FEATURES_RUN_WORLD()
    IF g_sFeatures.sWorldFeatures.bBlackout
        FEATURES_WORLD_BLACKOUT(TRUE)
    ENDIF
    IF g_sFeatures.sWorldFeatures.bNightVision
        FEATURES_WORLD_NIGHT_VISION(TRUE)
    ENDIF
    IF g_sFeatures.sWorldFeatures.bThermalVision
        FEATURES_WORLD_THERMAL_VISION(TRUE)
    ENDIF
    IF g_sFeatures.sWorldFeatures.bRiotMode
        FEATURES_WORLD_RIOT_MODE(TRUE)
    ENDIF
    IF g_sFeatures.sWorldFeatures.bPauseTime
        FEATURES_WORLD_PAUSE_TIME(TRUE)
    ENDIF
ENDPROC

PROC FEATURES_RUN_MAIN()
    FEATURES_RUN_SELF()
    FEATURES_RUN_VEHICLE()
    FEATURES_RUN_WEAPONS()
    FEATURES_RUN_TELEPORT()
    FEATURES_RUN_WORLD()
ENDPROC
