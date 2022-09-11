Option Explicit

Dim strComputer, strChassis
Dim objWMIService, objChassis, colChassis, objItem

strComputer = "."

Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _
& strComputer & "\root\cimv2")

Set colChassis = objWMIService.ExecQuery _
("Select * from Win32_SystemEnclosure")

For Each objItem In colChassis
  strChassis = Join(objItem.ChassisTypes, ",")
Next 

WScript.Echo "Computer chassis type: " & strChassis