@ECHO OFF
GOTO Action

:Action
ECHO Shutdown Service
NET STOP ZeacomServer

SET strBackupFolder=\\TOLMM02\Backup$\CustomBackup\Zeacom\
SET strDate=20150806

IF NOT EXIST "%strBackupFolder%%strDate%\CTI\bin\." MKDIR "%strBackupFolder%%strDate%\CTI\bin"
robocopy.exe -e -r:1 -w:1 "D:\Program Files (x86)\Telephony\CTI\bin" "%strBackupFolder%%strDate%\CTI\bin"

IF NOT EXIST "%strBackupFolder%%strDate%\CTI\Client\." MKDIR "%strBackupFolder%%strDate%\CTI\Client"
robocopy.exe -e -r:1 -w:1 "D:\Program Files (x86)\Telephony\CTI\Client" "%strBackupFolder%%strDate%\CTI\Client"
GOTO End

:End