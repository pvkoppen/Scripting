
'  GroupMap.vbs
' VBScript to map different groups to different shares.
' Author Guy Thomas http://computerperformance.co.uk/
' Version 2.5 - March 27th 2004
' -----------------------------------------------------------------'
Option Explicit
Dim objNetwork, objUser, CurrentUser
Dim strGroup

Const MEDtechUsers_Group = "cn=MEDtech32Users"
Const HLinkUsers_Group = "cn=HLinkUsers"
Const Users_Group = "cn=Users"
Const Administrators_Group = "cn=administrators"

Set objNetwork = CreateObject("WScript.Network")

Set objUser = CreateObject("AdSystemInfo")
Set CurrentUser = GetObject("LDAP://" & objUser.UserName)
strGroup = LCase(Join(CurrentUser.MemberOf))

If InStr(strGroup, MEDtechUsers_Group) Then
WScript.Echo "MEDtech32 User " & _
objNetwork.MapNetworkDrive "m:", "\\RHC-HPServer1\MT32\"


ElseIf InStr(strGroup, HLinkUsers_Group) Then
WScript.Echo " HealthLink User " & _
objNetwork.MapNetworkDrive "z:", "\\RHC-HPServer1\HLink\"


ElseIf InStr(strGroup, Users_Group) Then
WScript.Echo " Only a User... " & _
objNetwork.MapNetworkDrive "h:", "\\RHC-Rongo\Users\" & CurrentUser.UserName & _
objNetwork.UserName

ElseIf InStr(strGroup, Administrators_Group) Then
WScript.Echo "Administrator " & strGroup & _
objNetwork.MapNetworkDrive "h:", "\\Rhc-Rongo\Users\Administrator"


End If

Wscript.Echo "Finished Testing for Groups "

WScript.Quit
