' Set the ports for the Administration web site; 
'  3201 for the TCP port
'  3202 for the SSL port 
'

set WshShell = WScript.CreateObject("WScript.Shell")

' Stop IIS and it's dependents (/y) so we can write to the XML metabase. 
' No need to restart the service since machine will be rebooting later anyway.
'
WshShell.Run "net stop iisadmin /y", vbHide, True

metabase = WshShell.ExpandEnvironmentStrings("%WinDir%") & _
	"\system32\inetsrv\metabase.xml" 

set xmlDoc = CreateObject("Microsoft.XMLDOM")
xmlDoc.Async = False
xmlDoc.Load metabase

Set srvNode = xmlDoc.documentElement.selectSingleNode( _
	"MBProperty/IIsWebServer[@ServerComment='Administration']")

srvNode.SetAttribute "ServerBindings", ":3201:"
srvNode.SetAttribute "SecureBindings", ":3202:"

xmlDoc.Save metabase

