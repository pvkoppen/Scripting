' Name        : Kill-RemoteProcess.vbs
' Description : Script used to kill a running process on a computer. (Needs access to WMI!)
' Author      : Peter van Koppen,  Tui Ora Limited
' Version     : 1.1b
' -----------------------------------------------------------------------

' -----------------------------------------------------------------------
' Change Log.
' -----------------------------------------------------------------------
' 2009-01-04: Version 1.1
' -----------------------------------------------------------------------

' -- Default Settings and Variables
' -----------------------------------------------------------------------
Option Explicit
Dim boolDebug
boolDebug = True
boolDebug = False
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If

' Customize values here to fit your needs
' -----------------------------------------------------------------------
Dim intParameterCount, i, intCount
intParameterCount = WScript.Arguments.Count
If (intParameterCount < 2) Then
 WScript.Echo "Nothing to do: Script <Computername> <process> [<process>]."
 WScript.Quit(0)
Else
  WScript.Echo "Running Command: Kill-RemoteProcess.vbs <Computer="& WScript.Arguments(0) &"> <Proces(ses)="& WScript.Arguments(1) &" ...>"
End If

Dim objWMIService, colProcess, objProcess
Dim strComputer, strProcessKill 
strComputer = "."

'WScript.Argument runs from 0 to Count-1. The first argument should be the remote computer.
' -----------------------------------------------------------------------
strComputer = WScript.Arguments(0)

For i = 1 to intParameterCount-1
  intCount = 0
  Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
  Set colProcess = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '" & WScript.Arguments(i) & "'" )
  For Each objProcess in colProcess
    WScript.Echo "Kill Process: '"& objProcess.Name &"' on Computer: '"& strComputer &"'."
    objProcess.Terminate()
    intCount = intCount+1
  Next
  If (intCount = 0) Then
    WScript.Echo "Process: '" & WScript.Arguments(i) & "' was not running on computer: '" & strComputer & "'"
  Else
    WScript.Echo "Process: '" & WScript.Arguments(i) & "' was killed: " & intCount & " time(s) on computer: '" & strComputer & "'"
  End If
Next

' Clean up
' -----------------------------------------------------------------------
  Set objWMIService = Nothing
  Set colProcess = Nothing
  Set objProcess = Nothing

WScript.Quit

