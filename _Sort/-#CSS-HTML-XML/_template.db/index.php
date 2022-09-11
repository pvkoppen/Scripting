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
   Page <a href="./pagegroupselect.php?pagegroup=SYSTEMFIELDS&page=GENERAL">System Fields</a><br>
   Page <a href="./pagegroupselect.php?pagegroup=SYSTEMRECORDS&page=GENERAL">System Records</a><br>
   Page <a href="./pagegroupselect.php?pagegroup=SYSTEMRECORDFIELDS&page=GENERAL">System Record Fields</a><br>
  </body>
</html>
