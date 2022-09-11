function changeImagesArray(array) {
	if (preloadFlag == true) {
		var d = document; var img;
		for (var i=0; i<array.length; i+=2) {
			img = null; var n = array[i];
			if (d.images) {img = d.images[n];}
			if (!img && d.getElementById) {img = d.getElementById(n);}
			if (img) {img.src = array[i+1];}
		}
	}
}

function changeImages() {
	changeImagesArray(changeImages.arguments);
}

var preloadFlag = false;

function preloadImages() {
	if (document.images) {
		pre_square_over = newImage('img/orange_square.jpg');
		pre_square_off = newImage('img/pixel.gif');
		preloadFlag = true;
	}
}

function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

//-->

//<!-- Original:  CodeLifter.com (support@codelifter.com) -->
//<!-- Web Site:  http://www.codelifter.com -->

//<!-- This script and many more are available free online at -->
//<!-- The JavaScript Source!! http://javascript.internet.com -->

//<!-- Begin
// Set slideShowSpeed (milliseconds)
var slideShowSpeed = 4000;

// Duration of crossfade (seconds)
var crossFadeDuration = 3;

// Specify the image files
var Pic1 = new Array();
var Pic2 = new Array();
var Pic3 = new Array();
var Pic4 = new Array();
// to add more images, just continue
// the pattern, adding to the array below

Pic1[0] ="img/1_04.jpg"
Pic1[1] ="img/1_01.jpg"
Pic1[2] ="img/1_02.jpg"
Pic1[3] ="img/1_03.jpg"

Pic2[0] ="img/2_04.jpg"
Pic2[1] ="img/2_01.jpg"
Pic2[2] ="img/2_02.jpg"
Pic2[3] ="img/2_03.jpg"

Pic3[0] ="img/3_04.jpg"
Pic3[1] ="img/3_01.jpg"
Pic3[2] ="img/3_02.jpg"
Pic3[3] ="img/3_03.jpg"

Pic4[0] ="img/4_04.jpg"
Pic4[1] ="img/4_01.jpg"
Pic4[2] ="img/4_02.jpg"
Pic4[3] ="img/4_03.jpg"



// do not edit anything below this line
var t;
var j = 0;
var p = Pic1.length;

var preLoad1 = new Array();
var preLoad2 = new Array();
var preLoad3 = new Array();
var preLoad4 = new Array();

for (i = 0; i < p; i++) {
	preLoad1[i] = new Image();
	preLoad1[i].src = Pic1[i];

	preLoad2[i] = new Image();
	preLoad2[i].src = Pic2[i];

	preLoad3[i] = new Image();
	preLoad3[i].src = Pic3[i];

	preLoad4[i] = new Image();
	preLoad4[i].src = Pic4[i];
}

function runSlideShow1() {
	if (document.all) {
		document.images.SlideShow1.style.filter="blendTrans(duration=2)";
		document.images.SlideShow1.style.filter="blendTrans(duration=crossFadeDuration)";
		document.images.SlideShow1.filters.blendTrans.Apply();
	}

	document.images.SlideShow1.src = preLoad1[j].src;

	if (document.all) {
		document.images.SlideShow1.filters.blendTrans.Play();
	}

	//j = j + 1;
	//if (j > (p - 1)) j = 0;
	t = setTimeout('runSlideShow1()', slideShowSpeed);
}

function runSlideShow2() {
	if (document.all) {
		document.images.SlideShow2.style.filter="blendTrans(duration=2)";
		document.images.SlideShow2.style.filter="blendTrans(duration=crossFadeDuration)";
		document.images.SlideShow2.filters.blendTrans.Apply();
	}

	document.images.SlideShow2.src = preLoad2[j].src;

	if (document.all) {
		document.images.SlideShow2.filters.blendTrans.Play();
	}

	//j = j + 1;
	//if (j > (p - 1)) j = 0;
	t = setTimeout('runSlideShow2()', slideShowSpeed);
}

function runSlideShow3() {
	if (document.all) {
		document.images.SlideShow3.style.filter="blendTrans(duration=2)";
		document.images.SlideShow3.style.filter="blendTrans(duration=crossFadeDuration)";
		document.images.SlideShow3.filters.blendTrans.Apply();
	}

	document.images.SlideShow3.src = preLoad3[j].src;

	if (document.all) {
		document.images.SlideShow3.filters.blendTrans.Play();
	}

	//j = j + 1;
	//if (j > (p - 1)) j = 0;
	t = setTimeout('runSlideShow3()', slideShowSpeed);
}

function runSlideShow4() {
	if (document.all) {
		document.images.SlideShow4.style.filter="blendTrans(duration=2)";
		document.images.SlideShow4.style.filter="blendTrans(duration=crossFadeDuration)";
		document.images.SlideShow4.filters.blendTrans.Apply();
	}

	document.images.SlideShow4.src = preLoad4[j].src;

	if (document.all) {
		document.images.SlideShow4.filters.blendTrans.Play();
	}

	j = j + 1;
	if (j > (p - 1)) j = 0;
	t = setTimeout('runSlideShow4()', slideShowSpeed);
}

function start(){
	t = setTimeout('runSlideShow1()', slideShowSpeed/4*1);
	t = setTimeout('runSlideShow3()', slideShowSpeed/4*2);
	t = setTimeout('runSlideShow2()', slideShowSpeed/4*3);
	t = setTimeout('runSlideShow4()', slideShowSpeed);

	preloadImages()
}