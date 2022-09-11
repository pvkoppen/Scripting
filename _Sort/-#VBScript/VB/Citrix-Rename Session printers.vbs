-----------------------------------------------
-- VBScript: Rename Citrix Session Printers
-----------------------------------------------
Function RenameSessionPrintersFunc
    On Error Resume Next 
    strPrinter = Split(WSHShell.RegRead("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Device"), ",")(0)
    IF InStr(strPrinter,"JJLAPTOP") > 0 or InStr(strPrinter,"HN-") > 0 or InStr(strPrinter,"RK-") > 0 or InStr(strPrinter,"RCTHAM") > 0 or InStr(strPrinter,"HNMED") > 0 or InStr(strPrinter,"RKMED") > 0 or InStr(strPrinter,"HC-0") > 0 or InStr(strPrinter,"SCLINIC") > 0 or InStr(strPrinter,"SCHOOLCLINIC") > 0 or InStr(strPrinter,"CFHCAM") > 0 then
        IF InStr(strPrinter,"in session") > 0 then
            strNewPtrName = Replace(Left(strPrinter,InStr(strPrinter,"in session")-2),"from ","")
            strPrintLog = strPrintLog & time & " Renaming Session Printers for School Clinics " & vbCrLf
            strPrintLog = strPrintLog & time & " Printer was:" & strPrinter & " is now: " & strNewPtrName & vbCrLf
            'Need to get a var in the reg path SessionDefaultDevices\SID\Device
            Const HKEY_CURRENT_USER = &H80000001
            strComputer = "."
            Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _
            strComputer & "\root\default:StdRegProv")
            strKeyPath = "Software\Microsoft\Windows NT\CurrentVersion\Windows\SessionDefaultDevices"
            objReg.EnumKey HKEY_CURRENT_USER, strKeyPath, arrSubKeys
            For Each Subkey in arrSubKeys
                strVar2 = Subkey 'SID
            Next
            strVar = strNewPtrName & ",winspool,Ne00:" 'NewPrinterName and Port
            strVar3 = "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Device" ' Registry Path
            WSHShell.RegWrite strVar3, strVar, "REG_SZ"
            strVar3 = "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\SessionDefaultDevices\" & strVar2 & "\Device" ' Registry Path
            WSHShell.RegWrite strVar3, strVar, "REG_SZ"
            strVar3 = "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Devices\" & strNewPtrName
            WSHShell.RegWrite strVar3, "winspool,Ne00:", "REG_SZ" 'This allows the user to set default without failure and getting error 709
            Err.Clear
            strCommand = "cmd /c rundll32 printui.dll,PrintUIEntry /Xs /n " & Chr(34) & strPrinter & Chr(34) & " printername " & Chr(34) & strNewPtrName & Chr(34)
            WSHShell.Run strCommand, 0, False
            'WScript.Echo Err.Number & Err.Description & vbCrLf & "Old Name:" & strPrinter & vbCrLf & "New Name:" & strNewPtrName & vbCrLf & strCommand
        end if   
    end if       
End Function
