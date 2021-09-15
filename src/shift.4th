\ Shift shift shift... everywhere for everybody

----

\ All routines are based on
\ REF: https://www.chilliant.com/z80shift.html

decimal 2 capacity 1- thru


----

code 1LSHIFT ( u -- u)
 H POP
 H DAD   \  ADD HL,HL
 H PUSH
 next
end-code
----

code 2LSHIFT ( u -- u)
 H POP
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H PUSH
 next
end-code
----

code 3LSHIFT ( u -- u)
 H POP
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H PUSH
 next
end-code
----

code 4LSHIFT ( u -- u)
 H POP
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H PUSH
 next
end-code
----

code 5LSHIFT ( u -- u)
 H POP
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H PUSH
 next
end-code
----

code 6LSHIFT ( u -- u)
 H POP
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H DAD   \  ADD HL,HL
 H PUSH
 next
end-code
----

code 7LSHIFT ( u -- u)
 H POP
 H DAD H DAD
 H DAD H DAD
 H DAD H DAD
 H DAD
 H PUSH
 next
end-code
----

code 8LSHIFT ( u -- u)
 H POP
 L H MOV   \ LD H, L
 0 L MVI   \ LD L, 0
 H PUSH
 next
end-code
----

code 9LSHIFT ( u -- u)
 H POP
 L H MOV   \ LD H, L
 0 L MVI   \ LD L, 0
 H DAD
 H PUSH
 next
end-code
----

code 10LSHIFT ( u -- u)
 H POP
 L A MOV   \ LD  A, L
 A ADD     \ ADD A, A
 A ADD     \ ADD A, A
 A H MOV   \ LD  H, A
 0 L MVI   \ LD  L, 0
 H PUSH
 next
end-code
----

code 11LSHIFT ( u -- u)
 H POP
 L A MOV   \ LD  A, L
 A ADD     \ ADD A, A
 A ADD     \ ADD A, A
 A ADD     \ ADD A, A
 A H MOV   \ LD  H, A
 0 L MVI   \ LD  L, 0
 H PUSH
 next
end-code
----

code 12LSHIFT ( u -- u)
 H POP
 L A MOV   \ LD  A, L
 A ADD     \ ADD A, A
 A ADD     \ ADD A, A
 A ADD     \ ADD A, A
 A ADD     \ ADD A, A
 A H MOV   \ LD  H, A
 0 L MVI   \ LD  L, 0
 H PUSH
 next
end-code
----

hex code 13LSHIFT ( u -- u)
 H POP
 L A MOV  \ LD A, L
 RRC      \ RRCA
 RRC      \ RRCA
 RRC      \ RRCA
 E0  ANI  \ AND 224
 A H MOV  \ LD H, A
 0 L MVI  \ LD L, 0
 H PUSH
 next
end-code
----

hex code 14LSHIFT ( u -- u)
 H POP
 L A MOV  \ LD A, L
 RRC      \ RRCA
 RRC      \ RRCA
 E0  ANI  \ AND 224
 A H MOV  \ LD H, A
 0 L MVI  \ LD L, 0
 H PUSH
 next
end-code
----

hex code 15LSHIFT ( u -- u)
 H POP
 L A MOV
 RAR
 RAR
 80 ANI
 A H MOV
 0 L MVI
 H PUSH
 next
end-code
----

hex code 1RSHIFT
 H POP
 H A MOV
 A ANA
 RAR
 A H MOV
 L A MOV
 RAR
 A L MOV
 H PUSH
 next
end-code
----

code 4RSHIFT
 H POP
 A XRA    \ XOR A
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H DAD RAL
 H DAD RAL
 H DAD RAL
 H L MOV  \ LD L, H
 A H MOV  \ LD H, A
 H PUSH
 next
end-code
----

code 5RSHIFT ( u -- u)
 H POP
 A XRA    \ XOR A
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H L MOV  \ LD L, H
 A H MOV  \ LD H, A
 H PUSH
 next
end-code
----

code 6RSHIFT ( u -- u)
 H POP
 A XRA    \ XOR A
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H L MOV  \  LD L, H
 A H MOV  \ LD H, A
 H PUSH
 next
end-code
----

code 7RSHIFT ( u -- u)
 H POP
 A XRA    \ XOR A
 H DAD    \ ADD HL, HL
 RAL      \ RLA
 H L MOV  \ LD L, H
 A H MOV  \ LD H, A
 H PUSH
 next
end-code
----

code 8RSHIFT ( u -- u)
 H POP
 H L MOV
 0 H MVI
 H PUSH
 next
end-code
----

hex code 9RSHIFT ( u -- u)
 H POP
 H A MOV
 0 H MVI
 RRC
 7F ANI
 A L MOV
 H PUSH
 next
end-code
----

hex code 10RSHIFT ( u -- u)
 H POP
 H A MOV
 0 H MVI
 RRC
 RRC
 3F  ANI
 A L MOV
 H PUSH
 next
end-code
----

hex code 11RSHIFT ( u -- u)
 H POP
 H A MOV
 0 H MVI
 RRC
 RRC
 RRC
 1F  ANI
 A L MOV
 H PUSH
 next
end-code
----

hex code 12RSHIFT ( u -- u)
 H POP
 H A MOV  \ LD A, H
 RAR      \ RRA
 RAR      \ RRA
 RAR      \ RRA
 RAR      \ RRA
 0F  ANI  \ AND 15
 A L MOV  \ LD L, A
 0 H MVI  \ LD H, 0
 H PUSH
 next
end-code
----

hex code 13RSHIFT ( u -- u)
 H POP
 H A MOV  \  LD A, H
 RAL RAL
 RAL RAL
 7 ANI    \  AND 7
 A L MOV  \  LD L, A
 0 H MVI  \  LD H, 0
 H PUSH
 next
end-code
----

hex code 14RSHIFT ( u -- u)
 H POP
 H A MOV  \  LD A, H
 RAL RAL RAL
 3 ANI    \  AND 3
 A L MOV  \  LD L, A
 0 H MVI  \  LD H, 0
 H PUSH
 next
end-code

----

hex code 15RSHIFT ( u -- u)
 H POP
 H A MOV  \  LD A, H
 RAL RAL
 1 ANI    \  AND 1
 A L MOV  \  LD L, A
 0 H MVI  \  LD H, 0
 H PUSH
 next
end-code
----

hex code 2RSHIFT
 H POP
 CB C, 3C C, \ SRL H
 CB C, 1D C, \ RR L
 CB C, 3C C, \ SRL H
 CB C, 1D C, \ RR L
 H PUSH
 next
end-code
----

hex code 3RSHIFT
 H POP
 CB C, 3C C, \ SRL H
 CB C, 1D C, \ RR L
 CB C, 3C C, \ SRL H
 CB C, 1D C, \ RR L
 CB C, 3C C, \ SRL H
 CB C, 1D C, \ RR L
 H PUSH
 next
end-code
----

hex
: none ;

: TAB: CREATE DOES> SWAP 0F AND 2* + @ ;

----

TAB: LSHIFT-TAB
 '  NONE ,
 '  1LSHIFT , '  2LSHIFT , '  3LSHIFT , '  4LSHIFT ,
 '  5LSHIFT , '  6LSHIFT , '  7LSHIFT , '  8LSHIFT ,
 '  9LSHIFT , ' 10LSHIFT , ' 11LSHIFT , ' 12LSHIFT ,
 ' 13LSHIFT , ' 14LSHIFT , ' 15LSHIFT ,

: LSHIFT ( u n -- u)
  LSHIFT-TAB EXECUTE ;
----

TAB: RSHIFT-TAB
 '  NONE ,
 '  1RSHIFT , '  2RSHIFT , '  3RSHIFT , '  4RSHIFT ,
 '  5RSHIFT , '  6RSHIFT , '  7RSHIFT , '  8RSHIFT ,
 '  9RSHIFT , ' 10RSHIFT , ' 11RSHIFT , ' 12RSHIFT ,
 ' 13RSHIFT , ' 14RSHIFT , ' 15RSHIFT ,

: RSHIFT ( u n -- u)
  RSHIFT-TAB EXECUTE ;
----
