
----
\ wipe stack when finished stacking random numbers
: wipe depth 0 do drop loop ;

\ testing random number generators (1/2)
: test-rnd
  cr ." 8-bit random number gen + refresh register / seedc=1"
  cr 1 rnd.seedc ! 24 0 do rnd.rregc loop .S wipe
  cr ." 16-bit random number generator / seed=5" cr
  5 rnd.seed ! 24 0 do rnd.val loop .S wipe ;
