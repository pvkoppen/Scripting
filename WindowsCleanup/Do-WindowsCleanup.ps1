# ------------------------------------------------------------------
# Do-WindowsCleanup.ps1
# ------------------------------------------------------------------
# Simple script to call Windows cleanup tasks.
# ------------------------------------------------------------------

Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
Dism.exe /Online /Cleanup-Image /StartComponentCleanup 
Dism.exe /Online /Cleanup-Image /spsuperseded

cleanmgr.exe
