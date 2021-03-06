#Author: ITomation.
#Website: itomation.ca
#INSTRUCTIONS: Run getLastPatchDates.PS1. It will utilize _worker.ps1.

#path to working directory
$path = $PSScriptRoot

#clean previous run
remove-item -path "$path\online.txt" -ErrorAction SilentlyContinue
remove-item -path "$path\offline.txt" -ErrorAction SilentlyContinue
remove-item -path "$path\onlineInaccessible.txt" -ErrorAction SilentlyContinue
remove-item -path "$path\patched.txt" -ErrorAction SilentlyContinue
remove-item -path "$path\not-patched.txt" -ErrorAction SilentlyContinue
remove-item -path "$path\fullreport.txt" -ErrorAction SilentlyContinue

#check if there is already a powershell process running - if there is, halt.
#this is to ensure we are not running multiple instances of the same job
#$differentPSprocess = Get-Process powershell -ErrorAction SilentlyContinue
#if ($differentPSprocess) { write-host "Quitting. Please close all powershell instances and try again. (i.e. check task manager for 'powershell.exe' and close any that are open.)" ; Exit }

#get full list of servers
$allservers = get-content -path "$path\_computers.txt"

#get existing processes
$countExisting = (Get-Process powershell -ErrorAction SilentlyContinue).count

$allservers | ForEach-Object { 
    if ($_ -ne '')
    {
        $hname = $_.trim()
        #check if server is online
        $exist = Test-Connection -computername $hname -count 1 -quiet -ErrorAction SilentlyContinue
        if ($exist -eq "true") #server is online
        {
            write-host "$hname --> online"
            $hname | out-file -filepath "$path\online.txt"  -append #add server to online list

            #check server's share
            $accessible = ""
            $accessible = Test-Path "\\$hname\c$"
            if(!($accessible))
            {
                $hname | out-file -filepath "$path\onlineInaccessible.txt"  -append #add server to inaccessible list
            }
            
        }
        else #server is offline
        {
            write-host "$hname --> offline"
            $hname | out-file -filepath "$path\offline.txt"  -append #add server to offline list
        }
    }
    else {write-host "blank line" } #do nothing if the line is blank
}     

#get list of online servers
$onlineservers = get-content -path "$path\online.txt"
 
#count the servers
$numcontents = (($onlineservers | Measure-Object).count)
#divide worker process in batches of specified $intDiv (i.e. 5, 10, 20, etc...).
#higher number --> slower and less resource intensive
#lower number --> faster but more resource intensive
$intDiv = 5 #change this number if you want each process to query more servers
[int]$cycle = $numcontents/$intDiv
$cyclecount = 1

#divide the work based on number of servers per worker
while ($cyclecount -le $cycle)
{
    $subcontents = $onlineservers[(($cyclecount-1)*$intDiv)..(($cyclecount*$intDiv)-1)]
    $subcontents | out-file "$path\group$cyclecount.log"
    start-process powershell.exe -ArgumentList "-file $path\_worker.ps1 -GM $cyclecount" -WindowStyle Hidden
    write-host "running group $cyclecount"
    $cyclecount += 1
}

$subcontents = $onlineservers[(($cyclecount-1)*$intDiv)..($numcontents-1)]
$subcontents | out-file "$path\group$cyclecount.log"

start-process powershell.exe -ArgumentList "-file $path\_worker.ps1 -GM $cyclecount" -WindowStyle Hidden
write-host "running group $cyclecount"

write-host "processing...please wait as this may take a while"

$stillrunning = Get-Process powershell -ErrorAction SilentlyContinue
$remaining = $stillrunning.count - $countExisting
#write-host "groups remaining: $remaining"

#keep the script alive while there are workers in progress
while ($stillrunning)
{
    Start-Sleep -m  100
    $stillrunning = Get-Process powershell -ErrorAction SilentlyContinue
    if ($remaining -ne $stillrunning.count)
    {
        $remaining = $stillrunning.count
        write-host "groups remaining:" ($stillrunning.count-$countExisting)
    }

    if($remaining -eq $countExisting){$stillrunning -eq 0; break;}
}

write-host "Generating report..."

#rest
Start-Sleep -s 5

#merge the files
$finalFile = Join-Path $path "fullreport.txt"
"server,lastpatch,lastreboot,rpcOK" | out-file -filepath $finalFile  -append

$filesToMerge = Get-ChildItem -Path $path -Filter results*.log -File

#merge worker results
foreach ($file in $filesToMerge)
{
    Get-Content "$path\$file" | select | Out-File -FilePath $finalFile -Append
}

#cleanup worker log files
remove-item -path "$path\*.log" -ErrorAction silentlycontinue

#done
write-host("Completed. See " + $path + "\fullreport.txt")