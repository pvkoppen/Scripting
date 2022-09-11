@echo off
if %~d0' == \\' goto MapDrive
goto menu

:menu
Echo.
Echo Software Installer:
Echo -------------------
Echo 1 = Windows Server 2003 Service Pack 2
Echo 2 = Windows 2k3-SP2 Admin Package (SP2 Required!)
ECHO 3 = Windows 2k3-SP2 Support Tools (SP2 Required!)
ECHO 4 = Windows 2k3 Resource Kit
ECHO 5 = Dot Net v2
ECHO 6 = Group Policy Management Console
Echo Q = Quit
choice /c Q123456 /m "Select menu option:"
if %ERRORLEVEL% == 255 goto Error
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
"..\OS\Win2k3\WIN2K3SP2\WindowsServer2003-KB914961-SP2-x86-ENU.exe"
Echo.
ECHO Installed: Windows Server 2003 Service Pack 2
Echo We need to restart the server after the installation of SP2!
goto end

:2
"\\Localhost\Admin$\System32\Adminpak.msi"
ECHO Installed: Windows 2k3 Admin Package
goto menu

:3
"..\OS\Win2k3\Win2k3SP2 Support Tools\SupTools.msi"
ECHO Installed: Windows 2k3-SP2 Support Tools (SP2 Required!)
goto menu

:4
"..\OS\Win2k3\Win2k3 ResourceKit\rktools.exe"
ECHO Installed: Windows 2k3 Resource Kit
goto menu

:5
"..\OS\Windows.Updates\DotNet_v2.0\dotnetfx_v2.0-Win32-en.exe"
Echo Installed: Dot Net v2
goto menu

:6
"..\OS\Windows.Updates\Group Policies\gpmc.msi"
Echo Installed: Group Policy Management Console
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
Echo.
pause
