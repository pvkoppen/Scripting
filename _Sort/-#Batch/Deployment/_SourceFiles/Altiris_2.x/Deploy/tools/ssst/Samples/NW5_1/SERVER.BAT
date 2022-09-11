
REM *** ----------------------------------------------------------------------------------------------------
REM *** Check Server Type
REM *** ----------------------------------------------------------------------------------------------------
s:\cpq\systype s:\cpq\ssstksys.ini

if errorlevel 97 goto unknown

if errorlevel 96 goto DL585
if errorlevel 95 goto BL30p
if errorlevel 94 goto BL20pG3
if errorlevel 93 goto ML350G4
if errorlevel 92 goto ML370G4
if errorlevel 91 goto DL360G4
if errorlevel 90 goto DL380G4
if errorlevel 89 goto BL20pG2
if errorlevel 88 goto ML330g3
if errorlevel 87 goto DL740
if errorlevel 86 goto DL760G2
if errorlevel 85 goto DL560
if errorlevel 84 goto DL360G3
if errorlevel 83 goto DL320G2
if errorlevel 82 goto BL20p
if errorlevel 81 goto ML570G2
if errorlevel 80 goto DL380G3
if errorlevel 79 goto ML350G3
if errorlevel 78 goto ML310
if errorlevel 77 goto ML370G3
if errorlevel 76 goto DL320
if errorlevel 75 goto DL580G2
if errorlevel 74 goto DL580G2
if errorlevel 73 goto ML530G2
if errorlevel 72 goto BL10E
if errorlevel 71 goto DL360G2
if errorlevel 70 goto ML350G2
if errorlevel 69 goto ML330G2
if errorlevel 68 goto DL380G2
if errorlevel 67 goto ML370G2
if errorlevel 66 goto ML330e
if errorlevel 65 goto ML750
if errorlevel 64 goto DL760
if errorlevel 63 goto DL320
if errorlevel 62 goto ML350
if errorlevel 54 goto ML330
if errorlevel 53 goto DL580
if errorlevel 52 goto ML570
if errorlevel 51 goto DL360
if errorlevel 50 goto DL380
if errorlevel 49 goto ML530
if errorlevel 48 goto ML370
if errorlevel 47 goto ML350
if errorlevel 44 goto PL8500
if errorlevel 43 goto PL6400r
if errorlevel 36 goto PL3000
if errorlevel 34 goto PL1850r
if errorlevel 31 goto PL1600
if errorlevel 29 goto PL3000m1
if errorlevel 28 goto PL1600m1

:DL585
call S:\DL585.bat
goto end

:BL30p
call S:\BL30p.bat
goto end

:BL20pG3
call S:\BL20pG3.bat
goto end

:ML350G4
call S:\ML350G4.bat
goto end

:ML370G4
call S:\ML370G4.bat
goto end

:DL360G4
call S:\DL360G4.bat
goto end

:DL380G4
call S:\DL380G4.bat
goto end

:BL20pG2
call s:\BL20pG2.bat
goto end

:ML330G3
call s:\ML330G3.bat
goto end

:DL740
call s:\DL740.bat
goto end

:DL760G2
call s:\DL760G2.bat
goto end

:DL560
call s:\DL560.bat
goto end

:DL360G3
call s:\DL360G3.bat
goto end

:DL320G2
call s:\DL320G2.bat
goto end

:BL20p
call s:\BL20p.bat
goto end

:ML570G2
call s:\ML570g2.bat
goto end

:DL380G3
call s:\DL380G3.bat
goto end

:ML350G3
call s:\ML350g3.bat
goto end

:ML310
call s:\ml310.bat
goto end

:ML370G3
call s:\ML370g3.bat
goto end

:ML530G2
call s:\ML530g2.bat
goto end

:DL580G2
call s:\DL580g2.bat
goto end

:ML350G2
call s:\ML350g2.bat
goto end

:ML330G2
call s:\ML330g2.bat
goto end

:BL10e
call s:\BL10e.bat
goto end

:DL360G2
call s:\dl360g2.bat
goto end

:ML750
call s:\ml750.bat
goto end

:DL380G2
call s:\dl380g2.bat
goto end

:ML370G2
call s:\ml370g2.bat
goto end

:DL760
call s:\dl760.bat
goto end

:ML330e
call s:\ml330e.bat
goto end

:DL320
call s:\dl320.bat
goto end

:ML350
call s:\ml350.bat
goto end

:ML330
call s:\ml330.bat
goto end

:DL580
call s:\dl580.bat
goto end

:ML570
call s:\ml570.bat
goto end

:DL360
call s:\dl360.bat
goto end

:DL380
call s:\dl380.bat
goto end

:ML530
call s:\ml530.bat
goto end

:ML370
call s:\ml370.bat
goto end

:ML350
call s:\ml350.bat
goto end

:PL3000
call s:\pl3000r.bat
goto end

:PL3000m1
call s:\pl3000m1.bat
goto end

:PL8500
call s:\pl8500r.bat
goto end

:PL6400r
call s:\pl6400r.bat
goto end

:PL1850r
call s:\pl1850r.bat
goto end

:PL1600m1
call s:\pl1600m1.bat
goto end

:PL1600
call s:\pl1600.bat
goto end

:unknown
echo Why are we here....
pause

cd \
:end

