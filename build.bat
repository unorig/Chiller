D:\OneDrive\C64\Assemblers\64tass\64tass.exe -a "D:\OneDrive\C64\Chiller\chill.prg_64tass.asm" -o "D:\OneDrive\C64\Chiller\chill_compiled.prg"
D:\OneDrive\C64\Tools\exomizer.exe sfx $0818 -x 1 "D:\OneDrive\C64\Chiller\chill_compiled.prg" -o "D:\OneDrive\C64\Chiller\build\chill_packed.prg" -p 1
del D:\OneDrive\C64\Chiller\chill_compiled.prg
D:\OneDrive\C64\Emulators\RetroDebugger.exe -wait 2500 -autojmp -prg "D:\OneDrive\C64\Chiller\build\chill_packed.prg"
