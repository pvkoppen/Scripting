<?php

 include("../_include/database-connect.php");

 if (!function_exists("GetMain")) { function GetMain($s) {
  //$db_connection = odbc_connect(ODBC_DNS_STR, ODBC_USER_STR, ODBC_PASSWRD_STR);
  //$sql_result    = odbc_exec ($db_connection, "SELECT * FROM AC_INSTALL_TBL");
  //$result = odbc_fetch_into($sql_result, $data_row);
  //echo "<h1>$data_row[0]</h1>";
  //odbc_commit($db_connection);
  //odbc_close($db_connection);
  if       ($s == 'server')      {
   echo "<h1>$s</h1>";
   echo "<p><pre>";
   $fp = fopen('../_database/dns_devices_tbl.csv', 'r');
   while ($line = fgetcsv($fp, 1024, ";")) {
    for ($i=0; $i<count($line);$i++){
     echo "$line[$i]--";
    }
    echo "\n";
   }
   echo "</pre></p>";
  }else if ($s == 'service')     {
   echo "<h1>Service: $s</h1>";
  }else if ($s == 'place')       {
   echo "<h1>p: $s</h1>";
  }else if ($s == 'tekst')       {
   echo "<h1>t: $s</h1>";
  }else if ($s == 'organization'){
   echo "<h1>o: $s</h1>";
  }else if ($s == 'location')    {
   echo "<h1>l: $s</h1>";
  }else if ($s == 'install')     {
   echo "<h1>i: $s</h1>";
  }else {echo "<h1>Unknown: '$s'</h1>";
  };
 };};
?>