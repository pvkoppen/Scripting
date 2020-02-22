$hostname = "192.168.1.2"

$couldConnect = 0
$int = 0
$c = New-Object System.Net.TcpClient
while ($int -lt 1024){
  try
  {
    $c.Connect($hostname, $int)
    $couldConnect = 1
  } catch
  {
    $couldConnect = 0
  }
  if ($couldConnect) { echo "Connected: $hostname : $int ." }
  else { echo "Failed: $hostname : $int ." }
  $int += 1
}