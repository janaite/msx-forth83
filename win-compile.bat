FOR %%F in (.\src\*.4th) DO type %%F | .\bin\4th-blk.exe > .\dist\%%~nF.blk
openmsx -script compile.tcl
