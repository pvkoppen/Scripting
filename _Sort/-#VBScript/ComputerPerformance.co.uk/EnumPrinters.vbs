'
' EnumPrinters.vbs N.B. This script need printers
' VBScript to Enumerate Printers.
' Author Guy Thomas http://computerperformance.co.uk/
' Version 1.8 - April 24th 2005
' -----------------------------------------------------------'
Option Explicit
Dim objNetwork, objPrinter, intPrinter, intNetLetter

' This is the heart of the script
' Here is where objPrinter enumerates the mapped drives
Set objNetwork = CreateObject("WScript.Network")
Set objPrinter = objNetwork.EnumPrinterConnections

' Extra section to troubleshoot
If objPrinter.Count = 0 Then
WScript.Echo "Guy's warning: No Printers Mapped "
Wscript.Quit(0)
End If

' Here is the where the script reads the array
For intPrinter = 0 To objPrinter.Count -1 Step 2
intNetLetter = IntNetLetter +1
WScript.Echo "UNC Path: " & objPrinter.Item(intPrinter) & vbCrlf & "Printer name: " _
  & objPrinter.Item(intPrinter +1) & vbCrlf & "Printer no: " & intPrinter
Next

Wscript.Quit(1)

' End of Guy's Windows Logon Script