set TargetFolder=\\tolmm02\Backup$\CustomBackup\MedTech32\%COMPUTERNAME%\20151110-Medtech-TOSD
mkdir %TargetFolder%

RoboCopy.exe /E /R:1 /W:3 "D:\MedTech" "%TargetFolder%\MT32" /xf *.IB
RoboCopy.exe /E /R:1 /W:3 "C:\HLINK" "%TargetFolder%\HLINK"
RoboCopy.exe /E /R:1 /W:3 "C:\Program Files\Healthlink" "%TargetFolder%\HealthLink"
RoboCopy.exe /E /R:1 /W:3 "C:\Program Files (x86)\Healthlink" "%TargetFolder%\HealthLink (x86)"
RoboCopy.exe /E /R:1 /W:3 "C:\Admin" "%TargetFolder%\Admin"
GOTO End

:Extra
pause
NET STOP IBS_MedTech_IB11
"%~dp0..\Tools\RoboCopy.exe" /E /R:1 /W:3 "D:\MT32" "%TargetFolder%\MT32" *.IB
rem NET START IBG_MedTech_IB11
"%~dp0..\Tools\RoboCopy.exe" /R:1 /W:3 "D:\Backup-Config-Dump\MedTech32" "%TargetFolder%" /xf "*blob.ibk" "*mt32.ibk" 

:End

