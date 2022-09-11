@ECHO OFF

ECHO.
ECHO Set Variables
SET TargetSave=C:\Backup-Config-Dump\
SET TargetFiles=C:\Documentation-Drivers-Software\

ECHO.
ECHO Set Label C:
rem label c: System-XP32

ECHO.
ECHO Create folder Structure
MKDIR "%TargetSave%."
MKDIR "%TargetFiles%."

ECHO.
ECHO Copy Data to PC
IF NOT EXIST "%TargetFiles%\Drivers-Firmware\." "%~dp0Tools\Robocopy.exe" /MIR /R:1 /W:2 "%~dp0Drivers-Firmware\." "%TargetFiles%Drivers-Firmware\."
IF NOT EXIST "%TargetFiles%\ClientApps\." "%~dp0Tools\Robocopy.exe" /MIR /R:1 /W:2 "%~dp0..\..\..\ClientApps\." "%TargetFiles%ClientApps\."
"%~dp0Tools\Robocopy.exe" /E /R:1 /W:2 "%~dp0Documentation-Drivers-Software\." "%TargetFiles%."
"%~dp0Tools\Robocopy.exe" /E /R:1 /W:2 "%~dp0..\..\..\Operating Systems\Windows XP\." "%TargetFiles%Operating Systems\Windows XP\."
"%~dp0Tools\Robocopy.exe" /E /R:1 /W:2 "%~dp0..\..\..\Operating Systems\Windows - Tools and Updates\." "%TargetFiles%Operating Systems\Windows - Tools and Updates\."
REM RMDIR /Q /S "%TargetFiles%Tools"
REM DEL /Q "%TargetFiles%%~nx0"

ECHO.
Pause
