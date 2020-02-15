<#
#requires -version 3
.SYNOPSIS
    Download all files and folders from McAfee updates website.
.DESCRIPTION
    The Start-McAfeeDownload cmdlet downloads complete directory and files from web.
.PARAMETER
    No Parameters
.INPUTS
    No Input
.OUTPUTS
    Output is on console directly.
.NOTES
  Version:        1.8d
  Author:         Peter van Koppen
  Creation Date:  6 January 2019
  Purpose/Change: Automated way to download files from McAfee (https://update.nai.com/products/)
  Useful URLs:    http://vcloud-lab.com
.EXAMPLE 1
    PS C:\>Start-McAfeeDownload

    This command:
    1: Start download files from McAfee Updates site and downloads to fixed folder path, Will clean up filles that no longer exist.
#>

process {
    # -- Untrusted Cert Fix ----------------------------------------------------
    add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
  $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
  [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
  [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
  # -- Untrusted Cert Fix ----------------------------------------------------

    function ProcessWebFolder{
        Param( $WebPath, $LocalFolder)
        if ($boolDebug) { Write-Host "[INFO ] WebPath=$WebPath, LocalFolder=$LocalFolder."}
        try {
            # Check if folder exists, If Not Create Folder, On Failure stop processing.
            if (!(Test-Path -Path $LocalFolder)) {
                New-Item -Path $LocalFolder -Type Directory -Force -ErrorAction Stop | Out-Null
            }
            # Get webpage
            if ($Proxy -eq '') {
                $WebPage = Invoke-WebRequest $WebPath -UseBasicParsing -ErrorAction Stop
            } else {
                #write-host "Invoke-WebRequest -proxy $Proxy -Uri $WebPath"
                $WebPage = Invoke-WebRequest -proxy $Proxy -Uri $WebPath -UseBasicParsing -ErrorAction Stop
            }
            # Filter for Folders
            #$WebPage
            $WebPageFolders = $WebPage.links | Where-Object {$_.href -like "*/" -and $_.outerHTML -notlike "*Parent*"}
            #$WebPageFolders
# Delete Any local folders that do not exist in the "WebPageFolders" list
# ---
            $LocalContent = Get-ChildItem -Path $LocalFolder -Directory
            ForEach ($itemContent in $LocalContent) {
                $found = $false
                ForEach ($itemWeb in $WebPageFolders) {
                    if ($itemContent.Name -eq $(Split-Path -Leaf -Path $itemWeb.href)) { $found = $true}
                }
                If (-not $found) {
                    $strMsg = "[INFO ] Delete: '$($itemContent)'"
                    Write-Host $strMsg -ForegroundColor Magenta
                    Out-File -FilePath $strLogName -Append -InputObject $strMsg
                    Remove-Item -Path $(Join-Path -Path $LocalFolder -ChildPath $itemContent) -Recurse -Force
                }
            }
# ---
            # Re-run this function for all folders
            ForEach ($WebFolder in $WebPageFolders) {
                $strLeaf = Split-Path -Leaf -Path $WebFolder.href
                $NewWebPath = "$($WebPath)/$strLeaf"
                $NewLocalFolder = Join-Path $LocalFolder $strLeaf
                ProcessWebFolder $NewWebPath $NewLocalFolder
                }
            $strMsg = "$WebPath"
            Write-Host $strMsg -ForegroundColor Green
            Out-File -FilePath $strLogName -Append -InputObject $strMsg
            # Filter for Files
            $WebPageFiles = $WebPage.links | Where-Object {$_.href -notlike "*/" -and $_.href -notlike "*..*" -and $_.href -notlike "*=*"}
            #$WebPageFiles
# Delete any local files that do not exist in the "WebPageFiles" list
# ---
            $LocalContent = Get-ChildItem -Path $LocalFolder -File
            ForEach ($itemContent in $LocalContent) {
                $found = $false
                ForEach ($itemWeb in $WebPageFiles) {
                    if ($itemContent.Name -eq $(Split-Path -Leaf -Path $itemWeb.href)) { $found = $true}
                }
                if (-not $found) {
                    $strMsg = "[INFO ] Delete: '$($itemContent)'"
                    Write-Host $strMsg -ForegroundColor Magenta
                    Out-File -FilePath $strLogName -Append -InputObject $strMsg
                    Remove-Item -Path $(Join-Path -Path $LocalFolder -ChildPath $itemContent) -Recurse -Force
                }
            }
# ---
            # Process all (filtered) Files
            ForEach ($WebFile in $WebPageFiles) {
                $strLeaf = Split-Path -Leaf -Path $WebFile.href
                $NewWebFile = "$($WebPath)/$strLeaf"
                $NewLocalFile = Join-Path $LocalFolder $strLeaf
                if ($boolDebug) { Write-Host "[LOG  ] WebFile=$NewWebFile, LocalFile=$NewLocalFile."}
                try {
                    if (!(Test-Path -Path $NewLocalFile)) {
                        Write-Host " | $strLeaf `t[New file: downloading...]" -ForegroundColor Yellow -NoNewline
                        if ($Proxy -eq '') {
                            Invoke-WebRequest -Uri $NewWebFile -OutFile $NewLocalFile
                        } else {
                            Invoke-WebRequest -proxy $Proxy -Uri $NewWebFile -OutFile $NewLocalFile
                        }
                        Write-Host "`t[Done]" -ForegroundColor Green
                        $strMsg = " | $strLeaf `t[New file: downloading...]`t[Done]"
                        Out-File -FilePath $strLogName -Append -InputObject $strMsg
                    } else {
                        Write-Host " | $strLeaf " -ForegroundColor Yellow -NoNewline
                        if ($Proxy -eq '') {
                            $urlHeaders = Invoke-WebRequest -Uri $NewWebFile -Method Head
                        } else {
                            $urlHeaders = Invoke-WebRequest -Proxy $Proxy -Uri $NewWebFile -Method Head
                        }
                        #$urlHeaders.Headers
                        $onlineLength   = $urlHeaders.Headers.'Content-Length'
                        $onlineModified = ($urlHeaders.Headers.'Last-Modified') -as [DateTime] 
                        $localLength    = (Get-Item $NewLocalFile).Length
                        $localModified  = (Get-Item $NewLocalFile).LastWriteTime
                        #Write-Host "onlineLength=localLength; $onlineLength=$localLength; onlineModified<localModified = $onlineModified<$localModified."
                        if ($onlineLength -ne $localLength) {
                            # Checked: Size.
                            Write-Host "`t[File size ($onlineLength!=$localLength): downloading...]" -NoNewline #: Online=$onlineLength, Local=$localLength.
                            if ($Proxy -eq '') {
                                Invoke-WebRequest -Uri $NewWebFile -OutFile $NewLocalFile
                            } else {
                                Invoke-WebRequest -proxy $Proxy -Uri $NewWebFile -OutFile $NewLocalFile
                            }
                            Write-Host "`t[Done]" -ForegroundColor Green
                            $strMsg = " | $strLeaf `t[File size ($onlineLength!=$localLength): downloading...]`t[Done]"
                            Out-File -FilePath $strLogName -Append -InputObject $strMsg
                        } elseif ($onlineModified -ge $localModified) {
                            # Checked: Date.
                            Write-Host "`t[File date ($($onlineModified.ToString('yyyyMMdd-hhmm'))>=$($localModified.ToString('yyyyMMdd-hhmm'))): downloading...]" -NoNewline #: Online=$onlineLength, Local=$localLength.
                            if ($Proxy -eq '') {
                                Invoke-WebRequest -Uri $NewWebFile -OutFile $NewLocalFile
                            } else {
                                Invoke-WebRequest -proxy $Proxy -Uri $NewWebFile -OutFile $NewLocalFile
                            }
                            Write-Host "`t[Done]" -ForegroundColor Green
                            $strMsg = " | $strLeaf `t[File date ($($onlineModified.ToString('yyyyMMdd-hhmm'))>=$($localModified.ToString('yyyyMMdd-hhmm'))): downloading...]`t[Done]"
                            Out-File -FilePath $strLogName -Append -InputObject $strMsg
                        } else {
                            # All Good!
                            Write-Host "`t[File size and date good: no action.]"
                        }
                    }
                }
                catch {
                    $strMsg = "`t[ERROR] $($error[0])"
                    Write-Host $strMsg -ForegroundColor Red
                    Out-File -FilePath $strLogName -Append -InputObject $strMsg
                }
            }
        }
        catch {
            $strMsg = "`t[ERROR] $($error[0])"
            Write-Host $strMsg -ForegroundColor Red
            Out-File -FilePath $strLogName -Append -InputObject $strMsg
        }
    }

    function DeleteOldFiles {
        Param( $LocalFolder, $Days)
        ## Deletes the contents of the download folder.
        Write-host "[INFO ] Local folder clean up: Older than $Days days. ($LocalFolder)" -ForegroundColor Green
        Get-ChildItem "$LocalFolder*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
            Where-Object { $_.Mode -eq '-a----'} |
            Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays( - $Days)) } | Remove-Item -force -ErrorAction SilentlyContinue -Verbose
    }

    function DeleteStatusFiles {
        Param( $LocalFolder)
        ## Deletes the contents of the download folder.
        Write-host "[INFO ] Local folder clean up: All except (.zip). ($LocalFolder)" -ForegroundColor Green
        Get-ChildItem "$LocalFolder*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
            Where-Object { $_.Mode -eq '-a----'} |
            Where-Object { $_.Name -notlike "*.zip"} | Remove-Item -force -ErrorAction SilentlyContinue -Verbose
    }

    function DeleteSmallZipFiles {
        Param( $LocalFolder)
        ## Deletes the contents of the download folder.
        Write-host "[INFO ] Local folder clean up: Small .zip files. ($LocalFolder)" -ForegroundColor Green
        Get-ChildItem "$LocalFolder*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
            Where-Object { $_.Mode -eq '-a----'} | Where-Object { $_.Length -lt $SmallFiles} |
            Where-Object { $_.Name -like "*.zip"} | Remove-Item -force -ErrorAction SilentlyContinue -Verbose
    }

    $boolDebug        = $False
    $DaysToDelete     = 21+1
    $SmallFiles       = 8000000
    $DownloadURL      = 'https://update.nai.com/products/commonupdater/'
    $DownloadToFolder = 'C:\Data\ePO_Repository\commonupdater\'
#    $Proxy            = "http://10.200.35.46:3128" #DMZMOT
#    $Proxy            = "http://10.100.35.45:3128" #DMZWVL
    $Proxy            = ""
#
    if ($PSCommandPath -eq '') {
        $strScriptPath     = split-path -parent $global:MyInvocation.MyCommand.Definition
        $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($global:MyInvocation.MyCommand.Definition)
    } else {
        $strScriptPath     = split-path -parent $PSCommandPath
        $strScriptName     = [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
    }
    $strLogPath        = join-path -path $(join-path -path $strScriptPath -ChildPath "..") -ChildPath "LogFiles"
    $strLogName        = join-path -path ".\" -ChildPath "$strScriptName-$(Get-Date -Format dd).log"

$strMsg = "[INFO ] -------- $(Get-Date) --------"
Write-Host $strMsg -ForegroundColor White
if (Test-Path -Path $strLogName) { 
    if ($(Get-ChildItem -Path $strLogName).LastWriteTime -gt $((get-date).AddDays(-1))) {
        Out-File -FilePath $strLogName -Append -InputObject $strMsg
    } else {
        Out-File -FilePath $strLogName <#-Append#> -InputObject $strMsg
    }
} else {
    Out-File -FilePath $strLogName -Append -InputObject $strMsg
}

#    DeleteOldFiles $DownloadToFolder $DaysToDelete
#    Start-Sleep -Seconds 5
#    DeleteStatusFiles $DownloadToFolder
#    Start-Sleep -Seconds 5
#    DeleteSmallZipFiles $DownloadToFolder
#    Start-Sleep -Seconds 5

    # Download 1
    Write-host "[INFO ] Start Download (1)..." -ForegroundColor Green
    ProcessWebFolder $DownloadURL $DownloadToFolder
    Start-Sleep -Seconds 5

    # Download 2
    Write-host "[INFO ] Start Download (2)..." -ForegroundColor Green
    ProcessWebFolder $DownloadURL $DownloadToFolder
    Start-Sleep -Seconds 5

}
