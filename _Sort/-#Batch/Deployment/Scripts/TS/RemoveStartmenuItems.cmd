REM Activity      : Remove Start menu Items
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

REM Remove ALL icons from folder: 'All Users\Desktop'
REM -----------------------------------------------------------------
%SystemDrive%
cd "%AllUsersProfile%\Desktop"
XCOPY /y /V *.* "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Desktop\"
DEL /F /Q *.*

REM Move Windows Update and Windows Catalog Links
REM -----------------------------------------------------------------
%SystemDrive%
cd "%AllUsersProfile%\Start Menu"
XCOPY /y /V *.* "Programs\Administrative Tools\Start Menu\"
DEL /F /Q *.*

REM Clean up 'AllUsers' Start Menu\Programs folder.
REM -----------------------------------------------------------------
%SystemDrive%
cd "%AllUsersProfile%\Start Menu\Programs"
XCOPY /s /y "Accessories\Communications\Remote Desktop Connection.*" "Administrative Tools\Programs\Accessories\" 
RMDIR /s /q "Accessories\Communications"
XCOPY /s /y "Accessories\Remote Desktop Connection.*" "Administrative Tools\Programs\Accessories\" 
DEL   /f /q "Accessories\Remote Desktop Connection.*" 
XCOPY /y /s "Accessories\System Tools" "Administrative Tools\Programs\System Tools\"
RMDIR /s /q "Accessories\System Tools"
DEL   /f /q "Outlook Express.*"
XCOPY /y /s "Windows Support Tools" "Administrative Tools\Programs\Windows Support Tools\"
RMDIR /s /q "Windows Support Tools" 
XCOPY /y /s "Windows Resource Kit Tools" "Administrative Tools\Programs\Windows Resource Kit Tools\"
RMDIR /s /q "Windows Resource Kit Tools" 


REM Cleans unwanted shortcuts from the default user profile.
REM -----------------------------------------------------------------
%SystemDrive%
CD "\Documents and Settings\Default User\Start Menu\Programs"
DEL   /f /q "Outlook Express.*"
DEL   /f /q "Remote Assistance.*"
MOVE  /y "Accessories\Windows Explorer.*" .
MOVE  /y "Accessories\Notepad.*" .
DEL   /f /q "Accessories\*.*"
RMDIR /s /q "Accessories\Accessibility"
RMDIR /s /q "Accessories\Entertainment"
MOVE  /y "Windows Explorer.*" "Accessories\"
MOVE  /y "Notepad.*" "Accessories\"
REM -----------------------------------------------------------------
CD "\Documents and Settings\Administrator\Start Menu\Programs"
DEL   /f /q "Outlook Express.*"
DEL   /f /q "Remote Assistance.lnk"
MOVE  /y "Accessories\Windows Explorer.*" .
MOVE  /y "Accessories\Notepad.*" .
DEL   /f /q "Accessories\*.*"
RMDIR /s /q "Accessories\Accessibility"
RMDIR /s /q "Accessories\Entertainment"
MOVE  /y "Windows Explorer.*" "Accessories\"
MOVE  /y "Notepad.*" "Accessories\"
REM -----------------------------------------------------------------
CD "\Documents and Settings\Administrator.TOL\Start Menu\Programs"
DEL   /f /q "Outlook Express.*"
DEL   /f /q "Remote Assistance.lnk"
MOVE  /y "Accessories\Windows Explorer.*" .
MOVE  /y "Accessories\Notepad.*" .
DEL   /f /q "Accessories\*.*"
RMDIR /s /q "Accessories\Accessibility"
RMDIR /s /q "Accessories\Entertainment"
MOVE  /y "Windows Explorer.*" "Accessories\"
MOVE  /y "Notepad.*" "Accessories\"

REM Cleanup Shortcuts: Apple
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
MOVE /y "Apple*" "Administrative Tools\Programs\"

REM Cleanup Shortcuts: CutePDF
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
MOVE /y "CutePDF" "Administrative Tools\Programs\"

REM Cleanup Shortcuts: Marshal MailMarshal
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
XCOPY /y /v "MailMarshal\MailMarshal Configurator.*" "Administrative Tools\Programs\MailMarshal\"
DEL   /f /q "MailMarshal\MailMarshal Configurator.*" 

REM Cleanup Shortcuts: McAfee AntiVirus
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
MOVE /y "Network Associates" "Administrative Tools\Programs\"
MOVE /y "McAfee" "Administrative Tools\Programs\"

REM Cleanup Shortcuts: MsFireWall Client
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
XCOPY /y /v "Microsoft Firewall*.*" "Administrative Tools\Programs\Microsoft FireWall\"
DEL   /f /q "Microsoft Firewall*.*"

REM Cleanup Shortcuts: MsOffice 2003
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
COPY /y /v /b "Microsoft Office\*Access*.lnk"     "%AllUsersProfile%\Desktop\Microsoft Access.lnk"
COPY /y /v /b "Microsoft Office\*Excel*.lnk"      "%AllUsersProfile%\Desktop\Microsoft Excel.lnk"
COPY /y /v /b "Microsoft Office\*Outlook*.lnk"    "%AllUsersProfile%\Desktop\Microsoft Outlook.lnk"
COPY /y /v /b "Microsoft Office\*PowerPoint*.lnk" "%AllUsersProfile%\Desktop\Microsoft PowerPoint.lnk"
COPY /y /v /b "Microsoft Office\*Publisher*.lnk"  "%AllUsersProfile%\Desktop\Microsoft Publisher.lnk"
COPY /y /v /b "Microsoft Office\*Word*.lnk"       "%AllUsersProfile%\Desktop\Microsoft Word.lnk"

REM Cleanup Shortcuts: MsProject 2003
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
MD "Microsoft Project"
MD "Microsoft Project\Microsoft Office Tools"
MOVE /y "Microsoft Office\* Project *.lnk"         "Microsoft Project"
MOVE /y "Microsoft Office\Microsoft Office Tools\* Project *.lnk" "Microsoft Project\Microsoft Office Tools"

REM Cleanup Shortcuts: PowerChute
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
XCOPY /s /y "PowerChute Network Shutdown" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\PowerChute Network Shutdown\"
RMDIR /s /q "PowerChute Network Shutdown"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Default User\Start Menu\Programs"
XCOPY /s /y "PowerChute Network Shutdown" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\PowerChute Network Shutdown\"
RMDIR /s /q "PowerChute Network Shutdown"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Administrator\Start Menu\Programs"
XCOPY /s /y "PowerChute Network Shutdown" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\PowerChute Network Shutdown\"
RMDIR /s /q "PowerChute Network Shutdown"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Administrator.TOL\Start Menu\Programs"
XCOPY /s /y "PowerChute Network Shutdown" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\PowerChute Network Shutdown\"
RMDIR /s /q "PowerChute Network Shutdown"

REM Cleanup Shortcuts: Profile
REM -----------------------------------------------------------------
%SystemDrive%
CD "%SystemDrive%\Documents and Settings\Default User"
XCOPY /s /y "Start Menu\Programs\Profile" "%AllUsersProfile%\Start Menu\Programs\Profile\"
XCOPY /s /y "Desktop\Profile.*" "%AllUsersProfile%\Desktop\"
RMDIR /s /q "Start Menu\Programs\Profile"
DEL   /f /q "Desktop\Profile.*"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Administrator"
XCOPY /s /y "Start Menu\Programs\Profile" "%AllUsersProfile%\Start Menu\Programs\Profile\"
XCOPY /s /y "Desktop\Profile.*" "%AllUsersProfile%\Desktop\"
RMDIR /s /q "Start Menu\Programs\Profile"
DEL   /f /q "Desktop\Profile.*"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Administrator.TOL"
XCOPY /s /y "Start Menu\Programs\Profile" "%AllUsersProfile%\Start Menu\Programs\Profile\"
XCOPY /s /y "Desktop\Profile.*" "%AllUsersProfile%\Desktop\"
RMDIR /s /q "Start Menu\Programs\Profile"
DEL   /f /q "Desktop\Profile.*"
REM -----------------------------------------------------------------
COPY /Y "%AllUsersProfile%\Start Menu\Programs\Profile\*.*" "%AllUsersProfile%\Desktop\"

REM Cleanup Shortcuts: Symantec
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%"
XCOPY /s /y "Start Menu\Programs\Symantec Backup Exec for Windows Servers" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\"
RMDIR /s /q "Start Menu\Programs\Symantec Backup Exec for Windows Servers"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Default User"
XCOPY /s /y "Start Menu\Programs\Symantec Backup Exec for Windows Servers" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\"
RMDIR /s /q "Start Menu\Programs\Symantec Backup Exec for Windows Servers"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Administrator"
XCOPY /s /y "Start Menu\Programs\Symantec Backup Exec for Windows Servers" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\"
RMDIR /s /q "Start Menu\Programs\Symantec Backup Exec for Windows Servers"
REM -----------------------------------------------------------------
CD "%SystemDrive%\Documents and Settings\Administrator.TOL"
XCOPY /s /y "Start Menu\Programs\Symantec Backup Exec for Windows Servers" "%AllUsersProfile%\Start Menu\Programs\Administrative Tools\Programs\"
RMDIR /s /q "Start Menu\Programs\Symantec Backup Exec for Windows Servers"

REM Set this user session in Execute mode (For Terminal Servers Only)
REM -----------------------------------------------------------------

REM Make the server wait for a moment to finalize all installation processes.
REM -----------------------------------------------------------------
IF EXIST C:\Altiris\Tools\aWait.exe C:\Altiris\Tools\aWait.exe 30 "Waiting for 1/2 minute(s) to finalize Installs/Updates. Seconds remaining: %%d"

:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

