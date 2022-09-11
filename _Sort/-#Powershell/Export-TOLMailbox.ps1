param ([string] $MailBox='')

#v1.0 PvK Initial Powershell version
#v1.1 PvK Made Target Path a variable

$strTargetPathOld = 'T:\Backup-Config-Dump\Exchange\'
$strTargetPath = '\\TOLFP01\Archive$\ICT Archive\ExchangePST\'

if (!$MailBox) { 
  Write-Host "[INFO ] Ask for Mailbox"
  $strUsername = Read-Host 'Which user MailBox do you want to export?'
} else {
  Write-Host "[INFO ] Using Mailbox: $MailBox"
  $strUsername = $MailBox
}

$objMailBox = Get-Mailbox $strUsername

if ($($objMailbox | Measure).count -eq 1) {

  Write-Host "[INFO ] Statistics"
  Get-MailboxStatistics $strUsername | ft DisplayName, TotalItemSize,@{expression={$_.TotalItemSize.Value.ToMB()}}

  Write-Host "[INFO ] Set Permissions"
  #permissions
  #Add-MailboxPermission -Identity $strUsername -AccessRights FullAccess -User 'tol\Exmerge'

  Write-Host "[INFO ] Export"
  Export-Mailbox $strUsername -PSTFolderPath $strTargetPath

}

function Nothing {
# ----------------------------------------------------------------------------------------------
# Error occurred in the step: Approving object. An unknown error has occurred.
<#  
    * Full access to the source and target mailboxes
    For more information about permissions, delegating roles, and the rights th
    at are required to administer Microsoft Exchange Server 2007, see Permission Considerations.

    To grant full access to a mailbox, use the Add-MailboxPermission cmdlet and
     specify FullAccess for the AccessRights parameter.

    * Microsoft Office Outlook 2003 SP2 or later versions
    Microsoft Knowledge Base articles 289999 (http://go.microsoft.com/fwlink/?l
    inkid=3052&kbid=289999) and 813593 (http://go.microsoft.com/fwlink/?linkid=
    3052&kbid=813593) describe a problem with using Outlook 2003 to delete seve
    ral objects from a folder. You cannot use the Export-Mailbox cmdlet to dele
    te more than 4,000 objects from a folder. To export more objects, you must
    use Outlook 2007.

    For Exchange 2007 management tools 32-bit download information, see Microso
    ft Exchange Server 2007 Management Tools (32-Bit) (http://go.microsoft.com/
    fwlink/?LinkId=82335).

#>

<#
ERROR: Error occurred in the step: Approving object. An unknown error has occurred.
FIX: fixmapi
Support: https://social.technet.microsoft.com/Forums/en-US/82424f36-2611-4188-808e-df9aad36a5b7/exportmailbox-to-pst-file-unknown-error-in-approving-object?forum=exchangesvrdeploylegacy
#>

#export-mailbox $strUsername -PSTFolderPath \\tolmm02\software\Backup-Config-Dump\Exchange\

}