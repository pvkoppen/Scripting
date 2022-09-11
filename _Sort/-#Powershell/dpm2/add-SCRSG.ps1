#This script adds SCR data source (ExchangeDataSourceConfig) to the PSExchangeDatasourceConfig.xml in DPM installation folder.

param([string] $source, [string] $sgName, [Int] $sizeInMB, [string] $target, [boolean] $isCluster=$false)


if(("-?","-help") -contains $args[0])
{
   write-host 
   write-host "Usage::"
   write-host "add-SCRSG.ps1  <SCR source FQDN>  <Storage Group Name>  <Size in MB> <target FQDN>  <is cluster>"
   write-host "where target FQDN for cluster is <Resource Group Name>.<Cluster Name>.<Domain>"
   write-host  
   write-host "Example (Clustered server): "
   write-host "add-SCRSG.ps1 MBS.dpmv2.office testSG 1024 MBS.SCRTARGETCLUSTER.dpmv2.office `$true"
   write-host 
   write-host
   write-host "Example (Standalone Server): "
   write-host "add-SCRSG.ps1 SCRSource.dpmv2.office testSG 1024 SCRTarget.dpmv2.office `$false"
   write-host 
   write-host
   exit 0;
}


&{
	if(!$source)
	{
		$source = Read-host "Exchange SCR source Fully Qulaified Domain Name"
	}

	$sourceExchangeServer = Get-ExchangeServer -Identity $source
	if(!$sourceExchangeServer) 
	{
		write-host -foregroundcolor Red "Exchange Server $source not found "
	        exit 1;
	}
	$source = $sourceExchangeServer.Fqdn


	if(!$target) 
	{
		$target = Read-host "Exchange SCR target Fully Qulaified Domain Name"
	}

	# For cluster MBS doesnot exist before activation. Validate it for standalone.
	if(!$isCluster)
	{
		$targetExchangeServer = Get-ExchangeServer -Identity $target
		if(!$targetExchangeServer) 
		{
			write-host -foregroundcolor Red "Exchange Server $target not found "
		        exit 1;
		}
		$target = $targetExchangeServer.Fqdn
	}


	if($isCluster) 
	{
		$clusterName = @($target.split("."))[1]

		$clustersList = `cluster /List`
		# Output of cluster command has header "Cluster Name". Ignore it..
	        $null, $clustersList = $clustersList
        	$found = $false
		for($i=0; $i -lt $clustersList.count; $i++) 
		{
			$cName = $clustersList[$i].Trim()
			if($cName -ieq $clusterName) 
			{
				$clusterName = $cName
				$found = $true
				break;
			}
		}
		
		if(!$found) 
		{
			write-host -foregroundcolor Red "Cluster, $clusterName, not found!!!"
			exit 1;
		}  

		$resourceGroupName =  @($target.split("."))[0]

		$resourceGroupList = `cluster /cluster:$clusterName GROUP `

	        $found = $false
		for($i=0; $i -lt $resourceGroupList.count; $i++) 
		{
			if($($resourceGroupList[$i].length) -gt $resourceGroupName.length)
			{
	 			$actualResourceGroupName = $resourceGroupList[$i].substring(0,$resourceGroupName.length)
		
				if($actualResourceGroupName -ieq $resourceGroupName) 
				{
					$resourceGroupName = $actualResourceGroupName
					write-host "RG found $resourceGroupName"
					$found = $true;
					break;
				}
			}
		}
		if(!$found)
		{
			write-host -foregroundcolor Red "Resource Group , $resourceGroupName, not found on SCR Target!!!"
			write-host -foregroundcolor Red "You need to created a resourcegroup on SCR Target with same name as that of source before SCR Target protection"
			write-host -foregroundcolor Red "For more details read DPM document for SCR support"
          		exit 1;
		}
	     
		$null,$null,$domainName =  @($target.split("."))
		$target = $resourceGroupName + "." + $clusterName + "."	+ [string]::join(".",$domainName)
	}


	if(!$sgName) 
	{
		$sgName = Read-Host "Storage group name"
	}

	$sg = Get-StorageGroup -identity $source\$sgName 
	if(!$sg) 
	{
		write-host -foregroundcolor Red "Storage Group $sgName not found on server $source"
	        exit 1;
	}

	if(!$sizeInMB) 
	{
		$sizeInMB = Read-Host "Storage group size in MB"
	}

	if($sizeInMB -le 0)
	{
		write-host -foregroundcolor Red "Invalid storage Group size: $sizeInMB "
	        exit 1;

	}

	$regPath = "HKLM:\SOFTWARE\MICROSOFT\MICROSOFT DATA PROTECTION MANAGER\SETUP"
	$reg = Get-ItemProperty $regPath
	if($reg -eq $null) 
	{
		write-host -foregroundcolor Red "DPM agent is not installed on this server. Install DPM agent and run this script."
		exit 1;
	}
	$configFileName = "PSExchangeDataSourceConfig.xml"
	$configFilePath = Join-Path -path $reg.InstallPath -childPath "Datasources" 
	$configFilePath = Join-Path -path $configFilePath -childPath $configFileName 
	$writerId = "76fe1ac4-15f7-4bcd-987e-8e1acb462fb7";

	# In case of cluster, CMS may not be available on SCR Target. Get version number from source in that case.
	if($isCluster) 
	{
		$version = $sourceExchangeServer.AdminDisplayVersion.Major.tostring() + "." + $sourceExchangeServer.AdminDisplayVersion.Minor.tostring() + "."  + $sourceExchangeServer.AdminDisplayVersion.Build.tostring() + "."  + $sourceExchangeServer.AdminDisplayVersion.Revision.tostring()
		$logicalPath = @($source.split("."))[0]
	}
	else {       
		$version = $targetExchangeServer.AdminDisplayVersion.Major.tostring() + "." + $targetExchangeServer.AdminDisplayVersion.Minor.tostring() + "."  + $targetExchangeServer.AdminDisplayVersion.Build.tostring() + "."  + $targetExchangeServer.AdminDisplayVersion.Revision.tostring()
		$logicalPath = @($target.split("."))[0]
	}

	$isVssInvolved = "false"


	$db = Get-MailboxDatabase -StorageGroup $source\$sgName 
	if(!$db) 
	{
	   $db = Get-PublicFolderDatabase -StorageGroup $source\$sgName 
	}
	if(!$db)
	{
	   write-host -foregroundcolor Red "There is neither mailbox database nor public folder database associated with storage group $serverIdentity\$sgName"
	   exit 1;
	}
	$edbFilePath = $db.EdbFilePath.tostring()
	$logFiles = Join-Path -path  $sg.LogFolderPath.ToString() -childPath "*.log"
	$systemFiles = Join-Path -path  $sg.SystemFolderPath.ToString()  -childPath "*.chk"
	if($isCluster)
	{
		$sgGUID = $sg.Guid.ToString()
	} 
	else 
	{
		$tsg = Get-StorageGroup -identity $target\$sgName 
		if(!$tsg) 
		{
			write-host -foregroundcolor Red "Storage Group $sgName not found on server $target"
		        exit 1;
		}
		$sgGUID = $tsg.Guid.ToString()

		$db = Get-MailboxDatabase -StorageGroup $target\$sgName 
	        if($db)
		{
			Set-MailboxDatabase -Instance $db -MountAtStartup $false
		} 
		else
		{
			$db = Get-PublicFolderDatabase -StorageGroup $target\$sgName 
			if ($db)
			{
				Set-PublicFolderDatabase -Identity $db -MountAtStartup $false
			}
		}
		if(!$db)
		{
		   write-host -foregroundcolor Red "There is neither mailbox database nor public folder database associated with storage group $target\$sgName"
		   exit 1;
		}
		
		write-host -foregroundcolor Yellow "Database $($db.identity) needs to be dismounted."
		$confirmation = read-host "Do you want to continue dismounting (Y/N)?"
		if($confirmation -ine "Y") 
		{
			exit 1;
		}

		Dismount-Database -Identity $db -Confirm:0

	}
	$size = $sizeInMB
	$UseDRWithCC = "false"

	$standbyMachineName = $env:computername + "." + $env:userdnsdomain

	if(Test-Path $configFilePath) 
	{
		$psDSConfigDoc = [xml](GEt-content $configFilePath)
	        if(!$psDSConfigDoc) 
		{
			write-host -foregroundcolor Red "Failed to read data source config file $configFilePath."
			write-host -foregroundcolor Red "Either there is no data or the data is not in proper xml file format."
		        exit 1;
		}
	} 
	else 
	{
		write-host -foregroundcolor Yellow "There is no $configFilePath file. Creating new file"
		$null = New-Item -ItemType file $configFilePath 
		$psDSConfigDoc = [xml] ("<PSDatasourcesConfig xmlns:xsi=`"http://www.w3.org/2001/XMLSchema-instance`"  xmlns:xsd=`"http://www.w3.org/2001/XMLSchema`"  xmlns=`"http://schemas.microsoft.com/2003/dls/PSDatasourceConfig.xsd`"> </PSDatasourcesConfig>"
)
       }

	if(!($psDSConfigDoc.PSDataSourcesConfig)) 
	{
	   Write-host "$configFilePath file is not in the proper format"
	   exit 1;
	}

	##   Check if the SG already exists
	$exDSConfigList = @($psDSConfigDoc.PSDataSourcesConfig.ExchangeDatasourceConfig)
	if($exDSConfigList) 
	{
		foreach($exDS in $exDSConfigList) 
		{
			if($exDS.ComponentName -ieq $sgGUID) 
			{
				write-host -foregroundcolor Red "Data source already exists in $configFilePath with Source: $($exDS.SourceServer) Target: $($exDS.TargetServer) and SgName: $($exDS.Caption)"                   
				write-host -foregroundcolor Red "To update properties, remove and add the SG."
		                exit 1.         			

			} 
		}
	}

	$e_exDSConfig = $psDSConfigDoc.CreateElement("ExchangeDatasourceConfig")
	$DSProperty = @{}

	$DSProperty["WriterId"] = $writerId
	$DSProperty["Version"] = $version
	$DSProperty["VssWriterInvolved"] = $isVssInvolved
	$DSProperty["LogicalPath"] = $logicalPath
	$DSProperty["ComponentName"] = $sgGUID
	$DSProperty["FilesToProtect"] = @($edbFilePath, $logFiles, $systemFiles)
	$DSProperty["Size"] = $size
	$DSProperty["UseDRWithCC"] = $UseDRWithCC
	$DSProperty["SourceServer"] = $source
	$DSProperty["TargetServer"] = $target
	$DSProperty["StandbyMachine"] = $standbyMachineName
	$DSProperty["IsClustered"] = $isCluster.ToString().tolower();
	$DSProperty["Caption"] = $sg.Name

	foreach($property in @("WriterId", "Version", "VssWriterInvolved", "LogicalPath", "ComponentName", "FilesToProtect", "Size", "UseDRWithCC", "SourceServer", "TargetServer", "StandbyMachine", "IsClustered", "Caption")) 
	{
	    $valueSet = @($DSProperty[$property])
	    foreach($value in $valueSet) 
	    {
		$ne= $psDSConfigDoc.CreateElement($property)
		$ne.psbase.InnerText = $value
		$null = $e_exDSConfig.AppendChild($ne)
	    }
	}
	$null = $psDSConfigDoc.PSDataSourcesConfig.AppendChild($e_exDSConfig)
	$fullConfigFilePath =Convert-Path -literal $configFilePath
	write-host "Saving $fullConfigFilePath"
	$psDSConfigDoc.save($fullConfigFilePath)
	$configText = get-content $fullConfigFilePath
	$configText -replace 'xmlns=""','' | set-content $fullConfigFilePath
}
trap [Exception] 
{
      Write-Host "Script failed because $_"
      exit 1;
}


# SIG # Begin signature block
# MIIbdgYJKoZIhvcNAQcCoIIbZzCCG2MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUw8QpSeTmNyEl3uMS3P4BhVys
# z+GgghYqMIIEEjCCAvqgAwIBAgIPAMEAizw8iBHRPvZj7N9AMA0GCSqGSIb3DQEB
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
# BJ0wggOFoAMCAQICCmFJfO0AAAAAAAUwDQYJKoZIhvcNAQEFBQAweTELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEjMCEGA1UEAxMaTWljcm9zb2Z0
# IFRpbWVzdGFtcGluZyBQQ0EwHhcNMDYwOTE2MDE1NTIyWhcNMTEwOTE2MDIwNTIy
# WjCBpjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEnMCUGA1UE
# CxMebkNpcGhlciBEU0UgRVNOOjEwRDgtNTg0Ny1DQkY4MScwJQYDVQQDEx5NaWNy
# b3NvZnQgVGltZXN0YW1waW5nIFNlcnZpY2UwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQDqugVjyNl5roREPqWzxO1MniTfOXYeCdYySlh40ivZpQeQ7+c9
# +70mfKP75X1+Ms/ZPYs5N/L42Ds0FtSSgvs07GiFchqP4LhM4LiF8zMKAsGidnM1
# TF3xt+FKfR24lHjb/x6FFUJGcc5/J1cS0YNPO8/63vaL7T8A49XeYfkXjUukgTz1
# aUDq4Ym/B0+6dHvpDOVH6qts8dVngQj4Fsp9E7tz4glM+mL77aA5mjr+6xHIYR5i
# WNgKVIPVO0tL4lW9L2AajpIFQ9pd64IKI5cJoAUxZYuTTh5BIaKSkP1FREVvNbFF
# N61pqWX5NEOxF8I7OeEQjPIah+NUUB87nTGtAgMBAAGjgfgwgfUwHQYDVR0OBBYE
# FH5y8C4/VingJfdouAH8S+F+z+M+MB8GA1UdIwQYMBaAFG/oTj+XuTSrS4aPvJzq
# rDtBQ8bQMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNv
# bS9wa2kvY3JsL3Byb2R1Y3RzL3RzcGNhLmNybDBIBggrBgEFBQcBAQQ8MDowOAYI
# KwYBBQUHMAKGLGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvdHNw
# Y2EuY3J0MBMGA1UdJQQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIGwDANBgkq
# hkiG9w0BAQUFAAOCAQEAaXqCCQwW0d7PRokuv9E0eoF/JyhBKvPTIZIOl61fU14p
# +e3BVEqoffcT0AsU+U3yhhUAbuODHShFpyw5Mt1vmjda7iNSj1QDjT+nnGQ49jbI
# FEO2Oj6YyQ3DcYEo82anMeJcXY/5UlLhXOuTkJ1pCUyJ0dF2TDQNauF8RKcrW4NU
# f0UkGSXEikbFJeMZgGkpFPYXxvAiLIFGXiv0+abGdz4jb/mmZIWOomINqS0eqOWQ
# Pn//sI78l+zx/QSvzUnOWnSs+vMTHxs5zqO01rz0tO7IrfJWHvs88cjWKkS8v5w/
# fWYYzbIgYwrKQD1lMhl8srg9wSZITiIZmW6MMMHxkTCCBJ0wggOFoAMCAQICEGoL
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
# KoZIhvcNAQkEMRYEFBbgBg7QiRy0FblVw3ILjstoiTl/MIGABgorBgEEAYI3AgEM
# MXIwcKBOgEwATQBpAGMAcgBvAHMAbwBmAHQAIABEAGEAdABhACAAUAByAG8AdABl
# AGMAdABpAG8AbgAgAE0AYQBuAGEAZwBlAHIAIAAyADAAMAA3oR6AHGh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9EUE0wDQYJKoZIhvcNAQEBBQAEggEAZb85poI8RJD0
# EzklvF+aaQVbe/5ZD7sPbak+waClY3CS8PopWG2uMIlE1tugwCpejUSmZuQNP/zk
# OTyWD2OwLJ/AUv4jtDnc8nH5WnwmqxCWJj5S3j+dHrAKZ79Q/X/D+jnfrZaONcIK
# A8RGHr9OfRN1x5m4lSJyH752K9GsoeLP3GoIgv338TbwaqGftmtayqqoMXujit0r
# 9dReweoIMe4pnYlaSF7ox4kgTxjfGu+XamcAxA0A2GhI9Zg+E4E9zdPz3seX9d98
# vxg/nMUBJyk//fYL6AXLUJLmUzvaAY331aDqRQ+q3ApdXXm9ct2qMt98FmPvYZRn
# di5D2lfX0qGCAh8wggIbBgkqhkiG9w0BCQYxggIMMIICCAIBATCBhzB5MQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3Nv
# ZnQgVGltZXN0YW1waW5nIFBDQQIKYUl87QAAAAAABTAHBgUrDgMCGqBdMBgGCSqG
# SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MTIwOTAwNDUw
# NVowIwYJKoZIhvcNAQkEMRYEFL8O3TybSePglpo2C+GKxwSL7POQMA0GCSqGSIb3
# DQEBBQUABIIBAMXjocBVBYMv6+hdP7lyL4dyZhmcavVend7NL+ljlJcKuiLzNYwN
# 1VoY+ZECYzngG+y4yDAE+sNehHyHyJSx9Wf2I6E0YjHirrIy3gpziCa4rIxo7++I
# z83/Leqhh8RsLyVRfWc7TwaGiMjpDBf7TVnXKlI4/OwnorLpgWwe61HaXK8Qln/L
# xLH89IqJZpbywxhpnlhPrKQaR7EpqIbOKWWBgxrmPimleLbCbGsFPmml0lCLpYW8
# c4gDsmMnC0mnkN2MR9xebAoY56laVt2/HxvwzcY6SHecPAPcFxfzGI2WGWpn+Hut
# 70XbRA1pJyl+CdxPp69MXUQtst1Qr4yrKYc=
# SIG # End signature block
