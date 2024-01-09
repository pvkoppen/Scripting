# Install-Chocolatey
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install-Packages
#all
choco upgrade -y 7zip adobereader beyondcompare brave chromium google-chrome-for-enterprise keepass microsoft-edge microsoft-teams notepadplusplus OneDrive putty superputty sysinternals winscp
#private
#choco upgrade -y github-desktop google-backup-and-sync skype WhatsApp zoom
#choco upgrade -y google-chrome-for-enterprise --checksum 84F77C06EAE41F9A64B9F3E60F5E9B59ED910E59C6A661E566D96152432D809B

# List-Local-Packages
#choco list --local > choco-list-local.txt

# Update-AllPackages
choco upgrade all -y
#choco upgrade all -y --force
