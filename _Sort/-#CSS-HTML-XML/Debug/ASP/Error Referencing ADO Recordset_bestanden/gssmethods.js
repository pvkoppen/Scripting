if(typeof(g_gssCookieDomain) != "undefined") {
	if(g_gssCookieDomain.length > 0) {
			if(document.domain.indexOf(".com") > -1) {
				document.domain = g_gssCookieDomain;
			}
	}
}

var srchUIratio = 0.5;
if(fetchcookieval("gss_srchscroll") != "blank") srchUIratio = parseFloat(fetchcookieval("gss_srchscroll"));
var srchheightlimit = 100;
var scaleswitch = false;
var staticheight = 159+55+21;
var min_pane_height = 20;

var mouse_y = -1;

function calcscaleon(){
	top.scaleswitch = true;
	document.body.style.cursor = "n-resize";
	if(event && event.clientY){
		mouse_y = event.clientY;
	}
}

function calcscaleoff(){
	document.body.style.cursor = "";
	top.scaleswitch = false;
}

if(document.getElementById){
	document.onmouseup = calcscaleoff;
	document.onmousemove = scalesrch;
	document.onselectstart = cancelselect;
}

function scalesrch(){
	if(document.getElementById){
		var goforit = false;
		try{if(top.scaleswitch){goforit = true;}}
		catch(e){goforit = false;}
		
		if(goforit){
			document.body.style.cursor = "n-resize";
			var yloc = event.clientY;
			if(!document.getElementById("previewdiv")) yloc += 180 + top.sharedheight - top.pheight;
			if(top.mouse_y < 0) top.mouse_y = yloc;
			if(top.mouse_y != yloc){
				diffr = yloc - top.mouse_y;
				top.pheight = Math.ceil(top.sharedheight*(top.srchUIratio));
				top.pheight = top.pheight - diffr;
				
				if(top.pheight <= min_pane_height) top.pheight = min_pane_height;
				else if(top.pheight >= top.sharedheight-min_pane_height) top.pheight = top.sharedheight-min_pane_height;
				else top.mouse_y = yloc;
				
				top.srchUIratio = top.pheight/top.sharedheight;
				top.calcsearchdivsizes();
				setcookieval("gss_srchscroll", top.srchUIratio);
			}
		}
	}
}

function cancelselect(){
	if(top.scaleswitch){
		return false;
	}
}

function gss_handlesurvey(surveyurl, freq, expiration, properties){
	surveyurl = surveyurl.replace(" ","_");
	now = new Date();
	firesurvey = false;
	if(fetchcookieval("gss_survey") == "blank") firesurvey = true;
	else{
		then = new Date(fetchcookieval("gss_survey"));
		if((now.valueOf() - then.valueOf()) > (expiration*24*60*60*1000)) firesurvey = true;
	}
	if(firesurvey){
		if(Math.random() < (1/freq)){
			surveywin = window.open(surveyurl, "surveywin", properties);
			setcookieval("gss_survey", now.toString());
			surveywin.focus();
		}
	}
}

function gss_drawselectlist(parentobj, childobj){
	if(failure==0){
		if(parentobj){
			if(parentobj.type.toLowerCase().indexOf("select") > -1) catalognum = parentobj.selectedIndex;
			else catalognum = 0;
		}else catalognum = 0;
		var arraylen = eval(childobj.name+catalognum+'.length;');
		
		if(childobj.children && navigator.appVersion.indexOf("Macintosh") < 0){
			while(childobj.children.length > 0){
				for(i=0;i<childobj.children.length;i++){
					childobj.remove(childobj.children[i]);
				}
			}
		}else{
			for(i=0;i<childobj.options.length;i++){
				childobj.options[i] = null;
			}
		}
	
		var selectedIndex = 0;
		
		var makeselect = true;
		if(parentobj){
			if(parentobj.type.toLowerCase().indexOf("select") > -1){
				if(parentobj.options[catalognum].value.indexOf("PRODLISTSRC=OFF") > -1) makeselect = false;
			}else if(parentobj.type.toLowerCase().indexOf("hidden") > -1){
				if(parentobj.value.indexOf("PRODLISTSRC=OFF") > -1) makeselect = false;
			}
		}
		
		if(makeselect){
			for(i=0;i<arraylen;i++){
				tempstr = eval(childobj.name+catalognum+'['+i+']');
				eval("if("+childobj.name+catalognum+"default > 0) selectedIndex = "+i+";");
				eval("childobj.options[i] = new Option(\""+tempstr+"\")");
				childobj.disabled = false;
			}
		}else{
			childobj.options[0] = new Option("", "");
			selectedIndex = 0;
			childobj.disabled = true;
		}
	}
	childobj.options[selectedIndex].selected = true;
}

function gss_fixMetrixUrl(){
	if(typeof(sUrl) != "undefined"){
		var gid = "1F4FC18C-F71E-47fb-8FC9-612F8EE59C61";
		var cv;
		var dg = "";
		var p1 = "guid=";
		var p2 = "&guid=";
		var gl = 32;
		cv = fetchcookieval("MC1").toLowerCase();
		if(cv == "blank") cv = fetchcookieval("MC2").toLowerCase();
		if(cv != "blank"){
			if(cv.substr(0,p1.length) == p1) dg = cv.substr(p1.length, gl);
			else if(cv.indexOf(p2) > -1) dg = cv.substr(cv.indexOf(p2) + p2.length, gl);
		}
		sUrl = sUrl + "&msid=" + dg
		sUrl = sUrl + "&guid=" + gid
		if(document.images) {
			document.images["metrixgif"].src = sUrl;
		}
	}
}

function faqswitch(idnum){
	
	if(document.getElementById){
		if(document.getElementById("faqdiv"+idnum)){
			
			if(document.getElementById("faqdiv"+idnum).style.display == "none"){
						
				document.getElementById("faqdiv"+idnum).style.display = "";
				if(document.getElementById("faqplus"+idnum)){document.getElementById("faqplus"+idnum).style.display = "none";}
				if(document.getElementById("faqminus"+idnum)){document.getElementById("faqminus"+idnum).style.display = "";}
				if(document.getElementById("chevdown"+idnum)){document.getElementById("chevdown"+idnum).style.display = "none";}
				if(document.getElementById("chevup"+idnum)){document.getElementById("chevup"+idnum).style.display = "";}
			}else{
				
				document.getElementById("faqdiv"+idnum).style.display = "none";
				if(document.getElementById("faqplus"+idnum)){document.getElementById("faqplus"+idnum).style.display = "";}
				if(document.getElementById("faqminus"+idnum)){document.getElementById("faqminus"+idnum).style.display = "none";}
				if(document.getElementById("chevdown"+idnum)){document.getElementById("chevdown"+idnum).style.display = "";}
				if(document.getElementById("chevup"+idnum)){document.getElementById("chevup"+idnum).style.display = "none";}
			}
		}
	}
}


function gss_hidefaqs(){

	if(document.getElementsByTagName){
		var divarray = new Array();
		divarray = document.getElementsByTagName("div");
		for(i=0; i<divarray.length; i++){
			if(divarray[i].id){
				if(divarray[i].id.indexOf("faqdiv") > -1){
					if(divarray[i].style.display != "none"){
						faqswitch(divarray[i].id.replace("faqdiv", ""));
					}
				}
			}
		}
	}
}

function gss_focusToc(focusid){
	if(document.getElementById("faq"+focusid)) top.location.href = top.location.href + "#faq" + focusid ;
}

function gss_HideCategoryToc(clid){
	if(document.getElementById("faq"+clid)){
		if(document.getElementsByTagName){
			var faqarray = new Array();
			faqarray = document.getElementsByTagName("div");
			for(i=0;i<faqarray.length;i++)
			{
				if(faqarray[i].className == "faqcontainer"){faqarray[i].style.display = "none";}
			}
			if(document.getElementById("faq"+clid).style.display == "none") document.getElementById("faq"+clid).style.display = "";
			if(document.getElementById("toc")){
				document.getElementById("toc").style.display = "none";
			}	
		
			if(typeof(document.faqform.faqsection) != "undefined") {
				var el = document.faqform.faqsection.options;
				for(i = 0; i < el.length; i++) {
					if(el[i].value == "faq"+clid) {
						el[i].selected = true;
					}
				}
			}
	
		}
	}	
}

function clickExpandCollapse(){
	if(document.getElementsByTagName){
		var faqarray = new Array();
		faqarray = document.getElementsByTagName("div");
		for(i=0; i<faqarray.length; i++){
			if(faqarray[i].id.substring(0,6) == "faqdiv"){
				if(document.getElementById("ExpandCollapse").innerHTML == "+ Show All"){if(faqarray[i].style.display == "none") faqswitch(faqarray[i].id.substring(6,faqarray[i].id.length));}
				else{if(faqarray[i].style.display == "") faqswitch(faqarray[i].id.substring(6,faqarray[i].id.length));}
			}
		}
		if(document.getElementById("ExpandCollapse").innerHTML == "+ Show All"){
			document.getElementById("ExpandCollapse").innerHTML="- Hide All";
		}else{
			document.getElementById("ExpandCollapse").innerHTML="+ Show All";
		}
	}
}

var shownsection = 0;
function sortfaq(){
	if(document.getElementsByTagName){
		var faqarray = new Array();
		faqarray = document.getElementsByTagName("div");
		shownsection = document.faqform.faqsection.selectedIndex;
	
		if(document.faqform.faqsection.selectedIndex < 1){
			for(i=0;i<faqarray.length;i++){
				if(faqarray[i].className == "faqswitches"){faqarray[i].style.display = "";}
				if(faqarray[i].className == "faqcontainer"){faqarray[i].style.display = "";}
				if(faqarray[i].className == "faqbody"){faqarray[i].style.display = "";}
			}
		}else{
			for(i=0;i<faqarray.length;i++){
				if(faqarray[i].className == "faqcontainer"){faqarray[i].style.display = "none";}
				if(faqarray[i].className == "faqswitches"){faqarray[i].style.display = "none";}
			}
			var elem = document.getElementById(document.faqform.faqsection.options[document.faqform.faqsection.selectedIndex].value);
			
			elem.style.display = "";
			var idnum = elem.id.substring(3, elem.id.length);
			if(document.getElementById("faqdiv"+idnum).style.display == "none") document.getElementById("faqdiv"+idnum).style.display = "" ;
			
			//if(document.getElementById("faqdiv"+idnum).style.display == "none") faqswitch(idnum);
		}
	}
}

function sortNonProdfaq(clid){
    if(document.getElementById("faq"+clid))
    {
	if(document.getElementsByTagName){
		var faqarray = new Array();
		faqarray = document.getElementsByTagName("div");
		
			for(i=0;i<faqarray.length;i++){
				if(faqarray[i].className == "faqcontainer"){faqarray[i].style.display = "none";}
				if(faqarray[i].className == "faqswitches"){faqarray[i].style.display = "none";}
			}
			
			var elem = document.getElementById("faq"+clid);
			elem.style.display = "";
			if(document.getElementById("faqdiv"+clid).style.display == "none") faqswitch(clid);
			shownsection = parseInt(clid);
			
		}
	}	
}



function switchstate(sourcetag, targettag, nocookie){
	if(document.body.innerHTML){
		var objexists = true;
		eval("if(!"+sourcetag+") objexists = false;");
		if(objexists == true){
			eval(targettag+".innerHTML = "+sourcetag+".innerHTML");
			if(nocookie != "1") document.cookie = targettag+"="+sourcetag+"; expires=Fri, 31 Dec 2002 23:59:59 GMT; path=/";
		}
	}
}

function loadstate(spanid){
	if(document.getElementById){
		if(fetchcookieval(spanid+"sw") == "0") document.getElementById(spanid).style.display = 'none';
		if(fetchcookieval(spanid+"sw") == "1") document.getElementById(spanid).style.display = '';
	}
	return true;
}
		
function fetchcookieval(key){
	var cookiename;
	var cookieval;
	var keyfound = false;
	var cookiearray = document.cookie.split(";")
	for(i=0;i<cookiearray.length;i++){
		cookiename = cookiearray[i].substring(0, cookiearray[i].indexOf("="));
		if(cookiename.charAt(0) == " ") cookiename = cookiename.substring(1, cookiename.length);
		cookieval = cookiearray[i].substring(cookiearray[i].indexOf("=")+1, cookiearray[i].length);
		if(key == cookiename){keyfound = true; break;}
	}
	if(keyfound) return cookieval;
	else return "blank";
}
		
function setcookieval(key, val){
	if(typeof(g_gssCookieDomain) != "undefined") {
		if(document.domain.indexOf(".com") > -1) {
			document.domain = g_gssCookieDomain;
		}
		document.cookie = key+'='+val+'; expires=Fri, 31 Dec 2002 23:59:59 GMT; Domain=' + g_gssCookieDomain  + '; path=/';
	} else {
		document.cookie = key+'='+val+'; expires=Fri, 31 Dec 2002 23:59:59 GMT; path=/';
	}	
}
		
function mgswitch(target, sopen, sclose){
	var mg = "turnoff";
	if(document.all) eval("if("+target+".style.display == 'none') mg = 'turnon';");
	else if(document.getElementById) eval("if(document.getElementById('"+target+"').style.display == 'none') mg = 'turnon';");

	if(mg == "turnoff"){
		if(sclose != '') eval(sclose);
		setcookieval(target+"sw", "0");
		if(document.all) eval(target+".style.display = 'none'");
		else if(document.getElementById) eval("document.getElementById('"+target+"').style.display = 'none'");
	}else{
		setcookieval(target+"sw", "1");
		if(document.all) eval(target+".style.display = ''");
		else if(document.getElementById) eval("document.getElementById('"+target+"').style.display = ''");
		if(sopen != '') eval(sopen);
	}
	calcsearchdivsizes();
}

function gss_showrefine(){
	document.getElementById('refinediv').style.display = "";
}

function gss_hiderefine(){
	document.getElementById('refinediv').style.display = "none";
}

function gss_refineselect(){
	if(document.getElementById){
		gss_showrefine();
		if(document.getElementById('previewdiv')){
			if(document.midbar || document.sortform) gss_hidepreview();
		}
	}
	return true
}

function gss_hidepreview(){
	if(document.getElementById('previewdiv')){
		document.getElementById('previewdiv').style.display = "none";
		document.getElementById('previewbardiv').style.display = "none";
	}
	if(document.body.clientHeight){
		totalheight = document.body.clientHeight;
		scrollheight = document.body.scrollHeight;
	}else{
		totalheight = self.innerHeight;
		scrollheight = document.body.offsetHeight;
	}
	sharedheight = totalheight-159-55;
	document.getElementById('resultsdiv').style.height = sharedheight;
	document.getElementById('resultsdiv').style.overflowY = "visible";
}

function gss_showpreview(){
	document.getElementById('previewdiv').style.display = "";
	document.getElementById('previewbardiv').style.display = "";
	document.getElementById('previewdiv').style.height = Math.ceil(sharedheight*srchUIratio);
	document.getElementById('resultsdiv').style.height = Math.floor(sharedheight*(1-srchUIratio));
	document.getElementById('resultsdiv').style.overflowY = "scroll";
}

function gss_previewselect(){
	if(document.getElementById){
		if(document.getElementById('previewdiv')){

			tds = document.getElementsByTagName("td");
			for(i=0; i<tds.length; i++){
				if(tds[i].className == "srchlinkclicked"){
					tds[i].className = "srchlink";
				}
			}


			if(document.body.clientHeight){
				totalheight = document.body.clientHeight;
				scrollheight = document.body.scrollHeight;
			}else{
				totalheight = self.innerHeight;
				scrollheight = document.body.offsetHeight;
			}
			sharedheight = totalheight-staticheight;

			if((scrollheight-totalheight) < 55 && (scrollheight-totalheight) > 0){
				sharedheight += (scrollheight-totalheight);
			}else if((scrollheight-totalheight) >= 55){
				sharedheight += 55;
			}

			if(previewed){
				document.getElementById('previewavail').style.display = "";
				document.getElementById('previewnull').style.display = "none";
			}else{
				document.getElementById('previewavail').style.display = "none";
				document.getElementById('previewnull').style.display = "";
			}

			gss_showpreview();
			gss_hiderefine();
		}
	}
	return true;
}

function gss_srchviewmode(){
	if(document.getElementById){
		switch(document.viewform.srchviewmode.options[document.viewform.srchviewmode.selectedIndex].value){
			case "refine":
				gss_refineselect();
				break;
			case "preview":
				gss_previewselect();
				break;
			case "none":
				if(document.getElementById('previewdiv')) gss_hidepreview();
				gss_hiderefine();
				break;
		}
		setcookieval("srchview", document.viewform.srchviewmode.options[document.viewform.srchviewmode.selectedIndex].value);
		calcsearchdivsizes();
	}
}

function PrintContents(){

	if(document.getElementById){
		var PrintUrl = top.location.href;
		var HostName = top.location.hostname;
		HostName = HostName.toLowerCase();
			
		if(PrintUrl.toLowerCase() == "http://" + HostName) PrintUrl = "http://" + HostName + "/default.aspx" ;

		if(PrintUrl.indexOf(HostName + "/default.aspx") > -1){  
			PrintUrl = PrintUrl.replace("default.aspx","common/print.aspx");
			document.getElementById('printframe').src = PrintUrl;
			printframe.focus();
		}else if( PrintUrl.indexOf(HostName + "/search/default.aspx") > -1){	
			if(document.getElementById('previewdiv').src == 'searchmsg.aspx')top.print();
			else{
				top.frames['previewdiv'].focus();
				top.frames['previewdiv'].print();
			}
		}else if( PrintUrl.indexOf(HostName + "/newsgroups/default.aspx") > -1){
			//Add code to access newsgroup frames
			top.print();		
		}else{
			top.focus();
			top.print();
		}	
	}else{
		top.focus()
		top.print();
	}
	
	event.cancelBubble=true;
	return false; 
}

function showdesc(){
	if(document.getElementsByTagName){

		if(document.midbar) checkobj = document.midbar;
		else if(document.sortform) checkobj = document.sortform;
		
		divs = document.getElementsByTagName("div");
		for(i=0; i<divs.length; i++){
			if(divs[i].className == "srchdesc"){
				if(checkobj.desccheck.checked){
					divs[i].style.display = "";
					setcookieval("srchext","1");
				}else{
					divs[i].style.display = "none";
					setcookieval("srchext","0");
				}
			}
		}
	}
}

function calcsearchdivsizes(){
	if(document.getElementById){
	
		if(document.body.clientHeight){
			totalheight = document.body.clientHeight;
			scrollheight = document.body.scrollHeight;
		}else{
			totalheight = self.innerHeight;
			scrollheight = document.body.offsetHeight;
		}
	
		if(document.getElementById('previewdiv')){
			if(document.getElementById('previewdiv').style.display != "none"){
			
				if(document.getElementById('bluefiller')){
					document.getElementById('bluefiller').style.backgroundColor = "#3366CC";
				}
				
				sharedheight = totalheight-staticheight;

				if((scrollheight-totalheight) < 55 && (scrollheight-totalheight) > 0){
					sharedheight += (scrollheight-totalheight);
				}else if((scrollheight-totalheight) >= 55){
					sharedheight += 55;
				}

				if(sharedheight > srchheightlimit){
					if(document.getElementById('previewdiv').style.display == "none"){
						document.getElementById('resultsdiv').style.height = sharedheight+21;
					}else document.getElementById('resultsdiv').style.height = Math.floor(sharedheight*(1-srchUIratio));
					document.getElementById('previewdiv').style.height = Math.ceil(sharedheight*srchUIratio);
					
					showdesc();
				}
			}else{
				if(document.getElementById('bluefiller')){
					document.getElementById('bluefiller').style.backgroundColor = "#ffffff";
				}
				if(document.getElementById('refinediv')){
					document.getElementById('resultsdiv').style.height = scrollheight-159-55;
				}else{
					document.getElementById('resultsdiv').style.height = scrollheight-108-55;
				}
			}
		}
		if(document.getElementById('xnewsborder')){
			if(document.body.clientHeight) totalheight = document.body.clientHeight;
			else totalheight = self.innerHeight;
			if(document.body.clientHeight) totalwidth = document.body.clientWidth;
			else totalwidth = self.innerWidth;
			document.getElementById('xnewsborder').style.height = totalheight-44;
			document.getElementById('xnewsborder').style.width = totalwidth-4;
		}
	}
}

function scrolled(){
	calcsearchdivsizes();
}

function gss_verifykanisa(textval){
	var srcform = document.wizform;
	goforsubmit = 1;
	var radiochecked;
	for(i=0;i<srcform.elements.length;i++){
		var inputname = srcform.elements[i].name;
		if(inputname != "refinecheck"){
			if(srcform.elements[i].type.toLowerCase() == "text"){
				if(srcform.elements[i].value == '' || srcform.elements[i].value == textval) goforsubmit = 0;
			}
		}
	}
	if(!goforsubmit) alert("Please fill in the entire Search Wizard.");
	return goforsubmit;
}

function gss_srchwindow(url){
	if(document.body.clientHeight){
		winheight = Math.round(window.document.body.clientHeight * 0.9);
		winwidth = Math.round(window.document.body.clientWidth * 0.9);
		leftmargin = Math.round(window.document.body.clientWidth * 0.05);
		topmargin = Math.round(window.document.body.clientWidth * 0.02);
	}else{
		winheight = Math.round(document.body.offsetHeight * 0.9);
		winwidth = Math.round(document.body.offsetWidth * 0.9);
		leftmargin = Math.round(document.body.offsetWidth * 0.05);
		topmargin = Math.round(document.body.offsetWidth * 0.02);
	}
	var win = window.open(url, "_blank", "resizable=yes,scrollbars=yes,menubar=yes,location=yes,toolbar=yes,status=yes,height="+winheight+",width="+winwidth+",left="+leftmargin+",top="+topmargin);
	win.focus();
}

function CaptureState(gHTMLElementStateInfo){

}

function isMemberOf(divid,arrayVisibleDIV){
	var i;
	var boolFound;
	boolFound=false
	for (i=0;i<arrayVisibleDIV.length;i++) {if (arrayVisibleDIV[i]==divid){boolFound=true;}}
	return boolFound;
}

function show(id){
	if (document.all) document.all[id].style.display = "block";
	else document.layers[id].visibility = "show";
}

function hide(id){
	if (document.all) document.all[id].style.display = "none";
	else document.layers[id].visibility = "hide";
}

function RestoreState(gHTMLElementStateInfo){

	var strInVisibleDIV,arrayInVisibleDIV;
	var i,divid,collDIV;
	var VisibleDIVLookupTable;


	//get the invisible divs from the form field and make an array of it.
	strInVisibleDIV=gHTMLElementStateInfo.value
	  
	  
	if (!isblank(strInVisibleDIV)){ 
  		arrayInVisibleDIV=strInVisibleDIV.split("|");
  		collDIV=document.all.tags("DIV")
		
  		for (i=0;i<collDIV.length;i++){	
  			divid=collDIV(i).id;
  			if(!isblank(divid)){
  				if (isMemberOf(divid,arrayInVisibleDIV)){hide(divid);}
	  			else{show(divid);}
	  		}
  		}
	}
	  
	if(document.all.invisiblespans){
		currentVisible = document.all.invisiblespans.value;
		if(currentVisible != "") document.all[currentVisible].style.display = "inline";
	}
}

function fillInDialogState(tf){if(tf){tf.dialogState.value = dialogstate;}}

function answerLinksQuestion(theLinksForm,theCaptureStateElement, questionId, answerValue){
	fillInDialogState(theLinksForm);
	CaptureState(theCaptureStateElement);
	theLinksForm.id.value= questionId;
	theLinksForm.answerValue.value=answerValue;
	return theLinksForm.submit();
}

function UnicodeFixup(s){
	var result = new String();
	var c = '';
	var i = -1; 
	var l = s.length;
	result = "";
	for(i = 0; i < l; i++) {
		c = s.substring(i, i+1);
		if(c == "%") {
			result += c; i++;
			c = s.substring(i, i+1);
			if(c != "u") {
				if(parseInt("0x" + s.substring(i, i+2)) > 128) result += "u00";
			}
		}
		result += c;
	}
	return result;
}

function gss_srchlink(prevURL, linkURL, srctag){
	if(document.getElementById){
		if(document.getElementById('previewdiv').style.display != 'none'){
			previewed = 1; 
			gss_previewselect(); 
			if(srctag.parentElement) srctag.parentElement.className='srchlinkclicked'; 
			document.getElementById('previewdiv').src = prevURL + "&pr=1"; 
			if(prevURL.toLowerCase().indexOf("viewdoc.aspx") < 0) document.getElementById('src_newwinhref').href = linkURL;
			else document.getElementById('src_newwinhref').href = prevURL;
			return false;
		}else{
			if(prevURL.toLowerCase().indexOf("viewdoc.aspx") < 0) gss_srchwindow(linkURL); 
			else gss_srchwindow(prevURL);
			return false;
		}
	}else return true;
}

function gss_srchredir(url1, url2, sdval){
	pc = fetchcookieval("Params").toLowerCase();
	if(pc != "blank"){
		cva = new Array();
		nva = new Array();
		cva = pc.split("&");
		SD = "";
		for(i=0;i<cva.length;i++){
			nva = cva[i].split("=");
			if(nva[0] == "sd"){
				SD = nva[1];
				break;
			}
		}
		if(SD != sdval) document.location = url2.replace("||SDVAL||", SD);
		else document.location = url1;
	}else document.location = url1;
}

var produtil;

function writeKanisaProdStr(prodval){
	var writeme = "All products";
	var strval = new Array();
	for(i=0;i<10;i++){
		eval("top.produtil = top.PRD"+i);
		if(!top.produtil) eval("top.produtil = top.Product"+i);
		if(top.produtil){
			for(j=0;j<top.produtil.length;j++){
				strval = top.produtil[j].split("\",\"");
				if(strval[1].toLowerCase() == prodval.toLowerCase()){
					writeme = strval[0];
					i = 10;
					j = top.produtil.length;
				}
			}
		}else{
			i=10;
		}
	}
	document.write(writeme);
}