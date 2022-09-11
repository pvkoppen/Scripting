'////////////////////////////////////////////////////////////////////////
'
' This file is used by all help files and all files in the IDE that 
' use its methods:
'
' IsAuthorRunning               ' If Developer is running in AdminStudio
' GetRefToApp()					' Page must also include ErrorHandler.vbs
' GetRefToMain()				' Page must also include ErrorHandler.vbs
' MsgHelpOK()					' Page must also include Resource_h.vbs
' MsgHelpYN()					' Page must also include Resource_h.vbs
' ISHelpLoadString()			' Use constants in Resource_h.vbs.
' GetProductName()				' Page must also include Resource_h.vbs
' GetProductNameShort()			' Page must also include Resource_h.vbs
' AddTradeMarks()				' Page must also include Resource_h.vbs
' IsProjectLoaded()				' Page must also include ErrorHandler.vbs
' GetMainPath()					
' GetDefProjLocation()			
' GetHelpFile()					' Finds out which compiled help file your in
' HideAndShow()					' Hides or shows depending on outcome of GetHelpFile()
' IsMergeModule()				' Finds out if Merge Module Authoring view is open		
' OpenHelpToTopic()				' Page must also include ErrorHandler.vbs
' DisplayDemo()					' Page must also include ErrorHandler.vbs, 
'								  ProgIDName.h, and IHelpUtil.h
' LaunchSetupMap()				' Launches the setup map - requires IHelpUtil.h
' GoIntoIDE()					' Navigates to specified view in the IDE.
' CheckProject()				' use this to navigate to a view in the IDE that requires a project to be open, such as the Power Editor.
' ShowToolTip()					' Shows tooltip using wizard structure.
' BrowserVersion()				' Retrieves the major version number of MSIE.
' LaunchMSIHelp()				' Launch MSi Help
' LaunchDemo()					' Launch one of the demos
' IsBasicMSIProject()				' Determine if project is Basic MSI.
' IsStandardProject()			' Finds out if Project is Script based or not
' IsProProject()				' Finds out if Project is Pro type or not
' IsProObjectProject()				' Finds out if Project is Pro object type or not
' HideBasicMSIMergeModuleShowGen()		' Hides topics that pertain to Basic MSI and Merge Module projects.
' HideStandardMergeModuleShowGen()	' Hides stuff with StandardHelp Id
' HideStandardShowGen()				' Hides information with Standard span id and shows 
'						' information with Gen span id
' HideGenShowStandard()				' Hides information with Gen span id and shows 
'						' information with Standard span id
' HideNotProShowPro()				' Hides information with NotProHelp span id and shows 
'						' information with ProHelp span id
' HideProShowNotPro()				' Hides information with ProHelp span id and shows 
'						' information with NotProHelp span id
' HideNotProObjShowProObj()				' Hides information with NotProObjHelp span id and shows 
'						' information with ProObjHelp span id
' HideProObjShowNotProObj()				' Hides information with ProObjHelp span id and shows 
'						' information with NotProObjHelp span id
'////////////////////////////////////////////////////////////////////////

Option Explicit

	Dim m_objApp	' initialized in GetRefToApp()
	Dim m_objMain   ' initialized in GetRefToMain()

'///////////////////////////////////////////////////////////////////////
' See if we are in a page that gets a reference to pApp,
' meaning we're in the same process.
' Page must also include ErrorHandler.vbs
Function GetRefToApp ()
	on error resume next
	GetRefToApp = False
	Set m_objApp = AfxGetApp()
	If IsObject( m_objApp ) Then GetRefToApp = True 
End Function

'//////////////////////////////////////////////////////////////////////////////
' See if we are in a page that gets a reference to pApp,
' meaning it's in the same process.
' Page must also include ErrorHandler.vbs
Function GetRefToMain ()
	on error resume next
	GetRefToMain = False
	Set m_objMain = AfxGetMain()
	If IsObject( m_objMain ) Then GetRefToMain = True 
End Function

'//////////////////////////////////////////////////////////////////////////////
' Display information-only message box with ISWi as title
' Page must also include Resource_h.vbs
Sub MsgHelpOK( strMessage )
	Dim strTitle
	strTitle = GetProductName()
	msgBox strMessage, vbOKOnly + vbInformation, strTitle
End Sub

'//////////////////////////////////////////////////////////////////////////////
' Display message box with Yes and No options with ISWi as title
' Page must also include Resource_h.vbs
Function MsgHelpYN( strMessage )
	Dim strTitle
	strTitle = GetProductName()
	MsgHelpYN = msgBox (strMessage, vbYesNo + vbQuestion, strTitle)
End Function

'//////////////////////////////////////////////////////////////////////////////
' Retrieve string value from ISStringTables.dll
Function ISHelpLoadString(strID)
    Dim objStrMgr
    Set objStrMgr = CreateObject(ISSTRINGTABLES_CSTRINGLOADER())
    ISHelpLoadString = objStrMgr.LoadString(strID)
	Set objStrMgr = Nothing
End Function

'//////////////////////////////////////////////////////////////////////////////
' Get the full name of the product, e.g., InstallShield for Windows Installer
' Page must also include Resource_h.vbs
Function GetProductName()
	Dim strName
	If AfxGetApp.Edition = 1 Then
		strName = ISHelpLoadString( DISPLAYNAME_Express ) 
	ElseIf AfxGetApp.Edition = 2 Then
		strName = AfxGetMain.ProductName()
	End if
	GetProductName = strName
End Function

'//////////////////////////////////////////////////////////////////////////////
' Get the short name of the product, e.g., InstallShield
' Page must also include Resource_h.vbs
Function GetProductNameShort()
	Dim strName
	strName = ISHelpLoadString( DISPLAYNAME_ISPRODUCT ) 
	GetProductNameShort = strName
End Function

'//////////////////////////////////////////////////////////////////////////////
' Add (r) to InstallShield and Windows for first occurrence on a page.
' Page must also include Resource_h.vbs and IHelpUtil.h
'Function AddTradeMarks( strOrig )
'	
'	Dim strNew
'	Dim strIS
'	
'	strIS = GetProductNameShort()
'	
'	strNew = Replace ( strOrig, strIS, strIS & IHELP_HTMLCHAR_REG, 1, -1, vbTextCompare )
'	strNew = Replace ( strNew, IHELP_WINDOWS, IHELP_WINDOWS & IHELP_HTMLCHAR_REG, 1, -1, vbTextCompare )
'	
'	If strNew = Null Or strNew = ""	Then
'		strNew = strOrig
'	End If
'	
'	AddTradeMarks = strNew
'
'End Function

'//////////////////////////////////////////////////////////////////////////////
' See if there's a project open in the IDE.
' Make sure you test the return value of GetRefToMain() or GetRefToMain() 
' first to make sure you can get a reference to the app so this will work.
' Page must also include ErrorHandler.vbs
Function IsProjectLoaded()
	Dim objStore
	Set objStore = AfxGetStore()
	IsProjectLoaded = objStore.IsOpen()
End Function

'//////////////////////////////////////////////////////////////////////////////
' Get the user's path to <drive>\program files\installshield\<product name>
' by reading the App Paths key
Function GetMainPath()

	On Error Resume Next
	
	Dim objRegistry
	Dim nReturn, nLength
	Dim strDir

	Set objRegistry = CreateObject ("InstallShield.Registry.1")
    
    ' Hack to get it to work with ISX, too
    If objRegistry Is Nothing Then
        Set objRegistry = CreateObject ("ISExpInstallShield.Registry.1")
  	    nReturn = objRegistry.RegReadValue (2, "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ISIDE.EXE", "Path", 1, strDir)
	else
    	nReturn = objRegistry.RegReadValue (2, "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ISDEV.EXE", "Path", 1, strDir)
    End If	

	If nReturn < 0 Then
		GetMainPath = "C:\Program Files\InstallShield\Developer"
	Else
        nLength = len(strDir)      
        ' find second path (paths separated with semicolon)
        nReturn = InStr (strDir, ";")
        ' get path
        strDir = right (strDir, nLength - nReturn)
        nReturn = Instrrev (strdir, "\")
        strDir = left (strDir, nReturn - 1)
		GetMainPath = strDir
	End If

	Set objRegistry = Nothing

End Function
'//////////////////////////////////////////////////////////////////////////
Function GetHelpFile()

Dim nReturn
    Dim strLocation
    
    GetHelpFile = False
    strLocation = document.location
    
    nReturn = InStr (1, strLocation, "MMAuthor.chm", vbTextCompare)
    
    If nReturn > 0 Then 
        GetHelpFile = True
    End If

End Function 
'////////////////////////////////////////////////////////////////////////
'Hides Gen, BasicMSI & Standard Help and displays MergeModules Help
Sub HideAndShow()
    on error resume next
    Dim i, nLength

    MMAHelp.style.display = "inline"
    GenHelp.style.display = "none"
    StandardHelp.style.display = "none"
    BasicMSIHelp.style.display = "none"	

    nLength = document.all("MMAHelp").length
    for i = 0 to nLength - 1
        document.all("MMAHelp", i).style.display="inline"
    next

    nLength = document.all("GenHelp").length
    for i = 0 to nLength - 1
        document.all("GenHelp", i).style.display="none"
    next

    nLength = document.all("StandardHelp").length
    for i = 0 to nLength - 1
        document.all("StandardHelp", i).style.display="none"
    next

    nLength = document.all("BasicMSIHelp").length
    for i = 0 to nLength - 1
        document.all("BasicMSIHelp", i).style.display="none"
    next

End Sub

'////////////////////////////////////////////////////////////////////////
Sub HideStandardMergeModuleShowGen()
    on error resume next
    Dim i, nLength

    MMAHelp.style.display = "none"
    GenHelp.style.display = "inline"
    StandardHelp.style.display = "none"

    nLength = document.all("MMAHelp").length
    for i = 0 to nLength - 1
        document.all("MMAHelp", i).style.display="none"
    next

    nLength = document.all("GenHelp").length
    for i = 0 to nLength - 1
        document.all("GenHelp", i).style.display="inline"
    next

    nLength = document.all("StandardHelp").length
    for i = 0 to nLength - 1
        document.all("StandardHelp", i).style.display="none"
    next

End Sub

'////////////////////////////////////////////////////////////////////////
Sub HideBasicMSIMergeModuleShowGen()
    on error resume next
    Dim i, nLength

    MMAHelp.style.display = "none"
    GenHelp.style.display = "inline"
	BasicMSIHelp.style.display = "none"

    nLength = document.all("MMAHelp").length
    for i = 0 to nLength - 1
        document.all("MMAHelp", i).style.display="none"
    next

    nLength = document.all("GenHelp").length
    for i = 0 to nLength - 1
        document.all("GenHelp", i).style.display="inline"
    next

    nLength = document.all("BasicMSIHelp").length
    for i = 0 to nLength - 1
        document.all("BasicMSIHelp", i).style.display="none"
    next

End Sub


'////////////////////////////////////////////////////////////////////////
Sub HideStandardShowGen()
    on error resume next
    Dim i, nLength

    MMAHelp.style.display = "none"
    StandardHelp.style.display = "none"	
    GenHelp.style.display = "inline"

    nLength = document.all("GenHelp").length
    for i = 0 to nLength - 1
        document.all("GenHelp", i).style.display="inline"
    next

    nLength = document.all("StandardHelp").length
    for i = 0 to nLength - 1
        document.all("StandardHelp", i).style.display="none"
    next

End Sub


'////////////////////////////////////////////////////////////////////////
Sub HideGenShowStandard()
    on error resume next
    Dim i, nLength

    MMAHelp.style.display = "none"
    GenHelp.style.display = "none"
    StandardHelp.style.display = "inline"

    nLength = document.all("MMAHelp").length
    for i = 0 to nLength - 1
        document.all("MMAHelp", i).style.display="none"
    next

    nLength = document.all("GenHelp").length
    for i = 0 to nLength - 1
        document.all("GenHelp", i).style.display="none"
    next

    nLength = document.all("StandardHelp").length
    for i = 0 to nLength - 1
        document.all("StandardHelp", i).style.display="inline"
    next

End Sub

'////////////////////////////////////////////////////////////////////////
Sub HideNotProShowPro()
    on error resume next
    Dim i, nLength

    NotProHelp.style.display = "none"
    ProHelp.style.display = "inline"

    nLength = document.all("NotProHelp").length
    for i = 0 to nLength - 1
        document.all("NotProHelp", i).style.display="none"
    next

    nLength = document.all("ProHelp").length
    for i = 0 to nLength - 1
        document.all("ProHelp", i).style.display="inline"
    next

End Sub

'////////////////////////////////////////////////////////////////////////
Sub HideProObjShowNotProObj()
    on error resume next
    Dim i, nLength

    ProObjHelp.style.display = "none"
    NotProObjHelp.style.display = "inline"

    nLength = document.all("ProObjHelp").length
    for i = 0 to nLength - 1
        document.all("ProObjHelp", i).style.display="none"
    next

    nLength = document.all("NotProObjHelp").length
    for i = 0 to nLength - 1
        document.all("NotProObjHelp", i).style.display="inline"
    next

End Sub

'////////////////////////////////////////////////////////////////////////
Sub HideNotProObjShowProObj()
    on error resume next
    Dim i, nLength

    NotProObjHelp.style.display = "none"
    ProObjHelp.style.display = "inline"

    nLength = document.all("NotProObjHelp").length
    for i = 0 to nLength - 1
        document.all("NotProObjHelp", i).style.display="none"
    next

    nLength = document.all("ProObjHelp").length
    for i = 0 to nLength - 1
        document.all("ProObjHelp", i).style.display="inline"
    next

End Sub

'////////////////////////////////////////////////////////////////////////
Sub HideProShowNotPro()
    on error resume next
    Dim i, nLength

    ProHelp.style.display = "none"
    NotProHelp.style.display = "inline"

    nLength = document.all("ProHelp").length
    for i = 0 to nLength - 1
        document.all("ProHelp", i).style.display="none"
    next

    nLength = document.all("NotProHelp").length
    for i = 0 to nLength - 1
        document.all("NotProHelp", i).style.display="inline"
    next

End Sub

'////////////////////////////////////////////////////////////////////////

Function GetDefProjLocation()
    on error resume next
    Dim objRegistry
    Dim strDir, strLocation
    Dim nReturn
    
    strDir = ""
    
    Set objRegistry = CreateObject ("InstallShield.Registry.1")
    strLocation = "SOFTWARE\InstallShield\ISWI\2.0\Project Settings"

    ' Hack to get it to work with ISX, too
    If objRegistry Is Nothing Then
        Set objRegistry = CreateObject ("ISExpInstallShield.Registry.1")
        strLocation = "Software\InstallShield\Express\3.0\Project Settings"
    End If

    objRegistry.RegReadValue 1, strLocation, "Project Location", 1, strDir

    If strDir = "" Then
        GetDefProjLocation = "C:\&lt;WindowsFolder&gt;\Profiles\&lt;UserName&gt;\Personal\MySetups"
    Else
        GetDefProjLocation = strDir
    End If
    
    Set objRegistry = Nothing    
End Function 
'////////////////////////////////////////////////////////////////////////
Function IsMergeModule()
    On Error Resume Next
    IsMergeModule = False
    Dim nProjectType
    nProjectType = AfxGetMain().m_pVars.PackageType
    If nProjectType = 2 Then 
        IsMergeModule = True
    End If
end Function

'////////////////////////////////////////////////////////////////////////
Function IsStandardProject()
    On Error Resume Next
    IsStandardProject = False
    Dim nProjectType
    nProjectType = AfxGetMain().m_pVars.PackageType
    If nProjectType = 3 Then 
        IsStandardProject = True
    End If
end Function

'////////////////////////////////////////////////////////////////////////
Function IsBasicMSIProject()
    On Error Resume Next
    IsBasicMSIProject = False
    Dim nProjectType
    nProjectType = AfxGetMain().m_pVars.PackageType
    If nProjectType = 1 Then 
        IsBasicMSIProject = True
    End If
end Function

'////////////////////////////////////////////////////////////////////////
Function IsProProject()
    On Error Resume Next
    IsProProject = False
    Dim nProjectType
    nProjectType = AfxGetMain().m_pVars.PackageType
    If nProjectType = 11 Then 
        IsProProject = True
    End If
end Function

'////////////////////////////////////////////////////////////////////////
Function IsProObjectProject()
    On Error Resume Next
    IsProObjectProject = False
    Dim nProjectType
    nProjectType = AfxGetMain().m_pVars.PackageType
    If nProjectType = 12 Then 
        IsProObjectProject = True
    End If
end Function

'/////////////////////////////////////////////////////////////////////////
' Launch the current help file to the named help topic.
' This function will only work if you can get a reference to CApp inside the IDE
' or elsewhere.  
' It calls AfxGetApp inside ErrorHandler.vbs.
Sub OpenHelpToTopic( strFile )
    ' Cancel the normal behavior of clicking on an A tag (usu. # when code is involved)
    window.event.returnValue = False
    ' Call ShowHelp method in CApp
    AfxGetApp.ShowHelp strFile
End Sub

'/////////////////////////////////////////////////////////////////////////
Sub DisplayDemo(strDemoName, strFeatureName, bPromptUser)
    
    Dim objApp, objExecute, objRegistry
    Dim bInstalled
    Dim strPath, strDemoFile, HTMLPath
    
    ' See if we're in the IDE before getting CApp
    If GetRefToApp = True Then
        Set objApp = m_objApp
    Else
        Set objApp = CreateObject("ISApp.CApp")
    End If
    
    ' See if the user needs to be prompted to install demos if necessary
    bInstalled = True
    If bPromptUser Then
        bInstalled = objApp.InstallIfNeeded (strFeatureName, IHELP_DEMOS_PROMPTTEXT)
    End If

    ' Show the demo
    If bInstalled Then
        Set objExecute = CreateObject (PROGID_ISUTIL_FILE())
        HTMLPath = LanguageDir()
        strPath = GetMainPath()
        strDemoFile = HTMLPath & strDemoName & ".dbd"
        strPath = strPath & "\System"
        objExecute.ShowDemo strPath, " -c " & strDemoFile
    End If
    
    Set objExecute = Nothing
    Set objRegistry = Nothing
    Set objApp = Nothing
    
End Sub
'///////////////////////////////////////////////////////////////////////////////////////

sub LaunchSetupMap	
	window.event.returnvalue=False
    Dim l
    dim hWnd
    Set l = CreateObject("ISWI.Launcher")
    l.NotifyOnClose = False
    l.MinMaxButtons = True
    l.ShowWizard LanguageDir() & "SMap_FrameSet.htm", "Setup Map", 605, 435, hWnd
    l.SetVisible True
end sub

'////////////////////////////////////////////////////////////////////////////////////////
Sub GoIntoIDE ( strView )
    ' page must also link to ErrorHandler.vbs, IHelpUtil.h, and Resource_h.vbs
    On Error Resume Next
    window.event.returnvalue=False
    Dim objApp, objNav
    
    				
    If Not GetRefToApp() Then
        alert IHELP_ERROR_NOTINIDE
        Exit Sub
    End If
    
    Set objApp = m_objApp	
    Set objNav = objApp.GetNav()
    objNav.GoToNode strView
    AfxGetApp.FocusToIDE

End Sub
'///////////////////////////////////////////////////////////////////////////////////////////////

sub NewProject()

    Dim objApp, objOpen
    				
    If Not GetRefToApp() Then
        
        alert IHELP_ERROR_NOTINIDE
        Exit Sub
    End If
    
    Set objOpen = m_objApp.GetMain()
    objOpen.OnFileNew ()
end sub

'////////////////////////////////////////////////////////////////////////////////////////
sub CheckProject (strView)
dim MsgReturn
    window.event.returnvalue=false
    if GetRefToApp() then
        if IsProjectLoaded() then    
            GoIntoIDE strView
        else
           MsgReturn = MsgHelpYN( IHELP_ERROR_NOPROJECT )
                if MsgReturn = vbYes then
                    NewProject()
                    GoIntoIDE strView
                else 
                    Exit sub
                end if
        end if
     Else
     alert IHELP_ERROR_NOTINIDE
     end if
        
end sub

'////////////////////////////////////////////////////////////////////////////////
sub ShowToolTip( strLoc, intWidth, intHeight, strTitle )
'// strLoc = filename, intWidth=window width, intHeight= window height
'// strTitle = name on Title bar
    window.event.returnvalue=False
    Dim l
    dim hWnd
     hWnd = AfxGetApp.DlgParentHWND
    Set l = CreateObject("ISWI.Launcher")
    l.NotifyOnClose = False
    l.MinMaxButtons = True
    l.ShowWizard LanguageDir() & strLoc, strTitle, intWidth, intHeight, hWnd
    l.SetVisible True
end sub

'///////////////////////////////////////////////////////////////////////////////////////
' need to have errorhandler.vbs on page
Function LanguageDir()
    dim objApp
    If GetRefToApp = True Then
        Set objApp = m_objApp
    Else
        Set objApp = CreateObject("ISApp.CApp")
    End If
    LanguageDir = objApp.strHTMLDir
end Function

'///////////////////////////////////////////////////////////////////////////////////////
' Retrieves the major version number of the browser
Function BrowserVersion()
    Dim strVer
    Dim aBrowser

    aBrowser = Split (window.navigator.appVersion, ";", -1, 1)
    strVer = aBrowser(1)    
    strVer = Right (strVer, Len(strVer) - 5)
    BrowserVersion = Int(strVer)
End Function

'///////////////////////////////////////////////////////////////////////////////////
'launches msi.chm
'must have link to errorhandler.vbs
Sub LaunchMSIHelp(strTopic)
    window.event.returnvalue = False
    AfxGetApp.ShowHelp strTopic, 0, "msi.chm"
End Sub

'////////////////////////////////////////////////////////////////////////////////////
'strDemo is the name of the frameset page for the demo you want to launch (IDemoMM.htm)
'strName is the name on the toolbar
sub LaunchDemo (strDemo, strName)
    dim pLauncher
    dim hWnd
    window.event.returnvalue = False
    Set pLauncher = CreateObject("ISWI.Launcher")
    Set AfxGetApp.TempHelpObject = pLauncher
    pLauncher.NotifyOnClose = False
    pLauncher.MinMaxButtons = False
    pLauncher.ShowWizard LanguageDir() & strDemo, strName, 506, 540, hWnd
    pLauncher.SetVisible True
end sub

'//////////////////////////////////////////////////////////////////////////////////////

' Use this function only when it's necessary to reuse the window. Otherwise, 
' GiveFeedback should be used to open a new window.
' If iLeaveCurTopicBlank == 1, current topic will be left blank

Function GetFeedbackURL(iLeaveCurTopicBlank)

    window.event.returnvalue = False
    on error resume next
    dim objApp
    Dim objRegistry, strPlatform, strProcessorType, strAppVersion, strSystemLanguage
    Dim strProduct, strLocation, strVersion, strContextHelp, strView, nRAM
    dim strTemp, strTempSearch, strTempLength, strHelpTopic
    strTemp = document.url
    strTempSearch = instrrev(strTemp, "\", -1, 1)
    strTempLength = len(strTemp)

	If Not iLeaveCurTopicBlank = 1 Then
	    strHelpTopic = right(strTemp, strTempLength - strTempSearch)
	End If

    strProduct = "InstallShield Express"
    strVersion = ""
    Set objRegistry = CreateObject ("ISExpInstallShield.Registry.1")
    strLocation = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{598274B8-40A3-11D5-8BEC-006097C9A3ED}"
    objRegistry.RegReadValue 2, strLocation, "DisplayVersion", 1, strVersion 
    Set objRegistry = Nothing    
    strProcessorType = clientinformation.cpuclass
    strPlatform = clientinformation.platform
    strAppVersion = clientinformation.appversion
    strSystemLanguage = clientinformation.systemlanguage
    GetRefToApp()    
    Set objApp = m_objApp
    strContextHelp = m_objApp.GetHelpTopic 
    nRam = m_objApp.GetSystemMemory
    select case strContextHelp
            case "IHelpISXOrganizeYourSetup.htm"
                strView = "Organize Your Setup"
            case "IHelpISXSpecifyApplicationData.htm"
                strView = "Specify Application Data"
            case "IHelpISXTargetSystemConfiguration.htm"
                strView = "Configure the Target System"
            case "IHelpISXSetupAppearance.htm"
                strView = "Design the User Interface"
            case "IHelpISXSetupActions.htm"
                strView = "Define Sequences & Actions"
            case "IHelpISXOutput.htm"
                strView = "Prepare for Distribution"
            case "IHelpMarsAdvancedViews.htm"
                strView = "Advanced Views"
            case "IHelpISToday.htm"
                strView = "InstallShield Today"
            case "IhelpContents.htm"
                strView = "Help"
            case "IIDESetupBestPractices.htm"
                strView = "Best Practices"
            case "IHelpSetupProjects.htm"
                strView = "General Information"
            case "IHelpPathVariables.htm"
                strView = "Path Variables"
            case "IHelpPropertyManager.htm"
                strView = "Property Manager"
            case "IHelpDesignSetup.htm"
                strView = "Setup Design"
            case "IHelpFeatures.htm"
                strView = "Features"
            case "IHelpComponents.htm"
                strView = "Components"
            case "IHelpMergeModules.htm"
                strView = "Merge Module Details"
            case "IHelpSetupDestination.htm"
                strView = "Destination"
            case "IHelpISXFiles.htm"
                strView = "Files"
            case "IhelpMarsMergeModules.htm"
                strView = "Merge Modules"
            case "IHelpISXDependencies.htm"
                strView = "Dependencies"
            case "IHelpMarsShortcuts.htm"
                strView = "Shortcuts/Folders"
            case "IHelpMarsRegistry.htm"
                strView = "Registry"
            case "IHelpIsxODBCOverview.htm"
                strView = "ODBC Resources"
            case "IHelpISXINIFileChanges.htm"
                strView = "INI File Changes"
            case "IHelpEUDialogs.htm"
                strView = "Dialogs"
            case "IHelpISXBillboards.htm"
                strView = "Billboards"
            case "IHelpSequences.htm"
                strView = "Sequences"
            case "IHelpCustomActions.htm"
                strView = "Actions/Scripts"
            case "IHelpReleaseOverview.htm"
                strView = "Releases"
            case "IHelpISXDistributeRelease.htm"
                strView = "Distribute"
            case "IHelpMsiDbgOverview.htm"
                strView = "MSI Debugger"
            case "IHelpISXAlternateViews.htm"
                strView = "Alternate Views"
            case else
                strView = "Miscellaneous"
    end select 

	Dim strSerialNumber, strUser, strCompany
	Dim pAppSettings
	Set pAppSettings = CreateObject("ISExpWI.AppSettings")
	If Not pAppSettings Is Nothing Then
		strSerialNumber = pAppSettings.ProductID
		strUser = pAppSettings.RegOwner
		strCompany = pAppSettings.RegCompany
	End If

    GetFeedbackURL = "http://www.installshield.com/proddirect/process.asp?action=feedback&prod=XDPRF80353-B01" _ 
		& "&usr=" & strUser _
		& "&co=" & strCompany _
        & "&serial=" & strSerialNumber _
		& "&ver=" & strVersion _
		& "&view=" & strView _
		& "&CurTopic=" & strHelpTopic _
		& "&os=" & strPlatform _
		& "&ie=" & strAppVersion _
		& "&OSLang=" & strSystemLanguage _
		& "&Processor=" & strProcessorType _
		& "&ram=" & nRAM

	' Redirect asp will mangle url if %20 is not used.
	GetFeedbackURL = Replace(GetFeedbackURL, " ", "%20")
End Function

'//////////////////////////////////////////////////////////////////////////////////////
sub GiveFeedback
    window.event.returnvalue = False
    on error resume next
    dim objApp
    Dim objRegistry, strPlatform, strProcessorType, strAppVersion, strSystemLanguage
    Dim strProduct, strLocation, strVersion, strContextHelp, strView, nRAM
    dim strTemp, strTempSearch, strTempLength, strHelpTopic, FeedbackURL
    strTemp = document.url
    strTempSearch = instrrev(strTemp, "/", -1, 1)
    strTempLength = len(strTemp)
    strHelpTopic = right(strTemp, strTempLength - strTempSearch)
    strProduct = ""
    strVersion = ""
    Set objRegistry = CreateObject("ISProxy.Proxy") 
    objRegistry.ISCreateObject document, "Isutil.dll", "{CE730FB2-8BAE-11D1-B6A4-006097DF5F08}"
    strLocation = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A041CC14-868B-4D04-ABA0-3FA29BC7B487}"
    objRegistry.RegReadValue 2, strLocation, "DisplayName", 1, strProduct
    objRegistry.RegReadValue 2, strLocation, "DisplayVersion", 1, strVersion  
    strLocation = "SOFTWARE\InstallShield\Developer\9.0"
    objRegistry.RegReadValue 2, strLocation, "FeedbackURLLoc", 1, FeedbackURL
    Set objRegistry = Nothing
    strProcessorType = clientinformation.cpuclass
    strPlatform = clientinformation.platform
    strAppVersion = clientinformation.appversion
    strSystemLanguage = clientinformation.systemlanguage
    GetRefToApp()    
    Set objApp = m_objApp
    strContextHelp = m_objApp.GetHelpTopic 
    nRAM=0
    nRam = m_objApp.GetSystemMemory
    select case strContextHelp
            case "IHelpISXOrganizeYourSetup.htm"
                strView = "Organize Your Setup"
            case "IHelpISXSpecifyApplicationData.htm"
                strView = "Specify Application Data"
            case "IHelpISXTargetSystemConfiguration.htm"
                strView = "Configure the Target System"
            case "IHelpISXSetupAppearance.htm"
                strView = "Design the User Interface"
            case "IHelpISXSetupActions.htm"
                strView = "Define Sequences & Actions"
            case "IHelpISXOutput.htm"
                strView = "Prepare for Distribution"
            case "IHelpMarsAdvancedViews.htm"
                strView = "Advanced Views"
            case "IHelpISToday.htm"
                strView = "InstallShield Today"
            case "IhelpContents.htm"
                strView = "Help"
            case "IIDESetupBestPractices.htm"
                strView = "Best Practices"
            case "IHelpSetupProjects.htm"
                strView = "General Information"
            case "IHelpPathVariables.htm"
                strView = "Path Variables"
            case "IHelpPropertyManager.htm"
                strView = "Property Manager"
            case "IHelpDesignSetup.htm"
                strView = "Setup Design"
            case "IHelpFeatures.htm"
                strView = "Features"
            case "IHelpComponents.htm"
                strView = "Components"
            case "IHelpMergeModules.htm"
                strView = "Merge Module Details"
            case "IHelpSetupDestination.htm"
                strView = "Destination"
            case "IHelpISXFiles.htm"
                strView = "Files"
            case "IhelpMarsMergeModules.htm"
                strView = "Merge Modules"
            case "IHelpISXDependencies.htm"
                strView = "Dependencies"
            case "IHelpMarsShortcuts.htm"
                strView = "Shortcuts/Folders"
            case "IHelpMarsRegistry.htm"
                strView = "Registry"
            case "IHelpIsxODBCOverview.htm"
                strView = "ODBC Resources"
            case "IHelpISXINIFileChanges.htm"
                strView = "INI File Changes"
            case "IHelpEUDialogs.htm"
                strView = "Dialogs"
            case "IHelpISXBillboards.htm"
                strView = "Billboards"
            case "IHelpSequences.htm"
                strView = "Sequences"
            case "IHelpCustomActions.htm"
                strView = "Actions/Scripts"
            case "IHelpReleaseOverview.htm"
                strView = "Releases"
            case "IHelpISXDistributeRelease.htm"
                strView = "Distribute"
            case "IHelpMsiDbgOverview.htm"
                strView = "MSI Debugger"
            case "IHelpISXAlternateViews.htm"
                strView = "Alternate Views"
            case else
                strView = "Miscellaneous"
    end select 
    
    FeedbackURL = FeedbackURL + strVersion 
    FeedbackURL = FeedbackURL + "&CurView=" + strView + "&CurTopic=" + strHelpTopic + "&OSVersion=" + strPlatform + "&IEVersion="
    FeedbackURL = FeedbackURL + strAppVersion + "&OSLang=" + strSystemLanguage + "&Processor=" + strProcessorType + "&RAM=" + nRAM

Window.open FeedbackURL


end sub

Function IsAuthorRunning()
    On Error Resume Next
    IsAuthorRunning = False

    GetRefToApp()    
    IsAuthorRunning = m_objApp.IsAuthorRunning()
End Function