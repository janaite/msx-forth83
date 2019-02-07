   SCR #n                filename.blk
   JED
0---------1---------2---------3---------4---------5---------6--
4
5
6
7
8
9
10
11
12
13
14
15************************************************************
----

msx also


\ decimal 2 30 thru
decimal 2 capacity 1- thru

----

hex 

\ F3B3 constant #TXTNAM

\ 2 bytes, base address of current pattern name table
F922 constant #NAMBAS

F3B0 constant #LINLEN \ 1 byte, current screen width per line
F3B1 constant #CRTCNT \ 1 byte, number of lines of current screen

----
decimal
: VADDR ( row col -- vaddr )
 swap #LINLEN c@ * + 
 #NAMBAS @ + ;

decimal
: FASTCLS ( -- )
  0 0 vaddr   #LINLEN c@ #CRTCNT c@ *   BL vramfill ;

----
decimal
: SHOW1K ( buffer row col  -- )
  vaddr
  16 0 do 
    2dup 64 >vram
    swap 64 + swap 80 +
  loop 2drop ;
----
decimal
: fastruler ( row col -- )
  vaddr
  dup 1+ 64 45 vramfill
  7 0 do
    dup  48 i + swap vram!
    10 + 
  loop ;

----
decimal

4 constant #numberline-row
0 constant #numberline-col

: fastnumberlines ( row col -- )
  16 0 do
    i 10 mod
    ascii 0 +
    #numberline-row i + #numberline-col 1+ vaddr vram!

    i 10 /
    ascii 0 +
    #numberline-row i + #numberline-col vaddr vram!
  loop ;
----
\ layout coordinates

decimal
( always from upper-left screen corner )
2  constant #ruler-row
2  constant #ruler-col
1  constant #status-row
2  constant #status-col
60 constant #status-len
4  constant #vp-row
3  constant #vp-col
----

\ text is 16 rows (from 0 to 15) by 64 columns (from 0 to 63)
variable txt-row \ current row inside text
variable txt-col \ current column inside text

decimal

0 txt-row !
0 txt-col !

15 constant #max-txt-row
63 constant #max-txt-col
----

hex
1B constant #key-esc
1E constant #key-up   
1F constant #key-down
1D constant #key-left
1C constant #key-right
0B constant #key-home
0D constant #key-return
08 constant #key-bs
12 constant #key-ins
7F constant #key-del
18 constant #key-select
----

hex 
57 constant #key-W
77 constant #key-WW
51 constant #key-Q
71 constant #key-QQ
58 constant #key-X
78 constant #key-XX 
----
defer enter-edit-state
defer enter-menu-state

----
: draw-blk ( addr -- )
  #vp-row #vp-col show1k ;

: draw-ruler ( -- )
  #ruler-row #ruler-col fastruler ;

: draw-linenumber ( -- )
  fastnumberlines ;

----

: draw-cursor ( -- )
  txt-row @ #vp-row 1+ +
  txt-col @ #vp-col 1+ +
    posit ;

: REDRAW ( -- )
  fastcls
  draw-ruler
  0 block draw-blk 
  draw-cursor ;
-----
\ : fastnumberlines ( row -- )
\ 0 vaddr
\ 2 0 do i .
\ 10 0 do j .
\ #LINLEN c@ +
\ ;
----
: BADDR ( addr row col -- addr )
  swap 64 * + + ;

\ char @ dup 
\  buffer row @ col @ baddr c!
\  row @ col @ vaddr vram!

----

: roll-cur-up ( S -- S )
  txt-row @
  dup 0> if 1- txt-row ! else
  drop #max-txt-row txt-row ! then ;

: act-cur-up ( -- )
  roll-cur-up
  draw-cursor ;
----

: roll-cur-down ( -- )
  txt-row @
  dup #max-txt-row < if 1+ txt-row ! else 
  drop 0 txt-row ! then ;

: act-cur-down ( -- )
  roll-cur-down
  draw-cursor ;
----

: roll-cur-left ( S -- S )
  txt-col @
  dup 0> if 1- txt-col ! else
  drop #max-txt-col txt-col ! then ;

: act-cur-left ( -- )
  roll-cur-left
  draw-cursor ;
----

: roll-cur-right ( S -- S )
  txt-col @
  dup #max-txt-col < if 1+ txt-col ! else
  drop 0 txt-col ! then ;

: act-cur-right ( -- )
  roll-cur-right
  draw-cursor ;

----
hex

: status-cls ( -- )
  #status-row #status-col vaddr #status-len BL vramfill ;

\ >VRAM ( from-addr to-vaddr len -- )

: (.status") 
  status-cls
  R> COUNT 2DUP + >R ( str-addr str-len )
  #status-row #status-col vaddr ( from-addr len to-vaddr )
  swap >vram ;

: .status" compile (.status") ," ; immediate
----
: act-cur-begin ;

: act-cur-next ( -- )
  0 txt-col !
  roll-cur-down
  draw-cursor ;

----

variable what-state
variable editor-quit
variable current-block

----

: act-quit ( -- )
  true editor-quit ! ;

: act-write ( -- )
  .status" Salvando arquivo..." 
  .status" Arquivo salvo! " 
  enter-edit-state
;

: act-menu-esc
 enter-edit-state ;

----

: do-menu ( -- )
 .status" <Esc>ape / <Q>uit / <W>rite / <X> write and eXit" 
 key
 dup #key-esc = if act-menu-esc else
 dup #key-q   = if act-quit else
 dup #key-qq  = if act-quit else
 dup #key-w   = if act-write else
 dup #key-ww  = if act-write else
 dup #key-x   = if act-write act-quit else
 dup #key-xx  = if act-write act-quit
 then then then then then then then
 drop ;

----

: act-edit-default ( c -- c )
 dup 
 dup BL >= swap 127 <= and if
   dup chput act-cur-right 
 then ;

----
: act-menu
  enter-menu-state ;

: do-quit ( -- ) ;
----

: current-block-next! ( S -- S )
  current-block @
  dup capacity 1- < if
    1+ current-block ! then ;
  
: current-block-prev! ( S -- S )
  current-block @
  dup 0> if 
    1- current-block ! then ;

----

: act-blk-prev ( c -- c )
  .status" BLK previous"
  current-block-prev!
  current-block @ block draw-blk draw-cursor ;

: act-blk-next ( c -- c )
  .status" BLK next"
  current-block-next!
  current-block @ block draw-blk draw-cursor ;
----
: do-edit ( -- )
  key
  dup #key-esc    = if act-menu      else
  dup #key-up     = if act-cur-up    else
  dup #key-down   = if act-cur-down  else
  dup #key-left   = if act-cur-left  else
  dup #key-right  = if act-cur-right else
  dup #key-home   = if act-cur-begin else
  dup #key-return = if act-cur-next  else
  dup #key-ins    = if act-blk-prev  else
  dup #key-del    = if act-blk-next  else
  act-edit-default
  then then then then then then then then then
  drop ;
----

: enter-edit-state-impl ( -- )
  ['] do-edit what-state ! 
  .status" Edit mode..." ;

: enter-menu-state-impl ( -- )
  ['] do-menu what-state !
  ;
----

: jed-ini
  ['] enter-edit-state-impl IS enter-edit-state
  ['] enter-menu-state-impl IS enter-menu-state
  false editor-quit !
  10 current-block !
  fastcls
  msx true cursor forth
  0 txt-row !
  0 txt-col ! 
  draw-ruler
  draw-linenumber
  current-block @ block draw-blk
  draw-cursor ;
----

: jed-finish
  23 0 posit ;

----

: jed ( -- )
  jed-ini
  enter-edit-state
  begin
    what-state @ execute 
  editor-quit @ until
  jed-finish ;
----
