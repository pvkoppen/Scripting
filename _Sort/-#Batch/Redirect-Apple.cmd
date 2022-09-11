@ECHO OFF
C:
FOR %%A IN (User;Zara;William;Public) DO CALL :ProcessUserFolder %%A AppData\Roaming\ "Apple Computer" "D:\Private\Joint\Redirected\Roaming-AppleComputer"
FOR %%A IN (User;Zara;William;Public) DO CALL :ProcessUserFolder %%A Music\ iTunes "D:\Media\Audio\iTunes"
REM FOR %%A IN (User;Zara;William;Public) DO CALL :UnDoUserFolder %%A AppData\Roaming\ "Apple Computer" "D:\Private\Joint\Redirected\Roaming-AppleComputer"
REM FOR %%A IN (User;Zara;William;Public) DO CALL :UnDoUserFolder %%A AppData\Roaming\ iTunes "D:\Media\Audio\iTunes"
GOTO End

:ProcessUserFolder
ECHO [INFO ] Processing: User=%1, Path=\Users\%1\%2., Folder=%3, 
ECHO [INFO ]   Target=%4
IF NOT EXIST \Users\%1\%2. GOTO ERROR-UserPath
CD \Users\%1\%2.
IF EXIST     .\%3.%1 GOTO  ERROR-UserFolderExists
IF NOT EXIST .\%3    MKDIR .\%3.%1
IF EXIST     .\%3    REN   .\%3 %3.%1
ATTRIB +H +S .\%3.%1
IF EXIST     .\%3    GOTO  ERROR-UserFolderRename
MKLINK /J .\%3 %4
GOTO End

:ERROR-UserPath
ECHO [ERROR] The path: \Users\%1\%2. does not EXIST. Process aborted!
GOTO End

:ERROR-UserFolderExists
ECHO [ERROR] The folder: .\%3.%1 EXISTS. Undo this first before we can complete this process!
GOTO End

:ERROR-UserFolderRename
ECHO [ERROR] The folder: .\%3 for user "%1" could not be renamed!
GOTO End

:UnDoUserFolder
ECHO [WARN ] UnDo not ready Yet!
GOTO End
fsutil Reparsepoint delete "Apple Computer"
GOTO End

:End
