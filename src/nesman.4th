----

FORTH definitions
MSX also FORTH

decimal 2 capacity 1- thru


----
hex

: nesman ( fn -- )
   create ,
   does> @
   0E c, c,     \ LD   C, fn
   11 c, 2202 , \ LD   DE,0x2202
   CD c, FFCA , \ call EXTBIO
;

----

decimal

2 nesman (nesman02)
3 nesman (nesman03)
4 nesman (nesman04)
6 nesman (nesman06)
----

hex
code nesman? ( -- subver ver|F )
  B PUSH
  0 A MVI
  1 C MVI
  2202 D LXI
  ffca CALL
  B POP
  D PUSH
  0 D MVI
  A E MOV
  D PUSH
  next
end-code
----

hex
code nesman-info ( -- n1 n2 )
   B PUSH
   (nesman02)
   B H MOV
   A L MOV
   C E MOV
   B POP
   H PUSH
   D PUSH
   next
end-code
----

hex
code blkalloc ( sz -- bseg addr f)
   H POP
   B PUSH   (nesman04) B POP
   0 D MVI  A E MOV    D PUSH   \ bseg
   H PUSH   \ addr
   0 A MVI   RAL    \ CY to A bit0
   0 H MVI   A L MOV  H PUSH \ flag
   next
end-code
----

hex
code blkfree ( bseg addr  -- f )
   H POP  \ HL = addr
   D POP  \ E = bseg
   E A MOV
   B PUSH
   (nesman06)
   B POP
   0 A MVI   RAL    \ CY to A bit0
   0 H MVI   A L MOV  H PUSH \ flag
   next
end-code
----
