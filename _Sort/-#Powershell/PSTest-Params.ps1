param ([string] $HyperVGuest = ' ')

$HyperVGuest
if ($HyperVGuest) {
  write-host '[INFO] TRUE'
}

if ($HyperVGuest -eq $TRUE) {
  write-host '[INFO] equal to TRUE'
}

if (!$HyperVGuest) {
  write-host '[INFO] not TRUE'
}

if ($HyperVGuest -eq $FALSE) {
  write-host '[INFO] equal to FALSE'
}

if ($HyperVGuest -eq '') {
  write-host '[INFO] Param = '''' '
}
