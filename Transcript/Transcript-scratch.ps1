
#split-path -Path $MyInvocation.PSCommandPath -Leaf
#$MyInvocation
#$MyInvocation.MyCommand
#$MyInvocation.MyCommand.Name
#$MyInvocation.MyCommand.Source
#$MyInvocation.InvocationName

#[System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.InvocationName)
<#
  $strScriptPath     = split-path -parent $script:MyInvocation.MyCommand.Definition
  $strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
  $strScriptPath
  $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($global:MyInvocation.MyCommand.Definition)
  $strScriptName
  $strLogPath        = join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles"
  $strLogPath
  $strLogName        = join-path -path $strLogPath -ChildPath "$strScriptName.log"
  $strLogName

