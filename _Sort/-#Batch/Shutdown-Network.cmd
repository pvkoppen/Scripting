GOTO Check

:Shutdown
Echo Shutdown all servers! are you sure?
Pause
ECHO Terminal Servers/Desktops
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolts01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolts02
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolts03
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tammt01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolwt01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m PHOMT01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m MOLMH01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m MOLMH02
pause
ECHO VM-Guests
rem shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m phodw
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m toles01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m thphs01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolpt01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolsp01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolmm01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolse01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolws01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolws02
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolwu01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m koimt01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolpe01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolds01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m trpeq01
pause
ECHO Physical Servers: Application
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m callista
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolms01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolss02
pause
ECHO Physical Servers: VM and AD
rem shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolvs01
rem shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolvs02 -- ESX
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolvs03
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m toldv01
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m toldv02
shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolss01
pause
ECHO Physical Servers: Router
rem shutdown /f /s /t 5 /c "IT: Server and Network Maintenance" /m tolgw01

:Check
