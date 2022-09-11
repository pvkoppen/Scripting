'  GroupDriveMappings.vbs
' VBScript to map different groups to different shares.
' Author Simon F. GILMOUR based on script by Guy Thomas http://computerperformance.co.uk/
' Version 2.5 - January 2006
' -----------------------------------------------------------------'
Option Explicit
Dim objNetwork, objUser, CurrentUser
Dim strGroup

Const MEDtech32_Group = "cn=MEDtech32Users"
Const HealthLink_Group = "cn=HLinkUsers"
Const Administrators_Group = "cn=administrators"

Set objNetwork = CreateObject("WScript.Network")

Set objUser = CreateObject("AdSystemInfo")
Set CurrentUser = GetObject("LDAP://" & objUser.UserName)
strGroup = LCase(Join(CurrentUser.MemberOf))

If InStr(strGroup, MEDtech32_Group) Then
WScript.Echo "MEDtech32 "
' objNetwork.MapNetworkDrive "M:", "\\RHC-HPServer1\MT32\" _
' & objNetwork.UserName

ElseIf InStr(strGroup, HealthLink_Group) Then
WScript.Echo " HealthLink "
' objNetwork.MapNetworkDrive "Z:", "\\RHC-HPServer1\HLink\"_
' & objNetwork.UserName


End If
WScript.Quit

Wscript.Echo "Finished Testing for Groups "