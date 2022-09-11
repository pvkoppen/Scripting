C:
cd C:\Users\peter\AppData\Local\Temp
del /s /q *.*

cd C:\Program Files\Adobe\Reader 8.0\Setup Files
del /s /q *.*

cd C:\Users\peter\AppData\Local\Mozilla\Firefox\Profiles\1mdg0qf9.default\Cache
del /s /q *.*

cd C:\Windows\SoftwareDistribution\Download
del /s /q *.*

goto end
Vista C drive Cleanup dirs.
C:\Program Files\Lenovo\System Update\session\*\*.* - *.xml
C:\Users\peter\AppData\Local\Downloaded\
- C:\Users\peter\AppData\Local\Temp
- C:\Program Files\Adobe\Reader 8.0\Setup Files
- C:\Users\peter\AppData\Local\Mozilla\Firefox\Profiles
C:\Users\peter\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5
C:\Users\peter\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.MSO
C:\Users\peter\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Outlook
C:\Users\peter\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Word
C:\Users\peter\AppData\Local\Microsoft\Windows\Temporary Internet Files\Virtualized
C:\Users\PreInstalled\AppData\Local\Microsoft\Windows\Temporary Internet Files\Low\Content.IE5
C:\Windows\inf\setupapi*.log
C:\Windows\Installer
- C:\Windows\SoftwareDistribution\Download

:end
pause