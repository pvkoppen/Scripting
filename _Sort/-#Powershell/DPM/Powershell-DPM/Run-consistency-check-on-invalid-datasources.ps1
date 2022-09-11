----------------------------------- Start of Script --------------------------------

param ([string] $DPMServerName)

if(("-?","-help") -contains $args[0])
{
    Write-Host "Description: This script runs a consistency check on all the actively protected datasources which are not in valid state."
    Write-Host "Usage: Validate-InvalidDatasources.ps1 [-DPMServerName] <Name of the DPM server>"
    Write-Host "Example: Validate-InvalidDatasources.ps1 mohitc02"

    exit 0
}

if (!$DPMServerName)
{
    $DPMServerName = Read-Host "DPM server name"

    if (!$DPMServerName)
    {
        Write-Error "Dpm server name not specified."
        exit 1
    }
}

if (!(Connect-DPMServer $DPMServerName))
{
    Write-Error "Failed to connect To DPM server $DPMServerName"
    exit 1
}

$jobList = @()
foreach ($datasource in @(Get-Datasource -DPMServerName $DPMServerName | ? {$_.Protected -and $_.State -eq "Invalid"}))
{
    $jobList += @{Job = Start-DatasourceConsistencyCheck -Datasource $datasource; Datasource = $($datasource.LogicalPath)}
}

$completedJobsCount = 0
while ($completedJobsCount -ne $jobList.Length)
{
    $completedJobsCount = 0
    Write-Host ""

    foreach ($jobHT in $jobList)
    {
        if ($jobHT.Job.HasCompleted)
        {
            Write-Host "Consistency check on $($jobHT.Datasource) completed. Status: $(($jobHT.Job).Status)"
            $completedJobsCount += 1
        }
        else
        {
            Write-Host "Runnning consistency check on $($jobHT.Datasource)..."
        }
    }

    sleep 5
}


--------------------------------- End of script -------------------------------------

