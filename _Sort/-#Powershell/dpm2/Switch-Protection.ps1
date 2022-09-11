param([string] $DPMServerName, [string] $PSName, [string] $ProtectionType, [string] $UserName, [string] $Password , [string] $Domain)

if(("-?","-help") -contains $args[0])
{
	write-host
    	write-host "Usage::"
	write-host "Switch-Protection.ps1 -DPMServerName [DPM Server] -PSName [Production server] -ProtectionType [primary/secondary] -Username [PS admin username] -Password [Password] -Domain [User domain]"
	write-host
	write-host "Run 'Switch-Protection.ps1 -detailed' for detailed help"
	write-host
	write-host
	exit 0
}
if(("-detailed") -contains $args[0])
{
	write-host
	write-host "Detailed Help :  Use this script for the following scenarios"
	write-host
	write-host "a) Recovery to original location from secondary DPM server or to switch protection of data sources to secondary DPM server"
	write-host "Example: Switch-Protection.ps1 -DPMServerName dpm2 -PSName ps1 -ProtectionType primary"
 	write-host "Note: The following actions will occur for the protected computer whose protection is being switched:"
	write-host "1). Protection jobs will fail on the primary DPM server"
	write-host "2). The status of all its data sources on the secondary DPM server will become Inactive"
	write-host
	write-host "b) Switch back protection of data sources to primary DPM server."
	write-host "1) Run the script on primary DPM computer with following parameters"
	write-host "Example: Switch-Protection.ps1 -DPMServerName dpm1 -PSName ps1 -ProtectionType primary"
	write-host "2) Run the script on secondary DPM computer with following parameters"
	write-host "Example: Switch-Protection.ps1 -DPMServerName dpm2 -PSName ps1 -ProtectionType secondary"
	write-host
	write-host
	exit 0
}

if(!$DPMServerName)
{
     $DPMServerName = read-host "DPMServerName:"
}
$dpmServer = Connect-DPMServer $DPMServerName
if (!$dpmServer)
{
    write-Error "Failed To Connect To DPM Server::$DPMServerName"
    exit 1
}
if(!$PSName)
{
	$PSName = read-host "ProductionServerName:"
}
	
Write-Verbose "Getting PS::$PSName for DPM: $DPMServerName"
$ps = Get-ProductionServer -DPMServerName $DPMServerName | where { ($_.machinename,$_.name) -contains $PSName } 
if(!$ps)
{
    write-Error "Could Not Find Production Server::$PSName"
    Disconnect-dpmserver
    exit 1
}

if(!$ProtectionType)
{
	$ProtectionType = read-host "ProtectionType:"
}
if($ProtectionType)
{
	if(("PRIMARY","PROTECTFROMPS") -contains $ProtectionType)
	{
		$ProtectionType = "ProtectFromPS"
	}
	elseIf (("SECONDARY","PROTECTFROMDPM") -contains $ProtectionType)
	{
		$ProtectionType = "ProtectFromDPM"
	}
	else
	{
		write-Error "Invalid Value::$ProtectionType For Parameter -ProtectionType[primary/secondary]"
		Disconnect-dpmserver
		exit 1
	}
}

if(!$UserName)
{
    $UserName =  read-host "UserName:"
}
if(!$Password)
{
    $Pwd = read-host "Password:" -assecurestring
}
else
{
    $Pwd = ConvertTo-SecureString $Password -asPlainText -force
}
if(!$Domain)
{
    $Domain = read-host "Domain:" 
}

	

Write-Verbose "Starting Switch Protection"


$error.clear()
Start-ProductionServerSwitchProtection $ps $ProtectionType $UserName $Pwd $Domain

if(!$error)
{
write-Host
Write-Host "Switch Protection Completed Successfully"
write-Host
Write-Host "If you have run this script on the primary DPM server, please run Consistency Check to successfully continue protection. If you have run this script on the secondary DPM server, please modify or create a protection group and add data sources to continue protection."
write-Host
}

Disconnect-dpmserver

# SIG # Begin signature block
# MIIbdgYJKoZIhvcNAQcCoIIbZzCCG2MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUAojzblC4QfNQOC+YVWcKzX+X
# BSygghYqMIIEEjCCAvqgAwIBAgIPAMEAizw8iBHRPvZj7N9AMA0GCSqGSIb3DQEB
# BAUAMHAxKzApBgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3NvZnQgQ29y
# cC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWlj
# cm9zb2Z0IFJvb3QgQXV0aG9yaXR5MB4XDTk3MDExMDA3MDAwMFoXDTIwMTIzMTA3
# MDAwMFowcDErMCkGA1UECxMiQ29weXJpZ2h0IChjKSAxOTk3IE1pY3Jvc29mdCBD
# b3JwLjEeMBwGA1UECxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQDExhN
# aWNyb3NvZnQgUm9vdCBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQCpAr3BcOY78k4bKJ+XeF4w6qKpjSVf+P6VTKO3/p2iID58UaKboo9g
# MmvRQmR57qx2yVTa8uuchhyPn4Rms8VremIj1h083g8BkuiWxL8tZpqaaCaZ0Dos
# vwy1WCbBRucKPjiWLKkoOajsSYNC44QPu5psVWGsgnyhYC13TOmZtGQ7mlAcMQgk
# FJ+p55ErGOY9mGMUYFgFZZ8dN1KH96fvlALGG9O/VUWziYC/OuxUlE6u/ad6bXRO
# rxjMlgkoIQBXkGBpN7tLEgc8Vv9b+6RmCgim0oFWV++2O14WgXcE2va+roCV/rDN
# f9anGnJcPMq88AijIjCzBoXJsyB3E4XfAgMBAAGjgagwgaUwgaIGA1UdAQSBmjCB
# l4AQW9Bw72lyniNRfhSyTY7/y6FyMHAxKzApBgNVBAsTIkNvcHlyaWdodCAoYykg
# MTk5NyBNaWNyb3NvZnQgQ29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJvb3QgQXV0aG9yaXR5gg8AwQCLPDyI
# EdE+9mPs30AwDQYJKoZIhvcNAQEEBQADggEBAJXoC8CN85cYNe24ASTYdxHzXGAy
# n54Lyz4FkYiPyTrmIfLwV5MstaBHyGLv/NfMOztaqTZUaf4kbT/JzKreBXzdMY09
# nxBwarv+Ek8YacD80EPjEVogT+pie6+qGcgrNyUtvmWhEoolD2Oj91Qc+SHJ1hXz
# UqxuQzIH/YIX+OVnbA1R9r3xUse958Qw/CAxCYgdlSkaTdUdAqXxgOADtFv0sd3I
# V+5lScdSVLa0AygS/5DW8AiPfriXxas3LOR65Kh343agANBqP8HSNorgQRKoNWob
# ats14dQcBOSoRQTIWjM4bk0cDWK3CqKM09VUP0bNHFWmcNsSOoeTdZ+n0qAwggRg
# MIIDTKADAgECAgouqxHcUP9cncvAMAkGBSsOAwIdBQAwcDErMCkGA1UECxMiQ29w
# eXJpZ2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwGA1UECxMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3Jp
# dHkwHhcNMDcwODIyMjIzMTAyWhcNMTIwODI1MDcwMDAwWjB5MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgQ29k
# ZSBTaWduaW5nIFBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALd5
# fdZds0U5qDSsMdr5JTVJd8D7H57HRXHv0Ubo1IzDa0xSYvSZAsNN2ElsLyQ+Zb/O
# I7cLSLd/dd1FvaqPDlDFJSvyoOcNIx/RQST6YpnPGUWlk0ofmc2zLyLDSi18b9kV
# HjuMORA53b0p9GY7LQEy//4nSKa1bAGHnPu6smN/gvlcoIGEhY6w8riUo884plCF
# FyeHTt0w9gA99Mb5PYG+hu1sOacuNPa0Lq8KfWKReGacmHMNhq/yxPMguU8SjWPL
# LNkyRRnuu0qWO1BTGM5mUXmqrYfIVj6fglCIbgWxNcF7JL1SZj2ZTswrfjNuhEcG
# 0Z7QSoYCboYApMCH31MCAwEAAaOB+jCB9zATBgNVHSUEDDAKBggrBgEFBQcDAzCB
# ogYDVR0BBIGaMIGXgBBb0HDvaXKeI1F+FLJNjv/LoXIwcDErMCkGA1UECxMiQ29w
# eXJpZ2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwGA1UECxMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3Jp
# dHmCDwDBAIs8PIgR0T72Y+zfQDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTM
# Hc52AHBbr/HaxE6aUUQuo0Rj8DALBgNVHQ8EBAMCAYYwCQYFKw4DAh0FAAOCAQEA
# e6uufkom8s68TnSiWCd0KnWzhv2rTJR4AE3pyusY3GnFDqJ88wJDxsqHzPhTzMKf
# vVZv8GNEqUQA7pbImtUcuAufGQ2U19oerSl97+2mc6yP3jmOPZhqvDht0oivI/3f
# 6dZpCZGIvf7hALs08/d8+RASLgXrKZaTQmsocbc4j+AHDcldaM29gEFrZqi7t7uO
# NMryAxB8evXS4ELfe/7h4az+9t/VDbNw1pLjT7Y4onwt1D3bNAtiNwKfgWojifZc
# Y4+wWrs512CMVYQaM/U7mKCCDKJfi7Mst6Gly6vaILa/MBmFIBQNKrxS9EHgXjDj
# kihph8Fw4vOnq86AQnJ2DjCCBGowggNSoAMCAQICCmEPeE0AAAAAAAMwDQYJKoZI
# hvcNAQEFBQAweTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
# BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEj
# MCEGA1UEAxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EwHhcNMDcwODIzMDAy
# MzEzWhcNMDkwMjIzMDAzMzEzWjB0MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29ycG9yYXRpb24wggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCi2wqNz8LBSZvNqjo0rSNZa9tsviEi
# t5TI6q6/xtUmwjIRi7zaXSz7NlYeFSuujw3dFKNuKEx/Fj9BrI1AsUaIDdmBlK2X
# BtBXRHZc6vH8DuJ/dKMzy3Tl7+NhoX4Dt0X/1T4S1bDKXg3Qe/K3Ew38YGoohXWM
# t628hegXtJC+9Ra2Yl3tEd867iFbi6+Ac8NF45WJd2Cb5613wTeNMxQvE9tiya4a
# qU+YZ63UIDkwceCNZ0bixhz0DVB0QS/oBSRqIWtJsJLEsjnHQqVtXBhKq4/XjoM+
# eApH2KSyhCPD4vJ7ZrFKdL0mQUucYRRgTjDIgvPQC3B87lVNd9IIVXaBAgMBAAGj
# gfgwgfUwDgYDVR0PAQH/BAQDAgbAMB0GA1UdDgQWBBTzIUCOfFH4VEuY5RfXaoM0
# BS4m6DATBgNVHSUEDDAKBggrBgEFBQcDAzAfBgNVHSMEGDAWgBTMHc52AHBbr/Ha
# xE6aUUQuo0Rj8DBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLm1pY3Jvc29m
# dC5jb20vcGtpL2NybC9wcm9kdWN0cy9DU1BDQS5jcmwwSAYIKwYBBQUHAQEEPDA6
# MDgGCCsGAQUFBzAChixodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRz
# L0NTUENBLmNydDANBgkqhkiG9w0BAQUFAAOCAQEAQFdvU2eeIIM0AQ7mF0s8revY
# gX/uDXl0d0+XRxjzABVpfttikKL9Z6Gc5Cgp+lXXmf5Qv14Js7mm7YLzmB5vWfr1
# 8eEM04sIPhYXINHAtUVHCCZgVwlLlPAIzLpNbvDiSBIoNYshct9ftq9pEiSU7uk0
# Cdt+bm+SClLKKkxJqjIshuihzF0mvLw84Fuygwu6NRxPhEVH/7uUoVkHqZbdeL1X
# f6WnTszyrZyaQeLLXCQ+3H80R072z8h7neu2yZxjFFOvrZrv17/PoKGrlcp6K4cs
# wMfZ/GwD2r84rfHRXBkXD8D3yoCmEAga3ZAj57ChTD7qsBEmeA7BLLmka8ePPDCC
# BJ0wggOFoAMCAQICCmFHUroAAAAAAAQwDQYJKoZIhvcNAQEFBQAweTELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEjMCEGA1UEAxMaTWljcm9zb2Z0
# IFRpbWVzdGFtcGluZyBQQ0EwHhcNMDYwOTE2MDE1MzAwWhcNMTEwOTE2MDIwMzAw
# WjCBpjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEnMCUGA1UE
# CxMebkNpcGhlciBEU0UgRVNOOkQ4QTktQ0ZDQy01NzlDMScwJQYDVQQDEx5NaWNy
# b3NvZnQgVGltZXN0YW1waW5nIFNlcnZpY2UwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQCbbdyGUegyOzc6liWyz2/uYbVB0hg7Wp14Z7r4H9kIVZKIfuNB
# U/rsKFT+tdr+cDuVJ0h+Q6AyLyaBSvICdnfIyan4oiFYfg29Adokxv5EEQU1OgGo
# 6lQKMyyH0n5Bs+gJ2bC+45klprwl7dfTjtv0t20bSQvm08OHbu5GyX/zbevngx6o
# U0Y/yiR+5nzJLPt5FChFwE82a1Map4az5/zhwZ9RCdu8pbv+yocJ9rcyGb7hSlG8
# vHysLJVql3PqclehnIuG2Ju9S/wnM8FtMqzgaBjYbjouIkPR+Y/t8QABDWTAyaPd
# D/HI6VTKEf/ceCk+HaxYwNvfqtyuZRvTnbxnAgMBAAGjgfgwgfUwHQYDVR0OBBYE
# FE8YiYrSygB4xuxZDQ/9fMTBIoDeMB8GA1UdIwQYMBaAFG/oTj+XuTSrS4aPvJzq
# rDtBQ8bQMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNv
# bS9wa2kvY3JsL3Byb2R1Y3RzL3RzcGNhLmNybDBIBggrBgEFBQcBAQQ8MDowOAYI
# KwYBBQUHMAKGLGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvdHNw
# Y2EuY3J0MBMGA1UdJQQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIGwDANBgkq
# hkiG9w0BAQUFAAOCAQEANyce9YxA4PZlJj5kxJC8PuNXhd1DDUCEZ76HqCra3LQ2
# IJiOM3wuX+BQe2Ex8xoT3oS96mkcWHyzG5PhCCeBRbbUcMoUt1+6V+nUXtA7Q6q3
# P7baYYtxz9R91Xtuv7TKWjCR39oKDqM1nyVhTsAydCt6BpRyAKwYnUvlnivFOlSs
# pGDYp/ebf9mpbe1Ea7rc4BL68K2HDJVjCjIeiU7MzH6nN6X+X9hn+kZL0W0dp33S
# vgL/826C84d0xGnluXDMS2WjBzWpRJ6EfTlu/hQFvRpQIbU+n/N3HI/Cmp1X4Wl9
# aeiDzwJvKiK7NzM6cvrWMB2RrfZQGusT3jrFt1zNszCCBJ0wggOFoAMCAQICEGoL
# mU/AACWrEdtFH1h6Z6IwDQYJKoZIhvcNAQEFBQAwcDErMCkGA1UECxMiQ29weXJp
# Z2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwGA1UECxMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSEwHwYDVQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3JpdHkw
# HhcNMDYwOTE2MDEwNDQ3WhcNMTkwOTE1MDcwMDAwWjB5MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3NvZnQgVGltZXN0
# YW1waW5nIFBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANw3bvuv
# yEJKcRjIzkg+U8D6qxS6LDK7Ek9SyIPtPjPZSTGSKLaRZOAfUIS6wkvRfwX473W+
# i8eo1a5pcGZ4J2botrfvhbnN7qr9EqQLWSIpL89A2VYEG3a1bWRtSlTb3fHev5+D
# x4Dff0wCN5T1wJ4IVh5oR83ZwHZcL322JQS0VltqHGP/gHw87tUEJU05d3QHXcJc
# 2IY3LHXJDuoeOQl8dv6dbG564Ow+j5eecQ5fKk8YYmAyntKDTisiXGhFi94vhBBQ
# svm1Go1s7iWbE/jLENeFDvSCdnM2xpV6osxgBuwFsIYzt/iUW4RBhFiFlG6wHyxI
# zG+cQ+Bq6H8mjmsCAwEAAaOCASgwggEkMBMGA1UdJQQMMAoGCCsGAQUFBwMIMIGi
# BgNVHQEEgZowgZeAEFvQcO9pcp4jUX4Usk2O/8uhcjBwMSswKQYDVQQLEyJDb3B5
# cmlnaHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0
# eYIPAMEAizw8iBHRPvZj7N9AMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRv
# 6E4/l7k0q0uGj7yc6qw7QUPG0DAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAQEA
# lE0RMcJ8ULsRjqFhBwEOjHBFje9zVL0/CQUt/7hRU4Uc7TmRt6NWC96Mtjsb0fus
# p8m3sVEhG28IaX5rA6IiRu1stG18IrhG04TzjQ++B4o2wet+6XBdRZ+S0szO3Y7A
# 4b8qzXzsya4y1Ye5y2PENtEYIb923juasxtzniGI2LS0ElSM9JzCZUqaKCacYIoP
# O8cTZXhIu8+tgzpPsGJY3jDp6Tkd44ny2jmB+RMhjGSAYwYElvKaAkMve0aIuv8C
# 2WX5St7aA3STswVuDMyd3ChhfEjxF5wRITgCHIesBsWWMrjlQMZTPb2pid7oZjeN
# 9CKWnMywd1RROtZyRLIj9jGCBLYwggSyAgEBMIGHMHkxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xIzAhBgNVBAMTGk1pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBAgphD3hNAAAAAAADMAkGBSsOAwIaBQCggeEwGQYJKoZIhvcNAQkD
# MQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJ
# KoZIhvcNAQkEMRYEFOjo8x+/7i1ZHeB+6BSPeVZxnkNiMIGABgorBgEEAYI3AgEM
# MXIwcKBOgEwATQBpAGMAcgBvAHMAbwBmAHQAIABEAGEAdABhACAAUAByAG8AdABl
# AGMAdABpAG8AbgAgAE0AYQBuAGEAZwBlAHIAIAAyADAAMAA3oR6AHGh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9EUE0wDQYJKoZIhvcNAQEBBQAEggEAUuXlYZ8NBq3W
# zOzhLn75iYR4Khf36BR2bntQc12HnJs6HEIbRf0//YaOMoLCvZTgEmoI5kV5kCm/
# rU/AWFeRY5vlj+ERfRflC3zJs/oy/GmPRY4Gk+3YTYatLuKVPhg59bcYxsWAy7l2
# 4OBda10fXf9yU1ViHJpim15vEMxVkBDHfEbc5i1YKHfAHzk+WoeKfjt+XeK2nXaK
# NhW4mNPEPgCJQTjmgYcNhCkG10fG677c/OW6BEwvgrAxM2odkCA/rAz0X9qMjNNY
# qFCJpOPhKLXhMK8HXGNdbinRRHrHq3ojUTmElLzAdk7nZSmoh4RHIUqwOEry7IS4
# 5+ERxoQUxKGCAh8wggIbBgkqhkiG9w0BCQYxggIMMIICCAIBATCBhzB5MQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3Nv
# ZnQgVGltZXN0YW1waW5nIFBDQQIKYUdSugAAAAAABDAHBgUrDgMCGqBdMBgGCSqG
# SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MTIwOTAwNDY1
# OFowIwYJKoZIhvcNAQkEMRYEFEU94H0yRzudhaLaQ4+PonFh1xJhMA0GCSqGSIb3
# DQEBBQUABIIBAHCT+zqQMRidEdiF15pLUE+Q9AGMmNnq0njkPbjlCA3NctK5On06
# VQWcgh7vOFk4jDykrUwfEj5C+V/IR7wCRobDgx6/J0kNQJ44dX3XUBS/XM5kEGNO
# B1rFfliB28L23tQPogQw0cINS8BcMnJdMWh9q5IWZLrrB/fxG/LL2kUjqGXD8DWM
# yQ6t3q7f5Pr+9mlFRPyetNuaboULk3cCexfWmvOZOIk2xtXc99uk5NGAW2apDCbJ
# J+InHUiPiHC7FZn3WCKKPFjecrsFcINrFIlC1Ougr9m0o4JyzagUYf9hkIdgljD1
# fILrZ8A6tly0b/VMaX18IcVhfsre/yQkSDY=
# SIG # End signature block
