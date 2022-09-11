/////////////////////////////////////////////////////////////////////
//
// helpinfo.js - definition of Help information used 
//               throughout the InstallShield Help Library
//
// Copyright © 2002-2003 InstallShield Software Corporation
//
/////////////////////////////////////////////////////////////////////
//
// Use the appropriate value for HELPNETPRODUCTCAT
//
// 2     AdminStudio
// 4     DemoShield
// 6     InstallShield Developer
// 38  Expo Walkthrough
// 7     InstallShield Express
// 8     InstallShield MultiPlatform
// 9     InstallShield Professional
// 13    PackageForTheWeb
// 27    InstallShield Update Service
// 33    RedBend vBuild
// 50    InstallShield DevStudio
 
var HELPNETPRODUCTCAT = "50";
 
// Enter the current version of the product
 
var HELPNETPRODUCTVER = "9.0";
 
// These variables control the timestamp on the bottom of each topic
 
dateObj = new Date(document.lastModified)
var datetimestamp=dateObj.toLocaleString(document.lastModified);
var leading="Topic Last Updated: "
var modstamp = leading + datetimestamp;


function AfxGetApp() {
    var oObjMgr = new ActiveXObject("ISProxy.Proxy");
	oObjMgr.ISCreateObject(document, "Isobjmgr.dll", "{DE5FBA5D-8AB0-4a53-B620-F2065702D228}");
    return oObjMgr.pApp;
}

function AfxGetNav() {
    var oApp = AfxGetApp();
    return oApp.GetNav();
}

function GotoView(sView) {
    var oNav = AfxGetNav();
    oNav.GoToNode(sView);
    
    var oApp = AfxGetApp();
    oApp.FocusToIDE();
    
    return false;
}