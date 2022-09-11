<%@ Language=VBScript %>
<!--#include file="_includes/algemeen.asp"-->
<%
const KOPTEKST="welkom op het intranet"
%>
<script language="JavaScript">
	var 
	vWebUrl="<%=SECURE_PROTOCOL & BASE_URL%>"
	vWebUrl2=vWebUrl + "/";

	vloc=top.location;
	vloc=vloc.toString();
	vloc=vloc.toLowerCase();
	
	if ((vloc != vWebUrl) && (vloc != vWebUrl2))
	{
		 top.location.href = vWebUrl;
	}
</script>



<html>
<head>
  <title><%=TITLE%></title>
</head>

<frameset cols="220,<%=BREEDTE+100%>,*" framespacing="0" border="0" frameborder="NO">
  <frame name="links" target="main" src="home/menu.htm" scrolling="NO" marginwidth="0" marginheight="0" noresize>
  <frameset rows="100,*" framespacing="0" border="0" frameborder="NO">
    <frame name="boven" src="_top/top.asp?titel=<%=Server.URLEncode(koptekst)%>" scrolling="NO" noresize>
    <frame name="main" src="<%=SECURE_PROTOCOL & BASE_URL%>/users/login.asp" noresize>
  </frameset>
  <frame name="rechts" target="main" src="home/rechts.htm" scrolling="NO" marginwidth="0" marginheight="0" noresize>
</frameset>
<noframes>
  <body>
    <p>Deze site maakt gebruik van frames en deze worden helaas niet door jouw browser ondersteund!</p>
  </body>
</noframes>
</html>
