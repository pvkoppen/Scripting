for /f "tokens=1 delims=!" %%i in ('date /t') do set logdate=%%i
for /f "tokens=1 delims=!" %%i in ('time /t') do set logtime=%%i
echo --------------------------- %logdate%%logtime% --------------------------- >> D:\MT32\Scripts\Ibservice.log 2>>&1
echo INFO  Attempting to stop the Interbase Service for Backup >> D:\MT32\Scripts\Ibservice.log 2>>&1
echo INFO  NET STOP "INTERBASE SERVER" command results: >> D:\MT32\Scripts\Ibservice.log 2>>&1
NET STOP "INTERBASE SERVER" >> D:\MT32\Scripts\Ibservice.log 2>>&1
IF ERRORLEVEL 1 ( echo ERROR stopping IB service @ %logdate%%logtime% >> D:\MT32\Scripts\Ibservice.log 2>>&1
		) ELSE (
			echo INFO  Stopped IB service @ %logdate%%logtime% >> D:\MT32\Scripts\Ibservice.log 2>>&1
		)
echo. >> D:\MT32\Scripts\Ibservice.log 2>>&1