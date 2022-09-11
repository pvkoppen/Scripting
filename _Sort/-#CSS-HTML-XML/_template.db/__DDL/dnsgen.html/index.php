<?php
  include("./_include/database-connect.php");
?>
<html>
 <head>
 </head>
 <body>
  <h1>ONE - Ons Nieuwe Emailsysteem</h1>
  <SELECT name="BRON">
  <?php
   $sql_result    = odbc_exec($db_connection, "SELECT DISTINCT BRON FROM HISTORIE");
//   $result = odbc_fetch_into($sql_result, $data_row);
//   echo "<h1>$data_row[0]</h1>";
   while (odbc_fetch_row($sql_result)) {
     echo odbc_result($sql_result, 1)+"=1, 2="+odbc_result($sql_result, 2);
   }
   odbc_commit($db_connection);
   odbc_close($db_connection);
  ?>
 </body>
</html>