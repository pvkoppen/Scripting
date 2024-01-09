rem Windows 2003 hot fixes script for STDC
rem Created by Kelvin Brace @ Staples Rodway Ltd 9 June 2003
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use i: \\staples-altiris\express /user:administrator 0t100i10s /persistent:No

i:
cd\
cd Staples\CDS\patches




setlocal
set PATHTO=i:\Staples\CDS\patches

:: Install the hotfixes

start /wait %PATHTO%\WindowsServer2003-KB819696-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB823182-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB823559-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB824105-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB824141-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB825119-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB828035-x86-ENU.exe /Z /U
start /wait %PATHTO%\WindowsServer2003-KB828741-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB832894-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB835732-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB837001-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB839643-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB840374-x86-ENU.EXE /Z /U
start /wait %PATHTO%\WindowsServer2003-KB828750-x86-ENU.EXE /Z /U

start /wait %PATHTO%\ENU_Q832483_MDAC_X86.EXE /C:"dahotfix.exe /q /n" /q:a
start /wait %PATHTO%\WindowsMedia9-KB819639-x86-ENU.exe /Z /U


echo wait
echo wait
echo wait





