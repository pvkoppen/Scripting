#-----------------------------------------------
#-- Powershell: Read CSV file
#-----------------------------------------------
$strCSVHeader = """Name"",""Size"",""Last Modified"",""Last Accessed"",""Creation Date"",""Attributes"",""Extension"",""Path"",""Dir Level"",""File Version"""

$objFileHandle = [System.IO.File]::OpenText($strFileIn)
$boolFirst = 1 #0=FALSE,1=TRUE
$intCount = 0

while (($strLine = $objFileHandle.ReadLine()) -ne $null) {
  $intCount = $intCount + 1
  Write "Line ($intCount) : $strLine"
  $arrCSVstring = $strCSVHeader, $strLine
  $arrCSVline = $arrCSVstring | ConvertFrom-Csv -Delimiter ";" -Header "Name","Size","Last Modified","Last Accessed","Creation Date","Attributes","Extension","Path","Dir Level","File Version"
  $strLine | ConvertFrom-Csv -Delimiter ";"
  $arrCSVLine