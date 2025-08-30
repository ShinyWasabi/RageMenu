CONST_INT GLOBALS_BLOCK_RAGE_MENU 21 // Right after GLOBALS_BLOCK_FMMC_STRUCT_3 (starting from Global_5505024)

GLOBALS GLOBALS_BLOCK_RAGE_MENU

STRUCT FEATURES_SELF
    BOOL bGodMode
    BOOL bInvisibility
    BOOL bNoClip
    BOOL bNoRagdoll
    BOOL bFastRun
    BOOL bFastSwim
    BOOL bSuperJump
    BOOL bUnlimitedOxygen
    BOOL bUnlimitedAbility
    BOOL bNeverWanted
ENDSTRUCT

STRUCT FEATURES_VEHICLE
    BOOL bGodmode
    BOOL bSeatbelt
    BOOL bAlwaysRepaired
    BOOL bHornBoost
    BOOL bSpeedoMeter
ENDSTRUCT

STRUCT FEATURES_WEAPONS
    BOOL bInfiniteAmmo
    BOOL bInfiniteClip
    BOOL bExplosiveAmmo
    BOOL bExplosiveMelee
    BOOL bFireAmmo
ENDSTRUCT

STRUCT FEATURES_TELEPORT
    BOOL bAutoTpToWaypoint
ENDSTRUCT

STRUCT FEATURES_WORLD
    BOOL bBlackout
    BOOL bNightVision
    BOOL bThermalVision
    BOOL bRiotMode
    BOOL bPauseTime
ENDSTRUCT

STRUCT FEATURES
    FEATURES_SELF sSelfFeatures
    FEATURES_VEHICLE sVehicleFeatures
    FEATURES_WEAPONS sWeaponsFeatures
    FEATURES_TELEPORT sTeleportFeatures
    FEATURES_WORLD sWorldFeatures
ENDSTRUCT

FEATURES g_sFeatures

ENDGLOBALS
