<html>
 <head>
  <title>Autolisting for folder: <?php echo dirname($_SERVER["PHP_SELF"]); ?></title>
 </head>
 <body>
  <!-- 1. Change WebRoot from %systemRoot%\InetPub\wwwroot to C:\PvK\Development\Website. -->
  <!-- 2. Add Default document; index.php -->
  <!-- 3. Add MIME type: .php = text/html-->
  <!-- 4. Add Handler: Add Module Mapping; .php; FastCGI; <path>/php-cgi.exe; <name> -->
  <!-- 4. set System Variable: PHPHOME  -->
  <h1>Index Script</h1>
  <?php
   // Note that !== did not exist until 4.0.0-RC2
   if ($handle = opendir('.')) {
    /* This is the correct way to loop over the directory. */
    while (false !== ($file = readdir($handle))) { 
     if (($file != '.') && ($file != basename($_SERVER["PHP_SELF"]))) {echo "<a href=\"./$file\">$file</a><br />"; };
    }
    closedir($handle); 
   }
  ?>
 </body>
</html>
