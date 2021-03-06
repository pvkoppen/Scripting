#Author: ITomation.

Param([string]$GM)
  
 #get working directory
 $path = $PSScriptRoot
 
 #establish dates
 $date0 = get-date -format "yyyy-MM-dd"
 $date1 = get-date (get-date).adddays(+1) -format "yyyy-MM-dd"
 
 #get list of servers from file based on cycle count
 $subcontents = get-content -path "$path\group$GM.log"
 $subcontents

 write-host "==================Group $GM patch/boottime checking starts now==============="
  

  $subcontents | foreach-object {
                     $installedon = "" #last patch date
                     $lastbootuptime = "" #last boot time
                     $rpcOK = "" #rpc OK

                     #get last patch date
                     $lastpatch = Get-WmiObject -ComputerName "$_" Win32_Quickfixengineering | select @{Name="InstalledOn";Expression={$_.InstalledOn -as [datetime]}},InstalledBy | Sort-Object -Property Installedon | select-object -property installedon -last 1
                     $installedon = Get-Date $lastpatch.InstalledOn -format yyyy-MM-dd
                     #get last bootup time
                     $lastboot = Get-WmiObject -ComputerName "$_" win32_operatingsystem | select @{Name="LastBootUpTime";Expression={$_.ConverttoDateTime($_.lastbootuptime)}} | Select-Object -Property lastbootuptime
                     $lastbootuptime = Get-Date $lastboot.lastbootuptime -Format "yyyy-MM-dd hh:mm:ss tt"
                     #check RPC (shared drive test) for servers that haven't rebooted properly
                     $rpcOK = Test-Path "\\$_\c$"
                     
                     #list results in separate files
                     if (($installedon -eq $date0) -or ($installedon -eq $date1))
                     {
                        #add patched server to the successfully patched list
                        write-output "$_" | out-file -filepath "$path\patched.txt" -append 
                     }
                     else
                     {
                        #add none-patched server to the no yet patched list
                        write-output "$_" | out-file -filepath "$path\not-patched.txt" -append
                     }
                     
                     #append results to report file
                     write-output "$_,$installedon,$lastbootuptime,$rpcOK" | out-file -filepath "$path\results$GM.log" -append
}  
                     
                                