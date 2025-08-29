CONST_INT MAX_ATTEMPTS       300
CONST_FLOAT MAX_GROUND_CHECK 1000.0

PROC UTIL_TELEPORT_LOAD_GROUND_AT_3DCOORD(VECTOR& vLocation)
    FLOAT fGroundZ = vLocation.z
    INT iCurrentAttempts = 0
    BOOL bFoundGround = FALSE
    FLOAT fHeight = 0.0

    WHILE NOT bFoundGround AND iCurrentAttempts < MAX_ATTEMPTS
        bFoundGround = GET_GROUND_Z_FOR_3D_COORD(<<vLocation.x, vLocation.y, MAX_GROUND_CHECK>>, fGroundZ, FALSE, FALSE)
        REQUEST_COLLISION_AT_COORD(vLocation)

        IF iCurrentAttempts % 10 = 0
            vLocation.z += 25.0
        ENDIF

        ++iCurrentAttempts

        WAIT(0)
    ENDWHILE

    IF NOT bFoundGround
        EXIT
    ENDIF

    IF GET_WATER_HEIGHT(vLocation, fHeight)
        vLocation.z = fHeight
    ELSE
        vLocation.z = fGroundZ + 1.0
    ENDIF
ENDPROC
