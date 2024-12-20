#Set the file path (can be a network location)
$filePath = "\\mxnznpy31\COMMON\appexts\OpUtils\OpUtils Data.xlsx";
$exitCode = 0;  #success=0, error=1

Try {
    #Write-EventLog –LogName Application –Source "MXScheduledJobs" –EntryType Information –EventID 1 –Message "Debug 1."

    #Create the Excel Object
    $excelObj = New-Object -ComObject Excel.Application; 

    #Make Excel visible. Set to $false if you want this done in the background
    $excelObj.Visible = $false

    #Open the workbook
    $workBook = $excelObj.Workbooks.Open($filePath);

    #Refresh all data in this workbook
    $workBook.RefreshAll();
  
    #Save any changes done by the refresh
    $excelObj.DisplayAlerts = $false;  # if for any reason that excel cannot save DisplayAlerts=false will let powershell continue as if nothing went wrong. NOTE: in this case the schedjob will exit successfully altho the file didn't refresh or save.
    $workBook.Save();
   
} Catch {
    $exitCode = 1;
    Write-EventLog –LogName Application –Source "MXScheduledJobs" –EntryType Error –EventID 1 –Message "Scheduled Job RefreshOpUtilsData.ps1 failed, please check that EXCEL is not running";
} Finally {
 
    #Uncomment this line if you want Excel to close on its own
    $excelObj.DisplayAlerts = $false;
    $excelObj.Quit();
}

exit $exitCode;
