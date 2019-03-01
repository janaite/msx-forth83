----

FORTH definitions
MSX also FORTH

decimal 2 capacity 1- thru


----
hex

variable FLASH-SLOTID

: flash! ( addr b -- )
   FLASH-SLOTID @ -rot
   ( slot addr b -- ) wrslt ;

: flash@ ( addr -- b )
   FLASH-SLOTID @ swap
   ( slot addr -- b ) rdslt ;
----

: flashCmd2! ( b -- )
   55 AAA flash!
   55 2AA flash!
   555 flash! ;

: flashId ( -- manufactureid deviceid )
   90 flashCmd2! \ manufacturer id
   00 flash@
   90 flashCmd2! \ device id
   01 flash@ ;
----

2 0 slotid FLASH-SLOTID !
decimal
----
