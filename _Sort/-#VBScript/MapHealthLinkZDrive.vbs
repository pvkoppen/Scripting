' MapNetworkDrive.vbs
' VBScript to map a network drive to a UNC Path.
' Author Simon F. GILMOUR based on script by Guy Thomas http://computerperformance.co.uk/
' Version 2.3 - January 2006
' -----------------------------------------------------------------'
Option Explicit
Dim objNetwork
Dim strDriveLetter, strRemotePath
strDriveLetter = "Z:"
strRemotePath = "\\rhc-hpserver1\HLink"

' Purpose of script to create a network object. (objNetwork)
' Then to apply the MapNetworkDrive method.  Result M: drive
Set objNetwork = CreateObject("WScript.Network")

objNetwork.MapNetworkDrive strDriveLetter, strRemotePath
WScript.Quit
