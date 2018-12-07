\ test V9990

----

msx-v9990 also forth definitions

decimal 2 22 thru

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
: bmp1   [ hex ] 0. 2vram!!
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
[ hex ] 700 vram!! decimal 0 >vram 255 >vram 255 >vram 0 >vram
   ;
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
   #DSPM-BMP #DCKM=0 or #XIMM-512PX or #CLRM-4bpp or \ 133
     #V9R-SCREEN-RW#0  V9REG!
   0   #V9R-SCREEN-RW#1  V9REG!
   0   #V9R-PALETTEPTR-W V9REG!
   palturbor
   bmp3 ;
----

\ PAT-DRAWBK uses color01 and color02
hex
: PAT-DRAWBK
 dup 0 pat-a-2addr 2vram!! 11 >vram 12 >vram 21 >vram 11 >vram
 dup 1 pat-a-2addr 2vram!! 11 >vram 12 >vram 21 >vram 11 >vram
 dup 2 pat-a-2addr 2vram!! 11 >vram 22 >vram 22 >vram 11 >vram
 dup 3 pat-a-2addr 2vram!! 22 >vram 22 >vram 22 >vram 22 >vram
 dup 4 pat-a-2addr 2vram!! 22 >vram 22 >vram 22 >vram 22 >vram
 dup 5 pat-a-2addr 2vram!! 11 >vram 22 >vram 22 >vram 11 >vram
 dup 6 pat-a-2addr 2vram!! 11 >vram 12 >vram 21 >vram 11 >vram
     7 pat-a-2addr 2vram!! 11 >vram 12 >vram 21 >vram 11 >vram
;
----

: 2assert ( n1 n2 -- )
  D= if ." passed! "
  else ." failed "
  then ;

----
decimal
: test-pnt-a
  [ decimal ]  0  0 pnt-a-2addr [ hex ] 7C000. 2assert
  [ decimal ]  0  1 pnt-a-2addr [ hex ] 7C002. 2assert
  [ decimal ]  0 63 pnt-a-2addr [ hex ] 7C07E. 2assert
  [ decimal ]  1  0 pnt-a-2addr [ hex ] 7C080. 2assert
  [ decimal ]  1 63 pnt-a-2addr [ hex ] 7C0FE. 2assert
  [ decimal ] 63 63 pnt-a-2addr [ hex ] 7DFFE. 2assert ;

----

: test-pnt-b
  [ decimal ]  0  0 pnt-b-2addr [ hex ] 7E000. 2assert
  [ decimal ]  0  1 pnt-b-2addr [ hex ] 7E003. 2assert
  [ decimal ]  0 63 pnt-b-2addr [ hex ] 7E07E. 2assert
  [ decimal ]  1  0 pnt-b-2addr [ hex ] 7E080. 2assert
  [ decimal ]  1 63 pnt-b-2addr [ hex ] 7E0FE. 2assert
  [ decimal ] 63 63 pnt-b-2addr [ hex ] 7FFFE. 2assert ;

----

: test2
  screen-p1
  162 #V9R-CTL-RW V9REG! \ 162=A2h
  0   #V9R-PALETTEPTR-W V9REG!
  palturbor
  512 
  dup pat-drawbk
  dup 0 0 pnt-a  dup 0 1 pnt-a  dup 0 2 pnt-a  dup 0 3 pnt-a
  dup 1 0 pnt-a  dup 2 1 pnt-a  dup 3 2 pnt-a  dup 4 3 pnt-a
  dup 0 0 pnt-b  dup 0 1 pnt-b  dup 0 2 pnt-b  dup 0 3 pnt-b
  dup 1 0 pnt-b  dup 2 1 pnt-b  dup 3 2 pnt-b  dup 4 3 pnt-b
  drop
  true display ;
----
\ PAT-DRAW1 uses color02 and color03

hex
: PAT-DRAW1 ( pat -- )
 dup 0 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 34 >vram
 dup 1 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 34 >vram
 dup 2 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 34 >vram
 dup 3 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 34 >vram
 dup 4 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 34 >vram
 dup 5 pat-a-2addr 2vram!! 34 >vram 43 >vram 44 >vram 34 >vram
 dup 6 pat-a-2addr 2vram!! 34 >vram 44 >vram 44 >vram 44 >vram
     7 pat-a-2addr 2vram!! 34 >vram 44 >vram 44 >vram 44 >vram
 ;
----
\ PAT-DRAW2 uses color02 and color03

hex
: PAT-DRAW2 ( pat -- )
 dup 0 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 33 >vram
 dup 1 pat-a-2addr 2vram!! 44 >vram 33 >vram 33 >vram 33 >vram
 dup 2 pat-a-2addr 2vram!! 44 >vram 43 >vram 33 >vram 33 >vram
 dup 3 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 33 >vram
 dup 4 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 33 >vram
 dup 5 pat-a-2addr 2vram!! 43 >vram 44 >vram 34 >vram 43 >vram
 dup 6 pat-a-2addr 2vram!! 44 >vram 44 >vram 44 >vram 43 >vram
     7 pat-a-2addr 2vram!! 44 >vram 44 >vram 44 >vram 43 >vram
 ;
----
 \ PAT-DRAW3 uses color02 and color03

hex
: PAT-DRAW3 ( pat -- )
 dup 0 pat-a-2addr 2vram!! 33 >vram 34 >vram 44 >vram 44 >vram
 dup 1 pat-a-2addr 2vram!! 33 >vram 34 >vram 34 >vram 43 >vram
 dup 2 pat-a-2addr 2vram!! 33 >vram 34 >vram 44 >vram 44 >vram
 dup 3 pat-a-2addr 2vram!! 33 >vram 34 >vram 44 >vram 44 >vram
 dup 4 pat-a-2addr 2vram!! 33 >vram 34 >vram 44 >vram 44 >vram
 dup 5 pat-a-2addr 2vram!! 33 >vram 34 >vram 34 >vram 43 >vram
 dup 6 pat-a-2addr 2vram!! 33 >vram 34 >vram 34 >vram 43 >vram
     7 pat-a-2addr 2vram!! 33 >vram 33 >vram 33 >vram 34 >vram
 ;
----
\ PAT-DRAW4 uses color02 and color03
hex
: PAT-DRAW4 ( pat -- )
 dup 0 pat-a-2addr 2vram!! 44 >vram 44 >vram 43 >vram 33 >vram
 dup 1 pat-a-2addr 2vram!! 34 >vram 43 >vram 43 >vram 33 >vram
 dup 2 pat-a-2addr 2vram!! 44 >vram 44 >vram 43 >vram 33 >vram
 dup 3 pat-a-2addr 2vram!! 44 >vram 44 >vram 43 >vram 33 >vram
 dup 4 pat-a-2addr 2vram!! 44 >vram 44 >vram 43 >vram 33 >vram
 dup 5 pat-a-2addr 2vram!! 34 >vram 43 >vram 43 >vram 33 >vram
 dup 6 pat-a-2addr 2vram!! 34 >vram 43 >vram 43 >vram 33 >vram
     7 pat-a-2addr 2vram!! 43 >vram 33 >vram 33 >vram 33 >vram
;
----

decimal
: PAT-CASTLE ( row col -- )
  11 pat-draw1  12 pat-draw2  13 pat-draw3  14 pat-draw4
  \ 11 0 0 pnt-a  12 0 1 pnt-a  13 1 0 pnt-a  14 1 1 pnt-a
  2dup 11 -rot  pnt-a  
  2dup 12 -rot 1+ pnt-a
  2dup 13 -rot swap 1+ swap pnt-a
       14 -rot swap 1+ swap 1+ pnt-a
;

----
: test3
  screen-p1
  162 #V9R-CTL-RW V9REG! \ 162=A2h
  0   #V9R-PALETTEPTR-W V9REG!
  palturbor
  512 pat-drawbk
  512 fill-pnt-a
  12 15 pat-castle
  true display ;
----

variable posx
variable posy

: GO-LEFT  posx @ 1- dup posx ! scroll-ax ;
: GO-RIGHT posx @ 1+ dup posx ! scroll-ax ;
: GO-UP    posy @ 1- dup posy ! scroll-ay ;
: GO-DOWN  posy @ 1+ dup posy ! scroll-ay ;
----
hex
1D constant #CUR-LEFT
1C constant #CUR-RIGHT
1E constant #CUR-UP
1F constant #CUR-DOWN
1B constant #KEY-ESC

: test4
  begin  key
    dup #CUR-LEFT  = if go-left  then
    dup #CUR-RIGHT = if go-right then
    dup #CUR-UP    = if go-up    then
    dup #CUR-DOWN  = if go-down  then
    #KEY-ESC <> while repeat ;
----
