<#
# AUTHOR  : Victor Ashiedu
# WEBSITE : iTechguides.com
# BLOG    : iTechguides.com/blog
# CREATED : 08-08-2014 
# UPDATED : 30-04-2015
# COMMENT : Export-ADUsers Function exports Active Directory users
#           to a csv file. It has three required parameters (switches): 
#           -SearchLoc, -CSVReportPath & -ADServer. 
#>

Function Export-ADUsers {
<#
.SYNOPSIS
	Export-ADUsers is a PowerShell function that exports AD Users to a CSV file. 	
.DESCRIPTION
	Export-ADUsers is a PowerShell function that exports AD Users to a CSV file
	It has three required parameters (switches): -SearchLoc, -CSVReportPath & -ADServer
.PARAMETER Server
	Specifies the Domain Controler to query. This is required in W2K3 Domains where one DC
	has Active Directory web services installed. 
.PARAMETER SearchLoc
	Specifies the AD container to search. Specify actual name of the object, not the DN.
	The function converts the Active Directory object to DN format. 
.PARAMETER CSVReportPath
	Specifies the path to store the CSV report. Specify the full path with single quotes.
	For example 'C:\CSVReport'. If the directory does not exist, Export-ADUsers will create it.
	The user executing the command MUST have permission to create folders in the path specified
.PARAMETER Credential
	Specifies credential that runs the Export-ADUsers function. This account MUST have read permission
	to Active Directory. The Credential parameter is optional
.EXAMPLE
	PS C:\>Export-ADUsers -SearchLoc 'OU=FromCSV,OU=TestUsers,DC=70411Lab,DC=com' -CSVReportPath 'C:\CSV' -ADServer 70411SRV
	Add single quotes to avoid errors
#>

[CmdletBinding(DefaultParameterSetName='SearchLoc')]
Param
(		[Parameter(Mandatory=$true,Position=0,ParameterSetName='SearchLoc')]
		[String[]]$SearchLoc,
		[Parameter(Mandatory=$true,Position=1,ParameterSetName='SearchLoc')]
		[String]$CSVReportPath,
		[Parameter(Mandatory=$true,Position=2,ParameterSetName='SearchLoc')]
		[String]$Server,
		[Parameter(Mandatory=$false,Position=3,ParameterSetName='SearchLoc')]
		[String]$Credential
		
)
BEGIN {
If ($Credential) {
$Cred = Get-Credential $Credential
}

#Convert $SearchLoc to DN so that users will use actual name in Directory
Write-Host "Convering '$SearchLoc' to DistinguishedName format " -ForegroundColor Yellow
$SearchLocDN = 
If ($Credential)
{(Get-ADObject -LDAPFilter "(Name=$SearchLoc)" -Properties name -server $Server -Credential $Cred `
-ErrorAction SilentlyContinue -ErrorVariable SearchLocerr ).distinguishedName 
}
Else {

(Get-ADObject -LDAPFilter "(Name=$SearchLoc)" -Properties name -server $Server `
-ErrorAction SilentlyContinue -ErrorVariable SearchLocerr ).distinguishedName 

}


} #Not required, included for reference	
PROCESS #This is where the script executes
{
    $path = Split-Path -parent "$CSVReportPath\*.*"
	$pathexist = Test-Path -Path $path
	If (!$pathexist)
	{New-Item -type directory -Path $path | Out-Null}
	
   	#import the ActiveDirectory Module
    Write-Host "Importing Active Directory Modules and performing pre-tasks..." -ForegroundColor Cyan
	#import the ActiveDirectory Module
	Import-Module ActiveDirectory -WarningAction SilentlyContinue
    Write-Host "Exporting Active Directory users with the specified criteria. Please wait..." -ForegroundColor Magenta
    #Perform AD search. The quotes "" used in $SearchLoc is essential
	#Without it, Export-ADUsers returuned error
	$SearchLocDN
	$SearchLocDN | ForEach-Object {
	$DN = "$_"
	$reportdate = Get-Date -Format ssddmmyyyy
    $csvreportfile = $path + "\'$SearchLoc'_$reportdate.csv"
	
	$ADUserResults = 
	If ($Credential) {Get-ADUser -server $Server -searchbase "$DN" -Properties * -Filter * -Credential $Cred } 
	Else {Get-ADUser -server $Server -searchbase "$DN" -Properties * -Filter *}
    $ADUserResults | 
    Select-Object @{Label = "First Name";Expression = {$_.GivenName}}, 
    @{Label = "Last Name";Expression = {$_.Surname}},
    @{Label = "Display Name";Expression = {$_.DisplayName}},
    @{Label = "Logon Name";Expression = {$_.sAMAccountName}},
    @{Label = "Full address";Expression = {$_.StreetAddress}},
    @{Label = "City";Expression = {$_.City}},
    @{Label = "State";Expression = {$_.st}},
    @{Label = "Post Code";Expression = {$_.PostalCode}},
    @{Label = "Country/Region";Expression = {if (($_.Country -eq 'GB')  ) {'United Kingdom'} Else {''}}},
    @{Label = "Job Title";Expression = {$_.Title}},
    @{Label = "Company";Expression = {$_.Company}},
    @{Label = "Description";Expression = {$_.Description}},
    @{Label = "Department";Expression = {$_.Department}},
    @{Label = "Office";Expression = {$_.OfficeName}},
    @{Label = "Phone";Expression = {$_.telephoneNumber}},
    @{Label = "Email";Expression = {$_.Mail}},
    @{Label = "Manager";Expression = {%{(Get-AdUser $_.Manager -server $Server -Properties DisplayName).DisplayName}}},
    @{Label = "Account Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Enabled'} Else {'Disabled'}}}, # the 'if statement# replaces $_.Enabled
    @{Label = "Last LogOn Date";Expression = {$_.lastlogondate}} | 
    #Export CSV report
    Export-Csv -Path $csvreportfile -NoTypeInformation 
	
	}
}
END {} 
}
Export-ADUsers -SearchLoc 'Users' -CSVReportPath 'C:\Admin\CSV' -Server TOLDC01.tol.local


