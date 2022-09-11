servername = "localhost"
 set wmi = getobject("winmgmts://" & servername)
 StopService ("Microsoft Exchange System Attendant")
 StopService ("IIS Admin Service")
 StopService ("Netlogon")

Sub StopService (ServiceName)
         wql = "select state from win32_service " _
               & "where displayname='"& ServiceName & "'"
         set results = wmi.execquery(wql)
         for each service in results
            if service.state = "Running" then
             service.stopService
            end if
          next
End Sub

