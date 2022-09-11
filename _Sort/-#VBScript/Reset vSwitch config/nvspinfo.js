

//
// VirtualSwitchManagementService object.  Logical wrapper class for Switch Management Service
//
function
VirtualSwitchManagementService(
    Server,
    User,
    Password
    )
{
    //
    // Define instance fields.
    //    
    this.m_VirtualizationNamespace  = null;
    
    this.m_VirtualSwitchManagementService = null;
        

    
    VirtualSwitchManagementService.prototype.GetSingleObject = 
    function(
        SWbemObjectSet
        )
 
    /*++
 
    Description:
 
        Takes a SWbemObjectSet which is expected to have one object and returns the object
 
    Arguments:
 
        SWbemObjectSet - The set.
 
    Return Value:
 
        The lone member of the set.  Exception thrown if Count does not equal 1.
 
    --*/
 
    {
        if (SWbemObjectSet.Count != 1)
        {
            throw(new Error(5, "SWbemObjectSet was expected to have one item but actually had " + SWbemObjectSet.Count)); 
        }
        
        return SWbemObjectSet.ItemIndex(0);
    }
 
    
    //
    // Constructor code
    //
    
    if (Server == null)
    {
        Server = WScript.CreateObject("WScript.Network").ComputerName; 
    }
    
    //
    // Set Namespace fields
    //
    try
    {
        var locator = new ActiveXObject("WbemScripting.SWbemLocator");
 
        this.m_VirtualizationNamespace = locator.ConnectServer(Server, "root\\virtualization", User, Password);
    }
    catch (e)
    {
        this.m_VirtualizationNamespace = null;
        
        throw(new Error("Unable to get an instance of Virtualization namespace: " + e.description));
    }
    
    //
    // Set Msvm_VirtualSwitchManagementService field
    //
    try
    {
        var physicalComputerSystem = 
                this.m_VirtualizationNamespace.Get(
                        "Msvm_ComputerSystem.CreationClassName='Msvm_ComputerSystem',Name='" + Server + "'");
          
        this.m_VirtualSwitchManagementService = this.GetSingleObject(
                                                        physicalComputerSystem.Associators_(
                                                            "Msvm_HostedService",
                                                            "Msvm_VirtualSwitchManagementService",
                                                            "Dependent"));
    }
    catch (e)
    {
        this.m_VirtualSwitchManagementService = null;
        
        throw(new Error("Unable to get an instance of Msvm_VirtualSwitchManagementService: " + e.description));
    }
}
 

//
// main
// 

var wshShell = WScript.CreateObject("WScript.Shell");
 
var g_NvspWmi   = null;
 
Main();
 
function Main()
{
    WScript.Echo("Looking for nvspwmi...");
    g_NvspWmi   = new VirtualSwitchManagementService();
 
    WScript.Echo("");
    WScript.Echo("Looking for internal (host) virtual nics...");
    var list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_InternalEthernetPort");
    for (i = 0; i < list.Count; i++)
    {
        var next = list.ItemIndex(i);
        WScript.echo(next.DeviceID);
        WScript.echo("\t" + next.ElementName);
        WScript.echo("\tMTU = " + next.MaxDataSize);
    }
    
    WScript.Echo("");
    WScript.Echo("Looking for bound external nics...");
    list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_ExternalEthernetPort WHERE IsBound=TRUE");
    for (i = 0; i < list.Count; i++)
    {
        var next = list.ItemIndex(i);
        WScript.echo(next.DeviceID);
        WScript.echo("\t" + next.ElementName);
    }
    
    WScript.Echo("");
    WScript.Echo("Looking for unbound external nics...");
    list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_ExternalEthernetPort WHERE IsBound=FALSE");
    for (i = 0; i < list.Count; i++)
    {
        var next = list.ItemIndex(i);
        WScript.echo(next.DeviceID);
        WScript.echo("\t" + next.ElementName);
        WScript.echo("\tMTU = " + next.MaxDataSize);
    }
 
    WScript.Echo("");
    WScript.Echo("Looking for synthetic nics...");
    list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_SyntheticEthernetPort");
    for (i = 0; i < list.Count; i++)
    {
        var next = list.ItemIndex(i);
        WScript.echo(next.DeviceID);
        WScript.echo("\t" + next.ElementName);
        WScript.echo("\tMTU = " + next.MaxDataSize);
    }
 
    WScript.Echo("");
    WScript.Echo("Looking for emulated nics...");
    list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_EmulatedEthernetPort");
    for (i = 0; i < list.Count; i++)
    {
        var next = list.ItemIndex(i);
        WScript.echo(next.DeviceID);
        WScript.echo("\t" + next.ElementName);
        WScript.echo("\tMTU = " + next.MaxDataSize);
    }
 
    WScript.Echo("");
    WScript.Echo("Looking for switches...");
    list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_VirtualSwitch");
    for (i = 0; i < list.Count; i++)
    {
        var next = list.ItemIndex(i);
        WScript.echo(next.Name);
        WScript.echo("\t" + next.ElementName);
        WScript.echo("\tPorts:");
 
        var ports = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_SwitchPort WHERE SystemName= '" + next.Name + "'");
        for (j = 0; j < ports.Count; j++)
        {
            var port = ports.ItemIndex(j);
   
            WScript.echo("\t\t" + port.Name);
            WScript.echo("\t\tAllowMacSpoofing     = " + port.AllowMacSpoofing);
            WScript.echo("\t\tChimneyOffloadWeight = " + port.ChimneyOffloadWeight);
            WScript.echo("\t\tChimneyOffloadUsage  = " + port.ChimneyOffloadUsage);
            WScript.echo("\t\tVMQOffloadWeight     = " + port.VMQOffloadWeight);
            WScript.echo("\t\tVMQOffloadUsage      = " + port.VMQOffloadUsage);
 
            var macs = port.Associators_(
       "Msvm_SwitchPortDynamicForwarding",
       "Msvm_DynamicForwardingEntry",
       "Dependent");
   
         for (k = 0; k < macs.Count; k++)
            {
             var mac = macs.ItemIndex(k);
    var str = mac.MACAddress;
    if (str.length != 12)
    {
              WScript.echo("\t\t\t" + str);
    }
    else
    {
              WScript.echo("\t\t\t" + 
      str.charAt(0)  + str.charAt(1)  + "-" +
      str.charAt(2)  + str.charAt(3)  + "-" +
      str.charAt(4)  + str.charAt(5)  + "-" +
      str.charAt(6)  + str.charAt(7)  + "-" +
      str.charAt(8)  + str.charAt(9)  + "-" +
      str.charAt(10) + str.charAt(11) + "  VLAN:" + mac.VlanId);
    }
            }
 
            WScript.Echo("");
        }
    }
    
    WScript.Echo("");
    WScript.Echo("Finished!");
}
