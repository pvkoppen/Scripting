Requires at least Powershell V3

Step 1: populate '_computers.txt' with your list of servers
Step 2: run getLastPatchDates using PowerShell ISE to get the data

Note: the account under which the script runs must have administrative access to the servers

Output files as follows:
- online.txt --> online servers
- offline.txt --> offline servers
- fullreport.txt --> full report containing last patch and reboot dates
- onlineInaccessible.txt --> inaccessible servers
- not-patched.txt --> servers not patch "today"
- patched.txt --> servers patched "today"

By ITomation