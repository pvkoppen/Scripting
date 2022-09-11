Option Explicit

Dim strDn, strDnsDomain, strPassword, strName, objComputer,strContainer,objRootDSE 

If WScript.arguments.count = 0	 Then
	WScript.Echo "Usage: SetComputerPass.vbs <ComputerName> /p <password> /d <domain name>"
	WScript.Quit
Else
Dim i

i = 0
	Do
		If WScript.Arguments(i) = "/p" Then
			i = i + 1
			strPassword = WScript.Arguments(i)
		ElseIf WScript.Arguments(i) = "/d" Then
			i = i + 1
			strDnsDomain = WScript.Arguments(i)
		Else
			strName = WScript.Arguments(i)
		End If
		i = i + 1
	Loop While i < WScript.Arguments.Count
End If

If strDnsDomain <> "" Then
	Set objRootDSE = GetObject("LDAP://" & strDnsDomain & "/RootDSE")
	strContainer = "CN=Computers," & objRootDSE.Get("DefaultNamingContext")
End If
Set objComputer = GetObject("LDAP://CN=" & strName &  "," & strContainer)
objComputer.SetPassword strPassword

If Err.Number = 0 Then
	WScript.Echo "SUCCESS#" & "Password Changed to..." & strPassword  
Else
	WScript.Echo "Error " & Hex(Err.Number) & "|" & Err.Description & "||"

End If

WScript.Quit
