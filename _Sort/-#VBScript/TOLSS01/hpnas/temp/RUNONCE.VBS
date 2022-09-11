'*******************************************************************************
'*	RunOnce Script for R2 Installations
'*
'*	Requires Files in Image
'*	C:\hpnas\temp\products.xml
'*	C:\hpnas\temp\product.exe
'*	All other files are created on the fly
'*******************************************************************************
On Error Resume Next

Const RunOnceVer = "0.10.4"
Const ReadOnly = 1
Const Hidden = 2
Const System = 4
Const AttribON = True
Const AttribOFF = False

RunOnceScript = "C:\HPNAS\temp\RunOnce.vbs"

Argument0 = ""
' Need to Set this up to to get all arguments
If WScript.Arguments.Length > 0 Then 
  Argument0 = Wscript.Arguments.Item(0)
End IF

Set WshShell=CreateObject("Wscript.Shell")

If Argument0 = "" Then
	'*******************************************************************************
	' Create WinBOM.INI

Else
	' Call the Phase(Software) or Step(Hardware)
	Select Case Argument0   
		Case "Phase0" Call Phase0
		Case "Phase1" Call Phase1
		Case "Phase2" Call Phase2
		Case "Phase3" Call Phase3
		Case "Phase4" Call Phase4
		Case "Phase5" Call Phase5
		Case "Sleep" Call Sleep
		Case "HWRAID" Call HWRaid
		Case "SWRAIDRetainData" Call SWRAIDRetainData
		Case "SWRAIDNoData" call SWRAIDNoData
		Case Else Call Phase5
	End Select
End If
'*****  END OF MAIN SCRIPT
'*******************************************************************************

Sub Sleep
	' Wait 2 Minutes
	Wscript.Sleep 120000
End Sub

'*******************************************************************************
' Sub:  HWRaid
'  Finalizes the System for Hardware RAID 
'*******************************************************************************
Sub HWRaid
	
	PSSVerDll = "C:\Windows\System32\pssver.dll"
	ROMCheckExe = "C:\Windows\System32\RomCheckService.exe"

	' Make the ROMCheck Files READONLY and HIDDEN
	SetAttribute PSSVerDll, ReadOnly, AttribON
	SetAttribute PSSVerDll, Hidden, AttribON
	SetAttribute ROMCheckExe, ReadOnly, AttribON
	SetAttribute ROMCheckExe, Hidden, AttribON

	' Set the Drive Letters correctly, 
	'	C: => OS, 
	'	D: => DVD-ROM, 
	'	DON'T ERASE => C:\%windir%\Backup
	SetDriveLetters
	
	' Make registry setting and remove setup files
	FinalizeOS
End Sub

'*******************************************************************************
' SWRAIDRetainData
' This is the only phase called on software raid boxes where user selects
' Restore Factory Image and retain data.
'*******************************************************************************
Sub SWRAIDRetainData
	On Error Resume Next

	WriteLog False, "Beginning Phase SWRAIDRetainData"
		
    PSSVerDll = "C:\Windows\System32\pssver.dll"
	ROMCheckExe = "C:\Windows\System32\RomCheckService.exe"
		
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Primary"
	
	' Make the ROMCheck Files READONLY and HIDDEN
	SetAttribute PSSVerDll, ReadOnly, AttribON
	SetAttribute PSSVerDll, Hidden, AttribON
	SetAttribute ROMCheckExe, ReadOnly, AttribON
	SetAttribute ROMCheckExe, Hidden, AttribON
	
	' Mirror the Primary OS to disk 1	
	'MirrorOSDrive "Select disk 0", "select partition 1", "add disk=1"
	
    ' Make sure DVD-ROM is letter D
    SetDriveLetters

	' Any Final OS tweaks go here
	' Finalize the OS
	FinalizeOS
	
    ConvertDriveDynamic("Select Disk 0")

	WriteLog False, "Ending Phase SWRAIDRetainData"
End Sub

'*******************************************************************************
' Software Phase 0
'  Create the BOOT.INI
'  Convert the Primary OS Drive to Dynamic
'*******************************************************************************
Sub Phase0
	On Error Resume Next
	
	PSSVerDll = "C:\Windows\System32\pssver.dll"
	ROMCheckExe = "C:\Windows\System32\RomCheckService.exe"
	
	WriteLog False, "Beginning Phase 0"
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Primary"
	'CreateBootINI "E:\Boot.INI", "Primary"
	
	' Make the ROMCheck Files READONLY and HIDDEN
	SetAttribute PSSVerDll, ReadOnly, AttribON
	SetAttribute PSSVerDll, Hidden, AttribON
	SetAttribute ROMCheckExe, ReadOnly, AttribON
	SetAttribute ROMCheckExe, Hidden, AttribON
	
	'We want screen saver off during long mirror resynch
	'Turn it back on later
	WshShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ScreenSaveActive",0,"REG_SZ"
	
	' ADDED to PHASE0 with removal of Secondary OS
	' Convert Drive to Dynamic
	' Do not Create any new files after Conversion (corrupts File System)
	ConvertDriveDynamic("Select Disk 1")
	
	' Convert Drive to Dynamic
	' Do not Create any new files after Conversion (corrupts File System)
	ConvertDriveDynamic("Select Disk 0")

	' Reboot
	' Removed Reboot, done in WinBOM.INI to make sure to boot from C: not CDROM
	'WshShell.Run "shutdown /r /f /t 000", vbHide, False
End Sub

'*******************************************************************************
' Software Phase 1
'  Allow Dynamic Drive Drivers to Load
'  Boot to secondary OS
'  NOT RUN DUE TO CHANGING TO SINGLE OS
'*******************************************************************************
Sub Phase1
	On Error Resume Next
	
	WriteLog False, "Beginning Phase 1"
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Secondary"
	'CreateBootINI "E:\Boot.INI", "Secondary"

	WriteLog False, "Ending Phase 1"
	
	' Reboot
	WshShell.Run "shutdown /r /f /t 000", vbHide, False
End Sub

'*******************************************************************************
' Software Phase 2
'  Re-Create the BOOT.INI (Secondary Boot)
'  Convert the Secondary OS Drive to Dynamic
'  NOT RUN DUE TO CHANGING TO SINGLE OS
'*******************************************************************************
Sub Phase2
	On Error Resume Next
	
	PSSVerDll = "C:\Windows\System32\pssver.dll"
	ROMCheckExe = "C:\Windows\System32\RomCheckService.exe"

	WriteLog False, "Beginning Phase 2"
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Secondary"
	CreateBootINI "E:\Boot.INI", "Secondary"
	
	' Make the ROMCheck Files READONLY and HIDDEN
	SetAttribute PSSVerDll, ReadOnly, AttribON
	SetAttribute PSSVerDll, Hidden, AttribON
	SetAttribute ROMCheckExe, ReadOnly, AttribON
	SetAttribute ROMCheckExe, Hidden, AttibON

	' Convert Drive to Dynamic
	' Do not Create any new files after Conversion (corrupts File System)
	ConvertDriveDynamic("Select Disk 1")
	
	WriteLog False, "Ending Phase 2"
	
	' Reboot
	WshShell.Run "shutdown /r /f /t 000", vbHide, False
End Sub

'*******************************************************************************
' Software Phase 3
'  Re-Create the BOOT.INI (Primary Boot)
'  Finalize OS - Any processing for the Secodary OS goes here
'  Run SYSPREP -reseal -pnp -reboot
'  NOT RUN DUE TO CHANGING TO SINGLE OS
'*******************************************************************************
Sub Phase3
	On Error Resume Next
	
	WriteLog False, "Beginning Phase 3"
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Primary"
	CreateBootINI "E:\Boot.INI", "Primary"
	
	' Any Final OS tweaks go here
	'      Add a RunOnce SYSPREP.INF file to C:\SYSPREP
	EditSysPrep "C:\hpnas\RunOnce.vbe Phase5"

	' Finalize the OS
	FinalizeOS
	
	WriteLog False, "Ending Phase 3"
	
	' Run SYSPREP
	' REMOVED SYSPREP, Done by WINBOM.INI
	'WshShell.Run "C:\SYSPREP\SYSPREP -reseal -pnp -reboot -quiet", vbHide, True
End Sub

'*******************************************************************************
' Software Phase 4
'  Mirror Primary OS to Disk 1
'  Create Data Drive
'  Mirror Data Drive
'  Format Data Drive
'  Finalize OS - Any processing for the Secodary OS goes here
'  Re-Create the BOOT.INI (Secondary Boot)
'  Run SYSPREP -reseal -pnp -reboot
'*******************************************************************************
Sub Phase4
	On Error Resume Next

	WriteLog False, "Beginning Phase 4"
	
	' Mirror the Secondary OS
	'MirrorOSDrive "Select disk 1", "select partition 1", "add disk=0"

	' Create File System Object
	'Set FsoP4=CreateObject("Scripting.FileSystemObject")
	'BreakFile = "C:\hpnas\breaksec.txt"
	'BreakOutput = "C:\hpnas\DPartOut.txt"
	
	'WriteLog False, "Break Mirror to move Secondary OS"
	
	' Break the Mirror just created, drop the disk 1 volume
	'Set Breakf = FsoP4.OpenTextFile(BreakFile, 2, True)
	'Breakf.WriteLine "select disk 0"
	'Breakf.WriteLine "select partition 2"
	'Breakf.WriteLine "break disk=1 nokeep"
	'Breakf.Close
			
	' Wait for File to complete writing2
	'While Not FsoP4.FileExists(BreakFile)
	'	Wscript.sleep 2000
	'Wend

	' Run DISKPART Command
	'RunDiskPart BreakFile

	' Verify that DISKPART ran OK
	'If SearchForString(BreakOutput, "The disk management services could not complete the operation.") Then
	'	WriteLog False, "Break of Mirror failed rebooting"
	'	' If DISKPART Failed reboot the system and try again
	'	WshShell.Run "shutdown /r /f /t 000", vbHide, False
	'End If
	
	'Set Breakf = nothing
	'Set FsoP4 = nothing
	
	' Mirror the Primary OS to disk 1	
	MirrorOSDrive "Select disk 0", "select partition 1", "add disk=1"
	
	' Mirror the Secondary OS to disk 1
	'MirrorOSDrive "Select disk 0", "select partition 2", "add disk=1"

    ' Make sure DVD-ROM is letter D
    SetDriveLetters

	' Create Data Volume, mirror Too
	CreateDataVolume
	
	' Format the data drive
	FormatDataDrive

	' Any Final OS tweaks go here
	' Finalize the OS
	FinalizeOS
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Primary"
	'CreateBootINI "E:\Boot.INI", "FirstBoot"

    'turn screen saver back on
    WshShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ScreenSaveActive",1,"REG_SZ"

	WriteLog False, "Ending Phase 4"
	
	' Run SYSPREP
	' Removed SYSPREP, Done by WINBOM.INI
	'WshShell.Run "C:\SYSPREP\SYSPREP -reseal -pnp -reboot -quiet", vbHide, True
End Sub


'*******************************************************************************
' Software SWRAIDNoData
' On DPM servers we don't need to create the data drive.
'  Mirror Primary OS to Disk 1
'  Do not Create Data Drive
'  Do not Mirror Data Drive
'  Do not Format Data Drive
'  Finalize OS - Any processing for the Secodary OS goes here
'  Re-Create the BOOT.INI (Secondary Boot)
'  Run SYSPREP -reseal -pnp -reboot
'*******************************************************************************
Sub SWRAIDNoData
	On Error Resume Next

	WriteLog False, "Beginning Phase SWRAIDNoData"
	
	' Mirror the Secondary OS
	'MirrorOSDrive "Select disk 1", "select partition 1", "add disk=0"

	' Create File System Object
	'Set FsoP4=CreateObject("Scripting.FileSystemObject")
	'BreakFile = "C:\hpnas\breaksec.txt"
	'BreakOutput = "C:\hpnas\DPartOut.txt"
	
	'WriteLog False, "Break Mirror to move Secondary OS"
	
	' Break the Mirror just created, drop the disk 1 volume
	'Set Breakf = FsoP4.OpenTextFile(BreakFile, 2, True)
	'Breakf.WriteLine "select disk 0"
	'Breakf.WriteLine "select partition 2"
	'Breakf.WriteLine "break disk=1 nokeep"
	'Breakf.Close
			
	' Wait for File to complete writing2
	'While Not FsoP4.FileExists(BreakFile)
	'	Wscript.sleep 2000
	'Wend

	' Run DISKPART Command
	'RunDiskPart BreakFile

	' Verify that DISKPART ran OK
	'If SearchForString(BreakOutput, "The disk management services could not complete the operation.") Then
	'	WriteLog False, "Break of Mirror failed rebooting"
	'	' If DISKPART Failed reboot the system and try again
	'	WshShell.Run "shutdown /r /f /t 000", vbHide, False
	'End If
	
	'Set Breakf = nothing
	'Set FsoP4 = nothing
	
	' Mirror the Primary OS to disk 1	
	MirrorOSDrive "Select disk 0", "select partition 1", "add disk=1"
	
	' Mirror the Secondary OS to disk 1
	'MirrorOSDrive "Select disk 0", "select partition 2", "add disk=1"

    ' Make sure DVD-ROM is letter D
    SetDriveLetters

	' Create Data Volume, mirror Too
	'CreateDataVolume
	
	' Format the data drive
	'FormatDataDrive

	' Any Final OS tweaks go here
	' Finalize the OS
	FinalizeOS
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Primary"
	'CreateBootINI "E:\Boot.INI", "FirstBoot"

    'turn screen saver back on
    WshShell.RegWrite "HKEY_CURRENT_USER\Control Panel\Desktop\ScreenSaveActive",1,"REG_SZ"

	WriteLog False, "Ending Phase SWRAIDNoData"
	
	' Run SYSPREP
	' Removed SYSPREP, Done by WINBOM.INI
	'WshShell.Run "C:\SYSPREP\SYSPREP -reseal -pnp -reboot -quiet", vbHide, True
End Sub


'*******************************************************************************
' Software Phase 5
'  Create the BOOT.INI during mini-setup on the Secondary OS
'  NOT RUN DUE TO CHANGING TO SINGLE OS
'*******************************************************************************
Sub Phase5
	On Error Resume Next

	WriteLog False, "Beginning Phase 5"
	
	' Create the BOOT.INI File
	CreateBootINI "C:\Boot.INI", "Primary"
	CreateBootINI "E:\Boot.INI", "Primary"
	
	' Reboot
	WshShell.Run "shutdown /r /f /t 000", vbHide, False

	WriteLog False, "Ending Phase 5"

End Sub

'************************************************************
' Sub: Set Drive Letters
' Verify the drive letters are set correctly
'************************************************************
Sub SetDriveLetters()
On Error Resume Next
	' Start instance of DISKPART to maintain the VDS service
	'  Use RUN method instead of EXEC to hide the window
	WshShell.Run "DISKPART.EXE", vbHide, False
	
	' Create file system object, needed in Functions also.
	Set FsoDrives=CreateObject("Scripting.FileSystemObject")
	VolFile = "C:\hpnas\volumes.txt"
	VolOutFile = "C:\hpnas\DpartOut.txt"
	RemoveLettersFile = "C:\hpnas\removeDriveLetters.txt"
	AssignLettersFile = "C:\hpnas\assign.txt"
	
	If FsoDrives.FileExists (VolFile) Then
		FsoDrives.DeleteFile VolFile, True
	End If
	
	' Create files needed
	Set f = FsoDrives.OpenTextFile(VolFile, 2, True)
	f.WriteLine "list volume"
	f.close

	While Not FsoDrives.FileExists(VolFile)
		Wscript.sleep 2000
	Wend

	' Loop Added by KLS due to VDS not always coming up on DL100G2 due to SW RAID LED Driver
	DO
		' Loop until diskpart is working properly
		dpCount = 0
		DO
			RunDiskPart VolFile
			
			If FsoDrives.FileExists(VolOutFile) Then
				DiskPartFailing=SearchForString(VolOutFile, "The disk management services could not complete the operation.")
			Else
				DiskPartFailing=True
			End If	

			dpCount = dpCount + 1
			' Loop a maixmum of 90 times
			If dpCount > 90 Then
				' Write Error to log if count 90 is reached
				WriteLog True, "Diskpart not running"
				WriteLog True, "Rebooting or Exiting Script"
				WshShell.Run "Shutdown /r /t 000 /f", vbHide, False
				Wscript.Quit
			End If
			If dpCount > 1 Then
				' Write progress to log
				WriteLog False, "Waiting for diskpart"
			End If
			' Wait for 2 seconds and try again
			Wscript.sleep 2000

		Loop Until Not DiskPartFailing

		' Set initial variables
		dvdNumber = ""
		dvdLetter = ""
		Set f = FsoDrives.OpenTextFile(VolOutFile, 1)
		VolumesList = f.ReadAll
		f.Close	

		'Delete all the Drive Letters and mount path's (C: can not be removed)
		set f = FsoDrives.OpenTextFile(RemoveLettersFile, 2, True)
		volLine = Split(VolumesList, vbLf)

		' Using the number of lines in the returned Vol List, create the file to remove the letters
		' Does this break when trying to remove letter from C?
		For j=7 to (Ubound(VolLine)-1)
			f.WriteLine "Select Volume " & j-7
			f.WriteLine "Remove all noerr"
		Next
		f.Close
		
		Wscript.Sleep 2000
		
		While Not FsoDrives.FileExists(RemoveLettersFile)
			Wscript.sleep 2000
		Wend

		WriteLog False, "Attempting to Delete Drive Letter from Volume " & j-7

		RunDiskPart RemoveLettersFile

		' Get Volume List Again
		DO
			RunDiskPart VolFile
			DiskPartFailing=SearchForString(VolOutFile, "The disk management services could not complete the operation.")
		Loop Until Not DiskPartFailing

		Set f = FsoDrives.OpenTextFile(VolOutFile, 1)
		VolumesList = f.ReadAll
		f.Close	
		
		' Split the read in file by Line Feed
		volLine = Split(VolumesList, vbLf)
		
		' Skip the first 6 lines, Header explaining the program used
		For k=7 to (Ubound(VolLine)-1)
			' Remove the DoubleSpaces in the DiskPart Output
			' #### Note: Spaces in the Label, or missing Label text will make everything over 4 break
			CleanLine = VolLine(k)
		  	While InStr(CleanLine, "  ") <> 0
		  		CleanLine = Replace(CleanLine, "  ", " ")
		  	Wend
		  	' Split the Line by Spaces
			arr = Split(CleanLine, " ")
			
			' Still need to check all items in array because we can not guarantee order
			For j=3 to (UBound(arr)-1)
				If arr(j) = "DVD-ROM" Then
					dvdNumber = arr(2)
					' dvdLetter = arr(3) ' All Drive Letters should be gone
				ElseIf (arr(j) = "DON" & Chr(39) & "T") AND (arr(j+1) = "ERASE") Then
					DENumber = arr(2)
					' DELetter = arr(3)  ' All Drive Letters should be gone
				End If
			Next	
		Next
		
		WriteLog False, "dvdNumber is =" & dvdNumber
			
 		' Create a file to Assign new drive letters to the DVD-ROM and Secondary OS
		Set f = FsoDrives.OpenTextFile(AssignLettersFile, 2, True)
		
		' if the DVD-ROM is not D
		If Not dvdNumber = "" Then
			' Add lines to Assign Letter D to DVD-ROM
			f.WriteLine "Select Volume " & dvdNumber
			f.WriteLine "Assign Letter=D"
		End If
		If Not DENumber = "" Then
			f.WriteLine "Select Volume " & DENumber
			f.WriteLine "Assign Mount=%windir%\backup"
		End If

		' Assign secondary OS according to what drive we are on
'		If BootDrive = "Primary" Then
'			f.WriteLine "select disk 1"
'			f.WriteLine "select partition 1"
'			f.WriteLine "Assign Letter=E noerr"
'		End If
'		If BootDrive = "Secondary" Then
'			f.WriteLine "select disk 0"
'			f.WriteLine "select partition 1"
'			f.WriteLine "Assign Letter=E noerr"
'		End If

		f.Close
		
		' Wait until file is completely written
		While Not FsoDrives.FileExists(AssignLettersFile)
			Wscript.sleep 2000
		Wend
	
		RunDiskPart AssignLettersFile

    		' Verify that there were not errors in setting the Drive Letters
		DiskPartFailed = SearchForString(VolOutFile, "DiskPart cannot reassign the drive letter on a system, boot or pagefile volume.")

		WriteLog False, "DiskPartFailed is =" & DiskPartFailed

		'RunDiskPart VolFile

		'DriveCheck1 = SearchForDisks(VolOutFile, "C", "Partition", "Healthy")
		'If BootDrive = "Primary" Then
		'	DriveCheck2 = SearchForDisks("C:\HPNAS\Assign1Check.txt", "E", "Partition", "Healthy")
		'ElseIf BootDrive = "Secondary" Then
		'	DriveCheck2 = SearchForDisks("C:\HPNAS\Assign1Check.txt", "E", "Simple", "Healthy")
		'End If 
		'WriteLog False, "DriveCheck1 is =" & DriveCheck1
		'WriteLog False, "DriveCheck2 is =" & DriveCheck2
		WriteLog False, "Setting Drive Letters Returned:" & Not DiskPartFailed
			
			
	' Go back to the beginning if this fails, possible endless loop
	Loop Until Not DiskPartFailed

	' Delete the files Created in this function
	FsoDrives.DeleteFile VolFile, True
	FsoDrives.DeleteFile VolOutFile, True
	FsoDrives.DeleteFile RemoveLettersFile, True
	FsoDrives.DeleteFile AssignLettersFile, True

	Set FsoDrives=Nothing	
End Sub

'************************************************************
' Sub: FinalizeOS
' Complete the final steps to preparing the OS
'************************************************************
Sub FinalizeOS()

	Set FsoFinal=CreateObject("Scripting.FileSystemObject")

	' Load XML Doc
	Set xmlDoc = LoadXmlDoc()
	'      Write the versions to the Registry
	'         Get SWVN
	productID = GetProductInfo("id")
	Set SWVNNode = GetXMLNode(xmlDoc, productID, "SWVN")
	Set SWVNVersion = xmlDoc.DocumentElement.SelectSingleNode("//SWVNVersion")
	If (Not SWVNNode Is Nothing) Then
		WshShell.RegWrite "HKLM\Software\Hewlett-Packard\ProLiant Storage Server\SWVN",SWVNNode.Text & "." & SWVNVersion.Text,"REG_SZ"
		WriteLog False, "Setting Registry SWVN: " & SWVNNode.Text & "." & SWVNVersion.Text
	End If
	
	'      Write the Product Name to the Registry
	productName = GetProductInfo("name")
	WshShell.RegWrite "HKLM\Software\Hewlett-Packard\ProLiant Storage Server\Versions\Base",productName,"REG_SZ"
	
	'      Write the Base OS Build Version to Registry
	Set BuildVersion = xmlDoc.DocumentElement.SelectSingleNode("//Build")
	WshShell.RegWrite "HKLM\Software\Hewlett-Packard\ProLiant Storage Server\Build", BuildVersion.Text, "REG_SZ"
	WriteLog False, "OS Build Version: " & BuildVersion.Text

	'      Write the XML Version to Registry
	Set xmlVersion = xmlDoc.DocumentElement.SelectSingleNode("//SchemaVersion")
	WshShell.RegWrite "HKLM\Software\Hewlett-Packard\ProLiant Storage Server\XML Version", xmlVersion.Text, "REG_SZ"
	WriteLog False, "XML File Version: " & xmlVersion.Text

	'      Write R2-RunOnce Version
	WshShell.RegWrite "HKLM\Software\Hewlett-Packard\ProLiant Storage Server\RunOnce Version", RunOnceVer, "REG_SZ"
	WriteLog False, "RunOnce Version: " & RunOnceVer
	
	'      Copy the NAS MMC Link into the STARTUP folder
	If FsoFinal.FileExists("C:\Documents and Settings\All Users\Desktop\HP Storage Server Management.lnk") Then
		FsoFinal.CopyFile "C:\Documents and Settings\All Users\Desktop\HP Storage Server Management.lnk", "C:\Documents and Settings\All Users\Start Menu\Programs\Startup\HP Storage Server Management.lnk"
		WriteLog False, "Copy HPSS Mgmt Link to Startup Menu"
	End If
	
	'      Set the ROM service to start in automatic
	WshShell.Run "C:\Windows\System32\SC.EXE config ROM start= Auto"
	WriteLog False, "Set ROM Service Startup to: Automatic"
	
	'      Set the "HP Storage Service Management Service" to start automatically
	WshShell.Run "C:\Windows\System32\SC.EXE config HPSSMgmt start= Auto"
	WriteLog False, "Set HPSSMgmt Service Startup to: Automatic"

	'      Remove the c:\hpnas\temp folder
	'      REMOVED Deleting HPNAS folder, Done in WINBOM.INI
	'If FsoFinal.FolderExists("C:\hpnas\temp") Then
	'	FsoFinal.DeleteFolder "C:\hpnas\temp"
	'End If

	'      Set the HDMonSvc and HDMon Services to automatic on Software RAID DL100G2
	Set RAIDCtrlNode = GetXMLNode(xmlDoc, productID, "RAIDController")
	If (Not RAIDCtrlNode Is Nothing) AND (Not SWVNNode Is Nothing) Then
		If (SWVNNode.text = "100G2") AND (RAIDCtrlNode.Text = "None") Then 'HW RAID
			WshShell.Run "C:\Windows\System32\SC.EXE config HDmonSvc start= Auto"
			WshShell.Run "C:\Windows\System32\SC.EXE config HDmon start= Auto"
		End If	
	End If

	' Run the CIMINFO utility to set the CIMINFO information
	If Not FsoFinal.FolderExists("C:\COMPAQ") Then
		FsoFinal.CreateFolder("C:\COMPAQ")
	End If
	WshShell.Run "C:\hpnas\temp\CIMINFO.EXE", vbHide, True
	
	Set SWVNNode = nothing
	Set RAIDCtrlNode = nothing		
	Set xmlVersion = nothing
	Set xmlDoc = nothing
	Set FsoFinal = nothing
End Sub

'************************************************************
' Function: GetProductInfo()
' Returns the product ID or Name of the Storage Server
'************************************************************
Function GetProductInfo(infoType)

	WriteLog False, "Get the Product " & infoType

	ProductInfoPath = "C:\hpnas\temp\prodInfo.txt"
	
	Set productInfoFso=CreateObject("Scripting.FileSystemObject")

	' Delete Product Info Output File
	If productInfoFso.FileExists(ProductInfoPath) Then
		productInfoFso.DeleteFile(ProductInfoPath)
	End If
	
	' Delete Product Info Batch file
	If productInfoFso.FileExists("c:\hpnas\temp\prodinfo.bat") Then
		productInfoFso.DeleteFile "C:\hpnas\temp\prodinfo.bat"
	End If

	' Rebuild Product Info Batch File
	Set productInfoFile=productInfoFso.OpenTextFile("C:\hpnas\temp\prodinfo.bat",8,True)
	productInfoFile.WriteLine "c:\hpnas\temp\product.EXE " & infoType & " > " & ProductInfoPath
	productInfoFile.close
	Wscript.Sleep 5000

	While Not productInfoFso.FileExists("C:\hpnas\temp\prodinfo.bat") 
		Wscript.Sleep 2000
	Wend

	' Run Product Info Batch File
	WshShell.Run "c:\hpnas\temp\prodinfo.bat", vbHide, True
	Wscript.sleep 5000
	
	' Open Files, Read the PRODUCT.EXE output into a variable
	If productInfoFso.FileExists(ProductInfoPath) Then
		Set productInfoFile = productInfoFso.OpenTextFile(ProductInfoPath,1)
		GetProductInfo = productInfoFile.ReadLine
		WriteLog False, "Product " & infoType & ": " & GetProductInfo
		productInfoFile.close
	Else
		GetProductInfo = "Null"
	End If
	
	Set productInfoFile = nothing
	Set productInfoFso = nothing
End Function

'************************************************************
' Function: LoadXmlDoc(xmlPath)
' Loads an XML document and returns the document Object
'************************************************************
Function LoadXmlDoc()

	xmlFilePath = "C:\hpnas\temp\products.xml"

	Set LoadXmlDoc = CreateObject("Msxml2.DOMDocument.3.0")

	LoadXmlDoc.async = false
	LoadXmlDoc.SetProperty "SelectionLanguage", "XPath"
	LoadXmlDoc.Load xmlFilePath

	if LoadXmlDoc.parseError.errorCode <> 0 Then
		WriteLog True, LoadXmlDoc.parseError.reason
	end if
End Function

'************************************************************
' Function: GetXMLNode(productID, xmlNode)
' Gets the specified xmlNode from the XML Doc based on 
'  the productID specified
'************************************************************
Function GetXMLNode(nodeXmlDoc, uniqueID, xmlNode)

	Set ServerNode = nodeXmlDoc.DocumentElement.SelectSingleNode("//Server[Id='" & uniqueID & "']")
	Set GetXMLNode = ServerNode.SelectSingleNode(xmlNode)
	WriteLog False, "Product: " & uniqueID & "    " & xmlNode & ": " & GetXMLNode.Text

	Set ServerNode = nothing
End Function

'************************************************************
' Sub: EditSysPrep()
' Adds a line to the SYSPREP.INF to run a script during
' Mini-Setup
'************************************************************
Sub EditSysPrep(RunOnceScript)

	Set SysPrepFso=CreateObject("Scripting.FileSystemObject")

	SysPrepINF = "C:\SYSPREP\SYSPREP.INF"
	OutputINF = "C:\SYSPREP\OUTPUT.INF"
	
	WriteLog False, "Adding RunOnce Script to SYSPREP"
	
	' Open Files
	Set SysPrepFile = SysPrepFso.OpenTextFile(SysPrepINF,1)
	Set OutINFFile = SysPrepFso.OpenTextFile(OutputINF,2,True)
	
	While NOT SysPrepFile.AtEndOfStream <> 0
		SPLine = SysPrepFile.ReadLine
		OutINFFile.WriteLine SPLine
'		WriteLog False, SPLine		
		If InStr(SPLine, "[GuiRunOnce]") <> 0 Then
			OutINFFile.WriteLine RunOnceScript & " Phase5"
		End If
	Wend
	
	If SysPrepFso.FileExists(SysPrepINF) Then
		SysPrepFso.DeleteFile(SysPrepINF)
	End If
	
	SysPrepFso.MoveFile OutputINF, SysPrepINF
	
	WriteLog False, "Completed Edits to SYSPREP"
	
	Set SysPrepFso = nothing
End Sub
'************************************************************
' Function: FormatDataDrive()
' Performs format function on the data drive.
'************************************************************
Sub FormatDataDrive()
On Error Resume Next

	' Clear any previous errors
	Err.Clear
	VolList = "C:\hpnas\DPartOut.txt"
	
	' Create a new File System Object
	Set FsoFormat=CreateObject("Scripting.FileSystemObject")
	
	WriteLog False, "Formatting the Data Drive"
	
	' Verify Drives are set to the correct Drive Letter
	CheckVolumeStatus
	
	DiskPartSuccess0 = SearchForString(VolList, "C                NTFS   Mirror")
	'DiskPartSuccess1 = SearchForString(VolList, "E                NTFS   Mirror")
	DiskPartSuccess2 = SearchForString(VolList, "E                RAW    Mirror")
		
	WriteLog False, "Searching for all drives complete with result:" & DiskPartSuccess0 & ":" & DiskPartSuccess2

	' Wait 10 Seconds
	Wscript.Sleep 10000
	
	If DiskPartSuccess2 Then
		' Format F drive that we just created
		WriteLog False, "Found Unconfigured Drive and Formatting."

		FormatBat = "C:\HPNAS\temp\FMT.BAT"
		
		' Create Format Batch file
		Set Formatf = FsoFormat.OpenTextFile(FormatBat, 2, True)
		Formatf.WriteLine "Format E: /FS:NTFS /V:Data /A:16K /Q /Y"
		Formatf.Close

		' Wait for File to complete writing
		While Not FsoFormat.FileExists(FormatBat)
			Wscript.sleep 2000
		Wend

		WshShell.Run FormatBat, vbHide, True
	
		WriteLog False, "Format Call Completed"
	Else
		WriteLog False, "Could not Find unformatted Drive, skip format."
	End If
	
	' Delete files used in this Phase
	FsoFormat.DeleteFile VolList, True

	' Write to Log File that format was completed
	WriteLog False, "Format Complete, Finishing Configuration"
	
	' Clear the File System Object and File variable
	Set Formatf = Nothing
	Set FsoFormat = Nothing
End Sub

'************************************************************
' Function: CreateDataVolume
' Creates the Data volume
'************************************************************
Sub CreateDataVolume()
On Error Resume Next

	CreateDataFile = "C:\HPNAS\CreateF.txt"
	DPartOutput = "C:\HPNAS\DPartOut.txt"
	MirrorDataFile = "C:\HPNAS\MirrorF.txt"

	' Create a File System Object
	Set FsoData=CreateObject("Scripting.FileSystemObject")

	' Write to Log file that the data drive is being created
	WriteLog False, "Creating Data Drive"

	' Create new file which has DISKPART commands to create data disk
	Set Createf = FsoData.OpenTextFile(CreateDataFile, 2, True)

	' Write Commands to file to create secondary disk
	Createf.WriteLine "create volume simple disk=0"
	Createf.WriteLine "assign" 'letter E here should get assigned here 
	Createf.Close

	' Wait until file is finished writing
	While Not FsoData.FileExists(CreateDataFile)
		Wscript.sleep 2000
	Wend

	' Run DISKPART Command to create Data Volume
	RunDiskPart CreateDataFile

'	' Loop until Data Drive is mirrored  
'	' Commented out the Loop to mirror to avoid infinite loop
'	' one chance to mirror data drive. Since no data yet it's not so bad if this fails.	
'	Do
	' Write to Log File, Mirror of Data Drive
	WriteLog False, "Mirroring Data Drive"
		
	' Create new file which has DISKPART commands to mirror Secondary OS
	Set Mirrorf = FsoData.OpenTextFile(MirrorDataFile, 2, True)
	
	' Write Commands to file to mirror Data Drive
	Mirrorf.WriteLine "select disk 0"
	Mirrorf.WriteLine "select partition 2"
	Mirrorf.WriteLine "add disk=1"
	'Mirrorf.WriteLine "Assign Letter=E noerr"
	Mirrorf.Close

	' Wait until file is finished writing
	While Not FsoData.FileExists(MirrorDataFile)
		Wscript.sleep 2000
	Wend
		
	' Run DISKPART command to mirror Data drive
	RunDiskPart MirrorDataFile
		
	' Verify DISKPART ran OK
	If SearchForString(DPartOutput, "The disk management services could not complete the operation.") Then
		' Reboot if DISKPART did not run OK
		WriteLog False, "Mirror of Data Drive Could not complete"
		WshShell.Run "shutdown /r /f /t 000", vbHide, False
	End If

	' Verify that DISKPART succeeded in creating a mirror for the Secondary OS
	DiskPartSuccess = SearchForString(DPartOutput, "DiskPart succeeded in adding a mirror to the volume.")

	' Write to Log file the result of the mirror attempt
	WriteLog False, "Mirror of Data Attempt Complete with result:" & DiskPartSuccess
	
'	' Return to the beginning until the mirror is successfully created
'	Loop Until DiskPartSuccess

	' Wait while mirror completes, this could take a while
	While CheckMirrorStatus() = False
		Wscript.Sleep 10000
	Wend
	
	' Delete files used in this Phase
	FsoData.DeleteFile CreateDataFile, True
	FsoData.DeleteFile MirrorDataFile, True
	FsoData.DeleteFile DPartOutput, True
	
	' Clear the File System Object and File variable
	Set Mirrorf = nothing
	Set Createf = nothing
	Set FsoData = Nothing
End Sub

'************************************************************
' Function: CheckVolumeStatus()
' Return the Volume List from DISKPART
'************************************************************
Function CheckVolumeStatus()

	VolumesText = "C:\hpnas\volumes.txt"
	VolOutput = "C:\hpnas\DPartOut.txt"

	Set FsoVol = CreateObject("Scripting.FileSystemObject")	
	
	' Delete the VOLUMES.TXT File if it exists
	If FsoVol.FileExists(VolumesText) Then
		FsoVol.DeleteFile(VolumesText)
	End If
	
	' Create Volumes.txt file
	Set VolTextf = FsoVol.OpenTextFile(VolumesText, 2, True)
	VolTextf.WriteLine "List volume"
	VolTextf.Close

	While Not FsoVol.FileExists(VolumesText)
		Wscript.sleep 2000
	Wend
	
	' Run DISKPART command
	RunDiskPart VolumesText
	
	' Wait for the file to exist only for a specified time limit
	Count = 0
	While Not FsoVol.FileExists(VolOutput)
		Count = Count + 1
		If Count > 90 Then
			' Kills the script with the TRUE option
			WriteLog True, "Unable to get volume list from Diskpart"
		End If
		WriteLog False, "Waiting for Volume List"
		Wscript.sleep 2000
	Wend

	' Don't delete the output file, calling functions need it
	FsoMir.DeleteFile VolumesText, True
	
	' Close out the Handles
	Set VolTextf = nothing
	Set FsoVol = nothing
End Function

'************************************************************
' Function: CheckMirrorStatus()
' Return the status of mirroring
'************************************************************
Function CheckMirrorStatus()
On Error Resume Next

	CheckMirrorStatus = True
	CheckMirrorOutput = "C:\hpnas\DPartOut.txt"

	' Get the Volume List from diskpart
	CheckVolumeStatus

	Set FsoMir = CreateObject("Scripting.FileSystemObject")	
	
	' Read the entire file into variable
	Set fMir = FsoMir.OpenTextFile(CheckMirrorOutput, 1)
	volFile = fMir.ReadAll
	fMir.Close	
	
	' Split the file by line
	volLine = Split(volFile, vbLf)
	
	' Step through every line in the file
	For i=4 to Ubound(VolLine)
	
		' Split the line by whitespace
		arr = Split(VolLine(i), " ")
		
		' Search the line for the Rebuild Status (Only one mirror at a time)
		For j=2 to Ubound(arr)
			if arr(j) = "Rebuild" Then
				CheckMirrorStatus = False
'				Exit Function
			End If
		Next
	Next
	
	FsoMir.DeleteFile VolOutput, True
	
	Set fMir = Nothing
	Set FsoMir = Nothing
End Function

'************************************************************
' Function: SearchForString(FileName, String)
' Return the status of mirroring
'************************************************************
Function SearchForString(strFileName, strSearchStr)
	On Error Resume Next
	
	SearchForString = False
	
	Set FsoSearch = CreateObject("Scripting.FileSystemObject")	
	Set fSearch = FsoSearch.OpenTextFile(strFileName, 1)
	
	While Not FsoSearch.FileExists(strFileName)
		Count = Count + 1
		If Count > 5 Then
			Exit Function
		End If
		Wscript.sleep 2000
	Wend
	
	SearchFile = fSearch.ReadAll
	fSearch.Close	
	SearchLine = Split(SearchFile, vbLf)
	For l=0 to Ubound(SearchLine)
		if Not Instr(SearchLine(l), strSearchStr) = 0 Then
			SearchForString = True
			Exit Function
		End If
	Next
	
	Set fSearch = Nothing
	Set FsoSearch = Nothing
End Function

'*******************************************************************************
' Function: MirrorOSDrive
' This function is called 3 times in software RAID
'*******************************************************************************
Function MirrorOSDrive(selectDisk, selectPartition, addDisk)
	On Error Resume Next

	mirrorFile = ("C:\hpnas\mirrorOS.txt")
	outputFile = ("C:\hpnas\DPartOut.txt")
	
	WriteLog False, selectDisk & " : " & selectPartition & " : " & addDisk
	WriteLog False, mirrorFile & " : " & outputFile
	
	Set Mirrorfso=CreateObject("Scripting.FileSystemObject")

	' TODO: Need to add a check to see it Partition is already Mirrored

	'Mirror selectDisk, selectPartition to addDisk
	set mirrorf = Mirrorfso.OpenTextFile(mirrorFile, 2, True)
	mirrorf.WriteLine selectDisk
	mirrorf.WriteLine selectPartition
	mirrorf.WriteLine addDisk
	mirrorf.Close
			
	' Wait for File to complete writing
	While Not Mirrorfso.FileExists(mirrorFile)
		Wscript.sleep 2000
	Wend

	RunDiskPart mirrorFile
		
	' Verify that DISKPART ran OK
	If SearchForString(outputFile, "The disk management services could not complete the operation.") Then
		WriteLog False, "Failed to mirror the drive"
		' If DISKPART Failed reboot the system and try again
		WshShell.Run "shutdown /r /f /t 000", vbHide, False
	End If

	'Loop until the mirroring is complete, This will take a while
	While CheckMirrorStatus() = False
		Wscript.Sleep 10000
	Wend

	' Delete Files Created here
	Mirrorfso.DeleteFile mirrorFile, True
	Mirrorfso.DeleteFile outputFile, True
	
	Set Mirrorf = nothing
	Set Mirrorfso = nothing
End Function

'*******************************************************************************
' Convert the Select Disk to Dynamic
'*******************************************************************************
Sub ConvertDriveDynamic (SelectedDrv)
	On Error Resume Next

	Set Convertfso=CreateObject("Scripting.FileSystemObject")
	
	' Write to Log file
	WriteLog False, "Beginning to convert disk to dynamic disk: " & SelectedDrv

	'Create File to run in Diskpart to convert C Drive to dynamic
	Set ConvertFile = Convertfso.OpenTextFile("C:\HPNAS\ConvDrv.txt", 2, True)

	ConvertFile.WriteLine SelectedDrv
	ConvertFile.WriteLine "Convert Dynamic"
	ConvertFile.Close

	While Not Convertfso.FileExists("C:\HPNAS\ConvDrv.txt")
		Wscript.Sleep 2000
	Wend
	
	' DO NOT CREATE ANY NEW FILES AFTER THIS OR YOU WILL CORRUPT THE DRIVE
	RunDiskPart "C:\HPNAS\ConvDrv.txt"
	
	Set ConvertFile = nothing
	Set Convertfso = nothing
End Sub

'*******************************************************************************
' Run a DISKPART Command
'  Delete the Output File
'  Create DPART.BAT
'  Run the Command
'  Output to C:\hpnas\DPartOut.txt
'*******************************************************************************
Sub RunDiskPart (DPartFile)

	OutputFile = "C:\hpnas\DPartOut.txt"
	
	Set DiskPartfso=CreateObject("Scripting.FileSystemObject")

	If DiskPartfso.FileExists (OutputFile) Then
		DiskPartfso.DeleteFile OutputFile, True
	End If
	If DiskPartfso.FileExists ("C:\hpnas\DPart.bat") Then
		DiskPartfso.DeleteFile "C:\hpnas\DPart.bat", True
	End If

	Set DiskPartFile = DiskPartfso.OpenTextFile("C:\hpnas\DPart.bat", 2, True)
	DiskPartFile.WriteLine "Diskpart /s %1 >%2"
	DiskPartFile.close

	While Not DiskPartfso.FileExists("C:\hpnas\DPart.bat")
		Wscript.sleep 2000
	Wend

	' Run the DISKPART utility to convert the Primary OS Drive to Dynamic
	' DPart.bat is created in SetDriveLetters
	WshShell.Run "C:\hpnas\DPart.bat " & DPartFile & " " & OutputFile, vbHide, True
	
	' Wait 15 Seconds for Command to Complete
	Wscript.Sleep 15000

	' Wait until DISKPART output file is completely written
	BreakOut = 0
	While (Not DiskPartfso.FileExists(OutputFile)) AND (BreakOut < 90)
		BreakOut = BreakOut + 1
		Wscript.sleep 2000
	Wend
	If Breakout = 90 Then
		WriteLog True, "DiskPart Command never returned"
	End If

	Set DiskPartFile = nothing
	Set DiskPartfso = nothing
End Sub

'*******************************************************************************
' Set File Attributes
'  Pass in File name,  Attribute to change,  
'*******************************************************************************
Sub SetAttribute (FileName, Attrib, FinalState)
	Set FileNamefso=CreateObject("Scripting.FileSystemObject")
	
	Set FileHandle = FileNamefso.GetFile(FileName)
	
	If FinalState Then
		If NOT ((FileHandle.Attributes AND Attrib) = Attrib) Then
			FileHandle.Attributes = FileHandle.Attributes XOR Attrib
		End If
	Else
		If (FileHandle.Attributes AND Attrib) = Attrib Then
			FileHandle.Attributes = FileHandle.Attributes XOR Attrib
		End If
	End If
	
	Set FileHandle = nothing
	Set FileNamefso = nothing
End Sub
'*******************************************************************************
' Create the BOOT.INI File
'  Create the BOOT.INI file on both the primary and secondary OS drives
'*******************************************************************************
Sub CreateBootINI (BootFile, BootDrv)
	On Error Resume Next
	
	WriteLog False, "Re-Creating: " & BootFile & " Boot from: " & BootDrv
	
	Set BootINIfso=CreateObject("Scripting.FileSystemObject")

	' Turn the File Attributes OFF
	SetAttribute BootFile, ReadOnly, AttribOFF
	SetAttribute BootFile, Hidden, AttribOFF
	SetAttribute BootFile, System, AttribOFF
	
	' Delete Boot.INI File
	If BootINIfso.FileExists (BootFile) Then
		BootINI.DeleteFile BootFile, True
	End If
	
	' Create a new file and handle for the BOOT.INI
	Set INIFile = BootINIfso.OpenTextFile(BootFile, 2, True)
	
	' Re-Create the BOOT.INI File
	INIFile.WriteLine "[boot loader]"
	INIFile.WriteLine "timeout=10"
	Select Case BootDrv
		Case "Primary" INIFile.WriteLine "default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS"
		Case "Secondary" INIFile.WriteLine "default=multi(0)disk(0)rdisk(1)partition(1)\WINDOWS"
		Case "FirstBoot" INIFile.WriteLine "default=multi(0)disk(0)rdisk(1)partition(2)\WINDOWS"
		Case Else INIFile.WriteLine "default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS"
	End Select
	
	INIFile.WriteLine "[operating systems]"
	INIFile.WriteLine "multi(0)disk(0)rdisk(0)partition(1)\WINDOWS=" & Chr(34) & "Windows Storage Server R2, Primary OS" & Chr(34) & " /fastdetect /noexecute=Optin"
	INIFile.WriteLine "multi(0)disk(0)rdisk(1)partition(1)\WINDOWS=" & Chr(34) & "Windows Storage Server R2, Primary OS Mirror" & Chr(34) & " /fastdetect /noexecute=Optin"
	'INIFile.WriteLine "multi(0)disk(0)rdisk(1)partition(2)\WINDOWS=" & Chr(34) & "Windows Storage Server R2, Secondary OS" & Chr(34) & " /fastdetect /noexecute=Optin"
	'INIFile.WriteLine "multi(0)disk(0)rdisk(0)partition(2)\WINDOWS=" & Chr(34) & "Windows Storage Server R2, Secondary OS Mirror" & Chr(34) & " /fastdetect /noexecute=Optin"
	INIFile.Close

	' Wait for the file to exist
	While Not BootINIfso.FileExists(BootFile)
		Wscript.sleep 2000
	Wend

	' Get rid of the handle because we need to get it again in a different way
	Set INIFile = nothing

	' Turn the File Attributes ON
	SetAttribute BootFile, ReadOnly, AttribON
	SetAttribute BootFile, Hidden, AttribON
	SetAttribute BootFile, System, AttribON
	
	WriteLog False, "Completed re-creating: " & BootFile
	
	Set BootINIfso = nothing
End Sub

'************************************************************
' Function: WriteLog(intErr,strString)
' Performs format function on the data drive.
'************************************************************
Function WriteLog(intErr, strString)
On Error Resume Next

	Set FsoError=CreateObject("Scripting.FileSystemObject")

	Set fError = FsoError.OpenTextFile("C:\hpnas\Install.log", 8, True)
	If intErr = True Then
		fError.WriteLine "--------------------------------------------------------------"
		fError.WriteLine "Error: " & Cstr(Time) & ":" & strString
		fError.WriteLine "--------------------------------------------------------------"
		fError.WriteLine ""
'		WriteDebugInfo()
	Else
		fError.WriteLine "**" & Cstr(Time) & ":" & StrString
	End If
	fError.Close
	
	If (FsoError.FolderExists("E:\HPNAS")) Then
		Set fError = FsoError.OpenTextFile("E:\HPNAS\Install.log", 8, True)
		If intErr = True Then
			fError.WriteLine "--------------------------------------------------------------"
			fError.WriteLine "Error: " & Cstr(Time) & ":" & strString
			fError.WriteLine "--------------------------------------------------------------"
			fError.WriteLine ""
'			WriteDebugInfo()
		Else
			fError.WriteLine "**" & Cstr(Time) & ":" & StrString
		End If
		fError.Close
	End If
	
	Set fError = Nothing
	Set FsoError = Nothing
End Function