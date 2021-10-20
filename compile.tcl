set blk_files [list shift.blk msxbios.blk vt52.blk grp.blk debug.blk psg.blk vtx1.blk vgr1.blk]

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
# Get current line on terminal
#

proc get_current_line {} {
  set nl [string last "\n" [get_screen]]
  return [string range [get_screen] [expr $nl + 1] end]
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
# Wait for response on last line
#

proc wait_response {msg cmd} {
  if {[string last $msg [get_last_line]] >= 0} {
    message "*match*"
    $cmd
  } elseif {[llength $cmd] > 0} {
    #message "*after time 5 wait_response \"$msg\" $cmd"
    after time 5 [list wait_response "$msg" $cmd]
  }
}

#
# Chain of reactions
#

proc call_forth83 {} {
  message "Calling Forth83..."
  type "F83\r"
  wait_response "Version 2.1.0 Modified 01Jun84" open_blk_file
}

proc open_blk_file {} {
  global blk_files
  set path [lindex $blk_files 0]
  set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]

  message "Opening $filename..."
  type "OPEN $filename\r"
  wait_response "OPEN $filename  ok" compile
}

proc compile {} {
  global blk_files
  set path [lindex $blk_files 0]
  set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]
  message "Compiling $filename..."
  type "OK\r"
  wait_response "OK  ok" summarize
}

proc summarize {} {
  global blk_files
  set blk_files [lrange $blk_files 1 end]
  message "Done!"

  if {[llength $blk_files] > 0} {
    open_blk_file
  } else {
    save_system
  }
}

proc save_system {} {
  message "Writing F83MSX.COM..."
  type "SAVE-SYSTEM F83MSX.COM\r"
  wait_response "SAVE-SYSTEM F83MSX.COM  ok" {bye}
}

proc bye {} {
  message "Closing Forth83..."
  type "BYE\r"
  wait_response "Pages" {replace_autoexec}
}

proc replace_autoexec {} {
  message "Replacing AUTOEXEC.BAT..."
  type "COPY AUTOEXEC.BA2 AUTOEXEC.BAT\r"
  wait_response "1 file copied" {done}
}

proc done {} {
  message "Finished!"
  quit
}

set renderer none
machine C-BIOS_MSX2+
ext ide

set power off
diskmanipulator create hd.dsk -dos1 32M
hda hd.dsk
diskmanipulator format hda -dos1
diskmanipulator import hda dsk/ [glob -type f dist/*.blk]
diskmanipulator dir hda
message "hd.dsk created"
set power on

# Speed up boot
set save_settings_on_exit off
set speed 9999
set fullspeedwhenloading on

# Debug
ext debugdevice
set debugoutput stdout
#debug set_watchpoint write_io {0x2f} {} {message "$::wp_last_value received from debugdevice"}

message "Detecting boot..."
wait_boot call_forth83
