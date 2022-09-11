param ([string] $StartFolder='')

Function ProcessFolder ([string]$strFolder) {
  Write "$strFolder"
  $DirList = Get-ChildItem -Directory $strFolder
  foreach ($Dir in $DirList) {
    $NewDir = Join-Path -Path $strFolder -ChildPath $Dir
    ProcessFolder($NewDir)
  }
}

ProcessFolder($StartFolder)

# -ErrorAction silentlycontinue
#if ($error) { Write "[ERROR] $Error" }

