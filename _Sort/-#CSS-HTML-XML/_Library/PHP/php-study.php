<html>
 <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta http-equiv="refresh" content="60">
  <title>PHP-Study listing</title>
 </head>
 <boby>
  <a href="/">back</a>&nbsp;-&nbsp;<a href="./php-study.php">reload</a> <?php echo strftime("%x (%Y),  %X (%Z)", time()); ?>
  <table border="1">

   <tr><th colspan="2">php functions() (de haakjes kunnen soms weg vallen)                                    </th></tr>
   <tr><td>echo "Hello World."; echo("Hello World.");    </td><td><?php echo "Hello World."; echo("Hello World.");   ?></td></tr>
   <tr><td>phpinfo()                                     </td><td><?php echo "phpinfo()"                    ?></td></tr>
   <tr><td>echo strlen("tekst");                         </td><td><?php echo strlen("tekst");               ?></td></tr>
   <tr><td>echo strpos("Deze tekst", "Deze"); echo "-", strpos("Deze tekst", "tekst"); </td><td><?php echo strpos("Deze tekst", "Deze"); echo "-", strpos("Deze tekst", "tekst"); ?></td></tr>
   <tr><td>echo strtoupper("tekst");                     </td><td><?php echo strtoupper("tekst");           ?></td></tr>

   <tr><td colspan="2">&nbsp;                                                                                 </td></tr>
   <tr><th colspan="2">Autoglobal $_COOKIE  variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><th colspan="2">Autoglobal $_ENV     variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><th colspan="2">Autoglobal $_FILES   variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><th colspan="2">Autoglobal $_GET     variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><th colspan="2">Autoglobal $_POST    variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><th colspan="2">Autoglobal $_REQUEST variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><th colspan="2">Autoglobal $_SERVER  variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>
   <tr><td>echo $_SERVER["HTTP_USER_AGENT"];             </td><td><?php echo $_SERVER["HTTP_USER_AGENT"];   ?></td></tr>
   <tr><th colspan="2">Autoglobal $_SESSION variable (De variabele en de waardes zijn CASE-sensitive)                     </th></tr>

   <tr><td colspan="2">&nbsp;                                                                                 </td></tr>
   <tr><th colspan="2">Boolse logica                                                                          </th></tr>
   <tr><td>if (1 == false) {echo "1=false";}; if (0 == false) {echo "0=false";}; </td><td><?php if (1 == false) {echo "1=false";}; if (0 == false) {echo "0=false";}; ?></td></tr>
   <tr><td>if (1 == true) {echo "1=true";}; if (300 == true) {echo "300=true";}; </td><td><?php if (1 == true) {echo "1=true";}; if (300 == true) {echo "300=true";}; ?></td></tr>
   <tr><td>if (strpos("abcdef", "bc") !== false) { <b><i>not false</i></b> } else { <b><i>false</i></b> }; </td><td><?php if (strpos("abcdef", "bc") !== false) { ?> <b><i>not false</i></b> <?php } else { ?> <b><i>false</i></b> <?php }; ?></td></tr>
   <tr><td>                                              </td><td>                                            </td></tr>

   <tr><td colspan="2">&nbsp;                                                                                 </td></tr>
   <tr><th colspan="2">Forms                                                                                  </th></tr>
   <tr><td><form action="php-study.php" method="POST">POST: Your name: <input type="text" name="name" /><br>Your age: <input type="text" name="age" /><br><input type="submit"></form></td><td>Hi <?php echo $_POST["name"]; ?>.<br>You are <?php echo $_POST["age"]; ?> years old.</td></tr>
   <tr><td><form action="php-study.php" method="GET" >GET : Your name: <input type="text" name="name" /><br>Your age: <input type="text" name="age" /><br><input type="submit"></form></td><td>Hi <?php echo $_GET["name"]; ?>.<br>You are <?php echo $_GET["age"]; ?> years old.</td></tr>
   <tr><td>POST OR GET</td><td>Hi <?php echo $_REQUEST["name"]; ?>.<br>You are <?php echo $_REQUEST["age"]; ?> years old.</td></tr>

   <tr><td colspan="2">&nbsp;                                                                                 </td></tr>
   <tr><th colspan="2">System functions.                                                                      </th></tr>
   <tr><td>import_request_variables(), extract(), compact()         </td><td>                                            </td></tr>
   <tr><td>                                              </td><td>                                            </td></tr>
   <tr><td>                                              </td><td>                                            </td></tr>
   <tr><td>Shell_exec()                                  </td><td><pre><?php $kpparray = shell_exec("dir c:\\"); echo "--<br>$kpparray<br>--<br>"; print_r($kpparray); ?>                                    </pre></td></tr>
   <tr><td>Backticks                                     </td><td><pre><?php $kpparray = `"dir c:\"`; echo "--<br>$kpparray<br>--<br>"; print_r($kpparray); ?>      </pre></td></tr>
   <tr><td>System()                                      </td><td><pre><?php echo 'HERE:';system("dir");echo ':TOHERE'; ?>                                    </pre></td></tr>
  </table>
  <br />
  <table border=1>
   <tr><td colspan=6>Pre-composed characters Upper Case Lower Case</td></tr>
   <tr><td>Character</td><td>HTML Code</td><td>Unicode</td>  <td>Character</td><td>HTML Code</td><td>Unicode</td></tr>
   <tr><td>&#256;</td><td>&amp;#256;</td><td>U+0100</td>  <td>&#257;</td><td>&amp;#257;</td><td>U+0101</td></tr>
   <tr><td>&#274;</td><td>&amp;#274;</td><td>U+0112</td>  <td>&#275;</td><td>&amp;#275;</td><td>U+0113</td></tr>
   <tr><td>&#298;</td><td>&amp;#298;</td><td>U+012A</td>  <td>&#299;</td><td>&amp;#299;</td><td>U+012B</td></tr>
   <tr><td>&#332;</td><td>&amp;#332;</td><td>U+014C</td>  <td>&#333;</td><td>&amp;#333;</td><td>U+014D</td></tr>
   <tr><td>&#362;</td><td>&amp;#362;</td><td>U+016A</td>  <td>&#363;</td><td>&amp;#363;</td><td>U+016B</td></tr>
   <tr><td>&#469;</td><td>&amp;#469;</td><td>U+01D5</td>  <td>&#470;</td><td>&amp;#470;</td><td>U+01D6</td></tr>
   <tr><td>&#562;</td><td>&amp;#562;</td><td>U+0232</td>  <td>&#563;</td><td>&amp;#563;</td><td>U+0233</td></tr>
   <tr><td>&#60;</td><td>&amp;#60;</td><td> </td>  <td>&#62;</td><td>&amp;#62;</td><td> </td></tr>
   <tr><td>&#39;</td><td>&amp;#39;</td><td> </td>  <td>&#34;</td><td>&amp;#34;</td><td> </td></tr>
   <tr><td>&#38;</td><td>&amp;#38;</td><td> </td>  <td> </td><td> </td><td> </td></tr>
  </table>
  <br />
 </body>
</html>