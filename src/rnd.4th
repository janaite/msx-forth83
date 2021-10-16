rnd random number generators
from https://www.cpcwiki.eu/index.php/Programming:Random_Number_Generator
and  https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random

decimal 2 capacity 1- thru

----
\ z80 unique instructions not found in 8080 assembly
hex : (ldA,R)     0ed c, 5f c, ; immediate
hex : (sbcHL,DE)  0ed c, 52 c, ; immediate
hex : (rlC)       0cb c, 11 c, ; immediate
hex : (rlA)       17 c,        ; immediate
hex : (rlD)       0cb c, 12 c, ; immediate
hex : (rlE)       0cb c, 13 c, ; immediate
hex : (lddr)      0ed c, b8 c, ; immediate
----
\ alloc 64-bit seed used by the lfsr (1+7 bytes)
variable rnd.seed/LFSR 7 allot

\ 8-bit linear feedback shift register generator (1/3)
hex code rnd.lfsr ( -- c )
  b push                     \ push bc
  rnd.seed/LFSR 4 + h lxi    \ ld hl,seed/LFSR + 4
  m e mov                    \ ld e,(hl)
  h inx                      \ inc hl
  m d mov                    \ ld d,(hl)
  h inx                      \ inc hl
  m c mov                    \ ld c,(hl)
  h inx                      \ inc hl
  m a mov                    \ ld a,(hl)
  a b mov                    \ ld b,a
----
\ 8-bit linear feedback shift register generator (2/3)
  (rlE) (rlD)                \ rl e / rl d
  (rlC) (rlA)                \ rl c / rla
  (rlE) (rlD)                \ rl e / rl d
  (rlC) (rlA)                \ rl c / rla
  (rlE) (rlD)                \ rl e / rl d
  (rlC) (rlA)                \ rl c / rla
  a h mov                    \ ld h,a
  (rlE) (rlD)                \ rl e / rl d
  (rlC) (rlA)                \ rl c / rla
  b xra                      \ xor b
  (rlE) (rlD)                \ rl e / rl d
  h xra                      \ xor h
  c xra                      \ xor c
  d xra                      \ xor d
  rnd.seed/LFSR 6 + h lxi    \ ld hl,seed/LFSR + 6
----
\ 8-bit linear feedback shift register generator (3/3)
  rnd.seed/LFSR 7 + d lxi    \ ld de,seed/LFSR + 7
  7 b lxi                    \ ld bc,7
  (lddr)                     \ lddr
  d stax                     \ ld (de),a
  b pop                      \ pop bc
  0 h mvi                    \ ld h,0
  a l mov                    \ ld l,a
  h push                     \ push hl
  next
end-code
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
