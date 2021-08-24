\ MSX terminal VT-52 all commands

----

decimal 2 4 thru

----

: esc. [ hex ] 1B emit ;

: vt.pos ( line column -- ) 
   [ decimal ]
   32 + swap 32 +
   esc. ascii Y emit emit emit ;
----

: vt.up      esc. ascii A emit ;
: vt.down    esc. ascii B emit ;
: vt.right   esc. ascii C emit ;
: vt.left    esc. ascii D emit ;
: vt.cls     esc. ascii E emit ;
: vt.home    esc. ascii H emit ;
: vt.clsend  esc. ascii J emit ;
: vt.clseol  esc. ascii K emit ;
: vt.ins     esc. ascii L emit ;
: vt.del     esc. ascii M emit ;
: vt.clshome esc. ascii j emit ;
: vt.clsline esc. ascii l emit ;
----

: vt.full  esc. ascii x emit ascii 4 emit ;
: vt.half  esc. ascii y emit ascii 4 emit ;
: vt.hide  esc. ascii x emit ascii 5 emit ;
: vt.show  esc. ascii y emit ascii 5 emit ;

----
