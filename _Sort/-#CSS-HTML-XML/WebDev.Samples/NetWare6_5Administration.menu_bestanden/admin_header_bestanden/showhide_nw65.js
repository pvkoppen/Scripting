var curImageID = "title"; //defines initial selected buttonvar curmenuID = "blank"; //defines initial menu being displayedvar curpageID = "mygroup"; //defines initial page being displayedvar timeoutID = null; //defined timeout variable to start and stop setTimeout()//array for all images if (document.images)	{	//load images for swapping	var imageArray = new Array();	imageArray["title1"] = new Image(171,20);	imageArray["title2"] = new Image(171,20);	//set images URLs	imageArray["title1"].src = "images/NW65_title1.gif";	imageArray["title2"].src = "images/NW65_title2.gif";	}function showhide(divID){	var element;	element = document.getElementById(divID);	    	if(element.style.display == "none")  	{		element.style.display = "block";	}	else	{		element.style.display = "none";	} }function navshowhide(divID, imageID){	var element;	element = document.getElementById(divID);	    	if(element.style.display == "none")  	{		element.style.display = "block";		document.images[imageID].src = imageArray["minus"].src;	}	else	{		element.style.display = "none";		document.images[imageID].src = imageArray["plus"].src;	} }function expandcollapse(divID, imageID){	var element = document.getElementById(divID);			if(element.style.display == "none")	  	{			element.style.display = "block";			document.images[imageID].src = imageArray["minus"].src;		}	else		{			element.style.display = "none";			document.images[imageID].src = imageArray["plus"].src;		} }function swapimage(imageID){//	alert(curImageID);	  	    	if(curImageID != imageID)	  	{			document.images[curImageID].src = imageArray[curImageID + '1'].src;			document.images[imageID].src = imageArray[imageID + '2'].src;			curImageID = imageID;		}}function show_hint(titleID, hintID)	{		var hintIDelement = document.getElementById(hintID);		var titleIDelement = document.getElementById(titleID);		hintIDelement.style.visibility = "visible";  		titleIDelement.style.visibility = "visible";  	}			function hide_hint(titleID, hintID)	{		var hintIDelement = document.getElementById(hintID);		var titleIDelement = document.getElementById(titleID);		hintIDelement.style.visibility = "hidden";  		titleIDelement.style.visibility = "hidden";  	}			