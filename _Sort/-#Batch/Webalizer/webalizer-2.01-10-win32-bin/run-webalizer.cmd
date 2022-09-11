@echo off
if %1' == ' goto Start
if %2' == ' goto ProcessServer
if %3' == ' goto FindTempFolder
if %4' == ' goto Convert
if %5' == ' goto GetConfig
goto WebalizeFiles

:Start
REM ---------------------------------------------------------------
REM -- Create Temporary Settings.
REM ---------------------------------------------------------------
echo. > %LASTRUNLOG%  2>> &1
FOR /F %%A (IIS-Servers.txt) DO %0 %%A >> %LASTRUNLOG%  2>>&1
GOTO END

:ProcessServer
REM ---------------------------------------------------------------
REM -- %1=ServerName
REM ---------------------------------------------------------------
set LOGFOLDER=\\%1\ADMIN$\system32\Logfiles
if not exist %LOGFOLDER%\. goto NoLogFolder

ECHO ---------------------------------------------------------------
ECHO -- Server: All IIS Servers
ECHO ---------------------------------------------------------------
ECHO MSFTPSVC1       = FTPRoot
ECHO W3SVC1          = WWWRoot
ECHO W3SVC2          = SharePoint / IISAdmin
ECHO W3SVC3          = ??
ECHO ---------------------------------------------------------------

REM ---------------------------------------------------------------
REM -- Run Webalizer for the %LOGFOLDER%\W3SVC* folders.
REM ---------------------------------------------------------------
ECHO.
ECHO ------------- Beginning Process Run: FTP -------------
for /d %%A IN (%LOGFOLDER%\MSFTPSVC*) DO CALL %0 %1 %%A
ECHO ------------- Finished Process Run: FTP -------------
ECHO ------------- Beginning Process Run: WEB -------------
for /d %%A IN (%LOGFOLDER%\W3SVC*)    DO CALL %0 %1 %%A
ECHO ------------- Finished Process Run: WEB -------------

REM ---------------------------------------------------------------
REM -- Remove Temporary Settings.
REM ---------------------------------------------------------------
SET LOGFOLDER=
Pause
goto end


:FindTempFolder
REM ---------------------------------------------------------------
REM -- %1=ServerName, %2=W3SVC folder
REM ---------------------------------------------------------------
ECHO # Processing Folder: %2 on server: %1
for /d %%a IN (%2\*) DO CALL %0 %1 %2 %%a
goto end


:Convert
REM ---------------------------------------------------------------
REM -- %1=ServerName, %2=W3SVC folder, %3=ConvertedData folder
REM ---------------------------------------------------------------
ECHO ## Removing old converted files: %3\*.ncsa.dns*
del /q %3\*.ncsa.dns*
REM for %%a IN (%2\ex*.log) DO .\tools\convlog -ie -t ncsa:+1200 -o %3 %%a
ECHO ## Rebuilding NCSA Common Log Format Files.
.\tools\rconvlog -d -t ncsa:+1200 -o %3 %2\*ex*.log
ECHO ## Correcting NCSA file with Timezone.
for %%a IN (%3\*.ncsa.dns) DO .\tools\DateCorrection.vbs %%a
CALL %0 %1 %2 %3 Converted
REM del /q %3\*.ncsa.dns*
goto end


:GetConfig
REM ---------------------------------------------------------------
REM -- %1=ServerName, %2=W3SVC folder, %3=ConvertedData folder, %4='Converted'
REM ---------------------------------------------------------------
REM -- Run Webalizer for all *.nz.conf config files.
REM ---------------------------------------------------------------
for %%a IN (%3\*.conf) DO CALL %0 %1 %2 %3 %4 %%a
goto end


:WebalizeFiles
REM ---------------------------------------------------------------
REM -- %1=ServerName, %2=W3SVC folder, %3=ConvertedData folder, %4='Converted', %5=ConfigFile
REM ---------------------------------------------------------------
REM -- Run Webalizer for all *.nz.conf config files.
REM ---------------------------------------------------------------
ECHO ### Run Webalizer for folder: %2.
for %%a IN (%3\*.timezonecorrected) DO .\webalizer -c %5 %%a
goto end

:NoLogFolder
echo LOGFOLDER: %LOGFOLDER% doens't exist.
goto end

:end
