' Script name: AddPrinter-TRP.vbs - Windows Logon Script.
' Description: VBScript - Connect a network printer with AddWindowsPrinterConnection
' Copied of  : Guy Thomas http://computerperformance.co.uk/
' Build by   : Peter van Koppen
' ------------------------------------------------------------------------------'

' This has to be the first Code Option
' ------------------------------------------------------------------------------'
Option Explicit
On Error Resume Next
Dim boolDebug
boolDebug = False
boolDebug = True


' Declare Variables.
' ------------------------------------------------------------------------------'
Dim objNetwork, strUNCPrinter
Dim objPrinters, intPrinter, boolAddPrinter


' Set the default values for the variables.
' ------------------------------------------------------------------------------'
' The unc printer has to be the long name as listed in the 'printers and faxes' folder on the server!
strUNCPrinter   = "\\DC14\YTS Konica B&W"
'strUNCPrinter2   = "\\DC14\YTS Colour"
strUNCPrinter   = "\\DC14\TRP BW KONICA MINOLTA 350/250/200 PCL"
'strUNCPrinter2   = "\\DC14\TRP COLOR KONICA MINOLTA C250 PCL"
strUNCPrinter   = "\\DC14\TOL Canon iR C2100S-2100"
'strUNCPrinter2   = "\\DC14\TOL Konica 7255"
'strUNCPrinter3   = "\\DC14\TOL HP LaserJet 4000"
strUNCPrinter   = "\\DC14\THPH Minolta Di351/251/200"
'strUNCPrinter2  = "\\DC14\THPH HP LaserJet 6L"
strUNCPrinter   = "\\DC14\RHT Xerox 235 PCL 6"
strUNCPrinter   = "\\DC14\PTO hp LaserJet 1320 PCL 5e"
strUNCPrinter   = "\\DC14\MOR LaserJet 4000"
strUNCPrinter   = "\\DC14\HTPHO B/W Laserjet 2300"
boolAddPrinter  = True
Set objNetwork  = CreateObject("WScript.Network")
Set objPrinters = objNetwork.EnumPrinterConnections


' Here we check if the printer already exists.
' ------------------------------------------------------------------------------'
If objPrinters.Count <> 0 Then
  ' Here is the where the script reads the array.
  For intPrinter = 0 To objPrinters.Count -1 Step 2
    'If boolDebug Then WScript.Echo "Local Printer No: " &(intPrinter/2)+1 &vbCrlf& "(Port: " & objPrinters.Item(intPrinter) & ")" &vbCrlf& "(Network Path: " & objPrinters.Item(intPrinter +1) & ")" &vbCrlf& "(New Printer: " & strUNCPrinter & ")." End If
    If UCase(objPrinters.Item(intPrinter+1)) = UCase(strUNCPrinter) Then
      boolAddPrinter = False
      If boolDebug Then WScript.Echo "Printer Already Exists." &vbCrlf& _
        "(Port: " & objPrinters.Item(intPrinter) & ", Network Path: " & objPrinters.Item(intPrinter +1) & ")" 
    End If
  Next
End If


'If the Printer doens't exist yet add it.
' ------------------------------------------------------------------------------'
If boolAddPrinter Then 
  objNetwork.AddWindowsPrinterConnection strUNCPrinter
  If boolDebug Then WScript.Echo "Printer added: " & strUNCPrinter End If
End If


' End of the Script
' ------------------------------------------------------------------------------'
If boolDebug Then WScript.Echo "The End." End If
WScript.Quit
