Based on Dr. Eaker/Baden/WJR CASE statement, but modified

n CASE                        DUP
    test1 OF ... ENDOF        n test1 IF ... ELSE DUP THEN
    test2 OF ... ENDOF        n test2 IF ... ELSE DUP THEN
    testn OF ... ENDOF        n testn IF ... ELSE DUP THEN
    ... ( default case )      ...
ENDCASE                       DROP
----

decimal 2 capacity 1- thru

----
: CASE     ( n -- n n )
 STATE @ NOT ABORT" Interpreter mode" COMPILE DUP ; IMMEDIATE

: OF       ( n n -- n ) 
 [COMPILE] IF ; IMMEDIATE

: ENDOF    ( -- )
 COMPILE EXIT [COMPILE] ELSE COMPILE DUP [COMPILE] THEN ;
 IMMEDIATE

: .ENDOF      ( n -- )
 COMPILE DROP [COMPILE] ENDOF ; IMMEDIATE

: ENDCASE  ( n -- )
 DROP ;
