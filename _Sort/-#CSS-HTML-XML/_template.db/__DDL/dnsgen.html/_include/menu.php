<?php

 include("../_include/database-connect.php");

 if (!function_exists("buildmenu")) { function buildmenu() {
 // $db_connection = odbc_connect(ODBC_DNS_STR, ODBC_USER_STR, ODBC_PASSWRD_STR);
 // $sql_result    = odbc_exec ($db_connection, "SELECT * FROM DEVICE_TBL");
 // $result = odbc_fetch_into($sql_result, $data_row);
 // echo "<pre>x=$result<br>";
 // print_r($data_row);
 // echo "</pre>";
//  odbc_result_all($sql_result);
//  $sql_result = odbc_tables($db_connection);
//  odbc_result_all($sql_result);
//  odbc_commit($db_connection);
//  odbc_close($db_connection);
  echo "<a href='../html/main.php?to=server'   target='mainFrame'>Server</a><BR>";
  echo "<a href='../html/main.php?to=service'  target='mainFrame'>Service</a><br>";
  echo "<a href='../html/main.php?to=place'    target='mainFrame'>Placing</a><br>";
  echo "<a href='../html/main.php?to=tekst'    target='mainFrame'>Tekst</a><br>";
  echo "<a href='../html/main.php?to=organization' target='mainFrame'>Organisatie</a><br>";
  echo "<a href='../html/main.php?to=location' target='mainFrame'>Locaties</a><br>";
  echo "<a href='../html/main.php?to=install'  target='mainFrame'>Install</a><br>";
 };};
?>