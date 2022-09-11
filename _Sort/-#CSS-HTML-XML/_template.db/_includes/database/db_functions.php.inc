<?php 

  // --------------------------------------------------------- 
  if (!function_exists('db_function_template')){ 
    function db_function_template($param1, $param2) { 
      global $_db_type, $_db_conn;
      if (!db_valid()){ 
        return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        // For interbase do this 
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type." in function: db_function_template."); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // --------------------------------------------------------- 
  if (!function_exists('db_query')){ 
    function db_query($_sql_string) { 
      global $_db_type, $_db_conn;
      if (!db_valid()){ 
        return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        return ibase_query($_db_conn, $_sql_string);
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
        return FALSE;
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
        return FALSE;
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
        return FALSE;
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type." in function: db_query."); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // --------------------------------------------------------- 
  if (!function_exists('db_row_fetch')){ 
    function db_row_fetch($_sql_result) { 
      global $_db_type, $_db_conn;
      if (!db_valid()){ 
        return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        return ibase_fetch_row($_sql_result);
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
        return FALSE;
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
        return FALSE;
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
        return FALSE;
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type." in function: db_row_fetch."); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // --------------------------------------------------------- 
  if (!function_exists('db_row_count')){ 
    function db_row_count($resultset) { //I have pick it from bg_idol@hotmail.com 
      global $_db_type, $_db_conn;
      $tempres = $resultset;
      if (!db_valid()){ 
        return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        return FALSE; 
      }elseif ($_db_type == 'MSSQL'){ 
        $i = mssql_rows_affected($tempres); return $i; 
      }elseif ($_db_type == 'ODBC'){ 
        $i = odbc_num_row($tempres); return $i; 
      }elseif ($_db_type == 'ORACLE'){ 
        $i = ora_rows_affected($tempres); return $i; 
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type." in function: db_row_count."); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // --------------------------------------------------------- 
  if (!function_exists('db_field_count')){ 
    function db_field_count($_sql_result) { 
      global $_db_type, $_db_conn;
      if (!db_valid()){ 
        return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        return ibase_num_fields($_sql_result);
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
        return FALSE;
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
        return FALSE;
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
        return FALSE;
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type." in function: db_field_count."); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

  // --------------------------------------------------------- 
  if (!function_exists('db_field_info')){ 
    function db_field_info($_sql_result_row, $index) { 
      global $_db_type, $_db_conn;
      if (!db_valid()){ 
        return FALSE;
      }elseif ($_db_type == 'INTERBASE'){ 
        return ibase_field_info($_sql_result_row, $index);
      }elseif ($_db_type == 'MSSQL'){ 
        // For Microsoft SQL Server do this 
        return FALSE;
      }elseif ($_db_type == 'ODBC'){ 
        // For ODBC do this 
        return FALSE;
      }elseif ($_db_type == 'ORACLE'){ 
        // For ORACLE do this 
        return FALSE;
      }else { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type." in function: db_field_info."); return FALSE; 
      }; 
    }; 
  }; 
  // --------------------------------------------------------- 

?>
