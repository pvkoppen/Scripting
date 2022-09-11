-----------------------------------------------------------------

H E W L E T T - P A C K A R D   C O M P A N Y

SmartStart Scripting Toolkit


-----------------------------------------------------------------

1.  Memory Considerations
2.  Creating a Network Boot Diskette
3.  AUTOEXEC.BAT and CONFIG.SYS
4.  Disk Partition Creation Utility (CPQDISK.EXE)
5.  File Copy Utility (FILECOPY.EXE)
6.  Automating the Creation of $OEM$ Subdirectories for 
    Windows NT 4.0, Windows 2000 and Windows 2003
7.  New Hardware Support
8. SSSTKSYS.INI
9. Network-Based Deployment of Novell NetWare 5.1 on EISA 
    Servers (Pre ML/DL)

----------------------------------------------------------------

IMPORTANT: All of the examples provided in the SmartStart(TM) 
Scripting Toolkit and in the SmartStart Scripting Toolkit Best 
Practices use specific hardware and software. The Microsoft 
Windows NT 4.0, Windows 2000, Windows 20003, Red Hat Linux 6.2 or 7.0, and Ghost examples have been tested using MS-DOS 6.22 and MS-DOS 7.0. The 
Novell NetWare 5.1 examples have been tested using Caldera DOS 
7.02. The examples have been shown to work using specific 
hardware and software configurations. Using these examples 
without customizing them for your specific environment will 
likely result in failed installations. The batch files included 
in the SmartStart Scripting Toolkit are intended to show how the 
server configuration and operating system installation processes 
flow. There are numerous variations to how the toolkit utilities 
can be used, depending on your environment and process.

The source directories given during file copy operations are 
examples only. The actual source directories you use to copy the
files necessary to perform an operating system installation may 
differ from the examples. However, the destination directories are
required structures. Each operating system has a predefined method
of obtaining new drivers for use during the installation. You must
adhere to the standards of each operating system for the 
installation to be successful. The example file provided in the 
SmartStart Scripting Toolkit Best Practices will create the 
necessary destination directories and copy the required files to 
these directories.

For frequently asked questions and troubleshooting tips, refer to
the Hewlett-Packard website:

http://h18013.www1.hp.com/products/servers/management/toolkit/questionsanswers.html


1. Memory Considerations

All of the SmartStart Scripting Toolkit utilities use the MS-DOS
operating system, which is limited to 640 KB of addressable 
memory.The examples provided for creating network accessible disks
may create situations where there is not enough free memory to 
execute the utilities in your environment. Ensure that sufficient
free memory is available in your DOS operating system after all of
the necessary device drivers are loaded.


2. Creating a Network Boot Diskette

The "Creating a Bootable Server Configuration Diskette with 
Network Software" sections for Microsoft Windows NT 4.0, Windows 
2000, and Red Hat Linux 6.2 refer to the Client Administrator tool
from Microsoft Windows NT 4.0 Server.

Appendix B has been included to illustrate an alternate way of
creating a bootable server configuration diskette with network
software by using the Microsoft Network Client 3.0 files, 
available on the Microsoft FTP site:

ftp.microsoft.com/bussys/clients/msclient

Use whichever method is appropriate to your network environment.

When using the Client Administrator tool from Microsoft Windows NT
4.0 Server, additional steps may be necessary to create the 
bootable network diskette using the documentation provided in the
SmartStart Scripting Toolkit Best Practices. These additional 
steps set up the client tools for initial use. After the initial
setup, the tools function similarly to what is described in the 
user guide. There are some minor differences between the 
documentation and how the tools function. Refer to the Microsoft 
Windows NT 4.0 Server documentation for additional information 
about how to set up and use the Client Administrator tool.

One known issue with Microsoft Windows NT 4.0 Server is that the 
Intel-based NIC drivers are not included in the original 
distribution of the operating system. Consequently, updated NIC 
drivers must be obtained from the Hewlett-Packard website:

http://h18000.www1.hp.com/support/files/


3. AUTOEXEC.BAT and CONFIG.SYS

The file lists provided in the SmartStart Scripting Toolkit Best 
Practices for the CONFIG.SYS and AUTOEXEC.BAT files were used 
during testing. These file lists must be modified to work with 
your network environment.


4. Compaq Disk Partition Creation Utility (CPQDISK.EXE)

CPQDISK is limited to creating 4,000-megabyte partitions.  When 
reading the partition table from an existing drive, the utility
limits the partition to 4,000 megabytes and writes a note to the
partition information file.

To extend the partition size on a Microsoft Windows NT 4.0,
Windows 2000 server, or Windows 2003 Server insert the following entries into the UNATTEND.TXT file:

   [Unattended]
   ExtendOemPartition=1
   FileSystem=ConvertNTFS

These entries will increase the partition size to use the
available disk space and will convert the partition to the NTFS
file system. Refer to the Microsoft Windows NT 4.0, Windows
2000 and Windows 2003 documentation for details on these parameters.

NOTE: The Novell NetWare 5.1 system volume is created during the 
installation of the operating system. Changing the size of the
partition created by the CPQDISK is not necessary.



5. File Copy Utility (FILECOPY.EXE)

The configuration batch files included in the SmartStart Scripting
Toolkit Best Practices use FILECOPY to copy the necessary drivers
and support files to the target server. Depending on the amount of
conventional memory available on the target server and the size of
the subdirectory being copied to the target, FILECOPY may fail in
the copy process. Always ensure that sufficient free memory is
available in your DOS operating system to run the toolkit
utilities.

As a workaround, use the DOS XCOPY utility to copy the drivers and
support files to the target server. XCOPY is DOS-version dependent
and will not work if there are differences between the DOS version
that boots the server and the version of the XCOPY executable
file. If you prefer to use the internal DOS COPY command instead
of the XCOPY utility, add steps to the configuration batch files
to create the destination directories before copying files to the
directories.


6. Automating the Creation of $OEM$ Subdirectories for Windows NT 
   4.0, Windows 2000 and Windows 2003

The example batch files included in the SmartStart Scripting
Toolkit Best Practices to automate the creation of the Microsoft
Windows NT 4.0, Windows 2000 and Windows 2003 $OEM$ subdirectories use the DOS XCOPY utility to copy the necessary drivers and support files.
XCOPY is DOS-version dependent and will not work if there are
differences between the DOS version that boots the server and
the version of the XCOPY executable file. If you prefer to use
the internal DOS COPY command instead of the XCOPY utility,
add steps to the batch files to create the destination
directories before copying files to the directories.


7. New Hardware Support

The Compaq SmartStart Scripting Toolkit utilities require
SmartStart 6.0 or later to run. However, the current
release of the SmartStart Scripting Toolkit supports new
hardware that wasn't originally supported by the
SmartStart 6.0 CD. The latest driver files for the newer
hardware are located on the SmartStart 6.1 CD or on the
driver diskette of the option. The latest driver files
can also be downloaded from the Hewlett-Packard website:

http://h18000.www1.hp.com/support/files/

Ensure that you are using the correct driver package that
supports the newer hardware. The directory structures of
the installation CD or of the network software
repository may need to be modified when you copy the
latest driver files to these locations.


8. SSSTKSYS.INI

The SmartStart Scripting Toolkit includes a translation script file called SSSTKSYS.INI for the System Type utility. This file can be edited with any standard text editor to remove or include other servers. Refer to Chapter 2 of the Compaq SmartStart Scripting Toolkit User Guide 1.2 for additional information about this file.

The SSSTKSYS.INI file will be updated to support the
latest servers with every release of the Compaq
SmartStart Scripting Toolkit. If you customize the
file for your server environment, ensure that your 
changes are not overwritten by future versions of the
SSSTKSYS.INI file.


9. Network-Based Deployment of Novell NetWare 5.1 on EISA 
    Servers (Pre ML/DL)

The Server Configuration diskette with the Network Software may 
lock up on an unconfigured EISA server because it does not
recognize more than 16MB of memory in the system until the
system is configured. As a workaround add the following command
to the beginning of the CONFIG.SYS file:

device=memory.sys

Copy MEMORY.SYS from the \Repflat directory on the SmartStart
CD to the Server Configuration diskette.  

---------------------------------------------------------------

Copyright 2002, 2003 Hewlett-Packard Development Company, L.P. 

Hewlett-Packard Company shall not be liable for technical or editorial errors or omissions contained herein. The information in this document is provided "as is" without warranty of any kind and is subject to change without notice. The warranties for HP products are set forth in the express limited warranty statements accompanying such products. Nothing herein should be construed as constituting an additional warranty. 
