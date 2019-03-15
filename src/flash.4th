----

FORTH definitions
MSX also FORTH

decimal 2 capacity 1- thru


----
hex

variable FLASH-SLOTID

: flash! ( b addr -- )
   swap
   FLASH-SLOTID @ -rot
   ( slot addr b -- ) wrslt ;

: flash@ ( addr -- b )
   FLASH-SLOTID @ swap
   ( slot addr -- b ) rdslt ;
----

hex
: flashCmd! ( b -- )
   AA 0555 flash!
   55 02AA flash!
   ( b ) 0555 flash! ;

: flashAuto ( -- )
   90 flashCmd! ;

: flashAutoExit ( -- )
   F0 0000 flash! ;
----

hex
: flashId ( -- manufactureid deviceid )
   flashAuto
   00 flash@     \ manufacturer id
   01 flash@     \ device id
   flashAutoExit ;
----
\ flashErase ( -- )

hex
: flashErase ( -- )
   80 flashCmd!
   AA 0555 flash!
   55 02AA flash!
   30 0000 flash! \ always 0
;

----
\ timeout?(v -- f), dq7equal (u u -- f)

hex
: timeout? ( value -- f)
   \ verify bit5
   20 and 0<> ;

: dq7equal ( v1 v2 -- f)
   80 and swap
   80 and = ;
----
\ waitWrite ( value addr -- f)
hex
\ wait for write process
\ return: T if ok, F if timeout
: waitWrite ( value addr -- f )
   \ wait for DQ7 equal bit7 value
   \ or timeout DQ5=0
   begin
      ( v a --)
      2dup flash@ ( v a old new -- )
      dup timeout? ( v a old new f -- )
      -rot ( v a f old new -- )
      dq7equal ( v a f f -- )
   or until
   ( v a ) swap drop
   flash@ timeout? not ;
----
\ flashWR! ( b addr -- f)

hex

: (flashWR!) ( b addr -- )
   A0 flashCmd!
   flash! ;

: flashWR! ( b addr -- f)
   2dup 
   (flashWR!)
   waitWrite ;
----
decimal
2 0 slotid FLASH-SLOTID !

hex
flashId ( -- 01 A4 ) .s
----
