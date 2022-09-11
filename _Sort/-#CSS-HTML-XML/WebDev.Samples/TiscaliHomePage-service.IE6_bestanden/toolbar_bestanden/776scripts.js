var platform = navigator.platform;
var version = navigator.appVersion;
var browser = navigator.appName;
var fullVersion = parseFloat(version.substring(version.indexOf("MSIE")+5,version.length));
var majorVersion = parseInt(''+fullVersion);

if((majorVersion < 6)&&(majorVersion > 1)&&(browser == "Microsoft Internet Explorer")&&(platform == "Win32")) {
	document.write('<link rel="stylesheet" href="/css/layout-4/776old.css" type="text/css">'); 
} else { 
	document.write('<link rel="stylesheet" href="/css/layout-4/776w3c.css" type="text/css">'); 
}
if(platform.indexOf('Mac') != -1){document.write('<style>.topbar .tab b{font:bold 10px Arial;}</style>');}

var last=null;
var verspringen=null;
var verspringob=null;
var terugspringob=null; // de eerste aanroep zal naar de defaulttab zijn
var terugspringen=null;

function noklick() {
  if (verspringen) {
    clearTimeout(verspringen)
  }
  if (terugspringen) {
    clearTimeout(terugspringen)
  }
}

function TisKlick() {
var color_sel=verspringob.style.backgroundColor;
if(last){last.getElementsByTagName('b').item(0).style.borderBottom='1px solid #FFF';}
verspringob.getElementsByTagName('b').item(0).style.borderBottom='1px solid '+color_sel;
document.getElementById('lowbar').style.backgroundColor=color_sel;
last=verspringob;
var label='H-'+verspringob.id;
document.getElementById('menu').innerHTML=document.getElementById(label).innerHTML;
}

function TisUnKlick() {
var color_sel=terugspringob.style.backgroundColor;
if(last){last.getElementsByTagName('b').item(0).style.borderBottom='1px solid #FFF';}
terugspringob.getElementsByTagName('b').item(0).style.borderBottom='1px solid '+color_sel;
document.getElementById('lowbar').style.backgroundColor=color_sel;
last=terugspringob;
var label='H-'+terugspringob.id;
document.getElementById('menu').innerHTML=document.getElementById(label).innerHTML;
}

function leavemenu() {
  noklick();
  terugspringen = setTimeout("TisUnKlick()",800)
}

function klick(thiso){
  if (terugspringob == null) { terugspringob = thiso }
  noklick()
  verspringob = thiso;
  verspringen = setTimeout("TisKlick()",400)
}

function getUrlValue(what){
var url=document.location.href;
url=url.substring(url.indexOf(what)+what.length+1);
var end=(url.indexOf('&')!=-1)?url.indexOf('&'):url.length;
url=url.substring(0,end);
return (url);
}

function logo(){
var url=getUrlValue('area_HP_link');
var html=(url)?'<a href="'+url+'" alt="Tiscali logo">':'';
html+='<img src="/gfx/4/areas/cnews.gif">';
html+=(url)?'</a>':'';
document.write(html);
}