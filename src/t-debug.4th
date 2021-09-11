----

decimal
: debugmode cr ." Sending byte "
  dup . ." to debug device at #2e..." omsx.debugmode! ;

: debugc cr ." Sending "
  dup emit ."  to debug device at #2f..." omsx.debug! ;
-->
----

decimal
: debugtest
   31 debugmode \ set debugdevice to verbose mode
   65 debugc    \ prints A to stdout
   65 .debug

   .debug" Debug compiled message"
   65 .debugc
   [ hex ] CAFE .debug
   [ hex ] A5 .debugc" valor teste"
 ;
-->
----

debugtest
