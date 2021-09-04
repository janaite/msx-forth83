\ Graphic routines

----

decimal 2 capacity 1- thru

----

: T32NAM@ ( -- n) #T32NAM @ ;
: T32NAM! ( n --) #T32NAM ! ;
: T32COL@ ( -- n) #T32COL @ ;
: T32COL! ( n --) #T32COl ! ;
: T32CGP@ ( -- n) #T32CGP @ ;
: T32CGP! ( n --) #T32CGP ! ;
: T32ATR@ ( -- n) #T32ATR @ ;
: T32ATR! ( n --) #T32ATR ! ;
: T32PAT@ ( -- n) #T32PAT @ ;
: T32PAT! ( n --) #T32PAT ! ;
----

: GRPNAM@ ( -- n) #GRPNAM @ ;
: GRPNAM! ( n --) #GRPNAM ! ;
: GRPCOL@ ( -- n) #GRPCOL @ ;
: GRPCOL! ( n --) #GRPCOL ! ;
: GRPCGP@ ( -- n) #GRPCGP @ ;
: GRPCGP! ( n --) #GRPCGP ! ;
: GRPATR@ ( -- n) #GRPATR @ ;
: GRPATR! ( n --) #GRPATR ! ;
: GRPPAT@ ( -- n) #GRPPAT @ ;
: GRPPAT! ( n --) #GRPPAT ! ;
----

: MLTNAM@ ( -- n) #MLTNAM @ ;
: MLTNAM! ( n --) #MLTNAM ! ;
: MLTCOL@ ( -- n) #MLTCOL @ ;
: MLTCOL! ( n --) #MLTCOL ! ;
: MLTCGP@ ( -- n) #MLTCGP @ ;
: MLTCGP! ( n --) #MLTCGP ! ;
: MLTATR@ ( -- n) #MLTATR @ ;
: MLTATR! ( n --) #MLTATR ! ;
: MLTPAT@ ( -- n) #MLTPAT @ ;
: MLTPAT! ( n --) #MLTPAT ! ;
----

: FORCLR@ ( -- b) #FORCLR C@ ;
: FORCLR! ( b --) #FORCLR C! ;
: BAKCLR@ ( -- b) #BAKCLR C@ ;
: BAKCLR! ( b --) #BAKCLR C! ;
: BDRCLR@ ( -- b) #BDRCLR C@ ;
: BDRCLR! ( b --) #BDRCLR C! ;

----

: JIFFY@ ( -- u) #JIFFY @ ;
: JIFFY! ( u --) #JIFFY ! ;

: LINL40@ ( -- b) #LINL40 C@ ;
: LINL40! ( b --) #LINL40 C! ;

----

: CSRX@ ( -- b) #CSRX C@ ; \ X-coordinate of cursor
: CSRX! ( b --) #CSRX C! ; \ X-coordinate of cursor
: CSRY@ ( -- b) #CSRY C@ ; \ Y-coordinate of cursor
: CSRY! ( b --) #CSRY C! ; \ Y-coordinate of cursor
----

hex
: ATRBYT! ( c --) #ATRBYT ! ;
: ATRBYT@ ( -- c) #ATRBYT @ ;
: GXPOS!  ( u --) #GXPOS ! ;
: GXPOS@  ( -- u) #GXPOS @ ;
: GYPOS!  ( u --) #GYPOS ! ;
: GYPOS@  ( -- u) #GYPOS @ ;
----

\ Ported from: Micro Sistemas n88 pages 42-43
: PLOT ( x y c -- )
   ATRBYT@ >R
   ATRBYT!
   MAPXYC
   SETC
   R> ATRBYT!
;
----

decimal

: SC2TILE ( -- ) ( run-time: tile -- )
  create
  does> ( tile addr -- )
    swap 8 * 2dup
    8 ( from to len -- ) >vram
    2dup
    2048 + 8 ( from to len -- ) >vram
    4096 + 8 ( from to len -- ) >vram ;

----

hex

: SC2PALETTE ( -- ) ( run-time: tile -- )
  create
  does> ( tile param-addr -- )
    swap 8 * 2000 +
    2dup
    8        ( from to-vram len -- ) >vram
    2dup
    800  + 8 ( from to-vram len -- ) >vram
    1000 + 8 ( from to-vram len -- ) >vram ;
----
