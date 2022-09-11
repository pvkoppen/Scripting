::@Echo Off
IF %~d0' == \\' goto MapDrive
ECHO Activity      : Cleanup and Lockdown 'All Users' Startmenu folder.
ECHO Created by    : Peter van Koppen
ECHO Company       : Tui Ora Limited
ECHO Date Created  : 2007-11-07
ECHO Must be run as: An Administrators
ECHO -----------------------------------------------------------------
IF EXIST %~dp0\Tools\WhoAmI.exe %~dp0\Tools\WhoAmI.exe
IF NOT "%ERRORLEVEL%" == "0" ECHO Username=%UserName%
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

if %1' == ' GOTO RestartBatchWithLogging
goto ProcessBatch

:RestartBatchWithLogging
IF NOT EXIST C:\Scripts\LogFiles\nul MKDir C:\Scripts\LogFiles
ECHO ---------------- Start: %0 ---------------- >> "C:\Scripts\LogFiles\%~n0-%ComputerName%.LOG"
CALL %0 ProcessBatch   >> "C:\Scripts\LogFiles\%~n0-%ComputerName%.LOG" 2>>&1
ECHO ---------------- End  : %0 ---------------- >> "C:\Scripts\LogFiles\%~n0-%ComputerName%.LOG"
GOTO End

:ProcessBatch
ECHO Put the commandline on the right drive
ECHO -----------------------------------------------------------------
%SystemDrive%
cd "%AllUsersProfile%\"
md "Start Menu\Programs\Administrative Tools\Desktop\"
md "Start Menu\Programs\Administrative Tools\Start Menu\"
md "Start Menu\Programs\Administrative Tools\Programs\"

ECHO Remove ALL icons from folder: 'All Users\Desktop'
ECHO -----------------------------------------------------------------
cd "%AllUsersProfile%\"
move /y Desktop\*.* "Start Menu\Programs\Administrative Tools\Desktop\"
rem DEL /q "%AllUsersProfile%\Desktop\*.lnk"

ECHO Move All User Start Menu links
ECHO -----------------------------------------------------------------
cd "%AllUsersProfile%\Start Menu"
move /y *.* "Programs\Administrative Tools\Start Menu\"

ECHO.
ECHO Move Unnecassery All User Program Folder 
ECHO -----------------------------------------------------------------
cd "%AllUsersProfile%\Start Menu\Programs"
move /y "7-zip"               "Administrative Tools\Programs\"
move /y "Computer Associates" "Administrative Tools\Programs\"
move /y "CutePDF"             "Administrative Tools\Programs\"
move /y "Editpad Lite"        "Administrative Tools\Programs\"
for /D %%a in (HP*)       do move /y "%%a" "Administrative Tools\Programs\"
for /D %%a in (ODF*)      do move /y "%%a" "Administrative Tools\Programs\"
move /y "QuickTime"           "Administrative Tools\Programs\"
for /D %%a in (Symantec*) do move /y "%%a" "Administrative Tools\Programs\"
for /D %%a in (Trend*)    do move /y "%%a" "Administrative Tools\Programs\"
for /D %%a in (Windows*)  do move /y "%%a" "Administrative Tools\Programs\"
move /y "WinZip"              "Administrative Tools\Programs\"
move /y *.* "Administrative Tools\Programs\"

REM Clean up 'AllUsers' Start Menu\Programs folder.
REM -----------------------------------------------------------------
%SystemDrive%
cd "%AllUsersProfile%\Start Menu\Programs"
XCOPY /s /y "Accessories\Communications\Remote Desktop Connection.*" "Administrative Tools\Programs\Remote Desktop\" 
RMDIR /s /q "Accessories\Communications"
XCOPY /s /y "Accessories\Remote Desktop Connection.*" "Administrative Tools\Programs\Remote Desktop\" 
XCOPY /s /y "Accessories\System Tools" "Administrative Tools\Programs\System Tools\"
RMDIR /s /q "Accessories\System Tools"
DEL   /f /q "Outlook Express.*"

REM Cleans unwanted shortcuts from the "default user" and "Administrator" profile.
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

REM Cleanup Shortcuts: MsOffice 2003
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
REM : V1
REM COPY /y /v "Microsoft Office\*Access*.lnk"     "%AllUsersProfile%\Desktop\Microsoft Access.lnk"
REM COPY /y /v "Microsoft Office\*Excel*.lnk"      "%AllUsersProfile%\Desktop\Microsoft Excel.lnk"
REM COPY /y /v "Microsoft Office\*Outlook*.lnk"    "%AllUsersProfile%\Desktop\Microsoft Outlook.lnk"
REM COPY /y /v "Microsoft Office\*PowerPoint*.lnk" "%AllUsersProfile%\Desktop\Microsoft PowerPoint.lnk"
REM COPY /y /v "Microsoft Office\*Publisher*.lnk"  "%AllUsersProfile%\Desktop\Microsoft Publisher.lnk"
REM COPY /y /v "Microsoft Office\*Word*.lnk"       "%AllUsersProfile%\Desktop\Microsoft Word.lnk"
REM : V2
COPY /y /v "Microsoft Office\*Access*.lnk"     "%AllUsersProfile%\Desktop\"
COPY /y /v "Microsoft Office\*Excel*.lnk"      "%AllUsersProfile%\Desktop\"
COPY /y /v "Microsoft Office\*Outlook*.lnk"    "%AllUsersProfile%\Desktop\"
COPY /y /v "Microsoft Office\*PowerPoint*.lnk" "%AllUsersProfile%\Desktop\"
COPY /y /v "Microsoft Office\*Publisher*.lnk"  "%AllUsersProfile%\Desktop\"
COPY /y /v "Microsoft Office\*Word*.lnk"       "%AllUsersProfile%\Desktop\"
CD "%AllUsersProfile%\Desktop"
FOR %%A IN ("Microsoft Office*.lnk") DO FOR /F "tokens=1-5 delims=. " %%B IN ("%%A") DO Ren "%%A" "%%B %%D.%%F"

REM Cleanup Shortcuts: MsProject 2003
REM -----------------------------------------------------------------
%SystemDrive%
CD "%AllUsersProfile%\Start Menu\Programs"
MD "Microsoft Project"
MD "Microsoft Project\Microsoft Office Tools"
MOVE /y "Microsoft Office\* Project *.lnk"         "Microsoft Project"
MOVE /y "Microsoft Office\Microsoft Office Tools\* Project *.lnk" "Microsoft Project\Microsoft Office Tools"

REM Add group: <domain>\Terminal Server Users to Terminal Services (Guest and User access)
REM -----------------------------------------------------------------
NET LOCALGROUP "Remote Desktop Users" "Domain Users" /ADD

:: Create file in Temp directory, remove rights then hide
:: To stop deletion of directory
REM -----------------------------------------------------------------
if not exist %systemdrive%\Temp\nul            MKDIR %systemdrive%\Temp
if not exist %systemdrive%\Temp\secure.dir\nul MKDIR %systemdrive%\Temp\secure.dir
%~dp0\Tools\xcacls.exe %systemdrive%\Temp\secure.dir /g administrators:f system:f /y
attrib +h +s %systemdrive%\Temp\secure.dir

%~dp0\Tools\xcacls.exe "%AllUsersProfile%\Start Menu\Programs\Administrative Tools" /c /t /y /g Administrators:F SYSTEM:F

REM Install the automated Weekly reboot.
REM -----------------------------------------------------------------
MD C:\Scripts
Copy "%~dp0Resources\Restart-TSServer.cmd" c:\Scripts
REM schtasks /create /RU "NETWORK" /SC WEEKLY /MO 1 /D SUN /TN "_TOL Restart-TSServer (Part-1)" /TR "C:\Scripts\Restart-TSServer.cmd" /ST 03:01:00
REM schtasks /create /RU "NETWORK" /SC WEEKLY /MO 1 /D SUN /TN "_TOL Restart-TSServer (Part-2)" /TR "C:\Scripts\Restart-TSServer.cmd" /ST 03:15:00
schtasks /create /RU "SYSTEM" /SC WEEKLY /MO 1 /D SUN /TN "_TOL Restart-TSServer (Part-1)" /TR "C:\Scripts\Restart-TSServer.cmd" /ST 03:01:00
schtasks /create /RU "SYSTEM" /SC WEEKLY /MO 1 /D SUN /TN "_TOL Restart-TSServer (Part-2)" /TR "C:\Scripts\Restart-TSServer.cmd" /ST 03:15:00

REM Set registery setting.
REM -----------------------------------------------------------------
if exist "%~dp0Resources\ComputerName.REG" REGEDIT -s "%~dp0Resources\ComputerName.REG"
if not exist "%~dp0Resources\ComputerName.REG" Echo ERROR: File ComputerName.REG not in right location.
if exist "%~dp0Resources\DisableCTFMON.REG" REGEDIT -s "%~dp0Resources\DisableCTFMON.REG"
if not exist "%~dp0Resources\DisableCTFMON.REG" Echo ERROR: File DisableCTFMON.REG not in right location.
goto end

:MapDrive
Echo.
Echo Don't run this batch from a UNC path. Run it from a local or a mapped drive.
goto end

:end
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b

