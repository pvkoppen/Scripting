$strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
$strScriptPath

$strScriptName     = split-path -leaf $global:MyInvocation.MyCommand.Definition
$strScriptName

[System.IO.Path]::GetFileNameWithoutExtension($strScriptName)
[System.IO.Path] | Get-Member -Static

write-host '---------------------------------------------------------'
$global:MyInvocation
write-host '---------------------------------------------------------'
$global:MyInvocation.MyCommand
write-host '---------------------------------------------------------'
$global:MyInvocation.MyCommand.Definition
write-host '---------------------------------------------------------'


$strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
$strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($global:MyInvocation.MyCommand.Definition)
$strLogName        = join-path -path $(join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles") -ChildPath "$strScriptName.log"
$strLogName        