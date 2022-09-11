Rem Tuiora Apps script for Tuiora
rem Created by Aaron Gayton @ Staples Rodway Ltd 27-04-2005
rem Last change date:
rem Contact +64 6 7580956
rem copyright Staples Rodway Ltd


net use f: \\tuiora-altiris\express /user:tuiora-altiris\altiris alt1r1s /persistent:No



REM Deletes All Users Start Menu Programs and copies Across reguried applictaion short cuts
C:
cd \
cd C:\Documents and Settings\All Users\Start Menu\
DEl "*.*" /f /q
RMdir Programs /s /q 
MKdir Programs
cd..
F:
Cd \
Cd tuiora\CDS\tuiora-apps\Programs
XCOPy *.* "C:\Documents and Settings\All Users\Start Menu\Programs" /E /y

Rem Deletes items on Start Menu
c:
cd \
Cd C:\Documents and Settings\All Users\Start Menu\HP Information Center
del "*.*" /f /q
cd..
RMDir "HP Information Center"


REM Deletes All Users Desktop Programs and copies Across reguried applictaion short cuts
C:
cd \
Cd C:\Documents and Settings\All Users\Desktop
DEL "*.*" /f /q
F:
Cd \
cd Tuiora\CDS\tuiora-apps\Desktop\
XCOPy *.* "C:\Documents and Settings\All Users\Desktop" /e /y

REM Cleans unwanted shortcuts from the default user profile.
C:
cd \
cd C:\Documents and Settings\Default User\Start Menu\Programs
Del "Remote Assistance.lnk" /f/q

cd Accessories
DEL "*.*" /f /q
RMDIR /s /q Accessibility
RMDIR /s /q Entertainment


REM Deletes the Windows Catalogue shortcut
Rem C:
Rem cd \
Rem cd C:\Documents and Settings\All Users\Start Menu
Rem Del "Windows Catalog.lnk" /f /q


