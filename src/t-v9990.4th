\ test V9990

----

msx-v9990 also forth definitions

decimal 2 9 thru

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
   #DSPM-BMP #DCKM=0 or #XIMM-512PX or #CLRM-4bpp or \ 133
     #V9R-SCREEN-RW#0  V9REG!
   0   #V9R-SCREEN-RW#1  V9REG!
   0   #V9R-PALETTEPTR-W V9REG!
   palturbor
   bmp3 ;
