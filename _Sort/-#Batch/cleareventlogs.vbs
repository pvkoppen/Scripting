'~~[author]~~
'Marty Henderson
'~~[/author]~~

'~~[emailAddress]~~
'MooseGuy57@msn.com
'~~[/emailAddress]~~

'~~[scriptType]~~
'vbscript
'~~[/scriptType]~~

'~~[subType]~~
'DomainAdministration
'~~[/subType]~~

'~~[keywords]~~
'Event log,backup,clear,wmi,adsi,vbscript,event,log
'~~[/keywords]~~

'~~[comment]~~
'Save-Clear_Events.vbs - Portable Event Log backup & clear script. Dynamically finds your domain name. Dynamically finds all servers in the domain (member and DC) using ADSI. Dynamically discovers which event logs each server has via WMI. Backs up all event logs to a single network share, verifies the backup worked, then clears the logs (on all servers, via WMI). 

'Logs success and errors to the event log. Schedule this on a workstation or server in the domain running under a domain admins account. 

'You need only modify one thing: The cLogTarget constant. Make it point to your network share.
'~~[/comment]~~

'~~[script]~~
' Save-Clear_Events.vbs
  '
  ' Written in March 2003 by Marty Henderson.
  ' MooseGuy57@msn.com
  '
  '  This script does the following....
  '    Run from a Domain Workstation:
  '     - Dynamically gets the Active Directory namespace.
  '     - Makes a list of all domain DC's and Member Servers.
  '     - Makes a list of event logs per each Server.
  '     - Backs up each event log on each server to a network
  '       share (with a unique name for each file).
  '     - Clears each event log (only after verification of
  '       good backup).
  '     - Keeps warning, error, and success metrics.
  '     - Logs warnings, errors, and successes.
  '
  '  What Must I Do To Make This Script Work In My Domain?
  '    One Thing: Modify the cLogTarget string constant.
  '    This is the repository place for the event log backup
  '    files. You'll find it under the "Constants - Globally
  '    defined string constants" label. Modify it to look
  '    something like this...
  '    Const cLogTarget = "\\MyServer\MyShare"

  '  Environment:
  '    Run this script from any domain workstation either
  '    interactively or scheduled. The account context must
  '    be a Domain Admins member.
  '
  '    It is strongly suggested to run this from an XP or W2K
  '    workstation because of the event logging. If this were
  '    run from a server the very logs this script writes would
  '    be cleared. They would be backed up but you'd have to
  '    view them from the backup evt file, and some of the logs
  '    would remain on the server's live event log. NOTE: The
  '    event logs can be redirected to another server but this
  '    version is not written that way.
  '
  '  Prerequisites:
  '    - An Active directory Domain.
  '    - All nodes running Windows Script Host V5.6 engiine.
  '    - ADSI on the domain controllers and single workstation.
  '    - WMI on all servers and the single workstation.
  '    - The workstation that runs this script must be a domain
  '      member.
  '
  '     Note: WMI and ADSI are installed & run by default on
  '           W2K, XP, and Server 2003.
  '           WSH engine V5.6 is installed by default on XP and
  '           Server 2003. W2K SP4 installs WSH V5.6. Otherwise
  '           download it from...
  '           http://www.microsoft.com/technet/scriptcenter
  '
  '  Backup Flow:
  '    A WMI security feature disallows backup of event logs
  '    directly to a network share. Because of this the backups
  '    must be written to a local hard disk (respective to the
  '    server being backed up) then copied to the network share.
  '    After successfull copy the local hard disk backup evt
  '    file is deleted.
  '
  '  Naming:
  '    Each event log is given a unique name including the
  '    computer name, event log type, and date. For example:
  '    MYSERVER - Application - 2004 10 25.evt
  '
  '  Event Logging:
  '    This script is WAY more complex than it needs to be. One
  '    reason for this was to accomodate logging. The script
  '    keeps metrics for warnings, errors, and successes. It
  '    logs detailed event log data including the function the
  '    problem occured in.
  '
  '  Portability:
  '    Another reason for the high complexity level of this
  '    script is it's portability. It works in ANY Active
  '    Directory domain as written. You only need to change
  '    the cLogTarget constant to match your network share.
  '    It does not work at the entire forest level (but could
  '    be modified).
  '
  '  Entire Script Flow:
  '    1. Get some basic info about the host running the script.
  '    2. Get a local hard disk letter with more than 100 mb free
  '       space to write the backup logs directly onto.
  '    2. Get the LDAP domain name space from Active Directory.
  '    3. Query Active Directory for all nodes of type Server.
  '       This includes Domain Controllers and member servers.
  '    4. Check to see if the target specified in the cLogTarget
  '       constant is available on the network.
  '    5. For each WinServer in the domain...
  '          a. Query which event logs reside on it.
  '          b. Constuct a logfile name consisting of...
  '             node name, event log type, and day/month/year.
  '          c. Backup each logfile to a local hard disk.
  '          d. Move the backup logs from local hard disk to
  '             the network location. (Copy, verify, then delete)
  '          e. Clear each logfile only after verification of
  '             good backup and file transfer.
  '    6. Log script exit status to the application event log.
  '
  '  Scheduling:
  '    You can use the task scheduler. Little gotcha - in the
  '    scheduler wizard you must specify cscript.exe as the
  '    program to run. (It's in system32) After the scheduled
  '    task is created get properties on it and modify the
  '    run command box. Leave the text in place as is....but
  '    append a space followed by the full path to this script
  '    including the script name. It may look something like
  '    this...
  '    C:\WINDOWS\system32\cscript.exe C:\Script\Save-Clear-Events.vbs
  '
  '  Testing and Bugs:
  '    I forced errors in every function and tested. "There are no
  '    bugs in my code." (2nd most used lie in earth history)
  '    But if you discover any problems please let me know....
  '    MailTo:MooseGuy57@msn.com
  '
  '    This thing got a little out of hand. If you can think of
  '    ways to simplify I would welcome suggestions.
  '       Marty Henderson
  '
  '  Modifications:
  '      MOD:1a (Month Day, 2004 - Programmer Name)
  '
  '

Option Explicit
On Error Resume Next

'***********************************************************************
'  Constants - Globally defined string constants.
'***********************************************************************

   ' Location for target copy of events logs. Change this to customize
   ' archival point for the logs.

Const cLogTarget = "\\ttwsbs\EventLogs"

'***********************************************************************
'  Arrays - Globally defined arrays.
'***********************************************************************

  ' Array to hold sever computer names.
Dim arrServers
  ' Array to hold event log names for a given server.
Dim arrEVTfiles

'***********************************************************************
'  Variables - Globally defined variables.
'***********************************************************************

   ' Declare & create global Shell objects
Dim WshShell, WshNetwork, objFSO, objArgs

Set WshShell   = WScript.CreateObject("WScript.Shell")
Set WshNetwork = WScript.CreateObject("Wscript.Network")
Set objFSO     = CreateObject("Scripting.FileSystemObject")

   ' Declare misc global variables. Follow these through the script
   ' to see what they do.
Dim dtmThisDay
Dim dtmThisMonth
Dim dtmThisYear
Dim strToday
Dim strNameSpace
Dim strEvtMsg
Dim strNode
Dim strEVTname
Dim strBackupName
Dim strComputer
Dim strTempDisk
Dim intFatalCount   :  intFatalCount = 0
Dim intWarnCount    :  intWarnCount = 0
Dim intSuccessCount :  intSuccessCount = 0
Dim bouBailOut      :  bouBailOut = FALSE
Dim bouSkipNode     :  bouSkipNode = FALSE
Dim strSuccess
Dim strFailure
Dim strThisScript
Dim intResult

'***********************************************************************
'  Main Program
'***********************************************************************

   ' Get some baseline information into variables.
Call GetBaseInfo()

   ' Stamp script startup into event log.
Call WriteEvent(00, 4, strComputer, "", "")

   ' Get the Active Directory namespace.
intResult = FindNBind()

   ' Get names of domain DC's & member servers.
intResult = GetDomServers()

   ' Assure the target archive folder is reachable.
intResult = TargetReady(cLogTarget)

   ' Here we do all steps for a single log on one server to completion.
   ' After all logs for one server are finished then we move on to
   ' the next server.

   ' Loop the array of servers in our domain.
For Each strNode in arrServers

       ' NOTE: for security reasons, WMI will not allow backup of event
       ' logs to a network share. We must back them up to local disk
       ' then move them to a network share.

       ' Note: if we can't do certain things on the server then no
       ' sense in continuing and logging multiple errors. Hence the
       ' bouSkipNode variant.

    bouSkipNode = FALSE

       ' Find a local hard disk to write the backups.
    If Not bouSkipNode Then GetScratchDisk(strNode)

       ' Get the event logs resident on the current server.
    If Not bouSkipNode Then GetLogTypes(strNode)

    If Not bouSkipNode Then

           ' Loop the event logs of one server. Finish all tasks on
           ' the current log file before moving on to the next log.
        For Each strEVTname in arrEVTfiles

               ' Note: no check for bouSkipNode from here on out.
               ' It is possible that a failure condition for one
               ' evt log will not exist for another evt log.

               ' Backup or clear an event log. If P3 is "backup"
               ' then EVTstuff will run in backup mode. If P3
               ' is anything else then it will clear the log.
            intResult = EVTstuff(strNode, strEVTname, "backup")

               ' If the logfile backup worked....
            If Not bouSkipNode Then

               ' Copy the backup file to the network target.
                intResult = MoveEVT(strNode, strBackupName, _
                            strTempDisk, cLogTarget)

            End If

            If Not bouSkipNode Then

                    ' If the copy worked then clear event log.
                intResult = EVTstuff(strNode, strEVTname, "clear")

            End If
        Next
    End If

Next

Call BailOut()

'***********************************************************************
'  Sub GetBaseInfo() - Collect some baseline info into global variables.
'***********************************************************************

    Sub GetBaseInfo()

       On Error Resume Next

         ' Get the computer name
      strComputer = LCase(WshNetwork.ComputerName)

      strThisScript = WScript.ScriptName

          ' Populate date variables for use in backup logfile name.
       dtmThisDay    = Day(Now)
       dtmThisMonth  = Month(Now)
       dtmThisYear   = Year(Now)

          ' Set time portion of the event log backup file name variant.
       strToday = dtmThisYear & " " &_
                  dtmThisMonth & " " &_
                  dtmThisDay

    End Sub

'***********************************************************************
'  Function FindNBind() - Get LDAP Active Directory Provider Namespace
'                         at the domain level.
'***********************************************************************

    Function FindNBind()

       On Error Resume Next
       Dim objBaseLDAP, strErrDesc
       FindNBind = TRUE

          ' Bind to the root of our LDAP AD.
       Set objBaseLDAP = GetObject("LDAP://RootDSE")

          ' Return the namespace text string.
       Err.Clear
       strNameSpace = objBaseLDAP.get("DefaultNamingContext")

       If Err.Number <> 0 Then

           strErrDesc = Err.Description
           FindNBind = FALSE
           bouBailOut = TRUE

              ' Write fatal error log # 1. P2 = 1 means we
              ' abort the script. The script will exit on
              ' a call from WriteEvent().
           Call WriteEvent(01, 1, "FindNBind()", strErrDesc, "")

           Exit Function

       End If

    End Function

'***********************************************************************
'  Function GetDomServers() - Get the names of all domain DC and member
'                             servers into a data array.
'***********************************************************************

    Function GetDomServers()

       On Error Resume Next
       Dim objConnection, objCommand, objRecordSet, strQuery1
       Dim intSvrCount  :  intSvrCount = 0

       GetDomServers = TRUE

          ' Create ADO connecton object in memory.
       Set objConnection = CreateObject("ADODB.Connection")

          ' Open the connection object using ADSI OLE DB provider.
       objConnection.Open "Provider=ADsDSOObject;"

          ' Create ADO command object in local memory.
       Set objCommand = CreateObject("ADODB.Command")

          ' Link the connection object to the command object's
          ' ActiveConnection property.
       objCommand.ActiveConnection = objConnection

          ' Build the LDAP query string...serach entire AD for computer
          ' objects containing the word Server in the OS field. Return
          ' the computer name of each instance found.
       strQuery1 = "<LDAP://" & strNameSpace & ">;" &_
                   "(&(objectCategory=Computer)(operatingSystem=*Server*));" &_
                   "Name;subtree"

          ' Write the query string into the command object.
       objCommand.CommandText = strQuery1

          ' Run the query against AD and trap for error.
       Err.Clear
       Set objRecordSet = objCommand.Execute

          ' If nothing returned then log error and quit the script.
       If objRecordSet.RecordCount = 0 Then

            GetDomServers = FALSE
            bouSkipNode = TRUE
            bouBailOut = TRUE

              ' Write fatal error log # 2. The script will exit
              ' on a call from WriteEvent().
           Call WriteEvent(02, 1, "GetDomServers()", _
                                  strNameSpace, "")

       End If

          ' Size up the array to hold server names.
       ReDim arrServers(objRecordSet.RecordCount - 1)

          ' Loop the record set.
       While Not objRecordSet.EOF

             ' Load up the array.
          arrServers(intSvrCount) = objRecordSet.Fields("Name")
          intSvrCount = intSvrCount + 1

          objRecordSet.MoveNext

       Wend

          ' Kill the connection object.
       objConnection.Close

    End Function

'***********************************************************************
'  Function TargetReady() - Assure the final network target location for
'                           the evt file backups exist.
'***********************************************************************

    Function TargetReady(strLogTarget)

       On Error Resume Next
       TargetReady = TRUE

            ' Test for the target folder with error checking. If it
            ' doesn't exist now then we log and abort.
        If Not objFSO.FolderExists(strLogTarget) Then

            TargetReady = FALSE
            bouSkipNode = TRUE
            bouBailOut = TRUE

               ' Write fatal error log # 3. The script will exit
               ' on a call from WriteEvent().
            Call WriteEvent(03, 1, "TargetReady()", _
                                   strLogTarget, "")

            Exit Function

        End If

    End Function

'***********************************************************************
'  Function GetScratchDisk() - Find a local hard disk for one server
'                              with more than 100 mb free. This is to
'                              write the initial evt backup before
'                              moving it to the network destination.
'***********************************************************************

    Function GetScratchDisk(strSrvName)

       On Error Resume Next
       Dim objWMIService, strQuery1, strQuery2, colDisks, objDisk
       GetScratchDisk = TRUE
       strTempDisk = ""

          ' Get WMI CIM root.
       strQuery1 = "winmgmts:{impersonationLevel=impersonate}!\\" &_
                   strSrvName & "\root\cimv2"
       Set objWMIService = GetObject(strQuery1)

          ' Query the node for all logical disks.
       strQuery2 = "Select * from Win32_LogicalDisk"
       Set colDisks = objWMIService.ExecQuery (strQuery2)

          ' Loop the local disk objects.
       For each objDisk in colDisks

               ' Type 3 = Local Hard Disk.
            If objDisk.DriveType = 3 Then

                   ' If over 100 mb free disk space then we have our
                   ' temp disk. 100 mb = (1024 x 1024) x 100
                If objDisk.FreeSpace > 104857600 Then

                       ' Populate the global variant used for
                       ' temporary backup log file location.
                    strTempDisk = objDisk.DeviceID & "\"
                    'Exit Function

                End If

            End If

       Next

          ' strTempDisk null means no hard disks had free space
          ' of greater then 100 mb. We'll consider this fatal for
          ' the current server only and keep running the script
          ' since other servers might be OK.
       If strTempDisk = "" Then

            GetScratchDisk = FALSE
               ' Set flag to stop processing for the current server.
            bouSkipNode = TRUE
               ' Keep running the script.
            bouBailOut = FALSE

               ' Write warning error log # 4. The script will not
               ' exit on warnings.
            Call WriteEvent(04, 2, "GetScratchDisk()", _
                                   strSrvName, "")

               ' Keep track of failure metrics.
            Call WriteEvent(999, 2, strSrvName & " - All Event Logs", _
                            "", "nolog")

       End If

    End Function

'***********************************************************************
'  Function GetLogTypes() - Use WMI to get names of all event logs on
'                           one server. Server name must be passed in.
'***********************************************************************

    Function GetLogTypes(strSrvName)

       On Error Resume Next
       GetLogTypes = TRUE
       Dim objWMIService, objInstalledLogFiles, objLogfile, intEvtCount
       Dim strQuery1, strQuery2, strErrDesc
       intEvtCount = 0

           ' Connect remotely to WMI root Cimv2
       strQuery1 = "winmgmts:{impersonationLevel=impersonate}!\\" &_
                   strSrvName & "\root\cimv2"
       Set objWMIService = GetObject(strQuery1)

           ' Execute the WMI query to return all logfile objects.
       strQuery2 = "Select * from Win32_NTEventLogFile"
       Err.Clear
       Set objInstalledLogFiles = objWMIService.ExecQuery (strQuery2)

       If Err.Number <> 0 Then

               ' The WMI query didn't work, so stop processing for
               ' this server but keep running the script. (Other
               ' servers might be OK)
            strErrDesc = Err.Description
            GetLogTypes = FALSE
               ' Abort processing for the current server in the loop.
            bouSkipNode = TRUE
               ' Keep running the script code.
            bouBailOut = FALSE

               ' Write warning error log # 5. The script will not
               ' exit on warnings.
            Call WriteEvent(05, 2, "GetLogTypes()", _
                                   strSrvName, strErrDesc)

               ' Keep track of failure metrics.
            Call WriteEvent(999, 2, strSrvName & " - All Event Logs", _
                            "", "nolog")

            Exit Function

       End If

          ' Size up array to hold this node's event logs names.
       ReDim arrEVTfiles(objInstalledLogFiles.Count - 1)

           ' Populate the array with this node's event log names.
       For each objLogfile in objInstalledLogFiles

            arrEVTfiles(intEvtCount) = objLogfile.LogFileName
            intEvtCount = intEvtCount + 1

       Next

    End Function

'***********************************************************************
'  Function EVTstuff() - Backup or clear one event log.
'***********************************************************************

    Function EVTstuff(strSrvName, strEVTtype, strFunction)

      On Error Resume Next
      Dim LogFileSet, objLogfile, strQuery1, strQuery2
      EVTstuff = TRUE

          ' Create backup log filename. Format will appear as...
          ' Nodename - Application - 2004 8 18.evt
      strBackupName = strSrvName & " - " & strEVTtype & " - " &_
                            strToday & ".evt"

          ' Set up WMI query text strings. This query returns an object
          ' for a specific event log.
      strQuery1 = "winmgmts:{impersonationLevel=impersonate," &_
                  "(Backup,Security)}!\\" & strSrvName & "\root\cimv2"
      strQuery2 = "select * from Win32_NTEventLogFile where " &_
                  "LogfileName='" & strEVTtype & "'"

          ' Get a single event log object.
      Set LogFileSet = GetObject(strQuery1).ExecQuery(strQuery2)

      For Each objLogfile in LogFileSet

         If strFunction = "backup" Then

             Err.Clear
                ' This is where we backup one event log file to a
                ' local hard disk.
             objLogFile.BackupEventLog(strTempDisk & strBackupName)

             If Err.Number <> 0 Then

                 EVTstuff = TRUE
                    ' Again, a failure on one server does not mean the
                    ' others will fail...so keep running code.
                 bouBailOut = FALSE
                    ' If we can't backup one log file to the local disk
                    ' then we'll assume all of them will fail. This will
                    ' prevent scores of event log entries, one per log.
                 bouSkipNode = TRUE

                    ' Write fatal error log # 6. The script will not
                    ' exit. Since this is the actual backup of an event
                    ' log we consider this an error, unlike some prior
                    ' logs which were considered warnings. We do not
                    ' abort script because this condition might not
                    ' be prevalant on all servers.
                 Call WriteEvent(06, 2, "EVTstuff()", _
                                        strEVTtype , strSrvName)

                    ' Keep track of failure metrics.
                 Call WriteEvent(999, 2, strSrvName & " - " &_
                                 strEVTtype, "", "nolog")

             End If

         Else

            Err.Clear
                ' This is where we clear one event log file.
            objLogFile.ClearEventLog()

             If Err.Number <> 0 Then

                 EVTstuff = TRUE
                 bouBailOut = FALSE
                 bouSkipNode = FALSE

                    ' Write warning error log # 7. The script will not
                    ' exit.
                    ' If we can't clear a log then it's a warning
                    ' because the log was backed up.
                 Call WriteEvent(07, 2, "EVTstuff()", _
                                        strEVTtype , strSrvName)

                    ' Keep track of failure metrics.
                 Call WriteEvent(999, 2, strSrvName & " - " & strEVTtype, _
                                 "", "nolog")

                    ' Since the logfile did actually get backed up we'll
                    ' log success also.
                 Call WriteEvent(999, 0, strSrvName & " - " & strEVTtype, _
                                 "", "nolog")

             Else

                    ' If we get here then everything worked for one log!
                    ' Bump success metrics and append to the list of
                    ' logs that were successfull. "nolog" in P5 causes
                    ' WriteEvent() not to log to event log. This will
                    ' be done at gracefull script exit.
                 Call WriteEvent(999, 0, strSrvName & " - " & strEVTtype, _
                                 "", "nolog")

                    ' Flag success back to the caller
                 EVTstuff = TRUE

             End If

         End If

      Next

    End Function

'***********************************************************************
'  Function MoveEVT() - Use WMI to move one event log file from local
'                       disk to network share.
'***********************************************************************

    Function MoveEVT(strSrvName, strTempEvt, strCopyRoot, strNet)

       On Error Resume Next
       Dim strNetSource, strTempFile
       MoveEVT = TRUE

          ' This copy will go net location to net location. So we
          ' need to convert the temp evt filename from local disk
          ' to UNC. We can use the admin share of the disk.
       strNetSource = "\\" & strSrvName & "\" &_
                       Left(strCopyRoot, 1) & "$\" &_
                       strBackupName

          ' Copy a single backed up event log to the network target.
       Err.Clear
       objFSO.CopyFile strNetSource, strNet & "\", TRUE

       If Err.Number <> 0 Then

            MoveEVT = FALSE
               ' Same as other function....if we can't do this once
               ' then it'll probably fail for each log, so quit
               ' processing for the current server.
            bouSkipNode = TRUE
               ' Keep running the script.
            bouBailOut = FALSE

              ' Write fatal error log # 8.
            Call WriteEvent(08, 2, "MoveEVT()", _
                            strNetSource, _
                            strNet & ".")

               ' Keep track of failure metrics.
            Call WriteEvent(999, 2, strTempEvt, "", "nolog")

       Else

              ' Everything has worked to this point so we'll go
              ' ahead and dealte the local temp evt file.
           Set strTempFile = objFSO.GetFile(strNetSource)

           Err.Clear
           strTempFile.Delete
           If Err.Number <> 0 Then

                MoveEVT = FALSE
                   ' Since everything worked but this we'll go ahead
                   ' and keep trying on each event log, (We are getting
                   ' a good backup and file transfer) but later on
                   ' we'll advise the administrator to manually delete
                   ' the temp log files.
                bouSkipNode = FALSE
                bouBailOut = FALSE

                  ' Write fatal error log # 9.
                Call WriteEvent(09, 2, "MoveEVT()", _
                                strNetSource, "")

                   ' Keep track of failure metrics.
                Call WriteEvent(999, 2, strTempEvt, "", "nolog")

           End If

       End If

    End Function

'***********************************************************************
'  Sub WriteEvent() - Write one event to the Windows app event log.
'                     This function exists to make the other functions
'                     shorter and less convoluted. This is like a
'                     central repository for error messages and metrics
'                     processing.
'***********************************************************************
    Sub WriteEvent(intEvent, intSeverity, strTxt1, strTxt2, strTxt3)

      On Error Resume Next


      Select Case intEvent

      	 Case 00       ' Informational - Script startup time stamp.
      	            strEvtMsg = strThisScript & " has started on node " &_
      	                        strTxt1 & "."

      	 Case 01       ' Fatal - Can't get LDAP namespace.
      	            strEvtMsg = "Fatal " & strThisScript &_
      	                        " error in function " &_
      	                        strTxt1 & ". Script aborted. " &_
      	                        "Zero servers backed up. " &_
      	                        "to query the AD LDAP " &_
      	                        "namespace..." & strTxt2

      	 Case 02       ' Fatal - Can't get list of servers from ADSI.
      	            strEvtMsg = "Fatal " & strThisScript & " error " &_
      	                        "in function " & strTxt1 & ". " &_
      	                        "Script aborted. Zero servers " &_
      	                        "backed up. Unable to get list " &_
      	                        "of server names from ADSI query of " &_
      	                        strTxt2 & "."

      	 Case 03       ' Fatal - Target network folder is not available.
      	            strEvtMsg = "Fatal " & strThisScript & " error in " &_
      	                        "function " & strTxt1 & ". Script " &_
      	                        "aborted. Zero servers backed up. " &_
      	                        "Target backup folder " &_
      	                        strTxt2 & " is not reachable."

      	 Case 04        ' Fatal - Can't locate local disk with > 100 mb
      	                '         free disk space.
      	            strEvtMsg = "Fatal " & strThisScript & " error in " &_
                                "function " & strTxt1 & ". Script " &_
                                "continuing. Unable to locate local disk " &_
                                "with > 100 mb free on " & strTxt2 &_
                                " to write temp backup files."

      	 Case 05        ' Fatal - Can't get event log types from WMI.
      	            strEvtMsg = "Fatal " & strThisScript & " error in " &_
                                "function " & strTxt1 & ". Script " &_
                                "continuing. Unable to retrieve  " &_
                                "list of event log names from WMI " &_
                                "on " & strTxt2 & "..." & strTxt3

      	 Case 06       ' Warning - Can't backup event log to temp folder.
      	            strEvtMsg = "Fatal " & strThisScript & " error in " &_
                                "function " & strTxt1 & ". Script " &_
                                "continuing. Failure attempting " &_
                                "to backup the " & strTxt2 &_
                                " log on " & strTxt3 & "."

      	 Case 07       ' Warning - Can't clear event log.
      	            strEvtMsg = strThisScript & " warning in " &_
                                "function " & strTxt1 & ". Script " &_
                                "continuing. Failure attempting " &_
                                "to clear the " & strTxt2 &_
                                " log on " & strTxt3 & "."

      	 Case 08       ' Warning - Can't copy event log backup from temp
      	               '           location to network share.
      	            strEvtMsg = strThisScript & " warning in " &_
                                "function " & strTxt1 & ". Script " &_
                                "continuing. Failure attempting " &_
                                "to copy " & strTxt2 & " to " &_
                                strTxt3

      	 Case 09       ' Warning - Failure to delete temp backup file. We
      	               '           remind admin to manually delete the temp
      	               '           file because WMI will not overwrite on a
      	               '           copy function, so the next backup would
      	               '           fail.
      	            strEvtMsg = strThisScript & " warning in " &_
                                "function " & strTxt1 & ". Script " &_
                                "continuing. Failure attempting " &_
                                "to delete " & strTxt2 & ". " &_
                                "Please manually delete the file. " &_
                                " If you don't then the next " &_
                                "backup will fail."

      	 Case 10    strEvtMsg = ""

      	 Case Else     ' Do Nothing.

      End Select

      If strTxt3 <> "nolog" Then

             ' Log the event.
          WshShell.LogEvent intSeverity, strEvtMsg

      End If

         ' Handle metrics. Call to exit script if error severity is 1.
      Select Case intSeverity

       	 Case  0       ' Success
       	            intSuccessCount = intSuccessCount + 1
       	            If strTxt3 = "nolog" Then

                          ' Build list of servers backed up.
                       strSuccess =  strSuccess & VbCrLf &_
                       strTxt1 & strTxt2

                    End If

       	 Case  1       ' Error
                       ' Error status means we abort the script.
                    intFatalCount = intFatalCount + 1
                       ' Build list of servers not backed up.
                    If bouBailOut Then Call BailOut()

       	 Case  2       ' Warning

       	            If strTxt3 = "nolog" Then

                        intWarnCount = intWarnCount + 1
       	                strFailure = strFailure & VbCrLf & strTxt1 &_
       	                             strTxt2

       	            End If

      	 Case  4       ' Informational

      	 Case  8       ' Audit Success

         Case 16       ' Audit Failure

      End Select

    End Sub

'***********************************************************************
'  Sub BailOut() - Exit after logging in Event Log. This is the only
'                  exit point for the entire script.
'***********************************************************************
    Sub BailOut()

       On Error Resume Next
       Dim intType

         ' The three if statements construct the text portion of the
         ' final event log entry.

       If intWarnCount = 0 and intFatalCount = 0 Then

              ' If no errors or warnings write success status message
              ' with statistics & pertinate information.
           strEvtMsg = WScript.ScriptName & " completed successfully." &_
                       " The event logs were cleared. The backups can" &_
                       " be found at: " & cLogTarget &_
                       VbCrLf & VbCrLf &_
                       intSuccessCount & " logfiles were backed up..." &_
                       VbCrLf & strSuccess

           intType = 8

       End If

          ' If zero backups worked.
       If intSuccessCount = 0 Then

               ' If any warnings or errors then write the status message
               ' with statistics and advise to look at previous WSH logs.
           strEvtMsg = WScript.ScriptName & " ended with warning count of " &_
                       intWarnCount & " and fatal error count of " &_
                       intFatalCount & ". See prior WSH events for " &_
                       "details. " & VbCrLf & VbCrLf &_
                       intWarnCount & " problems were encountered..." &_
                       VbCrLf & strFailure

           intType = 16

       End If

       If intWarnCount + intFatalCount <> 0 and intSuccessCount <> 0 Then

               ' If any some warning and some successes then log stats for
               ' both.
           strEvtMsg = WScript.ScriptName & " ended with warning count of " &_
                       intWarnCount & ", fatal error count of " &_
                       intFatalCount & " and success count of " &_
                       intSuccessCount & ". See prior WSH events for " &_
                       "details. " & VbCrLf & VbCrLf &_
                       intWarnCount & " problems were encountered..." &_
                       VbCrLf & strFailure &_
                       VBCrLf & VbCrLf & intSuccessCount &_
                       " logfiles were backed up..." &_
                       VbCrLf & strSuccess

           intType = 16

       End If

          ' Log the final event and quit script.
       WshShell.LogEvent intType, strEvtMsg
       WScript.Quit(0)

    End Sub
'~~[/script]~~
