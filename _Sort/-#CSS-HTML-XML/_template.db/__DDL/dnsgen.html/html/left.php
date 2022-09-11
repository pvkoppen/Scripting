<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
 <head>
  <?php
   include("../_include/header-const.php");
   include("../_include/menu.php");
   echo CONST_APP_TITLE;
   echo CONST_APP_REFRESH;
   echo CONST_APP_CONTENT;
   echo CONST_APP_STYLE;
  ?>
  <link href="..\html\style.css" rel="stylesheet" type="text/css" />
  <script language="JavaScript" type="text/JavaScript">
   <!--
   // Kan dit ook op basis van altsrc??
   function imgpreload() {
    var d=document; 
    if(d.images){
     //
    };
   }
   function MM_preloadImages() { //v3.0
    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
   }
   function imgchange(imgtagname){
    imgname = document[imgtagname].src;
    document[imgtagname].src = document[imgtagname].altsrc;
    document[imgtagname].altsrc = imgname;
   }
   //-->
  </script>
 </head>

 <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="imgpreload();MM_preloadImages('../images/btn-home-h.jpg','../images/btn-veilen-h.jpg','../images/btn-inbrengen-h.jpg','../images/btn-onderh-verkoop-h.jpg','../images/btn-contact-h.jpg')">
  <table width="150" border="1" cellpadding="0" cellspacing="0">
   <tr>
    <td width="25">&nbsp;</td>
    <td width="25">&nbsp;</td>
    <td width="25">&nbsp;</td>
    <td width="25">&nbsp;</td>
    <td width="25">&nbsp;</td>
    <td width="25">&nbsp;</td>
   </tr><tr>
    <td colspan="6"><?php buildmenu(); ?></td>
   </tr>
  </table>
 </body>
</html>
