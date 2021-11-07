#
# Convert 4th files into BLK file format
# used by Forth F83
#
# JANAITE 20181126, 2020
#

FILES  = msxbios.blk
FILES += shift.blk t-shift.blk t-delay.blk
FILES += v9990.blk t-v9990.blk
FILES += msxdos.blk t-msxdos.blk
FILES += jed.blk flash.blk nesman.blk
FILES += vt52.blk grp.blk t-grp.blk
FILES += debug.blk t-debug.blk
FILES += psg.blk t-psg.blk
FILES += vtx1.blk t-vtx.blk
FILES += vgr1.blk t-vgr.blk
FILES += rnd.blk t-rnd.blk

DIST_DIR=dist
CC=gcc
CONVBLK=bin/4th-blk

BLKS=$(addprefix $(DIST_DIR)/, $(FILES))

vpath %.4th src
vpath %.c src

.PHONY : all .DELETE_ON_ERROR
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
	$(RRM) hd.dsk.zip

.PHONY: test
test: dsk
	openmsx -script openmsx.tcl

.PHONY: dsk
dsk: $(CONVBLK) $(BLKS)
	openmsx -script compile.tcl
	@zip hd.dsk.zip hd.dsk
	$(RRM) hd.dsk

