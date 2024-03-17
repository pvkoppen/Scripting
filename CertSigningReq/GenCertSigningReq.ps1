 <#
.SYNOPSIS
GenCertSigningReq.ps1 

.DESCRIPTION 
This powershell script can be used to generate a Certificate Signing Request (CSR) using the SHA256 signature algorithm 
and a 2048 bit key size (RSA). Subject Alternative Names are supported.


.PARAMETER



.EXAMPLE
.\GenCertSigningReq.ps1 


.NOTES
Written by: Reinout Segers
Edited By: Drago Petrovic



Find me on:

* LinkedIn:	https://www.linkedin.com/in/drago-petrovic-86075730/
* Xing:     https://www.xing.com/profile/Drago_Petrovic
* Website:  https://blog.abstergo.ch
* GitHub:   https://github.com/MSB365
https://github.com/MSB365/GenCertSigningReq.ps1/blob/master/GenCertSigningReq.ps1

Change Log
v2.0
- Modified for working with Windows 10, Windows Server 2012 R2 and Windows Server 2016
v1.1
- Added support for Windows Server 2008R2 and PowerShell 2.0
v1.0
- initial version


--- keep it simple, but significant ---

.COPYRIGHT
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>


####################
# Prerequisite check
####################
if (-NOT([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Administrator priviliges are required. Please restart this script with elevated rights." -ForegroundColor Red
    Pause
    Throw "Administrator priviliges are required. Please restart this script with elevated rights."
}


#######################
# Setting the variables
#######################
$UID = [guid]::NewGuid()
$files = @{}
$files['settings'] = "$($env:TEMP)\$($UID)-settings.inf";
$files['csr'] = "$($env:TEMP)\$($UID)-csr.req"


$request = @{}
$request['SAN'] = @{}

Write-Host "keep it simple but significant" -ForegroundColor green
Write-Host "Enter the Certificate informations below" -ForegroundColor cyan
$request['CN'] = Read-Host "Common Name (e.g. company.com)"
$request['O'] = Read-Host "Organisation (e.g. Company Ltd)"
$request['OU'] = Read-Host "Organisational Unit (e.g. IT)"
$request['L'] = Read-Host "City (e.g. Amsterdam)"
$request['S'] = Read-Host "State (e.g. Noord-Holland)"
$request['C'] = Read-Host "Country (e.g. NL)"

###########################
# Subject Alternative Names
###########################
$i = 0
Do {
$i++
    $request['SAN'][$i] = read-host "Subject Alternative Name $i (e.g. alt.company.com / leave empty for none)"
    if ($request['SAN'][$i] -eq "") {
    
    }
    
} until ($request['SAN'][$i] -eq "")

# Remove the last in the array (which is empty)
$request['SAN'].Remove($request['SAN'].Count)

#########################
# Create the settings.inf
#########################
$settingsInf = "
[Version] 
Signature=`"`$Windows NT`$ 
[NewRequest] 
KeyLength =  2048
Exportable = TRUE 
MachineKeySet = TRUE 
SMIME = FALSE
RequestType =  PKCS10 
ProviderName = `"Microsoft RSA SChannel Cryptographic Provider`" 
ProviderType =  12
HashAlgorithm = sha256
;Variables
Subject = `"CN={{CN}},OU={{OU}},O={{O}},L={{L}},S={{S}},C={{C}}`"
[Extensions]
{{SAN}}


;Certreq info
;http://technet.microsoft.com/en-us/library/dn296456.aspx
;CSR Decoder
;https://certlogik.com/decoder/
;https://ssltools.websecurity.symantec.com/checker/views/csrCheck.jsp
"

$request['SAN_string'] = & {
	if ($request['SAN'].Count -gt 0) {
		$san = "2.5.29.17 = `"{text}`"
"
		Foreach ($sanItem In $request['SAN'].Values) {
			$san += "_continue_ = `"dns="+$sanItem+"&`"
"
		}
		return $san
	}
}

$settingsInf = $settingsInf.Replace("{{CN}}",$request['CN']).Replace("{{O}}",$request['O']).Replace("{{OU}}",$request['OU']).Replace("{{L}}",$request['L']).Replace("{{S}}",$request['S']).Replace("{{C}}",$request['C']).Replace("{{SAN}}",$request['SAN_string'])

# Save settings to file in temp
$settingsInf > $files['settings']

# Done, we can start with the CSR
Clear-Host

#################################
# CSR TIME
#################################

# Display summary
Write-Host "Certificate information
Common name: $($request['CN'])
Organisation: $($request['O'])
Organisational unit: $($request['OU'])
City: $($request['L'])
State: $($request['S'])
Country: $($request['C'])

Subject alternative name(s): $($request['SAN'].Values -join ", ")

Signature algorithm: SHA256
Key algorithm: RSA
Key size: 2048

" -ForegroundColor Yellow

certreq -new $files['settings'] $files['csr'] > $null

# Output the CSR
$CSR = Get-Content $files['csr']
Write-Output $CSR
Write-Host "
"

# Set the Clipboard (Optional)
Write-Host "Copy CSR to clipboard? (y|n): " -ForegroundColor Yellow -NoNewline
if ((Read-Host) -ieq "y") {
	$csr | clip
	Write-Host "Check your ctrl+v
"
}


########################
# Remove temporary files
########################
$files.Values | ForEach-Object {
    Remove-Item $_ -ErrorAction SilentlyContinue
}