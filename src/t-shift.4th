
----
hex 
: test1
  AF53 1LSHIFT 5EA6 <> abort" error 1LSHIFT"
  AF53 2LSHIFT BD4C <> abort" error 2LSHIFT"
  AF53 3LSHIFT 7A98 <> abort" error 3LSHIFT"
  AF53 4LSHIFT F530 <> abort" error 4LSHIFT"
  AF53 5LSHIFT EA60 <> abort" error 5LSHIFT"
  AF53 6LSHIFT D4C0 <> abort" error 6LSHIFT"
  AF53 7LSHIFT A980 <> abort" error 7LSHIFT"
  AF53 8LSHIFT 5300 <> abort" error 8LSHIFT"
;
-->
----
hex
: test2
  AF53 9LSHIFT  A600 <> abort" error 9LSHIFT"
  AF53 10LSHIFT 4C00 <> abort" error 10LSHIFT"
  AF53 11LSHIFT 9800 <> abort" error 11LSHIFT"
  AF53 12LSHIFT 3000 <> abort" error 12LSHIFT"
  AF53 13LSHIFT 6000 <> abort" error 13LSHIFT"
  AF53 14LSHIFT C000 <> abort" error 14LSHIFT"
  AF53 15LSHIFT 8000 <> abort" error 15LSHIFT"
;
-->
----

hex
: test3
 A5DE 1RSHIFT 52EF <> abort" error 1RSHIFT"
 A5A5 2RSHIFT 2969 <> abort" error 2RSHIFT"
 A5A5 3RSHIFT 14B4 <> abort" error 3RSHIFT"
 A5A5 4RSHIFT 0A5A <> abort" error 4RSHIFT"
 A5A5 5RSHIFT 052D <> abort" error 5RSHIFT"
 A5A5 6RSHIFT 0296 <> abort" error 6RSHIFT"
 A5A5 7RSHIFT 014B <> abort" error 7RSHIFT"
 ABCD 8RSHIFT 00AB <> abort" error 8RSHIFT"
;
-->
----

hex
: test4 
 A5DE  9RSHIFT 0052 <> abort" error 9RSHIFT"
 A5DE 10RSHIFT 0029 <> abort" error 10RSHIFT"
 A5DE 11RSHIFT 0014 <> abort" error 11RSHIFT"
 A5DE 12RSHIFT 000A <> abort" error 12RSHIFT"
 A5DE 13RSHIFT 0005 <> abort" error 13RSHIFT"
 A5DE 14RSHIFT 0002 <> abort" error 14RSHIFT"
 A5DE 15RSHIFT 0001 <> abort" error 15RSHIFT"
;
-->
----

hex
: test-shift ( --)
  ." testing LSHIFT and RSHIFT" 
  test1 test2 test3 test4 20 emit ." PASS! " ;

test-shift
