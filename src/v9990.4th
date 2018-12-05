
V9990 Tests

----
only definitions FORTH also
vocabulary MSX-V9990

FORTH definitions
\ nothing

MSX-V9990 definitions
decimal 2 5 thru      \ constans
decimal 6 14 thru 

----
\ constants

hex 60 constant #V9BASE

#V9BASE 0 + constant #V9VRAM
#V9BASE 1 + constant #V9PALETTE
#V9BASE 2 + constant #V9CMD
#V9BASE 3 + constant #V9REGDATA
#V9BASE 4 + constant #V9REGSEL
#V9BASE 5 + constant #V9STATUS   \ R/O
#V9BASE 6 + constant #V9INTFLAG
#V9BASE 7 + constant #V9SYSCTL   \ W/O
#V9BASE F + constant #V9RESERVED

----
\ constants

decimal
0 constant #V9R-VRAM-W#0
1 constant #V9R-VRAM-W#1
2 constant #V9R-VRAM-W#2
3 constant #V9R-VRAM-R#0
4 constant #V9R-VRAM-R#1
5 constant #V9R-VRAM-R#2
6 constant #V9R-SCREEN-RW#0
7 constant #V9R-SCREEN-RW#1
8 constant #V9R-CTL-RW
9 constant #V9R-INT-RW#0
10 constant #V9R-INT-RW#1
11 constant #V9R-INT-RW#2
12 constant #V9R-INT-RW#3
----
\ constants
decimal
13 constant #V9R-PALETTECTL-W
14 constant #V9R-PALETTEPTR-W
15 constant #V9R-BACKDROP-RW
16 constant #V9R-DISPLAYADJ-RW
17 constant #V9R-SCROLL-AY-RW#0
18 constant #V9R-SCROLL-AY-RW#1
19 constant #V9R-SCROLL-AX-RW#0
20 constant #V9R-SCROLL-AX-RW#1
21 constant #V9R-SCROLL-BY-RW#0
22 constant #V9R-SCROLL-BY-RW#1
23 constant #V9R-SCROLL-BX-RW#0
24 constant #V9R-SCROLL-BX-RW#1
----
\ constants
decimal
25 constant #V9R-SPRITEGEN-RW
26 constant #V9R-LCDCTL-RW
27 constant #V9R-PRIORITYCTL-RW
28 constant #V9R-SPRITEPALETTECTL-W

32 constant #V9R-COMMAND-W#0
52 constant #V9R-COMMAND-W#20
53 constant #V9R-COMMAND-R#0
54 constant #V9R-COMMAND-R#1
----
\ V9REG! ( n reg -- )

: V9REG! ( n reg -- )
  #V9REGSEL  PC!
  #V9REGDATA PC! ;

: V9REG@ ( reg -- n )
  #V9REGSEL  PC!
  #V9REGDATA PC@ ;
----
\ V9PALETTE!, V9PALETTE@, V9RGBPALETTE!

: V9PALETTE! ( n -- )
   #V9PALETTE PC! ;

: V9PALETTE@ ( -- n )
   #V9PALETTE PC@ ;

: V9RGBPALETTE! ( b g r -- )
   V9PALETTE!   V9PALETTE!   V9PALETTE! ;
----
\ V9BUILD-PAL, rgb, ( r g b -- )

: V9BUILD-PAL ( compile: number-rgb-entries <name> -- )
   create ,
   does> dup @ swap 2+ swap
   0 do
     dup c@ V9PALETTE! 1+
     dup c@ V9PALETTE! 1+
     dup c@ V9PALETTE! 1+
   loop drop ;

: rgb, ( r g b -- )
   rot ( g b r ) c, 
   swap ( b g ) c, c, ;

----
\ D24BITS ( D -- msb mid lsb )

\ Double to 24 bits
code D24BITS ( D -- msb mid lsb )
   H POP   D POP
   0 H MVI   H PUSH   \ MSB
   D L MOV   H PUSH   \ MID
   E L MOV   H PUSH   \ LSB
   next
end-code

----
\ 2VRAM!! ( D-addr -- )

\ Set VRAM write address
: 2VRAM!! ( D-addr -- )
   D24BITS
   #V9R-VRAM-W#0 V9REG!   \ LSB
   #V9R-VRAM-W#1 V9REG!   \ MID
   #V9R-VRAM-W#2 V9REG!   \ MSB
;
----
\ VRAM!! ( addr -- )

\ 16bit number to 2x 8bit numbers
code n2b ( n -- msb lsb )
   H POP
   0 D MVI
   H E MOV   D PUSH
   L E MOV   D PUSH
   next
end-code

: VRAM!! ( addr -- )
   n2b
   #V9R-VRAM-W#0 V9REG!   \ LSB
   #V9R-VRAM-W#1 V9REG!   \ MSB
;
----
\ >VRAM ( n -- )

: >VRAM ( n -- )
   #V9VRAM PC! ;

----
\ DISPLAY ( f -- )

hex
: DISPLAY-ENABLE ( -- )
  #V9R-CTL-RW V9REG@
  80 or
  #V9R-CTL-RW V9REG! ;

hex
: DISPLAY-DISABLE ( -- )
  #V9R-CTL-RW V9REG@
  7F and
  #V9R-CTL-RW V9REG! ;

: DISPLAY ( f -- )
  IF display-enable ELSE display-disable THEN ;
----
\ SPRITES ( f -- )

hex
: SPRITES-ENABLE ( -- )
  #V9R-CTL-RW V9REG@
  BF and
  #V9R-CTL-RW V9REG! ;

hex
: SPRITES-DISABLE ( -- )
  #V9R-CTL-RW V9REG@
  40 or
  #V9R-CTL-RW V9REG! ;

: SPRITES ( f -- )
  IF sprites-enable ELSE sprites-disable THEN ;
----

\ http://msxbanzai.tni.nl/v9990/manual.html
\ http://www.map.grauw.nl/resources/video/yamaha_v9990.pdf

hex
40 constant #XIMM-1024PX
10 constant #CLRM-4BPP
80 constant #DSPM-BMP
00 constant #DCKM-1/4XTAL
----

: PAT-OFFSET ( pat -- addr )
   32 mod 4 * swap
   32 / 1024 * + ;

: DPATA-ADDR ( pat row -- d-addr )
   swap pat-offset 0 rot
   128 * 0 D+ ;

hex
: DPATB-ADDR ( pat row -- d-addr )
   40000. D+ ;
----
