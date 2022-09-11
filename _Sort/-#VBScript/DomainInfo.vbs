
Set objSysInfo = CreateObject("ADSystemInfo")
objSysInfo.RefreshSchemaCache
WScript.Echo "User name: " & objSysInfo.UserName
WScript.Echo "Computer name: " & objSysInfo.ComputerName
WScript.Echo "Site name: " & objSysInfo.SiteName
WScript.Echo "Domain short name: " & objSysInfo.DomainShortName
WScript.Echo "Domain DNS name: " & objSysInfo.DomainDNSName
WScript.Echo "Forest DNS name: " & objSysInfo.ForestDNSName
WScript.Echo "PDC role owner: " & objSysInfo.PDCRoleOwner
WScript.Echo "Schema role owner: " & objSysInfo.SchemaRoleOwner
WScript.Echo "Domain is in native mode: " & objSysInfo.IsNativeMode
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
WScript.Echo "Active Directory DomainController: " & objSysInfo.GetAnyDCName
For Each tree In objSysInfo.GetTrees
 WScript.Echo "Domain trees: " & tree
Next