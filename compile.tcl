#
# Wait for boot message "BOOT COMPLETED"
# 

proc wait_boot {{command ""}} {
  if {[string first "BOOT COMPLETED" [get_screen]] >= 0} {
    $command
  } else {
    after time 5 "wait_boot {$command}"
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
  set tmp [string range [get_screen] 0 [expr $nl2 - 1]]
  set nl1 [string last "\n" $tmp]
  if {$nl1 < 0} {return ""}
  return [string range $tmp [expr $nl1 + 1] $nl2]
}

#
# Wait for response on last line
#

proc wait_response {message command} {
  if {[string last $message [get_last_line]] >= 0} {
    $command
  } else {
    after time 5 "wait_response {$message} {$command}" 
  }
}

#
# Find string on whole screen
#
proc find_on_screen {message {command ""}} {
  if {[string last $message [get_screen]] >= 0} {
    $command
  } else {
    after time 5 "find_on_screen {$message} {$command}"
  }
}

#
# Chain of reactions
#

proc call_forth83 {} {
  type "F83\r"
  wait_response "Version 2.1.0 Modified 01Jun84" {open_blk_file}
}

proc open_blk_file {} {
  foreach path [forth83/dist/msxbios.blk forth83/dist/vt52.blk] {
    set filename [string toupper [string range $path [expr {[string last "/" $path] + 1}] end]]
    type "OPEN $filename\r"
    wait_response "OPEN $filename  ok" {compile}
  }
}

proc compile {} {
  type "OK\r"
  wait_response "OK  ok" {save_system}
}

proc save_system {} {
  type "SAVE-SYSTEM F83MSX.COM\r"
  wait_response "SAVE-SYSTEM F83MSX.COM  ok" {bye}
}

proc bye {} {
  type "BYE\r"
  wait_response "Pages" {replace_autoexec}
}

proc replace_autoexec {} {
  type "copy AUTOEXEC.BA2 AUTOEXEC.BAT\r"
  wait_response "1 file copied" {done}
}

proc done {} {
  message "Finished!"
  quit
}

#set renderer none
diskmanipulator create forth.dsk 720k -dos1
virtual_drive forth.dsk
diskmanipulator format virtual_drive -dos1
diskmanipulator import virtual_drive dsk/ [glob -type f forth83/dist/*.blk]

machine Sony_HB-F1XV
diska forth.dsk

# Speed up boot
set save_settings_on_exit off
set speed 9999
set fullspeedwhenloading on

wait_boot {call_forth83}
