On Error Resume Next

strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalDisk")

For Each objItem in colItems

	deviceID=objItem.DeviceID
	totalSize=objItem.Size
	freeSpace=objItem.FreeSpace
	usedSpace=totalSize-freeSpace
	deviceType=objItem.DriveType 

	' Wscript.Echo "DeviceID=" & deviceID & "(" & deviceType & ")" & " TotalSize=" & totalSize & " UsedSpace=" & usedSpace & " FreeSpace=" & freeSpace

	if deviceType = 3 then
		Wscript.Echo "DeviceID=" & deviceID & "(harddisk)" & " TotalSize=" & totalSize & " UsedSpace=" & usedSpace & " FreeSpace=" & freeSpace
	elseif deviceType = 4 then
		Wscript.Echo "DeviceID=" & deviceID & "(network)" & " TotalSize=" & totalSize & " UsedSpace=" & usedSpace & " FreeSpace=" & freeSpace
	elseif deviceType = 2 then
		Wscript.Echo "DeviceID=" & deviceID & "(removable)" & " TotalSize=" & totalSize & " UsedSpace=" & usedSpace & " FreeSpace=" & freeSpace
	else
		Wscript.Echo "DeviceID=" & deviceID & "(unknown)" & " TotalSize=" & totalSize & " UsedSpace=" & usedSpace & " FreeSpace=" & freeSpace
	end if
Next

