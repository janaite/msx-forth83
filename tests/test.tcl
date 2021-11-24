set blk_files [list shift.blk msxbios.blk vt52.blk grp.blk debug.blk psg.blk vtx1.blk vgr1.blk]
set test_files [glob -type f tests/t-*.blk]
#[message $test_files]

#
# Wait for boot message "BOOT COMPLETED"
#

proc wait_boot {{cmd ""}} {
  if {[string first "BOOT COMPLETED" [get_screen]] >= 0} {
    message "*match*"
    $cmd
  } elseif {$cmd != ""} {
    after time 5 [list wait_boot $cmd]
  }
}

#
# Get last message on terminal
#

proc get_last_line {} {
  set nl2 [string last "\n" [get_screen]]
  if {$nl2 < 0} {return ""}
  set tmp [string range [get_screen] 0 [expr $nl2 - 1]]
  set nl1 [string last "\n" $tmp]
  if {$nl1 < 0} {return ""}
  return [string range $tmp [expr $nl1 + 1] $nl2]
}

#
# Powered up version of type
#

proc _check_type {msg cmd} {
  if {[string last $msg [get_last_line]] >= 0} {
    message "*match*"
    $cmd
  } elseif {[llength $cmd] > 0} {
    after time 5 [list _check_type "$msg" $cmd]
  }
}

proc type! {str msg cmd} {
  type "\b$str\r"
  after time 5 [list _check_type "$msg" $cmd]
}

#
# Chain of reactions
#

proc call_forth83 {} {
  message "Calling Forth83..."
  type! "F83" "Version 2.1.0 Modified 01Jun84" open_blk_file
}

proc open_blk_file {} {
  global blk_files
  set path [lindex $blk_files 0]
  set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]

  message "Opening $filename..."
  type! "OPEN $filename" "OPEN $filename  ok" compile
}

proc compile {} {
  global blk_files
  set path [lindex $blk_files 0]
  set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]
  message "Compiling $filename..."
  type! "OK" "OK  ok" summarize
}

proc summarize {} {
  global blk_files
  set blk_files [lrange $blk_files 1 end]
  message "Done!"

  if {[llength $blk_files] > 0} {
    open_blk_file
  } else {
    test_system
  }
}

proc test_system {} {
  message "Testing modules..."
  # >>Future tests go here<<
  message "passed!"
  bye
}

proc bye {} {
  message "Closing Forth83..."
  type! "BYE" "Pages" done
}

proc done {} {
  message "Finished!"
  quit
}

set renderer none
machine C-BIOS_MSX2+
ext ide

set power off
diskmanipulator create tests/hd.dsk 32M
hda tests/hd.dsk
diskmanipulator import hda dsk/ [glob -type f dist/*.blk] [glob -type f tests/*.blk]
message "hd.dsk created"
set power on

# Debug
ext debugdevice
set debugoutput stdout
#debug set_watchpoint write_io {0x2f} {} {message "$::wp_last_value received from debugdevice"}

# Speed up boot
set save_settings_on_exit off
set fullspeedwhenloading on
set speed 9999

message "Detecting boot..."
wait_boot call_forth83
