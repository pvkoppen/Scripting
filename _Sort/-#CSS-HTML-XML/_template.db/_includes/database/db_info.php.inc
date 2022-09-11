<?php

  // --------------------------------------------------------- 
  if (!function_exists('db_info')){ 
    function db_info() { 
      global $_db_type, $_db_conn;
      if (!isset($_db_type) && !isset($_db_conn) && !($_db_conn === FALSE)){ 
        AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Database not defined. Open database connection first"); return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        // For interbase do this 
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // --------------------------------------------------------- 
  if (!function_exists('db_valid')){ 
    function db_valid() { 
      global $_db_type, $_db_conn;
      if (!isset($_db_type) && !isset($_db_conn) && !($_db_conn === FALSE)){ 
        AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Database not defined. Open database connection first"); return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        // For interbase do this 
        return TRUE;
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
        return TRUE;
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
        return TRUE;
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
        return TRUE;
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // ---------------------------------------------------------
  if (!function_exists('db_status')){ 
    function db_status() { 
//      $sql_secure = "select * from SETTING where SETTINGNAME = 'SITENAME'";
//      $db_result  = ibase_query($db_connection, $sql_secure);
      $sec_status = '';
//      if ($db_result === true){
//        $sec_status = 'Empty Sitename: Use the fat client to complete the initial settings.';
//      } else if (!($db_result === false)) {
//        $db_record = ibase_fetch_row($db_result);
//        if ($db_record[0] == ''){
//          $sec_status = 'Empty Sitename: Use the fat client to complete the initial settings.';
//        };
//      };
//      $ib_status = ib_free_result($db_result);
      if ($sec_status != '') {
        die("<h1>$sec_status</h1></body></html>");
      };
    }; 
  }; 
  // ---------------------------------------------------------

  db_status();

?>
