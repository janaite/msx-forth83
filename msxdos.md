# MSX-DOS2 WORDS set

| Constant      | File mode           |
|---------------|---------------------|
| #FMODE-RW     | Read and Write mode |
| #FMODE-RO     | Read only mode      |
| #FMODE-WO     | Write only mode     |
| #FMODE-RW-INH | R/W inheritable     |
| #FMODE-RO-INH | R/O inheritable     |
| #FMODE-WO-INH | R/W inheritable     |

**inheritable means**: the file handle will be inherited by a new process created by the "fork" function call (see function 60h). [See more here](http://map.grauw.nl/resources/dos2_functioncalls.php#_OPEN)

## MSX-DOS2 Functions

| forth word| fn  | description
|-----------|-----|-------------------------------------------|
|   -       | 31h |  Get disk parameters
|   -       | 40h |  Find first entry
|   -       | 41h |  Find next entry
|   -       | 42h |  Find new entry
| (FOPEN)   | 43h |  [Open file handle](http://map.grauw.nl/resources/dos2_functioncalls.php#_OPEN)
| (FCREATE) | 44h |  [Create file handle](http://map.grauw.nl/resources/dos2_functioncalls.php#_CREATE)
| FCLOSE    | 45h |  [Close file handle](http://map.grauw.nl/resources/dos2_functioncalls.php#_CLOSE)
| ENSURE    | 46h |  [Ensure file handle](http://map.grauw.nl/resources/dos2_functioncalls.php#_ENSURE)
|    -      | 47h |  Duplicate file handle
| FREAD     | 48h |  [Read from file handle](http://map.grauw.nl/resources/dos2_functioncalls.php#_READ)
| FWRITE    | 49h |  [Write to file handle](http://map.grauw.nl/resources/dos2_functioncalls.php#_WRITE)
|    -      | 4Ah |  Move file handle pointer
|    -      | 4Bh |  I/O control for devices
|    -      | 4Ch |  Test file handle
|    -      | 4Dh |  Delete file or subdirectory
|    -      | 4Eh |  Rename file or subdirectory
|    -      | 4Fh |  Move file or subdirectory
|    -      | 50h |  Get/set file attributes
|    -      | 51h |  Get/set file date and time
|    -      | 52h |  Delete file handle
|    -      | 53h |  Rename file handle
|    -      | 54h |  Move file handle
|    -      | 55h |  Get/set file handle attributes
|    -      | 56h |  Get/set file handle date and time
|    -      | 57h |  Get disk transfer address
|    -      | 58h |  Get verify flag setting
|    -      | 59h |  Get current directory
|    -      | 5Ah |  Change current directory
|    -      | 5Bh |  Parse pathname
|    -      | 5Ch |  Parse filename
|    -      | 5Dh |  Check character
|    -      | 5Eh |  Get whole path string
|    -      | 5Fh |  Flush disk buffers
|    -      | 60h |  Fork a child process
|    -      | 61h |  Rejoin parent process
|    -      | 62h |  Terminate with error code
|    -      | 63h |  Define abort exit routine
|    -      | 64h |  Define disk error handler routine
|    -      | 65h |  Get previous error code
| (EXPLAIN) | 66h |  [Explain error code](http://map.grauw.nl/resources/dos2_functioncalls.php#_EXPLAIN)
|    -      | 67h |  Format a disk
|    -      | 68h |  Create or destroy RAM disk
|    -      | 69h |  Allocate sector buffers
|    -      | 6Ah |  Logical drive assignment
|    -      | 6Bh |  Get environment item
|    -      | 6Ch |  Set environment item
|    -      | 6Dh |  Find environment item
|    -      | 6Eh |  Get/set disk check status
|  DOSVER   | 6Fh |  [Get MSX-DOS version number](http://map.grauw.nl/resources/dos2_functioncalls.php#_DOSVER)
|    -      | 70h |  Get/set redirection status
