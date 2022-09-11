' PrintersLong.vbs - Windows Logon Script.
' VBScript - Connect a network printer with AddWindowsPrinterConnection
' Author Simon F. GILMOUR based on script by Guy Thomas http://computerperformance.co.uk/
' Version 2.2 - January 2006
' ------------------------------------------------------------------------------'
Option Explicit
Dim objNetwork, strUNCPrinter
strUNCPrinter = "\\zara\HP LaserJet."
Set objNetwork = CreateObject("WScript.Network")
objNetwork.AddWindowsPrinterConnection strUNCPrinter
WScript.Echo "Check the Printers folder for : " & strUNCPrinter

WScript.Quit