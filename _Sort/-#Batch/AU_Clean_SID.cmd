@ECHO OFF
Echo Save the batch file "AU_Clean_SID.cmd". This batch file will do the following:
Echo 1.    Stops the wuauserv service
Echo 2.    Deletes the AccountDomainSid registry key (if it exists)
Echo 3.    Deletes the PingID registry key (if it exists)
Echo 4.    Deletes the SusClientId registry key (if it exists)
Echo 5.    Restarts the wuauserv service
Echo 6.    Resets the Authorization Cookie
Echo 7.    More information on http://msmvps.com/Athif
ECHO 8.    https://blogs.technet.microsoft.com/csstwplatform/2012/05/27/wsus-script-to-delete-duplicate-sid-created-by-disk-imaging-disk-cloning/
Pause
@echo on
net stop wuauserv
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v AccountDomainSid /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v PingID /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /f
net start wuauserv
wuauclt /resetauthorization /detectnow
Pause