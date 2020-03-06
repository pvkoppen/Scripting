
Param (
    [parameter(Mandatory=$false)][datetime]$Date,
    [parameter(Mandatory=$false)][bool]$iCalendar
)

Begin {
    Write-Host "[INFO ] -- Beginning..."
}

Process {
    function WriteDateTime ([parameter(Mandatory=$true)]$DateTime) {
        ($DateTime).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
    }
    function StartCalendar($Occurances, $Subject) {
<#
PRODID:PvK-Powershell
VERSION:2.0
ATTENDEE;RSVP=TRUE;ROLE=REQ-PARTICIPANT:mailto:jsmith@example.com
ORGANIZER;CN="John Smith":mailto:jsmith@example.com
#>
        $script:dtStamp = Get-Date
        $script:dtInstance = 0
        $script:dtOccurance = $Occurances
        Write-Host "BEGIN:VCALENDAR"
        Write-Host "PRODID:PvK-Powershell"
        Write-Host "VERSION:2.0"
        Write-Host "BEGIN:VEVENT"
        Write-Host "CREATED:$(WriteDateTime $script:dtStamp)"
        Write-Host "DTSTAMP:$(WriteDateTime $script:dtStamp)"
        Write-Host "LAST-MODIFIED:$(WriteDateTime $script:dtStamp)"
        Write-Host "RRULE:FREQ=DAILY;UNTIL=$(WriteDateTime ($script:dtStamp).AddDays($occurances-1))"
        Write-Host "SUMMARY:Windows Patching - $($Subject)"
        Write-Host "TRANSP:OPAQUE"
        Write-Host "UID:WINDOWS-PATCHING-2020-MARCH"
        Write-Host "LOCATION:Methanex NZ"
        Write-Host "DESCRIPTION:Windows Patching - $($Subject)"
        Write-Host "END:VEVENT"
    }
<#
BEGIN:VEVENT
CREATED:20151219T021727Z
DTEND;TZID=America/Toronto:20170515T110000
DTSTAMP:20151219T021727Z
DTSTART;TZID=America/Toronto:20170515T100000
LAST-MODIFIED:20151219T021727Z
RRULE:FREQ=DAILY;UNTIL=20170519T035959Z
SEQUENCE:0
SUMMARY:Meeting
TRANSP:OPAQUE
UID:21B97459-D97B-4B23-AF2A-E2759745C299
END:VEVENT
#-------------------------------
BEGIN:VALARM
TRIGGER:-PT10M
DESCRIPTION:Pickup Reminder
ACTION:DISPLAY
END:VALARM
#>
    function AddCalendarDate($Start, $Finish, $Subject, $Instance) {
        Write-Host "BEGIN:VEVENT"
        Write-Host "CREATED:$(WriteDateTime $script:dtStamp)"
        Write-Host "DTSTAMP:$(WriteDateTime $script:dtStamp)"
        Write-Host "LAST-MODIFIED:$(WriteDateTime $script:dtStamp)"
        Write-Host "RECURRENCE-ID:$(WriteDateTime ($script:dtStamp).AddDays($Instance-1))"
        Write-Host "DTEND:$(WriteDateTime $Finish)"
        Write-Host "DTSTART:$(WriteDateTime $Start)"
        Write-Host "SUMMARY:Windows Patching - $($Subject)"
        #Write-Host "TRANSP:OPAQUE"
        Write-Host "UID:WINDOWS-PATCHING-2020-MARCH"
        #Write-Host "LOCATION:Methanex NZ"
        Write-Host "DESCRIPTION:Windows Patching - $($Subject)"
        Write-Host "BEGIN:VALARM"
        Write-Host "TRIGGER:-PT30M"
        #Write-Host "DESCRIPTION:Windows Patching - $($Subject)"
        Write-Host "ACTION:DISPLAY"
        Write-Host "END:VALARM"
        Write-Host "END:VEVENT"
    }
    function StopCalendar() {
        Write-Host "END:VCALENDAR"
    }
    if ($Date) {
        #$date = (get-date).AddMonths(0)
        $ProcessDate = Get-Date -Date (($Date).ToString("yyyy-MM-05"))
    } else {
        $ProcessDate = Get-Date -Date (Get-Date -format "yyyy-MM-05")
    }
    $PatchTuesday  = $ProcessDate.AddDays(9-$ProcessDate.DayOfWeek)
    $ProcessDate   = $ProcessDate.AddDays(-4)
    Write-Host "Check for Month: '$($ProcessDate.ToLongDateString())'"
    Write-Host "Patch Tuesday: '$(($PatchTuesday).ToLongDateString())'"
    #Friday after second Tuesday
    $TestChangeLogStart     = ($PatchTuesday).AddDays(03).AddHours(09)
    $TestChangeLogEnd       = ($TestChangeLogStart).AddHours(00).AddMinutes(30)
    #Friday-Week after second Tuesday
    $ProdChangeLogStart     = ($PatchTuesday).AddDays(10).AddHours(09)
    $ProdChangeLogEnd       = ($ProdChangeLogStart).AddHours(00).AddMinutes(30)
    #Wednesday-Week after second Tuesday
    $TestNotifyStart        = ($PatchTuesday).AddDays(08).AddHours(09)
    $TestNotifyEnd          = ($TestNotifyStart).AddHours(00).AddMinutes(30)
    #Wednesday-Week after second Tuesday
    $TestCheckStart         = ($PatchTuesday).AddDays(08).AddHours(09).AddMinutes(30)
    $TestCheckEnd           = ($TestCheckStart).AddHours(00).AddMinutes(30)
    #Thursday-Week after second Tuesday
    $TestPatchStart         = ($PatchTuesday).AddDays(09).AddHours(15)
    $TestPatchEnd           = ($TestPatchStart).AddHours(03).AddMinutes(00)
    #Monday-Week after second Tuesday
    $ProdFirstNotifyStart   = ($PatchTuesday).AddDays(13).AddHours(09)
    $ProdFirstNotifyEnd     = ($ProdFirstNotifyStart).AddHours(00).AddMinutes(30)
    #Wednesday-2Week after second Tuesday
    $ProdSecondNotifyStart  = ($PatchTuesday).AddDays(15).AddHours(09)
    $ProdSecondNotifyEnd    = ($ProdSecondNotifyStart).AddHours(00).AddMinutes(30)
    #Thursday-2Week after second Tuesday
    $ProdStanddownStart     = ($PatchTuesday).AddDays(16).AddHours(08)
    $ProdStanddownEnd       = ($ProdStanddownStart).AddHours(04).AddMinutes(00)
    #Thursday-2Week after second Tuesday
    $ProdCheckStart         = ($PatchTuesday).AddDays(16).AddHours(16)
    $ProdCheckEnd           = ($ProdCheckStart).AddHours(00).AddMinutes(30)
    #Thursday-2Week after second Tuesday
    $ProdFirstPatchStart    = ($PatchTuesday).AddDays(16).AddHours(19)
    $ProdFirstPatchEnd      = ($ProdFirstPatchStart).AddHours(05).AddMinutes(-1)
    #Friday-2Week after second Tuesday
    $ProdSecondPatchStart   = ($PatchTuesday).AddDays(17).AddHours(09)
    $ProdSecondPatchEnd     = ($ProdSecondPatchStart).AddHours(03).AddMinutes(00)
    #First workday of next month
    $ScheduleNextMonthStart = ($ProcessDate).AddMonths(1).AddHours(09)
    while ((($ScheduleNextMonthStart).DayOfWeek -gt 6) -or (($ScheduleNextMonthStart).DayOfWeek -lt 1)) {
        #Write-Host "Checking: Schedule next month: '$($ScheduleNextMonthStart.ToString('f'))'."
        $ScheduleNextMonthStart = $ScheduleNextMonthStart.AddDays(1)
    }
    $ScheduleNextMonthEnd   = ($ScheduleNextMonthStart).AddHours(00).AddMinutes(30)
    if ($iCalendar) {
        StartCalendar -Occurances 13 -Subject "$(($ProcessDate).ToString("yyyy-MM (MMM)"))"
        AddCalendarDate -Instance 01 -Start ($PatchTuesday).AddHours(09) -Finish ($PatchTuesday).AddHours(09) -Subject "Patch Tuesday"
        AddCalendarDate -Instance 02 -Start $TestChangeLogStart -Finish $TestChangeLogEnd -Subject "Test patching change logged in SDPlus"
        AddCalendarDate -Instance 03 -Start $TestNotifyStart -Finish $TestNotifyEnd -Subject "Phase 1 - Test patching - Send notification"
        AddCalendarDate -Instance 04 -Start $TestCheckStart -Finish $TestCheckEnd -Subject "Phase 1 - Test patching - Servers Check"
        AddCalendarDate -Instance 05 -Start $TestPatchStart -Finish $TestPatchEnd -Subject "Phase 1 - Test patching"
        AddCalendarDate -Instance 06 -Start $ProdChangeLogStart -Finish $ProdChangeLogEnd -Subject "Production patching change logged in SDPlus"
        AddCalendarDate -Instance 07 -Start $ProdFirstNotifyStart -Finish $ProdFirstNotifyEnd -Subject "Phase 2 - Production patching - Send first notification"
        AddCalendarDate -Instance 08 -Start $ProdSecondNotifyStart -Finish $ProdSecondNotifyEnd -Subject "Phase 2 - Production patching - Send second notification"
        AddCalendarDate -Instance 09 -Start $ProdCheckStart -Finish $ProdCheckEnd -Subject "Phase 2 - Production patching - Servers Check"
        AddCalendarDate -Instance 10 -Start $ProdStanddownStart -Finish $ProdStanddownEnd -Subject "Prod stand-down"
        AddCalendarDate -Instance 11 -Start $ProdFirstPatchStart -Finish $ProdFirstPatchEnd -Subject "Phase 2 - Production patching"
        AddCalendarDate -Instance 12 -Start $ProdSecondPatchStart -Finish $ProdSecondPatchEnd -Subject "Phase 3 - Production patching - Plant and CCTV systems"
        AddCalendarDate -Instance 13 -Start $ScheduleNextMonthStart -Finish $ScheduleNextMonthEnd -Subject "Schedule patching for next month"
        StopCalendar
    } else {
        #Write-Host "Patch Tuesday: '$($PatchTuesday.ToLongDateString())'."
        Write-Host "Test patching change logged in SDPlus: '$($TestChangeLogStart.ToString('f'))', finish at: '$($TestChangeLogEnd.ToShortTimeString())'."
        Write-Host "Phase 1 - Test patching – Send notification: '$($TestNotifyStart.ToString('f'))', finish at: '$($TestNotifyEnd.ToShortTimeString())'."
        Write-Host "Phase 1 - Test patching - Servers check: '$($TestCheckStart.ToString('f'))', finish at: '$($TestCheckEnd.ToShortTimeString())'."
        Write-Host "Phase 1 - Test patching: '$($TestPatchStart.ToString('f'))', finish at: '$($TestPatchEnd.ToShortTimeString())'."
        Write-Host "Production patching change logged in SDPlus: '$($ProdChangeLogStart.ToString('f'))', finish at: '$($ProdChangeLogEnd.ToShortTimeString())'."
        Write-Host "Phase 2 - Production patching - Send first notification: '$($ProdFirstNotifyStart.ToString('f'))', finish at: '$($ProdFirstNotifyEnd.ToShortTimeString())'."
        Write-Host "Phase 2 - Production patching - Send second notification: '$($ProdSecondNotifyStart.ToString('f'))', finish at: '$($ProdSecondNotifyEnd.ToShortTimeString())'."
        Write-Host "Phase 2 - Production patching - Server check: '$($ProdCheckStart.ToString('f'))', finish at: '$($ProdCheckEnd.ToShortTimeString())'."
        Write-Host "Phase 2 - Production patching - Stand-down period: '$($ProdStanddownStart.ToString('f'))', finish at: '$($ProdStanddownEnd.ToShortTimeString())'."
        Write-Host "Phase 2 - Production patching: '$($ProdFirstPatchStart.ToString('f'))', finish at: '$($ProdFirstPatchEnd.ToShortTimeString())'."
        Write-Host "Phase 3 - Production patching - Plant and CCTV systems: '$($ProdSecondPatchStart.ToString('f'))', finish at: '$($ProdSecondPatchEnd.ToShortTimeString())'."
        Write-Host "Schedule patching for next month: '$($ScheduleNextMonthStart.ToString('f'))', finish at: '$($ScheduleNextMonthEnd.ToShortTimeString())'."
    }
}

End{
    Write-Host "[INFO ] -- Ending."
}
