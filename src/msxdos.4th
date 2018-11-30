
----

FORTH definitions
2 14 thru

0 constant #FMODE-RW
1 constant #FMODE-RO
2 constant #FMODE-WO
4 constant #FMODE-RW-INH
5 constant #FMODE-RO-INH
6 constant #FMODE-WO-INH

----
: asciizlen ( strz -- u )
  0 swap
  begin dup c@ 0<> while
    1+	         \ inc addr
    swap 1+ swap  \ inc counter
  repeat drop ;

: typez ( strz -- ) 
  begin dup c@ dup 0<> while
    emit 1+
  repeat drop drop ;
----

\ DOSVER ( --  kernelversionbcd dos2sysversionbcd )

hex code DOSVER ( -- msxdoskernel msxdos2sys )
  B  PUSH
  6F C MVI \ fn=43h
  5  CALL  \ bc=kernel, de=sys
  B  H MOV
  C  L MOV
  B  POP
  H  PUSH
  D  PUSH
  next
end-code
----

\ msx-dos kernel version major
hex
: dosverkmaj ( -- u )
  dosver drop flip FF and ;

: msxdos1? ( -- f )
  dosverkmaj 2 u< ;

: msxdos2? ( -- f )
  dosverkmaj 2 = ;

----
hex code (FOPEN) ( mode cstr -- handle error )
  D POP  H POP  B  PUSH
  H  A MOV \ A=mode
  43 C MVI \ fn=43h
  5  CALL  \ ret: A=error B=handle
  0  D MVI
  A  E MOV \ E = error
  0  H MVI
  B  L MOV \ L = handle
  B  POP
  H  PUSH  D  PUSH
  next
end-code
----

\ Add a null at the end of string
: >asciiz ( c-addr u -- )
  + 0 swap c! ;

\ copy string into PAD area
: >pad ( c-addr u -- )
  pad swap ( from to len -- ) move ;

\ copy string into PAD area as a null terminated
: >padz ( c-addr u -- )
  tuck >pad 
  pad ( u c-addr ) swap >asciiz ;
----
\ FOPEN" ( mode -- handle error <string> filename.ext" )

: FOPENX" ( mode -- )
  ascii " parse ( c-addr u )
  >padz
  pad (FOPEN) ;

: FOPEN" ( -- )
  0 FOPENX" ;

: FOPEN ( cstr mode -- handle error )
  -rot >padz
  pad (FOPEN)  ;
----

hex code FCLOSE ( handle -- error )
  D POP   B PUSH
  E  B MOV \ B=handle
  45 C MVI \ fn=45h _CLOSE
  5  CALL  \ ret: A=error
  0  D MVI
  A  E MOV \ E = error
  B  POP
  D  PUSH
  next
end-code
----

hex code ENSURE ( handle -- error )
  D POP   B PUSH
  E  B MOV \ B=handle
  46 C MVI \ fn=46h
  5  CALL  \ ret: A=error
  0  D MVI
  A  E MOV \ E = error
  B  POP
  D  PUSH
  next
end-code
----

hex code FWRITE ( handle addr len -- size error )
  B H MOV  C L MOV  ( IP>HL )
  B POP    D POP    XTHL
  ( stack=IP,BC=len,DE=addr,HL=handle )
  L  A MOV \ handle
  B  H MOV \ HL=len
  C  L MOV
  A  B MOV \ B=handle
  49 C MVI \ fn=49h _WRITE
  5  CALL  \ ret: A=error, HL=size
  0  D MVI
  A  E MOV \ E = error
  B  POP  H  PUSH  D  PUSH
  next
end-code
----

hex code FREAD ( handle addr len -- size error )
  B H MOV  C L MOV  ( IP>HL )
  B POP    D POP    XTHL
  ( stack=IP,BC=len,DE=addr,HL=handle )
  L  A MOV \ handle
  B  H MOV \ HL=len
  C  L MOV
  A  B MOV \ B=handle
  48 C MVI \ fn=48h _READ
  5  CALL  \ ret: A=error, HL=size
  0  D MVI
  A  E MOV \ E = error
  B  POP  H  PUSH  D  PUSH
  next
end-code
----

hex code FCREATE ( cstr mode -- handle error )
  H POP  D POP  B PUSH
  H  B MOV \ B = attributes
  L  A MOV \ A = open mode
  44 C MVI \ fn=44h _CREATE
  5  CALL  \ ret: A=error, B=handle
  0  H MVI
  B  L MOV
  0  D MVI
  A  E MOV \ E = error
  B  POP  H  PUSH  D  PUSH
  next
end-code
----

\ msg in cstr (asciiz)
hex code (EXPLAIN) ( error cstr -- )
  D POP  H POP  B  PUSH
  L  B MOV \ B=error
  66 C MVI \ fn=66h _EXPLAIN
  5  CALL  \ ret: DE=msg
  B  POP
  next
end-code

----
\ EXPLAIN ( error -- c-addr len )

: EXPLAIN ( error -- c-addr len )
  ?dup 0<> if 
    pad (explain) pad dup asciizlen
  else
    pad 0
  then ;
