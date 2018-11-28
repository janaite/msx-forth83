# MSX with Forth83

## Introduction
When you take a clever and exotic language like Forth and adds up with a really well thought computer standard like MSX you'll get an enjoyable thing to hack. It's a good toy to mess around and learn about hardware and MSX architecture.

It's far from being complete, but I'm sharing what I have so far hoping to encourage others to do his own experiments with the FORTH language in MSX world. It's fun!

Give it a try, you may like it!!!

## Usage

<span style="color:red"> **Warning:** This is a working in progress. Consider it alpha state software.</span>

As I don't have a good grasp about the text editor inside Forth I choose to edit forth source inside a normal text editor and after convert it into BLK file format. I made a simple tool to do this, it's called "4th-txt". It takes text from stdin and generates at stdout text filled with spaces, without CR CR/LF, inside a matrix od 64 rows by 16 cols (what Forth calls _a block_). To mark blocks, use "```----```" in the beginning of any line.

The Makefile should create all necessary files, just type:

> make all

It should generate all *.blk files into /dist directory. 
Only copy them to your Forth83 instalation directory and have fun!

I'm using Forth 83 labeled F83v2-80 developed by Henry Laxen and Michael Perry and distributed inside "f83v2-80.ark" (MD5: 8c5017e406add5aa0dcd9e99a2514bc2). I have a mirror of it into https://github.com/janaite/forth83-80

Inside F83, just open the file with:
> OPEN filename.blk

After the file was opened, type 
> OK

the word "OK" will load screen number 1 that will perform a chain load. Just wait, it could be a little time-consuming.

To save a new Forth system with all words compiled inside it, type

> SAVE-SYSTEM newname.com

To exit Forth system and return to command shell, type

> BYE

## Thanks

I would like to thank 
* Forth Interest Group (_FIG_) because of their efforts in Forth's history preservation
* Henry Laxen and Michael Perry for their excellent Forth 83 implementation
* Dr. Chen-hanson Ting for his texts about Forth, almost every reference about Forth83 that I read was written by him.

---
JANAITE (27-nov-2018)