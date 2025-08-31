USING "core_menu.sch"

TYPEDEF PROC CleanupFunc()
CleanupFunc fpCleanupFunc

STRUCT STAT_EDITOR_DATA
    INT iStatType = 0
    STRING sStatTypeNames[4]
    TEXT_LABEL_63 tlStatName
    INT iIntValue
    FLOAT fFloatValue
    BOOL bBoolValue
    TEXT_LABEL_63 tlStringValue
    BOOL bInitialized
ENDSTRUCT

STRUCT PACKED_STAT_EDITOR_DATA
    INT iPackedStatType
    STRING sPackedStatTypeNames[2]
    INT iPackedStatIndex
    INT iPackedIntValue
    BOOL bPackedBoolValue
    BOOL bInitialized
ENDSTRUCT

STAT_EDITOR_DATA sStatEditorData
PACKED_STAT_EDITOR_DATA sPackedStatEditorData

PROC INIT_STAT_EDITOR_DATA()
    IF sStatEditorData.bInitialized
        EXIT
    ENDIF
	
    sStatEditorData.sStatTypeNames[0] = "INT"
    sStatEditorData.sStatTypeNames[1] = "FLOAT"
    sStatEditorData.sStatTypeNames[2] = "BOOL"
    sStatEditorData.sStatTypeNames[3] = "STRING"
	
    sStatEditorData.bInitialized = TRUE
ENDPROC

PROC INIT_PACKED_STAT_EDITOR_DATA()
    IF sPackedStatEditorData.bInitialized
        EXIT
    ENDIF
	
    sPackedStatEditorData.sPackedStatTypeNames[0] = "INT"
    sPackedStatEditorData.sPackedStatTypeNames[1] = "BOOL"
	
    sPackedStatEditorData.bInitialized = TRUE
ENDPROC

PROC SUBMENUS_DRAW_DEBUG_STAT_EDITOR()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG_STAT_EDITOR)
        INIT_STAT_EDITOR_DATA()

        MENU_KEYBOARD_STRING("Stat Name", sStatEditorData.tlStatName, "Enter stat name.", DEFAULT, 31) // Max stat name is 32 characters
        IF MENU_SLIDER_STRING("Type", sStatEditorData.sStatTypeNames, sStatEditorData.iStatType, "Select stat type.")
            sStatEditorData.iIntValue = 0
            sStatEditorData.fFloatValue = 0.0
            sStatEditorData.bBoolValue = FALSE
            sStatEditorData.tlStringValue = ""
        ENDIF
        IF sStatEditorData.iStatType = 0
            MENU_KEYBOARD_INTEGER("Value", sStatEditorData.iIntValue, "Enter stat value.")
        ELIF sStatEditorData.iStatType = 1
            MENU_KEYBOARD_FLOAT("Value", sStatEditorData.fFloatValue, "Enter stat value.")
        ELIF sStatEditorData.iStatType = 2
            MENU_CHECKBOX("Value", sStatEditorData.bBoolValue, "Enter stat value.")
        ELIF sStatEditorData.iStatType = 3
            MENU_KEYBOARD_STRING("Value", sStatEditorData.tlStringValue, "Enter stat value.", DEFAULT, 31)
        ENDIF	
        IF MENU_BUTTON("Write Value", "Write the new value to stat.")
            INT iStat = GET_HASH_KEY(sStatEditorData.tlStatName)
            SWITCH sStatEditorData.iStatType
                CASE 0
                    STAT_SET_INT(iStat, sStatEditorData.iIntValue, TRUE)
                BREAK
                CASE 1
                    STAT_SET_FLOAT(iStat, sStatEditorData.fFloatValue, TRUE)
                BREAK
                CASE 2
                    STAT_SET_BOOL(iStat, sStatEditorData.bBoolValue, TRUE)
                BREAK
                CASE 3
                    STAT_SET_STRING(iStat, sStatEditorData.tlStringValue, TRUE)
                BREAK
            ENDSWITCH
        ENDIF
        IF MENU_BUTTON("Read Value", "Read the current stat value.")
            INT iStat = GET_HASH_KEY(sStatEditorData.tlStatName)
            SWITCH sStatEditorData.iStatType
                CASE 0
                    STAT_GET_INT(iStat, sStatEditorData.iIntValue, -1)
                BREAK
                CASE 1
                    STAT_GET_FLOAT(iStat, sStatEditorData.fFloatValue, -1)
                BREAK
                CASE 2
                    STAT_GET_BOOL(iStat, sStatEditorData.bBoolValue, -1)
                BREAK
                CASE 3
                    sStatEditorData.tlStringValue = STAT_GET_STRING(iStat, -1)
                BREAK
            ENDSWITCH
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_DEBUG_PACKED_STAT_EDITOR()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG_PACKED_STAT_EDITOR)
        INIT_PACKED_STAT_EDITOR_DATA()
	
        MENU_KEYBOARD_INTEGER("Index", sPackedStatEditorData.iPackedStatIndex, "Enter packed stat index.")
        IF MENU_SLIDER_STRING("Type", sPackedStatEditorData.sPackedStatTypeNames, sPackedStatEditorData.iPackedStatType, "Select packed stat type.")
            sPackedStatEditorData.iPackedIntValue = 0
            sPackedStatEditorData.bPackedBoolValue = FALSE
        ENDIF
        IF sPackedStatEditorData.iPackedStatType = 0
            MENU_KEYBOARD_INTEGER("Value", sPackedStatEditorData.iPackedIntValue, "Enter packed stat value.")
        ELIF sPackedStatEditorData.iPackedStatType = 1
            MENU_CHECKBOX("Value", sPackedStatEditorData.bPackedBoolValue, "Enter packed stat value.")
        ENDIF
        IF MENU_BUTTON("Write Value", "Write the new value to packed stat.")
            IF sPackedStatEditorData.iPackedStatType = 0
                SET_PACKED_STAT_INT_CODE(sPackedStatEditorData.iPackedStatIndex, sPackedStatEditorData.iPackedIntValue, -1)
            ELIF sPackedStatEditorData.iPackedStatType = 1
                SET_PACKED_STAT_BOOL_CODE(sPackedStatEditorData.iPackedStatIndex, sPackedStatEditorData.bPackedBoolValue, -1)
            ENDIF
        ENDIF
        IF MENU_BUTTON("Read Value", "Read the current packed stat value.")
            IF sPackedStatEditorData.iPackedStatType = 0
                sPackedStatEditorData.iPackedIntValue = GET_PACKED_STAT_INT_CODE(sPackedStatEditorData.iPackedStatIndex, -1)
            ELIF sPackedStatEditorData.iPackedStatType = 1
                sPackedStatEditorData.bPackedBoolValue = GET_PACKED_STAT_BOOL_CODE(sPackedStatEditorData.iPackedStatIndex, -1)
            ENDIF
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_DEBUG_SCRIPT_THREADS()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG_SCRIPT_THREADS)
        SCRIPT_THREAD_ITERATOR_RESET()
        THREADID tId = SCRIPT_THREAD_ITERATOR_GET_NEXT_THREAD_ID()
        WHILE tId <> NULL
            STRING sScriptName = GET_NAME_OF_SCRIPT_WITH_THIS_ID(tId)
            TEXT_LABEL_63 tlScriptNameWithId = sScriptName
            tlScriptNameWithId += " ("
            tlScriptNameWithId += NATIVE_TO_INT(tId)
            tlScriptNameWithId += ")"
            BOOL isThisThread = GET_HASH_KEY(sScriptName) = GET_HASH_OF_THIS_SCRIPT_NAME()
            IF MENU_BUTTON(tlScriptNameWithId, "Click to kill a script thread.", isThisThread)
                TERMINATE_THREAD(tId)
            ENDIF
            tId = SCRIPT_THREAD_ITERATOR_GET_NEXT_THREAD_ID()
        ENDWHILE
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_DEBUG()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG)
        MENU_SUBMENU_BUTTON("Stat Editor", SUBMENUS_DEBUG_STAT_EDITOR, "Write or read integer, float, boolean, and string stats.")
        MENU_SUBMENU_BUTTON("Packed Stat Editor", SUBMENUS_DEBUG_PACKED_STAT_EDITOR, "Write or read packed integer and boolean stats.")
        MENU_SUBMENU_BUTTON("Script Threads", SUBMENUS_DEBUG_SCRIPT_THREADS, "View currently active script threads.")
        IF MENU_BUTTON("Unload", "Disables all features, frees resources, and terminates the script.")
            CALL fpCleanupFunc()
        ENDIF
        IF MENU_BUTTON("Quit Game", "Quit the game.")
            QUIT_GAME()
        ENDIF
        IF MENU_BUTTON("Restart Game", "Restart the game.")
            RESTART_GAME()
        ENDIF
    ENDIF
	
    SUBMENUS_DRAW_DEBUG_STAT_EDITOR()
    SUBMENUS_DRAW_DEBUG_PACKED_STAT_EDITOR()
    SUBMENUS_DRAW_DEBUG_SCRIPT_THREADS()
ENDPROC
