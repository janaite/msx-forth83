
DEFER vdp!
DEFER vdp@

: PC!CUSTOM
  create c,
  does> c@ pc! ;

: PC@CUSTOM
  create c,
  does> c@ pc@ ;



: init
  [ 6 bios-c@ pc@custom vdpdirect@ ]
  [ 7 bios-c@ pc!custom vdpdirect! ]
  ['] vdpdirect@ is vdp@
  ['] vdpdirect! is vdp!
  ;
