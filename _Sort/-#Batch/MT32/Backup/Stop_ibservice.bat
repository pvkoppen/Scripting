for /f "tokens=1 delims=!" %%i in ('date /t') do set logdate=%%i
for /f "tokens=1 delims=!" %%i in ('time /t') do set logtime=%%i
echo --------------------------- %logdate%%logtime% --------------------------- >> e:\IBService_Logs\Ibservice.log 2>&1
echo Attempting to stop the Interbase Service for backup >> e:\IBService_Logs\Ibservice.log 2>&1
echo. >> e:\IBService_Logs\Ibservice.log 2>&1 
echo Net Start command results. >> e:\IBService_Logs\Ibservice.log 2>&1
NET STOP "INTERBASE SERVER" >> e:\IBService_Logs\Ibservice.log 2>&1
echo. >> e:\IBService_Logs\Ibservice.log 2>&1
IF ERRORLEVEL 1 ( echo Error stopping IB service @ %logdate%%logtime% >> e:\IBService_Logs\Ibservice.log
		) ELSE (
			echo Stopped IB service @ %logdate%%logtime% >> e:\IBService_Logs\Ibservice.log
		)
echo. >> e:\IBService_Logs\Ibservice.log 2>&1