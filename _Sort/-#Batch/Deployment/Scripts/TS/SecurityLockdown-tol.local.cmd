REM Activity      : Terminal Server Folder security Lockdown (TOL.LOCAL)
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-08-08
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\WhoAmI.exe C:\Altiris\Tools\WhoAmI.exe
IF NOT "%ERRORLEVEL%" == "0"         ECHO Username=%UserName%
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

if %1' == ' GOTO RestartBatchWithLogging
goto ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST C:\Altiris\nul MD C:\Altiris
IF NOT EXIST C:\Altiris\LogFiles\nul MD C:\Altiris\LogFiles
ECHO ---------------- Start: %0 ---------------- >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
CALL %0 ProcessBatch   >>C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG 2>>&1
ECHO ---------------- End  : %0 ---------------- >> C:\Altiris\LogFiles\AltirisAutomatedBuildProcess.LOG
GOTO End

:ProcessBatch
REM Set this user session in Install mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Predefine the External Groups.
REM -----------------------------------------------------------------
set GRP-MailMarshal="CN=MailMarshal Console Access,OU=Global Security Entities,DC=TOL,DC=LOCAL"
set GRP-MsProject="CN=Microsoft Project Access,OU=Global Security Entities,DC=TOL,DC=LOCAL"

:: Change attributes on boot.ini
REM -----------------------------------------------------------------
REM attrib -s -h -r %SystemDrive%\boot.ini

:: Xcopy all the update files   CHANGE!!!
REM -----------------------------------------------------------------
REM copy /y c:\windows\lck\autoexec.nt %SystemDrive%\system32\autoexec.nt

:: Change attributes on boot.ini back
REM -----------------------------------------------------------------
REM attrib +r +h +s %SystemDrive%\boot.ini

:: Set all the ACLS on the C Drive
REM -----------------------------------------------------------------

:: Grant Administrators and System full control of system volume
:: and Users Read access.
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe %systemdrive%\ /c /g Administrators:F SYSTEM:F "authenticated users:r" /y

:: Remove access to system boot files for users
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe %systemdrive%\boot.ini     /c /g Administrators:F SYSTEM:F /y
C:\Altiris\Tools\xcacls.exe %systemdrive%\config.sys   /c /g Administrators:F SYSTEM:F /y
C:\Altiris\Tools\xcacls.exe %systemdrive%\io.sys       /c /g Administrators:F SYSTEM:F /y
C:\Altiris\Tools\xcacls.exe %systemdrive%\msdos.sys    /c /g Administrators:F SYSTEM:F /y
C:\Altiris\Tools\xcacls.exe %systemdrive%\ntdetect.com /c /g Administrators:F SYSTEM:F /y
C:\Altiris\Tools\xcacls.exe %systemdrive%\ntldr        /c /g Administrators:F SYSTEM:F /y

:: Change permissions on Setup directory
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe %systemdrive%\$OEM$     /c /t /y /g Administrators:F system:F
C:\Altiris\Tools\xcacls.exe %systemdrive%\Altiris   /c /t /y /g Administrators:F system:F
C:\Altiris\Tools\xcacls.exe %systemdrive%\Compaq    /c /t /y /g Administrators:F system:F
C:\Altiris\Tools\xcacls.exe %systemdrive%\CpqSystem /c /t /y /g Administrators:F system:F
C:\Altiris\Tools\xcacls.exe %systemdrive%\Drivers   /c /t /y /g Administrators:F system:F
C:\Altiris\Tools\xcacls.exe %systemdrive%\HP        /c /t /y /g Administrators:F system:F
C:\Altiris\Tools\xcacls.exe %systemdrive%\I386      /c /t /y /g Administrators:F system:F

:: Change everyone access to Documents and Settings to read
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Documents and Settings"                /c /y /g Administrators:F SYSTEM:F "authenticated users:r"
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Documents and Settings\All Users"      /c /y /g Administrators:F SYSTEM:F "authenticated users:r"
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Documents and Settings\All Users\*"    /c /y /g Administrators:F SYSTEM:F "authenticated users:r"
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Documents and Settings\Default User"   /c /y /g Administrators:F SYSTEM:F "authenticated users:r"
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Documents and Settings\Default User\*" /c /y /g Administrators:F SYSTEM:F "authenticated users:r"
C:\Altiris\Tools\xcacls.exe "%AllUsersProfile%\Start Menu\Programs\Administrative Tools" /c /t /y /g Administrators:F SYSTEM:F
C:\Altiris\Tools\xcacls.exe "%AllUsersProfile%\Start Menu\Programs\MailMarshal"   /c /y /g Administrators:F SYSTEM:F
CALL C:\Altiris\Tools\GetDomGRPSID.cmd %GRP-MailMarshal%
@echo on
C:\Altiris\Tools\SetACL.exe "%AllUsersProfile%\Start Menu\Programs\MailMarshal"   /dir /grant %GRPSID% /Read_ex /p:no_copy /sid
C:\Altiris\Tools\xcacls.exe "%AllUsersProfile%\Start Menu\Programs\Microsoft Project"   /c /y /g Administrators:F SYSTEM:F
CALL C:\Altiris\Tools\GetDomGRPSID.cmd %GRP-MsProject%
@echo on
C:\Altiris\Tools\SetACL.exe "%AllUsersProfile%\Start Menu\Programs\Microsoft Project"   /dir /grant %GRPSID% /Read_ex /p:no_copy /sid


:: Change everyone access to WINNT(Windows 2000)/WINDOWS(Windows 2003) directory 
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe %SystemRoot% /c /y /g Administrators:F SYSTEM:F "authenticated users:r"

:: Change everyone access to Program Files directory
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Program Files\Altiris\AClient\AClntUsr.EXE" /c /t /y /g Administrators:F SYSTEM:F
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Program Files" /c /t /y /g Administrators:F SYSTEM:F "authenticated users:exw"
C:\Altiris\Tools\xcacls.exe "%systemdrive%\Program Files\Intrahealth\Profile" /c /t /y /g Administrators:F SYSTEM:F "authenticated users":exw "Domain Users":exwm

:: Change permissions on temp directory
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe %systemroot%\Temp /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y

:: Create file in Temp directory, remove rights then hide
:: To stop deletion of directory
REM -----------------------------------------------------------------
if not exist %systemdrive%\Temp\nul            MKDIR %systemdrive%\Temp
if not exist %systemdrive%\Temp\secure.dir\nul MKDIR %systemdrive%\Temp\secure.dir
C:\Altiris\Tools\xcacls.exe %systemdrive%\Temp\secure.dir /g administrators:f system:f /y
attrib +h +s %systemdrive%\Temp\secure.dir

:: Exceptions
REM -----------------------------------------------------------------
C:\Altiris\Tools\xcacls.exe %systemroot%\bin /c /t /g Administrators:F SYSTEM:F "authenticated users:rx" /y
C:\Altiris\Tools\xcacls.exe %systemroot%\system32\spool /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y
C:\Altiris\Tools\xcacls.exe %systemroot%\system32\spool\printers /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y
C:\Altiris\Tools\xcacls.exe %systemroot%\system32\spool\drivers /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y

:: End
REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

