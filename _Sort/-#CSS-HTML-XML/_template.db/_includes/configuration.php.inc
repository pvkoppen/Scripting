<?php
  include './_includes/functions.php.inc';
  // ---------------------------------------------------------
  // MSACCESS : $_db_name = 'ODBC='; // NOT POSSIBLE
  // ---------------------------------------------------------
  // INTERBASE: $_db_name = 'localhost:C:/Progra~1/WSMMHC~1/WSM_MH_Data.fdb';
  // MSSQL    : $_db_name = '<Server Name>';
  // ODBC     : $_db_name = '<ODBC Name>';
  // ORACLE   : $_db_name = '<TNS Name>';
  $_db_type    = 'INTERBASE';
  $_db_name    = 'localhost:D:/Development/WebSite/_template.db/_data/_template.fdb';
  $_db_user    = 'SYSDBA';
  $_db_pw      = 'masterkey';
  // ---------------------------------------------------------
  if     ($_db_type == 'INTERBASE'){
    // Requires Interbase Client(gds32.dll) and PHP extention: php_interbase.dll
    // Other PHP setting: magic_quotes_sybase = On
    $_db_conn    = ibase_connect($_db_name, $_db_user, $_db_pw);
  }elseif ($_db_type == 'MSSQL'){
    // Requires MSSQL Client Tools and PHP extention: php_mssql.dll
    $_db_conn    = mssql_connect($_db_name, $_db_user, $_db_pw);
  }elseif ($_db_type == 'ODBC'){
    // Doesn't requires any PHP extentions. The ODBC connection needs to be predefined.
    $_db_conn    = odbc_connect($_db_name, $_db_user, $_db_pw);
  }elseif ($_db_type == 'ORACLE'){
    // Requires Oracle Client Tools and PHP extention: php_oracle.dll
    $_db_conn    = ora_logon($_db_user."@".$_db_name, $_db_pw);
  }else {
    AddLogEntry('E', '', $_SERVER["PHP_SELF"], "Unknown database type: ".$_db_type); $_db_conn = FALSE;
  };
  include './_includes/database/db_info.php.inc';
  include './_includes/database/db_functions.php.inc';
  if (!db_valid()) { exit; }; 
  //if ($_db_conn === FALSE) { AddLogEntry('C', '', $_SERVER["PHP_SELF"], "Connection failed to database: ".$_db_name.", type: ".$_db_type); };
  //if ($_db_conn === FALSE) { AddLogEntry('E', '', $_SERVER["PHP_SELF"], "Connection failed to database: ".$_db_name.", type: ".$_db_type); };
  //if ($_db_conn === FALSE) { AddLogEntry('W', '', $_SERVER["PHP_SELF"], "Connection failed to database: ".$_db_name.", type: ".$_db_type); };
  //if ($_db_conn === FALSE) { AddLogEntry('I', '', $_SERVER["PHP_SELF"], "Connection failed to database: ".$_db_name.", type: ".$_db_type); };
  // ---------------------------------------------------------
?>
