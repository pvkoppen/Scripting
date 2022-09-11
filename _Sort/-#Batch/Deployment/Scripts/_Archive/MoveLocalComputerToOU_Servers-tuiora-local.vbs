' Activity      : Windows: Move Computer to Server OU
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-08-08
' Must be run as: A Domain Administrator
' -----------------------------------------------------------------

'--------------------------------------------------------------
' FILE: movecomputer.vbs
' Created:  12/05/2002
' Revision: 1.1
' Author:   Altiris
'
' Description: 	This script will find the specified computer
'		in the specified domain and move it to the new
'		location.
'		The computer must exist in the domain for this
'		sctript ot work.
'--------------------------------------------------------------
Option Explicit
Dim WshShell, WshSysEnv
Dim bFound
Dim strComputer, strDomainName, strNewLDAPPath, strADsPath, strLDAPPath
Dim objConnection, objCommand, objRecordSet, objComputer, objOU

'strComputer = "%COMPNAME%" 'The computer to look for
Set WshShell = WScript.CreateObject("WScript.Shell")
Set WshSysEnv = WshShell.Environment("PROCESS")
strComputer = WshSysEnv("COMPUTERNAME") 'Use local Computer
strDomainName = "TUIORA" 'Domain that the computer is in
'This is where you want the computer to go in LDAP format
strNewLDAPPath = "LDAP://OU=Servers,DC=Tuiora,DC=Local"

'----------- DEBUG -----------------------------
'WScript.Echo "Local Machine name= "&strComputer

bFound = False

'Find the Computer
' -----------------------------------------------------------------
Set objConnection = CreateObject("ADODB.Connection")
objConnection.Open "Provider=ADsDSOObject;"
Set objCommand = CreateObject("ADODB.Command")
objCommand.ActiveConnection = objConnection
objCommand.CommandText = _
   "<LDAP://" & strDomainName & ">;" & _
   "(&(objectCategory=Computer)(cn=" & strComputer & "));" & _
   "ADsPath;subtree"
Set objRecordSet = objCommand.Execute

While Not objRecordset.EOF
    strADsPath = objRecordset.Fields("ADsPath")
    Set objComputer = GetObject(strADsPath)
    strLDAPPath = strADsPath
    bFound = True
    objRecordSet.MoveNext
Wend

' if we find it move it
' -----------------------------------------------------------------
If bFound Then
	' lets move to the new OU
	Set objOU = GetObject(strNewLDAPPath)
	objOU.MoveHere strLDAPPath, "CN=" & strComputer
	Set objOU = Nothing
End If

objConnection.Close

WScript.Quit

