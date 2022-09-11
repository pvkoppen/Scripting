Const AUCKLAND		= "cn=Auckland"
Const CHRISTCHURCH	= "cn=Christchurch"
Const HAMILON		= "cn=Hamilton"
Const NPACCOUNTS	= "cn=New Plymouth Accounts"
Const NPDISPATCH	= "cn=New Plymouth Dispatch"
Const NPFRONT		= "cn=New Plymouth Front"
Const NPGENERAL		= "cn=New Plymouth General"
Const WELLINGTON	= "cn=Wellington"
Const PROPHET		= "cn=Prophet Users"
Const PROPHETHIST	= "cn=Historic Prophet Users"
Const BANKING		= "cn=PC Banking Users"

Set oWshnetwork=CreateObject("wscript.network")
Set oShell=CreateObject("wscript.shell")

Set wshNetwork = CreateObject("WScript.Network")
'wshNetwork.MapNetworkDrive "h:", "\\FileServer\Users\" & wshNetwork.UserName

Set ADSysInfo = CreateObject("ADSystemInfo")
Set CurrentUser = GetObject("LDAP://" & ADSysInfo.UserName)
strGroups = LCase(Join(CurrentUser.MemberOf))



'Set Global Drive Mappings
wshNetwork.MapNetworkDrive "G:", "\\SERVER\COMMON"
wshNetwork.MapNetworkDrive "H:", "\\SOPDC30\" & wshNetwork.Username & "$"



'Set Drive Mappings based on Group Membership
If InStr(strGroups, BANKING) Then
	wshNetwork.MapNetworkDrive "n:", "\\SERVER\BANKLINK$"
If InStr(strGroups, PROPHET) Then
	wshNetwork.MapNetworkDrive "p:", "\\SOPDC30\PROPHET"
If InStr(strGroups, PROPHETHIST) Then
	wshNetwork.MapNetworkDrive "q:", "\\SERVER\PRIOR$"
End If



'Set LPT1 Printer Mapping to Default Windows Printer
'Checks if LPT1: is already mapped, if so remove connection
Set oExistingPrinters=oWshNetwork.EnumPrinterConnections
For Each Printer In oExistingPrinters
	sDefaultWinPrinter=oShell.RegRead("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Device")
	If (Left(printer,4))="LPT1" Then
		oWshNetwork.RemovePrinterConnection "LPT1:"
	End If
Next


' If a printer is configured, checks which printer is the default and map to LPT1:
If sDefaultWinPrinter <> "" then
	sStringLength=Len(sDefaultWinPrinter)
	sDefaultWinPrinter=(Left(sDefaultWinPrinter,sStringLength-15))
	oWshNetwork.AddPrinterConnection "LPT1:",sDefaultWinPrinter
End If


'Set LPT Printer Mappings based on Group Membership
If InStr(strGroups, AUCKLAND) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\AKLMatrix01
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\AKLBar01
If InStr(strGroups, CHRISTCHURCH) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\CHCMatrix01
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\CHCBar01
If InStr(strGroups, HAMILTON) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\HAMMatrix01
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\HAMBar01
If InStr(strGroups, NPACCOUNTS) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\NPLMatrix03
If InStr(strGroups, NPDISPATCH) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\NPLMatrix02
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\NPLBar01
If InStr(strGroups, NPFRONT) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\NPLMatrix04
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\NPLBar01
	WshNetwork.AddPrinterConnection "LPT4", \\SOPDC30\NPLMatrix01
If InStr(strGroups, NPGENERAL) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\NPLMatrix01
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\NPLBar01
If InStr(strGroups, WELLINGTON) Then
	WshNetwork.AddPrinterConnection "LPT2", \\SOPDC30\WLGMatrix01
	WshNetwork.AddPrinterConnection "LPT3", \\SOPDC30\WLGBar01
End If


'If a printer is configured, check which printer is the default and map to LPT1:
If sDefaultWinPrinter <> "" then
	sStringLength=Len(sDefaultWinPrinter)
	sDefaultWinPrinter=(Left(sDefaultWinPrinter,sStringLength-15))
	oWshNetwork.AddPrinterConnection "LPT1:",sDefaultWinPrinter
End If

