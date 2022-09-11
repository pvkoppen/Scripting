<?php

  // --------------------------------------------------------- 
  if (!function_exists('AddLogEntry')){ 
    function AddLogEntry($ErrorType, $UserAccount, $ErrorPage, $ErrorMessage) { 
      $ErrorType = StrToUpper($ErrorType);
      If ($ErrorType == "C") {
        Echo "<table border=\"1\" class=\"Error\">"; $ErrorTypeString="Critical Error";
      }elseif ($ErrorType == "E") {
        Echo "<table border=\"1\" class=\"Error\">"; $ErrorTypeString="Error";
      }elseif ($ErrorType == "W") {
        Echo "<table border=\"1\" class=\"Warning\">"; $ErrorTypeString="Warning";
      }elseif ($ErrorType == "I") {
        Echo "<table border=\"1\" class=\"Info\">"; $ErrorTypeString="Info";
      }else{
        Echo "<table border=\"1\" class=\"Error\">"; $ErrorTypeString="-Unknown-";
      };
      If ($UserAccount == "") { $UserAccount = "&gt;null&lt;"; };
      Echo "<tr><th>ErrorType</th><th>UserAccount</th><th>ErrorPage</th><th>ErrorMessage</th></tr><tr>";
      Echo "<td>$ErrorType ($ErrorTypeString)</td>"; 
      Echo "<td>$UserAccount</td>"; 
      Echo "<td>$ErrorPage</td>"; 
      Echo "<td>$ErrorMessage</td>"; 
      Echo "</tr></table>\n";
    }; 
  }; 
  // --------------------------------------------------------- 
?>
