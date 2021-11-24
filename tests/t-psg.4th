----

decimal 2 capacity 1- thru

----

decimal
\ 440Hz NTSC 3579545
\ P = 3579545/(32*F)

: psg-test1 
  254 psg.tone.a!
  62 psg.mixer!
  15 psg.amp.a!
  CHGET DROP
  0 psg.amp.a!
;
----
