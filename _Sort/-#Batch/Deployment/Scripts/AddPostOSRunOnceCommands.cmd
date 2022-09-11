REM Activity      : Add Post OS Installation RunOnce Commands.
REM Created by    : Peter van Koppen
REM Company       : Tui Ora Limited
REM Date Created  : 2006-12-08
REM Must be run as: <No Preference: Administrators/LocalSystem>
REM -----------------------------------------------------------------

REM Determine hard drive
REM -----------------------------------------------------------------
set HD=c
for %%i in (c d e f g h i j k l m) do if exist %%i:\rdpimage set HD=%%i

REM Hookup post-oem script
REM -----------------------------------------------------------------
echo REG IMPORT %%systemdrive%%\$oem$\TuiOra\AllowRDP.reg>>%HD%:\$oem$\runonce.cmd
echo REG IMPORT %%systemdrive%%\$oem$\TuiOra\NOPSSU.reg>>%HD%:\$oem$\runonce.cmd

REM Finish
REM -----------------------------------------------------------------
:END
for /f "tokens=*" %%a in ('date /t') do for /f "tokens=*" %%b in ('time /t') do echo DATE/TIME= %%a- %%b
