ECHO Shutdown Script - _BE CAREFULL_
ECHO.

REM Setting Base Settings
REM -- -------------------------------------
SET strReason=PvK: Network rewiring.

ECHO Non-Client/Employee focused
PAUSE
shutdown /f /s /t 30 /c "%strReason%" /m TOLSS02
shutdown /f /s /t 30 /c "%strReason%" /m TOLMM01
shutdown /f /s /t 30 /c "%strReason%" /m TOLMM02

ECHO Client Access Terminal Servers
PAUSE
shutdown /f /s /t 30 /c "%strReason%" /m TOLTS03
shutdown /f /s /t 30 /c "%strReason%" /m TOLTSxx
shutdown /f /s /t 30 /c "%strReason%" /m TOLTS04
shutdown /f /s /t 30 /c "%strReason%" /m TOLTS05
shutdown /f /s /t 30 /c "%strReason%" /m TOLTS06
shutdown /f /s /t 30 /c "%strReason%" /m TOLTS07
shutdown /f /s /t 30 /c "%strReason%" /m TOLTS08
shutdown /f /s /t 30 /c "%strReason%" /m TAMMT01
shutdown /f /s /t 30 /c "%strReason%" /m THPHTS01

ECHO Hyper-V Servers and Application Servers
PAUSE
shutdown /f /s /t 30 /c "%strReason%" /m TOLVS05
shutdown /f /s /t 30 /c "%strReason%" /m TOLVS06
shutdown /f /s /t 30 /c "%strReason%" /m TOLVS07
shutdown /f /s /t 30 /c "%strReason%" /m TOLVS08
shutdown /f /s /t 30 /c "%strReason%" /m TOLVS09
shutdown /f /s /t 30 /c "%strReason%" /m TOLVS10
shutdown /f /s /t 30 /c "%strReason%" /m TOLMS01
shutdown /f /s /t 30 /c "%strReason%" /m TOLOCS01

ECHO Core Support Server
PAUSE
shutdown /f /s /t 30 /c "%strReason%" /m TOLDV02
shutdown /f /s /t 30 /c "%strReason%" /m TOLDM01
shutdown /f /s /t 30 /c "%strReason%" /m TOLDB01
shutdown /f /s /t 30 /c "%strReason%" /m TOLGW01

ECHO True Core Servers
PAUSE
shutdown /f /s /t 30 /c "%strReason%" /m TOLDV01

ECHO Done - Remember to boot up TS servers after Hyper-V restart!
PAUSE

