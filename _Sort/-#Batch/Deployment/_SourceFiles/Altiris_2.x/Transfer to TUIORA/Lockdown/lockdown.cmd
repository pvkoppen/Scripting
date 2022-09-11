rem Lock down script for Staples Rodway
rem Created by Aaron Gayton @ Staples Rodway Ltd November
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd



net use f: \\staples-altiris\express /user:staples-altiris\altiris l3tm31n! /persistent:No

:::::::::::::::::::::::::::::::::::::::::::::
:: Change attributes on boot.ini
:::::::::::::::::::::::::::::::::::::::::::::
attrib -s -h -r %SystemDrive%\boot.ini

:::::::::::::::::::::::::::::::::::::::::::::
:: Xcopy all the update files   CHANGE!!!
:::::::::::::::::::::::::::::::::::::::::::::
copy /Y c:\windows\lck\boot.ini %SystemDrive%\boot.ini
copy /y c:\windows\lck\autoexec.nt %SystemDrive%\system32\autoexec.nt

:::::::::::::::::::::::::::::::::::::::::::::
:: Change attributes on boot.ini back
:::::::::::::::::::::::::::::::::::::::::::::
attrib +r +h +s %SystemDrive%\boot.ini

:::::::::::::::::::::::::::::::::::::::::::::
:: Set all the ACLS on the C Drive
:::::::::::::::::::::::::::::::::::::::::::::

F:
f:
cd\
cd Staples\CDS\Lockdown

:: Grant Administrators and System full control of system volume
:: and Users Read access.
xcacls %systemdrive%\ /c /g Administrators:F SYSTEM:F "authenticated users:r" /y

:: Remove access to system boot files for users
xcacls %systemdrive%\boot.ini /c /g Administrators:F SYSTEM:F /y
xcacls %systemdrive%\config.sys /c /g Administrators:F SYSTEM:F /y
xcacls %systemdrive%\io.sys /c /g Administrators:F SYSTEM:F /y
xcacls %systemdrive%\msdos.sys/c /g Administrators:F SYSTEM:F /y
xcacls %systemdrive%\ntdetect.com /c /g Administrators:F SYSTEM:F /y
xcacls %systemdrive%\ntldr /c /g Administrators:F SYSTEM:F /y

:: Change permissions on Setup directory  LOOK AT!!

:: xcacls %systemdrive%\setup /c /g Administrators:F system:F /y


:: Change everyone access to Documents and Settings to read
xcacls "%systemdrive%\Documents and Settings" /c /g Administrators:F SYSTEM:F "authenticated users:r" /y
xcacls "%systemdrive%\Documents and Settings\All Users" /c /g Administrators:F SYSTEM:F "authenticated users:r" /y
xcacls "%systemdrive%\Documents and Settings\All Users\*" /c /g Administrators:F SYSTEM:F "authenticated users:r" /y
xcacls "%systemdrive%\Documents and Settings\Default User" /c /g Administrators:F SYSTEM:F "authenticated users:r" /y
xcacls "%systemdrive%\Documents and Settings\Default User\*" /c /g Administrators:F SYSTEM:F "authenticated users:r" /y

:: Change everyone access to WINNT directory
xcacls %systemdrive%\WINNT /c /g Administrators:F SYSTEM:F "authenticated users:r" /y

:: Change everyone access to Program Files directory
xcacls "%systemdrive%\Program Files" /c /t /g Administrators:F SYSTEM:F "authenticated users:exw" /y


:: Change permissions on temp directory
xcacls %systemroot%\Temp /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y

:: Create file in Temp directory, remove rights then hide
:: To stop deletion of directory
copy c:\winnt\system32\secure.dir c:\Temp\secure.dir /y
xcacls %systemdrive%\Temp\secure.dir /g administrators:f system:f /y
attrib +h %systemdrive%\Temp\secure.dir


:: Exceptions
xcacls %systemroot%\bin /c /t /g Administrators:F SYSTEM:F "authenticated users:rx" /y
xcacls %systemroot%\system32\spool /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y
xcacls %systemroot%\system32\spool\printers /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y
xcacls %systemroot%\system32\spool\drivers /c /t /g Administrators:F SYSTEM:F "authenticated users:c" /y
Pause

:: Application Licnese Restrictions
:: Microsoft Publisher
xcacls "%systemdrive%\Program Files\Microsoft Office\OFFICE11MSPUB.exe" /D "NT Authority\authenticated users" /y
xcacls "%systemdrive%\Program Files\Microsoft Office\OFFICE11MSPUB.exe" /c /t /g Administrators:F SYSTEM:F "iwayonline\Terminal Server Publisher Users:rx" /y

:: Microsoft Project
xcacls "%systemdrive%\Program Files\Microsoft Office\OFFICE11\WINPROJ.exe" /D "NT Authority\authenticated users" /y
xcacls "%systemdrive%\Program Files\Microsoft Office\OFFICE11\WINPROJ.exe" /c /t /g Administrators:F SYSTEM:F "iwayonline\Terminal Server Project Users :rx" /y

:: Microsoft Visio
xcacls "%systemdrive%\Program Files\Microsoft Office\Visio11" /D "NT Authority\authenticated users" /y
xcacls "%systemdrive%\Program Files\Microsoft Office\Visio11" /c /t /g Administrators:F SYSTEM:F "iwayonline\Terminal Server Visio Users:rx" /y

:: Helpdesk Software
xcacls "%systemdrive%\Program Files\LBEHDW3\LBEHDW3.exe" /D "NT Authority\authenticated users" /y
xcacls "%systemdrive%\Program Files\LBEHDW3\LBEHDW3.exe" /c /t /g Administrators:F SYSTEM:F "iwayonline\Terminal Server Helpdesk Users:rx" /y

:: MailMarshal
xcacls "%systemdrive%\Program Files\NetIQ\MailMarshal" /D "NT Authority\authenticated users" /y
xcacls "%systemdrive%\Program Files\NetIQ\MailMarshal" /c /t /g Administrators:F SYSTEM:F "iwayonline\Terminal Server MailMarshal Console Users:rx" /y

:: End

rem exit