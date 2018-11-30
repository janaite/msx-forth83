----

2 load

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