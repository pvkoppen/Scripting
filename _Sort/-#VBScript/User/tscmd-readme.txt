tscmd Readme file
=================

tscmd is used to change the setting for Terminal Server from a command prompt or script:

Syntax:

   tscmd <Server> <User> <Setting> [New Value]

Server, User, and Setting are required.  New Value is optional.  When a new value is not supplied, tscmd will display the current setting.

Setting should have one of the following values:

InitialProgram
WorkingDirectory
InheritInitialProgram (*)
AllowLogonTerminalServer (*)
TimeoutConnection (*)
TimeoutDisconnect (*)
TimeoutIdle (*)
DeviceClientDrives (*)
DeviceClientPrinters (*)
DeviceClientDefaultPrinter (*)
BrokenTimeoutSettings (*)
ReconnectSettings (*)
ModemCallbackSettings (*)
ModemCallbackPhoneNumber
ShadowingSettings (*)
TerminalServerProfilePath
TerminalServerHomeDir
TerminalServerHomeDirDrive

Settings marked with an '*' are numeric-only.  

- If these settings are displayed as true/false in a GUI, use a value of '0' to turn the setting OFF and '1' to turn the setting ON.

- If these settings are displayed as having multiple values in a GUI, use the following guide:

ModemCallbackSettings
=====================
0 = Callback connections are disabled.
1 = The server prompts the user to enter a phone number and calls the user back at that phone number. You can use the WTSUserConfigModemCallbackPhoneNumber value to specify a default phone number.
2 = The server automatically calls the user back at the phone number specified by the WTSUserConfigModemCallbackPhoneNumber value.

ShadowingSettings
=================
0 = Disable
1 = Enable input, notify
2 = Enable input, no notify
3 = Enable no input, notify
4 = Enable no input, no notify


If there are any question or problems with this utility, please contact SystemTools.com support at:

support@systemtools.com

This is a FREE utility.  SystemTools Software Inc. assumes no liability for its use by anyone.
