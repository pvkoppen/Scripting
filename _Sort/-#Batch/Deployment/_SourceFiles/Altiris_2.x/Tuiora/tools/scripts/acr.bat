@ECHO ON

:: ==============================================================
:: acr.bat
:: Read/writes array configuration
::
:: Usage
::   Capture
::     acr.exe /c file
::   Deploy
::     acr.exe /i file /o
:: ==============================================================

:: if there is no array controller, then skip
F:\tuiora\TOOLS\SSST\ARRTYPE.EXE F:\tuiora\TOOLS\SSST\SSSTKARR.INI FIRST
IF ERRORLEVEL 1 GOTO ACR
GOTO END

:ACR
F:\tuiora\TOOLS\SSST\ACR.EXE /a %1 %2 %3 %4 %5 %6 %7 %8 %9

:: ==============================================================
:: Error Codes
:: ==============================================================
:: 001 = Multiple errors where encountered
:: 001 = An argument error occured
:: 002 = An internal error occured
:: 002 = The input file could not be opened
:: 003 = The error file could not be opened
:: 004 = A memory allocation failure occured
:: 005 = The drive was not found or the drive is already assigned
:: 006 = The spare was not found or the spare is already assigned
:: 007 = The capture file could not be opened
:: 009 = No controllers were found
:: 010 = The was an error negotiating with the controller
:: 011 = The array profile does not contain any drive specification
:: 013 = A configuration error occured
:: 022 = An error occured while parsing the input file
:: 113 = An invalid Logical Drive Number was specified
:: 201 = The logical drive stripe size cannot be supported
:: 202 = The requested logical drive size cannot be supported
:: 203 = The RAID level cannot be supported
:: 206 = The logical drive size specified is too small
:: ==============================================================

IF ERRORLEVEL 206 GOTO ERR206
IF ERRORLEVEL 203 GOTO ERR203
IF ERRORLEVEL 202 GOTO ERR202
IF ERRORLEVEL 201 GOTO ERR201
IF ERRORLEVEL 113 GOTO ERR113
IF ERRORLEVEL 22 GOTO ERR22
IF ERRORLEVEL 13 GOTO ERR13
IF ERRORLEVEL 11 GOTO ERR11
IF ERRORLEVEL 10 GOTO ERR10
IF ERRORLEVEL 9 GOTO ERR9
IF ERRORLEVEL 7 GOTO ERR7
IF ERRORLEVEL 6 GOTO ERR6
IF ERRORLEVEL 5 GOTO ERR5
IF ERRORLEVEL 4 GOTO ERR4
IF ERRORLEVEL 3 GOTO ERR3
IF ERRORLEVEL 2 GOTO ERR2
IF ERRORLEVEL 1 GOTO ERR1
IF ERRORLEVEL 0 GOTO ERR0

:ERR0
SET SEVERITY=1
SET STATUS="ACR: Completed successfully."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR1
SET SEVERITY=3
SET STATUS="ACR: Multiple errors were encountered."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR2
SET SEVERITY=3
SET STATUS="ACR: An internal error occured."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR3
SET SEVERITY=3
SET STATUS="ACR: The error file could not be opened."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR4
SET SEVERITY=3
SET STATUS="ACR: Memory allocation failure."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR5
SET SEVERITY=3
SET STATUS="ACR: The drive was not found or the drive is already assigned."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR6
SET SEVERITY=3
SET STATUS="ACR: The spare was not found or the spare is already assigned."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR7
SET SEVERITY=3
SET STATUS="ACR: The capture file could not be opened."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR9
SET SEVERITY=2
SET STATUS="ACR: No controllers were found."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR10
SET SEVERITY=3
SET STATUS="ACR: The was an error negotiating with the controller."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR11
SET SEVERITY=3
SET STATUS="ACR: The array profile does not contain any drive specification."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR13
SET SEVERITY=3
SET STATUS="ACR: A configuration error occured."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR22
SET SEVERITY=3
SET STATUS="ACR: An error occured while parsing the input file."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR113
SET SEVERITY=3
SET STATUS="ACR: An invalid Logical Drive Number was specified."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR201
SET SEVERITY=3
SET STATUS="ACR: The logical drive stripe size cannot be supported."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR202
SET SEVERITY=3
SET STATUS="ACR: The requested logical drive size cannot be supported."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR203
SET SEVERITY=3
SET STATUS="ACR: The RAID level cannot be supported."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR206
SET SEVERITY=3
SET STATUS="ACR: The logical drive size specified is too small."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:DONE
SET SEVERITY=
SET STATUS=

:END
