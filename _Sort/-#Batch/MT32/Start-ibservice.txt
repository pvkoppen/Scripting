for /f "tokens=1 delims=!" %%i in ('date /t') do set logdate=%%i
for /f "tokens=1 delims=!" %%i in ('time /t') do set logtime=%%i
echo --------------------------- %logdate%%logtime% --------------------------- >> D:\MT32\Scripts\Ibservice.log 2>>&1
echo INFO  Attempting to start the Interbase Service for Medtech32 >> D:\MT32\Scripts\Ibservice.log 2>>&1
echo INFO  NET START "INTERBASE GUARDIAN" command results: >> D:\MT32\Scripts\Ibservice.log 2>>&1
NET START "INTERBASE GUARDIAN" >> D:\MT32\Scripts\Ibservice.log 2>>&1
IF ERRORLEVEL 1 ( echo ERROR starting IB service @ %logdate%%logtime% >> D:\MT32\Scripts\Ibservice.log 2>>&1
		) ELSE (
			echo INFO  Started IB service @ %logdate%%logtime% >> D:\MT32\Scripts\Ibservice.log 2>>&1
		)
echo. >> D:\MT32\Scripts\Ibservice.log 2>>&1
