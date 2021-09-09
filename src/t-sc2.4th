\ test Screen 2

----

\ msx also forth definitions

decimal 2 capacity 1- thru

----

hex
1800 constant #VDPNAMETABLE \ GRPNAM@

----

hex
sc2tile tileBK 18 c, 18 c, 3c c, ff c, ff c, 3c c, 18 c, 18 c,
sc2tile tile1 01 c, 01 c, 01 c, 01 c, 01 c, 6d c, 7f c, 7f c,
sc2tile tile2 00 c, c0 c, e0 c, 00 c, 00 c, b6 c, fe c, fe c,
sc2tile tile3 1f c, 16 c, 1f c, 1f c, 1f c, 16 c, 16 c, 01 c,
sc2tile tile4 f8 c, 68 c, f8 c, f8 c, f8 c, 68 c, 68 c, 80 c,

sc2palette pal0 62 c, 62 c, 62 c, 62 c, 62 c, 62 c, 62 c, 62 c,
sc2palette pal1 B2 c, B2 c, B2 c, B2 c, B2 c, B2 c, B2 c, B2 c,

sc2sprite8 sprite1 18 C, 18 C, 7E C, BD C, BD C, 24 C, 24 C, 66 C,

----

decimal

: testinit
  0 cls   ( CLS with tile 0)
  setgrp  ( screen2 !!! 256x192x16 = 32x24 tiles)
  1 14 15 puttile
  2 14 16 puttile
  3 15 15 puttile
  4 15 16 puttile
  0 16 16 0 15 putsprite8 ;

----

decimal

: testtiles ( -- )
  0 tileBK  1 tile1
  2 tile2   3 tile3
  4 tile4  ;

: testpalettes ( -- )
  0 pal0  1 pal1
  2 pal1  3 pal1
  4 pal1  ;
----
: testsprites ( -- )
  0 sprite1 ;

: testwait ( -- )
  chget drop
  initxt ;
----

: test ( -- )
  testinit
  testtiles
  testpalettes
  testsprites
  testwait  ;
