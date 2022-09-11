@ECHO OFF
TITLE GP Update
GOTO Action

:Action
ECHO.
ECHO [INFO] Reload Group Policies: DO NOT LOG OFF!
ECHO ----------------------------------------------
GPUpdate /Force
GOTO End

:End

