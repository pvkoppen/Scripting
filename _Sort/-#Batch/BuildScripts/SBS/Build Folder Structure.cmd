@Echo Off

ECHO.
ECHo Preparing Drive: C
ECHO - Create folder(s): Scripts
MD C:\Scripts

ECHO.
ECHo Preparing Drive: D

ECHO - Create folder(s): Backup / Software
MD "D:\Backup-Config-Dump"
MD "D:\Documentation-Drivers-Software"
NET SHARE Software="D:\Documentation-Drivers-Software" /GRANT:Everyone,FULL /REMARK:"Software"

ECHO - Create folder(s): Quarantine
MD "D:\Quarantine\Attachments"

ECHO - Create folder(s): Company
MD "D:\Company Shared Folders\Shared By All"
NET SHARE SharedByAll="D:\Company Shared Folders\Shared By All" /GRANT:Everyone,FULL /REMARK:"Company Folder - Shared By All"

PAUSE
