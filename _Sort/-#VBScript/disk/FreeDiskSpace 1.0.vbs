'****************************************************************************
' This script created by Chrissy LeMaire (clemaire@gmail.com)
' Website: http://netnerds.net/
'
' NO WARRANTIES, etc.
'
' This script checks hard drives for less than 1GB of space.
'
' Requirements -- ability to read WinNT://, create events and read WMI
'
' This script has only been tested on Windows Server 2003.
'
' "What it does"
' 1. Gets a list of computers on a domain
' 2. Checks for disk space
' 3. If disk space < 1 GB, add to Event Viewer but not more than once a day.
'*****************************************************************************

On Error Resume Next 'Ignore errors

Set objAdRootDSE = GetObject("LDAP://RootDSE")
Set objRS = CreateObject("adodb.recordset")

  varConfigNC = objAdRootDSE.Get("defaultNamingContext")
  strConnstring = "Provider=ADsDSOObject"
  strWQL = "SELECT * FROM 'LDAP://" & varConfigNC & "' WHERE objectCategory= 'Computer' and OperatingSystem = 'Windows*Server*'"
  objRS.Open strWQL, strConnstring
    Do until objRS.eof
       Set objServer = GetObject(objRS.Fields.Item(0))
       strServerName = objServer.CN
       Call GetDiskSpaceAddEvent(strServerName)
       objRS.movenext
    Loop
    Set objServer = Nothing
  objRS.close

Set objRS = Nothing
Set objAdRootDSE = Nothing

'-----------------------------------------------------------------------
'
'    Do the Dirty Work
'
'-----------------------------------------------------------------------

Sub GetDiskSpaceAddEvent(strComputer)

  WScript.Echo "Processing server: " & strComputer
  Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
    Set colItems = objWMIService.ExecQuery  ("Select DeviceID, Size, FreeSpace from Win32_LogicalDisk where DriveType = 3") 'Grab the name and the free space for fixed drives
    For Each objItem in colItems
      WScript.Echo " - Checking Device: " & objItem.DeviceID
      PercentFree = formatnumber(((objItem.FreeSpace/objItem.Size)*100),2)
      WScript.Echo " - Percent Free: " & PercentFree
      If PercentFree <= 10 Then 'Convert to MB then check for < 1GB
        runThis =  "%COMSPEC% /c eventcreate /s " & strComputer & " /so ""Low Disk Space"" /T Error /ID 1000 /L System /D ""The size of disk " & objItem.DeviceID & " on " & StrComputer & " has dropped below 10% (" & PercentFree & " % free)."""
        WScript.echo runThis
        WindowStyle = 0 'Do not pop up a dos box
        Set WshShell = WScript.CreateObject("WScript.Shell") 'generate the object
        'Call WshShell.Run (runThis, WindowStyle, false) 'execute the dos command listed above (COMSPEC = cmd.exe)
        Set WshShell = Nothing
      End If
    Next
    Set colItems = Nothing
  Set objWMIService = Nothing

End Sub

