@ECHO OFF

REM 2012-05-29 v1
REM 2012-02-17 v2

:CheckDriveO
IF NOT Exist O:\. GOTO MapO
IF NOT Exist "O:\Users Shared Folders\TOL\." GOTO ReMapO
GOTO CheckDriveT

:ReMapO
NET USE O: /DELETE
:MapO
NET USE O: \\TOLFP01\D$
GOTO CheckDriveT

:CheckDriveT
IF NOT Exist T:\. GOTO MapT
IF NOT Exist "T:\Scripts\Signatures\." GOTO ReMapT
GOTO Action

:ReMapT
NET USE T: /DELETE
:MapT
NET USE T: \\TOLOCS01\Software
GOTO Action

:Action
O:
cd "O:\Users Shared Folders\TOL"
FOR /D %%A IN (*.*) DO call :ProcessUser %%A
GOTO DoEnd

:ProcessUser
CALL :ProcessProfile1 %1 Profile 
CALL :ProcessProfile1 %1 TSProfile 
CALL :ProcessProfile2 %1 Profile 
CALL :ProcessProfile2 %1 TSProfile 
GOTO End

:ProcessProfile1
IF EXIST ".\%1\%2\Application Data\Microsoft\Signatures\TOL-Signature.txt" ECHO %1 (%2): SignatureExists && GOTO End
IF NOT EXIST ".\%1\%2\Application Data\." ECHO %1 (%2): No Profile && GOTO End
xcopy /e /y "T:\Scripts\Signatures" ".\%1\%2\Application Data\Microsoft\Signatures\"
GOTO End

:ProcessProfile2
IF EXIST ".\%1\%2.V2\AppData\Roaming\Microsoft\Signatures\TOL-Signature.txt" ECHO %1 (%2.V2): SignatureExists && GOTO End
IF NOT EXIST ".\%1\%2.V2\AppData\." ECHO %1 (%2.V2): No Profile && GOTO End
xcopy /e /y "T:\Scripts\Signatures" ".\%1\%2.V2\AppData\Roaming\Microsoft\Signatures\"
GOTO End

:DoEnd
Pause
GOTO End

:End
