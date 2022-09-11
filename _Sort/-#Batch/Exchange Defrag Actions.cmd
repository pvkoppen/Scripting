@ECHO OFF
rem IF %1' == ' GOTO MailboxDatabase
rem IF %1' == ' GOTO MailboxBetterHomes
IF %1' == ' GOTO PublicFolderDatabase
GOTO ProcessDatabase

:ProcessDatabase
ECHO Params: %1="DB Name"; %2=LogPrefix; %3="Storage Group"; %4=LogDrive; %5=SysDrive
IF %5' == ' SET strError=[ERROR] Not Enough Parameters (%1)&&GOTO END
ECHO.
ECHO Manually dismount all databases in Storage group: %3
ECHO Please continue once the database is dismounted!
Pause
CD "%4\Program Files\Microsoft\Exchange Server\Mailbox\%~3\"
CD "%5\Program Files\Microsoft\Exchange Server\Mailbox\%~3\"
ECHO.
ECHO Performing a Recovery on Stogare Group: %3
eseutil /r %2 /l%4 /s%5 /d%5
IF NOT %ERRORLEVEL%' == 0' SET strError=[ERROR] Recovery of DB: %1&&GOTO END
ECHO.
ECHO Performing an Intergity Check on database: Mainbox Database
eseutil /g "%5\Program Files\Microsoft\Exchange Server\Mailbox\%~3\%~1.edb"
IF NOT %ERRORLEVEL%' == 0' SET strError=[ERROR] Integrity of DB: %1&&GOTO END
ECHO.
ECHO Performing a Defragmentation on database: Mainbox Database
eseutil /d "%5\Program Files\Microsoft\Exchange Server\Mailbox\%~3\%~1.edb"
IF NOT %ERRORLEVEL%' == 0' SET strError=[ERROR] Defragmentation of DB: %1&&GOTO END
ECHO.
ECHO Repair completed for Database: %1
ECHO You can mount this database again.
GOTO End

:MailboxDatabase
CALL %0 "Mailbox Database" e00 "First Storage Group" X: D:
GOTO End

:MailboxBetterHomes
CALL %0 "Mailbox BetterHomes" e00 "First Storage Group" X: D:
GOTO End

:PublicFolderDatabase
CALL %0 "Public Folder Database" e01 "Second Storage Group" X: D:
GOTO End

:End
IF NOT %strError%' == ' ECHO :%strError%

