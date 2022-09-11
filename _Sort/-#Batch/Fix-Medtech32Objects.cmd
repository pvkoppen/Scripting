@ECHO OFF
REM Name          : Fix-Medtech32Objects.cmd
REM Description   : Script used to Regsiter dll's needed by Medtech.
REM Author        : Peter van Koppen,  Tui Ora Limited
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2011-10-03: 1.0: Initial version.
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
GOTO Action

:Action
ECHO.
ECHO -- Map Drive
IF NOT EXIST M:\. NET USE M: \\AveServer\MT32

ECHO.
ECHO -- Fix: PDFView
regsvr32.exe /s M:\Bin\pdfview.ocx
IF NOT %ERRORLEVEL%' == 0' GOTO ErrorPermission

ECHO.
ECHO -- Fix: IBProvider
regsvr32.exe /s M:\Bin\Services\MedtechServices\_IBProvider_v3_vc9_i.dll
IF NOT %ERRORLEVEL%' == 0' GOTO ErrorPermission

IF %1' == /silent' GOTO End
GOTO DoEnd

:ErrorPermission
ECHO.
ECHO [ERROR] The REGSRV32 process failed. You need Local Admin permissions.
IF %1' == /silent' GOTO End
GOTO DoEnd

:DoEnd
Pause
GOTO End

:End

