#------------------------------------------------------------------------------ 
# 
# Copyright © 2012 Microsoft Corporation.  All rights reserved. 
# 
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT 
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT 
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS 
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR  
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 
# 
#------------------------------------------------------------------------------ 
# 
# PowerShell Source Code 
# 
# NAME: 
#    GetThumbnailPhotoSize.ps1 
# 
# VERSION: 
#    1.0 
# 
#------------------------------------------------------------------------------ 


#modify $root to utilize your domain root

$Root = [ADSI]'GC://ou=TOL,dc=TOL,dc=local'

#get all user objects into array

Write-Host "`n Collecting user accounts..."

$Searcher = New-Object System.DirectoryServices.DirectorySearcher($root)
$Searcher.filter = "(&(objectClass=user)(sAMAccountName=*))"
$Searcher.PageSize = 1000
$Users = $Searcher.findall()
$TotalCount = $Users.Count
$CountTooLarge = 0
$CountNoPhoto = 0
$CountOKPhoto = 0

#loop through all user objects

Write-Host "`n Evaluating the thumbnailPhoto size for $TotalCount users..."

Foreach ($SingleUser in $Users)
	{
		#get the user UPN and thumbnailPhoto size
		
		$UserDn = $SingleUser.Path
		$UserDn = $UserDn.Trim("GC")
		$UserDn = "LDAP" + $UserDn
		$User = [ADSI]($UserDn)
		$Upn = $User.Properties["DisplayName"].Value
		$ByteArray = $User.Properties["thumbnailPhoto"].Value
		$PicSize = (($ByteArray.Count)/1.333)/1KB

		#depending on the size, write to appropriate log file

		If ($picSize -gt 10)

			#greater than 10KB is too big for EXO
			
			{
				$CountTooLarge++
				"`n $upn`t`t$picSize`tKB" | Out-File thumbnailPhoto-TooLarge.log -Append
			}

		ElseIf (($picSize -le 10) -and ($picSize -gt 0))

			#greater than 0KB and less than 10KB are accepted sizes

			{
				$CountOKPhoto++

				"`n $upn`t`t$picSize`tKB" | Out-File thumbnailPhoto-OK.log -Append
			}

		ElseIf ($picSize -le 0)

			#less than or equal to 0KB means there is no thumbnailPhoto for this user
			
			{
				$CountNoPhoto++
				"`n $upn" | Out-File thumbnailPhoto-NoPhoto.log -Append
			}


	}

#report counts

Write-Host "`n`tUsers with large photos`:`t$CountTooLarge`n`tUsers with OK photos`:`t`t$CountOKPhoto`n`tUsers with no photo`:`t`t$CountNoPhoto"

Write-Host "`n Done!`n`n"