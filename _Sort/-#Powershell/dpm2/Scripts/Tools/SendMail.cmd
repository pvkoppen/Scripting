@ECHO OFF
REM Name        : SendMail.cmd
REM Description : Script used for sending automated email message to the default IT management group using: bmail.exe.
REM Author      : Peter van Koppen,  Tui Ora Limited
REM -----------------------------------------------------------------------

REM -----------------------------------------------------------------------
REM Change Log.
REM -----------------------------------------------------------------------
REM 2006-06-01: First sendmail script to automate commandline emailing using bmail.exe.
REM 2008-06-15: Updateded the sendmail script with a MailQueue system.
REM 2008-06-30: Added this ChangeLOG.
REM 2008-11-11: Changed the MailQueue folder to %~dp0Queue.
REM 2008-12-05: Changed the MailQueue folder to %~dp0\%~n0.Queue, Changed SendMail script location to: tools.
REM 2009-01-04: Version 1.3a
REM 2009-01-19: v1.3b: Set parameters changed
REM 2009-08-01: v1.3c: Updated time format
REM 2009-08-01: v1.3d: Added USERDNSDOMAIN
REM 2010-03-16: 1.3e: Updated Date-Time format
REM -----------------------------------------------------------------------

REM -- Default Settings
REM -----------------------------------------------------------------------
IF NOT %USERDNSDOMAIN%' == ' SET InternalDomain=%USERDNSDOMAIN%
IF %USERDNSDOMAIN%' == ' SET InternalDomain=tol.local
SET SendMailServer=smtp.%InternalDomain%
SET SendMailFrom=%COMPUTERNAME%@%InternalDomain%
SET SendMailTo=ITServices@%InternalDomain%
SET MailQueue=%~dp0%~n0.Queue
ECHO INFO Script Parameters: %*

SET SendMailFrom=Administrator@%InternalDomain%
SET SendMailTo=ITServices@tuiora.co.nz

REM -----------------------------------------------------------------------
REM %1= <blank>, /PrintDate, /Log, <Any other parameter after logging>
REM %2= /process, /ProcessRecipient, /ProcessEmail, <EmailSubject>
REM %3= <EmailAttachment>, <RecipientToProcess>
REM -----------------------------------------------------------------------
IF %1' == ' GOTO Help
IF %1' == /PrintDateTime' GOTO PrintDateTime
IF %1' == /GetDateTime' GOTO GetDateTime
IF NOT %1' == /Log' GOTO Log
IF %2' == /process' GOTO ProcessMailQueue
IF %2' == /Process' GOTO ProcessMailQueue
IF %2' == /ProcessRecipient' GOTO ProcessRecipient
IF %2' == /ProcessEmail' GOTO ProcessEmail
GOTO CreateNew

:Help
REM -----------------------------------------------------------------------
ECHO The email has not been sent. Tool Usage:
ECHO call %~nx0 [:1 [:2]]
ECHO  - Help
ECHO      No parameters :: This help
ECHO  - Send Email
ECHO      Parameter :1  :: "Subject" 
ECHO      Parameter :2  :: "Filename" (Content of file is email body.)
ECHO  - Process Queue
ECHO      Parameter :1  :: /process 
Pause
GOTO End

:PrintDateTime
REM -----------------------------------------------------------------------
ECHO -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO ECHO -- DATE-TIME=%%D%%C%%B(%%A)-%%c%%d%%a%%b 
ECHO -----------------------------------------------------------------------
GOTO End

:GetDateTime
REM -----------------------------------------------------------------------
@FOR /F "tokens=1-9 delims=/ " %%A IN ('date /t') DO @FOR /F "tokens=1-9 delims=:. " %%a IN ('time /t') DO SET strDateTime=%%D%%C%%B(%%A)-%%c%%d%%a%%b&& SET strDate=%%D%%C%%B(%%A)&& SET strTime=%%c%%d%%a%%b
REM -----------------------------------------------------------------------
GOTO End

:Log
REM Check if you can write to the log location
REM -----------------------------------------------------------------------
MKDIR %MailQueue%
SET SendMailLogFile="%MailQueue%\%~n0.Log"
ECHO. >> %SendMailLogFile%
IF NOT "%ERRORLEVEL%" == "0" SET SendMailLogFile=nul
CALL %0 /GetDateTime
CALL %0 /PrintDateTime
CALL %0 /Log %*  >>%SendMailLogFile% 2>>&1
RMDIR %MailQueue%
GOTO Final

:CreateNew
REM -----------------------------------------------------------------------
CALL %0 /PrintDateTime
ECHO INFO: Save Email, Check or make recipient folder
MKDIR %MailQueue%\%SendMailTo%
ECHO INFO: Save Email, Place Content in email file
IF %3' == ' ECHO %2 >> %MailQueue%\%SendMailTo%\%2.%strDateTime%
IF NOT %3' == ' TYPE %3 >> %MailQueue%\%SendMailTo%\%2.%strDateTime%
GOTO ProcessMailQueue

:ProcessMailQueue
REM -----------------------------------------------------------------------
ECHO INFO: Send Emails, Open All subfolders of mailqueue folder with an @ symbol
FOR /F "tokens=*" %%A IN ('DIR /B /AD %MailQueue%\*@*') DO CALL %0 %1 /ProcessRecipient "%%A"
GOTO End

:ProcessRecipient
REM -----------------------------------------------------------------------
ECHO INFO: Send Emails, Open all email files and send: to=Foldername, subject=filename, body=File content.
FOR /F "tokens=*" %%A in ('DIR /B %MailQueue%\%3\*.*') DO CALL %0 %1 /ProcessEmail %3 "%%A"
RMDIR %MailQueue%\%3
GOTO End

:ProcessEmail
REM -----------------------------------------------------------------------
"%~dp0BMail.exe" -s %SendMailServer% -t %3 -f %SendMailFrom% -h -a %4 -m %MailQueue%\\%3\\%4
IF %ERRORLEVEL%' == 0' DEL %MailQueue%\%3\%4
GOTO End

:Final
REM -----------------------------------------------------------------------
SET SendMailLogFile=
SET SendMailServer=
SET SendMailTo=
SET SendMailFrom=
SET MailQueue=
GOTO End

:End
REM -----------------------------------------------------------------------

