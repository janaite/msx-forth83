----

decimal 2 capacity 1- thru

----

hex
ascii B VTX1.CHAR: newB
  FF c, 00 c, 00 c, 00 c,
  00 c, 00 c, 00 c, FF c,
----

: test-vtx1
 screen0/40
 ." ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 chget drop
 ascii A vtx1.invch
 chget drop
 newB
 chget drop
 vtx1.invall
 chget drop
 vtx1.invall ;
----
