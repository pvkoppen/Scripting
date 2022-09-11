'Server Details
'==============
hostName="TOLWS01"
portNo="8080"

'********** DO NOT MODIFY ANY CODE BELOW THIS **********
protocol="http"

'Script Mode Details
'===================
isAgentMode=false
agentTaskID="NO_AGENT_TASK_ID"
if(WScript.Arguments.Count>0) Then
	isAgentMode = true
	agentTaskID=WScript.Arguments(0)
end if

'Save Settings File Configuration
'================================
saveXMLFile=false
computerNameForFile="NO_COMPUTER_NAME"

'XML Version/Encoding Information
'================================
xmlVersion="1.0"
xmlEncoding="ISO-8859-1"

strComputer = "."
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

const HKEY_LOCAL_MACHINE = &H80000002
Const HKEY_CURRENT_USER = &H80000001
const doubleQuote=""""
const backSlash="\"
newLineConst = VBCrLf
spaceString = " "
equalString = "=" 
supportMailID="support@assetexplorer.com"

xmlInfoString = "<?xml"
xmlInfoString = addCategoryData(xmlInfoString, "version",xmlVersion)
'xmlInfoString = addCategoryData(xmlInfoString, "encoding",xmlEncoding)
xmlInfoString = xmlInfoString & "?>"

outputText = xmlInfoString & newLineConst
outputText = outputText &  "<DocRoot>"

'Adding Agent Scan Key Info
'==========================
if(isAgentMode) Then
	agentTaskInfo  = "<agentTaskInfo  "
	agentTaskInfo  = addCategoryData(agentTaskInfo, "AgentTaskID",agentTaskID)
	agentTaskInfo  = agentTaskInfo & "/>"
	outputText = outputText & agentTaskInfo 
end if

'Adding Script Information
'=========================
scriptVersion="5000"
scriptVersionInfo = "<scriptVersion "
scriptVersionInfo = addCategoryData(scriptVersionInfo, "Version",scriptVersion)
scriptVersionInfo = scriptVersionInfo & "/>"
outputText = outputText & scriptVersionInfo

'Data Fetching Starts 
'====================
outputText = outputText & "<Hardware_Info>"
dataText = ""

'Compuer System Info
'===================
dataText = "<Computer " 
getDomainName=true

'Get domain name from registry
'------------------------------
On Error Resume Next
Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
domainKeyRoot = "SYSTEM\ControlSet001\Services\Tcpip\parameters\"
objReg.GetStringValue HKEY_LOCAL_MACHINE, domainKeyRoot, "Domain", domainName

if not ISNULL(domainName) then
	if (domainName <> "") then
		getDomainName = false
	end if
end if

query="Select * from Win32_ComputerSystem"
Set queryResult = objWMIService.ExecQuery (query)
For Each iterResult in queryResult
	computerNameForFile = LCase(iterResult.Caption & "")
	dataText = addCategoryData(dataText, "Name", computerNameForFile)
	dataText = addCategoryData(dataText, "Manufacturer", iterResult.Manufacturer)
	dataText = addCategoryData(dataText, "PrimaryOwnerName", iterResult.PrimaryOwnerName)
	dataText = addCategoryData(dataText, "Model", iterResult.Model)
	dataText = addCategoryData(dataText, "UserName", iterResult.UserName)
	dataText = addCategoryData(dataText, "WorkGroup", iterResult.WorkGroup)
	dataText = addCategoryData(dataText, "TotalPhysicalMemory", iterResult.TotalPhysicalMemory)
	if(getDomainName) Then
		domainName = iterResult.Domain & ""
	end if
	dataText = addCategoryData(dataText, "DomainName", domainName)
Next

query="Select * from Win32_BIOS"
Set queryResult = objWMIService.ExecQuery (query)
For Each iterResult in queryResult
	dataText = addCategoryData(dataText, "BiosName", iterResult.Caption)
	dataText = addCategoryData(dataText, "BiosVersion", iterResult.Version)
	dataText = addCategoryData(dataText, "BiosDate", iterResult.ReleaseDate)
	dataText = addCategoryData(dataText, "ServiceTag", iterResult.SerialNumber)
Next

query="select DNSDomain,DNSHostName from Win32_NetworkAdapterConfiguration where DNSDomain!=null AND DNSHostName!=null"
Set queryResult = objWMIService.ExecQuery (query)
For Each iterResult in queryResult
	dnsdomain = iterResult.DNSDomain
	dnshost = iterResult.DNSHostName
Next
dataText = addCategoryData(dataText, "DNSDomain", dnsdomain)
dataText = addCategoryData(dataText, "DNSHostName", dnshost)

query="Select MemoryDevices from Win32_PhysicalMemoryArray where Use=3"
Set queryResult = objWMIService.ExecQuery (query)
memorySlotText=""
For Each iterResult in queryResult
	memorySlotText = addCategoryData(memorySlotText, "MemorySlotsCount", iterResult.MemoryDevices)
Next
dataText = dataText & "  " & memorySlotText

query="Select ChassisTypes from Win32_SystemEnclosure"
Set queryResult = objWMIService.ExecQuery (query)

For Each iterResult in queryResult
	labtopIterator = iterResult.ChassisTypes
	isLaptop=""
	for each laptop in labtopIterator
		isLaptop = laptop
	Next
Next
dataText = addCategoryData(dataText, "isLaptop", isLaptop)
dataText = dataText & "/>"
outputText = outputText & dataText
Err.clear

'Operating System Info
'=====================
On Error Resume Next
	getComputerName=true
	query="select * from Win32_OperatingSystem"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<OperatingSystem " 
	For Each iterResult in queryResult
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "Version", iterResult.Version)
		dataText = addCategoryData(dataText, "BuildNumber", iterResult.BuildNumber)
		dataText = addCategoryData(dataText, "ServicePackMajorVersion", iterResult.ServicePackMajorVersion)
		dataText = addCategoryData(dataText, "ServicePackMinorVersion", iterResult.ServicePackMinorVersion)
		dataText = addCategoryData(dataText, "SerialNumber", iterResult.SerialNumber)
		dataText = addCategoryData(dataText, "TotalVisibleMemorySize", iterResult.TotalVisibleMemorySize)
		dataText = addCategoryData(dataText, "FreePhysicalMemory", iterResult.FreePhysicalMemory)
		dataText = addCategoryData(dataText, "TotalVirtualMemorySize", iterResult.TotalVirtualMemorySize)
		dataText = addCategoryData(dataText, "FreeVirtualMemory", iterResult.FreeVirtualMemory)
	Next
	dataText = dataText & "/>"
	outputText = outputText & dataText
Err.clear

'CPU Info
'========
On Error Resume Next
	query="Select * from Win32_Processor"
	Set queryResult = objWMIService.ExecQuery (query)
	procCount=0
	cpuData = ""
	dataText = "<CPU " 
	For Each iterResult in queryResult
		procCount=procCount+1
		cpuData = ""
		cpuData = addCategoryData(cpuData, "CPUName", iterResult.Name)
		cpuData = addCategoryData(cpuData, "CPUSpeed", iterResult.MaxClockSpeed)
		cpuData = addCategoryData(cpuData, "CPUStepping", iterResult.Stepping)
		cpuData = addCategoryData(cpuData, "CPUManufacturer", iterResult.Manufacturer)
		cpuData = addCategoryData(cpuData, "CPUModel", iterResult.Family)
		cpuData = addCategoryData(cpuData, "CPUSerialNo", iterResult.UniqueId)
	Next
	cpuData = addCategoryData(cpuData, "CPUCount", procCount)
	dataText = dataText & cpuData & "/>"
	outputText = outputText & dataText
Err.clear

'MemoryModule Info
'=================
On Error Resume Next
	query="Select * from Win32_PhysicalMemory"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<MemoryModule>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<MemoryModule_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Tag)
		dataText = addCategoryData(dataText, "Capacity", iterResult.Capacity)
		dataText = addCategoryData(dataText, "BankLabel", iterResult.BankLabel)
		dataText = addCategoryData(dataText, "DeviceLocator", iterResult.DeviceLocator)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</MemoryModule>"
	outputText = outputText & dataText
Err.clear


'HardDisc Info
'=============
On Error Resume Next
	query="Select * from Win32_DiskDrive"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<HardDisk>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<HardDisk_" & count & " " 
		dataText = addCategoryData(dataText, "HDName", iterResult.Caption)
		dataText = addCategoryData(dataText, "HDModel", iterResult.Model)
		dataText = addCategoryData(dataText, "HDSize", iterResult.Size)
		HDSerialNumberId = iterResult.DeviceID
		HDSerialNumberId = Replace(HDSerialNumberId,"\","\\")
		query="Select SerialNumber from  CIM_PhysicalMedia where Tag = " & doubleQuote & HDSerialNumberId & doubleQuote 
		Set queryResultForSN = objWMIService.ExecQuery (query)
		For Each iterResultSN in queryResultForSN
			serialNo = iterResultSN.SerialNumber
			if not ISNULL(serialNo) then
				dataText = addCategoryData(dataText, "HDSerialNumber", serialNo)
			else
				dataText = addCategoryData(dataText, "HDSerialNumber", "HardDiskSerialNumber")
			End if 
		Next
		dataText = addCategoryData(dataText, "HDDescription", iterResult.Description)
		dataText = addCategoryData(dataText, "HDManufacturer", iterResult.Manufacturer)
		dataText = addCategoryData(dataText, "TotalCylinders", iterResult.TotalCylinders)
		dataText = addCategoryData(dataText, "BytesPerSector", iterResult.BytesPerSector)
		dataText = addCategoryData(dataText, "SectorsPerTrack", iterResult.SectorsPerTrack)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</HardDisk>"
	outputText = outputText & dataText
Err.clear

'LogicalDisk Info
'================
On Error Resume Next
	query="Select * from Win32_LogicalDisk"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<LogicDrive>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<LogicDrive_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "Description", iterResult.Description)
		discType = getDiskType(iterResult.DriveType)
		dataText = addCategoryData(dataText, "Type", discType)
		dataText = addCategoryData(dataText, "Size", iterResult.Size)
		dataText = addCategoryData(dataText, "FreeSpace", iterResult.FreeSpace)
		dataText = addCategoryData(dataText, "SerialNumber", iterResult.VolumeSerialNumber)
		dataText = addCategoryData(dataText, "FileSystem", iterResult.FileSystem)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</LogicDrive>"
	outputText = outputText & dataText
Err.clear

'PhysicalDrive Info
'==================
On Error Resume Next
	count=0
	query="Select * from CIM_MediaAccessDevice"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<PhysicalDrive>" 
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<PhysicalDrive_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "Description", iterResult.Description)
		'dataText = addCategoryData(dataText, "Manufacturer", iterResult.Manufacturer)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</PhysicalDrive>"
	outputText = outputText & dataText
Err.clear



'KeyBoard Info
'=============
On Error Resume Next
	query="Select * from Win32_KeyBoard"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = ""
	For Each iterResult in queryResult
		dataText = dataText & "<KeyBoard " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = dataText & "/>"
	Next
	outputText = outputText & dataText
Err.clear

'Mouse Info
'===========
On Error Resume Next
	query="Select * from Win32_PointingDevice"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = ""
	For Each iterResult in queryResult
		dataText = dataText & "<Mouse " 
		dataText = addCategoryData(dataText, "Name", iterResult.Name)
		dataText = addCategoryData(dataText, "ButtonsCount", iterResult.NumberOfButtons)
		dataText = addCategoryData(dataText, "Manufacturer", iterResult.Manufacturer)
		dataText = dataText & "/>"
	Next
	outputText = outputText & dataText
Err.clear


'Monitor Info
'============
Dim sMultiStrings() 
On Error Resume Next
	query="Select * from Win32_DesktopMonitor where PNPDeviceID != NULL"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = ""
	For Each iterResult in queryResult
		dataText = dataText & "<Monitor " 
		dataText = addCategoryData(dataText, "Name", iterResult.Name)
		dataText = addCategoryData(dataText, "DisplayType", iterResult.DisplayType)
		dataText = addCategoryData(dataText, "MonitorType", iterResult.MonitorType)
		dataText = addCategoryData(dataText, "Manufacturer", iterResult.MonitorManufacturer)
		dataText = addCategoryData(dataText, "Height", iterResult.ScreenHeight)
		dataText = addCategoryData(dataText, "Width", iterResult.ScreenWidth)
		dataText = addCategoryData(dataText, "XPixels", iterResult.PixelsPerXLogicalInch)
		dataText = addCategoryData(dataText, "YPixels", iterResult.PixelsPerYLogicalInch)
		'Getting monitor serial number from registry.
		pnpDeviceId = iterResult.PNPDeviceID 
		subKey = "SYSTEM\CurrentControlSet\Enum\" & pnpDeviceId & "\Device Parameters"
		objReg.GetBinaryValue HKEY_LOCAL_MACHINE, subKey, "EDID", EDID
		serialNumber = GetMonitorSerialNumber(EDID)
		dataText = addCategoryData(dataText, "SerialNumber", serialNumber)
		dataText = dataText & "/>"
	Next
	outputText = outputText & dataText
Err.clear

'Network Info
'=============
On Error Resume Next
	query="Select * from Win32_NetworkAdapterConfiguration where IPEnabled = True"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<Network>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<Network_" & count & " " 
		'To Remove the NIC Index from the NIC Caption
		nwCaption = getNetworkCaption(iterResult.Caption)
		dataText = addCategoryData(dataText, "Name", nwCaption)
		dataText = addCategoryData(dataText, "Index", iterResult.Index)
		dataText = addCategoryData(dataText, "MACAddress", iterResult.MACAddress)
		dataText = addCategoryData(dataText, "DNSDomain", iterResult.DNSDomain)
		dataText = addCategoryData(dataText, "DNSHostName", iterResult.DNSHostName)
		dataText = addCategoryData(dataText, "DHCPEnabled", iterResult.DHCPEnabled)
		dataText = addCategoryData(dataText, "DHCPLeaseObtained", iterResult.DHCPLeaseObtained)
		dataText = addCategoryData(dataText, "DHCPLeaseExpires", iterResult.DHCPLeaseExpires)
		dataText = addCategoryData(dataText, "DHCPServer", iterResult.DHCPServer)
		ipIterator = iterResult.IPAddress
		ipAddress=""
		for each ipaddr in ipIterator
			if (ipAddress <> "") then
				ipAddress = ipAddress & "-" & ipaddr
			else
				ipAddress = ipaddr
			end if
		Next
		dataText = addCategoryData(dataText, "IpAddress", ipAddress)
		ipIterator = iterResult.DefaultIPGateway
		ipAddress=""
		for each ipaddr in ipIterator
			if (ipAddress <> "") then
				ipAddress = ipAddress & "-" & ipaddr
			else
				ipAddress = ipaddr
			end if
		Next
		dataText = addCategoryData(dataText, "Gateway", ipAddress)
		ipIterator = iterResult.DNSServerSearchOrder
		ipAddress=""
		for each ipaddr in ipIterator
			if (ipAddress <> "") then
				ipAddress = ipAddress & "-" & ipaddr
			else
				ipAddress = ipaddr
			end if
		Next
		dataText = addCategoryData(dataText, "DnsServer", ipAddress)
		ipIterator = iterResult.IPSubnet
		ipAddress=""
		for each ipaddr in ipIterator
			if (ipAddress <> "") then
				ipAddress = ipAddress & "-" & ipaddr
			else
				ipAddress = ipaddr
			end if
		Next
		dataText = addCategoryData(dataText, "Subnet", ipAddress)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</Network>"
	outputText = outputText & dataText
Err.clear

'SoundCard Info
'============
On Error Resume Next
	query="Select * from Win32_SoundDevice"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = ""
	For Each iterResult in queryResult
		dataText = dataText & "<SoundCard " 
		dataText = addCategoryData(dataText, "SoundCardName", iterResult.Caption)
		dataText = addCategoryData(dataText, "SoundCardManufacturer", iterResult.Manufacturer)
		dataText = dataText & "/>"
	Next
	outputText = outputText & dataText
Err.clear

'VideoCard Info
'==================
On Error Resume Next
	query="Select * from Win32_VideoController where Availability!=8"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<VideoCard>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<VideoCard_" & count & " " 
		dataText = addCategoryData(dataText, "VideoCardName", iterResult.Caption)
		dataText = addCategoryData(dataText, "VideoCardChipset", iterResult.VideoProcessor)
		dataText = addCategoryData(dataText, "VideoCardMemory", iterResult.AdapterRAM)
		dataText = dataText & "/>"
	Next

	dataText = dataText & "</VideoCard>"
	outputText = outputText & dataText
Err.clear

'SerialPort Info
'==================
On Error Resume Next
	query="Select * from Win32_SerialPort"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<SerialPort>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<SerialPort_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "BaudRate", iterResult.MaxBaudRate)
		dataText = addCategoryData(dataText, "Status", iterResult.Status)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</SerialPort>"
	outputText = outputText & dataText
Err.clear

'ParallelPort Info
'==================
On Error Resume Next
	query="Select * from Win32_ParallelPort"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<ParallelPort>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<ParallelPort_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "Status", iterResult.Status)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</ParallelPort>"
	outputText = outputText & dataText
Err.clear

'USB Info
'========
On Error Resume Next
	query="Select * from Win32_USBController"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<USB>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<USB_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "Manufacturer", iterResult.Manufacturer)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</USB>"
	outputText = outputText & dataText
Err.clear



'Printer Info
'=================
On Error Resume Next
	query="Select * from Win32_Printer"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<Printer>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		On Error Resume Next
		dataText = dataText & "<Printer_" & count & " " 
		dataText = addCategoryData(dataText, "Name", iterResult.Caption)
		dataText = addCategoryData(dataText, "Model", iterResult.DriverName)
		dataText = addCategoryData(dataText, "Default", iterResult.Default)
		dataText = addCategoryData(dataText, "Network", iterResult.Network)
		dataText = addCategoryData(dataText, "Local", iterResult.Local)
		dataText = addCategoryData(dataText, "PortName", iterResult.PortName)
		dataText = addCategoryData(dataText, "Location", iterResult.Location)
		dataText = addCategoryData(dataText, "Comment", iterResult.Comment)
		dataText = addCategoryData(dataText, "ServerName", iterResult.ServerName)
		Err.clear
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</Printer>"
	outputText = outputText & dataText
Err.clear

'HotFix Info
'===========
On Error Resume Next
	query="Select * from Win32_QuickFixEngineering where FixComments!=''"
	Set queryResult = objWMIService.ExecQuery (query)
	dataText = "<HotFix>" 
	count=0
	For Each iterResult in queryResult
		count=count+1
		dataText = dataText & "<HotFix_" & count & " " 
		dataText = addCategoryData(dataText, "HotFixID", iterResult.HotFixID)
		dataText = addCategoryData(dataText, "InstalledBy", iterResult.InstalledBy)
		dataText = addCategoryData(dataText, "InstalledOn", iterResult.InstalledOn)
		dataText = addCategoryData(dataText, "Description", iterResult.Description)
		dataText = dataText & "/>"
	Next
	dataText = dataText & "</HotFix>"
	outputText = outputText & dataText
Err.clear


outputText = outputText & "</Hardware_Info>"


'SoftwareList Info
'=================
On Error Resume Next
softwareDataText="<Software_Info>"
softwareDataText = softwareDataText & "<InstalledProgramsList>"
strComputer = "."

Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
strKeyPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
objReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
count=0
If NOT ISNULL(arrSubKeys) then
	For Each subkey In arrSubKeys
		subkeyPath = strKeyPath & "\" & subkey
		objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "DisplayName", softwareName
		objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "DisplayVersion", softwareVersion
		objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "Publisher", softwarePublisher
		objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "InstallLocation", softwareLocation
		objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "InstallDate", softwareInstallDate
		keyForSoftwareUsage = "SOFTWARE\Microsoft\Windows\CurrentVersion\App Management\ARPCache\" & subkey
		objReg.GetBinaryValue HKEY_LOCAL_MACHINE, keyForSoftwareUsage, "SlowInfoCache", usageData
		swUsage = getSoftwareUsage(usageData)
		If NOT ISNULL(softwareName) then
			if(softwareName <> "") then
			count=count+1
			softwareDataText = softwareDataText & "<Software_" & count & " "
			softwareDataText = addCategoryData(softwareDataText, "Name", softwareName)
			softwareDataText = addCategoryData(softwareDataText, "Version", softwareVersion)
			softwareDataText = addCategoryData(softwareDataText, "Vendor", softwarePublisher)
			softwareDataText = addCategoryData(softwareDataText, "Location", softwareLocation)
			softwareDataText = addCategoryData(softwareDataText, "InstallDate", softwareInstallDate)
			softwareDataText = addCategoryData(softwareDataText, "Usage", swUsage)
			softwareDataText = addCategoryData(softwareDataText, "Key", subkey)
			softwareDataText = softwareDataText &  "/>"
			end if
		end if
	Next
end if
Err.clear

'Softwares installed for current user only
'==========================================
On Error Resume Next
objReg.EnumKey HKEY_CURRENT_USER, strKeyPath, arrSubKeys

If NOT ISNULL(arrSubKeys) then
	For Each subkey In arrSubKeys
		subkeyPath = strKeyPath & "\" & subkey
		objReg.GetStringValue HKEY_CURRENT_USER, subkeyPath, "DisplayName", softwareName
		objReg.GetStringValue HKEY_CURRENT_USER, subkeyPath, "DisplayVersion", softwareVersion
		objReg.GetStringValue HKEY_CURRENT_USER, subkeyPath, "Publisher", softwarePublisher
		objReg.GetStringValue HKEY_CURRENT_USER, subkeyPath, "InstallLocation", softwareLocation
		objReg.GetStringValue HKEY_CURRENT_USER, subkeyPath, "InstallDate", softwareInstallDate
		keyForSoftwareUsage = "SOFTWARE\Microsoft\Windows\CurrentVersion\App Management\ARPCache\" & subkey
		objReg.GetBinaryValue HKEY_CURRENT_USER, keyForSoftwareUsage, "SlowInfoCache", usageData
		swUsage = getSoftwareUsage(usageData)
		If NOT ISNULL(softwareName) then
			if(softwareName <> "") then
			count=count+1
			softwareDataText = softwareDataText & "<Software_" & count & " "
			softwareDataText = addCategoryData(softwareDataText, "Name", softwareName)
			softwareDataText = addCategoryData(softwareDataText, "Version", softwareVersion)
			softwareDataText = addCategoryData(softwareDataText, "Vendor", softwarePublisher)
			softwareDataText = addCategoryData(softwareDataText, "Location", softwareLocation)
			softwareDataText = addCategoryData(softwareDataText, "InstallDate", softwareInstallDate)
			softwareDataText = addCategoryData(softwareDataText, "Usage", swUsage)
			softwareDataText = addCategoryData(softwareDataText, "Key", subkey)
			softwareDataText = softwareDataText &  "/>"
			end if
		end if
	Next
end if
softwareDataText = softwareDataText & "</InstalledProgramsList>"
Err.clear
'Microsoft Keys
'=================
On Error Resume Next
softwareDataText = softwareDataText & "<MicrosoftOfficeKeys>"
strKeyPath = "SOFTWARE\Microsoft\Office"
objReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys
count=0
If NOT ISNULL(arrSubKeys) then
	For Each subkey In arrSubKeys
		subkeyPath = strKeyPath & "\" & subkey & "\Registration" 
		objReg.EnumKey HKEY_LOCAL_MACHINE, subkeyPath, productSubKeys
		If NOT ISNULL(productSubKeys) then
			For Each productsubkey In productSubKeys
				count=count+1
				softwareDataText = softwareDataText & "<Key_" & count & " "
				softwareDataText = addCategoryData(softwareDataText, "Key", productsubkey)
				productsubkeyPath = subkeyPath & "\" &  productsubkey
				objReg.GetStringValue HKEY_LOCAL_MACHINE, productsubkeyPath, "ProductID", productId
				objReg.GetBinaryValue HKEY_LOCAL_MACHINE, productsubkeyPath, "DigitalProductID", productKey
				if NOT ISNULL(productId) then
					softwareDataText = addCategoryData(softwareDataText, "ProductID", productId)
				end if
				if NOT ISNULL(productKey) then
					key = getLicenceKey(productKey)
					softwareDataText = addCategoryData(softwareDataText, "ProductKey", key)
				end if
				softwareDataText = softwareDataText &  " />"
			Next
		end if	
	Next
end if
softwareDataText = softwareDataText & "</MicrosoftOfficeKeys>"
Err.clear
'Windows Key
'===========
On Error Resume Next
softwareDataText = softwareDataText & "<WindowsKey " 
windowsKeyRoot = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\"
objReg.GetStringValue HKEY_LOCAL_MACHINE, windowsKeyRoot, "ProductID", windowsId
if not ISNULL(windowsId) then
	softwareDataText = addCategoryData(softwareDataText, "ProductID", windowsId)
end if
objReg.GetBinaryValue HKEY_LOCAL_MACHINE, windowsKeyRoot, "DigitalProductID", windowsKeyData
if not ISNULL(windowsKeyData)then
	windowsKey = getLicenceKey(windowsKeyData)
	softwareDataText = addCategoryData(softwareDataText, "DigitalProductID", windowsKey)
end if
softwareDataText = softwareDataText & "/>"
Err.clear
'Oracle Info
'===========
On Error Resume Next
softwareDataText = softwareDataText & "<OracleInfo>" 
oracleKeyRoot = "SOFTWARE\ORACLE"
objReg.EnumKey HKEY_LOCAL_MACHINE, oracleKeyRoot, arrSubKeys
count=0
If NOT ISNULL(arrSubKeys) then
	For Each subkey In arrSubKeys
		if(Left(subkey,4)="HOME" Or Left(subkey,7)="KEY_Ora") then
			
			subkeyPath = oracleKeyRoot & "\" & subkey
			objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "SQLPATH", sqlPath
			objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "ORACLE_GROUP_NAME", groupName
			objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "ORACLE_HOME_NAME", homeName
			objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "ORACLE_BUNDLE_NAME", bundleName
			objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "VERSION", version
			objReg.GetStringValue HKEY_LOCAL_MACHINE, subkeyPath, "ORACLE_HOME", home
			count=count+1
			softwareDataText = softwareDataText & "<Software_" & count & " "
			softwareDataText = addCategoryData(softwareDataText, "sqlPath", sqlPath)
			softwareDataText = addCategoryData(softwareDataText, "groupName", groupName)
			softwareDataText = addCategoryData(softwareDataText, "homeName", homeName)
			softwareDataText = addCategoryData(softwareDataText, "bundleName", bundleName)
			softwareDataText = addCategoryData(softwareDataText, "version", version)
			softwareDataText = addCategoryData(softwareDataText, "home", home)
			softwareDataText = addCategoryData(softwareDataText, "Key", subkey)
			softwareDataText = softwareDataText &  "/>"
		end if
	Next
end if
softwareDataText = softwareDataText & "</OracleInfo>"


softwareDataText = softwareDataText & "</Software_Info>"
outputText = outputText  & softwareDataText
outputText = outputText  & "</DocRoot>"
Err.clear
'Converting Data to XML
'======================
set xml = CreateObject("Microsoft.xmldom")
xml.async = false
loadResult = xml.loadxml(outputText)

On Error Resume Next

'Sending Data via http
'=====================
if(isAgentMode) Then
	saveXMLFile=true
	computerNameForFile=agentTaskID
else
	urlStr = protocol & "://" & hostName & ":" & portNo & "/discoveryServlet/WsDiscoveryServlet"
	set http = createobject("microsoft.xmlhttp")
	http.open "post",urlStr,false
	http.send xml
end if

if Err Then
	handleError(Err)
	saveXMLFile=true	
end if

'Saving XML File
'===============
if(saveXMLFile=true) then
	'Saving the Inventory Data as XML File - will be useful to troubleshoot the Error
	fileName = ".\" & computerNameForFile  & ".xml"
	xml.save fileName
end if

'To Add Data
'===========
Function addCategoryData(outputText, category, data)
	'For handling problem when data contains &
	pos=InStr(data,"&")
	if pos>0 Then
		data = Replace(data,"&","###AND###")
	end if
	'For handling problem when data contains <
	pos=InStr(data,"<")
	if pos>0 Then
		data = Replace(data,"<","###[###")
	end if
	'For handling problem when data contains >
	pos=InStr(data,">")
	if pos>0 Then
		
		data = Replace(data,">","###]###")
		
	end if
	'For handling problem when data contains DOUBLEQUOTE
	pos=InStr(data,doubleQuote)
	if pos>0 Then
		data = Replace(data,doubleQuote,"###DQ###")
	end if
	data = removeInvalidXMLChar(data)
	retStr = outputText 
	if NOT ISNULL(data) then
		retStr = retStr & spaceString 
		retStr = retStr & category 
		retStr = retStr & equalString 
		retStr = retStr & doubleQuote 
		retStr = retStr &  Trim(data) 
		retStr = retStr & doubleQuote
	end if
	addCategoryData=retStr
End Function

'To get the licence Key
'======================
Public Function getLicenceKey(bDigitalProductID)
    Dim bProductKey()
    Dim bKeyChars(24)
    Dim ilByte
    Dim nCur
    Dim sCDKey
    Dim ilKeyByte
    Dim ilBit
    ReDim Preserve bProductKey(14)
    Set objShell = CreateObject("WScript.Shell")
    Set objShell = Nothing
    For ilByte = 52 To 66
      bProductKey(ilByte - 52) = bDigitalProductID(ilByte)
    Next
    bKeyChars(0) = Asc("B")
    bKeyChars(1) = Asc("C")
    bKeyChars(2) = Asc("D")
    bKeyChars(3) = Asc("F")
    bKeyChars(4) = Asc("G")
    bKeyChars(5) = Asc("H")
    bKeyChars(6) = Asc("J")
    bKeyChars(7) = Asc("K")
    bKeyChars(8) = Asc("M")
    bKeyChars(9) = Asc("P")
    bKeyChars(10) = Asc("Q")
    bKeyChars(11) = Asc("R")
    bKeyChars(12) = Asc("T")
    bKeyChars(13) = Asc("V")
    bKeyChars(14) = Asc("W")
    bKeyChars(15) = Asc("X")
    bKeyChars(16) = Asc("Y")
    bKeyChars(17) = Asc("2")
    bKeyChars(18) = Asc("3")
    bKeyChars(19) = Asc("4")
    bKeyChars(20) = Asc("6")
    bKeyChars(21) = Asc("7")
    bKeyChars(22) = Asc("8")
    bKeyChars(23) = Asc("9")
    For ilByte = 24 To 0 Step -1
      nCur = 0
      For ilKeyByte = 14 To 0 Step -1
        nCur = nCur * 256 Xor bProductKey(ilKeyByte)
        bProductKey(ilKeyByte) = Int(nCur / 24)
        nCur = nCur Mod 24
      Next
      sCDKey = Chr(bKeyChars(nCur)) & sCDKey
      If ilByte Mod 5 = 0 And ilByte <> 0 Then sCDKey = "-" & sCDKey
    Next
    getLicenceKey = sCDKey
End Function


'To get Software usage
'=====================
Function getSoftwareUsage(softwareUsageData)
	getSoftwareUsage = "Not Known" 
	if not ISNULL(softwareUsageData) then
		usageLevel = CLng(softwareUsageData(24))
		if(usageLevel<3) then
			getSoftwareUsage = "Rarely" 
		elseif (usageLevel<9) then
			getSoftwareUsage = "Occasionally" 
		elseif (usageLevel<>255) then
			getSoftwareUsage = "Frequently" 
		end if
	end if
End Function


'To get the Logical Disk Type
'============================
Function getDiskType(diskType)
	getDiskType="Unknown"
	if(diskType="1") then
		getDiskType="No Root Directory"
	elseif (diskType="2") then
		getDiskType="Removable Disk"
	elseif (diskType="3") then
		getDiskType="Local Disk"
	elseif (diskType="4") then
		getDiskType="Network Drive"
	elseif (diskType="5") then
		getDiskType="Compact Disc"
	elseif (diskType="6") then
		getDiskType="RAM Disk"
	end if
End Function


'To Remove the Index in Network Caption
'======================================
Function getNetworkCaption(captionString)
	getNetworkCaption = captionString
	idx = InStr(captionString," ")
	If(idx>0) Then
		getNetworkCaption = Trim(Mid(captionString,idx))
	End If
End Function

'To Get Monitor Serial number
'============================

Function GetMonitorSerialNumber(EDID)
	
	sernumstr=""
	sernum=0
	for i=0 to ubound(EDID)-4
		if EDID(i)=0 AND EDID(i+1)=0 AND EDID(i+2)=0 AND EDID(i+3)=255 AND EDID(i+4)=0 Then
			' if sernum<>0 then
				'sMsgString = "a second serial number has been found!"
				'WScript.ECho sMsgString
				'suspicious=1
			'end if
			sernum=i+4
		end if
	next
	if sernum<>0 then
		endstr=0
		sernumstr=""
		for i=1 to 13
			if EDID(sernum+i)=10 then 
    			endstr=1
			end if
			if endstr=0 then
				sernumstr=sernumstr & chr(EDID(sernum+i))
			end if

		next
		'sMsgString = "Monitor serial number: " & sernumstr
		'WScript.Echo sMsgString
	else
	sernumstr="-"
	'sMsgString = "No monitor serial number found. Possibly the computer is a laptop."
	'WScript.Echo sMsgString
	end if
	GetMonitorSerialNumber = sernumstr

End Function

'To Handle Error
'===============
Function handleError(Err)
	if Err Then
		displayErrorMessage = getErrorMessage(Err)
		'Wscript.Echo displayErrorMessage 	
		Err.clear
	end if
End Function


'To Get the Error Message for Given Error Code
'=============================================
Function getErrorMessage(Err)
	hexErrorCode = "0x" & hex(Err.Number)
	errorMessage = newLineConst & newLineConst
	errorMessage = errorMessage & "Exception occured while running the Script. (ManageEngine AssetExplorer)"
	errorMessage = errorMessage & newLineConst
	errorMessage = errorMessage & newLineConst & newLineConst

	if(hexErrorCode="0x800C0005") Then
		resolution = "The AssetExplorer server is not reachable from this machine.Check the server name and port number in the script."
	elseif(hexErrorCode="0x80004005") Then
		resolution = "The AssetExplorer server is not reachable from this machine.Check the server name and port number in the script."
	elseif(hexErrorCode="0x80070005") Then
		resolution = "The AssetExplorer server is not reachable from this machine.Check the server name and port number in the script."
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

'Ref : http://www.w3.org/TR/2000/REC-xml-20001006#NT-Char

Function removeInvalidXMLChar(xmldata)
	
	Dim strLen
	Dim isValidChar
	Dim current
	Dim retdata

	retdata = xmldata
	strLen = len(xmldata)
	for i=1 to strLen
		current = AscW(Mid(xmldata,i,1))
		isValidChar = false
		isValidChar = isValidChar or CBool(current = HexToDec("9"))
		isValidChar = isValidChar or CBool(current = HexToDec("A"))
		isValidChar = isValidChar or CBool(current = HexToDec("D"))
		isValidChar = isValidChar or (CBool(current >= HexToDec("20")) and CBool(current <= HexToDec("D7FF")))
		isValidChar = isValidChar or (CBool(current >= HexToDec("E000")) and CBool(current <= HexToDec("FFFD")))
		isValidChar = isValidChar or (CBool(current >= HexToDec("10000")) and CBool(current <= HexToDec("10FFFF")))
		if(Not isValidChar) then
			retdata = Replace(retdata,chr(current),"")
		End if
	Next
	removeInvalidXMLChar = retdata
End Function

'Hex to decimal
Function HexToDec(hexVal)

	dim dec
	dim strLen
  	dim digit
  	dim intValue
	dim i

	dec = 0
	strLen = len(hexVal)
	for i =  strLen to 1 step -1
 
		digit = instr("0123456789ABCDEF", ucase(mid(hexVal, i, 1)))-1
		if digit >= 0 then
        		intValue = digit * (16 ^ (len(hexVal)-i))
	  		dec = dec + intValue
		else 
 	  		dec = 0
		        i = 0 	'exit for
		end if
	next

  HexToDec = dec
End Function

'
'Version Info
'$Id: ae_scan.vbs,v 1.12.2.1 2009/04/07 13:37:52 balaguru Exp $

