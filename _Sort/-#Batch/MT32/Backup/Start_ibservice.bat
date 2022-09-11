for /f "tokens=1 delims=!" %%i in ('date /t') do set logdate=%%i
for /f "tokens=1 delims=!" %%i in ('time /t') do set logtime=%%i
echo --------------------------- %logdate%%logtime% --------------------------- >> e:\IBService_Logs\Ibservice.log 2>&1
echo Attempting to start Interbase Service for Medtech32 >> e:\IBService_Logs\Ibservice.log 2>&1
echo. >> e:\IBService_Logs\Ibservice.log 2>&1 
echo Net Start command results. >> e:\IBService_Logs\Ibservice.log 2>&1
NET START "INTERBASE GUARDIAN" >> e:\IBService_Logs\Ibservice.log 2>&1
echo. >> e:\IBService_Logs\Ibservice.log 2>&1
IF ERRORLEVEL 1 ( echo ERROR starting IB service @ %logdate%%logtime% >> e:\IBService_Logs\Ibservice.log 2>&1
		) ELSE (
			echo Started IB service @ %logdate%%logtime% >> e:\IBService_Logs\Ibservice.log 2>&1
		)
echo. >> e:\IBService_Logs\Ibservice.log 2>&1
