/* 
	Ben Smith's Over-Hacked and Under-Appreciated Menuing Code
	This stuff gives me no trouble in standards compliant browsers, any patches would be appreciated
	- ben@thirdeyemedia.net
*/
function Browser() {

  var ua, s, i;

  this.isIE    = false;  // Internet Explorer
  this.isNS    = false;  // Netscape
  this.isMac   = false;  // Macintosh
  this.version = null;

  ua = navigator.userAgent;
  
  s = "MSIE";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isIE = true;
    this.version = parseFloat(ua.substr(i + s.length));
    return;
  }

  s = "Netscape6/";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isNS = true;
    this.version = parseFloat(ua.substr(i + s.length));
    return;
  }
  
  s = "Macintosh";
  if ((i=ua.indexOf(s)) >= 0){
  	this.isMac = true;
	return;
  }
  
  // Treat any other "Gecko" browser as NS 6.1.
  s = "Gecko";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isNS = true;
    this.version = 6.1;
    return;
  }
  
}

var browser = new Browser();
//----------------------------------------------------------------------------
// Code for handling the menu bar and active button.
//----------------------------------------------------------------------------

var activeButton = null;

/* [MODIFIED] This code commented out, not needed for activate/deactivate
   on mouseover.

// Capture mouse clicks on the page so any active button can be
// deactivated.

if (browser.isIE)
  document.onmousedown = pageMousedown;
else
  document.addEventListener("mousedown", pageMousedown, true);

function pageMousedown(event) {

  var el;

  // If there is no active button, exit.

  if (activeButton == null)
    return;

  // Find the element that was clicked on.

  if (browser.isIE)
    el = window.event.srcElement;
  else
    el = (event.target.tagName ? event.target : event.target.parentNode);

  // If the active button was clicked on, exit.

  if (el == activeButton)
    return;

  // If the element is not part of a menu, reset and clear the active
  // button.

  if (getContainerWith(el, "DIV", "dhtmlMenu") == null) {
    resetButton(activeButton);
    activeButton = null;
  }
}

[END MODIFIED] */

function buttonClick(event, menuId) {

  var button;

  // Get the target button element.

  if (browser.isIE)
    button = window.event.srcElement;
  else
    button = event.currentTarget;

  // Blur focus from the link to remove that annoying outline.

  button.blur();

  // Associate the named menu to this button if not already done.
  // And initialize menu display.

  if (button.menu == null) {
    button.menu = document.getElementById(menuId);
	if(button.menu!=null){
    	if (button.menu.isInitialized == null)
    		menuInit(button.menu);
	}
  }

  // [MODIFIED] Added for activate/deactivate on mouseover.

  // Set mouseout event handler for the button, if not already done.

  if (button.onmouseout == null)
    button.onmouseout = buttonOrMenuMouseout;

  // Exit if this button is the currently active one.

  if (button == activeButton)
    return false;

  // [END MODIFIED]

  // Reset the currently active button, if any.

  if (activeButton != null)
    resetButton(activeButton);

  // Activate this button, unless it was the currently active one.

  if (button != activeButton) {
    depressButton(button);
    activeButton = button;
  }
  else
    activeButton = null;

  return false;
}

function buttonMouseover(event, menuId) {

  var button;

  // [MODIFIED] Added for activate/deactivate on mouseover.

  // Activates this button's menu if no other is currently active.
	if(!(browser.isMac&&browser.isIE)){
		 if (activeButton == null) {
		   buttonClick(event, menuId);
		   return;
		 }
  	}
	
  // [END MODIFIED]

  // Find the target button element.

  if (browser.isIE){
    button = window.event.srcElement;
  }
  else{
    button = event.currentTarget;
  }
  // If any other button menu is active, make this one active instead.

  if (activeButton != null && activeButton != button){
    buttonClick(event, menuId);
  }
}

function depressButton(button) {

  var x, y;

  // Update the button's style class to make it look like it's
  // depressed.

  button.className += " menuButtonActive";

  // [MODIFIED] Added for activate/deactivate on mouseover.

  // Set mouseout event handler for the button, if not already done.
  
  if (button.onmouseout == null)
    button.onmouseout = buttonOrMenuMouseout;
  if(button.menu!=null){
	if (button.menu.onmouseout == null)
	  button.menu.onmouseout = buttonOrMenuMouseout;
  }
  // [END MODIFIED]

  // Position the associated drop down menu under the button and
  // show it.

  x = getPageOffsetLeft(button);
  y = getPageOffsetTop(button) + button.offsetHeight;

  // For IE, adjust position.

  if (browser.isNS) {
    //x += button.offsetParent.clientLeft;
  //  y += button.offsetParent.clientTop;
  }
  if(button.menu!=null){
	  button.menu.style.left = x + "px";
	  button.menu.style.top  = y + "px";
	  button.menu.style.visibility = "visible";
  }
}

function resetButton(button) {

  // Restore the button's style class.

  removeClassName(button, "menuButtonActive");

  // Hide the button's menu

  if (button.menu != null) {
    button.menu.style.visibility = "hidden";
  }
}

//----------------------------------------------------------------------------
// Code to handle the menus and sub menus.
//----------------------------------------------------------------------------

function menuMouseover(event) {

  var menu;

  // Find the target menu element.

  if (browser.isIE)
    menu = getContainerWith(window.event.srcElement, "DIV", "dhtmlMenu");
  else
    menu = event.currentTarget;


}

function menuItemMouseover(event, menuId) {

  var item, menu, x, y;

  // Find the target item element and its parent menu element.

  if (browser.isIE)
    item = getContainerWith(window.event.srcElement, "A", "dhtmlMenuItem");
  else
    item = event.currentTarget;
  menu = getContainerWith(item, "DIV", "dhtmlMenu");

  // mark this one as active.

  menu.activeItem = item;

  // Highlight the item element.

  item.className += " menuItemHighlight";


  // [END MODIFIED]
}


// [MODIFIED] Added for activate/deactivate on mouseover. Handler for mouseout
// event on buttons and menus.

function buttonOrMenuMouseout(event) {

  var el;

  // If there is no active button, exit.

  if (activeButton == null)
    return;

  // Find the element the mouse is moving to.

  if (browser.isIE)
    el = window.event.toElement;
  else if (event.relatedTarget != null)
      el = (event.relatedTarget.tagName ? event.relatedTarget : event.relatedTarget.parentNode);

  // If the element is not part of a menu, reset the active button.

  if (getContainerWith(el, "DIV", "dhtmlMenu") == null) {
    resetButton(activeButton);
    activeButton = null;
  }
}

// [END MODIFIED]

//----------------------------------------------------------------------------
// Code to initialize menus.
//----------------------------------------------------------------------------

function menuInit(menu) {

  var itemList, spanList;
  var textEl, arrowEl;
  var itemWidth;
  var w, dw;
  var i, j;

  // For IE, replace arrow characters.

  if (browser.isIE) {
    menu.style.lineHeight = "2.5ex";
    spanList = menu.getElementsByTagName("SPAN");
    for (i = 0; i < spanList.length; i++)
      if (hasClassName(spanList[i], "menuItemArrow")) {
        spanList[i].style.fontFamily = "Webdings";
        spanList[i].firstChild.nodeValue = "4";
      }
  }
  

  // Find the width of a menu item.

	itemList = menu.getElementsByTagName("A");
	if (itemList.length > 0){
	  itemWidth = itemList[0].offsetWidth;
	}else{
	  	return;
	}	
	
  // For items with arrows, add padding to item text to make the
  // arrows flush right.

  for (i = 0; i < itemList.length; i++) {
    spanList = itemList[i].getElementsByTagName("SPAN");
    textEl  = null;
    arrowEl = null;
    for (j = 0; j < spanList.length; j++) {
      if (hasClassName(spanList[j], "menuItemText"))
        textEl = spanList[j];
      if (hasClassName(spanList[j], "menuItemArrow"))
        arrowEl = spanList[j];
    }
    if (textEl != null && arrowEl != null)
      textEl.style.paddingRight = (itemWidth
        - (textEl.offsetWidth + arrowEl.offsetWidth)) + "px";
  }

  // Fix IE hover problem by setting an explicit width on first item of
  // the menu.

  if (browser.isIE) {
    w = itemList[0].offsetWidth;
    itemList[0].style.width = w + "px";
    dw = itemList[0].offsetWidth - w;
    w -= dw;
    itemList[0].style.width = w + "px";
  }

  // Mark menu as initialized.

  menu.isInitialized = true;
}

//----------------------------------------------------------------------------
// General utility functions.
//----------------------------------------------------------------------------

function getContainerWith(node, tagName, className) {

  // Starting with the given node, find the nearest containing element
  // with the specified tag name and style class.

  while (node != null) {
    if (node.tagName != null && node.tagName == tagName &&
        hasClassName(node, className))
      return node;
    node = node.parentNode;
  }
  return node;
}

function hasClassName(el, name) {

  var i, list;

  // Return true if the given element currently has the given class
  // name.

  list = el.className.split(" ");
  for (i = 0; i < list.length; i++)
    if (list[i] == name)
      return true;

  return false;
}

function removeClassName(el, name) {

	var i, curList, newList;
	
	if (el.className == null){
		return;
	}
	// Remove the given class name from the element's className property.
	
	newList = new Array();
	curList = el.className.split(" ");
	
	var j=0;
	for (i = 0; i < curList.length; i++){
		if (curList[i] != name){
			newList[j]=curList[i];
			j++;
			//newList.push(curList[i]);
		}
	}
	el.className = newList.join(" ");
}

function getPageOffsetLeft(el) {

  var x;

  // Return the x coordinate of an element relative to the page.

  x = el.offsetLeft;
  if (el.offsetParent != null)
    x += getPageOffsetLeft(el.offsetParent);

  return x;
}

function getPageOffsetTop(el) {

  var y;

  // Return the x coordinate of an element relative to the page.

  y = el.offsetTop;
  if (el.offsetParent != null)
    y += getPageOffsetTop(el.offsetParent);

  return y;
}
/*** end Menuing code ***/

/*** JS Form Checker (dunno how swank it is, needs review ***/

function formchecker(x) {
	return(checkFields(x));
}

function checkFields(x) {
	flag = true;
	
	// See if required fields are empty
	y = x.first_name;    if(y.value == ""){fieldAlert(y);return false;}
	y = x.last_name;     if(y.value == ""){fieldAlert(y);return false;}
	y = x.company_name;  if(y.value == ""){fieldAlert(y);return false;}
	y = x.phone;         if(y.value == ""){fieldAlert(y);return false;}
	
	y = x.email;
	if(y.value == ""){fieldAlert(y);return false;}
	if(!checkMail(x)){return false;}

	return flag;
}

function fieldAlert(y) {
	alert("Please fill in all of the fields\nthat are marked with '*'.");
	y.focus();	
}


function checkMail(x) {//pass form Object onSubmit
	var mail = x.email.value;
	var regexp = (/^(\S\S*\@\S\S*\.\S\S\S*)$/);
	var result_1 = regexp.test(mail);  
       
	if(mail != "") {
		if(result_1)	{
			myflag = true;
		} else {
			alert("It appears that your email address is invalid.\nPlease make sure that if is in the following format:\n\nyou@yourdomain.com");
			x.email.focus();
			myflag = false;
		}
		return(myflag);
	} else {
		return true;
	}
}

function goTopNow(x) {//should one need it...
	if (x != "") {
		top.location = x;
	};
}