On Error Resume Next

strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalDisk")

For Each objItem in colItems

	deviceID=objItem.DeviceID
	totalSize=objItem.Size
	freeSpace=objItem.FreeSpace
	usedSpace=totalSize-freeSpace

	if objItem.DriveType = 3 then
		Wscript.Echo "DeviceID=" & deviceID & " TotalSize=" & totalSize & " UsedSpace=" & usedSpace & " FreeSpace=" & freeSpace
	end if
Next

