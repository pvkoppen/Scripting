 
                         ========================
                            Rebex CONVLOG v1.5
                         ========================

RCONVLOG (Rebex Internet Log Converter) converts web server log files
from W3C log format into NCSA log format. It can be very useful especially
when using a log analyzer which does not support a native IIS format or
a W3C Extended format (e.g. excellent Webalizer - http://www.webalizer.org)

IIS is shipped with a similar program called convlog, which is able to convert
web server log files into NCSA Common Log format. However, using Microsoft
convlog causes some problems: Original convlog does not convert user agents
(browsers) and referrers. It also ignores all uploads, which makes generating
statistics from FTP log files impossible.

RCONVLOG deals with all those difficulties - it is nearly identical to original
convlog, but it does work as expected. In most cases, RCONVLOG can be used as
an out-of-the-box replacement or a bugfix release of the original ;-) 


Advantages of RCONVLOG:
- supports browsers
- supports referrers
- upload, download or both can be choosen for conversion
- a powerful and efficient DNS lookup and a caching mechanism
- Linux and FreeBSD ports are also available

Other features of RCONVLOG:
- converts web server log files from W3C Log Format to NCSA Common Log format
- supports browser agents
- supports referrers
- supports both upload and download
- a powerful and efficient DNS lookup and a caching mechanism
- a call format is compatible with Microsoft convlog.


Note: Currently, RCONVLOG only understands W3C Extended format. If you need
to process MS Internet Standard Log File Format or NCSA Common Log format,
mail us - we will add it upon first request.


Availability:

FREEWARE. Can be downloaded from http://www.rebex.cz/


Portability:

  Platforms:
  - Windows
  - Cygwin (Unix environment for Windows - http://www.cygwin.com)
  - Linux (tested on RedHat 7 and Debian 3, but should compile with other distributions as well)
  - FreeBSD (tested on 4.6.2)

  Compilers:
  - Microsoft Visual C++
  - GCC

  Thanks to Christophe Paquin (http://www.cwd.fr) for initial unix port.



Usage:

rconvlog [options] LogFile1 [LogFile2] [LogFile3] ...

LogFile
    File(s) is W3C format to be converted - may contain wildcards such
    as ? and *.

-o <output directory>
    Directory where logfiles in NCSA Combined format will be created.
    Default is current directory. Created files will have filename
    of the original ones + extension ".ncsa" (or "ncsa.dns" for -d option).

-c <hostname cache file>
    Use this file as hostname cache. If filename without path is specified,
    path of RCONVLOG.exe (use .\filename to specify
    file in current directory). Cache saves time when executing RCONVLOG
    multiple - resolved hostnames can be reused.

-t <ncsa[:GMTOffset]>
    Specifies GTM Offset to use in NCSA logfile. Default is ncsa:+0000.

-d  Convert IP addresses to domain names if possible.

-w  Overwrite existing NCSA log files (default is append).
    
-b<0|1|2|3>
    How to log bytes sent:
    0 = be compatible with convlog (default)
    1 = log bytes sent from server to client only (download)
    2 = log bytes sent from client to server only (upload)
    3 = log sum of bytes sent both ways (upload and download)

-n YYYY-MM-DDTHH:NN:SS
    Ignore records older than specified datetime (eg. -n 2001-12-20T00:00:00)

-h H
    Ignore records older than H hours (eg. -h 164)

Version history:
    v1.0 - 2001-05-17 - initial version
    v1.1 - 2001-10-30 - added support for ignoring old records (-n and -h arguments)
    v1.2 - 2002-01-06 - fixed a simple bug which caused rconvlog to ignore january records
    v1.3 - 2002-12-17 - many enhancements and smaller bug fixes
                      - rconvlog now compiles on windows and unix
                      - changed the way of progress reporting
    v1.4 - 2004-07-08 - fixed a bug that caused fields to be ignored if their number
                        exceeded 21
    v1.5 - 2005-04-29 - fixed a bug that caused negative offsets of -t argument to fail
                      - output directory specified by -o and input files specified
                        by LogFile arguments are now combined to an output path
                        correctly


Copyright (c) 2001-2005 Rebex
Written by Lukas Pokorny (lukas.pokorny@rebex.cz)
http://wwww.rebex.net
