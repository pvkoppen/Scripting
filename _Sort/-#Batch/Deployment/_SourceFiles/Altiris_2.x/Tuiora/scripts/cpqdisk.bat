@ECHO ON

:: ==============================================================
:: cpqdisk.bat
:: Writes disk partition configuration
::
:: Usage
::   cpqdisk.exe /w file
:: ==============================================================

:CPQDISK
F:\DEPLOY\TOOLS\SSST\CPQDISK.EXE %1 %2 %3 %4 %5 %6 %7 %8 %9

:: ==============================================================
:: Error Codes
:: ==============================================================
:: 100 = The file was not found
:: 101 = Cannot create the file
:: 102 = Invalid data in the file
:: 103 = Invalid command-line parameters
:: 104 = A MBR is present and the overwrite option was not used
:: 105 = Insufficient memory
:: 106 = Could not read the MBR
:: ==============================================================

IF ERRORLEVEL 106 GOTO ERR106
IF ERRORLEVEL 105 GOTO ERR105
IF ERRORLEVEL 104 GOTO ERR104
IF ERRORLEVEL 103 GOTO ERR103
IF ERRORLEVEL 102 GOTO ERR102
IF ERRORLEVEL 101 GOTO ERR101
IF ERRORLEVEL 100 GOTO ERR100
IF ERRORLEVEL 0 GOTO ERR0

:ERR0
SET SEVERITY=1
SET STATUS="CPQDISK: Completed succesfully."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR100
SET SEVERITY=3
SET STATUS="CPQDISK: The file was not found."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR101
SET SEVERITY=3
SET STATUS="CPQDISK: Cannot create the file."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR102
SET SEVERITY=3
SET STATUS="CPQDISK: Invalid data in file."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR103
SET SEVERITY=3
SET STATUS="CPQDISK: Invalid command-line parameters."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR104
SET SEVERITY=3
SET STATUS="CPQDISK: A MBR is present and the overwrite option was not used."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR105
SET SEVERITY=3
SET STATUS="CPQDISK: Insufficient memory."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:ERR106
SET SEVERITY=3
SET STATUS="CPQDISK: Could not read the MBR."
IF EXIST F:\LOGEVENT.EXE F:\LOGEVENT.EXE -l:%SEVERITY% -ss:%STATUS%
GOTO DONE

:DONE
SET SEVERITY=
SET STATUS=

:END
