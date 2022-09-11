param([string] $DPMServerName, [string] $option, [string]$PSName, [string]$Domain)

#function to convert the output of a query to a 2d array
function ReaderOutputToBuffer ([Microsoft.Internal.EnterpriseStorage.Dls.DB.SqlRetryReader] $tempReader) 
{
    while($tempReader.Read())
     {
       $DataRow = @()
 
       for($counter = 0 ; $counter -le $tempReader.FieldCount - 1; $counter++ )
        {
            $DataRow += ,$tempReader[$counter].toString()
        }

       $queryResult += ,$DataRow
     } 

     $tempReader.close()
    
    return ,$queryResult 
 
} #end of function ReaderOutputToBuffer


#function to print the output of the query with serial number
function PrintQueryResultWithSerialno($queryResult)
{
    $rowNumber = 1
    
    foreach($queryResultRow in $queryResult)
     {
        write-host $rowNumber -nonewline " "
        
        $queryResultRow[0] 
  
        $rowNumber = $rowNumber + 1
        
        write-host ""
     }

}


#given a query, function executes and returns an 2d string array for the table-output
function ExecuteQuery([string] $query)
{
    $ctx = NEW-OBJECT -Typename Microsoft.Internal.EnterpriseStorage.Dls.DB.SqlContext  
    
    $ctx.open()
     
    $cmd = $ctx.createcommand()
     
    $cmd.commandtext = $query
     
    $reader = $cmd.executereader()
     
    $queryResult = @()
    
    if ($reader.HasRows)
    {
      $queryResult = ReaderOutputToBuffer($reader)
    } 
    
    $reader.close()
    
    $cmd.dispose()
    
    $ctx.close()

     return ,$queryResult
   
}



function AutoSearchForDS()
    {
        
    #Getting Volumelabels in the PS already protected but volumes marked for deletion   
    $queryVolumeLabelsInProtection = "SELECT  DS.DataSourceName
                                      FROM 
                                      tbl_AM_Server amServer 
                                      JOIN tbl_IM_DataSource DS ON amServer.ServerId = DS.ServerId 
                                      JOIN tbl_IM_DataSourceVolume dsv ON DS.DataSourceId = dsv.DataSourceId 
                                      JOIN tbl_IM_Volume  vol ON dsv.VolumeId = vol.VolumeId 
                                      WHERE
                                      amServer.servername LIKE N'$DNSName' AND
                                      vol.MarkedForDeletion = 1 AND
                                      vol.ServerId = amServer.ServerId AND
                                      DS.AppId = N'$FileSystemAppId' AND
                                      DS.ProtectedGroupId IS NOT NULL " 
                                  
    $VolumeLabelsInProtection =  ExecuteQuery($queryVolumeLabelsInProtection)
    
    if($VolumeLabelsInProtection.Length -eq 0)
    {
    
    write-host "Could not find any volumes for migrating automatically`n"
    
    Disconnect-dpmserver
    
    exit 1
    }
    
           
    #Gives FileSystem datasource entries in the order of their first occurrence    
    $uniqueFileSystemDataSources = $VolumeLabelsInProtection | sort -uniq
           
    $VolumesNotInProtection = @()
    
    foreach($dataSourceName in $uniqueFileSystemDataSources)
    {
     $queryVolumeNotInProtection = "SELECT DS.DataSourceName, DS.DataSourceId
                                    FROM 
                                    tbl_AM_Server amServer
                                    JOIN tbl_IM_DataSource DS ON amServer.serverid = DS.serverid 
                                    JOIN tbl_IM_DataSourceVolume dsv ON DS.DataSourceId = dsv.DataSourceId 
                                    JOIN tbl_IM_Volume  vol ON dsv.VolumeId = vol.VolumeId 
                                    WHERE 
                                    amServer.servername LIKE N'$DNSName' AND
                                    DS.DataSourcename LIKE N'$dataSourceName' AND 
                                    DS.AppId = N'$FileSystemAppId' AND
                                    vol.MarkedForDeletion = 0 AND 
                                    vol.ServerId = amServer.ServerId AND
                                    DS.ProtectedGroupId IS NULL" 
                                                                               
      $VolumeNotInProtection = ExecuteQuery($queryVolumeNotInProtection)
   
      if($VolumeNotInProtection.Length -ne 0) 
       {
         $VolumesNotInProtection += , $VolumeNotInProtection  #Its VolumeS in former
       }
    
    } 
    
    write-host "Listing fileSystem datasources which are to be protected and yet have a older PG associated with them`n"
    
    if($VolumesNotInProtection.Length -eq 0)
     {
       write-host "Could not find any volumes for migrating automatically."
       
       Disconnect-dpmserver
       
       exit 1
       
     }
    
    
    $rowNumber = 1
    foreach($queryResultRow in $VolumesNotInProtection)
     {
        write-host $rowNumber " " $queryResultRow[0]  
        
        $rowNumber = $rowNumber + 1
        
        write-host ""
    }
    
      
    foreach ($volume in $VolumesNotInProtection)
    {
    
         $tempVolumeLabel = $volume[0][0]
          
         #Getting List of PGs for each VolumeLabel(not protected)
         $queryListOfPGs = " SELECT  
                             pg.FriendlyName, DS.dataSourceId, DS.DataSourceName
                             FROM 
                             tbl_AM_Server amServer 
                             JOIN tbl_IM_DataSource DS ON amServer.ServerId = DS.ServerId 
                             JOIN tbl_IM_ProtectedGroup pg ON DS.ProtectedGroupId = pg.ProtectedGroupId
                             JOIN tbl_IM_DataSourceVolume dsv ON DS.DataSourceId = dsv.DataSourceId 
                             JOIN tbl_IM_Volume  vol ON dsv.VolumeId = vol.VolumeId 
                             WHERE 
                             amServer.ServerName LIKE N'$DNSName' AND 
                             DS.AppId = N'$FileSystemAppId' AND
                             vol.ServerId = amServer.ServerId AND
                             DS.DataSourcename LIKE N'$tempVolumeLabel'"
                             
         $ListOfPGs = ExecuteQuery($queryListOfPGs)
         
         if($ListOfPGs.Length -gt 1)
          {
            write-host "Multiple PGs available for this datasource: "  $temp 
                     
            $rowNumber = 1
            foreach($queryResultRow in $ListOfPGs)
             {
               write-host $rowNumber " " $queryResultRow[0] " " $queryResultRow[2]
              
               $rowNumber = $rowNumber + 1
              
               write-host ""
             } 
                    
            write-host "Which one would you like to consider:"
          
            [int]$optPGNumber = read-host "Option:"
           
            while($optPGNumber -lt 1 -or $optPGNumber -gt $ListOfPGs.Length)
             {
               write-host "Invalid Option"
            
               $optPGNumber = read-host "Number"
             }
          
            $oldDataSourceId =  $ListOfPGs[$optPGNumber -1][1]
          
          }
         else
          {
            $oldDataSourceId =  $ListOfPGs[0][1]
          }
         
         $newDataSourceId =  $volume[0][1]  
         
         write-host "newDataSource=" $volume[0][0] "oldDataSource=" $ListOfPGs[0][2] "`n"
         
         $error.clear()  
         $dpmServer.MigrateDataSource($newDataSourceId, $oldDataSourceId)
         if($error)
         {
          write-host "Error in Migration"
          Disconnect-dpmServer
          exit 1
         }
         
         write-host "Migration Completed for newDataSource=" $volume[0][0] "oldDataSource=" $ListOfPGs[0][2] 
                          
      }
    
  }  #end of function DS_in_protection
  

 function ManualInput()
 {
     $queryListOfVolumesInPG = "SELECT 
                                DS.DataSourceName, DS.DataSourceId, pg.FriendlyName, 
                                substring(vol.volumepath, patindex('%volume{%', vol.volumepath)+7, 36) as VGP 
                                FROM 
                                tbl_IM_DataSource DS
                                JOIN tbl_AM_Server amServer ON DS.ServerId = amServer.ServerId
                                JOIN tbl_IM_ProtectedGroup pg ON DS.ProtectedGroupId = pg.ProtectedGroupId
                                JOIN tbl_IM_DataSourceVolume DSV ON DS.DataSourceId = DSV.DataSourceId
                                JOIN tbl_IM_Volume VOL ON DSV.VolumeId = VOL.VolumeId
                                WHERE
                                amServer.ServerName LIKE N'$DNSName' AND
                                DS.AppId = N'$FileSystemAppId' AND
                                vol.ServerId = amServer.ServerId AND
                                DS.ProtectedGroupId IS NOT NULL"
 
     $ListOfVolumesInPG = ExecuteQuery($queryListOfVolumesInPG)   
                                     
     if( $ListOfVolumesInPG.Length -eq 0) 
     {
       write-host "No FileSystem datasources under protection(but volumes marked as deleted) on this PS`n"

       Disconnect-dpmServer
       
       exit 1
       
     } 
     write-host "List of fileSystem datasources under protection(candidates for migration):"

     $multipleDataSource = @{}
     
     $rowNumber = 1
     foreach($queryResultRow in $ListOfVolumesInPG)
     {
     
       if($multipleDataSource[$queryResultRow[0]])
        {
          write-host $rowNumber  $queryResultRow[0]"(" $queryResultRow[3]") "$queryResultRow[2]
        }
        
       else
        {
          $multipleDataSource[$queryResultRow[0]] = 1
       
          write-host $rowNumber  $queryResultRow[0] " "  $queryResultRow[2]
        }
               
        $rowNumber = $rowNumber + 1
       
        write-host ""
     }
   

     [int]$option = read-host "Number"
     
     while($option -lt 1 -or $option -gt $ListOfVolumesInPG.Length)
     {
       write-host "Invalid Option"
       
       $option = read-host "Number"
     }
     
     $oldDataSourceId = $ListOfVolumesInPG[$option - 1][1]
     
     $oldDataSourceName = $ListOfVolumesInPG[$option - 1][0]
     
     write-host "The old datasource selected is :" $ListOfVolumesInPG[$option - 1][2] " " $oldDataSourceName
     write-host ""

       
     $queryValidVolumesForProtection = "SELECT DS.DataSourceName, DS.DataSourceId 
                                        FROM 
                                        tbl_IM_DataSource DS
                                        JOIN tbl_AM_Server amServer ON DS.ServerId = amServer.ServerId
                                        JOIN tbl_IM_DataSourceVolume DSV ON DS.DataSourceId = DSV.DataSourceId
                                        JOIN tbl_IM_Volume VOL ON DSV.VolumeId = VOL.VolumeId
                                        WHERE
                                        amServer.ServerName LIKE N'$DNSName' AND
                                        DS.AppId = N'$FileSystemAppId' AND 
                                        VOL.MarkedForDeletion = 0 AND
                                        vol.ServerId = amServer.ServerId AND
                                        DS.ProtectedGroupId IS NULL"
     
     $ListOfVolumesForProtection = ExecuteQuery($queryValidVolumesForProtection)
                                   
     if($ListOfVolumesForProtection.Length -eq 0)    
      {
        write-host "No Filesystem datasource is available for protection on this PS"
        
        Disconnect-dpmserver
        
        exit 1
      } 
      
     
        write-host "The following are the list of Datasourcevolumes available for protection, which would u like to consider:"
        write-host "(Migration not allowed from normal volume to a mounted volume)"

        $rowNumber = 1
        foreach($queryResultRow in $ListOfVolumesForProtection)
        {
         write-host $rowNumber $queryResultRow[0] 
      
         $rowNumber = $rowNumber + 1
      
         write-host ""
        }

        [int]$option = read-host "Number"
     
        while($option -lt 1 -or $option -gt $ListOfVolumesForProtection.Length)
        {
         write-host "Invalid Option"
       
         [int]$option = read-host "Number"
        }
      
     
     $newDataSourceId = $ListOfVolumesForProtection[$option - 1][1]
   
     write-host "`nThe New datasource selected is " $ListOfVolumesForProtection[$option - 1][0]
     
     $newDataSourceName = $ListOfVolumesForProtection[$option - 1][0]

     $confirm = read-host "Confirm migration (Y/N)? "
     
     if(("y","Y") -contains $confirm)
     {
       write-host "newDataSource=" $newDataSourceName "oldDataSource=" $oldDataSourceName "`n"
       
       $error.clear()
         
       $dpmServer.MigrateDataSource($newDataSourceId, $oldDataSourceId)
       
       if($error)
       {
        write-host "Error in Migration"
        Disconnect-dpmServer
        exit 1
       }
       
       write-host "Migration Completed for newDataSource=" $newDataSourceName  "oldDataSource=" $oldDataSourceName 
       
     }
     else
     {
       write-host "Migration Abandoned"
       Disconnect-dpmserver
       exit 1
     }  
 
 } #end of function :manualInput 





#main body of the file

  $FileSystemAppId = [Microsoft.Internal.EnterpriseStorage.Dls.EngineUICommon.VssWriterId]::FileSystem.toString()
  

  if(("-?","-help") -contains $args[0])
  {
    write-host Usage::
    write-host MigrateDataSource.ps1 -DPMServername [dpmserver] -Option [auto or manual] -PSName[machine name] 
    write-host -Domain [eg. fareast.corp.microsoft.com]
    write-host " -auto for Auto Search of matching volume letters "
    write-host " -manual for manual entry of 'from' and 'to' datasources, to be migrated "
    write-host Help::
    write-host -Migrates from one DataSoure to another.
    write-host 
    
    exit 0
  }
  
  
  if(!$DPMServerName)
   {
     $DPMServerName = read-host "DPMServer"
   }
   
   $dpmServer = Connect-DPMServer $DPMServerName
  
   if (!$dpmServer)
   {
     Write-Error "Unable to connect to $dpmServerName"
     
     exit 1
   }                 

   if(!$option)
   {
    write-host "  auto for AUTO SEARCH for matching volume letters "
    write-host "  manual for MANUAL INPUT of 'from' and 'to' Volumes, to be migrated "
    
    $option = read-host "option( auto or manual)"
   }
   
   if(!(("auto","manual") -contains $option))
   {
    write-error "Invalid Option:$option. Allowed: auto or manual" 
    
    Disconnect-dpmserver
    
    exit 1
   }

   if(!$PSName)
   {
    $PSName = read-host "PSName"
   } 
  
   if(!$Domain)
   {
    $Domain = read-host "Domain" 
   }
   
   $DNSName = $PSName + "." + $Domain
  
   $PSObject = $dpmServer.GetProductionServerWithName($DNSName)
   
   if( !$PSObject)
   {
    write-error "DPM cannot find a protected computer of this name. If this computer is on another domain, you must provide the fully qualified domain name (FQDN) for the protected computer."
    
    Disconnect-dpmserver
    
    exit 1
   }
   
   write-host "Running inquiry on the PS"
     
    #$null is to not print the inquiry results and the errors on the console.  
   Get-Datasource -productionserver $PSObject -Inquire -ErrorVariable inquiryErr1 2>&1 >$null
   
   if($inquiryErr1)
   {
    $errMsg = ""
    foreach($err in $inquiryErr1)
    {
     $errMsg += $err.ErrorDetails.toString() + "`n"
    }
    $errMsg += "`n`nDPM could not locate all new data sources on " + $DNSName + "You may see some of the volume information not updated." 
    write-warning $errMsg
   }

   
   write-host "Finished running inquiry"
  
   if($option -eq "auto")
   {
    AutoSearchForDS -Confirm
   } 

   if($option -eq "manual")
   {
    ManualInput 
   }  
       
              
   write-host "Running inquiry on the PS for App restore"
   write-host "`nRun Consistency check to make replica Valid"
   write-host ""
   
   #$null to not print the inquiry results on the console.
   Get-Datasource -productionserver $PSObject -Inquire -ErrorVariable inquiryErr2 2>&1 >$null
   
   if($inquiryErr2)
   {
    $errMsg = ""
    foreach($err in $inquiryErr2)
     {
      $errMsg += $err.ErrorDetails.toString() + "`n`n" 
     }
    $errMsg += "DPM could not locate all new data sources on " + $DNSName
    write-warning $errMsg 
   }
   
   Disconnect-dpmServer
 

# SIG # Begin signature block
# MIIbdgYJKoZIhvcNAQcCoIIbZzCCG2MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUoahX9GLvHz8ZAysrpHDYF8pR
# o5SgghYqMIIEEjCCAvqgAwIBAgIPAMEAizw8iBHRPvZj7N9AMA0GCSqGSIb3DQEB
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
# KoZIhvcNAQkEMRYEFLzBqbQyGoPhpEVkuNgd69slQBHyMIGABgorBgEEAYI3AgEM
# MXIwcKBOgEwATQBpAGMAcgBvAHMAbwBmAHQAIABEAGEAdABhACAAUAByAG8AdABl
# AGMAdABpAG8AbgAgAE0AYQBuAGEAZwBlAHIAIAAyADAAMAA3oR6AHGh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9EUE0wDQYJKoZIhvcNAQEBBQAEggEAnXLoLACyPtV3
# s+cX03v18GUfuK1af8TrOOZc3SMkq7TFPzXYx7lDowTPNT8SSHX+g3QPLY0X6gMD
# 3RWGbsh0tqWLqrM1BoRzzkgUSpo3DIJowOcvWS5kRgQmT/Bo79HB/PRVT+uWXuoE
# PVDkYiUvsm4r16y8PWyj/JOGAvgopN1WcHSpNy5D8VCoJPrQABTx4AjklLBet7pV
# +JtllWR2YRUoT+Rz+ubK9iI7b/kp24p9HnDwA5Kb3UEIcu/KNsaaTi7sTvVagEGa
# mqiIWBMJUDLM8RNMvAiJCgI8pST3nOdYPRbenbrpe4jCyiTBtgm1Meo43+XNUVYV
# SWLXt4PeBKGCAh8wggIbBgkqhkiG9w0BCQYxggIMMIICCAIBATCBhzB5MQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSMwIQYDVQQDExpNaWNyb3Nv
# ZnQgVGltZXN0YW1waW5nIFBDQQIKYUl87QAAAAAABTAHBgUrDgMCGqBdMBgGCSqG
# SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA4MTIwOTAwNDUw
# NFowIwYJKoZIhvcNAQkEMRYEFEvl/0NAoJkucMweZiE+GX4wwNraMA0GCSqGSIb3
# DQEBBQUABIIBAJMk1NgmF70eqBgxFHkoqgmHNYgUSmBmqPwkyniiAo8mH7cn55B1
# c8IutLR6bQRHMiMJdhemnWd7/PFKRZUfyp7Wp7AHg0RoZFPytct8aPwlTZeEhn/D
# OZIwRbDMG84yJQ5l4Ekjye16S6UU0nAJJejEH0fzS+WwET7Bwe9IMcVHfZWfCps8
# X6+AfXTBOIGkFVHreAShDHimiCQycYnuldgObZMdiNuPTkALJdfQ8pfkKEYzKw9L
# 2ZecR7HgwOHo4CIUnmwbWU46ghpBEwP5HUZHpSww5xE5WPyANXIjfTLJT4eY2teb
# aKJ3tstQeZHKuDlyMa2xAaAJlCvk0YSxRV4=
# SIG # End signature block
