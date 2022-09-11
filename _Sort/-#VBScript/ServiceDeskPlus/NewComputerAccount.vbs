'CreateComputerAccount.vbs
'Create a Computer account in Active Directory, set it's password and
'echo the principal name, DNS domain name and password in a | separated
'list. If no password is supplied, a random password will be set. If no
'container DN is supplied, the account will be created in the default
'Computers container (such as CN=Computers,DC=example,DC=com). If an
'error occurs, the error code and possibly error text will be returned
'in the first two fields of the output string. If the operation is
'successful, the error code is always "0".

Option Explicit
On Error Resume Next

Dim strContainer, strName, strPassword, strDnsDomain
Dim objContainer, objComputer, objRootDSE, objSystemInfo

strContainer = ""
strName = ""
strPassword = ""
strDnsDomain = ""

If WScript.Arguments.Count = 0 Then
	WScript.Echo "Usage: CreateComputerAccount.vbs <Name>"
	WScript.Echo "  [/p <Password>]"
	WScript.Echo "  [/c <ContainerDN> | /d <DnsDomain>]"
	WScript.Echo "Output: <ErrorCode>|<ErrorText>|<PrincipalName>|<DnsDomain>|<Password>"
	WScript.Quit
Else
	Dim i

	i = 0
	Do
		If WScript.Arguments(i) = "/p" Then
			i = i + 1
			strPassword = WScript.Arguments(i)
		ElseIf WScript.Arguments(i) = "/c" Then
			i = i + 1
			strContainer = WScript.Arguments(i)
			strDnsDomain = ""
		ElseIf WScript.Arguments(i) = "/d" Then
			i = i + 1
			strDnsDomain = WScript.Arguments(i)
			strContainer = ""
		Else
			strName = WScript.Arguments(i)
		End If
		i = i + 1
	Loop While i < WScript.Arguments.Count
End If

If strName = "" Then
	WScript.Echo "Usage: CreateComputerAccount.vbs <Name> [/p <Password>] [/c <ContainerDN>]"
	WScript.Quit
End If

Function TranslateDnToDnsDomain(dn)
	Dim objTrans, strCanon

	'ADS_NAME_INITTYPE_GC 3
	'ADS_NAME_TYPE_1779 1
	'ADS_NAME_TYPE_CANONICAL 2

	Set objTrans = CreateObject("NameTranslate")
	objTrans.Init 3, ""
	objTrans.Set 1, dn
	strCanon = objTrans.Get(2)
	strCanon = Mid(strCanon, 1, InStr(strCanon, "/") - 1)

	TranslateDnToDnsDomain = strCanon
End Function

If strContainer <> "" Then
	strDnsDomain = TranslateDnToDnsDomain(strContainer)
ElseIf strDnsDomain <> "" Then
	Set objRootDSE = GetObject("LDAP://" & strDnsDomain & "/RootDSE")
	strContainer = "CN=Computers," & objRootDSE.Get("DefaultNamingContext")
Else
	Set objRootDSE = GetObject("LDAP://RootDSE")
	strContainer = "CN=Computers," & objRootDSE.Get("DefaultNamingContext")
	strDnsDomain = TranslateDnToDnsDomain(strContainer)
End If


Function RandPass(pn)
	Dim c, n, m, s, ret, i, r

	c = "abcdefghjkmnpqrstuvwxyz"
	n = "23456789"
	m = "~$^-+."
	ret = ""

	Randomize

	pn = pn - 1

	For i = 0 to pn
		If i Mod 8 = 4 Then
			s = m
		ElseIf i Mod 8 > 4 Then
			s = n
		Else
			s = c
		End If
		r = Int(Rnd() * Len(s))
		ret = ret & Mid(s, r + 1, 1)
	Next

	RandPass = ret
End Function

If strPassword = "" Then
	strPassword = RandPass(8)
End If

If Err.Number = 0 Then
	Set objContainer = GetObject("LDAP://" & strContainer)
	If Err.Number = 0 Then

		Set objComputer = objContainer.Create("Computer", "CN=" & strName)
		If Err.Number = 0 Then
			objComputer.sAMAccountName = strName & "$"
			objComputer.userAccountControl = 4128
			objComputer.SetInfo
			If Err.Number = 0 Then
				objComputer.SetPassword strPassword
				If Err.Number = 0 Then

					WScript.Echo "0||" & objComputer.sAMAccountName & "@" & strDnsDomain & "|" & strDnsDomain & "|" & strPassword

					WScript.Quit
				End If
			End If
		End If
	End If
End If

If Err.Number = &H80071392 Then
	Err.Description = "The object already exists"
ElseIf Err.Number = &H80072035 Then
	Err.Description = "The server is unwilling to process the request"
End If

WScript.Echo Hex(Err.Number) & "|" & Err.Description & "||"

WScript.Quit