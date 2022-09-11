@ECHO OFF
GOTO Action

:Action
ECHO -- NIC --------------------------------------------
IPCONFIG /ALL | FIND /i "."
ECHO.
ECHO -- Firewall --------------------------------------------
netsh advfirewall show allprofiles | find /i "state"
ECHO -- Admin PW --------------------------------------------
ECHO Run this command with Elevated Permissions!
NET USER Administrator Bl@nk-@cc3ss?
IF EXIST \\localhost\sysvol\. GOTO AD
ECHO -- ADDC PW --------------------------------------------
ECHO (%COMPUTERNAME% is not an ADDC server)
GOTO DoEnd

:AD
ECHO -- ADDC PW --------------------------------------------
ECHO Update ADDC Restore password
REM ntdsutil v1: Set DSRM password - Reset Password on server null - [Password] - q - q
REM ntdsutil v2: Set DSRM password - Sync from domain account Administrator
ntdsutil "Set DSRM password" "Sync from domain account Administrator" q q
if %ERRORLEVEL%' == 1' GOTO ntdsutil
GOTO DoEnd

:ntdsutil
ECHO ntdsutil: Set DSRM password - Reset Password on server null - [Password] - q - q
ntdsutil
GOTO DoEnd

:DoEnd
ECHO -- END --------------------------------------------
Pause
GOTO End

:End
