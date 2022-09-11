' Activity      : Set IP address for: TOLMM01
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-10-20
' Date Updated  : 2007-06-19
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

' Set Initial Script Options
' -----------------------------------------------------------------
'Option Explicit
On Error Resume Next

' Set Constants and Variables
' -----------------------------------------------------------------
strIPAddress     = Array("10.203.10.87")
strSubnetMask    = Array("255.255.255.0")
strGateway       = Array("10.203.10.61")
strGatewayMetric = Array(1)
strDNSDomain     = "tol.local"
arrDNSServers    = Array("10.203.10.51" , "10.203.10.52")
Const FULL_DNS_REGISTRATION   = True
Const DOMAIN_DNS_REGISTRATION = False
 
' Open a Connection to Windows Management Instumentation
' -----------------------------------------------------------------
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
' Then Query WMI for all active NIC's
' -----------------------------------------------------------------
Set colNetAdapters = objWMIService.ExecQuery _
    ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")

'Set all NIC's to the pre-defined: IP-address, Netmask, Gateway.
' -----------------------------------------------------------------
For Each objNetAdapter in colNetAdapters
    errEnable   = objNetAdapter.EnableStatic(strIPAddress, strSubnetMask)
    If errEnable = 0 Then
        WScript.Echo "The IP address has been changed."
    Else
        WScript.Echo "The IP address could not be changed."
    End If
    errGateways = objNetAdapter.SetGateways(strGateway, strGatewaymetric)
    Wscript.Echo  objNetAdapter.SetDNSDomain(strDNSDomain)
    objNetAdapter.SetDynamicDNSRegistration FULL_DNS_REGISTRATION, _
        DOMAIN_DNS_REGISTRATION
    objNetAdapter.SetDNSServerSearchOrder(arrDNSServers)
Next

' Finalize and Quit the script
' -----------------------------------------------------------------
WScript.Quit

