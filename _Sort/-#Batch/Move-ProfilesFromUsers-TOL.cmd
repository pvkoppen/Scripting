GOTO ERROR
D:
CD "\Users Shared Folders\TOL"
pause

FOR /D %%A IN (*.*) DO MKDir "..\..\Users Profile Folders\TOL\%%A"
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\Profile"      "..\..\Users Profile Folders\TOL\%%A\
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\Profile.V2"   "..\..\Users Profile Folders\TOL\%%A\
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\TSProfile"    "..\..\Users Profile Folders\TOL\%%A\
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\TSProfile.V2" "..\..\Users Profile Folders\TOL\%%A\
pause

net use w: \\TOLRODC01\d$
w:
CD "\Users Shared Folders\TOL"
pause

FOR /D %%A IN (*.*) DO MKDir "..\..\Users Profile Folders\TOL\%%A"
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\Profile"      "..\..\Users Profile Folders\TOL\%%A\
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\Profile.V2"   "..\..\Users Profile Folders\TOL\%%A\
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\TSProfile"    "..\..\Users Profile Folders\TOL\%%A\
FOR /D %%A IN (*.*) DO MOVE  ".\%%A\TSProfile.V2" "..\..\Users Profile Folders\TOL\%%A\
pause
GOTO END

:ERROR
ECHO This is a one off batch. Do not re-use.
pause
GOTO END

:END
