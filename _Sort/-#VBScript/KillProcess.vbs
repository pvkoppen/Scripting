Option Explicit
Dim boolDebug
boolDebug = True
boolDebug = False
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If

Dim intParameterCount, i, intCount
intParameterCount = WScript.Arguments.Count
If intParameterCount = 0 Then
 WScript.Echo "Nothing to do."
 WScript.Quit(0)
End If

Dim objWMIService, colProcess, objProcess
Dim strComputer, strProcessKill 
strComputer = "."
'strProcessKill = "" 
  'Set colProcess = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = " & strProcessKill )
  'WScript.Echo "Just killed process " & strProcessKill & " on " & strComputer

For i = 0 to intParameterCount
  intCount = 0
  Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\"  & strComputer & "\root\cimv2") 
  Set colProcess = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '" & WScript.Arguments(i) & "'" )
  For Each objProcess in colProcess
    objProcess.Terminate()
    intCount = intCount+1
  Next
  If (intCount = 0) Then
    WScript.Echo "Process: '" & WScript.Arguments(i) & "' was not running on computer: '" & strComputer & "'"
  Else
    WScript.Echo "Process: '" & WScript.Arguments(i) & "' was killed: " & intCount & " time(s) on computer: '" & strComputer & "'"
  End If
Next

WScript.Quit
