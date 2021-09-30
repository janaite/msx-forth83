----

decimal 2 capacity 1- thru

----

decimal

\ invert all chars in GRAPHIC 1 mode
: VGR1.INVALL
 2048 0 DO
  T32CGP@ I + VRAM@
  255 XOR
  T32CGP@ I + VRAM!
 LOOP ;
----

decimal

\ invert a char in GRAPHIC 1 mode
: VGR1.INVCH ( ch --)
 8* T32CGP@ +
 8 0 DO
  DUP VRAM@
  255 XOR ( addr b)
  OVER VRAM!
  1+
 LOOP DROP ;
----

\ redefines a char in screen1 (GRAPHIC 1 mode)
: VGR1.CHAR: ( ch -- )
  CREATE C,
  DOES>
   DUP 1+ SWAP C@ ( from-addr char)
   8* T32CGP@ +   ( from-addr to-addr)
   8 >VRAM ;
----

: VGR1.INI ( --)
  INIT32 ;
----
