@ECHO OFF

IF %1' == /Action' GOTO Action
GOTO Log

:Log
CALL :SetDateTime
CALL %0 /Action >> "%~dpn0-%COMPUTERNAME%-%strDate%.Log" 2>>&1
GOTO End

:SetDateTime
FOR /F "tokens=1,2,3,4 delims=/ "  %%A IN ('ECHO %DATE%') DO SET strDate=%%D-%%C-%%B&&SET strDayOfWeek=[%%A]
FOR /F "tokens=1,2,3,4 delims=:."  %%A IN ('ECHO %TIME%') DO SET strTime=%%A%%B.%%C%%D
GOTO End

:Action
ECHO.
ECHO --------------------------------------------------------------------------------------
ECHO COMPUTERNAME=%COMPUTERNAME%
ECHO --------------------------------------------------------------------------------------
ECHO -- Date / Time
ECHO strDate=%strDate%, strDayOfWeek=%strDayOfWeek%
ECHO strTime=%strTime%
ECHO -- SET
SET
ECHO -- IPConfig
ipconfig /all
ECHO -- ROUTE
route print
ECHO -- TraceRoute
tracert -h 8 8.8.8.8
ECHO --------------------------------------------------------------------------------------

GOTO End

:End
