function setScreen(){
	if(navigator.platform.indexOf('Mac')!=-1 && navigator.appName.indexOf('Explorer')!=-1){
		if (document.getElementById('container')) {
			var html='<table class="container" border="1" cellpadding="0" cellspacing="0"><tr><td width="144" height="100%" bgcolor="#6785AA" valign="top">';
			html+=document.getElementById('container-LEFT').innerHTML+'</td><td width="468" height="100%" bgcolor="#CCDFF0" valign="top">';
			html+=document.getElementById('container-CENTER').innerHTML+'</td><td width="144" height="100%" bgcolor="#E6EFF7" valign="top">';
			html+=document.getElementById('container-RIGHT').innerHTML+'</td></tr></table>';
			document.getElementById('container').outerHTML=html;
		}		
	}
	
	var HH=document.body.scrollHeight-193;

	if (document.getElementById('container-LEFT')) {
		document.getElementById('container-LEFT').style.height=HH+'px';
	}
	if(document.getElementById('container-CENTER')){
		document.getElementById('container-CENTER').style.height=HH+'px';
	}
	if (document.getElementById('container-RIGHT')) {
		document.getElementById('container-RIGHT').style.height=HH+'px';
	}
}