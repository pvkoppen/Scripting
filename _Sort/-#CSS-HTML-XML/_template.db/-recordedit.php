<?php echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" ?> <!-- This line has to be first in the Document -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <!--BEGIN:HEADER-->
  <?php
    // ---------------------------------------------------------
    include './_includes/configuration.php.inc';
    // include './_includes/functions.php.inc'; // Included thru Configuration.
    include './_includes/database/db_info.php.inc';
    include './_includes/database/db_functions.php.inc';
    include './_includes/security/secure.php.inc';
  // ---------------------------------------------------------
  ?>
  <head>
    <title>_Template: <?php  ?></title>
    <link rel="stylesheet" type="text/css" href="./_style/default.css">
    <meta name="keywords" lang="en-us" content="Keywords: Template database">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="Description: Template Database">
    <meta name="distribution" content="global">
    <meta name="robots" content="index,follow">
    <meta name="revisit-after" content="15 days">
  </head>
  <body>
    <?php
      // ---------------------------------------------------------
      $strsql = "select * from SYS_FIELD";
      $result = ibase_query($_db_conn, $strsql);
      // echo "nr of rows: ".ibase_affected_rows($result);
      $nrow = db_num_rows($result);//sum of row
      echo "nr of rows: $nrow<br>";
      // ---------------------------------------------------------
      $strSQL = "select * from SYS_FIELD";
      //$strSQL = "select * from RDB$FIELDS";
      // ---------------------------------------------------------
      $result = ibase_query($_db_conn, $strSQL);
      if (isset($_REQUEST["page"])) { $page = $_REQUEST["page"]; }else{ $page = 1; };
      if (!isset($page))
        $page = 1;
      $i = 0;
      $recperpage = 8;
      $norecord = ($page - 1) * $recperpage;
      if ($norecord){
        $j=0;
        while($j < $norecord and list($code, $name)= ibase_fetch_row($result)){
          $j++;
        }
      }
      ?><table border="1">
      <tr>
        <th width="5%">Row nr</th>
        <th width="5%">Code</th>
        <th>Name</td>
      </tr><?php
      while (list($code, $name)= ibase_fetch_row($result) and $i < $recperpage){
        ?><tr>
          <th width="5%"><?php echo ((($page - 1) * $recperpage) +$i+1); ?></th>
          <th width="5%"><?php echo $code; ?></th>
          <td><?php echo $name; ?></td>
        </tr><?php
        $i++;
      }
      $incr = $page + 1;
      if ($page > 1) $decr = $page - 1;
      $numOfPage = ceil($nrow/$recperpage);
      ?><tr><td colspan="3" align="center"><?php
        if ($page <= 1)
          echo "<span>First</span>";
        else
          echo "<a href=".$_SERVER["PHP_SELF"]."?page=1>First</a>";
        ?>&nbsp;&nbsp;<?php
        if ($page <= 1)
          echo "<span>Prev</span>";
        else
          echo "<a href=".$_SERVER["PHP_SELF"]."?page=".$decr.">Prev</a>";
        ?>&nbsp;&nbsp;<?php
        if ($page == $numOfPage)
          echo "<span>Next</span>";
        else
          echo "<a href=".$_SERVER["PHP_SELF"]."?page=".$incr.">Next</a>";
        ?>&nbsp;&nbsp;<?php
        if ($page == $numOfPage)
          echo "<span>Last</span>";
        else
          echo "<a href=".$_SERVER["PHP_SELF"]."?page=".$numOfPage.">Last</a>";
        ?>
      </td></tr>
    </table>
  </body>
</html>
<?php// phpinfo(); ?>