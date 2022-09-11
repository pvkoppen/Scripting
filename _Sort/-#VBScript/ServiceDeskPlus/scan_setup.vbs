'Script to Configure Scan Settings for ManageEngine AssetExplorer
'===================================================================================================


'WARNING:
'********
'	This script Edits Windows Registry to configure the Settings required for scanning through WMI
'	It is highly recomended to test the script in a Test Computer before rolling it across a Network




'Section 1: To Configure Basic Remote DCOM Settings
'==================================================
'	a. ENABLE Remote DCOM 
'	b. DCOM Authentication Level set as DEFAULT
'	c. DCOM Impersonation Level as IMPERSONATE	
enableDCOMandRPC()
Private Sub enableDCOMandRPC()	supportMailID="support@assetexplorer.com"
	Set WSHShell = WScript.CreateObject("WScript.Shell")
	'To Enable Remote DCOM in the computer	On Error Resume Next
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Ole\EnableDCOM","Y","REG_SZ"
	if Err Then
		WScript.Echo getErrorMessage(Err)
		Exit sub
	end if
	'To Enable Remote DCOM via HTTP in the computer
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Ole\EnableDCOMHTTP","Y","REG_SZ"	if Err Then
		WScript.Echo getErrorMessage(Err)
		Exit sub
	end if

	'To Set Authentication Leval as Default
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Ole\LegacyAuthenticationLevel",0,"REG_DWORD"	if Err Then
		WScript.Echo getErrorMessage(Err)
		Exit sub
	end if

	'To Set Impersonation level as Impersonate
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Ole\LegacyImpersonationLevel",3,"REG_DWORD"	if Err Then
		WScript.Echo getErrorMessage(Err)
		Exit sub
	end if



	'Section 2: To Configure Windows XP (SP2) Settings
	'=================================================
	'	a. DISABLE Simple File Sharing 
	'	b. ENABLE RemoteAdmin in Firewall for Standard and Current Profile
	'	   (RemoteAdmin will take care of Ports required by WMI for scanning)


	'To Configure Windows XP
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

	Set colServiceList = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
	For Each objService in colServiceList
		osName = objService.Caption
	Next

	Set colServiceList = objWMIService.ExecQuery("Select * from Win32_Service where Name = 'SharedAccess'")
	For Each objService in colServiceList
		State=objService.State
	Next

	'To configure only for Windows XP Workstations
	if osName="Microsoft Windows XP Professional" Then

		'To Disable Simple File Sharing Security
		WshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\forceguest",0,"REG_DWORD"		if Err Then
			WScript.Echo getErrorMessage(Err)
			Exit sub
		end if

		if State="Running" Then
				'To Enable Remote Admin in Firewall
				Set objFirewall = CreateObject("HNetCfg.FwMgr")

			'For Current Profile
				Set objPolicy = objFirewall.LocalPolicy.CurrentProfile
				Set objAdminSettings = objPolicy.RemoteAdminSettings
				objAdminSettings.Enabled = TRUE
			 
			'For Standard Profile
				set objPolicyStdProfile = objFirewall.LocalPolicy.GetProfileByType(1)
				Set objAdminSettingsStdProfile = objPolicy.RemoteAdminSettings
				objAdminSettingsStdProfile.Enabled = TRUE
		end If
	end If	End sub
'To Get the Error Message for Given Error Code
'=============================================
Function getErrorMessage(Err)
	hexErrorCode = "0x" & hex(Err.Number)
	errorMessage = newLineConst & newLineConst
	errorMessage = errorMessage & "Exception occured while running the Script. (ManageEngine AssetExplorer)"
	errorMessage = errorMessage & newLineConst
	errorMessage = errorMessage & newLineConst & newLineConst

	if(hexErrorCode="0x80070005") Then
		resolution = "The User does not have relevant permission.Run this script under administrator Rights."
	else
		errorMessage = errorMessage & "Error Code : 0x" & hex(Err.Number)
		errorMessage = errorMessage & newLineConst
		errorMessage = errorMessage & "Error Desc : " & Err.description
		errorMessage = errorMessage & newLineConst
		resolution = "For resolution please report the above Error Message to " & supportMailID
	end if

	errorMessage = errorMessage & resolution
	errorMessage = errorMessage & newLineConst
	getErrorMessage = errorMessage
End Function



