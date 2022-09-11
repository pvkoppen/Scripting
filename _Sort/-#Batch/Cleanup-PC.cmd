@ECHO OFF
C:
CD \Users
FOR /D %%A in (*.*) DO ECHO [INFO ] User: %%A&&rmdir /s /q ".\%%A\AppData\Local\Microsoft\Windows\Temporary Internet Files\."
FOR /D %%A in (*.*) DO ECHO [INFO ] User: %%A&&rmdir /s /q ".\%%A\AppData\Local\Temp\."
ECHO [INFO ] Windows: %%A&&rmdir /s /q "C:\Windows\Temp\."

PAUSE


