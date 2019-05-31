@ECHO OFF
SET zip=7za.exe a -tzip -mx9
SET AutoHotkeyPath=C:\Program Files (x86)\AutoHotkey

@ECHO Cleanup...
DEL /F /Q FNVSGM.exe
DEL /F /Q FNVSGM.zip
DEL /F /Q FNVSGM-Src.zip

@ECHO Compiling Script...
"%AutoHotkeyPath%\Compiler\Ahk2Exe.exe" /in FNVSGM.ahk /out FNVSGM.exe /icon "FNV icon.ico"

@ECHO Creating Release Archive...
%zip% FNVSGM.zip FNVSGM.exe
%zip% FNVSGM.zip FNVSGMreadme.txt
%zip% FNVSGM.zip Standard.jpg
%zip% FNVSGM.zip *.ahk
%zip% FNVSGM.zip *.ico

@ECHO Creating Source Archive...
%zip% FNVSGM-Src.zip FNVSGMreadme.txt
%zip% FNVSGM-Src.zip Standard.jpg
%zip% FNVSGM-Src.zip *.ahk
%zip% FNVSGM-Src.zip *.ico

@ECHO Done.