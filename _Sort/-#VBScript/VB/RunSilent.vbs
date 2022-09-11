'ignore errors to avoid prompts
on error resume next

' if no arguments, just quit
if WScript.Arguments.count = 0 then wscript.quit

' Build the supplied arguments into a single string, with double quotes around arguments with spaces
' not expecting any errors to occur in the below loop - this code is not reached if there are no arguments
CommandLine = ""
For i = 0 To WScript.Arguments.Count-1
	if instr(WScript.Arguments(i)," ") then
		CommandLine = CommandLine + """"+ WScript.Arguments(i) + """ "
  else
		CommandLine = CommandLine + WScript.Arguments(i) + " "
	end if
Next
CommandLine = Trim(CommandLine)

' run the supplied commandline hidden
CreateObject("Wscript.Shell").Run CommandLine, 0, False
