
$KeepDays   = 8
$DaysAgo    = (Get-Date).AddDays(-$KeepDays)
$FileFilter = "*.log"
$ScriptPath = Split-Path -Path $script:MyInvocation.InvocationName -Parent
$ScriptShortName = [System.IO.Path]::GetFileNameWithoutExtension($script:MyInvocation.InvocationName)
Start-Transcript -Path "$(Join-Path -Path $ScriptPath -ChildPath $ScriptShortName)-$(Get-Date -Format "dd").log" -Append

#Actions


Write-Host "[INFO ] Remove Transcript Logs: [$FileFilter] older then: '$DaysAgo' from folder: '$ScriptPath' ."
Get-ChildItem -Path $ScriptPath -Force -File -Filter $FileFilter | 
    Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DaysAgo } | Remove-Item -Force -Verbose
Stop-Transcript
