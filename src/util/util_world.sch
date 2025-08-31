TYPEDEF FUNC STRING GetIPLNameByIndex(INT iIndex)

STRUCT IPL_SET_DATA
    STRING sIPLSetNames[10]
    BOOL bInitialized
    INT iCurrentIPLSetIndex
    GetIPLNameByIndex fpGetIPLNameByIndex
ENDSTRUCT

IPL_SET_DATA sIPLSetData

PROC UTIL_WORLD_ENABLE_SNOW(BOOL bEnabled)
    IF bEnabled
        INT iTimeOut = 0
        WHILE NOT REQUEST_SCRIPT_AUDIO_BANK("SNOW_FOOTSTEPS", FALSE, -1) AND NOT HAS_NAMED_PTFX_ASSET_LOADED("core_snow")
            REQUEST_NAMED_PTFX_ASSET("core_snow")
            iTimeOut++
            IF iTimeOut = 30
                EXIT
            ENDIF
            WAIT(0)
        ENDWHILE
        USE_SNOW_FOOT_VFX_WHEN_UNSHELTERED(TRUE)
        USE_SNOW_WHEEL_VFX_WHEN_UNSHELTERED(TRUE)
        FORCE_ALLOW_SNOW_FOOT_VFX_ON_ICE(TRUE)
        FORCE_GROUND_SNOW_PASS(TRUE)
    ELSE
        USE_SNOW_FOOT_VFX_WHEN_UNSHELTERED(FALSE)
        USE_SNOW_WHEEL_VFX_WHEN_UNSHELTERED(FALSE)
        FORCE_ALLOW_SNOW_FOOT_VFX_ON_ICE(FALSE)
        FORCE_GROUND_SNOW_PASS(FALSE)
        REMOVE_NAMED_PTFX_ASSET("core_snow")
        RELEASE_NAMED_SCRIPT_AUDIO_BANK("SNOW_FOOTSTEPS")
    ENDIF
ENDPROC

PROC UTIL_WORLD_LOAD_IPL(STRING sIPLName, BOOL bLoad)
    IF NOT IS_STRING_NULL_OR_EMPTY(sIPLName)
        IF bLoad
            IF NOT IS_IPL_ACTIVE(sIPLName)
                REQUEST_IPL(sIPLName)
            ENDIF
        ELIF IS_IPL_ACTIVE(sIPLName)
            REMOVE_IPL(sIPLName)
        ENDIF
    ENDIF
ENDPROC

FUNC VECTOR UTIL_WORLD_GET_IPL_SET_COORDS(INT iIPLSet)
    SWITCH iIPLSet
        CASE 0 RETURN <<3211.42, -4836.89, 111.81>>
        CASE 1 RETURN <<4915.78, -4907.40, 3.39>>
        CASE 2 RETURN <<-2045.8, -1031.2, 11.9>>
        CASE 3 RETURN <<3069.33, -4632.4, 15.04>>
        CASE 4 RETURN <<-162.89, -2365.76, 0.0>>
        CASE 5 RETURN <<297.84, -584.41, 43.26>>
        CASE 6 RETURN <<2471.49, 4954.18, 45.12>>
        CASE 7 RETURN <<-1082.77, -258.67, 37.76>>
        CASE 8 RETURN <<-630.4, -236.7, 40.0>>
        CASE 9 RETURN <<244.9, -1374.7, 39.5>>
    ENDSWITCH

    RETURN <<0, 0, 0>>
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_PROLOGUE_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN  "prologue01"
        CASE 1 RETURN  "prologue01c"
        CASE 2 RETURN  "prologue01d"
        CASE 3 RETURN  "prologue01e"
        CASE 4 RETURN  "prologue01f"
        CASE 5 RETURN  "prologue01g"
        CASE 6 RETURN  "prologue01h"
        CASE 7 RETURN  "prologue01i"
        CASE 8 RETURN  "prologue01j"
        CASE 9 RETURN  "prologue01k"
        CASE 10 RETURN "prologue01z"
        CASE 11 RETURN "prologue02"
        CASE 12 RETURN "prologue03"
        CASE 13 RETURN "prologue03_grv_cov"
        CASE 14 RETURN "prologue03_grv_dug"
        CASE 15 RETURN "prologue03_grv_fun"
        CASE 16 RETURN "prologue03b"
        CASE 17 RETURN "prologue_grv_torch"
        CASE 18 RETURN "des_protree_end"
        CASE 19 RETURN "des_protree_start"
        CASE 20 RETURN "prologue04"
        CASE 21 RETURN "prologue04_cover"
        CASE 22 RETURN "prologue04b"
        CASE 23 RETURN "prologue05"
        CASE 24 RETURN "prologue05b"
        CASE 25 RETURN "prologue06"
        CASE 26 RETURN "prologue06_int"
        CASE 27 RETURN "prologue06_pannel"
        CASE 28 RETURN "prologue06b"
        CASE 29 RETURN "prologue_m2_door"
        CASE 30 RETURN "prologue_occl"
        CASE 31 RETURN "prologuerd"
        CASE 32 RETURN "prologuerdb"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_ISLAND_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN  "h4_mph4_terrain_01_grass_0"
        CASE 1 RETURN  "h4_mph4_terrain_01_grass_1"
        CASE 2 RETURN  "h4_mph4_terrain_02_grass_0"
        CASE 3 RETURN  "h4_mph4_terrain_02_grass_1"
        CASE 4 RETURN  "h4_mph4_terrain_02_grass_2"
        CASE 5 RETURN  "h4_mph4_terrain_02_grass_3"
        CASE 6 RETURN  "h4_mph4_terrain_04_grass_0"
        CASE 7 RETURN  "h4_mph4_terrain_04_grass_1"
        CASE 8 RETURN  "h4_mph4_terrain_05_grass_0"
        CASE 9 RETURN  "h4_mph4_terrain_06_grass_0"
        CASE 10 RETURN "h4_islandx_terrain_01"
        CASE 11 RETURN "h4_islandx_terrain_01_lod"
        CASE 12 RETURN "h4_islandx_terrain_01_slod"
        CASE 13 RETURN "h4_islandx_terrain_02"
        CASE 14 RETURN "h4_islandx_terrain_02_lod"
        CASE 15 RETURN "h4_islandx_terrain_02_slod"
        CASE 16 RETURN "h4_islandx_terrain_03"
        CASE 17 RETURN "h4_islandx_terrain_03_lod"
        CASE 18 RETURN "h4_islandx_terrain_04"
        CASE 19 RETURN "h4_islandx_terrain_04_lod"
        CASE 20 RETURN "h4_islandx_terrain_04_slod"
        CASE 21 RETURN "h4_islandx_terrain_05"
        CASE 22 RETURN "h4_islandx_terrain_05_lod"
        CASE 23 RETURN "h4_islandx_terrain_05_slod"
        CASE 24 RETURN "h4_islandx_terrain_06"
        CASE 25 RETURN "h4_islandx_terrain_06_lod"
        CASE 26 RETURN "h4_islandx_terrain_06_slod"
        CASE 27 RETURN "h4_islandx_terrain_props_05_a"
        CASE 28 RETURN "h4_islandx_terrain_props_05_a_lod"
        CASE 29 RETURN "h4_islandx_terrain_props_05_b"
        CASE 30 RETURN "h4_islandx_terrain_props_05_b_lod"
        CASE 31 RETURN "h4_islandx_terrain_props_05_c"
        CASE 32 RETURN "h4_islandx_terrain_props_05_c_lod"
        CASE 33 RETURN "h4_islandx_terrain_props_05_d"
        CASE 34 RETURN "h4_islandx_terrain_props_05_d_lod"
        CASE 35 RETURN "h4_islandx_terrain_props_05_d_slod"
        CASE 36 RETURN "h4_islandx_terrain_props_05_e"
        CASE 37 RETURN "h4_islandx_terrain_props_05_e_lod"
        CASE 38 RETURN "h4_islandx_terrain_props_05_e_slod"
        CASE 39 RETURN "h4_islandx_terrain_props_05_f"
        CASE 40 RETURN "h4_islandx_terrain_props_05_f_lod"
        CASE 41 RETURN "h4_islandx_terrain_props_05_f_slod"
        CASE 42 RETURN "h4_islandx_terrain_props_06_a"
        CASE 43 RETURN "h4_islandx_terrain_props_06_a_lod"
        CASE 44 RETURN "h4_islandx_terrain_props_06_a_slod"
        CASE 45 RETURN "h4_islandx_terrain_props_06_b"
        CASE 46 RETURN "h4_islandx_terrain_props_06_b_lod"
        CASE 47 RETURN "h4_islandx_terrain_props_06_b_slod"
        CASE 48 RETURN "h4_islandx_terrain_props_06_c"
        CASE 49 RETURN "h4_islandx_terrain_props_06_c_lod"
        CASE 50 RETURN "h4_islandx_terrain_props_06_c_slod"
        CASE 51 RETURN "h4_mph4_terrain_01"
        CASE 52 RETURN "h4_mph4_terrain_01_long_0"
        CASE 53 RETURN "h4_mph4_terrain_02"
        CASE 54 RETURN "h4_mph4_terrain_03"
        CASE 55 RETURN "h4_mph4_terrain_04"
        CASE 56 RETURN "h4_mph4_terrain_05"
        CASE 57 RETURN "h4_mph4_terrain_06"
        CASE 58 RETURN "h4_mph4_terrain_06_strm_0"
        CASE 59 RETURN "h4_mph4_terrain_lod"
        CASE 60 RETURN "h4_mph4_terrain_occ_00"
        CASE 61 RETURN "h4_mph4_terrain_occ_01"
        CASE 62 RETURN "h4_mph4_terrain_occ_02"
        CASE 63 RETURN "h4_mph4_terrain_occ_03"
        CASE 64 RETURN "h4_mph4_terrain_occ_04"
        CASE 65 RETURN "h4_mph4_terrain_occ_05"
        CASE 66 RETURN "h4_mph4_terrain_occ_06"
        CASE 67 RETURN "h4_mph4_terrain_occ_07"
        CASE 68 RETURN "h4_mph4_terrain_occ_08"
        CASE 69 RETURN "h4_mph4_terrain_occ_09"
        CASE 70 RETURN "h4_boatblockers"
        CASE 71 RETURN "h4_islandx"
        CASE 72 RETURN "h4_islandx_disc_strandedshark"
        CASE 73 RETURN "h4_islandx_disc_strandedshark_lod"
        CASE 74 RETURN "h4_islandx_disc_strandedwhale"
        CASE 75 RETURN "h4_islandx_disc_strandedwhale_lod"
        CASE 76 RETURN "h4_islandx_props"
        CASE 77 RETURN "h4_islandx_props_lod"
        CASE 78 RETURN "h4_islandx_sea_mines"
        CASE 79 RETURN "h4_mph4_island"
        CASE 80 RETURN "h4_mph4_island_long_0"
        CASE 81 RETURN "h4_mph4_island_strm_0"
        CASE 82 RETURN "h4_aa_guns"
        CASE 83 RETURN "h4_aa_guns_lod"
        CASE 84 RETURN "h4_beach"
        CASE 85 RETURN "h4_beach_bar_props"
        CASE 86 RETURN "h4_beach_lod"
        CASE 87 RETURN "h4_beach_party"
        CASE 88 RETURN "h4_beach_party_lod"
        CASE 89 RETURN "h4_beach_props"
        CASE 90 RETURN "h4_beach_props_lod"
        CASE 91 RETURN "h4_beach_props_party"
        CASE 92 RETURN "h4_beach_props_slod"
        CASE 93 RETURN "h4_beach_slod"
        CASE 94 RETURN "h4_islandairstrip"
        CASE 95 RETURN "h4_islandairstrip_doorsclosed"
        CASE 96 RETURN "h4_islandairstrip_doorsclosed_lod"
        CASE 97 RETURN "h4_islandairstrip_doorsopen"
        CASE 98 RETURN "h4_islandairstrip_doorsopen_lod"
        CASE 99 RETURN "h4_islandairstrip_hangar_props"
    ENDSWITCH
    SWITCH iIndex
        CASE 100 RETURN "h4_islandairstrip_hangar_props_lod"
        CASE 101 RETURN "h4_islandairstrip_hangar_props_slod"
        CASE 102 RETURN "h4_islandairstrip_lod"
        CASE 103 RETURN "h4_islandairstrip_props"
        CASE 104 RETURN "h4_islandairstrip_propsb"
        CASE 105 RETURN "h4_islandairstrip_propsb_lod"
        CASE 106 RETURN "h4_islandairstrip_propsb_slod"
        CASE 107 RETURN "h4_islandairstrip_props_lod"
        CASE 108 RETURN "h4_islandairstrip_props_slod"
        CASE 109 RETURN "h4_islandairstrip_slod"
        CASE 110 RETURN "h4_islandxcanal_props"
        CASE 111 RETURN "h4_islandxcanal_props_lod"
        CASE 112 RETURN "h4_islandxcanal_props_slod"
        CASE 113 RETURN "h4_islandxdock"
        CASE 114 RETURN "h4_islandxdock_lod"
        CASE 115 RETURN "h4_islandxdock_props"
        CASE 116 RETURN "h4_islandxdock_props_2"
        CASE 117 RETURN "h4_islandxdock_props_2_lod"
        CASE 118 RETURN "h4_islandxdock_props_2_slod"
        CASE 119 RETURN "h4_islandxdock_props_lod"
        CASE 120 RETURN "h4_islandxdock_props_slod"
        CASE 121 RETURN "h4_islandxdock_slod"
        CASE 122 RETURN "h4_islandxdock_water_hatch"
        CASE 123 RETURN "h4_islandxtower"
        CASE 124 RETURN "h4_islandxtower_lod"
        CASE 125 RETURN "h4_islandxtower_slod"
        CASE 126 RETURN "h4_islandxtower_veg"
        CASE 127 RETURN "h4_islandxtower_veg_lod"
        CASE 128 RETURN "h4_islandxtower_veg_slod"
        CASE 129 RETURN "h4_islandx_barrack_hatch"
        CASE 130 RETURN "h4_islandx_barrack_props"
        CASE 131 RETURN "h4_islandx_barrack_props_lod"
        CASE 132 RETURN "h4_islandx_barrack_props_slod"
        CASE 133 RETURN "h4_islandx_checkpoint"
        CASE 134 RETURN "h4_islandx_checkpoint_lod"
        CASE 135 RETURN "h4_islandx_checkpoint_props"
        CASE 136 RETURN "h4_islandx_checkpoint_props_lod"
        CASE 137 RETURN "h4_islandx_checkpoint_props_slod"
        CASE 138 RETURN "h4_islandx_maindock"
        CASE 139 RETURN "h4_islandx_maindock_lod"
        CASE 140 RETURN "h4_islandx_maindock_props"
        CASE 141 RETURN "h4_islandx_maindock_props_2"
        CASE 142 RETURN "h4_islandx_maindock_props_2_lod"
        CASE 143 RETURN "h4_islandx_maindock_props_2_slod"
        CASE 144 RETURN "h4_islandx_maindock_props_lod"
        CASE 145 RETURN "h4_islandx_maindock_props_slod"
        CASE 146 RETURN "h4_islandx_maindock_slod"
        CASE 147 RETURN "h4_islandx_mansion"
        CASE 148 RETURN "h4_islandx_mansion_b"
        CASE 149 RETURN "h4_islandx_mansion_b_lod"
        CASE 150 RETURN "h4_islandx_mansion_b_side_fence"
        CASE 151 RETURN "h4_islandx_mansion_b_slod"
        CASE 152 RETURN "h4_islandx_mansion_entrance_fence"
        CASE 153 RETURN "h4_islandx_mansion_guardfence"
        CASE 154 RETURN "h4_islandx_mansion_lights"
        CASE 155 RETURN "h4_islandx_mansion_lockup_01"
        CASE 156 RETURN "h4_islandx_mansion_lockup_01_lod"
        CASE 157 RETURN "h4_islandx_mansion_lockup_02"
        CASE 158 RETURN "h4_islandx_mansion_lockup_02_lod"
        CASE 159 RETURN "h4_islandx_mansion_lockup_03"
        CASE 160 RETURN "h4_islandx_mansion_lockup_03_lod"
        CASE 161 RETURN "h4_islandx_mansion_lod"
        CASE 162 RETURN "h4_islandx_mansion_office"
        CASE 163 RETURN "h4_islandx_mansion_office_lod"
        CASE 164 RETURN "h4_islandx_mansion_props"
        CASE 165 RETURN "h4_islandx_mansion_props_lod"
        CASE 166 RETURN "h4_islandx_mansion_props_slod"
        CASE 167 RETURN "h4_islandx_mansion_slod"
        CASE 168 RETURN "h4_islandx_mansion_vault"
        CASE 169 RETURN "h4_islandx_mansion_vault_lod"
        CASE 170 RETURN "h4_island_padlock_props"
        CASE 171 RETURN "h4_mansion_gate_closed"
        CASE 172 RETURN "h4_mansion_remains_cage"
        CASE 173 RETURN "h4_mph4_airstrip"
        CASE 174 RETURN "h4_mph4_airstrip_interior_0_airstrip_hanger"
        CASE 175 RETURN "h4_mph4_beach"
        CASE 176 RETURN "h4_mph4_dock"
        CASE 177 RETURN "h4_mph4_island_lod"
        CASE 178 RETURN "h4_mph4_island_ne_placement"
        CASE 179 RETURN "h4_mph4_island_nw_placement"
        CASE 180 RETURN "h4_mph4_island_se_placement"
        CASE 181 RETURN "h4_mph4_island_sw_placement"
        CASE 182 RETURN "h4_mph4_mansion"
        CASE 183 RETURN "h4_mph4_mansion_b"
        CASE 184 RETURN "h4_mph4_mansion_b_strm_0"
        CASE 185 RETURN "h4_mph4_mansion_strm_0"
        CASE 186 RETURN "h4_mph4_wtowers"
        CASE 187 RETURN "h4_ne_ipl_00"
        CASE 188 RETURN "h4_ne_ipl_00_lod"
        CASE 189 RETURN "h4_ne_ipl_00_slod"
        CASE 190 RETURN "h4_ne_ipl_01"
        CASE 191 RETURN "h4_ne_ipl_01_lod"
        CASE 192 RETURN "h4_ne_ipl_01_slod"
        CASE 193 RETURN "h4_ne_ipl_02"
        CASE 194 RETURN "h4_ne_ipl_02_lod"
        CASE 195 RETURN "h4_ne_ipl_02_slod"
        CASE 196 RETURN "h4_ne_ipl_03"
        CASE 197 RETURN "h4_ne_ipl_03_lod"
        CASE 198 RETURN "h4_ne_ipl_03_slod"
        CASE 199 RETURN "h4_ne_ipl_04"
    ENDSWITCH
    SWITCH iIndex // Max case count in 192
        CASE 200 RETURN "h4_ne_ipl_04_lod"
        CASE 201 RETURN "h4_ne_ipl_04_slod"
        CASE 202 RETURN "h4_ne_ipl_05"
        CASE 203 RETURN "h4_ne_ipl_05_lod"
        CASE 204 RETURN "h4_ne_ipl_05_slod"
        CASE 205 RETURN "h4_ne_ipl_06"
        CASE 206 RETURN "h4_ne_ipl_06_lod"
        CASE 207 RETURN "h4_ne_ipl_06_slod"
        CASE 208 RETURN "h4_ne_ipl_07"
        CASE 209 RETURN "h4_ne_ipl_07_lod"
        CASE 210 RETURN "h4_ne_ipl_07_slod"
        CASE 211 RETURN "h4_ne_ipl_08"
        CASE 212 RETURN "h4_ne_ipl_08_lod"
        CASE 213 RETURN "h4_ne_ipl_08_slod"
        CASE 214 RETURN "h4_ne_ipl_09"
        CASE 215 RETURN "h4_ne_ipl_09_lod"
        CASE 216 RETURN "h4_ne_ipl_09_slod"
        CASE 217 RETURN "h4_nw_ipl_00"
        CASE 218 RETURN "h4_nw_ipl_00_lod"
        CASE 219 RETURN "h4_nw_ipl_00_slod"
        CASE 220 RETURN "h4_nw_ipl_01"
        CASE 221 RETURN "h4_nw_ipl_01_lod"
        CASE 222 RETURN "h4_nw_ipl_01_slod"
        CASE 223 RETURN "h4_nw_ipl_02"
        CASE 224 RETURN "h4_nw_ipl_02_lod"
        CASE 225 RETURN "h4_nw_ipl_02_slod"
        CASE 226 RETURN "h4_nw_ipl_03"
        CASE 227 RETURN "h4_nw_ipl_03_lod"
        CASE 228 RETURN "h4_nw_ipl_03_slod"
        CASE 229 RETURN "h4_nw_ipl_04"
        CASE 230 RETURN "h4_nw_ipl_04_lod"
        CASE 231 RETURN "h4_nw_ipl_04_slod"
        CASE 232 RETURN "h4_nw_ipl_05"
        CASE 233 RETURN "h4_nw_ipl_05_lod"
        CASE 234 RETURN "h4_nw_ipl_05_slod"
        CASE 235 RETURN "h4_nw_ipl_06"
        CASE 236 RETURN "h4_nw_ipl_06_lod"
        CASE 237 RETURN "h4_nw_ipl_06_slod"
        CASE 238 RETURN "h4_nw_ipl_07"
        CASE 239 RETURN "h4_nw_ipl_07_lod"
        CASE 240 RETURN "h4_nw_ipl_07_slod"
        CASE 241 RETURN "h4_nw_ipl_08"
        CASE 242 RETURN "h4_nw_ipl_08_lod"
        CASE 243 RETURN "h4_nw_ipl_08_slod"
        CASE 244 RETURN "h4_nw_ipl_09"
        CASE 245 RETURN "h4_nw_ipl_09_lod"
        CASE 246 RETURN "h4_nw_ipl_09_slod"
        CASE 247 RETURN "h4_se_ipl_00"
        CASE 248 RETURN "h4_se_ipl_00_lod"
        CASE 249 RETURN "h4_se_ipl_00_slod"
        CASE 250 RETURN "h4_se_ipl_01"
        CASE 251 RETURN "h4_se_ipl_01_lod"
        CASE 252 RETURN "h4_se_ipl_01_slod"
        CASE 253 RETURN "h4_se_ipl_02"
        CASE 254 RETURN "h4_se_ipl_02_lod"
        CASE 255 RETURN "h4_se_ipl_02_slod"
        CASE 256 RETURN "h4_se_ipl_03"
        CASE 257 RETURN "h4_se_ipl_03_lod"
        CASE 258 RETURN "h4_se_ipl_03_slod"
        CASE 259 RETURN "h4_se_ipl_04"
        CASE 260 RETURN "h4_se_ipl_04_lod"
        CASE 261 RETURN "h4_se_ipl_04_slod"
        CASE 262 RETURN "h4_se_ipl_05"
        CASE 263 RETURN "h4_se_ipl_05_lod"
        CASE 264 RETURN "h4_se_ipl_05_slod"
        CASE 265 RETURN "h4_se_ipl_06"
        CASE 266 RETURN "h4_se_ipl_06_lod"
        CASE 267 RETURN "h4_se_ipl_06_slod"
        CASE 268 RETURN "h4_se_ipl_07"
        CASE 269 RETURN "h4_se_ipl_07_lod"
        CASE 270 RETURN "h4_se_ipl_07_slod"
        CASE 271 RETURN "h4_se_ipl_08"
        CASE 272 RETURN "h4_se_ipl_08_lod"
        CASE 273 RETURN "h4_se_ipl_08_slod"
        CASE 274 RETURN "h4_se_ipl_09"
        CASE 275 RETURN "h4_se_ipl_09_lod"
        CASE 276 RETURN "h4_se_ipl_09_slod"
        CASE 277 RETURN "h4_sw_ipl_00"
        CASE 278 RETURN "h4_sw_ipl_00_lod"
        CASE 279 RETURN "h4_sw_ipl_00_slod"
        CASE 280 RETURN "h4_sw_ipl_01"
        CASE 281 RETURN "h4_sw_ipl_01_lod"
        CASE 282 RETURN "h4_sw_ipl_01_slod"
        CASE 283 RETURN "h4_sw_ipl_02"
        CASE 284 RETURN "h4_sw_ipl_02_lod"
        CASE 285 RETURN "h4_sw_ipl_02_slod"
        CASE 286 RETURN "h4_sw_ipl_03"
        CASE 287 RETURN "h4_sw_ipl_03_lod"
        CASE 288 RETURN "h4_sw_ipl_03_slod"
        CASE 289 RETURN "h4_sw_ipl_04"
        CASE 290 RETURN "h4_sw_ipl_04_lod"
        CASE 291 RETURN "h4_sw_ipl_04_slod"
        CASE 292 RETURN "h4_sw_ipl_05"
        CASE 293 RETURN "h4_sw_ipl_05_lod"
        CASE 294 RETURN "h4_sw_ipl_05_slod"
        CASE 295 RETURN "h4_sw_ipl_06"
        CASE 296 RETURN "h4_sw_ipl_06_lod"
        CASE 297 RETURN "h4_sw_ipl_06_slod"
        CASE 298 RETURN "h4_sw_ipl_07"
        CASE 299 RETURN "h4_sw_ipl_07_lod"
        CASE 300 RETURN "h4_sw_ipl_07_slod"
        CASE 301 RETURN "h4_sw_ipl_08"
        CASE 302 RETURN "h4_sw_ipl_08_lod"
        CASE 303 RETURN "h4_sw_ipl_08_slod"
        CASE 304 RETURN "h4_sw_ipl_09"
        CASE 305 RETURN "h4_sw_ipl_09_lod"
        CASE 306 RETURN "h4_sw_ipl_09_slod"
        CASE 307 RETURN "h4_underwater_gate_closed"
        CASE 308 RETURN "h4_islandx_placement_01"
        CASE 309 RETURN "h4_islandx_placement_02"
        CASE 310 RETURN "h4_islandx_placement_03"
        CASE 311 RETURN "h4_islandx_placement_04"
        CASE 312 RETURN "h4_islandx_placement_05"
        CASE 313 RETURN "h4_islandx_placement_06"
        CASE 314 RETURN "h4_islandx_placement_07"
        CASE 315 RETURN "h4_islandx_placement_08"
        CASE 316 RETURN "h4_islandx_placement_09"
        CASE 317 RETURN "h4_islandx_placement_10"
        CASE 318 RETURN "h4_mph4_island_placement"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_SMBOAT_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "smboat"
        CASE 1 RETURN "apa_smboat_lodlights"
        CASE 2 RETURN "ba_sm_boat_window"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_HEI_CARRIER_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "hei_carrier_lodlights"
        CASE 1 RETURN "hei_carrier"
        CASE 2 RETURN "hei_carrier_int1"
        CASE 3 RETURN "hei_carrier_int2"
        CASE 4 RETURN "hei_carrier_int3"
        CASE 5 RETURN "hei_carrier_int4"
        CASE 6 RETURN "hei_carrier_int5"
        CASE 7 RETURN "hei_carrier_int6"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_SUNK_SHIP_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "sunk_ship_fire"
        CASE 1 RETURN "sunkcargoship"
        CASE 2 RETURN "cargoship"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_HOSPITAL_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "rc12b_hospitalinterior"
        CASE 1 RETURN "rc12b_default"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_FARM_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "farm_burnt"
        CASE 1 RETURN "farm_burnt_props"
        CASE 2 RETURN "farm"
        CASE 3 RETURN "farmint"
        CASE 4 RETURN "farmint_cap"
        CASE 5 RETURN "farm_props"
        CASE 6 RETURN "des_farmhs_startimap"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_LOBBY_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "facelobby"
        CASE 1 RETURN "facelobbyfake"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_JEWEL_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "post_hiest_unload"
        CASE 1 RETURN "jewel2fake"
        CASE 2 RETURN "bh1_16_refurb"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC STRING UTIL_WORLD_GET_IPL_NAME_CORONER_BY_INDEX(INT iIndex)
    SWITCH iIndex
        CASE 0 RETURN "coroner_int_on"
        CASE 1 RETURN "coronertrash"
        CASE 3 RETURN "coroner_int_off"
    ENDSWITCH
	
    RETURN ""
ENDFUNC

FUNC BOOL UTIL_WORLD_SHOULD_REMOVE_THIS_IPL_ON_LOAD(INT iIPLHash)
    SWITCH iIPLHash
        CASE HASH("cargoship")
        CASE HASH("rc12b_default")
        CASE HASH("farm")
        CASE HASH("farmint")
        CASE HASH("farmint_cap")
        CASE HASH("farm_props")
        CASE HASH("des_farmhs_startimap")
        CASE HASH("facelobbyfake")
        CASE HASH("jewel2fake")
        CASE HASH("bh1_16_refurb")
        CASE HASH("coroner_int_off")
            RETURN TRUE
        BREAK
    ENDSWITCH
	
    RETURN FALSE
ENDFUNC
