#
# Convert 4th files into BLK file format
# used by Forth F83
#
# JANAITE 20181126, 2020
#

FILES = $(patsubst %.4th,%.blk,$(notdir $(wildcard src/*.4th)))
TFILES = $(patsubst %.4th,%.blk,$(notdir $(wildcard tests/*.4th)))
DIST_DIR=dist
TEST_DIR=tests
CC=gcc
CONVBLK=bin/4th-blk

BLKS=$(addprefix $(DIST_DIR)/, $(FILES))
TBLKS=$(addprefix $(TEST_DIR)/, $(TFILES))

vpath %.4th src
vpath %.4th tests
vpath %.c src

.PHONY : all .DELETE_ON_ERROR
all: $(CONVBLK) $(BLKS)

$(DIST_DIR)/%.blk: %.4th
	cat $< | $(CONVBLK) > $@

$(TEST_DIR)/%.blk: %.4th
	cat $< | $(CONVBLK) > $@

$(CONVBLK): src/4th-blk.c
	$(CC) $< -o $@

RRM = rm -f -r

.PHONY: clean
clean:
	$(RRM) bin/*
	$(RRM) tests/*.blk
	$(RRM) tests/hd.dsk.zip
	$(RRM) dist/*.blk
	$(RRM) hd.dsk.zip

.PHONY: test
test: all $(TBLKS)
	openmsx -script tests/test.tcl
	zip tests/hd.dsk.zip tests/hd.dsk
	@$(RRM) tests/hd.dsk

.PHONY: dsk
dsk: $(CONVBLK) $(BLKS)
	openmsx -script compile.tcl
	@zip hd.dsk.zip hd.dsk
	@$(RRM) hd.dsk

