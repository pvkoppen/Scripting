//===================================================
// BrowserVersion.js
//===================================================

//Get browser type, version, platform
var WIN =  (navigator.userAgent.indexOf("Win") != -1);
var MAC =  (navigator.userAgent.indexOf("Mac") != -1);
var LIN =  (navigator.userAgent.indexOf("Lin") != -1);

//original mozilla
var M2   = (navigator.userAgent.indexOf("Mozilla/2") != -1);
var M3   = (navigator.userAgent.indexOf("Mozilla/3") != -1);
var M4   = (navigator.userAgent.indexOf("Mozilla/4") != -1);
var M5   = (navigator.userAgent.indexOf("Mozilla/5") != -1);

//opera
var OP   = (navigator.userAgent.indexOf("Opera") != -1);
var OP3  = (navigator.userAgent.indexOf("Opera/3") != -1) && M3;
var OP35 = (navigator.userAgent.indexOf("Opera/3") != -1) && M4;
var OP36 = (navigator.userAgent.indexOf("Opera 3") != -1) && M4;
var OP4  = (navigator.userAgent.indexOf("Opera 4") != -1) ||
           (navigator.userAgent.indexOf("Opera/4") != -1);
var OP5  = (navigator.userAgent.indexOf("Opera 5") != -1) ||
           (navigator.userAgent.indexOf("Opera/5") != -1);
var OP6  = (navigator.userAgent.indexOf("Opera 6") != -1) ||
           (navigator.userAgent.indexOf("Opera/6") != -1);

//internet explorer
var IE   = (navigator.userAgent.indexOf("MSIE") != -1) && !OP;
var IE3  = (navigator.userAgent.indexOf("MSIE 3") != -1);
var IE4  = (navigator.userAgent.indexOf("MSIE 4") != -1);
var IE50 = (navigator.userAgent.indexOf("MSIE 5.0") != -1) && !OP;
var IE55 = (navigator.userAgent.indexOf("MSIE 5.5") != -1) && !OP;
var IE60 = (navigator.userAgent.indexOf("MSIE 6.0") != -1) && !OP;
var IEVer = 0;
if (IE)
{
   if (IE3)       IEVer = 3;
   else if (IE4)  IEVer = 4;
   else if (IE50) IEVer = 5.0;
   else if (IE55) IEVer = 5.5;
   else if (IE60) IEVer = 6.0;
   else           IEVer = 100;
   //alert("IE browser version = "+IEVer);
}

//netscape
var NS   = (navigator.appName == "Netscape") && !OP;
var NS2  = (navigator.appName == "Netscape") && M2 && !OP;
var NS3  = (navigator.appName == "Netscape") && M3 && !OP;
var NS4  = (navigator.appName == "Netscape") && M4 && !OP;
var NS6  = (navigator.userAgent.indexOf("Netscape6") != -1) && M5 && !OP;
var NS7  = (navigator.userAgent.indexOf("Netscape/7") != -1)&& M5 && !OP;
var NSVer = 0;
if (NS)
{
   if (NS2)       NSVer = 2;
   else if (NS3)  NSVer = 3;
   else if (NS4)  NSVer = 4;
   else if (NS6)  NSVer = parseFloat(navigator.userAgent.substring(navigator.userAgent.indexOf("Netscape6/") + 10));
   else if (NS7)  NSVer = parseFloat(navigator.userAgent.substring(navigator.userAgent.indexOf("Netscape/") + 9));
   else           NSVer = 100;
   //alert("Netscape browser version = "+NSVer); 
}

//open-source mozilla/gecko
var MOZ1 = M5 && !OP && 
           (navigator.userAgent.indexOf("Netscape") == -1) &&
           (navigator.userAgent.indexOf("Gecko") != -1) &&
           (navigator.userAgent.indexOf("rv:1") != -1);

//Browser that runs on the NetWare GUI
var NW = (navigator.appName.indexOf("Netware Remote Manager") != -1);

//minimum version variables
//Treat NetWare Browser as Netscape 6 since they are functionaly equivelant and we don't want to everyone to have the extra check
NN6 =  ((NS && NSVer>=6) || NW);       //at least netscape 6
MS4 =  (IE && IEVer>=4);       //at least ie 4
MS55 = (IE && IEVer>=5.5);     //at least ie 5.5
PIE =  ((parseInt(navigator.appVersion)>=2)&&(navigator.appVersion.indexOf("Windows CE")!=-1))?true:false;   //at least pocket ie 2