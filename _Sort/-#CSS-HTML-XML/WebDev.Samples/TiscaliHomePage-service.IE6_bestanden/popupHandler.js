
		var strUrlPopupBlocker = 'http://web.tiscali.nl/servicecentre/content/article/hsurfwin/494789.htm';

		/*
		intOnBlock : Gaat bepalen wat er moet gebeuren als er GEEN popup geopend kan worden
			1:	Alert met mededeling high (geen verdere acties)
			2:	Alert met uitgebreide medeling (geen verdere acties)
			3:	Confirm met mededeling dat popup niet geopend kon worden en de vraag of ze instructies
				willen hoe dat op te lossen(knop OK) of niet(Annuleren)
				OK:			Redirect naar changepopupblockerinstellingen.asp
				Annuleren:	Geen actie
			4:	Confirm met mededeling dat popup niet kon openen en de vraag of ze de pagina
				in hetzelfde venster willen openen (knop OK).
				OK:			Redirect naar de opgevraagde pagina
				Annuleren:	Geen actie
			5:	Zonder melding direct redirecten naar de opgevraagde pagina maar dan NIET
				in een popup.
			6:	Zonder melding direct redirecten naar changepopupblockerinstellingen.asp
			7:	Zonder melding een DIV+iFrame maken waarin de opgevraagde URL wordt geladen
		
		strUrl:		Volledige URL van de te openen pagina
		strName:	Naam van het te openen window
		strOptions: Options van het te maken window
		*/
		function fnOpenPopup(strUrl,strName,PopupOptions,intOnBlock,BlockOptions,strForm)
		{
			strPopupOptions = fnGetPopupOptions(PopupOptions);
			strBlockOptions	= fnGetBlockOptions(BlockOptions);
			
			if (strForm != '')
			{
				strUrl = strUrl + fnGetForm(strForm);
			}
			
			// Try opening the window returning true/false
			blnWindow = window.open(strUrl,strName,strPopupOptions);
			if (!blnWindow)
			{
				// This cookie is for storing a users defaultsetting handling blocked popups
				if (Get_Cookie('TiscaliPopupSetting'))
				{
					//Delete_Cookie('TiscaliPopupSetting');
					document.location.href=strUrl;
					return false;
				}

				// a case with all posible "if block is detected" solutions
				switch(intOnBlock)
				{
				case 1:
					alert('De popup is geblokkeerd!');
					break;
				case 2:
					if (confirm("Popup blocked. Klik \"OK\" om naar de helpdeskpagina's te gaan om dit probleem te verhelpen. Klik \"Cancel\" om niets te doen."))
					{
						document.location.href=strUrlPopupBlocker;
					}
					break;
				case 3:
					if (confirm("De door u opgevraagde pagina wordt geopend in een nieuw venster maar dit is geblokkeerd. Klik \"OK\" om de pagina in dit venster te openen verhelpen. Klik \"Cancel\" om niets te doen."))
					{
						document.location.href=strUrl;
					}
					break;
				case 4:
					document.location.href=strUrl;
					break;
				case 5:
					document.location.href=strUrlPopupBlocker;
					break;
				case 6:
					var newDiv				= document.createElement('div');
					newDiv.id				= "popupLayer";
					newDiv.style.position	= 'absolute';
					newDiv.style.visibility = 'visible';
					newDiv.style.width		= '375px';
					newDiv.style.height		= '250px';
					newDiv.style.top		= '40%';
					newDiv.style.left		= '35%';
					
					var newFrame			= newDiv.appendChild(document.createElement('iframe'));
					newFrame.id				= 'PopupiFrame';
					newFrame.src			= strUrl;
					newFrame.width			= '100%';
					newFrame.height			= '100%';
					
					document.getElementsByTagName('body')[0].appendChild(newDiv);
					break;
				case 7:
					fnFormVisibility('hidden','');
			
					if (!document.getElementById('popuplayer'))
					{
						var newDiv				= document.createElement('div');
						newDiv.id				= "popupLayer";
						newDiv.style.position	= 'absolute';
						newDiv.style.visibility = 'visible';
						newDiv.style.width		= '320px';
						newDiv.style.height		= '200px';
						newDiv.style.top		= '30%';
						newDiv.style.left		= '35%';
						newDiv.innerHTML		= 
						'<div id="popupLayerBackground0" style="z-index: 300; position:absolute; top:1px; left:1px; opacity:.4; filter:alpha(opacity=40); -moz-Opacity:.4; float:left; width:322px; height:200px; background-color:#000;">&nbsp;</div>' + 
						'<div id="popupLayerBackground1" style="z-index: 301; position: absolute; top: 2px; left: 2px; opacity:.26; filter: alpha(opacity=26); -moz-Opacity: .26; float:left; width:322px; height:200px; background-color:#000;">&nbsp;</div>' + 
						'<div id="popupLayerBackground2" style="z-index: 302; position: absolute; top: 3px; left: 3px; opacity:.18; filter:alpha(opacity=18); -moz-Opacity:.18; float:left; width:322px; height:200px; background-color:#000;">&nbsp;</div>' + 
						'<div id="popupLayerBackground4" style="z-index: 304; position: absolute; top: 4px; left: 4px; opacity:.1; filter:alpha(opacity=10); -moz-Opacity:.1; float:left; width:322px; height:200px; background-color:#000;">&nbsp;</div>' + 
						'<div id="popupLayerFront" style="z-index:305; position:absolute; top:0px; left:0px; opacity:1; filter:alpha(opacity=100); -moz-Opacity:1; float:left; width:320px; height:200px; border:solid 1pt #7E71B4; background-color:#EAF7E2;"><div style="float:left; width:320px; height:30px;"><div class="title17b" style="width:256px; margin-top:10px; margin-left:10px; float:left; text-align:left;">Deze pagina is geblokkeerd!</div><div style="width:20px; float:right; margin-right:10px; margin-top:10px;"><a href="javascript:void(0);" onClick="fnFormVisibility(\'visible\');document.getElementById(\'popupLayer\').style.visibility=\'hidden\';"><img src="/gfx/4/buttons/x.gif" width="20" height="18" alt=""></a></div></div><div style="float:left; height:100px; width:290px; margin: 5px 10px 0px 10px; overflow:hidden; text-align:left;">Als gevolg van een instelling in uw Internet Explorer of een "Pop-up-killer" is de opgevraagde pagina geblokkeerd. Klik op "Openen" om de gevraagde pagina alsnog te openen, klik voor meer informatie over hoe u de instellingen kunt veranderen op "Meer informatie" of sluit dit venster door op het "kruisje" te klikken.</div><div style="float:left; height:30px; width:280px; padding-left:13px;"><form name="PopupSetting" style="margin:0px;border:0px;padding:0px;"><input type="checkbox" name="savePopupSetting">Altijd pagina in zelfde venster openen</form></div><div style="float:left; height:18px; width:280px; padding-left:50px;"><div style="float:left; margin-right:10px;"><a href="#" onClick="javascript:fnOpenButton(\''+strUrl+'\');"><img src="/gfx/4/buttons/openen.gif" width="56" height="18" alt=""></a></div><div style="float:left;"><a href="#" onClick="document.location.href=\'' + strUrlPopupBlocker + '\';"><img src="/gfx/4/buttons/popupblokinstellen.gif" width="142" height="18" alt=""></a></div></div></div>';
						document.getElementsByTagName('body')[0].appendChild(newDiv);
					}
					else
					{
						document.getElementById('popupLayer').style.visibility='visible';
					}
					break;
				}
			}
			return false;
		}


		// Function that makes all formitems invisible or visible depending on the
		// value that is submitted (hidden OR visible)
		function fnFormVisibility(formValue,strFormName)
		{
			intCounter2 = 0;
			intItemCounter = 0;
			
			for (intCounter2=0;intCounter2<document.forms.length;intCounter2++)
			{
				if (document.forms[intCounter2].name != 'PopupSetting')
				{
					for (intItemCounter=0;intItemCounter<document.forms[intCounter2].length;intItemCounter++)
					{
						document.forms[intCounter2].elements[intItemCounter].style.visibility = formValue;
					}
				}
			}
			return true;
		}


		function fnGetForm(strForm)
		{
			strFormData = '?';
			intCounter = 0;

			for (intCounter=0; intCounter<strForm.elements.length ;intCounter++)
			{
				strFormData += strForm.elements[intCounter].name + '=' + strForm.elements[intCounter].value + '&';
			}
			return strFormData;
		}

		// This function is called when clicking the 'Openen' button
		// it checks if the user wants to save his clicked action and after
		// that redirects to the requested page.
		function fnOpenButton(strUrl)
		{
			if (document.PopupSetting.savePopupSetting.checked)
			{
				Set_Cookie('TiscaliPopupSetting','open',new Date(2006,1,1));
			}
			document.getElementById('popupLayer').style.visibility='hidden';
			document.location.href = strUrl;
		}


		// Function for reading the cookie specified by the name
		// that is given as input var.
		function Get_Cookie(name) {
			var start = document.cookie.indexOf(name+"=");
			var len = start+name.length+1;
			if ((!start) && (name != document.cookie.substring(0,name.length))) return null;
			if (start == -1) return null;
			var end = document.cookie.indexOf(";",len);
			if (end == -1) end = document.cookie.length;
			//alert(document.cookie.substring(len,end));
			return unescape(document.cookie.substring(len,end));
		}

		// Function for setting a cookie
		function Set_Cookie(name,value,expires,path,domain,secure) {
			document.cookie = name + "=" +escape(value) +
				( (expires) ? ";expires=" + expires.toGMTString() : "") +
				( (path) ? ";path=" + path : "") + 
				( (domain) ? ";domain=" + domain : "") +
				( (secure) ? ";secure" : "");
		}

		// Function for deleting a cookie
		function Delete_Cookie(name,path,domain) {
			if (Get_Cookie(name)) document.cookie = name + "=" +
				( (path) ? ";path=" + path : "") +
				( (domain) ? ";domain=" + domain : "") +
				";expires=Thu, 01-Jan-1970 00:00:01 GMT";
		}


		// This functions requires a variable containing the PopupOptions. When the
		// var contains an integer it returns the string that is according the sent 
		// int. Otherwise it wil return itself.
		//
		// INPUT:	string or integer
		// OUTPUT:	string
		function fnGetPopupOptions(PopupOptions)
		{
			/*
			width=			number in pixels
			height=			number in pixels
			left=			number in pixels
			top=			number in pixels
			resizable=		yes or no
			scrollbars=		yes or no
			toolbar=		yes or no
			location=		yes or no
			directories=	yes or no
			status=			yes or no
			menubar=		yes or no
			copyhistory=	yes or no
			*/
			
			// This RegEx is testing if input is an integer
			if( /^\d+$/.test(PopupOptions))
			{
				switch(PopupOptions)
				{
					case 1:
						// Just a new window
						return '';
						break;
					case 2:
						// Window with options
						return 'width=400,height=400,status=no,toolbar=no,resize=yes';
						break;
					case 3:
						// Windows with options
						return 'width=200,height=300,status=no,toolbar=yes,resize=yes';
						break;
				}
			}
			else
				return PopupOptions;
		}

		
		
		// This functions requires a variable containing the BlockOptions. When the
		// var contains an integer it returns the string that is according the sent 
		// int. Otherwise it wil return itself.
		//
		// INPUT:	string or integer
		// OUTPUT:	string
		function fnGetBlockOptions(BlockOptions)
		{
			// This RegEx is testing if input is an integer
			if( /^\d+$/.test(BlockOptions))
			{
				switch(BlockOptions)
				{
					case 1:
						return '';
					break;
				}
			}
			else
				return BlockOptions;
		}
