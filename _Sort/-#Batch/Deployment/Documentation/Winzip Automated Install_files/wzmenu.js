function LeftNav(element, mode) {
 if ((document.getElementById) || (document.all)) {

  //defaults
  var bgColor = '#FFCC00';
  var txtColor = '#000000';

  if (mode == 'over') {
   bgColor = '#B70E14';
   txtColor = '#FFFFFF';
  } else if (mode == 'hi') {
   bgColor = '#B70E14';
   txtColor = '#FFFFFF';
  }

  //modern browsers
  if (document.getElementById) {

   var navTxt = document.getElementById(element + "Link");

   //change colors, swap image
   document.getElementById(element).style.backgroundColor = bgColor;
   if (navTxt) { navTxt.style.color = txtColor; }

  //IE 4
  } else if (document.all) {

   var navTxt = document.all(element + "Link");

   //change colors, swap image
   document.all(element).style.backgroundColor = bgColor;
   if (navTxt) { navTxt.style.color = txtColor; }
  }
 }
}
