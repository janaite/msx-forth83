
V9990 Tests

----
only definitions FORTH also
vocabulary MSX-V9990

FORTH definitions
\ nothing

MSX-V9990 definitions
decimal 2 5 thru \ constans
decimal 6 12 thru 
decimal 13 19 thru   \ tests

----

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

decimal
13 constant #V9R-PALETTECTL-W
14 constant #V9R-PALETTEPTR-W
15 constant #V9R-BACKDROP-RW
16 constant #V9R-DISPLAYADJ-RW
17 constant #V9R-SCROLL-RW#0
18 constant #V9R-SCROLL-RW#1
19 constant #V9R-SCROLL-RW#2
20 constant #V9R-SCROLL-RW#3
21 constant #V9R-SCROLL-RW#4
22 constant #V9R-SCROLL-RW#5
23 constant #V9R-SCROLL-RW#6
24 constant #V9R-SCROLL-RW#7
----

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


\ PC! (n port -- )
\ PC@ ( port -- n)

: V9REG! ( n reg -- )
#V9REGSEL PC!
   #V9REGDATA PC! ;
----

: V9PALETTE! ( n -- )
   #V9PALETTE PC! ;

: V9PALETTE@ ( -- n )
   #V9PALETTE PC@ ;

: V9RGBPALETTE! ( b g r -- )
   V9PALETTE!   V9PALETTE!   V9PALETTE! ;
   
----

: V9BUILD-PAL ( compile: number-rgb-entries <name> -- )
   create ,
   does> dup @ swap 2+ swap
   0 do
     dup c@ V9PALETTE! 1+
     dup c@ V9PALETTE! 1+
     dup c@ V9PALETTE! 1+
   loop drop
;

----

\ Double to 24 bits
code D24BITS ( D -- msb mid lsb )
   H POP   D POP
   0 H MVI   H PUSH   \ MSB
   D L MOV   H PUSH   \ MID
   E L MOV   H PUSH   \ LSB
   next
end-code

----

\ Set VRAM write address
: 2VRAM!! ( D-addr -- )
   D24BITS
   #V9R-VRAM-W#0 V9REG!   \ LSB
   #V9R-VRAM-W#1 V9REG!   \ MID
   #V9R-VRAM-W#2 V9REG!   \ MSB
;
----

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

: >VRAM ( n -- )
   #V9VRAM PC! ;

----

16 V9BUILD-PAL PALTEST
   128 c, 0  c, 0  c,      0   c, 0  c, 0  c,
   4   c, 27 c, 4  c,      13  c, 31 c, 13 c,
   4   c, 4  c, 31 c,      9   c, 13 c, 31 c,
   22  c, 4  c, 4  c,      9   c, 27 c, 31 c,
   31  c, 4  c, 4  c,      31  c, 13 c, 13 c,
   27  c, 27 c, 4  c,      27  c, 27 c, 18 c,
   4   c, 18 c, 4  c,      27  c, 9  c, 27 c,
   22  c, 22 c, 22 c,      31  c, 31 c, 31 c,
----

: rgb, ( r g b -- )
   rot ( g b r ) c, 
   swap ( b g ) c, c, ;

\ TurboR palette (by tvalenca)
16 V9BUILD-PAL PALTURBOR
   128  0   0 rgb,     0    0   0 rgb,
   4   27   4 rgb,    13   31  13 rgb,
   4    4  31 rgb,     9   13  31 rgb,
   22   4   4 rgb,     9   27  31 rgb,
   31   4   4 rgb,    31   13  13 rgb,
   27  27   4 rgb,    27   27  18 rgb,
   4   18   4 rgb,    27    9  27 rgb,
   22  22  22 rgb,    31   31  31 rgb,

----

\ V9BUILD-BMP
\    create , ,
\   does> 
\   ;

----
 \  hex 4 8
decimal
variable bmpx
     0 c, 255 c, 255 c,   0 c,
    15 c,   0 c,   0 c, 240 c,
   240 c, 240 c,  15 c,  15 c, 
   240 c,   0 c,   0 c,  15 c,
   240 c, 240 c,  15 c,  15 c,
   240 c,  15 c, 240 c,  15 c,
    15 c,   0 c,   0 c, 240 c,
     0 c, 255 c, 255 c,   0 c,

----
: bmp1
   [ hex ] 0. 2vram!!
   [ decimal ] 0  >VRAM  255 >VRAM 255 >VRAM 0 >VRAM
   [ hex ] 100 vram!!
   [ decimal ] 15 >vram   0 >vram    0 >vram 240 >vram
   [ hex ] 200 vram!!
   [ decimal ] 240 >vram 240 >vram   15 >vram  15 >vram 
   [ hex ] 300 vram!!
   [ decimal ] 240 >vram   0 >vram    0 >vram  15 >vram
   [ hex ] 400 vram!!
   [ decimal ] 240 >vram 240 >vram   15 >vram  15 >vram
   [ hex ] 500 vram!!
   [ decimal ] 240 >vram  15 >vram  240 >vram  15 >vram
[ hex ] 600 vram!! decimal 15 >vram 0 >vram 0 >vram  240 >vram
[ hex ] 700 vram!! decimal 0 >vram 255 >vram 255 >vram 0 >vram ;
----
decimal 
: bmp2
   0.  2vram!!   0 >vram 255 >vram  255 >vram   0 >vram
   256  vram!!  15 >vram   0 >vram    0 >vram 240 >vram
   512  vram!! 240 >vram 240 >vram   15 >vram  15 >vram 
   768  vram!! 240 >vram   0 >vram    0 >vram  15 >vram
   1024 vram!! 240 >vram 240 >vram   15 >vram  15 >vram
   1280 vram!! 240 >vram  15 >vram  240 >vram  15 >vram
   1536 vram!!  15 >vram   0 >vram    0 >vram 240 >vram
   1792 vram!!   0 >vram 255 >vram  255 >vram   0 >vram ;
----
hex
: bmp3
   0.   2vram!!  0 >vram FF >vram FF >vram  0 >vram
   100. 2vram!! 0F >vram  0 >vram  0 >vram F0 >vram
   200. 2vram!! F0 >vram F0 >vram 0F >vram 0F >vram 
   300. 2vram!! F0 >vram  0 >vram  0 >vram 0F >vram
   400. 2vram!! F0 >vram F0 >vram 0F >vram 0F >vram
   500. 2vram!! F0 >vram 0F >vram F0 >vram 0F >vram
   600. 2vram!! 0F >vram  0 >vram  0 >vram F0 >vram
   700. 2vram!!  0 >vram FF >vram FF >vram  0 >vram ;
----
decimal
: V9INI ( -- ) 
   24 #V9RESERVED PC!
   0  #V9SYSCTL PC! ;

decimal
: test
   V9INI
   162 #V9R-CTL-RW V9REG!
   133 #V9R-SCREEN-RW#0  V9REG!
   0   #V9R-SCREEN-RW#1  V9REG!
   0   #V9R-PALETTEPTR-W V9REG!
   palturbor
   bmp3 ;

----
   000000 
OUT &H64,0:OUT &H63,0:
OUT &H64,1:OUT &H63,0:
OUT &H64,2:OUT &H63,0
----
0 255 0
   100

230 OUT &H60,15: OUT &H60,0:OUT &H60,0:OUT&H60,240

   200

250 OUT &H60,240:OUT &H60,240:OUT &H60,15:OUT&H60,15

   300

270 OUT &H60,240:OUT &H60,0:OUT &H60,0:OUT&H60,15

   400

290 OUT &H60,240:OUT &H60,240:OUT &H60,15:OUT&H60,15
----
   500

310 OUT &H60,240:OUT &H60,15:OUT &H60,240:OUT&H60,15

   600

330 OUT &H60,15:OUT &H60,0:OUT &H60,0:OUT&H60,240

   700

350 OUT &H60,0:OUT &H60,255:OUT &H60,255:OUT&H60,0

----

VRAM!
VRAM@

PALETTE!
PALETTE@

CMD!
CMD@
----

REGDATA!
REGDATA@

REGSEL!

STATUS@

----

INTFLAG@
INTFLAG!

SYSCTL!
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