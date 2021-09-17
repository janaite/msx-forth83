#
# Convert 4th files into BLK file format
# used by Forth F83
#
# JANAITE 20181126, 2020
#

FILES  = msxbios.blk shift.blk t-shift.blk t-delay.blk
FILES += v9990.blk t-v9990.blk
FILES += msxdos.blk t-msxdos.blk
FILES += jed.blk flash.blk nesman.blk
FILES += vt52.blk grp.blk t-grp.blk debug.blk t-debug.blk
FILES += psg.blk t-psg.blk
FILES += sc0.blk t-sc0.blk

DIST_DIR=dist
CC=gcc
CONVBLK=bin/4th-blk

BLKS=$(addprefix $(DIST_DIR)/, $(FILES))

vpath %.4th src
vpath %.c src

.PHONY : all
all: $(CONVBLK) $(BLKS)

$(DIST_DIR)/%.blk: %.4th
	cat $< | $(CONVBLK) > $@

$(CONVBLK): src/4th-blk.c
	$(CC) $< -o $@

RRM = rm -f -r

.PHONY: clean
clean:
	$(RRM) bin/*
	$(RRM) dist/*.blk
	$(RRM) forth.dsk

.PHONY: test
test: dsk
	openmsx -script openmsx.tcl -machine Sony_HB-F1XV -ext video9000 -ext ASCII_MSX-DOS2 -diska forth.dsk

.PHONY: dsk
dsk: $(CONVBLK) $(BLKS)
	openmsx -script compile.tcl -machine Sony_HB-F1XV
