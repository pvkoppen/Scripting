var MENU_HIDE_TIMEOUT = 5000;

function _InitializeMenu(menu, actuator)
{
	var		i;
	var		menuItems;

	var currentMenu = null;

	var menubarElem = actuator.parentNode.parentNode;

	function startHideTimer()
	{
		var timeout = 0;
		
		startHideTimerWithTimeout(timeout);
	}
	
	function clearHideTimer()
	{
		if (menubarElem.menuHideTimer != null)
			clearTimeout(menubarElem.menuHideTimer);
	}
	
	function startHideTimerWithTimeout(timeout)
	{
		clearHideTimer();
			
		menubarElem.menuHideTimer = setTimeout(
						function ()
						{
							if (menubarElem.currentMenu)
							{
								menubarElem.currentMenu.style.visibility = "hidden";
								menubarElem.currentMenu = null;
							};
						}, timeout);
	}
		
	function hideMenu()
	{
			if (menubarElem.currentMenu)
			{
				menubarElem.currentMenu.style.visibility = "hidden";
				menubarElem.currentMenu = null;
			}
	}

	//	If there is no menu, just initialize a standalone actuator
	if (menu == null)
	{
		actuator.onmouseover = function ()
		{
			hideMenu();
			this.parentNode.className = 'hover';
		};

		actuator.onmouseout = function ()
		{
			this.parentNode.className = '';
		};

		return;
	};

	menuItems = menu.getElementsByTagName('li');
	for (i = 0; i < menuItems.length; i++)
	{
		menuItems[i].onmouseover = function ()
		{
			this.className = 'hover';
		};
		menuItems[i].onmouseout = function ()
		{
			this.className = '';
		};
	};

	menu.onclick = function ()
	{
			hideMenu();
			return true;	// follow the link
	}

	actuator.onmouseover = function ()
	{
		clearHideTimer();            

		if (menubarElem.getAttribute('clickToActivate') == 'true')
		{
				if (menubarElem.currentMenu)
				{
					// only show menus on mouseover if we are tracking
					this.showMenu();
				}
		}
		else
		{
			this.showMenu();
		};

		this.parentNode.className = 'hover';
	};
  
	actuator.onmouseout = function ()
	{
		startHideTimer();
		this.parentNode.className = '';
	}

	actuator.onclick = function ()
	{
		if (menubarElem.getAttribute('clickToActivate') != 'true')
		{
			hideMenu();
			return true;	// follow the link, do no futher work
		}

		if (menubarElem.currentMenu == null)
		{
			this.showMenu();
		}
		else
		{
			hideMenu();
		}
			
		return false; 	// don't follow the link
	}

	actuator.showMenu = function ()
	{
			var fudgeH = 0;
			var fudgeV = 0;
				
			hideMenu();
				
			//menu.style.left = (this.offsetLeft - fudgeH) + "px";
			menu.style.top = (this.offsetTop + this.offsetHeight - fudgeV) + "px";
			menu.style.visibility = "visible";

			menubarElem.currentMenu = menu;

			startHideTimerWithTimeout(MENU_HIDE_TIMEOUT);
		}

		actuator.onmousemove = function ()
		{
			startHideTimerWithTimeout(MENU_HIDE_TIMEOUT);
			
			// if we are an actuator, and there is no current menu
			// make sure we re-show ourselves if necessary
			
			if ((menubarElem.getAttribute('clickToActivate') != 'true') &&
						(menubarElem.currentMenu == null) &&
						this.showMenu)
			{
				this.showMenu();
			}
		}

		menu.onmousemove = actuator.onmousemove;

		menu.onmouseover = function ()
		{
			this.parentNode.className = 'active';
			this.style.visibility = "visible";
			clearHideTimer();
		}
		
		menu.onmouseout = function ()
		{
			this.parentNode.className = '';
			startHideTimer();
		}
}

function InitializeMenus(menus)
{
	var		allAnchors;

	var		navMenuClassRegEx;
	var		i;
	var		menuActuator;
	var		aSibling;
	var		navMenuList;

	//	Grab all 'a' elements in the document
	allAnchors = document.getElementsByTagName('a');

	navMenuClassRegEx = /menuActuator/;

	//	Loop through them, filtering for ones that have 'className' of
	//	'menuActuator'

	for (i = 0; i < allAnchors.length; i++)
	{
		menuActuator = allAnchors[i];
		navMenuList = null;

		if (navMenuClassRegEx.test(menuActuator.className) == false)
		{
			continue;
		};

		//	See if it actually has a 'ul' as one of its next siblings. That will
		//	be a menu.
		aSibling = menuActuator.nextSibling;
		while (aSibling != null)
		{
				//	Make sure that its an Element node (type 1) and a 'ul'.
				if ((aSibling.nodeType == 1) &&
						(aSibling.tagName.toLowerCase() == 'ul'))
				{
					navMenuList = aSibling;
					break;
				};

				aSibling = aSibling.nextSibling;
		};

			_InitializeMenu(navMenuList, menuActuator);	
	};

	return;
}

addEvent(window,'load',function () {
  InitializeMenus();
});
