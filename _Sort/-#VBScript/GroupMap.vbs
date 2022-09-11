'  GroupMap.vbs
' VBScript to map different groups to different shares.
' Author Guy Thomas http://computerperformance.co.uk/
' Version 2.5 - March 27th 2004
' -----------------------------------------------------------------'
Option Explicit
Dim objNetwork, objUser, CurrentUser
Dim strGroup

Const Dentists_Group = "cn=Dentists"
Const Managers_Group = "cn=Managers"
Const What_ever_you_Like = "cn=any_lower_case_group"
Const Users_Group = "cn=Users"
Const Administrators_Group = "cn=administrators"

Set objNetwork = CreateObject("WScript.Network")

Set objUser = CreateObject("AdSystemInfo")
Set CurrentUser = GetObject("LDAP://" & objUser.UserName)
strGroup = LCase(Join(CurrentUser.MemberOf))

If InStr(strGroup, Dentists_Group) Then
WScript.Echo "Dentists "
' objNetwork.MapNetworkDrive "h:", "\\Server\Users\" _
' & objNetwork.UserName

ElseIf InStr(strGroup, Managers_Group) Then
WScript.Echo " Manager "
' objNetwork.MapNetworkDrive "h:", "\\YourServer\Users\"_
' & objNetwork.UserName

ElseIf InStr(strGroup, Users_Group) Then
WScript.Echo " Only a User... "
' objNetwork.MapNetworkDrive "y:", "\\alan\home\" _
' & objNetwork.UserName

ElseIf InStr(strGroup, Administrators_Group) Then
WScript.Echo "Administrator " & strGroup
' objNetwork.MapNetworkDrive "h:", "\\AnotherServer\Users\" _
' & objNetwork.UserName

End If
WScript.Quit

Wscript.Echo "Finished Testing for Groups "