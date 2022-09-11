' GroupEnum.vbs
' VBScript to discover who is a member of the Administrators Group
' Author Guy Thomas http://computerperformance.co.uk/
' Version 1.3 August 2005
' ----------------------------------------------------------'
Option Explicit
Dim strMember, strDNSDomain, strContainer
Dim objGroup, objRootDSE
Dim arrMemberOf

'  Bind to Active Directory'
strContainer = "cn=Administrators,cn=Builtin, "
Set objRootDSE = GetObject("LDAP://RootDSE")
strDNSDomain = objRootDSE.Get("DefaultNamingContext")

'  Get the Builtin Administrators group
Set objGroup = GetObject ("LDAP://"& strContainer & strDNSDomain)
objGroup.getInfo

arrMemberOf = objGroup.GetEx("member")

' Loop = For Each .... Next
' WScript.Echo "Members of Group " & strContainer
For Each strMember in arrMemberOf
   WScript.echo strMember
Next

Wscript.Quit

' End of Sample Group Enum Member Script
