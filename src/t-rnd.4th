
----
\ wipe stack when finished stacking random numbers
: wipe depth 0 do drop loop ;

\ testing random number generators (1/2)
: test-rnd
  cr ." 8-bit random number gen + refresh register / seedc=1"
  cr 1 rnd.seedc ! 24 0 do rnd.rregc loop .S wipe
  cr ." 16-bit random number generator / seed=5" cr
  5 rnd.seed ! 24 0 do rnd.val loop .S wipe
  cr ." 8-bit LFSR generator / seed=(a5f9c309d14fee21)" cr
  DP @ >R rnd.seed/LFSR DP ! ( point DP to seed )
  a5 c, f9 c, c3 c, 09 c, d1 c, 4f c, ee c, 21 c, ( write seed )
  R> DP ! ( restore DP pointer )
  24 0 do rnd.LFSR loop .S wipe ;