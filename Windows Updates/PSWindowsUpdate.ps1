set-executionpolicy Unrestricted

Install-Module PSWindowsUpdate

Import-Module PSWindowsUpdate

Get-Command –module PSWindowsUpdate

Add-WUServiceManager -ServiceID 3da21691-e39d-4da6-8a4b-b43877bcb1b7

Get-WUInstall –MicrosoftUpdate –AcceptAll –AutoReboot

Install-WindowsUpdate