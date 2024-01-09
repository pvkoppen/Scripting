# Set Variable values
  $colorHeader = "Yellow"
  $colorInfo = "White"
  $colorGood = "Green"
  $colorBad = "Red"
  $secSleepTime = 60
  Write-Host "# Set Variables." -foregroundcolor $colorHeader
  Write-Host "  # ---------------------------------------------------------------"
  Write-Host "  # Colors: " -NoNewLine -ForegroundColor $colorInfo
  Write-Host "Plain, "  -NoNewLine
  Write-Host "Header, " -NoNewLine -ForegroundColor $colorHeader
  Write-Host "Info, "   -NoNewLine -ForegroundColor $colorInfo
  Write-Host "Good, "   -NoNewLine -ForegroundColor $colorGood
  Write-Host "Bad."     -ForegroundColor $colorBad

# Start of Script: Check for Snapin
  Write-Host "# Checking for: Exchange" -ForegroundColor $colorHeader
  if (!(Get-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin)) {
    write-host "  # Adding PS Snapin for: Exchange" -ForegroundColor $colorGood
    add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
  } else {
    write-host "  # PS Snapin already loaded for: Exchange." -ForegroundColor $colorGood
  }

# help
# get-command
# help about_comparison_operators
# help about_logical_operator
# Get-Mailbox | Set-CASMailbox -ActiveSyncMailboxPolicy(Get-ActiveSyncMailboxPolicy "Policy Name").Identity
# Set-CASMailbox UserName -ActiveSyncMailboxPolicy(Get-ActiveSyncMailboxPolicy "Policy Name").Identity
# Get-Mailbox    | Where-Object {$_.Alias -ne 'mwj'}
# Get-CASMailbox | Where-Object {!$_.ActiveSyncMailboxPolicy} 
# Get-CASMailbox | Where-Object {$_.samaccountname -ne 'mwj'}

Write-Host "# Regenerate all address books." -ForegroundColor $colorHeader
  Get-AddressList | Update-AddressList
  Get-GlobalAddressList | Update-GlobalAddressList
  Get-OfflineAddressBook | Update-OfflineAddressBook

Write-Host "# Check for Exchange 2007 Object Properties (ApplyMandatoryProperties)" -ForegroundColor $colorHeader
  $objMB = Get-Mailbox | Where-Object {$_.RecipientTypeDetails -eq 'LegacyMailbox' -and $_.ServerName -eq 'TOLMS01'}
  $objMB
  if (!$objMB) {
    Write-Host "  # Nothing to process" -ForegroundColor $colorGood
  } else {
    $objMB | Set-Mailbox -ApplyMandatoryProperties
  }

Write-Host "# For all mailboxes without a policy, Apply default mailbox policy." -ForegroundColor $colorHeader
  $objMB = Get-CASMailbox | Where-Object {!$_.ActiveSyncMailboxPolicy}
  $objMB
  if (!$objMB) {
    Write-Host "  # Nothing to process" -ForegroundColor $colorGood
  } else {
  $objMB | Set-CASMailbox -ActiveSyncMailboxPolicy(Get-ActiveSyncMailboxPolicy | Where-Object {$_.Identity -like '*(Default)'}).Identity
  }

Write-Host "# Select Statistics from all Combinations: Accounts+Mobile Device" -ForegroundColor $colorHeader
  Get-Mailbox | ForEach-Object { Get-ActiveSyncDeviceStatistics -mailbox $_} | ft Identity,LastSuccessSync
  #Get-Mailbox | ForEach-Object { Get-ActiveSyncDeviceStatistics -mailbox $_} | where {$_.LastSuccessSync -lt "01-jun-2011"} | Remove-ActiveSyncDevice 

Write-Host "# Regenerate all address books." -ForegroundColor $colorHeader
  Get-AddressList | Update-AddressList
  Get-GlobalAddressList | Update-GlobalAddressList
  Get-OfflineAddressBook | Update-OfflineAddressBook

Write-Host "# Wait for '$secSleepTime' second(s) before closing this window." -ForegroundColor $colorHeader
   sleep $secSleepTime


