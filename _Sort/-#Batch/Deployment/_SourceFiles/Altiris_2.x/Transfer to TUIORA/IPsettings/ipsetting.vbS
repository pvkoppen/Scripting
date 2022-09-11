strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colNetAdapters = objWMIService.ExecQuery _
    ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")

strIPAddress = Array("192.203.88.50")
strSubnetMask = Array("255.255.255.0")
strGateway = Array("192.203.88.5")
strGatewayMetric = Array(1)
 
For Each objNetAdapter in colNetAdapters
    errEnable = objNetAdapter.EnableStatic(strIPAddress, strSubnetMask)
    errGateways = objNetAdapter.SetGateways(strGateway, strGatewaymetric)
    If errEnable = 0 Then
        WScript.Echo "The IP address has been changed."
    Else
        WScript.Echo "The IP address could not be changed."
    End If
Next


On Error Resume Next

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colNetCards = objWMIService.ExecQuery _
    ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")

For Each objNetCard in colNetCards
    Wscript.Echo objNetCard.SetDNSDomain("iwayonline")
Next

On Error Resume Next
 
Const FULL_DNS_REGISTRATION = True
Const DOMAIN_DNS_REGISTRATION = False
 
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colNetCards = objWMIService.ExecQuery _
    ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")

For Each objNetCard in colNetCards
    objNetCard.SetDynamicDNSRegistration FULL_DNS_REGISTRATION, _
        DOMAIN_DNS_REGISTRATION
Next

On Error Resume Next

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colNetCards = objWMIService.ExecQuery _
    ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")

For Each objNetCard in colNetCards
    arrDNSServers = Array("192.203.88.23", "192.203.88.24")
    objNetCard.SetDNSServerSearchOrder(arrDNSServers)
Next

