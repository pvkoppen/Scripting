@echo off

REM -- Default Settings
set SendMailServer=smtp.tol.local
set SendMailFrom=Administrator@tuiora.co.nz
set SendMailTo=IT.Services@tuiora.co.nz
set MailQueue=D:\Altiris\Mail.Queue
if %MailQueue%' == ' set MailQueue = %~dp0

REM ------------------------------------
REM %1= <blank>, /PrintDate, /Log, <Any other parameter after logging>
REM %2= /process, /ProcessRecipient, /ProcessEmail, <EmailSubject>
REM %3= <EmailAttachment>, <RecipientToProcess>
REM ------------------------------------
if %1' == ' goto :Help
if %1' == /PrintDate' goto PrintDate
if not %1' == /Log' goto Log
if %2' == /process' goto ProcessMailQueue
if %2' == /ProcessRecipient' goto ProcessRecipient
if %2' == /ProcessEmail' goto ProcessEmail
goto CreateNew

:Log
:: Check if you can write to the log location
mkdir %MailQueue%
set SendMailLogFile="%MailQueue%\SendMail.log"
Echo. >> %SendMailLogFile%
IF NOT "%errorlevel%" == "0" set SendMailLogFile=nul
@for /f "tokens=1-9 delims=:. " %%a in ('time /t') do @for /f "tokens=1-9 delims=/ " %%A in ('date /t') do set DateTime=%%A%%B%%C%%D-%%a%%b%%c%%d
call %0 /Log %1 %2 %3 %4  >>%SendMailLogFile% 2>>&1
goto end

:CreateNew
call %0 /PrintDate
ECHO INFO: Save Email, Check or make recipient folder
mkdir %MailQueue%\%SendMailTo%
ECHO INFO: Save Email, Place Content in email file
if %3' == ' Echo %2 >> %MailQueue%\%SendMailTo%\%2.%DateTime%
if not %3' == ' type %3 >> %MailQueue%\%SendMailTo%\%2.%DateTime%
goto ProcessMailQueue

:ProcessMailQueue
ECHO INFO: Send Emails, Open All subfolders of mailqueue folder with an @ symbol
for /d %%a in (%MailQueue%\*@*) DO call %0 %1 /ProcessRecipient "%%a"
goto end

:ProcessRecipient
ECHO INFO: Send Emails, Open all email files and send: to=Foldername, subject=filename, body=File content.
for /f "tokens=*" %%a in ('dir /b %3\*.*') do call %0 %1 /ProcessEmail %3 "%%a"
echo off
goto end

:ProcessEmail
"%~dp0bmail.exe" -s %SendMailServer% -t %3 -f %SendMailFrom% -h -a %4 -m %3\%4
IF %ERRORLEVEL%' == 0' del %3\%4
goto end

:Help
ECHO The email has not been sent. Tool Usage:
ECHO call sendmail.cmd [:1 [:2]]
ECHO  - Help
ECHO      No parameters :: This help
ECHO  - Send Email
ECHO      Parameter :1  :: "Subject" 
ECHO      Parameter :2  :: "Filename" (Content of file is email body.)
ECHO  - Process Queue
ECHO      Parameter :1  :: /process 
pause
goto end

:PrintDate
echo -------------------------------------- 
@for /f "tokens=1-9 delims=:. " %%a in ('time /t') do @for /f "tokens=1-9 delims=/ " %%A in ('date /t') do echo -- Date-Time=%%A%%B%%C%%D-%%a%%b%%c%%d
echo -------------------------------------- 
goto end

:RublishCode
REM -----------------------------------------------------------------------
if %1' == ' goto Help
if %2' == ' goto EmptyBody
goto EmailFile
::EmailFile
if not exist %2 goto EmptyBody
echo. >>%EMAIL_LOGFILE% 2>>&1
echo -- Email Text >>%EMAIL_LOGFILE% 2>>&1
echo -------------------------------------- >>%EMAIL_LOGFILE% 2>>&1
echo: Subject: %1 >>%EMAIL_LOGFILE% 2>>&1
echo: Body: %2 >>%EMAIL_LOGFILE% 2>>&1
echo. >>%EMAIL_LOGFILE% 2>>&1
echo -- Mail Send >>%EMAIL_LOGFILE% 2>>&1
echo -------------------------------------- >>%EMAIL_LOGFILE% 2>>&1
"%~dp0bmail.exe" -s %SendMailServer% -t %SendMailTo% -f %SendMailFrom% -h -a %1 -m %2 >>%EMAIL_LOGFILE% 2>>&1
goto end
::EmptyBody
echo. >>%EMAIL_LOGFILE% 2>>&1
echo -- Email Text >>%EMAIL_LOGFILE% 2>>&1
echo -------------------------------------- >>%EMAIL_LOGFILE% 2>>&1
echo: Subject and Body: %1 >>%EMAIL_LOGFILE% 2>>&1
echo. >>%EMAIL_LOGFILE% 2>>&1
echo -- Mail Send >>%EMAIL_LOGFILE% 2>>&1
echo -------------------------------------- >>%EMAIL_LOGFILE% 2>>&1
"%~dp0bmail.exe" -s %SendMailServer% -t %SendMailTo% -f %SendMailFrom% -h -a %1 -b %1 >>%EMAIL_LOGFILE% 2>>&1
goto end
REM -----------------------------------------------------------------------

:end
rem set SendMailLogFile=
rem set SendMailServer=
rem set SendMailTo=
rem set SendMailFrom=
rem set MailQueue=

