var platform = navigator.platform;
	var version = navigator.appVersion;
	var browser = navigator.appName;
	var fullVersion = parseFloat(version.substring(version.indexOf("MSIE")+5,version.length));
	var majorVersion = parseInt(''+fullVersion);
	if((majorVersion < 6)&&(browser == "Microsoft Internet Explorer")&&(platform == "Win32")) {
		document.write('<link rel="stylesheet" href="/css/layout-4/footer/3-776-old.css" type="text/css">'); 
 	}
	else { 
		document.write('<link rel="stylesheet" href="/css/layout-4/footer/776-w3c.css" type="text/css">'); 
	}

var last=null;
	
function klick(thiso){
var color_sel=thiso.style.backgroundColor;
if(last){last.style.borderBottom='1px solid #FFF';}
thiso.style.borderBottom='1px solid '+color_sel;
document.getElementById('lowbar').style.backgroundColor=color_sel;
last=thiso;
var label=thiso.getElementsByTagName('b').item(0).innerHTML;
document.getElementById('menu').innerHTML=document.getElementById(label).innerHTML;
}

