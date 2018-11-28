#
# Convert 4th files into BLK file format
# used by Forth F83
#
# JANAITE 20181126
#

FILES=msxbios.blk test-sc2.blk v9990.blk

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
	$(RRM) dist/*
