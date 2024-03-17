# --------------------------------------------
# -- 
# --------------------------------------------

$logfile = "C:/temp/stoppedServices.csv"
$servers= get-content "c:\servers\Servers.txt"
$errors = ""

foreach ($server in $servers) {
    $errors += Invoke-Command -ComputerName $server -ScriptBlock {
		$startErrors = "";
		Get-WmiObject Win32_Service | where { ($_.startmode -like "*auto*") -and ($_.state -notlike "*running*") } | select DisplayName,Name,StartMode,State | %{
			try { start-service $_.Name -ErrorAction stop } 
			catch { $startErrors += "$env:COMPUTERNAME,$_{.Exception.Message}`r`n" }
        }
		return $startErrors
    }
}

$errors > $logfile
