if(document.layers){ // If Netscape 4
 layerRef='document.'
 topRef='.top' // '.top'
 leftRef='.left' // '.left'
}else if(document.all){ // If IE4
 layerRef=''
 topRef='.style.pixelTop' // niet offsetTop
 leftRef='.style.pixelLeft' // niet offsetLeft
}

function LayOnOther(divad,divloc) {
 x = eval(divloc+'.offsetLeft')
 y = eval(divloc+'.offsetTop')
 eval(layerRef+divad+leftRef+'='+x)
 eval(layerRef+divad+topRef+'='+y)
 }

function TisgetPageCoords (element) {
  var coords = {x: 0, y: 0};
  while (element) {
	coords.x += element.offsetLeft;
	coords.y += element.offsetTop;
	element = element.offsetParent;
  }
  return coords;
}

function TisMoveOnTopOfOther(div1,div2) {
  var coords1 = TisgetPageCoords(document.getElementById(div1));
  var coords2 = TisgetPageCoords(document.getElementById(div2));
  if ((coords1.x!=coords2.x) || (coords1.y!=coords2.y)) {
    document.getElementById(div1).style.top = coords2.y
    document.getElementById(div1).style.left = coords2.x
// volgende deel is voor IE op Mac
    coords1 = TisgetPageCoords(document.getElementById(div1));
    if ((coords1.x!=coords2.x) || (coords1.y!=coords2.y)) {
      document.getElementById(div1).style.top = 2*coords2.y - coords1.y
      document.getElementById(div1).style.left = 2*coords2.x - coords1.x
    }
  }
}


function MoveAds() {
 for (div in document.all) {
  if (div.substring(0,2)=='xa') {
   div2 = 'xl'+ div.substring(2,div.length)
   LayOnOther(div,div2)
   }
  }
 }


function getWidth(){
  bodywidth = 0;
  if( typeof( window.innerWidth ) == 'number' ) {    //Non-IE
	bodyWidth = window.innerWidth;
  } 
  else {
	if( document.documentElement && ( document.documentElement.clientWidth ) ) {
	  //IE 6+ in 'standards compliant mode'
	  bodyWidth = document.documentElement.clientWidth;
	} 
	else {
	  if( document.body && ( document.body.clientWidth ) ) {
		 bodyWidth = document.body.clientWidth;
	  }
	}
  }
  return(bodyWidth);
}

var skyloaded = false

function CheckSkySize() {
// controleer breedte
// en dan op grond van die vaststelling de inhoud wijzigen
  if (getWidth()<918) {
    document.body.id = 'nobanner';
    if (document.getElementById('bannersize')) {
  	  document.getElementById('bannersize').id = 'nobannersize';
	  document.getElementById('skaaiskreep').style.display='none';
    }
  } else {
    document.body.id = 'banner';
    if (document.getElementById('nobannersize')) {
	  document.getElementById('nobannersize').id = 'bannersize';
	  document.getElementById('skaaiskreep').style.display='inline';
	  if (!skyloaded) {
	    document.getElementById('skaaiskreep').src = 'justsky.asp';
	    skyloaded = true;
	  }
    }
  }
}


function ShrinkWoordNm(divnm,nog) {
  div = document.getElementById(divnm);
  divnm2 = divnm.substr(0,2) + 'x' + divnm.substr(3,100)
  div2 = document.getElementById(divnm2);
  if (!div2) {
     div.innerHTML += '<div id="'+divnm2+'">&nbsp;</div>';
     setTimeout('ShrinkWoordNm("' + divnm + '",'+(nog-1)+')',1)
  } else {
  //alert(divnm2+' ['+div2.offsetTop+']['+div.offsetTop+']['+ (div2.offsetTop-div.offsetTop) +']['+ div.offsetHeight +']')

//  if ((div2.offsetTop-div.offsetTop)>div.offsetHeight) {
  if ((TisgetPageCoords(div2).y-TisgetPageCoords(div).y)>div.offsetHeight) {
    txt = div.innerHTML;
    l = txt.length
    do {l = l-1} while ((l>0) && (txt.charAt(l)!=' '))
    do {l = l-1} while ((l>0) && (txt.charAt(l)==' '))
    do {l = l-1} while ((l>0) && (txt.charAt(l)!=' '))
    if (l>0) {
     div.innerHTML = txt.substring(0, l) + '&nbsp;...<div id="'+divnm2+'">&nbsp;</div>';
     if (nog>0) {
       setTimeout('ShrinkWoordNm("' + divnm + '",'+(nog-1)+')',1)
     }
    } else {
     div.innerHTML = '';
    }
  } // else alert(divnm+' ['+div.innerHTML+']['+ (div2.offsetTop-div.offsetTop) +']['+ div.offsetHeight +']')
  }
}



function TisMoveAds() {
 var myCollection = document.getElementsByTagName("DIV")
 for (var i=0; i<myCollection.length; i++) {
  if (el = myCollection[i].getAttribute("id")) {
   if (el.substring(0,2)=='xa') {
    div2 = 'xl'+ el.substring(2,el.length)
    TisMoveOnTopOfOther(el,div2)
   }
   if (el.substring(0,3)=='shr') {
     setTimeout('ShrinkWoordNm("' + el + '",40)',100)
   } 
  }
 }
}

function TisNS() {
 var myCollection = document.getElementsByTagName("DIV")
 for (var i=0; i<myCollection.length; i++) {
  if (el = myCollection[i].getAttribute("id")) {
   if (el.substring(0,3)=='shr') {
     setTimeout('ShrinkWoordNm("' + el + '",40)',100)
   } 
  }
 }
}