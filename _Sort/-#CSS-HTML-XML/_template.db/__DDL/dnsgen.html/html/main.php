<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
 <head>
  <?php
   include("../_include/header-const.php");
   include("../_include/maindata.php");
   echo CONST_APP_TITLE;
   echo CONST_APP_REFRESH;
   echo CONST_APP_CONTENT;
   echo CONST_APP_STYLE;
  ?>
 </head>

 <body leftmargin="5" topmargin="5" marginwidth="0" marginheight="0">
  <table width="750" border="1" cellpadding="0" cellspacing="0">
   <tr> 
    <td width="125" height="20">&nbsp;</td>
    <td width="125">&nbsp;</td>
    <td width="125">&nbsp;</td>
    <td width="125">&nbsp;</td>
    <td width="125">&nbsp;</td>
    <td width="125">&nbsp;</td>
   </tr>
   <tr>
    <td heigth="40" colspan="6"><?php if (isset($_REQUEST['to'])) {GetMain($_REQUEST['to']);}; ?></td>
   </tr>
  </table>
 </body>
</html>
