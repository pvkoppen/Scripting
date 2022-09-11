<?php

 if (!defined("ODBC_DNS_STR"     )) { define("ODBC_DNS_STR"     , "ACMAIL"); };
 if (!defined("ODBC_USER_STR"    )) { define("ODBC_USER_STR"    , "kpp"); };
 if (!defined("ODBC_PASSWRD_STR" )) { define("ODBC_PASSWRD_STR" , "k0ppen"); };
 $db_connection = odbc_connect(ODBC_DNS_STR, ODBC_USER_STR, ODBC_PASSWRD_STR);

?>