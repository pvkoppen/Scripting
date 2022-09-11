REM -----------------------------------------------------------------
REM Activity      : Add Predefined Start menu Items
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-08
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------

if %1' == ' GOTO RestartBatchWithLogging
goto ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST C:\Altiris\nul MD C:\Altiris
IF NOT EXIST C:\Altiris\LogFiles\nul MD C:\Altiris\LogFiles
CALL %0 ProcessBatch >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
GOTO End

:ProcessBatch
REM Make a drive mapping to the Altiris Resource Folder
REM -----------------------------------------------------------------
if not exist f:\nul net use f: \\TuiOra-Altiris\eXpress /user:tuiora-altiris\Altiris alt1r1s /persistent:No

REM Deletes All Users Start Menu Programs and copies Across reguried applictaion short cuts
REM -----------------------------------------------------------------
F:
CD "\Resource.TOL\Configs\TS\TuiOra-StartMenu\Programs"
XCOPY *.* "C:\Documents and Settings\All Users\Start Menu\Programs" /E /y

REM Deletes All Users Desktop Programs and copies Across reguried applictaion short cuts
REM -----------------------------------------------------------------
F:
CD "\Resource.TOL\Configs\TS\TuiOra-StartMenu\Desktop"
XCOPY *.* "C:\Documents and Settings\All Users\Desktop" /e /y

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
echo wait
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 60 "Waiting for 1 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END

