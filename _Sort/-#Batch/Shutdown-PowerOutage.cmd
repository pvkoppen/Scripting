@ECHO OFF
ECHO.
ECHO Make sure you run this batch as an administrator that has 
ECHO the permission to shut down servers!
ECHO.-----------------------------------------------------------
Choice /M "Are you sure you want to shut down all the servers?"
IF %ERRORLEVEL%' == 1' GOTO Listing
GOTO DoEnd

:Listing
CALL :Shutdown NOT MOLMH01
CALL :Shutdown NOT MOLMH02
CALL :Shutdown NOT TAMMT01
CALL :Shutdown NOT THPHS01
CALL :Shutdown NOT THPHTS1
CALL :Shutdown NOT TIHIS01
CALL :Shutdown NOT TOLDV01
CALL :Shutdown NOT TOLDV02
CALL :Shutdown NOT TOLFP01
CALL :Shutdown NOT TOLGW01
CALL :Shutdown NOT TOLMS01
CALL :Shutdown NOT TOLPE01
CALL :Shutdown NOT TOLPT01
CALL :Shutdown NOT TOLTS01
CALL :Shutdown NOT TOLTS02
CALL :Shutdown NOT TOLTS03
CALL :Shutdown NOT TOLTS05
CALL :Shutdown NOT TOLTS06
CALL :Shutdown NOT TOLSS01
CALL :Shutdown NOT TOLVS01
CALL :Shutdown NOT TOLVS03
CALL :Shutdown NOT TOLVS05
CALL :Shutdown NOT TOLVS06

CALL :Shutdown BHSERVER
CALL :Shutdown DEV01
CALL :Shutdown KOIMT01
CALL :Shutdown PHODW
CALL :Shutdown PHOMT01
CALL :Shutdown TOLDS01
CALL :Shutdown TOLMM01
CALL :Shutdown TOLMM02
CALL :Shutdown TOLOCS01
CALL :Shutdown TOLPE02
CALL :Shutdown TOLSE01
CALL :Shutdown TOLSE02
CALL :Shutdown TOLSS02
CALL :Shutdown TOLTM01
CALL :Shutdown TOLTS04
CALL :Shutdown TOLTSxx
CALL :Shutdown TOLWS01
CALL :Shutdown TOLWT01
CALL :Shutdown TOLWU01
CALL :Shutdown TRPEQ01
GOTO DoEnd

:Shutdown
IF %1' == NOT' GOTO NOT
PING -w 5 %1 > nul
IF %ERRORLEVEL%' == 0' GOTO Shutdown
GOTO Missing
GOTO End

:NOT
ECHO INFO : Don't shut down server: %2
GOTO End

:Shutdown
IF NOT %1' == TOLSE02' GOTO Continue
Choice /M "Are you sure you want to shut down server: %1?"
IF %ERRORLEVEL%' == 1' GOTO Continue
GOTO End
:Continue
ECHO INFO : Shuting down server: %1
Shutdown /f /s /t 10 /c "Scheduled Power Outage" /m %1
IF NOT %ERRORLEVEL%' == 0' ECHO ERROR: Shutdown of server %1 FAILED!!
GOTO End

:Missing
ECHO ERROR: Server Missing - %1
GOTO End

:DoEnd
Pause
GOTO End

:End
