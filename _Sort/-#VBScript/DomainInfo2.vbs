Set objRootDSE = GetObject("LDAP://rootDSE")
 
strSchema = "LDAP://" & objRootDSE.Get("schemaNamingContext")
WScript.echo "ADsPath to schema: " & strSchema
Set objSchema = GetObject(strSchema)
WScript.Echo  "Schema Object:" & Vbcrlf & _
  "Name: " & objSchema.Name & Vbcrlf & _
  "Class: " & objSchema.Class & Vbcrlf
 
strConfiguration = "LDAP://" & objRootDSE.Get("configurationNamingContext")
WScript.Echo "ADsPath to configuration container: " & strConfiguration
Set objConfiguration = GetObject(strConfiguration)
WScript.Echo "Configuration Object:" & Vbcrlf & _
  "Name: " & objConfiguration.Name & Vbcrlf & _
  "Class: " & objConfiguration.Class & Vbcrlf
 
strDomain = "LDAP://" & objRootDSE.Get("defaultNamingContext")
WScript.Echo "ADsPath to current domain container: " & strDomain
Set objDomain = GetObject(strDomain)
WScript.Echo "Current Domain Object:" & Vbcrlf & _
  "Name: " & objDomain.Name & Vbcrlf & _
  "Class: " & objDomain.Class & Vbcrlf
 
strRootDomain = "LDAP://" & objRootDSE.Get("rootDomainNamingContext")
WScript.Echo "ADsPath to root domain container: " & strRootDomain
Set objRootDomain = GetObject(strRootDomain)
WScript.Echo "Root Domain Object:" & Vbcrlf & _
  "Name: " & objRootDomain.Name & Vbcrlf & _
  "Class: " & objRootDomain.Class & Vbcrlf

