Testing routines for CASE.BLK

----
: {13,19}  13 19 BETWEEN ;

: SELECT ( n -- )
 CASE
  1     = OF       ." Got first!"             CR  .ENDOF
  1 1+  = OF       ." Got" 2 .r               CR   ENDOF
  2 2 + = OF       ." Got" 2 .r               CR   ENDOF
  {13,19} OF  0 .r ."  y.o. is a teenager!"   CR   ENDOF
  0 >     OF  0 .r ."  is bigger than zero."  CR   ENDOF
  0 <     OF  0 .r ."  is smaller than zero." CR   ENDOF
  ( default case: )
  ." Sorry, I wasn't expecting <" 0 .r ." >, try again." CR
 ENDCASE ;
-->
----
: TEST
 ." Testing case -1: " -1 SELECT
 ." Testing case  2: "  2 SELECT
 ." Testing case  1: "  1 SELECT
 ." Testing case  4: "  4 SELECT 
 ." Testing case  0: "  0 SELECT
 ." Testing case  3: "  3 SELECT
 ." Testing case 17: " 17 SELECT ;

CR TEST
