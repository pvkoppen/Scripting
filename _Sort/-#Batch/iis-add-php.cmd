MKDIR %SYSTEMDRIVE%\Inetpub\PHP
REM ECHO Extract PHP files from ZIP archive into %SYSTEMDRIVE%\Inetpub\PHP
REM COPY /Y %SYSTEMDRIVE%\Inetpub\PHP\PHP.INI-Recommended %SYSTEMDRIVE%\Inetpub\PHP\PHP.INI
PUSHD %SYSTEMROOT%\System32\inetsrv
APPCMD SET CONFIG -section:handlers -+[name='Prog-PHP5',path='*.php,*.phtml',verb='GET,HEAD,POST',modules='IsapiModule',scriptProcessor='%SYSTEMDRIVE%\Programs\PHP_v5\php5isapi.dll',resourceType='File']
APPCMD SET CONFIG -section:isapiCgiRestriction -+[path='%SYSTEMDRIVE%\Programs\PHP_v5\php5isapi.dll',allowed='true',groupId='PHP5',description='Prog-PHP5']
APPCMD SET CONFIG -section:isapiCgiRestriction -+[path='%SYSTEMDRIVE%\InetPub\PHP_v5\php5isapi.dll',allowed='true',groupId='PHP5',description='Inet-PHP5']
POPD
