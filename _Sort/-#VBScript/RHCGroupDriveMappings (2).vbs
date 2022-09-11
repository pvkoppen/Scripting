'  RHCGroupDriveMappings.vbs
' VBScript to map different groups to different shares.
' Author Simon F. GILMOUR from script by Guy Thomas http://computerperformance.co.uk/
' Version 2.9 - February 11th 2006
' -----------------------------------------------------------------'
'
Option Explicit
Dim objNetwork, objUser, oPrinters, CurrentUser
Dim colstrGroup, colstrPrinters
Dim strGroup, strComputerName, strUNCPrinter
Dim i

Const MEDtechUsers_Group = "cn=medtechusers"
Const HLinkUsers_Group = "cn=hlinkusers"
Const SCPUsers_Group = "cn=scpusers"
Const Users_Group = "cn=users"
Const Administrators_Group = "cn=administrators"

Set objNetwork = CreateObject("WScript.Network")

Set objUser = CreateObject("AdSystemInfo")
Set CurrentUser = GetObject("LDAP://" & objUser.UserName)

colstrGroup = CurrentUser.MemberOf

If IsEmpty(colstrGroup) Then
  strGroup = ""
ElseIf TypeName(colstrGroup) = "String" Then
  strGroup = LCase(colstrGroup)
Else
  strGroup = LCase(Join(colstrGroup))
End If

' Don't create mappings for local logon to server
strComputerName = LCase(objUser.ComputerName)

If Not (Instr("rhc-rongo", strComputerName) Or Instr("rhc-hpserver1", strComputerName))  Then

  If InStr(strGroup, MEDtechUsers_Group) Then
    WScript.Echo "MEDtech32 User "
    objNetwork.MapNetworkDrive "M:", "\\Rhc-HPServer1\MT32"
  End If

  If InStr(strGroup, HLinkUsers_Group) Then
    WScript.Echo " HealthLink User "
    objNetwork.MapNetworkDrive "Z:", "\\Rhc-HPServer1\HLink"
  End If

  If InStr(strGroup, SCPUsers_Group) Then
	WScript.Echo " Smoking Cessation User "
	objNetwork.MapNetworkDrive "S:", "\\RHC-Rongo\CGC"
  End If

End If


' Map MEDtech Printers

Set oPrinters = objNetwork.EnumPrinterConnections

For i = 0 to oPrinters.Count - 1 Step 2
  colstrPrinters = colstrPrinters & oPrinters.Item(i+1)
  If i < (oPrinters.Count - 1) Then
    colstrPrinters = colstrPrinters & + ","
  End If
Next

'If InStr(strGroup, MEDtechUsers_Group) Then

  ' Map MEDtech32 A4 & A5 printers
'  strUNCPrinter = "\\RHC-HPServer1\Konica_A4"

'  If   Instr(1, colstrPrinters, strUNCPrinter, vbTextCompare) = 0 Then
'    WScript.Echo "Installing MEDtech32 printer - " & strUNCPrinter
'    objNetwork.AddWindowsPrinterConnection strUNCPrinter
'  End If

'  strUNCPrinter = "\\RHC-HPServer1\Konica_A5"

'  If   Instr(1, colstrPrinters, strUNCPrinter, vbTextCompare) = 0 Then
'    WScript.Echo "Installing MEDtech32 printer - " & strUNCPrinter
'    objNetwork.AddWindowsPrinterConnection strUNCPrinter
'  End If

'Else

  ' Map Konica 7222 printer
  
'  strUNCPrinter = "\\RHC-HPServer1\KONICA MINOLTA 7222-7235/IP-424"
'
'  If   Instr(1, colstrPrinters, strUNCPrinter, vbTextCompare) = 0 Then
'    WScript.Echo "Installing Konica printer - " & strUNCPrinter
'    objNetwork.AddWindowsPrinterConnection strUNCPrinter
'  End If

'End If

' Wscript.Echo "Finished Drive/Printer mapping for User: " & objNetwork.UserName

WScript.Quit
