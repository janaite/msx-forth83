----

only FORTH also definitions

\ vocabulary MSX
\ MSX also definitions

decimal 3 load ( msxbios )
decimal 4 6 THRU ( def bios )

decimal 7 capacity 1- thru ( impl bios )

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
   CD c, 1C ,          \ CALL CALSLT
   FB c,               \ EI
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
00C6 msxbios (POSIT)
00A2 msxbios (CHPUT)
000C msxbios (RDSLT)
0014 msxbios (WRSLT)
0090 msxbios (GICINI)
0093 msxbios (WRTPSG)
0111 msxbios (MAPXYC)
0120 msxbios (SETC)
00D5 msxbios (GTSTCK)
00D8 msxbios (GTTRIG)
00DB msxbios (GTPAD)
00DE msxbios (GTPDL)
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

: TXTNAM@ ( -- vaddr)  #TXTNAM @ ;
: TXTCOL@ ( -- vaddr)  #TXTCOL @ ;
: TXTCGP@ ( -- vaddr)  #TXTCGP @ ;
: TXTATR@ ( -- vaddr)  #TXTATR @ ;
: TXTPAT@ ( -- vaddr)  #TXTPAT @ ;
----
\ INITXT ( S -- )
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

code CALPAT ( b -- addr )
   H POP      L A MOV
   (CALPAT)   H PUSH
   next
end-code

code CALATR ( b -- addr )
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
\ BIOS-C@ ( addr -- b )

hex code BIOS-C@ ( addr -- b )
  H POP     \ POP HL
  B PUSH    \ PUSH BC
  fcc0 LDA  \ LD A,[fcc0]
  000c CALL \ CALL RDSLT
  EI        \ EI
  0 H MVI   \ LD H,0
  A L MOV   \ LD L,A
  B POP     \ POP BC
  H PUSH    \ PUSH HL
  next
end-code
----
\ BIOS60HZ ( -- ), BIOS50HZ ( -- )

hex
: BIOS60HZ ( -- )
   2B bios-c@ 80 and 0= ;

hex
: BIOS50HZ ( -- )
   2B bios-c@ 80 and 0<> ;
----
\ (delayjf) ( jiffy-min -- )

hex FC9E constant #JIFFY

: (delayjf) ( jiffy-min -- )
  begin
    dup #JIFFY @ u<=  \ unsigned compare
  until drop ;
----
\ delayjiffy ( u -- )
hex
: delayjiffy ( u -- )
  0            \ convert to double precision number
  #JIFFY @ 0 d+
  dup 0= if    \ sum not overflows
    drop (delayjf)
  else
    ffff. d- drop
    begin
      dup #JIFFY @ <=  \ signed compare !
    until drop
  then ;
----
\ SCREEN0, SCREEN0/80, SCREEN0/40

hex F3AE constant #LINL40

: SCREEN0 ( -- )
  0 CHGMOD ;

decimal
: SCREEN0/80 ( -- )
  80 #LINL40 C!  screen0 ;

decimal
: SCREEN0/40 ( -- )
  40 #LINL40 C!  screen0 ;
----
\ POSIT ( row col -- )

code POSIT ( row col -- )
  D POP
  H POP
  E H MOV
  (POSIT) \ H=x-coord L=y-coord
  next
end-code
----
\ CURSOR ( f -- ), #CSRY, #CSRX

hex
F3DC constant #CSRY  \ 1 byte, Y-coordinate of cursor
F3DD constant #CSRX  \ 1 byte, X-coordinate of cursor

hex
: cursor ( f -- ) \ show/hide cursor
  1B emit 79 emit 34 emit
  1B emit IF 79 ELSE 78 THEN emit
  35 emit ;
----
\ CHPUT ( ch -- )

code CHPUT ( ch -- )
  H POP
  L A MOV
  (CHPUT)
  next
end-code
----
\ RDSLT ( slot addr -- b )
hex

code RDSLT
   H POP   D POP   E A MOV
   B PUSH
   000C CALL \ OR... (RDSLT)
   EI
   B POP
   0 H MVI   A L MOV   H PUSH
   next
end-code
----
\ WRSLT ( slot addr b -- )
hex

code WRSLT
   B H MOV   C L MOV   ( IP>HL )
   D POP     B POP     XTHL
   ( stack=IP,DE=b, BC=addr, HL=slot )
   L A MOV
   B H MOV C L MOV
   ( A=slot,HL=addr,E=value)
   0014 CALL  \ OR... (WRSLT)
   B POP
   next
end-code
----
\ SLOTID ( primary expanded -- slotid)

hex
: SLOTID
   3 and 2* 2*
   swap 3 and +
   80 + ;
----
\ PSG init

code GICINI ( -- )
   B PUSH
   (GICINI)
   B POP
   next
end-code

: PSGINI GICINI ;

----
\ PSG!

code PSG! ( b reg -- )
   H POP
   D POP   L A MOV
   (WRTPSG)
   next
end-code
----

code SETC ( -- )
   B PUSH
   (SETC)
   B POP
   next
end-code

----

code MAPXYC ( x y --)
   D POP
   H POP
   B PUSH
   H B MOV
   L C MOV
   (MAPXYC)
   B POP
   next
end-code
----

hex
F3F2 constant #ATRBYT
FCB3 constant #GXPOS
FCB5 constant #GYPOS
FCAF constant #SCRMOD

----

hex
F3DF constant #RG0SAV
F3E0 constant #RG1SAV
F3E1 constant #RG2SAV
F3E2 constant #RG3SAV
F3E3 constant #RG4SAV
F3E4 constant #RG5SAV
F3E5 constant #RG6SAV
F3E6 constant #RG7SAV
F3E7 constant #STATFL
----

: RG0SAV@ ( --b) #RG0SAV C@ ;
: RG1SAV@ ( --b) #RG1SAV C@ ;
: RG2SAV@ ( --b) #RG2SAV C@ ;
: RG3SAV@ ( --b) #RG3SAV C@ ;
: RG4SAV@ ( --b) #RG4SAV C@ ;
: RG5SAV@ ( --b) #RG5SAV C@ ;
: RG6SAV@ ( --b) #RG6SAV C@ ;
: RG7SAV@ ( --b) #RG7SAV C@ ;
: STATFL@ ( --b) #STATFL C@ ;
----

hex FCA9 constant #CSRSW
: CSRSW@ ( --b) #CSRSW C@ ;
: CSRSW! ( bool--) 0= IF 0 ELSE 1 THEN #CSRSW C! ;
----

\ joy: 0=cursors, 1=port1, 2=port2
code GTSTCK ( joy -- status)
 H POP
 B PUSH
 L A MOV
 (GTSTCK)
 A L MOV
 0 H MVI
 B POP
 H PUSH
 next
end-code

----

\ button: 0=space, 
\         1=port1 bt A, 2=port2 bt A
\         3=port1 bt B, 4=port2 bt B
code GTTRIG ( button -- status)
 H POP
 B PUSH
 L A MOV
 (GTTRIG)
 A L MOV
 A H MOV
 B POP
 H PUSH
 next
end-code
----

code GTPDL ( pdlnum -- status)
 H POP
 B PUSH
 L A MOV
 (GTPDL)
 A L MOV
 0 H MVI
 B POP
 H PUSH
 next
end-code
----
