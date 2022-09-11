' Name        : PrinterManagement.vbs
' Description : .
' Author      : Peter van Koppen,  Tui Ora Ltd
' ----------------------------------------------------------

' ----------------------------------------------------------
' Change Log.
' ----------------------------------------------------------
' 2013-03-15: 1.0: Initial Version
' ----------------------------------------------------------

' ----------------------------------------------------------
' Here start the beginning of the VBScript. Here we set some standard global setting.
' ----------------------------------------------------------
' Option Explicit: All variabled need to be declared before they are used.
' boolDebug: If True the script will show additional information.
' On Error: Resume Next= Ingore all errors. Goto 0= Show ErrorMessage and stop.
' ----------------------------------------------------------

' Set Option Explicit and Global Variables
' ----------------------------------------------------------
Option Explicit
Dim boolDebug
boolDebug = False
boolDebug = True
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If


' ----------------------------------------------------------
' Library Procedures: (Library is located at the end of this script)
' ----------------------------------------------------------
' RemovePrinter
' MapPrinter
' SetDefaultPrinter

Dim strPrinter

If Wscript.Arguments.Count = 0 Then
  WScript.Echo "Arguments: AddPrinter ""\\Server\Printer""; RemovePrinter ""\\Server\Printer"""
Else
  If Wscript.Arguments(0) = "AddPrinter" Then
    MapPrinter(WScript.Arguments(1))
  End If
  If Wscript.Arguments(0) = "RemovePrinter" Then
    RemovePrinter(WScript.Arguments(1))
  End If
End If


' Final.
' ----------------------------------------------------------
'boolDebug = True
If (boolDebug) Then WScript.Echo "Done." &vbCrLf
WScript.Quit


' Procedure: RemovePrinter
' Does: Checks if the current user has the give printer installed.
'     : If the printer is installed an attempt will be made to remove it.
'     : The UNC printer name has to be the long name as listed in the 
'       'printers and faxes' folder on the server!
' ----------------------------------------------------------
Public Sub RemovePrinter(strUNCPrinter)
  If (strUNCPrinter <> "") Then 
    ' Declare Variables.
    Dim objNetwork, objPrinters, intPrinter, boolRemovePrinter
    ' Set the default values for the variables. 
    boolRemovePrinter  = False
    ' Bind to Active Directory.
    Set objNetwork  = CreateObject("WScript.Network")
    Set objPrinters = objNetwork.EnumPrinterConnections
    ' Here we check if the printer exists.
    If objPrinters.Count <> 0 Then
      ' Here is the where the script reads the array.
      For intPrinter = 0 To objPrinters.Count -1 Step 2
        'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If &vbCrLf
        If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
          boolRemovePrinter = True
          If (boolDebug) Then WScript.Echo "Printer Exists." &vbCrLf& _
            "(Port: " & objPrinters.Item(intPrinter) & ", Network Path: " & objPrinters.Item(intPrinter +1) & ")"  &vbCrLf
        End If
      Next
    End If
    ' If the printer exists try to remove it.
    If True = boolRemovePrinter Then
      objNetwork.RemovePrinterConnection  strUNCPrinter, True, True
      If (boolDebug) Then WScript.Echo "Printer Removed: " & strUNCPrinter &vbCrLf End If
    End If
    ' Cleanup.
    Set objPrinters = Nothing
    Set objNetwork  = Nothing
  ElseIf (boolDebug) Then
    WScript.Echo "RemovePrinter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: MapPrinter
' Does: Checks if the current user has the give printer installed.
'     : If the printer is not installed an attempt will be made to install it.
'     : The UNC printer name has to be the long name as listed in the 
'       'printers and faxes' folder on the server!
' ----------------------------------------------------------
Public Sub MapPrinter(strUNCPrinter)
  If (strUNCPrinter <> "") Then 
    ' Declare Variables.
    Dim objNetwork, objPrinters, intPrinter, boolAddPrinter
    ' Set the default values for the variables.
    boolAddPrinter  = True
    ' Bind to Active Directory.
    Set objNetwork  = CreateObject("WScript.Network")
    Set objPrinters = objNetwork.EnumPrinterConnections
    ' Here we check if the printer already exists.
    If objPrinters.Count <> 0 Then
      ' Here is the where the script reads the array of installed printers.
      For intPrinter = 0 To objPrinters.Count -1 Step 2
        'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If &vbCrLf
        If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
          boolAddPrinter = False
          If (boolDebug) Then WScript.Echo "MapPrinter: Prevented (Printer Already Exists)" &vbCrLf& _
            "LocalPort: " & objPrinters.Item(intPrinter)&vbCrLf& "Printer: " & objPrinters.Item(intPrinter +1)  &vbCrLf
        End If
      Next
    End If
    ' If the Printer doens't exist yet add it.
    If boolAddPrinter Then 
      objNetwork.AddWindowsPrinterConnection strUNCPrinter
      If (boolDebug) Then WScript.Echo "MapPrinter: Succes (Printer added)" &vbCrLf& "Printer: " & strUNCPrinter &vbCrLf End If
    End If
    ' Cleanup.
    Set objPrinters = Nothing
    Set objNetwork  = Nothing
  ElseIf (boolDebug) Then
    WScript.Echo "MapPrinter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
  End If ' Check on parameters empty
End Sub

' Procedure: SetDefaultPrinter
' Does: Checks if the current user has the give printer installed.
'     : If the printer is not installed nothing else is done.
'     : If the Printer exists is will be set to the default.
'     : The UNC printer name has to be the long name as listed in the 
'       'printers and faxes' folder on the server!
' ----------------------------------------------------------
Public Sub SetDefaultPrinter(strUNCPrinter)
  If (strUNCPrinter <> "") Then 
    If Not (InStr(UCase(GetComputerDNName), UCase("CN="&GetComputerName&",OU=Domain Controllers,DC="))) And _
      Not (InStr(UCase(GetComputerDNName), UCase("CN="&GetComputerName&",OU=Servers,DC="))) Then 
      ' Declare Variables.
      Dim objNetwork, objPrinters, intPrinter, boolPrinterExists
      ' Set the default values for the variables.
      boolPrinterExists  = False
      ' Bind to Active Directory.
      Set objNetwork  = CreateObject("WScript.Network")
      Set objPrinters = objNetwork.EnumPrinterConnections
      ' Here we check if the printer already exists.
      If objPrinters.Count <> 0 Then
        ' Here is the where the script reads the array of installed printers.
        For intPrinter = 0 To objPrinters.Count -1 Step 2
          'If (boolDebug) Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If &vbCrLf
          If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
            boolPrinterExists = True
            objNetwork.SetDefaultPrinter strUNCPrinter
            If (boolDebug) Then WScript.Echo "SetDefaultPrinter: Success (Printer Set As Active)" &vbCrLf& "Printer: " & objPrinters.Item(intPrinter +1) &vbCrLf
          End If
        Next
      End If
      ' If the Printer does not exist, do nothing.
      If Not boolPrinterExists Then 
        If (boolDebug) Then WScript.Echo "SetDefaultPrinter: Failed (Printer does not exist yet)" &vbCrLf& "Printer: " & strUNCPrinter &vbCrLf End If
      End If
      ' Cleanup.
      Set objPrinters = Nothing
      Set objNetwork  = Nothing
    ElseIf (boolDebug) Then 
      WScript.Echo "SetDefaultPrinter= Failed (Don't set printers active on a Domain Controller or a Server)"& vbCrLf& "ComputerName: " &GetComputerDNName&vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
    End If ' LocalMachine = Server.
  ElseIf (boolDebug) Then
    WScript.Echo "SetDefaultPrinter= Failed (One of the Parameter(s) is Empty)" &vbCrLf& "Printer: " &strUNCPrinter &vbCrLf
  End If ' Check on parameters empty
End Sub
