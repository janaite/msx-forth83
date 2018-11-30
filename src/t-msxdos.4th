----

MSXDOS

decimal 2 4 thru

----

: arq1 " msxdos.blk" ;
: arq2 " none.xxx" ;

: (tt)
  ?dup 0<> if
    explain type drop
  else
    fclose
      explain type
  then ;

: t1 arq1 #FMODE-RO fopen (tt) ;
: t2 arq2 #FMODE-RO fopen (tt) ;
----

: arq3 " test.txt" ;

: str1 " ###This is a test string ###" ;

: t3 arq3 #FMODE-RW fcreate (tt) ;

: error? ?dup 0<> if explain type drop then ;


----

\ test write into a file
decimal
: t4 arq3 #FMODE-WO fcreate error?
  dup str1 fwrite error? ." wrote " . ." byte(s)"
  fclose error? ;

\ test read from a file
decimal
: t5 arq3 #FMODE-RO fopen error?
  dup pad 28 fread error? ." read " . ." byte(s) "
  fclose error? 
  pad 28 type ;
