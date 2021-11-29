set fd [open "./blkfiles" "r"]
set blkfiles [read $fd]
#set blkfiles [list shift.blk msxbios.blk vt52.blk grp.blk debug.blk psg.blk vtx1.blk vgr1.blk]

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
  global blkfiles
  set path [lindex $blkfiles 0]
  set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]

  message "Opening $filename..."
  type! "OPEN $filename" "OPEN $filename  ok" compile
}

proc compile {} {
  global blkfiles
  set path [lindex $blkfiles 0]
  set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]
  message "Compiling $filename..."
  type! "OK" "  ok" summarize
}

proc summarize {} {
  global blkfiles
  set blkfiles [lrange $blkfiles 1 end]
  message "Done!"

  if {[llength $blkfiles] > 0} {
    open_blk_file
  } else {
    save_system
  }
}

proc save_system {} {
  message "Writing F83MSX.COM..."
  type! "SAVE-SYSTEM F83MSX.COM" "SAVE-SYSTEM F83MSX.COM  ok" bye
}

proc bye {} {
  message "Closing Forth83..."
  type! "BYE" "Pages" replace_autoexec
}

proc replace_autoexec {} {
  message "Replacing AUTOEXEC.BAT..."
  type! "COPY AUTOEXEC.BA2 AUTOEXEC.BAT" "1 file copied" done
}

proc done {} {
  message "Finished!"
  quit
}

set renderer none
machine C-BIOS_MSX2+
ext ide

set power off
diskmanipulator create hd.dsk 32M
hda hd.dsk
diskmanipulator import hda dsk/ [glob -type f dist/*.blk]
message "hd.dsk created"
set power on

# Speed up boot
set save_settings_on_exit off
set fullspeedwhenloading on
set speed 9999

# Debug
#ext debugdevice
#set debugoutput stdout
#debug set_watchpoint write_io {0x2f} {} {message "$::wp_last_value received from debugdevice"}

message "Detecting boot..."
wait_boot call_forth83
