\ Support debugdevice (OpenMSX)

----

decimal 2 capacity 1- thru

----

hex code omsx.debugmode! ( byte -- )
   H   POP   \ POP HL
   L A MOV   \ LD A, L
   2E  OUT   \ OUT 2E, A
   next
end-code

hex code omsx.debug! ( byte -- )
   H   POP            \ POP HL
   L A MOV            \ LD A, L
   2F  OUT            \ OUT 2F, A
   next
end-code

----

hex
: .debugstr ( addr len -- )
  23 omsx.debugmode!
  0 DO dup I + C@ omsx.debug! LOOP DROP
  ascii : omsx.debug! ;

hex
: (.debug")
  R> COUNT 2DUP + >R ( str-addr str-sz -- R: addr sz)
  .debugstr ;

: .debug" ( <string>"" -- )
  compile (.debug") ," ; immediate

----
hex
: .debugc ( byte -- )
 5F omsx.debugmode! omsx.debug! ;

: .debug ( u -- )
 5F omsx.debugmode! DUP
 U2/ U2/ U2/ U2/ U2/ U2/ U2/ U2/ omsx.debug! \ MSB
 omsx.debug!  ;                              \ LSB

----

: (.debugc")
  R> COUNT 2DUP + >R ( str-addr str-sz -- R: addr sz)
  .debugstr
  .debugc ;

: .debugc" ( <string>"" -- )
  compile (.debugc") ," ; immediate
