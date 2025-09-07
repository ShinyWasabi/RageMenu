USING "core_menu.sch"

TYPEDEF PROC CleanupFunc()
CleanupFunc fpCleanupFunc

STRUCT STAT_EDITOR_DATA
    INT iStatType
    STRING sStatTypeNames[4]
    TEXT_LABEL_63 tlStatName
    INT iIntValue
    FLOAT fFloatValue
    BOOL bBoolValue
    TEXT_LABEL_63 tlStringValue
ENDSTRUCT

STRUCT PACKED_STAT_EDITOR_DATA
    INT iPackedStatType
    STRING sPackedStatTypeNames[2]
    INT iPackedStatIndex
    INT iPackedIntValue
    BOOL bPackedBoolValue
ENDSTRUCT
#IF IS_RELEASE_SCOL_BUILD
STRUCT SCRIPT_STATICS_DATA
    INT iStaticType
    INT iStaticIndex
    INT iLabelSize
    STRING sStaticTypeNames[5]
    TEXT_LABEL_63 tlScriptName
    INT iIntValue
    FLOAT fFloatValue
    TEXT_LABEL_63 tlStringAndLabelValue
    VECTOR vVectorValue
ENDSTRUCT

STRUCT SCRIPT_GLOBALS_DATA
    INT iGlobalType
    INT iGlobalIndex
    INT iLabelSize
    STRING sGlobalTypeNames[4]
    INT iIntValue
    FLOAT fFloatValue
    TEXT_LABEL_63 tlLabelValue
    VECTOR vVectorValue
ENDSTRUCT
#ENDIF
STAT_EDITOR_DATA sStatEditorData
PACKED_STAT_EDITOR_DATA sPackedStatEditorData
#IF IS_RELEASE_SCOL_BUILD
SCRIPT_STATICS_DATA sScriptStaticsData
SCRIPT_GLOBALS_DATA sScriptGlobalsData
#ENDIF

PROC INIT_STAT_EDITOR_DATA()	
    sStatEditorData.sStatTypeNames[0] = "INT"
    sStatEditorData.sStatTypeNames[1] = "FLOAT"
    sStatEditorData.sStatTypeNames[2] = "BOOL"
    sStatEditorData.sStatTypeNames[3] = "STRING"
ENDPROC

PROC INIT_PACKED_STAT_EDITOR_DATA()	
    sPackedStatEditorData.sPackedStatTypeNames[0] = "INT"
    sPackedStatEditorData.sPackedStatTypeNames[1] = "BOOL"
ENDPROC

#IF IS_RELEASE_SCOL_BUILD
PROC INIT_SCRIPT_STATICS_DATA()
    sScriptStaticsData.sStaticTypeNames[0] = "INT"
    sScriptStaticsData.sStaticTypeNames[1] = "FLOAT"
    sScriptStaticsData.sStaticTypeNames[2] = "STRING"
    sScriptStaticsData.sStaticTypeNames[3] = "TEXT LABEL"
    sScriptStaticsData.sStaticTypeNames[4] = "VECTOR"
ENDPROC

PROC INIT_SCRIPT_GLOBALS_DATA()
    sScriptGlobalsData.sGlobalTypeNames[0] = "INT"
    sScriptGlobalsData.sGlobalTypeNames[1] = "FLOAT"
    sScriptGlobalsData.sGlobalTypeNames[2] = "TEXT LABEL"
    sScriptGlobalsData.sGlobalTypeNames[3] = "VECTOR"
ENDPROC
#ENDIF

PROC SUBMENUS_DRAW_DEBUG_STAT_EDITOR()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG_STAT_EDITOR)
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

#IF IS_RELEASE_SCOL_BUILD
PROC SUBMENUS_DRAW_DEBUG_SCRIPT_STATICS()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG_SCRIPT_STATICS)
        MENU_KEYBOARD_STRING("Script Name", sScriptStaticsData.tlScriptName, "Enter script name.")
        MENU_KEYBOARD_INTEGER("Index", sScriptStaticsData.iStaticIndex, "Enter static index.")
        IF MENU_SLIDER_STRING("Type", sScriptStaticsData.sStaticTypeNames, sScriptStaticsData.iStaticType, "Select static type.")
            sScriptStaticsData.iIntValue = 0
            sScriptStaticsData.fFloatValue = 0.0
            sScriptStaticsData.tlStringAndLabelValue = ""
            sScriptStaticsData.vVectorValue = <<0.0, 0.0, 0.0>>
        ENDIF
        IF sScriptStaticsData.iStaticType = 0
            MENU_KEYBOARD_INTEGER("Value", sScriptStaticsData.iIntValue, "Enter static value.")
        ELIF sScriptStaticsData.iStaticType = 1
            MENU_KEYBOARD_FLOAT("Value", sScriptStaticsData.fFloatValue, "Enter static value.")
        ELIF sScriptStaticsData.iStaticType = 2
            MENU_KEYBOARD_STRING("Value", sScriptStaticsData.tlStringAndLabelValue, "Enter static value.")
        ELIF sScriptStaticsData.iStaticType = 3
            MENU_KEYBOARD_STRING("Value", sScriptStaticsData.tlStringAndLabelValue, "Enter static value.")
            MENU_KEYBOARD_INTEGER("Size", sScriptStaticsData.iLabelSize, "Enter text label size.")
        ELIF sScriptStaticsData.iStaticType = 4
            MENU_KEYBOARD_FLOAT("Value X", sScriptStaticsData.vVectorValue.x, "Enter static value.")
            MENU_KEYBOARD_FLOAT("Value Y", sScriptStaticsData.vVectorValue.y, "Enter static value.")
            MENU_KEYBOARD_FLOAT("Value Z", sScriptStaticsData.vVectorValue.z, "Enter static value.")
        ENDIF
        IF MENU_BUTTON("Write Value", "Write the new value to static.")
            INT iScriptHash = GET_HASH_KEY(sScriptStaticsData.tlScriptName)
            SWITCH sScriptStaticsData.iStaticType
                CASE 0
                    SCRIPT_STATIC_SET_INT(iScriptHash, sScriptStaticsData.iStaticIndex, sScriptStaticsData.iIntValue)
                BREAK
                CASE 1
                    SCRIPT_STATIC_SET_FLOAT(iScriptHash, sScriptStaticsData.iStaticIndex, sScriptStaticsData.fFloatValue)
                BREAK
                CASE 2
                    SCRIPT_STATIC_SET_STRING(iScriptHash, sScriptStaticsData.iStaticIndex, sScriptStaticsData.tlStringAndLabelValue)
                BREAK
                CASE 3
                    SCRIPT_STATIC_SET_TEXT_LABEL(iScriptHash, sScriptStaticsData.iStaticIndex, sScriptStaticsData.tlStringAndLabelValue, sScriptStaticsData.iLabelSize)
                BREAK
                CASE 4
                    SCRIPT_STATIC_SET_VECTOR(iScriptHash, sScriptStaticsData.iStaticIndex, sScriptStaticsData.vVectorValue)
                BREAK
            ENDSWITCH
        ENDIF
        IF MENU_BUTTON("Read Value", "Read the current static value.")
            INT iScriptHash = GET_HASH_KEY(sScriptStaticsData.tlScriptName)
            SWITCH sScriptStaticsData.iStaticType
                CASE 0
                    sScriptStaticsData.iIntValue = SCRIPT_STATIC_GET_INT(iScriptHash, sScriptStaticsData.iStaticIndex)
                BREAK
                CASE 1
                    sScriptStaticsData.fFloatValue = SCRIPT_STATIC_GET_FLOAT(iScriptHash, sScriptStaticsData.iStaticIndex)
                BREAK
                CASE 2
                    sScriptStaticsData.tlStringAndLabelValue = SCRIPT_STATIC_GET_STRING(iScriptHash, sScriptStaticsData.iStaticIndex)
                BREAK
                CASE 3
                    sScriptStaticsData.tlStringAndLabelValue = SCRIPT_STATIC_GET_TEXT_LABEL(iScriptHash, sScriptStaticsData.iStaticIndex)
                BREAK
                CASE 4
                    sScriptStaticsData.vVectorValue = SCRIPT_STATIC_GET_VECTOR(iScriptHash, sScriptStaticsData.iStaticIndex)
                BREAK
            ENDSWITCH
        ENDIF
    ENDIF
ENDPROC

PROC SUBMENUS_DRAW_DEBUG_SCRIPT_GLOBALS()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG_SCRIPT_GLOBALS)
        MENU_KEYBOARD_INTEGER("Index", sScriptGlobalsData.iGlobalIndex, "Enter global index.")
        IF MENU_SLIDER_STRING("Type", sScriptGlobalsData.sGlobalTypeNames, sScriptGlobalsData.iGlobalType, "Select global type.")
            sScriptGlobalsData.iIntValue = 0
            sScriptGlobalsData.fFloatValue = 0.0
            sScriptGlobalsData.tlLabelValue = ""
            sScriptGlobalsData.vVectorValue = <<0.0, 0.0, 0.0>>
        ENDIF
        IF sScriptGlobalsData.iGlobalType = 0
            MENU_KEYBOARD_INTEGER("Value", sScriptGlobalsData.iIntValue, "Enter global value.")
        ELIF sScriptGlobalsData.iGlobalType = 1
            MENU_KEYBOARD_FLOAT("Value", sScriptGlobalsData.fFloatValue, "Enter global value.")
        ELIF sScriptGlobalsData.iGlobalType = 2
            MENU_KEYBOARD_STRING("Value", sScriptGlobalsData.tlLabelValue, "Enter global value.")
            MENU_KEYBOARD_INTEGER("Size", sScriptGlobalsData.iLabelSize, "Enter text label size.")
        ELIF sScriptGlobalsData.iGlobalType = 3
            MENU_KEYBOARD_FLOAT("Value X", sScriptGlobalsData.vVectorValue.x, "Enter global value.")
            MENU_KEYBOARD_FLOAT("Value Y", sScriptGlobalsData.vVectorValue.y, "Enter global value.")
            MENU_KEYBOARD_FLOAT("Value Z", sScriptGlobalsData.vVectorValue.z, "Enter global value.")
        ENDIF
        IF MENU_BUTTON("Write Value", "Write the new value to global.")
            SWITCH sScriptGlobalsData.iGlobalType
                CASE 0
                    SCRIPT_GLOBAL_SET_INT(sScriptGlobalsData.iGlobalIndex, sScriptGlobalsData.iIntValue)
                BREAK
                CASE 1
                    SCRIPT_GLOBAL_SET_FLOAT(sScriptGlobalsData.iGlobalIndex, sScriptGlobalsData.fFloatValue)
                BREAK
                CASE 2
                    SCRIPT_GLOBAL_SET_TEXT_LABEL(sScriptGlobalsData.iGlobalIndex, sScriptGlobalsData.tlLabelValue, sScriptGlobalsData.iLabelSize)
                BREAK
                CASE 3
                    SCRIPT_GLOBAL_SET_VECTOR(sScriptGlobalsData.iGlobalIndex, sScriptGlobalsData.vVectorValue)
                BREAK
            ENDSWITCH
        ENDIF
        IF MENU_BUTTON("Read Value", "Read the current global value.")
            SWITCH sScriptGlobalsData.iGlobalType
                CASE 0
                    sScriptGlobalsData.iIntValue = SCRIPT_GLOBAL_GET_INT(sScriptGlobalsData.iGlobalIndex)
                BREAK
                CASE 1
                    sScriptGlobalsData.fFloatValue = SCRIPT_GLOBAL_GET_FLOAT(sScriptGlobalsData.iGlobalIndex)
                BREAK
                CASE 2
                    sScriptGlobalsData.tlLabelValue = SCRIPT_GLOBAL_GET_TEXT_LABEL(sScriptGlobalsData.iGlobalIndex)
                BREAK
                CASE 3
                    sScriptGlobalsData.vVectorValue = SCRIPT_GLOBAL_GET_VECTOR(sScriptGlobalsData.iGlobalIndex)
                BREAK
            ENDSWITCH
        ENDIF
    ENDIF
ENDPROC
#ENDIF

PROC SUBMENUS_DRAW_DEBUG()
    IF MENU_BEGIN_SUBMENU(SUBMENUS_DEBUG)
        MENU_SUBMENU_BUTTON("Stat Editor", SUBMENUS_DEBUG_STAT_EDITOR, "Edit integer, float, boolean, and string stats.")
        MENU_SUBMENU_BUTTON("Packed Stat Editor", SUBMENUS_DEBUG_PACKED_STAT_EDITOR, "Edit packed integer and boolean stats.")
        MENU_SUBMENU_BUTTON("Script Threads", SUBMENUS_DEBUG_SCRIPT_THREADS, "View currently active script threads.")
#IF IS_RELEASE_SCOL_BUILD
        MENU_SUBMENU_BUTTON("Script Statics", SUBMENUS_DEBUG_SCRIPT_STATICS, "Edit script statics.")
        MENU_SUBMENU_BUTTON("Script Globals", SUBMENUS_DEBUG_SCRIPT_GLOBALS, "Edit script globals.")
#ENDIF
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
#IF IS_RELEASE_SCOL_BUILD
    SUBMENUS_DRAW_DEBUG_SCRIPT_STATICS()
    SUBMENUS_DRAW_DEBUG_SCRIPT_GLOBALS()
#ENDIF
ENDPROC
