@ECHO ON

:: ==============================================================
:: conrep.bat
:: Read/writes hardware configuration
::
:: Usage
::   Capture
::     conrep.exe /sh file
::   Deploy
::     conrep.exe /l file
:: ==============================================================

:CONREP
F:\DEPLOY\TOOLS\SSST\CONREP.EXE %1 %2 %3 %4 %5 %6 %7 %8 %9

:: ==============================================================
:: Error Codes
:: ==============================================================
:: 002 = Invalid DOS version
:: 003 = A bad filename was specified
:: 004 = This is not a supported server model! You need to update SSSTKSYS.INI.
:: 005 = Bad command line parameter
:: 006 = Access denied to the file
:: 007 = The diskette is full
:: 008 = There was a syntax error in the input file
:: ==============================================================

IF ERRORLEVEL 8 GOTO ERR8
IF ERRORLEVEL 7 GOTO ERR7
IF ERRORLEVEL 6 GOTO ERR6
IF ERRORLEVEL 5 GOTO ERR5
IF ERRORLEVEL 4 GOTO ERR4
IF ERRORLEVEL 3 GOTO ERR3
IF ERRORLEVEL 2 GOTO ERR2
IF ERRORLEVEL 0 GOTO ERR0

:ERR0
SET SEVERITY=1
SET STATUS="CONREP: Completed successfully."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR2
SET SEVERITY=3
SET STATUS="CONREP: Invalid DOS version!"
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR3
SET SEVERITY=3
SET STATUS="CONREP: A bad filename was specified."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR4
SET SEVERITY=3
SET STATUS="CONREP: This is not a supported server model! You need to update SSSTKSYS.INI."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR5
SET SEVERITY=3
SET STATUS="CONREP: Bad command line parameter."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR6
SET SEVERITY=3
SET STATUS="CONREP: Access denied to the file."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR7
SET SEVERITY=3
SET STATUS="CONREP: The diskette is full."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR8
SET SEVERITY=3
SET STATUS="CONREP: There was a syntax error in the input file."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:DONE
SET SEVERITY=
SET STATUS=

:END
