function disclaim() { 
	window.open("/home/overtiscali/disclaimer.asp","disclaim","toolbar=no,directories=no,menubar=no,location=no,scrollbars=yes,resizable=no,height=640,width=800"); 
}

function algemeenvw() { 
	window.open("/content/algemenevoorwaarden.asp","algemeenvw","toolbar=no,directories=no,menubar=no,location=no,scrollbars=no,resizable=no,height=330,width=457"); 
}

function NoBlanks(s) {
  while (s.indexOf(' ')>0) {
    s = s.replace(' ','%20')
  }
  return s
}

function formHandler(form) {
	var URL = document.form.site.options[document.form.site.selectedIndex].value;
	window.location.href = URL;
}

function BAKformHandler1(form) {
	if ((document.searchform.type.options[document.searchform.type.selectedIndex].value=='www') && (NoBlanks(document.searchform.key.value)==''))
    window.location.href="/sear/sear_center.asp"
	else if (document.searchform.type.options[document.searchform.type.selectedIndex].value=='www')
		window.location.href="/sear/sear_center.asp?query="+NoBlanks(document.searchform.key.value)+"&kind=all"
	else if (document.searchform.type.options[document.searchform.type.selectedIndex].value=='categories')
		window.location.href="/sear/links.asp?data="+NoBlanks(document.searchform.key.value)
	else if (document.searchform.type.options[document.searchform.type.selectedIndex].value=='dvd')
		window.open("http://www.nl.bol.com/cec/cstage?siteid=36210773&bfpage=vsearch_white_k&bfmid=1821541&query_type=title&nav_type=v&search_text="+NoBlanks(document.searchform.key.value)+"&ecaction=boldlquicksearch")
	else if (document.searchform.type.options[document.searchform.type.selectedIndex].value=='cd')
		window.open("http://www.nl.bol.com/cec/cstage?siteid=36210773&bfpage=small_black_msearch&bfmid=1821541&query_type=pop_artist&nav_type=m&search_text="+NoBlanks(document.searchform.key.value)+"&ecaction=boldlquicksearch")
	else if (document.searchform.type.options[document.searchform.type.selectedIndex].value=='boeken')
		window.open("http://www.nl.bol.com/cec/cstage?siteid=36210773&bfpage=small_black_msearch&bfmid=1821541&query_type=title&nav_type=b&search_text="+NoBlanks(document.searchform.key.value)+"&ecaction=boldlquicksearch")
}

function BAKformHandler2(form) {
	if (document.chansearch.searchmethod.options[document.chansearch.searchmethod.selectedIndex].value=='zdnet')
		window.location.href="/mult/search.asp?zoekstring="+NoBlanks(document.chansearch.termen.value)
	else if (document.chansearch.searchmethod.options[document.chansearch.searchmethod.selectedIndex].value=='gamespot')
		window.location.href="/game/search.asp?zoekstring="+NoBlanks(document.chansearch.termen.value)
	else if (document.chansearch.searchmethod.options[document.chansearch.searchmethod.selectedIndex].value=='internet')
		window.location.href="/sear/sear_center.asp?query="+NoBlanks(document.chansearch.termen.value)+"&kind=all"
	else
		window.location.href="/content/search.asp?categorie="+NoBlanks(document.chansearch.categorie.value)+"&termen="+NoBlanks(document.chansearch.termen.value)
}

function openPopUpWindow(url,x,y) {   
	if(ns4) {
		stringie="height="+y+",width="+x+",toolbar=0,scrollbars=0,directories=no,menubar=no,location=no,resizable=0,personalbar=no,screenX=0,screenY=0,status=0";
		newWindow = open(url,"window", stringie);
	} else {
		stringie="height="+y+",width="+x+",toolbar=0,scrollbars=0,directories=no,menubar=no,location=no,resizable=0,personalbar=no,status=0,left=0,top=0";
		newWindow = window.open(url,"window", stringie);
	}
	return; 
}

function OpenPopup(pad,titel,wid,hei) {
	param = 'toolbar=no,status=no,location=no,menubar=no,scrollbars=yes,width='+wid+',height='+hei+''
	window.open(pad,titel,param);
}

function bookmark(url, description) {
	iemac="Klik eerst op OK en vervolgens APPELTJE+D om deze site op te slaan bij uw favorieten."  
	netscapemac="Klik eerst op OK en vervolgens APPELTJE+D om deze site op te slaan bij uw favorieten."	
	netscapepc="Klik eerst op OK en vervolgens CTRL+D om deze site op te slaan bij uw favorieten."
	ander="Klik eerst op OK en vervolgens CTRL+D om deze site op te slaan bij uw favorieten."
	if ((navigator.appVersion.toLowerCase().indexOf('mac') ==-1) && (document.all)) {
		window.external.AddFavorite(url, description);
	} else if ((navigator.appVersion.toLowerCase().indexOf('mac') !=-1) &&  (document.all)) {
		alert(iemac);
	} else if ((navigator.appVersion.toLowerCase().indexOf('mac') !=-1) && (document.layers)) {
		alert(netscapemac);
	} else if ((navigator.appVersion.toLowerCase().indexOf('mac') ==-1) && (document.layers)) {
		alert(netscapepc);
	} else {
		alert(ander);
	}
}

var popupje;
function openWindow(url,width,height,scroll) {
	popupje = window.open(url,"popupje",'toolbar=no,status=no,location=no,menubar=no,scrollbars='+scroll+',width='+width+',height='+height+'');
	popupje.focus();
}

function euroRadio2004() {
	openWindow('/actueel/euro2004/radio.asp',135,125,'no');
}