::@ECHO OFF

sqlcmd -S np:\\.\pipe\MSSQL$MICROSOFT##SSEE\sql\query –i %~dp0\SQL\WsusDBMaintenance.sql