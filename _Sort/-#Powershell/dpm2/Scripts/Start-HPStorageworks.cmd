@ECHO OFF

ECHO.
ECHO -- Check service: Server Administrator (Secure Port Server)
sc qc "Server Administrator" |FIND /I "START_TYPE"
sc query "Server Administrator" |FIND /I "STATE"

ECHO.
ECHO -- Configure Service: "Server Administrator" (Stop, Start=Disabled)
sc stop "Server Administrator"
sc config "Server Administrator" start= disabled

ECHO.
ECHO -- Check service: NTMSSVC (Removable Storage)
sc qc ntmssvc |FIND /I "START_TYPE"
sc query ntmssvc |FIND /I "STATE"

ECHO.
ECHO -- Configure Service: NTMSSVC (Start=Manual)
sc config ntmssvc start= demand

ECHO.
ECHO -- Start HP Storageworks Tape Tools
"C:\Program Files\HP StorageWorks Library and Tape Tools\HP_LTT.exe"

ECHO.
ECHO -- Configure Service: NTMSSVC  (Stop, Start=Disabled)
sc stop ntmssvc
sc config ntmssvc start= disabled

ECHO.
ECHO -- Check service: NTMSSVC (Removable Storage)
sc qc ntmssvc |FIND /I "START_TYPE"
sc query ntmssvc |FIND /I "STATE"


ECHO.
ECHO -- Done.
REM Pause

