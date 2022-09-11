@echo off
if %~d0' == \\' goto MapDrive
goto menu

:menu
Echo.
Echo Software Installer:
Echo -------------------
Echo 1 = Adobe Acrobat Reader
Echo 2 = CutePDF Writer (and Ghost Script)
ECHO 3 = Editpad
ECHO 4 = Java / JRE
ECHO 5 = WinZip
ECHO 6 = Microsoft Update
ECHO 7 = Adobe Flash and Shockwave Player
ECHO 8 = Apple Quicktime
ECHO 9 = Borland BDE
ECHO A = Ms ISA Firewall Client
ECHO B = Citrix ICA Web client
ECHO C = Ms Office 2003 Professional
ECHO D = Ms Office 2003 Professional SP3
ECHO E = Ms Office 2003: Converter for Office 2007 documents (Requires Office 2003)
Echo Q = Quit
choice /c Q123456789ABCDE /m "Select menu option:"
if %ERRORLEVEL% == 255 goto Error
if %ERRORLEVEL% == 15 goto e
if %ERRORLEVEL% == 14 goto d
if %ERRORLEVEL% == 13 goto c
if %ERRORLEVEL% == 12 goto b
if %ERRORLEVEL% == 11 goto a
if %ERRORLEVEL% == 10 goto 9
if %ERRORLEVEL% ==  9 goto 8
if %ERRORLEVEL% ==  8 goto 7
if %ERRORLEVEL% ==  7 goto 6
if %ERRORLEVEL% ==  6 goto 5
if %ERRORLEVEL% ==  5 goto 4
if %ERRORLEVEL% ==  4 goto 3
if %ERRORLEVEL% ==  3 goto 2
if %ERRORLEVEL% ==  2 goto 1
if %ERRORLEVEL% ==  1 goto End
if %ERRORLEVEL% ==  0 goto Cancel
goto menu

:1
"..\..\ClientApps\Adobe Acrobat Reader\AdbeRdr811_en_US.exe"
ECHO Installed: Acrobat Reader
goto menu

:2
"..\..\ClientApps\CutePDF Writer\converter-v8.15.exe"
"..\..\ClientApps\CutePDF Writer\CuteWriter-2.71.exe"
ECHO Installed CutePDF Writer
goto menu

:3
"..\..\ClientApps\EditPad\SetupEditPadLite-6.3.1.exe"
Echo Installed: Editpad
goto menu

:4
"..\..\ClientApps\Java-JRE\jre-6u3-windows-i586-p.exe"
Echo Installed: Java / JRE
goto menu

:5
start ..\..\ClientApps\WinZip\"winzip81sr1 Serial.txt"
"..\..\ClientApps\WinZip\winzip81sr1.exe"
Echo Installed: WinZip
goto menu

:6
start http://update.microsoft.com/microsoftupdate/
Echo Updated: Windows Update to Microsoft Update
goto menu

:7
"..\..\ClientApps\AdobeFlashShockwavePlayer_v10.2\install_flash_player_active_x.msi"
ECHO Installed: Adobe Flash and Shockwave Player
goto menu

:8
"..\..\ClientApps\AppleQuicktime_v7.1\QuickTimeInstaller_v7.1.0.210.exe"
Echo Installed: Apple Quicktime
goto menu

:9
rem "..\..\ClientApps\BorlandBDE-v5\BDE_5.0\BDE5_install\setup.exe"
rem "..\..\ClientApps\BorlandBDE-v5\BDE_5.0.1\BDEUpd.exe"
REM "..\..\ClientApps\BorlandBDE-v5\BDE510en.exe"
"..\..\ClientApps\BorlandBDE-v5\BDE511en.exe"
copy "..\..\ClientApps\BorlandBDE-v5\PDOXUSRS.NET" C:\
start C:\
Echo Installed: Borland DBE
ECHO  - Change Permisions for file: C:\PDOXUSRS.NET
goto menu

:a
"..\..\ClientApps\Microsoft ISA Firewall Client\ISACLIENT-KB929556-ENU.EXE"
Echo Installed: Ms ISA Firewall Client
goto menu

:b
"..\..\ClientApps\CitrixIcaWebClient_v10.0\ica32web_v10.0.msi"
Echo Installed: Citrix ICA Web Client
goto menu

:c
rem start ..\CD\"MS Serial.txt"
"..\..\ClientApps\MsOffice2003 Professional\Setup.exe" PIDKEY=D9G2T83WR8Q8RM9MCRMFHFG7Q
Echo Installed: Ms Office 2003 Professional
goto menu

:d
"..\..\ClientApps\MsOffice2003-SP3\Office2003SP3-KB923618-FullFile-ENU.exe"
Echo Installed: Ms Office 2003 Professional SP3
goto menu

:e
"..\..\ClientApps\MsOffice2003_2007Converter\FileFormatConverters.exe"
Echo Installed: Microsoft Office 2003: Office 2007 Converter
goto menu

:MapDrive
Echo.
Echo Run this script from a mapped drive not from a UNC path!
goto end

:Error
Echo.
Echo There was an error in the execution of the script.
goto end

:Cancel
Echo.
Echo The installation batch has been cancelled.
goto end

:End
pause
