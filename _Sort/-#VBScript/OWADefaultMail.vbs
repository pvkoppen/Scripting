-----------------------------------------------------------------------------------------------------
'THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT 
'WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
'INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
'OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR 
'PURPOSE
'
' You are free to use this code within your own applications,
' but you are expressly forbidden from selling or otherwise
' distributing this source code without prior written consent.
' This includes both posting free demo projects made from this
' code as well as reproducing the code in any other format.
'
'------------------------------------------------------------------------------
'
' NAME:         OWADefaultMail.vbs
' VERSION:      1.00 - 02/22/2004 Initial release
' Updated:       09/09/2004 by Sean Hook(athelu) and Brandon Stiff. Now supports OWA 2003 SP1.
' 
' DESCRIPTION:  This Windows Script file adds all necessary registry keys
'               to add OWA as choice of mail client in Internet Explorer
'
' Copyright (c) Siegfried Weber. All rights reserved.
'               http://playground.doesntexist.org/
'
'------------------------------------------------------------------------------

' Initialize error handling
Option Explicit
On Error Resume Next

' Declare variables
Dim objWSHShell                        ' As WScript.Shell
Dim strInput                        ' As String

' Ask for FQDN to Exchange Server
strInput = InputBox("Enter the Exchange Server full qualified domain name. Remember that if you are using SSL to use https: (like: <https://myserver.mydomain.com>) ")

' Check if server FQDN has been supplied
If Trim(strInput) <> "" Then

      ' Put registry settings to make OWA a mail client one can choose in IE
      Set objWSHShell = WScript.CreateObject("WScript.Shell")
      With objWSHShell
            'adds Microsoft Outlook Web access as a Mail Handler on the system.
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\", "Microsoft Outlook Web Access", "REG_SZ"
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\Protocols\mailto\", "URL:MailTo Protocol", "REG_SZ"
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\Protocols\mailto\URL Protocol", "", "REG_SZ"
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\Protocols\mailto\EditFlags", &H00000002, "REG_BINARY"
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\Protocols\mailto\DefaultIcon\", "%ProgramFiles%\Outlook Express\msimn.exe,-2", "REG_EXPAND_SZ"
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\shell\open\command\", """%ProgramFiles%\Internet Explorer\iexplore.exe"" ", "REG_EXPAND_SZ"
            'sets the path and Variables to open up and address a message inside of OWA - used by Send to Mail selection
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\Outlook Web Access\Protocols\mailto\shell\open\command\", """%ProgramFiles%\Internet Explorer\iexplore.exe"" " & strInput & "/exchange/?cmd=new&mailtoaddr=%1", "REG_EXPAND_SZ"
            'sets the path and Variables to open up and address a message inside of OWA - used by mailto: links
            .RegWrite "HKLM\SOFTWARE\Classes\mailto\shell\open\command\", """%ProgramFiles%\Internet Explorer\iexplore.exe"" " & strInput & "/exchange/?cmd=new&mailtoaddr=%1", "REG_EXPAND_SZ"            
            'changes the internet program setting for mail to defautl to OWA
            .RegWrite "HKLM\SOFTWARE\Clients\Mail\","Outlook Web Access", "REG_SZ"            
            End With

      ' Tidy up
      Set objWSHShell = Nothing
Else
      WScript.Echo "Please enter a valid Exchange Server full qualified domain name"
End If

' Tidy up
Set objWSHShell = Nothing

' Say good bye
WScript.Echo "Thank you for using this script."