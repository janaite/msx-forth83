----

decimal 2 capacity 1- thru

----

decimal
: psg.tone.a! ( 12bits --)
  DUP 00 psg! 8RSHIFT 15 AND 01 psg! ;

: psg.tone.b! ( 12bits --)
  DUP 02 psg! 8RSHIFT 15 AND 03 psg! ;

: psg.tone.c! ( 12bits --)
  DUP 04 psg! 8RSHIFT 15 AND 05 psg! ;

: psg.noise! ( 5bits --)
  31 AND 06 psg! ;
----

decimal
: psg.mixer! ( 6bits --)
  63 AND 128 OR 07 psg! ; \ 10cbacba

: psg.amp.a! ( b --)
  08 psg! ;

: psg.amp.b! ( b --)
  09 psg! ;

: psg.amp.c! ( b --)
  10 psg! ;

----

decimal
: psg.env! ( w --)
  DUP     11 psg!
  8RSHIFT 12 psg! ;

: psg.envshape! ( b --)
  15 AND 12 psg! ;
----
