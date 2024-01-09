On Error Resume Next

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colNetAdapters = objWMIService.ExecQuery _
    ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")
 
For Each objNetAdapter In colNetAdapters 
    Adaptertype = objNetAdapter.AdapterTypeId
    Status = objNetAdapter.NetConnectionStatus
    Descr  = objNetAdapter.Description
    WScript.Echo "---- IPEnabled ----"&vbCrlf&"TypeID:"&AdapterType&vbCrlf&"Status:"&Status&vbCrlf&"Descr:"&Descr
Next

Set colNetAdapters = objWMIService.ExecQuery _
    ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=False")
 
For Each objNetAdapter in colNetAdapters
    Adaptertype = objNetAdapter.AdapterTypeId
    Status = objNetAdapter.NetConnectionStatus
    Descr  = objNetAdapter.Description
    WScript.Echo "---- IPDisabled ----"&vbCrlf&"TypeID:"&AdapterType&vbCrlf&"Status:"&Status&vbCrlf&"Descr:"&Descr
Next

WScript.Quit
