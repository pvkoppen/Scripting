$OrgFolders = Get-ChildItem -Directory
foreach ($OrgFolder in $OrgFolders) {
  Write "[INFO ] Processing Organisation: $OrgFolder"
  cd .\$OrgFolder
  $UserFolders = Get-ChildItem
  foreach ($UserFolder in $UserFolders) {
    $ADUser = Get-ADUser -filter {SAMAccountName -eq $UserFolder} -SearchBase "OU=$OrgFolder,DC=tol,DC=local"
    If     ($ADUser.Count -lt 1) {
      Write "[ERROR] User: $UserFolder; Account not found. ($($ADUser.Count))"
    } elseIf ($ADUser.Count -gt 1) {
      Write "[ERROR] User: $UserFolder; Multiple accounts found. ($($ADUser.Count))" 
    } else   {
##      Write "[INFO ] User: $UserFolder; Found account: $ADUser. ($($ADUser.Count))" 
    }
  }
  cd .\..
}

#-~*.*;-*.bak;-*.tmp;-Thumbs.db;-desktop.ini

# $list= dir '\\tolfp01\Archive$\Users Profile Folders\TOL'
# foreach ($item in $list) { write "[ERROR] User: $item" }

# $list= dir '\\tolfp01\Archive$\Users Shared Folders\TOL'
# foreach ($item in $list) { write "[ERROR] User: $item" }
