#Add SharePoint PowerShell SnapIn if not already added 
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) { 
    Add-PSSnapin "Microsoft.SharePoint.PowerShell" 
} 
 
 
$site = new-object Microsoft.SharePoint.SPSite("http://tuinet.tuiora.co.nz");  
$ServiceContext = [Microsoft.SharePoint.SPServiceContext]::GetContext($site);  
 
#Get UserProfileManager from the My Site Host Site context 
$ProfileManager = new-object Microsoft.Office.Server.UserProfiles.UserProfileManager($ServiceContext)    
$AllProfiles = $ProfileManager.GetEnumerator()  
 
foreach($profile in $AllProfiles)  
{  
    $DisplayName = $profile.DisplayName  
    $AccountName = $profile[[Microsoft.Office.Server.UserProfiles.PropertyConstants]::AccountName].Value  
 
    #Do not delete setup (admin) account from user profiles. Please enter the account name below 
    if($AccountName -ne "Domain\MySiteSVApp") 
    { 
        $ProfileManager.RemoveUserProfile($AccountName); 
        write-host "Profile for account ", $AccountName, " has been deleted" 
    } 
 
}  
write-host "Finished." 
$site.Dispose() 