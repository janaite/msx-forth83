----

decimal 2 capacity 1- thru

----

hex
ascii B SC0CHAR: newB 
  FF c, 00 c, 00 c, 00 c,
  00 c, 00 c, 00 c, FF c,
----

: test-sc0
 screen0/40
 ." ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 chget drop 
 ascii A sc0invch
 chget drop
 newB
 chget drop
 sc0invall
 chget drop
 sc0invall ;
----
