---------------------------------------------------------------------------------------
$Computer = "localhost"
$Boottime = (Get-WmiObject win32_operatingSystem -computer $Computer -ErrorAction stop).lastbootuptime
$Boottime = [System.Management.ManagementDateTimeconverter]::ToDateTime($BootTIme)
$Now = Get-Date
$span = New-TimeSpan $BootTime $Now
$Uptime = "{0} day(s), {1} hour(s), {2} min(s), {3} second(s)" -f $span.days, $span.hours, $span.minutes, $span.seconds
$Uptime
