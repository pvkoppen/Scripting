/*

Copyright (c) Microsoft Corporation. All rights reserved.
 
Module Name:
 
    nvspscrub.js
 
*/


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
        

    //
    // Instance methods
    //        
    
    VirtualSwitchManagementService.prototype.DeleteSwitch = 
    function(
        VirtualSwitch
        )
        
    /*++

    Description:

        Deletes a virtual switch
        
    Arguments:

        VirtualSwitch - Msvm_VirtualSwitch object to delete

    Return Value:

        SWbemMethod.OutParameters object.

    --*/
    
    {
        var methodName = "DeleteSwitch";

        var inParams = this.m_VirtualSwitchManagementService.Methods_(methodName).inParameters.SpawnInstance_();

        inParams.VirtualSwitch = VirtualSwitch.Path_.Path;
        
        return this.m_VirtualSwitchManagementService.ExecMethod_(methodName, inParams);
    }
    
    
    VirtualSwitchManagementService.prototype.DeleteInternalEthernetPort = 
    function(
        InternalEthernetPort
        )

    /*++

    Description:

        Deletes an internal ethernet port
        
    Arguments:

        InternalEthernetPort - Msvm_InternalEthernetPort to delete
        
    Return Value:

        SWbemMethod.OutParameters object.

    --*/

    {
        var methodName = "DeleteInternalEthernetPort";

        var inParams = this.m_VirtualSwitchManagementService.Methods_(methodName).inParameters.SpawnInstance_();
        
        inParams.InternalEthernetPort = InternalEthernetPort.Path_.Path;
        
        return this.m_VirtualSwitchManagementService.ExecMethod_(methodName, inParams);
    }
    
    VirtualSwitchManagementService.prototype.UnbindExternalEthernetPort = 
    function(
        ExternalEthernetPort
        )

    /*++

    Description:

        Unbinds an external ethernet port from the virtual network subsystem.  Usually this method
         won't be called directly
        
    Arguments:

        SwitchPort - Msvm_ExternalEthernetPort to unbind.

    Return Value:

        SWbemMethod.OutParameters object.

    --*/

    {
        var methodName = "UnbindExternalEthernetPort";

        var inParams = this.m_VirtualSwitchManagementService.Methods_(methodName).inParameters.SpawnInstance_();

        inParams.ExternalEthernetPort = ExternalEthernetPort.Path_.Path;
        
        return this.m_VirtualSwitchManagementService.ExecMethod_(methodName, inParams);
    }
    
    //
    // Utility functions
    //
    
    VirtualSwitchManagementService.prototype.WaitForNetworkJob = 
    function(
        OutParams
        )

    /*++

    Description:

        WMI calls will exit with some type of return result.  Some will require 
        a little more processing before they are complete. This handles those 
        states after a wmi call.

    Arguments:

        OutParams - the parameters returned by the wmi call.

    Return Value:

        Status code

    --*/

    {
        if (OutParams.ReturnValue == 4096)
        {
            var jobStateStarting        = 3;
            var jobStateRunning         = 4;
            var jobStateCompleted       = 7;
    
            var networkJob;

            do
            {
                WScript.Sleep(1000);
                
                networkJob = this.m_VirtualizationNamespace.Get(OutParams.Job);

            } while ((networkJob.JobState == jobStateStarting) || 
                     (networkJob.JobState == jobStateRunning));

            if (networkJob.JobState != jobStateCompleted)
            {
                throw(new Error(networkJob.ErrorCode,
                                networkJob.Description + " failed: " + networkJob.ErrorDescription));
            }
            
            return networkJob.ErrorCode;
        }

        return OutParams.ReturnValue;
    }
    
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
    // Aggregate functions
    //
    VirtualSwitchManagementService.prototype.DeleteSwitchAndWait = 
    function(
        VirtualSwitch
        )
        
    /*++

    Description:

        Deletes a switch
        
    Arguments:

        VirtualSwitch - Msvm_VirtualSwitch to delete
        
    Return Value:
    
        None.

    --*/
    
    {
        var outParams = this.DeleteSwitch(VirtualSwitch);

        var wmiRetValue = this.WaitForNetworkJob(outParams);

        if (wmiRetValue != 0)
        {
            throw(new Error(wmiRetValue, "DeleteSwitch failed"));
        }
    }
    
    VirtualSwitchManagementService.prototype.DeleteInternalEthernetPortAndWait = 
    function(
        InternalEthernetPort
        )
    /*++

    Description:

        Deletes an internal ethernet port
        
    Arguments:

        InternalEthernetPort - Msvm_InternalEthernetPort to delete
        
    Return Value:

        SWbemMethod.OutParameters object.

    --*/
    
    {
        var outParams = this.DeleteInternalEthernetPort(InternalEthernetPort);

        var wmiRetValue = this.WaitForNetworkJob(outParams);

        if (wmiRetValue != 0)
        {
            throw(new Error(wmiRetValue, "DeleteInternalEthernetPortAndWait failed"));
        }
    }
    
    
    VirtualSwitchManagementService.prototype.UnbindExternalEthernetPortAndWait = 
    function(
        ExternalEthernetPort
        )
    /*++

    Description:

        unbinds an internal ethernet port
        
    Arguments:

        ExternalEthernetPort - Msvm_ExternalEthernetPort to unbind
        
    Return Value:

        SWbemMethod.OutParameters object.

    --*/
    
    {
        var outParams = this.UnbindExternalEthernetPort(ExternalEthernetPort);

        var wmiRetValue = this.WaitForNetworkJob(outParams);

        if (wmiRetValue != 0)
        {
            throw(new Error(wmiRetValue, "UnbindExternalEthernetPortAndWait failed"));
        }
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
// Helper function for displaying Win32_NetworkAdapter settings
//
function DisplayWin32NetworkAdapter(win32NetworkAdapter)
{
    var protocols = win32NetworkAdapter.Associators_(
                                    "Win32_ProtocolBinding",
                                    "Win32_NetworkProtocol",
                                    "Antecedent");

    return win32NetworkAdapter.Name;
}

//
// Helper function for displaying network settings
//
function DisplayNetworkSettings(DeviceID)
{
    // get corresponding Win32_NetworkAdapter
    var win32NetworkAdapters = 
            g_CimV2.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE GUID = '" + DeviceID + "'");

    if (win32NetworkAdapters.Count)
    {
        var win32NetworkAdapter = win32NetworkAdapters.ItemIndex(0);
        return DisplayWin32NetworkAdapter(win32NetworkAdapter);
    }        
}

//
// main
// 

var wshShell = WScript.CreateObject("WScript.Shell");

var g_NvspWmi   = null;
var g_CimV2     = null;

Main();

function Main()
{
    var deleteDisabledNics = false;
    var purgeAll = false;
    var deleteNic = false;
    var queryAll = true;
    var nic = "";
    var objArgs = WScript.Arguments;

    var locator = new ActiveXObject("WbemScripting.SWbemLocator");

    if (WScript.arguments.Named.Exists("?"))
    {
        WScript.Echo("");
        WScript.Echo("    /v    delete disabled virtual NICs");
        WScript.Echo("    /p    purge all virtual network settings");
        WScript.Echo("    /n    purge specified NIC");
        WScript.Echo("");
        WScript.Quit();
    }
        
    if (WScript.arguments.Named.Exists("v"))
    {
        deleteDisabledNics = true;
        queryAll = false;
    }
    
    if (WScript.arguments.Named.Exists("p"))
    {
        purgeAll = true;
        queryAll = false;
    }

    if (WScript.arguments.Named.Exists("n"))
    {
        if (WScript.arguments.Count() < 2)
        {
           WScript.Echo(" no NIC specified");
           WScript.Quit();
        } 
        nic = objArgs(1);
        deleteNic = true;
        queryAll = false;
    }

    WScript.Echo("Looking for nvspwmi...");
    g_NvspWmi = new VirtualSwitchManagementService();
    g_CimV2 = locator.ConnectServer("", "root\\cimv2", "", "");

    if (deleteDisabledNics)
    {
        WScript.Echo("Looking for root\\cimv2...");
        
        WScript.Echo("");
        WScript.Echo("Looking for internal (host) virtual nics...");
        var list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_InternalEthernetPort");
        for (i = 0; i < list.Count; i++)
        {
            var next = list.ItemIndex(i);

            // find correpsonding Win32_NetworkAdapter
            var adapters = g_CimV2.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE GUID='" + next.DeviceID + "'");
            for (j = 0; j < adapters.Count; j++)
            {
                var adapter = adapters.ItemIndex(j);
                if (adapter.NetEnabled == false)
                {
                    WScript.echo("Deleting '" + next.ElementName + "' because it is disabled.");
                    g_NvspWmi.DeleteInternalEthernetPortAndWait(next);
                }
                else
                {
                    WScript.echo("Not deleting '" + next.ElementName + "' because it is enabled.");
                }
            }
        }
    }
    else
    {
        WScript.Echo("");
        WScript.Echo("Looking for internal (host) virtual nics...");
        var list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_InternalEthernetPort");
        for (i = 0; i < list.Count; i++)
        {
            var next = list.ItemIndex(i);
            var network = ""

            WScript.echo(next.DeviceID);
            WScript.echo("    " + next.ElementName);

            network = DisplayNetworkSettings(next.DeviceID);            

//            WScript.echo("    " + network);

            if (purgeAll)
            {
                g_NvspWmi.DeleteInternalEthernetPortAndWait(next);
            }
            else if (deleteNic)
            {
                if (nic == network || nic == next.ElementName)
                {
                    WScript.echo("");
                    WScript.echo("Deleting '" + next.ElementName + "' because it matches specified NIC.");
                    g_NvspWmi.DeleteInternalEthernetPortAndWait(next);
                }         
            }
            WScript.echo("");
        }

        if (purgeAll || queryAll)
        {
            WScript.Echo("");
            WScript.Echo("Looking for switches...");
            list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_VirtualSwitch");
            for (i = 0; i < list.Count; i++)
            {
                var next = list.ItemIndex(i);
                WScript.echo(next.Name);
                if (purgeAll)
                {
                    g_NvspWmi.DeleteSwitchAndWait(next);
                }
            }
        
            WScript.Echo("");
            WScript.Echo("Looking for external nics...");
            list = g_NvspWmi.m_VirtualizationNamespace.ExecQuery("SELECT * FROM Msvm_ExternalEthernetPort WHERE IsBound=TRUE");
            for (i = 0; i < list.Count; i++)
            {
                var next = list.ItemIndex(i);
                WScript.echo(next.DeviceID);
                if (purgeAll)
                {
                    g_NvspWmi.UnbindExternalEthernetPortAndWait(next);
                }
            }
        }
    }
    
    WScript.Echo("");
    WScript.Echo("Finished!");
}
