----


only definitions FORTH also
vocabulary MSX

FORTH definitions

decimal 3 load ( msxbios )
decimal 4 6 THRU ( def bios )

MSX definitions
decimal 7 23 thru ( impl bios )

decimal
----
----
\ MSXBIOS ( fn -- )
hex
: MSXBIOS ( fn -- )
   create ,
   does> @
   DD c, 21 c, ,       \ LD IX,fn
   FD c, 2A c, FCC0 ,  \ LD IY,[FCC0]
   CD c, 1C ,          \ CALL CASLT
;
----

hex
0041 msxbios (DISSCR)
0044 msxbios (ENASCR)
0047 msxbios (WRTVDP)
004A msxbios (RDVRM)
004D msxbios (WRTVRM)
0050 msxbios (SETRD)
0053 msxbios (SETWRT)
0056 msxbios (FILVRM)
0059 msxbios (LDIRMV)
005C msxbios (LDIRVM)
005F msxbios (CHGMOD)
0062 msxbios (CHGCLR)
0066 msxbios (NMI)
----

hex
0069 msxbios (CLRSPR)
006C msxbios (INITXT)
006F msxbios (INIT32)
0072 msxbios (INIGRP)
0075 msxbios (INIMLT)
0078 msxbios (SETTXT)
007B msxbios (SETT32)
007E msxbios (SETGRP)
0081 msxbios (SETMLT)
0084 msxbios (CALPAT)
0087 msxbios (CALATR)
008A msxbios (GSPSIZ)
008D msxbios (GRPPRT)
----

hex
0132 msxbios (CHGCAP)
009F msxbios (CHGET)
----
\ DISSCR ( -- ), ENASCR ( -- )
hex
code DISSCR ( -- )
   B PUSH
   (DISSCR)
   B POP
   next
end-code

code ENASCR ( -- )
   B PUSH
   (ENASCR)
   B POP
   next
end-code
----
\ CHGCLR ( S -- ), #FORCLR, #BAKCLR, #BDRCLR
hex

F3E9 constant #FORCLR
F3EA constant #BAKCLR
F3EB constant #BDRCLR

code CHGCLR ( S -- )
   B PUSH
   (CHGCLR)
   B POP
   next
end-code
----
\ VDPREG! ( n reg -- )
hex

code VDPREG! ( n reg -- )
   H POP   D POP
   B PUSH
   E B MOV ( B=data )
   L C MOV ( C=reg )
   (WRTVDP)
   B POP
   next
end-code
----
\ VRAM@ ( vaddr -- b ), VRAM! ( b vaddr -- )
hex

code VRAM@ ( addr -- n )
   H POP
   (RDVRM)
   0 H MVI   A L MOV   H PUSH
   next
end-code

code VRAM! ( b addr -- )
   H POP
   D POP   E A MOV
   (WRTVRM)
   next
end-code
----
\ VDP@@ ( addr -- ), VDP!! ( addr -- )
hex

code VDP@@ ( addr -- )
   H POP
   (SETRD)
   next
end-code

code VDP!! ( addr -- )
   H POP
   (SETWRT)
   next
end-code
----
\ VRAMFILL ( vaddr len char -- )

code VRAMFILL ( addr len char -- )
   B H MOV   C L MOV   ( IP>HL )
   D POP     B POP     XTHL
   ( stack=IP,DE=char,BC=len,HL=addr )
   E A MOV    \ A=char
   (FILVRM)   \ HL=addr, BC=len
   B POP
   next
end-code
----
\ CHGCAP ( f -- )
hex
code CHGCAP ( f -- )
   H POP   L A MOV   CMA
   B PUSH
   (CHGCAP)
   B POP
   next
end-code
----
\ SETTXT ( -- ), SETT32 ( -- ), SETGRP ( -- ), SETMLT ( -- )
code SETTXT ( -- )
   B PUSH   (SETTXT)   B POP   next
end-code

code SETT32 ( -- )
   B PUSH   (SETT32)   B POP   next
end-code

code SETGRP ( -- )
   B PUSH   (SETGRP)   B POP   next
end-code

code SETMLT ( -- )
   B PUSH   (SETMLT)   B POP   next
end-code
----
\ INITXT ( S -- )
hex
F3B3 constant #TXTNAM   \ SCREEN 0 name table
F3B5 constant #TXTCOL   \ SCREEN 0 color table
F3B7 constant #TXTCGP   \ SCREEN 0 character pattern table
F3B9 constant #TXTATR   \ SCREEN 0 sprite attribute table
F3BB constant #TXTPAT   \ SCREEN 0 sprite pattern table

code INITXT ( S -- )
   B PUSH   (INITXT)   B POP   next
end-code
----
\ INIT32 ( S -- )
hex
F3BD constant #T32NAM   \ SCREEN 1 name table
F3BF constant #T32COL   \ SCREEN 1 color table
F3C1 constant #T32CGP   \ SCREEN 1 character pattern table
F3C3 constant #T32ATR   \ SCREEN 1 sprite attribute table
F3C5 constant #T32PAT   \ SCREEN 1 sprite pattern table

code INIT32 ( S -- )
   B PUSH   (INIT32)   B POP   next
end-code
----
\ INIGRP ( S -- )
hex
F3C7 constant #GRPNAM   \ SCREEN 2 name table
F3C9 constant #GRPCOL   \ SCREEN 2 color table
F3CB constant #GRPCGP   \ SCREEN 2 character pattern table
F3CD constant #GRPATR   \ SCREEN 2 sprite attribute table
F3CF constant #GRPPAT   \ SCREEN 2 sprite pattern table

code INIGRP ( S -- )
   B PUSH   (INIGRP)   B POP   next
end-code
----
\ INIMLT ( S -- )
hex
F3D1 constant #MLTNAM   \ SCREEN 3 name table
F3D3 constant #MLTCOL   \ SCREEN 3 color table 
F3D5 constant #MLTCGP   \ SCREEN 3 character pattern table
F3D7 constant #MLTATR   \ SCREEN 3 sprite attribute table
F3D9 constant #MLTPAT   \ SCREEN 3 sprite pattern table

code INIMLT ( S -- )
   B PUSH   (INIMLT)   B POP   next
end-code
----
\ CHGMOD ( n -- ), NMI ( -- )
hex

code CHGMOD ( n -- )
   H POP   L A MOV
   B PUSH
   (CHGMOD)
   B POP
   next
end-code

code NMI ( -- )
   B PUSH   (NMI)   B POP   next
end-code
----
\ CLRSPR ( -- ), CALPAT ( n -- addr ), CALATR ( n -- addr )
code CLRSPR ( -- )
   B PUSH   (CLRSPR)   B POP   next
end-code

code CALPAT ( n -- addr )
   H POP      L A MOV
   (CALPAT)   H PUSH
   next
end-code

code CALATR ( n -- addr )
   H POP      L A MOV
   (CALATR)   H PUSH
   next
end-code
----
\ >VRAM ( from-addr to-vaddr len -- )

code >VRAM ( from-addr to-vaddr len -- )
   B H MOV   C L MOV   ( IP>HL )
   B POP     D POP     XTHL
   \ LDIRVM: BC=len, DE=vaddr, HL=addr
   (LDIRVM) \ Block transfer RAM->VRAM
   B POP
   next
end-code
----
\ VRAM> ( from-vaddr to-addr len -- )

code VRAM> ( from-vaddr to-addr len -- )
   B H MOV   C L MOV   ( IP>HL )
   B POP     D POP     XTHL
   \ LDIRMV: BC=len, DE=addr, HL=vaddr
   (LDIRMV) \ Block transfer VRAM->RAM
   B POP
   next
end-code
----
\ CHGET ( -- char )

code CHGET ( -- char )
   (CHGET)
   0 H MVI   L A MOV
   H PUSH
   next
end-code
----
