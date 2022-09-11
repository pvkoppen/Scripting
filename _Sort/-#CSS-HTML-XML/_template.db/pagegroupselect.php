<?php echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"; '<!-- This line has to be first in the Document --> ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <!--BEGIN:HEADER-->
  <?php
    // ---------------------------------------------------------
    include './_includes/configuration.php.inc';
    // include './_includes/functions.php.inc'; // Included thru Configuration.
    // include './_includes/database/db_info.php.inc';
    // include './_includes/database/db_functions.php.inc';
    include './_includes/security/secure.php.inc';
  // ---------------------------------------------------------
  ?>
  <head>
    <title>_Template: <?php  ?></title>
    <link rel="stylesheet" type="text/css" href="./_style/default.css">
    <meta name="keywords" lang="en-us" content="Keywords: Template database">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="description" content="Description: Template Database">
    <meta name="distribution" content="global">
    <meta name="robots" content="index,follow">
    <meta name="revisit-after" content="15 days">
    <script rel="Javascript">
      function SetElementValue(element, value){
      };
    </script>
  </head>
  <body>
    <?php // ----------------------Header-----------------------------
    ?>
    <?php // ----------------------Menu-----------------------------
    ?>
    <?php
      // ---------------------------------------------------------
      if (db_valid()){
        $_sql_1         = "SELECT SYSGP.NAME, SYSP.NAME FROM SYS_PAGEGROUP SYSPG, SYS_PAGE SYSP WHERE SYSPG.NAME=\"".$_REQUEST['pagegroup']."\" AND SYSP=\"".$_REQUEST['page']."\" ";
        $_sql_result    = db_query($_sql_1);
        echo "Showing first <span id=\"rows_processed\">.</span> row(s) of <span id=\"rows_returned\">..</span><br>\n"; 
        
        // ---------------------------------------------------------
        $_rows_returned = 0;
        $_cols_returned = db_field_count($_sql_result);
        ?><table border="1"><?php echo "\n"; ?><tr><?php
        for ($i=0;$i<$_cols_returned;$i++){
          $_field_info = db_field_info($_sql_result, $i);
          echo "<th>".$_field_info['name']."</th>";
        };
        ?></tr><?php echo "\n"; 
        while (($_sql_result_row = db_row_fetch($_sql_result)) && !($_sql_result_row === false)) {
          $_rows_returned++;
          ?><tr><?php 
          for ($i=0;$i<$_cols_returned;$i++){
            if ($_sql_result_row[$i] == "") {
              echo "<td>".$_sql_result_row[$i]."&nbsp;</td>";
            }else{
              echo "<td>".$_sql_result_row[$i]."</td>";
            };
          };
          ?></tr><?php echo "\n"; 
        };
        ?></table><?php 
      }else{ echo "!db_valid()";}; // db_valid();
    ?>
    <?php // ----------------------Footer-----------------------------
    ?>
  </body>
</html>
<?php// phpinfo(); ?>
