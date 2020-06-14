
Param (
    [parameter(Mandatory=$false)][datetime]$Date,
    [parameter(Mandatory=$false)][bool]$iCalendar = $true
)

Begin {
    Write-Host "[INFO ] -- Beginning..."
}

<#
Make sure you have "X-MS-OLK-FORCEINSPECTOROPEN:TRUE" in the VCALENDAR part of your file. This allows an ICS file with multiple VEVENTs to import into your default calendar in Outlook. No new calendar created.

Tested this and it doesn't appear to work fully, at least in O365 Outlook. It prompts to add only the first VEVENT in the file - any others are no added to the main calendar.

X-MS-OLK-FORCEINSPECTOROPEN:TRUE only effects the outlook calendar the event is added to. If you are only processing the first VEVENT, the there is another issue with your ICS file. Issues relatred witrh the UID or start times/dates so the system can match the VEVENTS.
#>

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
        Write-Host "X-MS-OLK-FORCEINSPECTOROPEN:TRUE"
        Write-Host "BEGIN:VEVENT"
        Write-Host "CREATED:$(WriteDateTime $script:dtStamp)"
        Write-Host "DTSTAMP:$(WriteDateTime $script:dtStamp)"
        Write-Host "LAST-MODIFIED:$(WriteDateTime $script:dtStamp)"
        Write-Host "RRULE:FREQ=DAILY;UNTIL=$(WriteDateTime ($script:dtStamp).AddDays($occurances-1))"
        Write-Host "SUMMARY:Windows Patching - $($Subject)"
        Write-Host "TRANSP:OPAQUE"
        Write-Host "UID:WINDOWS-PATCHING-$(($script:dtStamp).Year)-$(($script:dtStamp).Month)"
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
    function AddCalendarDate($Start, $Finish, $Subject) {
        $script:dtInstance = $script:dtInstance+1
        If ($script:dtInstance -lt $script:dtOccurance) {
            Write-Host "BEGIN:VEVENT"
            Write-Host "CREATED:$(WriteDateTime $script:dtStamp)"
            Write-Host "DTSTAMP:$(WriteDateTime $script:dtStamp)"
            Write-Host "LAST-MODIFIED:$(WriteDateTime $script:dtStamp)"
            Write-Host "RECURRENCE-ID:$(WriteDateTime ($script:dtStamp).AddDays($script:dtInstance-1))"
            Write-Host "DTEND:$(WriteDateTime $Finish)"
            Write-Host "DTSTART:$(WriteDateTime $Start)"
            Write-Host "SUMMARY:Windows Patching - $($Subject)"
            #Write-Host "TRANSP:OPAQUE"
            Write-Host "UID:WINDOWS-PATCHING-$(($script:dtStamp).Year)-$(($script:dtStamp).Month)"
            #Write-Host "LOCATION:Methanex NZ"
            Write-Host "DESCRIPTION:Windows Patching - $($Subject)"
            Write-Host "BEGIN:VALARM"
            Write-Host "TRIGGER:-PT30M"
            #Write-Host "DESCRIPTION:Windows Patching - $($Subject)"
            Write-Host "ACTION:DISPLAY"
            Write-Host "END:VALARM"
            Write-Host "END:VEVENT"
        }
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
    Write-Host "Check for Month: `t$($ProcessDate.ToLongDateString())"
    Write-Host "Patch Tuesday: `t$(($PatchTuesday).ToLongDateString())"
    #Friday after second Tuesday
    $TestChangeLogStart     = ($PatchTuesday).AddDays(03).AddHours(09) # Friday after PT
    $TestChangeLogEnd       = ($TestChangeLogStart).AddHours(00).AddMinutes(30)
    #Wednesday-Week after second Tuesday
    $TestNotifyStart        = ($PatchTuesday).AddDays(08).AddHours(09) 
    $TestNotifyEnd          = ($TestNotifyStart).AddHours(00).AddMinutes(30)
    #Wednesday-Week after second Tuesday
    $TestCheckStart         = ($PatchTuesday).AddDays(08).AddHours(09).AddMinutes(30)
    $TestCheckEnd           = ($TestCheckStart).AddHours(01).AddMinutes(00)
    #Thursday-Week after second Tuesday
    $TestPatchStart         = ($PatchTuesday).AddDays(09).AddHours(15)
    $TestPatchEnd           = ($TestPatchStart).AddHours(03).AddMinutes(00)
    #Friday-Week after second Tuesday
    $ProdChangeLogStart     = ($PatchTuesday).AddDays(10).AddHours(09) # Friday 1wk after PT
    $ProdChangeLogEnd       = ($ProdChangeLogStart).AddHours(00).AddMinutes(30)
    #Monday-Week after second Tuesday
    $ProdFirstNotifyStart   = ($PatchTuesday).AddDays(13).AddHours(09)
    $ProdFirstNotifyEnd     = ($ProdFirstNotifyStart).AddHours(00).AddMinutes(30)
    #Wednesday-2Week after second Tuesday
    $ProdSecondNotifyStart  = ($PatchTuesday).AddDays(15).AddHours(09)
    $ProdSecondNotifyEnd    = ($ProdSecondNotifyStart).AddHours(00).AddMinutes(30)
    #Wednesday-2Week after second Tuesday
    $ProdCheckStart         = ($PatchTuesday).AddDays(15).AddHours(09).AddMinutes(30)
    $ProdCheckEnd           = ($ProdCheckStart).AddHours(01).AddMinutes(00)
    #Thursday-2Week after second Tuesday
    $ProdStanddownStart     = ($PatchTuesday).AddDays(16).AddHours(08)
    $ProdStanddownEnd       = ($ProdStanddownStart).AddHours(04).AddMinutes(00)
    #Thursday-2Week after second Tuesday
    $ProdFirstPatchStart    = ($PatchTuesday).AddDays(16).AddHours(19)
    $ProdFirstPatchEnd      = ($ProdFirstPatchStart).AddHours(05).AddMinutes(-1)
    #Friday-2Week after second Tuesday
    $ProdSecondPatchStart   = ($PatchTuesday).AddDays(17).AddHours(09)
    $ProdSecondPatchEnd     = ($ProdSecondPatchStart).AddHours(03).AddMinutes(00)
    #First workday of next month
    $ScheduleNextMonthStart = ($ProcessDate).AddMonths(1).AddHours(09)
    while ((($ScheduleNextMonthStart).DayOfWeek -gt 6) -or (($ScheduleNextMonthStart).DayOfWeek -lt 1)) {
        #Write-Host "Checking: Schedule next month: '$($ScheduleNextMonthStart.ToString("f"))'."
        $ScheduleNextMonthStart = $ScheduleNextMonthStart.AddDays(1)
    }
    $ScheduleNextMonthEnd   = ($ScheduleNextMonthStart).AddHours(00).AddMinutes(30)
    if ($iCalendar) {
        StartCalendar -Occurances 13 -Subject "$(($ProcessDate).ToString("yyyy-MM (MMM)"))"
        AddCalendarDate -Start ($PatchTuesday).AddHours(09) -Finish ($PatchTuesday).AddHours(09) -Subject "Patch Tuesday"
        AddCalendarDate -Start $TestChangeLogStart     -Finish $TestChangeLogEnd     -Subject "Test patching change logged in SDPlus"
        AddCalendarDate -Start $TestNotifyStart        -Finish $TestNotifyEnd        -Subject "Phase 1 - Test patching - Send notification"
        AddCalendarDate -Start $TestCheckStart         -Finish $TestCheckEnd         -Subject "Phase 1 - Test patching - Servers Check"
        AddCalendarDate -Start $TestPatchStart         -Finish $TestPatchEnd         -Subject "Phase 1 - Test patching"
        AddCalendarDate -Start $ProdChangeLogStart     -Finish $ProdChangeLogEnd     -Subject "Production patching change logged in SDPlus"
        AddCalendarDate -Start $ProdFirstNotifyStart   -Finish $ProdFirstNotifyEnd   -Subject "Phase 2 - Production patching - Send first notification"
        AddCalendarDate -Start $ProdSecondNotifyStart  -Finish $ProdSecondNotifyEnd  -Subject "Phase 2 - Production patching - Send second notification"
        AddCalendarDate -Start $ProdCheckStart         -Finish $ProdCheckEnd         -Subject "Phase 2 - Production patching - Servers Check"
        AddCalendarDate -Start $ProdStanddownStart     -Finish $ProdStanddownEnd     -Subject "Prod stand-down"
        AddCalendarDate -Start $ProdFirstPatchStart    -Finish $ProdFirstPatchEnd    -Subject "Phase 2 - Production patching"
        AddCalendarDate -Start $ProdSecondPatchStart   -Finish $ProdSecondPatchEnd   -Subject "Phase 3 - Production patching - Plant and CCTV systems"
        AddCalendarDate -Start $ScheduleNextMonthStart -Finish $ScheduleNextMonthEnd -Subject "Schedule patching for next month"
        StopCalendar
    } else {
        #Write-Host "Patch Tuesday: '$($PatchTuesday.ToLongDateString())'."
        Write-Host "Test patching change logged in SDPlus: `t$($TestChangeLogStart.ToString("f")), finish at: `t$($TestChangeLogEnd.ToShortTimeString())."
        Write-Host "Phase 1 - Test patching – Send notification: `t$($TestNotifyStart.ToString("f")), finish at: `t$($TestNotifyEnd.ToShortTimeString())."
        Write-Host "Phase 1 - Test patching - Servers check: `t$($TestCheckStart.ToString("f")), finish at: `t$($TestCheckEnd.ToShortTimeString())."
        Write-Host "Phase 1 - Test patching: `t$($TestPatchStart.ToString("f")), finish at: `t$($TestPatchEnd.ToShortTimeString())."
        Write-Host "Production patching change logged in SDPlus: `t$($ProdChangeLogStart.ToString("f")), finish at: `t$($ProdChangeLogEnd.ToShortTimeString())."
        Write-Host "Phase 2 - Production patching - Send first notification: `t$($ProdFirstNotifyStart.ToString("f")), finish at: `t$($ProdFirstNotifyEnd.ToShortTimeString())."
        Write-Host "Phase 2 - Production patching - Send second notification: `t$($ProdSecondNotifyStart.ToString("f")), finish at: `t$($ProdSecondNotifyEnd.ToShortTimeString())."
        Write-Host "Phase 2 - Production patching - Server check: `t$($ProdCheckStart.ToString("f")), finish at: `t$($ProdCheckEnd.ToShortTimeString())."
        Write-Host "Phase 2 - Production patching - Stand-down period: `t$($ProdStanddownStart.ToString("f")), finish at: `t$($ProdStanddownEnd.ToShortTimeString())."
        Write-Host "Phase 2 - Production patching: `t$($ProdFirstPatchStart.ToString("f")), finish at: `t$($ProdFirstPatchEnd.ToShortTimeString())."
        Write-Host "Phase 3 - Production patching - Plant and CCTV systems: `t$($ProdSecondPatchStart.ToString("f")), finish at: `t$($ProdSecondPatchEnd.ToShortTimeString())."
        Write-Host "Schedule patching for next month: `t$($ScheduleNextMonthStart.ToString("f")), finish at: `t$($ScheduleNextMonthEnd.ToShortTimeString())."
    }
}

End{
    Write-Host "[INFO ] -- Ending."
}
