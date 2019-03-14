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
hex

: flashWR! ( b addr -- )
   A0 flashCmd!
   flash!
;
----

hex
: flashErase ( -- )
   80 flashCmd!
   AA 0555 flash!
   55 02AA flash!
   30 0000 flash! \ always 0
;

----
decimal
2 0 slotid FLASH-SLOTID !

hex
flashId ( -- 01 A4 ) .s
----
