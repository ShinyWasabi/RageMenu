USING "core_math.sch"

CONST_INT MAX_VIEW_ITEMS  10
CONST_INT MAX_SUBMENUS    20
//CONST_INT MAX_TEXT_LENGHT 25

ENUM SUBMENUS
    SUBMENUS_MAIN,
    SUBMENUS_SELF,
    SUBMENUS_SELF_WANTED_LEVEL,
    SUBMENUS_VEHICLE,
    SUBMENUS_VEHICLE_SPAWN,
    SUBMENUS_VEHICLE_CLASS,
    SUBMENUS_WEAPONS,
    SUBMENUS_WEAPONS_AMMUNATION,
    SUBMENUS_TELEPORT,
    SUBMENUS_TELEPORT_CUSTOM_TELEPORT,
    SUBMENUS_WORLD,
    SUBMENUS_WORLD_WEATHER,
    SUBMENUS_WORLD_TIME,
    SUBMENUS_WORLD_IPL,
    SUBMENUS_WORLD_CUSTOM_IPL
ENDENUM

STRUCT MENU_COLOURS
    RGBA sText
    RGBA sRect
ENDSTRUCT

STRUCT SUBMENU_DATA
    INT iSubMenu
    INT iPos
    INT iView
ENDSTRUCT

STRUCT MENU_DATA
    BOOL bIsOpen
    BOOL bClicked
    BOOL bIncremented
    BOOL bDecremented
    INT iLastInputTime
    INT iCurPos
    INT iCurView
    SUBMENUS eCurMenu
    SUBMENU_DATA sSubMenuData[MAX_SUBMENUS]
    INT iSubMenuDepth = -1
    INT iMaxItems
    INT iCurMenuDef
    INT iCurPosDef
    INT iChangingToMenu = -1
    FLOAT fYValue
    STRING sToolTipText = NULL
ENDSTRUCT

MENU_DATA sMenuData

PROC MENU_INITIALIZE()
    sMenuData.iLastInputTime = GET_GAME_TIMER()
ENDPROC

PROC MENU_UPDATE_VIEW()
    IF sMenuData.iCurPos >= (sMenuData.iCurView + MAX_VIEW_ITEMS)
        sMenuData.iCurView = sMenuData.iCurPos - (MAX_VIEW_ITEMS - 1)
    ELIF sMenuData.iCurPos < sMenuData.iCurView
        sMenuData.iCurView = sMenuData.iCurPos
    ENDIF
ENDPROC

PROC MENU_HANDLE_INPUT()
    INT iCurTime = GET_GAME_TIMER()
    
    IF iCurTime < (sMenuData.iLastInputTime + 150)
        EXIT
    ENDIF
    
    BOOL bMenuJustOpened = IS_DISABLED_CONTROL_JUST_RELEASED(PLAYER_CONTROL, INPUT_FRONTEND_DELETE)
    
    BOOL bBackPressed   = IS_DISABLED_CONTROL_JUST_RELEASED(PLAYER_CONTROL, INPUT_FRONTEND_CANCEL)
    BOOL bEnterPressed  = IS_DISABLED_CONTROL_JUST_RELEASED(PLAYER_CONTROL, INPUT_FRONTEND_ACCEPT)
    BOOL bDownPressed   = IS_DISABLED_CONTROL_PRESSED(PLAYER_CONTROL, INPUT_FRONTEND_DOWN)
    BOOL bUpPressed     = IS_DISABLED_CONTROL_PRESSED(PLAYER_CONTROL, INPUT_FRONTEND_UP)
    BOOL bRightPressed  = IS_DISABLED_CONTROL_PRESSED(PLAYER_CONTROL, INPUT_FRONTEND_RIGHT)
    BOOL bLeftPressed   = IS_DISABLED_CONTROL_PRESSED(PLAYER_CONTROL, INPUT_FRONTEND_LEFT)
    
    IF (NOT GET_IS_LOADING_SCREEN_ACTIVE()) AND (NOT IS_PAUSE_MENU_ACTIVE()) AND
       (NOT bBackPressed) AND (NOT bEnterPressed) AND (NOT bDownPressed) AND (NOT bUpPressed) AND 
       (NOT bRightPressed) AND (NOT bLeftPressed) AND (NOT bMenuJustOpened)
        EXIT
    ENDIF
    
    sMenuData.iLastInputTime = iCurTime
    
    BOOL bIsMenuOpen = sMenuData.bIsOpen
    
    IF bBackPressed AND bIsMenuOpen
        PLAY_SOUND_FRONTEND(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
        
        IF sMenuData.eCurMenu = SUBMENUS_MAIN
            sMenuData.bIsOpen = FALSE
        ENDIF
        IF sMenuData.iSubMenuDepth >= 0
            sMenuData.iCurPos  = sMenuData.sSubMenuData[sMenuData.iSubMenuDepth].iPos
            sMenuData.eCurMenu = INT_TO_ENUM(SUBMENUS, sMenuData.sSubMenuData[sMenuData.iSubMenuDepth].iSubMenu)
            sMenuData.iCurView = sMenuData.sSubMenuData[sMenuData.iSubMenuDepth].iView
            sMenuData.iSubMenuDepth--
        ENDIF
    ELIF bEnterPressed AND bIsMenuOpen
        sMenuData.bClicked = TRUE
    ELIF bUpPressed AND bIsMenuOpen
        PLAY_SOUND_FRONTEND(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
        
        sMenuData.iCurPos--
        IF sMenuData.iCurPos < 0
            sMenuData.iCurPos = sMenuData.iMaxItems - 1
        ENDIF
        MENU_UPDATE_VIEW()
    ELIF bDownPressed AND bIsMenuOpen
        PLAY_SOUND_FRONTEND(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
        
        sMenuData.iCurPos++
        IF sMenuData.iCurPos >= sMenuData.iMaxItems
            sMenuData.iCurPos = 0
        ENDIF
        MENU_UPDATE_VIEW()
    ELIF bRightPressed AND bIsMenuOpen
        sMenuData.bIncremented = TRUE
    ELIF bLeftPressed AND bIsMenuOpen
        sMenuData.bDecremented = TRUE
    ELIF bMenuJustOpened
        PLAY_SOUND_FRONTEND(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
        
        sMenuData.bIsOpen = NOT sMenuData.bIsOpen
    ENDIF
ENDPROC

FUNC BOOL MENU_SHOULD_RENDER()
    IF sMenuData.iCurPosDef < sMenuData.iCurView OR 
       sMenuData.iCurPosDef >= (sMenuData.iCurView + MAX_VIEW_ITEMS)
        RETURN FALSE
    ENDIF
    
    RETURN TRUE
ENDFUNC

FUNC BOOL MENU_IS_FOCUSED()
    IF sMenuData.iCurPos = sMenuData.iCurPosDef
        RETURN TRUE
    ENDIF
    
    RETURN FALSE
ENDFUNC

FUNC BOOL MENU_IS_CLICKED(BOOL bDisabled = FALSE)
    IF MENU_IS_FOCUSED() AND sMenuData.bClicked
        IF bDisabled
            PLAY_SOUND_FRONTEND(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
            RETURN FALSE
        ELSE
            PLAY_SOUND_FRONTEND(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
            RETURN TRUE
        ENDIF
    ENDIF
    
    RETURN FALSE
ENDFUNC

FUNC BOOL MENU_IS_INCREMENTED(BOOL bDisabled = FALSE)
    IF MENU_IS_FOCUSED() AND sMenuData.bIncremented
        IF bDisabled
            PLAY_SOUND_FRONTEND(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
            RETURN FALSE
        ELSE
            PLAY_SOUND_FRONTEND(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
            RETURN TRUE
        ENDIF
    ENDIF
    
    RETURN FALSE
ENDFUNC

FUNC BOOL MENU_IS_DECREMENTED(BOOL bDisabled = FALSE)
    IF MENU_IS_FOCUSED() AND sMenuData.bDecremented
        IF bDisabled
            PLAY_SOUND_FRONTEND(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
            RETURN FALSE
        ELSE
            PLAY_SOUND_FRONTEND(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", TRUE)
            RETURN TRUE
        ENDIF
    ENDIF
    
    RETURN FALSE
ENDFUNC

FUNC STRING MENU_GET_SUBMENU_TITLE(SUBMENUS eSubmenu)
    SWITCH eSubmenu
        CASE SUBMENUS_MAIN                     RETURN "MAIN"
        CASE SUBMENUS_SELF                     RETURN "SELF"
        CASE SUBMENUS_SELF_WANTED_LEVEL        RETURN "WANTED LEVEL"
        CASE SUBMENUS_VEHICLE                  RETURN "VEHICLE"
        CASE SUBMENUS_VEHICLE_SPAWN            RETURN "SPAWN"
        CASE SUBMENUS_VEHICLE_CLASS            RETURN "CLASS"
        CASE SUBMENUS_WEAPONS                  RETURN "WEAPONS"
        CASE SUBMENUS_WEAPONS_AMMUNATION       RETURN "AMMU-NATION"
        CASE SUBMENUS_TELEPORT                 RETURN "TELEPORT"
        CASE SUBMENUS_TELEPORT_CUSTOM_TELEPORT RETURN "CUSTOM TELEPORT"
        CASE SUBMENUS_WORLD                    RETURN "WORLD"
        CASE SUBMENUS_WORLD_WEATHER            RETURN "WEATHER"
        CASE SUBMENUS_WORLD_TIME               RETURN "TIME"
        CASE SUBMENUS_WORLD_IPL                RETURN "IPL"
        CASE SUBMENUS_WORLD_CUSTOM_IPL         RETURN "CUSTOM IPL"
    ENDSWITCH
    
    RETURN ""
ENDFUNC

PROC MENU_GET_COLOURS(MENU_COLOURS& sColours, BOOL bDisabled)
    // Default rect (unfocused)
    sColours.sRect.iRed   = 23
    sColours.sRect.iGreen = 23
    sColours.sRect.iBlue  = 23
    sColours.sRect.iAlpha = 210

    // Default text
    IF bDisabled
        sColours.sText.iRed   = 150
        sColours.sText.iGreen = 150
        sColours.sText.iBlue  = 150
        sColours.sText.iAlpha = 255
    ELSE
        sColours.sText.iRed   = 255
        sColours.sText.iGreen = 255
        sColours.sText.iBlue  = 255
        sColours.sText.iAlpha = 255
    ENDIF

    // Focused override
    IF MENU_IS_FOCUSED()
        sColours.sRect.iRed   = 255
        sColours.sRect.iGreen = 255
        sColours.sRect.iBlue  = 255
        sColours.sRect.iAlpha = 255

        IF NOT bDisabled
            sColours.sText.iRed   = 0
            sColours.sText.iGreen = 0
            sColours.sText.iBlue  = 0
            sColours.sText.iAlpha = 255
        ENDIF
    ENDIF
ENDPROC

PROC MENU_DISABLE_CONTROLS()
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_PHONE, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_NEXT_CAMERA, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_MOUSE_CONTROL_OVERRIDE, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_DRIVE_LOOK, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_DRIVE_LOOK2, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_WEAPON_WHEEL_NEXT, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_WEAPON_WHEEL_PREV, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_SELECT_NEXT_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_SELECT_PREV_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_ATTACK, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_AIM, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_AIM, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_ATTACK, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_ATTACK2, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_PREV_RADIO_TRACK, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_RADIO_WHEEL, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_SELECT_NEXT_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_PASSENGER_ATTACK, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_SELECT_PREV_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_FLY_ATTACK, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_FLY_SELECT_NEXT_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_FLY_ATTACK_CAMERA, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_MELEE_ATTACK_ALTERNATE, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_CURSOR_SCROLL_UP, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_PREV_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_ATTACK2, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_NEXT_WEAPON, TRUE)
    DISABLE_CONTROL_ACTION(FRONTEND_CONTROL, INPUT_VEH_FLY_ATTACK2, TRUE)
ENDPROC

PROC MENU_DRAW_HEADER()
    DRAW_RECT(0.8, sMenuData.fYValue + 0.05, 0.21, 0.100, 0, 150, 255, 255, FALSE)

    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING")
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME("RageMenu")
    
    SET_TEXT_CENTRE(TRUE)
    SET_TEXT_COLOUR(255, 255, 255, 255)
    SET_TEXT_SCALE(1.0, 1.0)
    SET_TEXT_FONT(6)
    SET_TEXT_DROP_SHADOW()
    END_TEXT_COMMAND_DISPLAY_TEXT(0.8, (sMenuData.fYValue + 0.07) - GET_RENDERED_CHARACTER_HEIGHT(1.0, 6), 0)

    sMenuData.fYValue += 0.1
ENDPROC

PROC MENU_DRAW_TITLE()
    DRAW_RECT(0.8, sMenuData.fYValue + 0.005, 0.21, 0.029, 0, 0, 0, 255, FALSE)
    
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING")
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(MENU_GET_SUBMENU_TITLE(sMenuData.eCurMenu))
    
    SET_TEXT_COLOUR(255, 255, 255, 255)
    SET_TEXT_SCALE(0.33, 0.33)
    SET_TEXT_FONT(0)
    
    END_TEXT_COMMAND_DISPLAY_TEXT(0.7, (sMenuData.fYValue + 0.004) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), 0)
    
    TEXT_LABEL tlNumItems = ""
    tlNumItems += sMenuData.iCurPos + 1
    tlNumItems += " / "
    tlNumItems += sMenuData.iMaxItems
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING")
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(tlNumItems)
    
    SET_TEXT_WRAP(0, 0.9)
    SET_TEXT_RIGHT_JUSTIFY(TRUE)
    SET_TEXT_COLOUR(255, 255, 255, 255)
    SET_TEXT_SCALE(0.33, 0.33)
    SET_TEXT_FONT(0)
    
    END_TEXT_COMMAND_DISPLAY_TEXT(0.9, (sMenuData.fYValue + 0.004) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), 0)
    
    sMenuData.fYValue += 0.019
ENDPROC

PROC MENU_DRAW_TOOLTIP()
    IF IS_STRING_NULL_OR_EMPTY(sMenuData.sToolTipText)
        EXIT
    ENDIF

    INT iNumLines     = GET_NUM_LINES_TOOLTIP(sMenuData.sToolTipText)
    FLOAT fLineHeight = GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) * 1.1
    FLOAT fRectHeight = fLineHeight * iNumLines + 0.03
    DRAW_RECT(0.8, sMenuData.fYValue + 0.025 + (fRectHeight / 2) - (0.038 / 2), 0.21, fRectHeight, 23, 23, 23, 210, FALSE)

    SET_TEXT_SCALE(0.33, 0.33)
    SET_TEXT_WRAP(0.0, 0.9)
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING")
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(sMenuData.sToolTipText)
    END_TEXT_COMMAND_DISPLAY_TEXT(0.7, sMenuData.fYValue + 0.013, 0)
ENDPROC

PROC MENU_DRAW_TEXT_STRING(STRING sText, FLOAT fX, FLOAT fY, INT iRed = 255, INT iGreen = 255, INT iBlue = 255, INT iAlpha = 255, BOOL bDrawRight = FALSE)
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("STRING")
    
    /*TEXT_LABEL_63 sToDraw = sText
    INT iLength           = GET_LENGTH_OF_LITERAL_STRING(sText)
    IF iLength >= MAX_TEXT_LENGHT
        sToDraw = GET_CHARACTER_FROM_AUDIO_CONVERSATION_FILENAME(sText, 0, MAX_TEXT_LENGHT - 3)
        sToDraw += "..."
    ENDIF*/
    
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(sText)
    
    IF bDrawRight
        SET_TEXT_WRAP(0, fX)
        SET_TEXT_RIGHT_JUSTIFY(TRUE)
    ENDIF
    
    SET_TEXT_COLOUR(iRed, iGreen, iBlue, iAlpha)
    SET_TEXT_SCALE(0.33, 0.33)
    SET_TEXT_FONT(0)
    
    END_TEXT_COMMAND_DISPLAY_TEXT(fX, fY, 0)
ENDPROC

PROC MENU_DRAW_TEXT_INTEGER(INT iNumber, FLOAT fX, FLOAT fY, INT iRed = 255, INT iGreen = 255, INT iBlue = 255, INT iAlpha = 255, BOOL bDrawRight = FALSE)
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("NUMBER")
    ADD_TEXT_COMPONENT_INTEGER(iNumber)
    
    IF bDrawRight
        SET_TEXT_WRAP(0, fX)
        SET_TEXT_RIGHT_JUSTIFY(TRUE)
    ENDIF
    
    SET_TEXT_COLOUR(iRed, iGreen, iBlue, iAlpha)
    SET_TEXT_SCALE(0.33, 0.33)
    SET_TEXT_FONT(0)
    
    END_TEXT_COMMAND_DISPLAY_TEXT(fX, fY, 0)
ENDPROC

PROC MENU_DRAW_TEXT_FLOAT(FLOAT fNumber, FLOAT fX, FLOAT fY, INT iRed = 255, INT iGreen = 255, INT iBlue = 255, INT iAlpha = 255, BOOL bDrawRight = FALSE)
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT("NUMBER")
    ADD_TEXT_COMPONENT_FLOAT(fNumber, 2)
    
    IF bDrawRight
        SET_TEXT_WRAP(0, fX)
        SET_TEXT_RIGHT_JUSTIFY(TRUE)
    ENDIF
    
    SET_TEXT_COLOUR(iRed, iGreen, iBlue, iAlpha)
    SET_TEXT_SCALE(0.33, 0.33)
    SET_TEXT_FONT(0)
    
    END_TEXT_COMMAND_DISPLAY_TEXT(fX, fY, 0)
ENDPROC

PROC MENU_DRAW_OPTION_STRING(STRING sLeft, STRING sRight = NULL, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    IF NOT MENU_SHOULD_RENDER()
        EXIT
    ENDIF

    MENU_COLOURS sColours
    MENU_GET_COLOURS(sColours, bDisabled)

    DRAW_RECT(0.8, sMenuData.fYValue + 0.019, 0.21, 0.038, sColours.sRect.iRed, sColours.sRect.iGreen, sColours.sRect.iBlue, sColours.sRect.iAlpha, FALSE)

    MENU_DRAW_TEXT_STRING(sLeft, 0.7, (sMenuData.fYValue + 0.019) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha)

    IF NOT IS_STRING_NULL_OR_EMPTY(sRight)
        MENU_DRAW_TEXT_STRING(sRight, 0.9, (sMenuData.fYValue + 0.019) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.725), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
    ENDIF

    IF MENU_IS_FOCUSED()
        sMenuData.sToolTipText = sTooltip
    ENDIF

    sMenuData.fYValue += 0.038
ENDPROC

PROC MENU_DRAW_OPTION_INTEGER(STRING sLeft, INT iRight, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    IF NOT MENU_SHOULD_RENDER()
        EXIT
    ENDIF

    MENU_COLOURS sColours
    MENU_GET_COLOURS(sColours, bDisabled)

    DRAW_RECT(0.8, sMenuData.fYValue + 0.019, 0.21, 0.038, sColours.sRect.iRed, sColours.sRect.iGreen, sColours.sRect.iBlue, sColours.sRect.iAlpha, FALSE)

    MENU_DRAW_TEXT_STRING(sLeft, 0.7, (sMenuData.fYValue + 0.019) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha)

    MENU_DRAW_TEXT_INTEGER(iRight, 0.9, (sMenuData.fYValue + 0.019) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.725), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)

    IF MENU_IS_FOCUSED()
        sMenuData.sToolTipText = sTooltip
    ENDIF

    sMenuData.fYValue += 0.038
ENDPROC

PROC MENU_DRAW_OPTION_FLOAT(STRING sLeft, FLOAT fRight, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    IF NOT MENU_SHOULD_RENDER()
        EXIT
    ENDIF

    MENU_COLOURS sColours
    MENU_GET_COLOURS(sColours, bDisabled)

    DRAW_RECT(0.8, sMenuData.fYValue + 0.019, 0.21, 0.038, sColours.sRect.iRed, sColours.sRect.iGreen, sColours.sRect.iBlue, sColours.sRect.iAlpha, FALSE)

    MENU_DRAW_TEXT_STRING(sLeft, 0.7, (sMenuData.fYValue + 0.019) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha)

    MENU_DRAW_TEXT_FLOAT(fRight, 0.9, (sMenuData.fYValue + 0.019) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.725), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)

    IF MENU_IS_FOCUSED()
        sMenuData.sToolTipText = sTooltip
    ENDIF

    sMenuData.fYValue += 0.038
ENDPROC

PROC MENU_DRAW_SLIDER_STRING(STRING sLeft, STRING sRight, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    IF NOT MENU_SHOULD_RENDER()
        EXIT
    ENDIF

    MENU_COLOURS sColours
    MENU_GET_COLOURS(sColours, bDisabled)

    DRAW_RECT(0.8, sMenuData.fYValue + 0.019, 0.21, 0.038, sColours.sRect.iRed, sColours.sRect.iGreen, sColours.sRect.iBlue, sColours.sRect.iAlpha, FALSE)

    MENU_DRAW_TEXT_STRING(sLeft, 0.7, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha)

    IF MENU_IS_FOCUSED()
        MENU_DRAW_TEXT_STRING("<", 0.892 - GET_STRING_WIDTH(sRight) / 3.4, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        MENU_DRAW_TEXT_STRING(">", 0.9, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        MENU_DRAW_TEXT_STRING(sRight, 0.893, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        
        sMenuData.sToolTipText = sTooltip
    ELSE
        MENU_DRAW_TEXT_STRING(sRight, 0.9, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
    ENDIF

    sMenuData.fYValue += 0.038
ENDPROC

PROC MENU_DRAW_SLIDER_INTEGER(STRING sLeft, INT iRight, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    IF NOT MENU_SHOULD_RENDER()
        EXIT
    ENDIF

    MENU_COLOURS sColours
    MENU_GET_COLOURS(sColours, bDisabled)

    DRAW_RECT(0.8, sMenuData.fYValue + 0.019, 0.21, 0.038, sColours.sRect.iRed, sColours.sRect.iGreen, sColours.sRect.iBlue, sColours.sRect.iAlpha, FALSE)

    MENU_DRAW_TEXT_STRING(sLeft, 0.7, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha)

    IF MENU_IS_FOCUSED()
        MENU_DRAW_TEXT_STRING("<", 0.892 - GET_INTEGER_WIDTH(iRight) / 3.4, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        MENU_DRAW_TEXT_STRING(">", 0.9, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        MENU_DRAW_TEXT_INTEGER(iRight, 0.893, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)

        sMenuData.sToolTipText = sTooltip
    ELSE
        MENU_DRAW_TEXT_INTEGER(iRight, 0.9, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
    ENDIF

    sMenuData.fYValue += 0.038
ENDPROC

PROC MENU_DRAW_SLIDER_FLOAT(STRING sLeft, FLOAT fRight, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    IF NOT MENU_SHOULD_RENDER()
        EXIT
    ENDIF

    MENU_COLOURS sColours
    MENU_GET_COLOURS(sColours, bDisabled)

    DRAW_RECT(0.8, sMenuData.fYValue + 0.019, 0.21, 0.038, sColours.sRect.iRed, sColours.sRect.iGreen, sColours.sRect.iBlue, sColours.sRect.iAlpha, FALSE)

    MENU_DRAW_TEXT_STRING(sLeft, 0.7, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha)

    IF MENU_IS_FOCUSED()
        MENU_DRAW_TEXT_STRING("<", 0.892 - GET_FLOAT_WIDTH(fRight) / 3.4, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        MENU_DRAW_TEXT_STRING(">", 0.9, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
        MENU_DRAW_TEXT_FLOAT(fRight, 0.893, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)

        sMenuData.sToolTipText = sTooltip
    ELSE
        MENU_DRAW_TEXT_FLOAT(fRight, 0.9, (sMenuData.fYValue + 0.018) - (GET_RENDERED_CHARACTER_HEIGHT(0.33, 0) / 1.5), sColours.sText.iRed, sColours.sText.iGreen, sColours.sText.iBlue, sColours.sText.iAlpha, TRUE)
    ENDIF

    sMenuData.fYValue += 0.038
ENDPROC

FUNC BOOL MENU_BEGIN_SUBMENU(SUBMENUS eSubmenu)
    IF sMenuData.eCurMenu = eSubmenu
        RETURN TRUE
    ENDIF

    RETURN FALSE
ENDFUNC

FUNC BOOL MENU_SUBMENU_BUTTON(STRING sText, SUBMENUS eSubmenu, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    BOOL bRetn = FALSE

    MENU_DRAW_OPTION_STRING(sText, ">", sTooltip, bDisabled)
    IF (MENU_IS_CLICKED(bDisabled))
        sMenuData.iChangingToMenu = ENUM_TO_INT(eSubmenu)
        bRetn = TRUE
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_BUTTON(STRING sText, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    BOOL bRetn = FALSE

    MENU_DRAW_OPTION_STRING(sText, DEFAULT, sTooltip, bDisabled)
    IF (MENU_IS_CLICKED(bDisabled))
        bRetn = TRUE
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_CHECKBOX(STRING sText, BOOL& bChecked, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    BOOL bRetn = FALSE

    MENU_DRAW_OPTION_STRING(sText, PICK_STRING(bChecked, "ON", "OFF"), sTooltip, bDisabled)
    IF (MENU_IS_CLICKED(bDisabled))
        bChecked = NOT bChecked
        bRetn = TRUE
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_SLIDER_STRING(STRING sText, STRING& sStrings[], INT& iCurrentItem, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    BOOL bRetn = FALSE

    MENU_DRAW_SLIDER_STRING(sText, sStrings[iCurrentItem], sTooltip, bDisabled)
    IF (MENU_IS_INCREMENTED(bDisabled))
        iCurrentItem++
        IF iCurrentItem > COUNT_OF(sStrings) - 1
            iCurrentItem = 0
        ENDIF
        bRetn = TRUE
    ELIF (MENU_IS_DECREMENTED(bDisabled))
        iCurrentItem--
        IF iCurrentItem < 0
            iCurrentItem = COUNT_OF(sStrings) - 1
        ENDIF
        bRetn = TRUE
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_SLIDER_INTEGER(STRING sText, INT& iValue, INT iMin, INT iMax, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    BOOL bRetn = FALSE

    MENU_DRAW_SLIDER_INTEGER(sText, iValue, sTooltip, bDisabled)
    IF (MENU_IS_INCREMENTED(bDisabled))
        iValue++
        IF iValue > iMax
            iValue = iMin
        ENDIF
        bRetn = TRUE
    ELIF (MENU_IS_DECREMENTED(bDisabled))
        iValue--
        IF iValue < iMin
            iValue = iMax
        ENDIF
        bRetn = TRUE
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_SLIDER_FLOAT(STRING sText, FLOAT& fValue, FLOAT fMin, FLOAT fMax, STRING sTooltip = NULL, BOOL bDisabled = FALSE)
    BOOL bRetn = FALSE

    MENU_DRAW_SLIDER_FLOAT(sText, fValue, sTooltip, bDisabled)
    IF (MENU_IS_INCREMENTED(bDisabled))
        fValue++
        IF fValue > fMax
            fValue = fMin
        ENDIF
        bRetn = TRUE
    ELIF (MENU_IS_DECREMENTED(bDisabled))
        fValue--
        IF fValue < fMin
            fValue = fMax
        ENDIF
        bRetn = TRUE
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_KEYBOARD_STRING(STRING sText, TEXT_LABEL_63& tlString, STRING sTooltip = NULL, BOOL bDisabled = FALSE, INT iLenght = 63) // Can't pass string as reference.
    BOOL bRetn = FALSE

    MENU_DRAW_OPTION_STRING(sText, tlString, sTooltip, bDisabled)
    IF MENU_IS_CLICKED(bDisabled)
        KEYBOARD_STATUS eStatus = EDITING
        DISPLAY_ONSCREEN_KEYBOARD(6, "VEUI_ENTER_TEXT", "", "", "", "", "", iLenght)
        WHILE eStatus = EDITING
            eStatus = UPDATE_ONSCREEN_KEYBOARD()
            WAIT(0)
        ENDWHILE
        IF eStatus = FINISHED
            tlString = GET_ONSCREEN_KEYBOARD_RESULT()
            bRetn = TRUE
        ENDIF
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_KEYBOARD_INTEGER(STRING sText, INT& iValue, STRING sTooltip = NULL, BOOL bDisabled = FALSE, INT iMin = INT_MIN, INT iMax = INT_MAX, INT iLenght = 63)
    BOOL bRetn = FALSE

    MENU_DRAW_OPTION_INTEGER(sText, iValue, sTooltip, bDisabled)
    IF MENU_IS_CLICKED(bDisabled)
        KEYBOARD_STATUS eStatus = EDITING
        DISPLAY_ONSCREEN_KEYBOARD(6, "VEUI_ENTER_TEXT", "", "", "", "", "", iLenght)
        WHILE eStatus = EDITING
            eStatus = UPDATE_ONSCREEN_KEYBOARD()
            WAIT(0)
        ENDWHILE
        IF eStatus = FINISHED
            INT iTemp
            STRING sResult = GET_ONSCREEN_KEYBOARD_RESULT()
            IF STRING_TO_INT(sResult, iTemp)
                iValue = CLAMP_INTEGER(iTemp, iMin, iMax)
                bRetn = TRUE
            ENDIF
        ENDIF
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

FUNC BOOL MENU_KEYBOARD_FLOAT(STRING sText, FLOAT& fValue, STRING sTooltip = NULL, BOOL bDisabled = FALSE, FLOAT fMin = FLOAT_MIN, FLOAT fMax = FLOAT_MAX, INT iLenght = 63)
    BOOL bRetn = FALSE

    MENU_DRAW_OPTION_FLOAT(sText, fValue, sTooltip, bDisabled)
    IF MENU_IS_CLICKED(bDisabled)
        KEYBOARD_STATUS eStatus = EDITING
        DISPLAY_ONSCREEN_KEYBOARD(6, "VEUI_ENTER_TEXT", "", "", "", "", "", iLenght)
        WHILE eStatus = EDITING
            eStatus = UPDATE_ONSCREEN_KEYBOARD()
            WAIT(0)
        ENDWHILE
        IF eStatus = FINISHED
            FLOAT fTemp
            STRING sResult = GET_ONSCREEN_KEYBOARD_RESULT()
            IF STRING_TO_FLOAT(sResult, fTemp)
                fValue = CLAMP_FLOAT(fTemp, fMin, fMax)
                bRetn = TRUE
            ENDIF
        ENDIF
    ENDIF

    sMenuData.iCurPosDef++
    RETURN bRetn
ENDFUNC

PROC MENU_READONLY_STRING(STRING sText, STRING sRight = NULL, STRING sTooltip = NULL)
    MENU_DRAW_OPTION_STRING(sText, sRight, sTooltip)

    sMenuData.iCurPosDef++
ENDPROC

PROC MENU_READONLY_INTEGER(STRING sText, INT iRight, STRING sTooltip = NULL)
    MENU_DRAW_OPTION_INTEGER(sText, iRight, sTooltip)

    sMenuData.iCurPosDef++
ENDPROC

PROC MENU_READONLY_FLOAT(STRING sText, FLOAT fRight, STRING sTooltip = NULL)
    MENU_DRAW_OPTION_FLOAT(sText, fRight, sTooltip)

    sMenuData.iCurPosDef++
ENDPROC

FUNC BOOL MENU_BEGIN()
    sMenuData.iCurMenuDef   = 0
    sMenuData.iCurPosDef    = 0
    sMenuData.fYValue       = 0.1
    sMenuData.bClicked      = FALSE
    sMenuData.bIncremented  = FALSE
    sMenuData.bDecremented  = FALSE

    MENU_HANDLE_INPUT()

    IF sMenuData.bIsOpen
        MENU_DISABLE_CONTROLS()
        MENU_DRAW_HEADER()
        MENU_DRAW_TITLE()
        RETURN TRUE
    ENDIF

    RETURN FALSE
ENDFUNC

PROC MENU_END()
    IF sMenuData.iCurPosDef = 0
        MENU_READONLY_STRING("Empty", DEFAULT, "No options available.")
    ENDIF

    MENU_DRAW_TOOLTIP()

    IF sMenuData.iChangingToMenu <> -1 AND sMenuData.iSubMenuDepth < (MAX_SUBMENUS - 1)
        sMenuData.iSubMenuDepth++
        INT depth = sMenuData.iSubMenuDepth
        sMenuData.sSubMenuData[depth].iPos     = sMenuData.iCurPos
        sMenuData.sSubMenuData[depth].iSubMenu = ENUM_TO_INT(sMenuData.eCurMenu)
        sMenuData.sSubMenuData[depth].iView    = sMenuData.iCurView
        sMenuData.eCurMenu = INT_TO_ENUM(SUBMENUS, sMenuData.iChangingToMenu)
        sMenuData.iCurPos  = 0
        sMenuData.iCurView = 0
    ENDIF

    sMenuData.iChangingToMenu = -1
    sMenuData.iMaxItems       = sMenuData.iCurPosDef
ENDPROC
