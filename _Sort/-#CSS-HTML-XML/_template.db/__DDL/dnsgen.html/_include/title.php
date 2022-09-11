<?php

 include("../_include/database-connect.php");

 if (!function_exists("ShowTitle")) { function ShowTitle() {
  //$db_connection = odbc_connect(ODBC_DNS_STR, ODBC_USER_STR, ODBC_PASSWRD_STR);
  //$sql_result    = odbc_exec ($db_connection, "SELECT * FROM AC_INSTALL_TBL");
  //$result = odbc_fetch_into($sql_result, $data_row);
  //echo "<h1>$data_row[0]</h1>";
  //odbc_commit($db_connection);
  //odbc_close($db_connection);
  $fp = fopen("..\_database\dns_install_tbl.csv","r");
  if ($data = fgetcsv($fp, 1024, ";")) {
   echo "<h1>$data[0]</h1>";
  } else {echo "<h1>APP_NAME</h1>";};
 };};
?>