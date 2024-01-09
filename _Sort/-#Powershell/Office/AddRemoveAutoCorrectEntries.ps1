Function Set-AutoCorrectEntries {
  Param(
    [string]$path,
    [switch]$add,
    [switch]$remove)
  $entry = Import-Csv -Path $path
  $word = New-Object -ComObject word.application
  $word.visible = $false
  $entries = $word.AutoCorrect.entries
  if($add) {
    Foreach($e in $entry) {
      Try {
        $entries.add($e.replace, $e.with) | out-null
      } Catch [system.exception] { 
        "unable to add $($e.replace)" 
      }
    } #end foreach
  }#end if add
  if($remove) { 
    $j = 0
    Foreach($e in $entry) { 
      $j = $j+1
      Write-Progress -Activity "deleting entries" -Status "deleting $($e.replace)" -percentcomplete ($j/$entry.count*100)
      foreach($i in $entries) {
        if($i.name -eq $e.replace) {
          $i.delete()
        }
      }
    } #end foreach entry
  } #end if remove
  $word.Quit()
  $word = $null
  [gc]::collect()
  [gc]::WaitForPendingFinalizers()
} #End function Set-AutoCorrectEntries
