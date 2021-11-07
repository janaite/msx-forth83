machine C-BIOS_MSX2+
ext ide
hda hd.dsk.zip

ext debugdevice
set debugoutput stdout

set throttle off
after time 15 "set throttle on"
