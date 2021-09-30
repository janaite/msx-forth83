----

decimal 2 capacity 1- thru

----

hex
: charset.addr@ ( -- addr)   F920 @ ;
: charset.slot@ ( -- slotid) F91F C@ ;

----

decimal

\ invert all chars in screen0/40
: VTX1.INVALL
 2048 0 DO
  TXTCGP@ I + VRAM@
  255 XOR
  TXTCGP@ I + VRAM!
 LOOP ;
----

decimal

\ invert a char in screen0/40
: VTX1.INVCH ( ch --)
 8* TXTCGP@ +
 8 0 DO
  DUP VRAM@
  255 XOR ( addr b)
  OVER VRAM!
  1+
 LOOP DROP ;
----

 \ redefines a char in screen0/40
: VTX1.CHAR: ( ch -- )
 CREATE C,
 DOES>
  DUP 1+ SWAP C@ ( from-addr char)
  8* TXTCGP@ +   ( from-addr to-addr)
  8 >VRAM ;
----
