@REM -----------------------------------------------------------
@REM 2006-12-22: 1.0: First Edition
@REM 2010-07-09: 1.1: Added help
@REM -----------------------------------------------------------

@if %1' == ' goto end
@if %1' == /?' goto help
@if %2' == ' goto run
@goto getsid

:run
@for /f "usebackq" %%a in (`CALL %0 %1 run`) do set GRPSID=%%a
@ECHO SET GRPSID=%GRPSID%
@goto end

:getsid
::@dsquery group -name "*IT Services" | dsget get -sid
@dsget group %1 -sid | find "S-1-"
@goto end

:help
@echo Syntax: %~nx0 "Domain\Group Name"
@ECHO Output: %%GRPSID%% =  The group SID
GOTO End

:end
