\ JED a simple editor, it's "Just an EDitor"          ??AGO21JJN
*** unfinished !!! *** 
USAGE: JED ( block -- )

Ctrl + Shift + UP    = first block
Ctrl + Shift + DOWN  = last block
Ctrl + Shift + LEFT  = previous block
Ctrl + Shift + RIGHT = next block
Shift + UP    = first line
Shift + DOWN  = last line
Shift + LEFT  = first column
Shift + RIGHT = last column

ESC = save and exit
HOME = save all and redraw screen
----

only definitions FORTH also
vocabulary JED2

JED2 definitions

.( wait several seconds to finish...)

( Load all blocks )
decimal 2 capacity 1- thru

.( loading OK)
----
\ keycodes constants

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
\ keycodes constants (cont.)

hex 
57 constant #key-W
77 constant #key-WW
51 constant #key-Q
71 constant #key-QQ
58 constant #key-X
78 constant #key-XX 
----
\ variables

\ text is 16 rows (from 0 to 15) by 64 columns (from 0 to 63)
variable txt-row \ current row inside text
variable txt-col \ current column inside text
variable current-block

variable buf
variable pbuf

variable what-state
variable editor-quit
----
\ constants

hex 1B constant #ESC
: esc #ESC emit ;

decimal
15 constant #max-txt-row
63 constant #max-txt-col
HEX
F3B0 constant #LINLEN \ 1 byte, current screen width per line
F3B1 constant #CRTCNT \ 1 byte, number of lines of current screen
----
\ utility words
decimal
: ++ ( addr -- ) dup @ 1+ swap ! ;
: -- ( addr -- ) dup @ 1- swap ! ;
: ++max ( addr n -- ) over @ 1+ min swap ! ;
: --min ( addr n -- ) over @ 1- max swap ! ;
: max-blk ( -- n) capacity 1- ; \ shadows,use capacity 2/ ;
: 80cols? ( -- b) #LINLEN c@ 80 >= ;
----
\ txt-col and txt-row auxiliary words

: txt-col++ ( -- ) txt-col #max-txt-col ++max ;
: txt-col-- ( -- ) txt-col 0 --min ;
: txt-row++ ( -- ) txt-row #max-txt-row ++max ;
: txt-row-- ( -- ) txt-row 0 --min ;

----
( terminal VT52 )

decimal
: vt.cls ( -- )      esc ascii E emit ;
: vt.cls-end ( -- )  esc ascii j emit ;
: vt.cls-eol ( --)   esc ascii K emit ;
: vt.cur-full ( -- ) esc ascii x emit ascii 4 emit ;
: vt.cur-half ( -- ) esc ascii y emit ascii 4 emit ; 
: vt.cur-show ( -- ) esc ascii y emit ascii 5 emit ;
: vt.cur-hide ( -- ) esc ascii x emit ascii 5 emit ;
: vt ( -- ) vt.cur-show ;
: vt.cur-pos ( line column -- ) 
   32 + swap 32 + esc ascii Y emit emit emit ;
----
decimal

: txt-rowcol>offset ( -- n )
  txt-row @ 64 *
  txt-col @ + ;

: cursor.update ( -- )
 txt-row @ 1 + txt-col @ 15 + vt.cur-pos
 txt-row @ 16 * txt-col @ + buf + pbuf !
;
----
( drawing routines )

: 9dash ( -- ) 9 0 do ascii - emit loop ;
: 3dash ( -- ) ascii - dup emit dup emit emit ;
: emitnum ( n -- ) ascii 0 + emit ;
: ruler ( -- ) 
  0 emitnum 7 1 do 
    9dash i emitnum 
  loop
  3dash ascii * emit ;
: ruler.draw ( -- ) 0 15 vt.cur-pos ruler ;
: emit2num ( n -- ) dup 10 / emitnum 10 mod emitnum ; ( decimal )
----

: emit64chars ( addr -- addr+64 )
64 0 do dup c@ emit 1+ loop ;

: draw ( addr -- ) ruler.draw 
16 0 do
  i 1+ 13 vt.cur-pos 
  i emit2num 32 emit emit64chars
loop ;

: sh ( blk -- )
 block vt.cur-hide draw vt.cur-show ;
----

: scr.draw ( -- )
 ruler.draw
 16 0 do
  i 1+ 12 vt.cur-pos 
  i emit2num 32 emit
 loop ;
----
( read CONTROL and SHIFT key state )

hex
: newkey6@ FBE5 6 + c@ ;
: kb.ctrl? ( -- f) newkey6@ 2 and 0= ;
: kb.shift? ( -- f) newkey6@ 1 and 0= ;

----

decimal
: show-current-block ( -- )
  0 txt-col !
  current-block @ block
  vt.cur-hide
  #max-txt-row 1+ 0 do
    I txt-row ! cursor.update
    emit64chars
  loop
  drop
  0 txt-row ! vt.cur-show cursor.update ;
----
decimal
: act-cur-bol ( -- )               0 txt-col ! cursor.update ;
: act-cur-eol ( -- )    #max-txt-col txt-col ! cursor.update ;
: act-cur-line0 ( -- )             0 txt-row ! cursor.update ;
: act-cur-line15 ( -- ) #max-txt-row txt-row ! cursor.update ;

: act-cur-left ( -- )  txt-col-- cursor.update ;
: act-cur-right ( -- ) txt-col++ cursor.update ;
: act-cur-up ( -- )    txt-row-- cursor.update ;
: act-cur-down ( -- )  txt-row++ cursor.update ;
: act-cur-begin ( -- ) ;
: act-cur-bol-newline ( -- );
----

: act-next-blk ( -- ) 
 current-block max-blk ++max show-current-block ;

: act-prev-blk ( -- ) 
 current-block 0 --min show-current-block ;

: act-first-blk ( -- )
 0 current-block ! show-current-block ;

: act-last-blk ( -- )
 max-blk current-block ! show-current-block ;
----

: kb.left ( -- )
 kb.ctrl? IF 
  kb.shift? IF act-prev-blk ELSE act-cur-bol THEN
 ELSE
  act-cur-left
 THEN ;

: kb.right ( -- )
 kb.ctrl? IF 
  kb.shift? IF act-next-blk ELSE act-cur-eol THEN
ELSE 
  act-cur-right
THEN ;

----
: kb.up ( -- )
 kb.ctrl? IF 
  kb.shift? IF act-first-blk ELSE act-cur-line0 THEN
 ELSE 
  act-cur-up 
 THEN ;

: kb.down ( -- )
 kb.ctrl? IF
  kb.shift? IF act-last-blk ELSE act-cur-line15 THEN
 ELSE
  act-cur-down
 THEN ;
----
: kb.home ( -- ) SAVE-BUFFERS show-current-block ;
: kb.return ( -- ) act-cur-bol-newline ;
: kb.ins ( -- ) ;
: kb.del ( -- ) ;
----

: putchar-into-buffer ( ch -- ) 
  current-block @ block txt-rowcol>offset +
  c! UPDATE ;

----

: act-menu ( -- ) 
 true editor-quit ! ;

: act-accept-char ( ch -- )
  txt-col @ #max-txt-col <= IF
    dup putchar-into-buffer
    emit
    txt-col ++
  THEN
 ;

----

decimal 
: accept-char? ( ch -- bool) 
  BL >= ;

: act-edit-default ( key -- key )
  dup accept-char? IF 
    dup act-accept-char cursor.update
  THEN ;

----

: do-edit ( -- )
  key
  dup #key-esc    = if act-menu  else
  dup #key-up     = if kb.up     else
  dup #key-down   = if kb.down   else
  dup #key-left   = if kb.left   else
  dup #key-right  = if kb.right  else
  dup #key-home   = if kb.home   else
  dup #key-return = if kb.return else
  dup #key-ins    = if kb.ins    else
  dup #key-del    = if kb.del    else
  act-edit-default
  then then then then then then then then then
  drop ;
----



: blk-load ( n -- )
 dup current-block !
 block buf !
;
----
\ init

: jed-ini ( -- )
 80cols? NOT ABORT" JED requires 80 columns"
 0 txt-row !
 0 txt-col !
 0 current-block !
 false editor-quit !
 vt.cur-half
;
----
\ finish
: jed-finish ( -- )
 vt.cls
 vt.cur-show
 SAVE-BUFFERS
;

----
\ Main JED word

: jed ( n -- )
  jed-ini
  vt.cur-hide vt.cls scr.draw 
  vt.cur-show cursor.update
  blk-load show-current-block
  \ enter-edit-state
  begin
    do-edit
  \  what-state @ execute 
  editor-quit @ until
  jed-finish ;

----
