 
' Set Option Explicit and Global Variables 
' ---------------------------------------------------------- 
Option Explicit 
Dim boolDebug 
boolDebug = False 
'boolDebug = True 
If (boolDebug) Then On Error Goto 0 Else On Error Resume Next End If 
 
' Procedure: MapPrinter 
' Does: Checks if the current user has the give printer installed. 
'     : If the printer is not installed an attempt will be made to install it. 
'     : The UNC printer name has to be the long name as listed in the  
'       'printers and faxes' folder on the server! 
' ---------------------------------------------------------- 
Public Sub MapPrinter(strUNCPrinter) 
  ' Declare Variables. 
  Dim objNetwork, objPrinters, intPrinter, boolAddPrinter 
  Dim strResult 
  ' Bind to Active Directory. 
  Set objNetwork  = CreateObject("WScript.Network") 
  Set objPrinters = objNetwork.EnumPrinterConnections 
  ' Here we check if the printer already exists. 
  objNetwork.AddWindowsPrinterConnection strUNCPrinter 
 WScript.Echo "Adding Printer:"& strUNCPrinter &" ("&strResult&")." 
  ' Cleanup. 
  Set objPrinters = Nothing 
  Set objNetwork  = Nothing 
end Sub 
 
' Add configured printers from the login script to this generated VBS script. 
' ---------------------------------------------------------- 
 
' Add printer comments from the login script to this generated VBS script. 
' ---------------------------------------------------------- 
 
' Final. 
' ---------------------------------------------------------- 
Wscript.Quit 
 
