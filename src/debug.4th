\ debugdevice

----

decimal 2 capacity 1- thru

----
hex code _debugmode ( byte -- )
   E1 C,              \ POP HL
   7D C,              \ LD A, L
   D3 C, 2E C,        \ OUT 2E, A
   next
end-code

: debugmode cr ." Sending byte " dup . ." to debug device at #2e..." _debugmode ;

----
hex code _debugc ( byte -- )
   E1 C,              \ POP HL
   7D C,              \ LD A, L
   D3 C, 2F C,        \ OUT 2F, A
   next
end-code

: debugc cr ." Sending " dup emit ."  to debug device at #2f..." _debugc ;

----
decimal

: debugtest
   31 debugmode \ set debugdevice to verbose mode
   65 debugc ;  \ prints A to stdout
