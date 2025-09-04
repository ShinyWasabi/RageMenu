CONST_INT   INT_MIN     -2147483647
CONST_INT   INT_MAX      2147483647
CONST_FLOAT FLOAT_MIN   -2147483647.0
CONST_FLOAT FLOAT_MAX    2147483647.0
CONST_FLOAT TOOLTIP_POS  0.880

FUNC FLOAT MATH_GET_STRING_WIDTH(STRING sString)
    BEGIN_TEXT_COMMAND_GET_SCREEN_WIDTH_OF_DISPLAY_TEXT("STRING")
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(sString)
    RETURN END_TEXT_COMMAND_GET_SCREEN_WIDTH_OF_DISPLAY_TEXT(TRUE)
ENDFUNC

FUNC FLOAT MATH_GET_INTEGER_WIDTH(INT iNumber)
    BEGIN_TEXT_COMMAND_GET_SCREEN_WIDTH_OF_DISPLAY_TEXT("NUMBER")
    ADD_TEXT_COMPONENT_INTEGER(iNumber)
    RETURN END_TEXT_COMMAND_GET_SCREEN_WIDTH_OF_DISPLAY_TEXT(TRUE)
ENDFUNC

FUNC FLOAT MATH_GET_FLOAT_WIDTH(FLOAT fNumber)
    BEGIN_TEXT_COMMAND_GET_SCREEN_WIDTH_OF_DISPLAY_TEXT("NUMBER")
    ADD_TEXT_COMPONENT_FLOAT(fNumber, 4)
    RETURN END_TEXT_COMMAND_GET_SCREEN_WIDTH_OF_DISPLAY_TEXT(TRUE)
ENDFUNC

FUNC INT MATH_GET_NUM_LINES_TOOLTIP(STRING sString)
    BEGIN_TEXT_COMMAND_GET_NUMBER_OF_LINES_FOR_STRING("STRING")
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(sString)
    RETURN END_TEXT_COMMAND_GET_NUMBER_OF_LINES_FOR_STRING((TOOLTIP_POS / (TOOLTIP_POS * 2.0)) - 0.1, 0.544 * 0.5)
ENDFUNC

FUNC INT MATH_CLAMP_INTEGER(INT iValue, INT iMin, INT iMax)
    IF iValue > iMax
        RETURN iMax
    ELIF iValue < iMin
        RETURN iMin
    ENDIF
    RETURN iValue
ENDFUNC

FUNC FLOAT MATH_CLAMP_FLOAT(FLOAT fValue, FLOAT fMin, FLOAT fMax)
    IF fValue > fMax
        RETURN fMax
    ELIF fValue < fMin
        RETURN fMin
    ENDIF
    RETURN fValue
ENDFUNC

FUNC BOOL MATH_STRING_TO_FLOAT(STRING sString, FLOAT &fResult)
    IF IS_STRING_NULL_OR_EMPTY(sString)
        RETURN FALSE
    ENDIF

    INT iLength = GET_LENGTH_OF_LITERAL_STRING(sString)
    BOOL bNegative = FALSE
    BOOL bAfterDecimal = FALSE
    INT iDecimalCount = 0
    fResult = 0.0

    INT i
    FOR i = 0 TO iLength - 1
        STRING sChar = GET_CHARACTER_FROM_AUDIO_CONVERSATION_FILENAME(sString, i, i + 1)
        INT iCharAsInt = -1
        BOOL bIsCharNumber = STRING_TO_INT(sChar, iCharAsInt)

        IF bIsCharNumber
            IF NOT bAfterDecimal
                fResult = fResult * 10.0 + TO_FLOAT(iCharAsInt)
            ELSE
                IF iDecimalCount < 4
                    FLOAT divisor = POW(10.0, TO_FLOAT(iDecimalCount + 1)) // 10, 100, 1000, 10000
                    fResult += TO_FLOAT(iCharAsInt) / divisor
                    iDecimalCount++
                ENDIF
            ENDIF
        ELSE
            BOOL bCharIsMinus = ARE_STRINGS_EQUAL(sChar, "-")
            BOOL bCharIsPoint = ARE_STRINGS_EQUAL(sChar, ".")

            IF bCharIsMinus
                bNegative = TRUE
            ELIF bCharIsPoint
                bAfterDecimal = TRUE
            ELSE
                RETURN FALSE
            ENDIF
        ENDIF
    ENDFOR

    IF bNegative
        fResult *= -1.0
    ENDIF

    RETURN TRUE
ENDFUNC

FUNC STRING MATH_PICK_STRING(BOOL bVal, STRING sTrue, STRING sFalse)
    IF bVal
        RETURN sTrue
    ENDIF
	
    RETURN sFalse
ENDFUNC

FUNC BOOL MATH_IS_VECTOR_ZERO(VECTOR vVector)
    IF vVector.x = 0.0 AND vVector.y = 0.0 AND vVector.z = 0.0
        RETURN TRUE
    ENDIF
    
    RETURN FALSE
ENDFUNC
