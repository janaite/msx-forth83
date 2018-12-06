
V9990 Tests

----
only definitions FORTH also
vocabulary MSX-V9990

FORTH definitions
\ nothing

MSX-V9990 definitions
decimal 2 5 thru      \ constans
decimal 6 14 thru 
decimal 15 18 thru \ Scrolls...
decimal 19 21 thru \ screen mode...
decimal 22 27 thru \ patterns...

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
  #V9REGSEL PC!  #V9REGDATA PC! ;

hex
: V9REG+1! ( n reg -- )
  3F AND
  #V9REGSEL PC!  #V9REGDATA PC! ;

: V9REG@ ( reg -- n )
  #V9REGSEL PC!  #V9REGDATA PC@ ;
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
hex
: 2VRAM!! ( D-addr -- )
   D24BITS
   #V9R-VRAM-W#0 V9REG!   \ R#0 = LSB
   #V9R-VRAM-W#1 V9REG!   \ R#1 = MID
   7F and                 \ Autoincrement AII=0
   #V9R-VRAM-W#2 V9REG!   \ R#2 = MSB
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
\ >VRAM ( b -- ), >V9REGDATA ( b -- )

: >VRAM ( b -- )
   #V9VRAM PC! ;

: >V9REGDATA ( b -- )
  #V9REGDATA PC!  ;
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
\ Scroll A/B constants and variables
hex
00 constant #SCROLL-MODE-ROLLIMAGE
40 constant #SCROLL-MODE-ROLL256
80 constant #SCROLL-MODE-ROLL512

variable SCROLL-A-MODE
#SCROLL-MODE-ROLLIMAGE SCROLL-A-MODE !

variable SCROLL-B-MODE
#SCROLL-MODE-ROLLIMAGE SCROLL-B-MODE !
----
\ SET-SCROLL-A-MODE ( n -- ), SET-SCROLL-B-MODE ( n -- )

hex
: SET-SCROLL-A-MODE ( n -- )
  00C0 and SCROLL-A-MODE ! ;

hex
: SET-SCROLL-B-MODE ( n -- )
  00C0 and SCROLL-B-MODE ! ;
----
\ SCROLL-AX ( n -- ), SCROLL-AY ( n -- )

hex
: SCROLL-AX ( n -- )
  dup
  7 and #V9R-SCROLL-AX-RW#0 V9REG+1!  \ bits 2..0
  u2/ u2/ u2/ >V9REGDATA ;            \ bits 10..3

hex
: SCROLL-AY ( n -- )
  n2b ( n -- msb lsb )
  #V9R-SCROLL-AY-RW#0 V9REG+1!             \ bits  7..0
  1F and SCROLL-A-MODE C@ or >V9REGDATA ;  \ bits 12..8

----
\ SCROLL-BX ( n -- ), SCROLL-BY ( n --)

hex
: SCROLL-BX ( n -- )
  dup
  7 and #V9R-SCROLL-BX-RW#0 V9REG+1!  \ bits 2..0
  u2/ u2/ u2/ 3F and >V9REGDATA ;     \ bits 10..3
  
hex
: SCROLL-BY ( n --)
  n2b ( n -- msb lsb )
  #V9R-SCROLL-BY-RW#0 V9REG+1!             \ bits 7..0
  01 and SCROLL-B-MODE C@ or >V9REGDATA ;  \ bits 8
----

\ Selection of number of pixels in X direction of image space
\ (Number of pixels in Y direction is automatically 
\ calculated from XIMM and CLRM)
hex
03 constant #CLRM-16bpp  \ 16 bits/pixel
02 constant #CLRM-8bpp   \ 8 bits/pixel
01 constant #CLRM-4bpp   \ 4 bits/pixel
00 constant #CLRM-2bpp   \ 2 bits/pixel 

hex
0C constant #XIMM-2048PX \ 2048 pixels
08 constant #XIMM-1024PX \ 1024 pixels
04 constant #XIMM-512PX  \ 512 pixels
00 constant #XIMM-256PX  \ 256 pixels
----

hex
20 constant #DCKM=2
10 constant #DCKM=1
00 constant #DCKM=0

hex
C0 constant #DSPM-STANDBY
80 constant #DSPM-BMP
40 constant #DSPM-P2
00 constant #DSPM-P1

----

hex
00 constant #HSCN=0
01 constant #HSCN=1
00 constant #IL=0
02 constant #IL=1
00 constant #EO=0
04 constant #EO=1
00 constant #PAL=0
08 constant #PAL=1
00 constant #SM=0
10 constant #SM=1
00 constant #SM1=0
20 constant #SM1=1
00 constant #CM25M=0
40 constant #CM25M=1
----
\ SCREEN-P1

decimal
: SUPERIMPOSE ( f -- )    \ video9000 superimpose enable
  if 24 else 0 then #V9RESERVED PC! ;

: SCREEN-P1 ( -- )
  true superimpose
  \ 0  #V9SYSCTL PC!  \ MCS=0
  #CLRM-4bpp
  #XIMM-512PX or
  #DCKM=0 or
  #DSPM-P1 or
  #V9R-SCREEN-RW#0 V9REG+1!  \ R#6
  0 >V9REGDATA               \ R#7
  0 #V9SYSCTL PC!  ;         \ P#7
----
\ PAT-B-2ADDR, PAT-A-2ADDR ( pat row -- d-addr )
decimal
: PAT-OFFSET ( pat -- d-addr )
   dup
   32 mod 4 * 0 rot
   32 / 1024 * 0 D+ ;

decimal
: PAT-A-2ADDR ( pat row -- d-addr )
   128 * 0
   rot pat-offset 
   D+ ;

hex
: PAT-B-2ADDR ( pat row -- d-addr )
   PAT-A-2ADDR 40000. D+ ;
----
\ PNT-A ( pat row col -- )

hex
\ Pattern name table
: PNT-A-2ADDR ( row col -- d-addr )
  2* swap 80 * + 
  0 7C000. D+ ;

: PNT-A ( pat row col -- )
  pnt-a-2addr 2vram!! 
  n2b ( msb lsb )  \ swap ???
  >vram >vram ;
----
\ PNT-B ( pat row col -- )

: PNT-B-2ADDR ( row col -- d-addr )
  2* swap 80 * + 
  0 7E000. D+ ;

: PNT-B ( pat row col -- )
  pnt-b-2addr 2vram!! 
  n2b ( msb lsb )  \ swap ???
  >vram >vram ;
----
\ FILL-PNT-A ( pat -- ), FILL-PNT-B ( pat -- )
hex
7C000. 2constant #PNT-A-BEGIN
2000   constant  #PNT-A-LEN
7E000. 2constant #PNT-B-BEGIN
2000   constant  #PNT-B-LEN

: FILL-PNT-A ( pat -- )
  #PNT-A-BEGIN 2vram!!
  #PNT-A-LEN 0 do dup n2b >vram >vram loop drop ;

: FILL-PNT-B ( pat -- )
  #PNT-B-BEGIN 2vram!!
  #PNT-B-LEN 0 do dup n2b >vram >vram loop drop ;
----
