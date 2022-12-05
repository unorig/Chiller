..\Assemblers\64tass\64tass.exe -a "chill.prg_64tass.S" -o "chill_compiled.prg"
..\Tools\exomizer.exe sfx $0818 -x 1 "chill_compiled.prg" -o "chill_packed.prg" -p 1
..\Emulators\C64Debugger\C64Debugger.exe -wait 2500 -autojmp -prg "chill_packed.prg"