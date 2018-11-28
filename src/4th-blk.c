/*
f83blk	v1.0-beta2

Format input text as a block file without new lines 
with a layout of 16 rows by 64 cols, filled by spaces.
Usefull to convert TXT into BLK file-format used by FORTH-83
implementation by Henry Laxon & Mike Perry

TIP: to mark a new Forth BLOCK, start a line with "----"

USE: f83blk < input.txt > output.blk

by JANAITE 20181120,21

*/

#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/* 
get a line from file (up to buffer size)
RETURN: true=ok / false = end-of-stream
 */
static bool getdata(char *buffer, size_t size, FILE *f) {
		memset(buffer, ' ', size);
		char *status = fgets(buffer, size, f);
		buffer[size - 1] = '\0';
		return status == NULL ? false : true;
}

/*
test if a char is valid or not
RETURN: true=valid char / false=invalid char
*/
static bool isvalidchar(const unsigned char ch) {
	if((ch >= 32) && (ch <= 127))
		return true;
	return false;
}

/*
replace all invalid chars with space
RETURN: number of replacements
*/
static int replaceinvalidchars(char *buffer, size_t size) {
	int i,cnt=0;
	size_t len = strlen(buffer);
	for(i=0; i < (size-1); i++) {
		if (! isvalidchar(buffer[i])) {
			buffer[i] = ' ';
			if(i < len) {
				cnt++;	/* only count valid chars */
			}
		}
	}
	return cnt;
}

/*
test if buffer has a special separator sequence
RETURN: true=yes / false=no
*/
static bool isseparatorseq(const unsigned char *const buf) {
	if ((buf[0] == '-') &&
		(buf[1] == '-') &&
		(buf[2] == '-') &&
		(buf[3] == '-')) 
		return true;
	return false;
}

/*
write chars from buffer into file
*/
static void putdata(char *buffer, size_t size, FILE *f) {
	buffer[size-1] = '\0';
	fputs(buffer, f);
}

/*
MAIN
*/
int main(int argc, char **argv) {
	char buffer[65];

	bool verbose=false;
	unsigned invalidchars=0;
	
	if (argc > 2) {
		fprintf(stderr, "Text to F83 BLK format.\n %s[-v]\n", argv[0]);
		return -1;
	}

	if (argc == 2) {
		if (argv[1][0] == '-' && argv[1][1] == 'v') {
			fprintf(stderr, "VERBOSE MODE ON\n");
			verbose=true;
		}
		else if (argv[1][0] == '-' && argv[1][1] == 'h') {
			fprintf(stderr, "Text to F83 BLK format.\n %s [-v|-h]\n", argv[0]);
			return -1;
		}
		else {
			fprintf(stderr, "\"%s\" invalid option\n", argv[1]);
			return -2;
		}
	}

	unsigned line_in_block=0, block=1, line_input=0;
	do {
		/* reads a line up to 64 chars */
		bool status = getdata(buffer, sizeof(buffer), stdin);
		if (status == false)	/* error reading */
			break;
		
		line_input++;

		if (isseparatorseq(buffer)) {	/* its a special line */
			if(verbose) {
				fprintf(stderr, "line %04d special mark / ", line_input);
			}

			unsigned lines_filled=0;

			/* fill block with spaces to complete 16 rows */
			memset(buffer, ' ', sizeof(buffer));
			buffer[sizeof(buffer)-1] = '\0';
			while(line_in_block++ < 16) {
				putdata(buffer, sizeof(buffer), stdout);
				lines_filled++;
			}

			if(verbose) {
				fprintf(stderr, "block #%04d filled with %04d lines\n", block, lines_filled);
			}
			
			line_in_block=0;
			block++;
			
			continue;
		}

		if (line_in_block >= 16) {
			fprintf(stderr, ">>> ERROR: line %04d overflows 16 rows inside block #%04d <<<\n", line_input, block);
			line_in_block=0;
			block++;
		}
		invalidchars += replaceinvalidchars(buffer, sizeof(buffer));
		putdata(buffer, sizeof(buffer), stdout);
		line_in_block++;

	} while(true);


	/* fill last block with spaces to complete 16 rows */
	memset(buffer, ' ', sizeof(buffer));
	buffer[sizeof(buffer)-1] = '\0';
	while(line_in_block++ < 16) {
		putdata(buffer, sizeof(buffer), stdout);		
	}
	
	/* display summary if in verbose mode */
	if (verbose) {
		fprintf(stderr, "\nF83blk filter results:\n---------\n");
		fprintf(stderr, "Block(s) generated: %04d (0x%04X)\n", block+1, block+1);
		fprintf(stderr, "Invalid chars replaced (includes CR/LF): %04d\n", invalidchars);
	}

	return 0;
}