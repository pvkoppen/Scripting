' Activity      : Windows: Change Pagefile Size
' Created by    : Peter van Koppen
' Company       : Tui Ora Limited
' Date Created  : 2006-08-08
' Must be run as: <No Preference: Administrators/LocalSystem>
' -----------------------------------------------------------------

'Sets min and max pagefile size
'to some (specified) factor of RAM.
'Mainly developed to dynamically set pagefile
'during automated XP build process.
'Seems also to work on Win2k. As is, modifies
'only pagefiles that are in Windows' default
'location (e.g., c:\pagefile.sys if windows
'is in C:\Windows).
' -----------------------------------------------------------------

'Dave Motovidlak
'03/27/02
' -----------------------------------------------------------------

Option Explicit

Dim objShl
Dim objMem
Dim objModule
Dim objPageFile

Dim intMem
Dim intRamfactor
Dim strSysdrv
Dim strDefaultpagefile
Dim pgfilsz

Set objShl=CreateObject("WScript.Shell")
strSysdrv=objShl.ExpandEnvironmentStrings("%systemdrive%")

'The default page file is put on the systemdrive with this name... 
' -----------------------------------------------------------------
strDefaultpagefile=strSysdrv & "\pagefile.sys" 

'This number times your RAM is the size your pagefile will be. 
' -----------------------------------------------------------------
intRamfactor=2.5

'Connect to the Win32_OperatingSystem class on the local PC 'and count up the memory. 
' -----------------------------------------------------------------
Set objMem=GetObject("WinMgmts:root/cimv2:Win32_OperatingSystem")
For each objModule in objMem.Instances_
     intMem=intMem + objModule.TotalVisibleMemorySize
Next

'Convert to MB.
' -----------------------------------------------------------------
intMem=Int(intMem/1024)

'Unfortunately the Win32_OperatingSystem class doesn't report 'actual physical memory but just what Windows sees as available 'to itself (and the Win32_PhysicalMemory class doesn't seem to work 'on all computers). This code will round up the number to the next nearest 'even number to account for the minute difference.
' -----------------------------------------------------------------
If intMem Mod 2 <>0 Then intMem=intMem+1

'Get a handle on the default pagefile.
' -----------------------------------------------------------------
Set objPageFile=GetObject("WinMgmts:root/cimv2:Win32_PageFileSetting=" & chr(39) & strDefaultpagefile & chr(39))

'calculate the new page file size
' -----------------------------------------------------------------
pgfilsz=intMem*intRamfactor
if pgfilsz > 4095 then 
	pgfilsz = 4000
end if

'Make the min and max size of the pagefile the same
'to avoid fragmentation and therefore boost performance.
' -----------------------------------------------------------------
objPageFile.InitialSize=pgfilsz
objPageFile.MaximumSize=pgfilsz
objPageFile.Put_

Set objPageFile=Nothing
Set objMem=Nothing
Set objShl=Nothing

WScript.Quit

