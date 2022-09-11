@Echo off

IF %1' == /Process1' GOTO FixACL1
IF %1' == /Process2' GOTO FixACL2
IF %1' == /Process3' GOTO FixACL3
GOTO Action

:Action
GOTO End
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Corporate Services\Finance\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Corporate Services\Human Resources\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Corporate Services\ICT\"

CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Cultural Services\Competency\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Cultural Services\Rongoa\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Cultural Services\TDHB Cultural Kaiawhina\"

CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\HBS\Disability Support Services\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\HBS\Elder Abuse Protection\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\HBS\HBSS\"

CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Mental Health\MHAS\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Mental Health\Residential\"

CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Primary Health\Mama Pepe Hauora\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Primary Health\Primary Care\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Primary Health\Tui Ora Family Health\"

CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\AKP - Aukati Kaipaipa\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\Cervical Screening\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\Injury Prevention\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\Mama Pepe Hauora (MPH)\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\Nutrition & Physical Activity\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\Pahake Programme\"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Public Health\Problem Gambling\"

CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Rangatahi Services\Alt Ed"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Rangatahi Services\ICAY"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Rangatahi Services\Kaiawhina and Kaumatua"
CALL %0 /Process1 "\\TOLFP01\SharedTOL$\Service Delivery\Rangatahi Services\Youth Service"

GOTO End

:FixACL1
ECHO Root:%2
FOR /F "usebackq tokens=*" %%A in (`DIR /b /AD %2.`) do CALL %0 /Process2 %2 "%%A"
GOTO End

:FixACL2
ECHO - Folder:%3
FOR /F "usebackq tokens=*" %%A in (`DIR /b /AD %2.\%3\.`) do CALL %0 /Process3 %2 %3 "%%A" 
GOTO End

:FixACL3
ECHO - SubFolder:%4
FOR /F "usebackq tokens=*" %%A in (`DIR /b "%~2.\%~3\%~4\."`) do ECHO "%~2.\%~3\%~4\%%A"&&icacls "%~2.\%~3\%~4\%%A" /reset
GOTO End

:End