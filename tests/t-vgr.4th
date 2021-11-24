----

decimal 2 capacity 1- thru

----

hex
ascii B VGR1.CHAR: newB
  FF c, 00 c, 00 c, 00 c,
  00 c, 00 c, 00 c, FF c,
----

: waitkey ( --)
  CHGET DROP ;

: test-vgr1
 VGR1.INI
 ." ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 waitkey
 ascii A VGR1.INVCH
 waitkey
 newB
 waitkey
 VGR1.INVALL
 chget drop
 VGR1.INVALL ;
----
