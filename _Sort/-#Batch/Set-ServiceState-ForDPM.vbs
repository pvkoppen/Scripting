option explicit

Dim boolDebug
boolDebug = True

' Procedure: SetReg
' Does: Writes the registry information.
' ----------------------------------------------------------
Public Sub SetReg(strRegPath, strRegValue, strRegType)
  If (strRegPath <> "") And (strRegValue <> "") And (strRegType <> "") Then
    ' Declare variables and set initial value.
    Dim WsShell
    Set WsShell = WScript.CreateObject("WScript.Shell")
    WScript.Echo "RegValue Before Write: " & WsShell.RegRead(strRegPath)
    ' Write the Registry information.
    WsShell.RegWrite strRegPath, strRegValue, strRegType
    WScript.Echo "RegValue After Write: " & WsShell.RegRead(strRegPath)
    If (boolDebug) Then WScript.Echo "SetReg: Succes (Write Registry Key)" &vbCrlf& "Registry Key: " & strRegPath &vbCrlf& "Registry Value: [" & strRegType & "] " & strRegValue &vbCrlf  End If
  Elseif (boolDebug) then
    WScript.Echo "SetReg= Failed (One of the Parameter(s) is Empty)" &vbCRLF& "RegPath: " &strRegPath&vbCRLF& "RegValue: " &strRegValue&vbCRLF& "RegType: " &strRegType
  End If ' Check on parameters empty
End Sub 

' Auto=2, Manual=3, Disabled=4.
SetReg "HKLM\System\CurrentControlSet\Services\NtmsSvc\Start", 4, "REG_DWORD"
SetReg "HKLM\System\CurrentControlSet\Services\Server Administrator\Start", 4, "REG_DWORD"

