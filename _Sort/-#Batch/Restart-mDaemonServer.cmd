Shutdown /f /r /c "TOL Automated Restart: %~n0"

CALL "%~dp0Tools\sendmail.cmd" "Restarting %COMPUTERNAME% (%~n0)"