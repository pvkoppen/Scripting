#split-path -Path $MyInvocation.PSCommandPath -Leaf
#$MyInvocation
#$MyInvocation.MyCommand
#$MyInvocation.MyCommand.Name
#$MyInvocation.MyCommand.Source
#$MyInvocation.InvocationName

[System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.InvocationName)


-- Powershell Version
-------------------------------------------------------
echo $psversiontable


-- DotNet 4.5 installed?
-------------------------------------------------------
function Test-Net45 {
  if (Test-Path 'HKLM:SOFTWAREMicrosoftNET Framework SetupNDPv4Full') {
    if (Get-ItemProperty 'HKLM:SOFTWAREMicrosoftNET Framework SetupNDPv4Full' -Name Release -ErrorAction SilentlyContinue) { return $True }
    return $False
  }
}

If (Test-Net45) { ECHO True } else { Echo False }

-- Exchange: Free space in Mailbox DB
-------------------------------------------------------
Get-MailboxDatabase -Status | ft name,databasesize,availablenewmailboxspace -auto

-- Exchange: Offline Defrag
-------------------------------------------------------
F:
cd F:\Program Files\Microsoft\Exchange Server\V14\Mailbox\Methanex NZ DB1\
Dismount-Database "Methanex NZ DB1"
eseutil /d ".\Methanex NZ DB1.edb"

-- Exchange: Move Mailbox DB and Log
-------------------------------------------------------
Move-DatabasePath -Identity "Methanex NZ DB1" -EdbFilePath "D:\Services\Microsoft\Exchange Server\V14\Mailbox\Methanex NZ DB1\Methanex NZ DB1.edb" -LogFolderPath "D:\Services\Microsoft\Exchange Server\V14\Mailbox\Methanex NZ DB1"


-- Folder Quota: 
-------------------------------------------------------
$arrFolders = Get-childItem E:\Home | where {$_.Attributes -eq 'Directory'}
foreach ($tmpFolder in $arrFolders) {
  $tmpFolderName = $tmpFolder.Name
  Write-Host "FolderName = $tmpFolderName."
  $tmpQuota = dirquota quota list -path:E:\Home\$tmpFolderName
  If ($LASTEXITCODE -eq 0) {
    #Write-Host "$($tmpQuota[6])"
    #Write-Host "$($tmpQuota[5])"
  } else {
    Write-Host "ERROR: $($tmpQuota)"
  }
}

-- Update Help
-------------------------------------------------------
Update-Help

-- Messagebox
-------------------------------------------------------
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Operation Completed",0,"Done",0x1)
$wshell.Popup("Welcome $Env:ComputerName Your network drives are mounted",5,"Mappning")
  [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [System.Windows.Forms.MessageBox]::Show("The Growth Tube Monitor process has failed. Restart this computer to resolve this issue.", "Check-TubeGrowthMonitor", 0) 
