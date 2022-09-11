# This script do a consistency check on the file system data source. The parameters have to be initialized first as given below.  Please give the values of parameters as appropriate for your environment.  You can customize this easily as per your needs. Save the attached file as a .ps1 file and invoke through the DPM Management Shell.

$dpmname = "DPM Server Name"; 
$pgname = "My PG"; 
$dsname = "G:\"; 

function StartDatasourceConsistencyCheck 
{ 
    param($dpmname, $pgname, $dsname, $isheavyweight) 

    write-host "Start consistency check on $dsname " 

    trap{"Error in execution... $_";break} 
    &{ 
        write-host "Getting protection group $pgname in $dpmname..." 
        $clipg = Get-ProtectionGroup $dpmname | where { $_.FriendlyName -eq $pgname } 

         if($clipg -eq $abc) 
          { 
              Throw "No PG found" 
          } 

        write-host "Getting $dsname from PG $pgname..." 
        $ds = Get-Datasource $clipg | where { $_.logicalpath -eq $dsname } 

        if($ds -eq $abc) 
         { 
              Throw "No Data Source found" 
         } 

        if( $isheavyweight -ne "true") 
        { 
            write-host "Starting light weight consistency check..." 
            $j = Start-DatasourceConsistencyCheck -Datasource $ds 
            $jobtype = $j.jobtype 
            if(("Validation") -notcontains $jobtype) 
                { 
                    Throw "Shadow Copy job not triggered" 
                } 
            while (! $j.hascompleted ){ write-host "Waiting for $jobtype job to complete..."; start-sleep 5} 
            if($j.Status -ne "Succeeded") {write-host "Job $jobtype failed..." } 
            Write-host "$jobtype job completed..." 
        } 
        else 
        { 
            write-host "Starting Heavy weight consistency check..." 
            $j = Start-DatasourceConsistencyCheck -Datasource $ds -HeavyWeight 
            $jobtype = $j.jobtype 
            if(("Validation") -notcontains $jobtype) 
                { 
                    Throw "Shadow Copy job not triggered" 
                } 
            while (! $j.hascompleted ){ write-host "Waiting for $jobtype job to complete..."; start-sleep 5} 
            if($j.Status -ne "Succeeded") {write-host "Job $jobtype failed..." } 
            Write-host "$jobtype job completed..." 
        } 

    } 
} 

#Example for usage 

StartDatasourceConsistencyCheck $dpmname $pgname $dsname "false" 
StartDatasourceConsistencyCheck $dpmname $pgname $dsname "true"
