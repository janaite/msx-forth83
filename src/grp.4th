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

decimal
: PUTTILE ( tile row col -- )
  swap 32 * + GRPNAM@ + vram! ;

decimal
: CLS ( tile -- )
  GRPNAM@ 768 rot ( addr len char -- ) VRAMFILL ;

----
( screen mode - up to screen 8)

: SCRMOD@ ( -- b) #SCRMOD C@ ;
: SCRMOD! ( b --) #SCRMOD C! ;

----
\ Get Sprite size

\ n: sprite size in bytes
\ TRUE: if 16x16 sprite, else FALSE
code GSPSIZ ( -- n f) \ TODO: test
  (GSPSIZ)
  0 D MVI   A E MOV   D PUSH
  0 E MVI  \ DE="false"
  C0<> IF  \ Jump to THEN when CY=0
    D DCX  \ if CY=1, DE="true"
  THEN
  D PUSH
  next
end-code
----
hex

: SC2SPRITE ( -- )
  create
  does> ( pat# from-addr -- )
    swap GSPSIZ drop dup rot * #GRPPAT @ + swap ( from-addr to-vram len -- ) >vram ;
----
decimal

: PUTSPRITE ( sprite# y x pat# ec+color -- )
  here 3 + c! ( store ec+color )
  GSPSIZ drop 8 / * here 2+ c! ( store correct pattern )
  here 1+ c! ( store x )
  1- here c! ( store y - 1 )
  here swap 4 * #GRPATR @ + 4 ( from-addr to-vram len -- ) >vram ;
----

decimal
: spr.ini ( --) CLRSPR ;

: spr.load ( blknum -- ) \ uses 2 blocks
  DUP
  BLOCK GRPPAT@ 1024 >vram
  1+ BLOCK GRPPAT@ 1024 + 1024 >vram ;
----

decimal
: spr.base  ( spr -- addr) 2* 2* GRPATR@ + ;

: spr.y@     ( spr -- n) spr.base VRAM@ ;
: spr.y!     ( n spr --) spr.base VRAM! ;
: spr.x@     ( spr -- n) spr.base 1+ VRAM@ ;
: spr.x!     ( n spr --) spr.base 1+ VRAM! ;
: spr.pat@   ( spr -- n) spr.base 2+ VRAM@ ;
: spr.pat!   ( n spr --) spr.base 2+ VRAM! ;

----
hex
: spr.8 ( -- ) e0 1 VDPREG! ;
: spr.16 ( -- ) e2 1 VDPREG! ;

: spr.ec+color@ ( spr -- n) spr.base 3 + VRAM@ ;
: spr.ec+color! ( n spr --) spr.base 3 + VRAM! ;

: spr.color@ ( spr -- n) spr.ec+color@ 31 AND ;
: spr.color! ( n spr --) SWAP 31 AND SWAP spr.ec+color! ;

: spr.ec? ( spr -- f)
  spr.ec+color@ 80 AND 0<> ;
----

hex
: spr.ec1! ( spr --)
  DUP spr.ec+color@ 80 OR
  SWAP spr.ec+color! ;

: spr.ec0! ( spr --)
  DUP spr.ec+color@ 7F AND
  SWAP spr.ec+color! ;

: spr.ec! ( f spr --)
  SWAP IF spr.ec1! ELSE spr.ec0! THEN ;
----
