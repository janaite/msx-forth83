rnd random number generators
from https://www.cpcwiki.eu/index.php/Programming:Random_Number_Generator
----

decimal 2 capacity 1- thru

----
\ z80 unique instructions not found in 8080 assembly
hex : (ldA,R)     0ed c, 5f c, ; immediate
hex : (sbcHL,DE)  0ed c, 52 c, ; immediate
----
\ seed of the 8-bit random number generator
variable rnd.seedc

\ random 8-bit number generator using refresh register (1/2)
hex code rnd.rregc ( -- c )
  rnd.seedc lhld       \ ld lh,(rnd.seedc)
  (ldA,R)              \ ld a,r
  a d mov              \ ld d,a
  a e mov              \ ld e,a
  d dad                \ add hl,de
  l xra                \ xor l
  a add                \ add a
----
\ random 8-bit number generator using refresh register (2/2)
  h xra                \ xor h
  a l mov              \ ld l,a
  0 h mvi              \ ld h,0
  rnd.seedc shld       \ ld (rnd.seedc), hl
  a l mov              \ ld l,a
  h push               \ push hl
  next
end-code
----
\ seed of the 16-bit random number generator
variable rnd.seed

\ random 16-bit number generator (1/2)
hex code rnd.val ( -- n )
  0ed c, 5b c, rnd.seed ,   \ ld de,(rnd.seed)
  d a mov                   \ ld a,d
  e h mov                   \ ld h,e
  0fd l mvi                 \ ld l,0fd
  a ora                     \ or a
  (sbcHL,DE)                \ sbc hl,de
  0 sbi                     \ sbc a,0
  (sbcHL,DE)                \ sbc hl,de
----
\ random 16-bit number generator (2/2)
  0 d mvi                   \ ld d,0
  d sbb                     \ sbc a,d
  a e mov                   \ ld e,a
  (sbcHL,DE)                \ sbc hl,de
  cs if h inx then          \ if carry then inc hl
  rnd.seed shld             \ ld (rnd.seed),hl
  h push                    \ push hl
  next
end-code
----
