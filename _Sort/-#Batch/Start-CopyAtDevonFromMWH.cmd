::@ECHO OFF


Robocopy /R:1 /W:1 "\\tolmm02\backup$\Data\MedTech32\TOLMT02\20151029[Thu]-pm0328\." "%temp%\." *.ibk

Del %temp%\.\*.ibk