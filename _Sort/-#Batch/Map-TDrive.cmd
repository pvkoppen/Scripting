@ECHO OFF
GOTO Action

:Action
ECHO.
ECHO [INFO] Creating Mapped Drive
ECHO ----------------------------------------------
NET USE T: \\TOLMM02\Software
GOTO End

:End

