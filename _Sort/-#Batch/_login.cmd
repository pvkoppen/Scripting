@ECHO OFF

NET USE x
NET USE Y

IF %COMPUTERNAME%' == PC' cscript PrinterManagement.vbs AddPrinter \\Server\Printer
IF %COMPUTERNAME%' == PC' cscript PrinterManagement.vbs AddPrinter "\\Server\Printer Name Here"
CScript PrinterManagement.vbs AddPrinter \\Server\Printer

CScript PrinterManagement.vbs RemovePrinter \\Server\Printer
CScript PrinterManagement.vbs RemovePrinter "\\Server\Printer Name Here"

