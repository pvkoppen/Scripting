@ECHO OFF

ECHO d=%~d0, p=%~p0, n=%~n0, x=%~x0, f=%~f0, Source=%0, NoQuotes=%~0.
ECHO Date=%date%, Time=%time%

goto end

- Migrate data
- rename folders
- fix security
- Update Profile folder
- Update TSProfile Folder
- Run AD Check
- Update Login Script
- Update Group Policy
- Fixup TSHome and other folder under Users

Server Role: File Services
Role Services:
- Windows Search Service
- Windows Server 2003 File Services
- - Indexing Service

:End
pause