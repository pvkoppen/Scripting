@ECHO OFF
GOTO End

FOR /D %%a in (N:\HomeDirs\*.*) do for /D %%b in (%%a\*.*) do CALL :ProcessHomeDir "%%a" "%%b"
GOTO END

:ProcessHomeDir
IF EXIST %2\Documents\. ren %2\Documents\. Documents1234567890
MKDIR %2\Documents
FOR /F "tokens=*" %%a IN ('dir /a /b /on %2\*.*') DO IF NOT "%%a" == "Documents" attrib -s -h %2\"%%a" && move /Y %2\"%%a" %2\Documents
IF EXIST %2\Documents\Documents1234567890\. ren %2\Documents\Documents1234567890\. Documents
GOTO End

:End