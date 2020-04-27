; Value macros

percent EQUS "* $ff / 100"

; Constant data (db, dw, dl) macros

dwb: MACRO
	dw \1
	db \2
ENDM

dbw: MACRO
	db \1
	dw \2
ENDM

dbbw: MACRO
	db \1, \2
	dw \3
ENDM

dbww: MACRO
	db \1
	dw \2, \3
ENDM

dbwww: MACRO
	db \1
	dw \2, \3, \4
ENDM

dn: MACRO ; nybbles
rept _NARG / 2
	db ((\1) << 4) | (\2)
	shift 2
endr
ENDM

dc: MACRO ; "crumbs"
rept _NARG / 4
	db ((\1) << 6) | ((\2) << 4) | ((\3) << 2) | (\4)
	shift 4
endr
ENDM

dx: MACRO
x = 8 * ((\1) - 1)
rept \1
	db ((\2) >> x) & $ff
x = x - 8
endr
ENDM

dt: MACRO ; three-byte (big-endian)
	dx 3, \1
ENDM

dd: MACRO ; four-byte (big-endian)
	dx 4, \1
ENDM

bigdw: MACRO ; big-endian word
	dx 2, \1 ; db HIGH(\1), LOW(\1)
ENDM

dba: MACRO ; dbw bank, address
rept _NARG
	dbw BANK(\1), \1
	shift
endr
ENDM

dab: MACRO ; dwb address, bank
rept _NARG
	dwb \1, BANK(\1)
	shift
endr
ENDM

; Reverses FixPicBank in engine/gfx/load_pics.asm
;
; Takes the actual bank of the pic in the ROM and returns the "defined" bank
;     $1f -> $13
;     $20 -> $14
;     $2e -> $1f
;
; Otherwise, the ROM bank will match the defined bank.
dba_pic: MACRO ; dbw bank, address
	db (BANK(\1) == $1f) * ($13 - $1f) \
	 + (BANK(\1) == $20) * ($14 - $20) \
	 + (BANK(\1) == $2e) * ($1f - $2e) \
	 + (BANK(\1))
	dw \1
ENDM

bcd: MACRO
rept _NARG
	dn ((\1) % 100) / 10, (\1) % 10
	shift
endr
ENDM

sine_table: MACRO
; \1: amplitude

x = 0
	rept $20
	; Round up.
	dw (sin(x) + (sin(x) & $ff)) >> 8
x = x + (\1) * $40000
	endr
ENDM
