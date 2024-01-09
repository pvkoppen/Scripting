## -------------------------------------
## Date: 20190728
## Author: Peter van Koppen
## -------------------------------------
## Installed: Centrally, to be run on all PC's
## User: RunAs Admin
## -------------------------------------

## Set Execution Policy
Set-ExecutionPolicy RemoteSigned

## Download and install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Wait.
start-sleep -Seconds 30