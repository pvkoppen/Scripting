Option Explicit

'//////////////////////////////////////////////////////////////////////////////
Sub Window_OnError(message, url, line)

    On Error Resume Next
    ' Don't use ProgIDName.h, to minimize file dependencies
    Dim pFileSys
    Set pFileSys = CreateObject("ISProxy.Proxy")
	pFileSys.ISCreateObject document, "Isutil.dll", "{A5CF09AF-F2FC-4E5D-9F7D-419D28130E62}"
    pFileSys.LogError message, url, line

    window.event.returnValue = True

End Sub

'//////////////////////////////////////////////////////////////////////////////
Function AfxGetApp()
    Dim pObjMgr
    Set pObjMgr = CreateObject("ISProxy.Proxy")
	pObjMgr.ISCreateObject document, "Isobjmgr.dll", "{DE5FBA5D-8AB0-4a53-B620-F2065702D228}"
    Set AfxGetApp = pObjMgr.pApp
End Function

'//////////////////////////////////////////////////////////////////////////////
Function AfxGetMain()
    Set AfxGetMain = AfxGetApp.GetMain
End Function

'//////////////////////////////////////////////////////////////////////////////
Function AfxGetStore()
    Set AfxGetStore = AfxGetMain.m_pStore
End Function

'//////////////////////////////////////////////////////////////////////////////
Function AfxGetDB()
    Set AfxGetDB = AfxGetStore.hDb
End Function

'//////////////////////////////////////////////////////////////////////////////
Function AfxGetProject()
    Set AfxGetProject = AfxGetStore.Project
End Function

'//////////////////////////////////////////////////////////////////////////////
Sub PopAndShow()
End Sub
