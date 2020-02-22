/*
 Copyright 2015 webtrends Inc. All Rights Reserved.
 WEBTRENDS PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
*/
(function(h,n,t,A){function m(h,g,m,n){var t=this,v={major:0,minor:0,inc:1},e=this,A=!1,F=2E3,B="undefined"!=typeof _wt_forceSSL&&_wt_forceSSL?"https:":"https:"==document.location.protocol?"https:":"http:",L="sizzle",G=null,H=!1,C=!1,k={},w=!1;k.s_eventHandlers={};this.isBodyExtant=function(){try{return"undefined"!=typeof document.getElementsByTagName("body")[0]?!0:!1}catch(a){return WT.Debug.error("isBodyExtant: body detection fail, assuming false","002",a),!1}};this.inHead=function(){return w};
this.getSelector=function(){switch(L){case "sizzle":if(WT.hasVal(Sizzle))return Sizzle;break;default:if(null!==G)return G;WT.Debug.error("getSelector:  No Selector found","003");return null}};this.setCustomSelector=function(a,b){L=a;G=b};this.applyStyleSheet=function(a,b){try{var d=g.getElementsByTagName("head")[0],e=g.createElement("style");e.type="text/css";e.id=b;e.styleSheet?e.styleSheet.cssText=a:e.appendChild(g.createTextNode(a));d.appendChild(e)}catch(f){WT.Debug.error("applyStyleSheet:  Failed to failed to apply stylesheet",
"004",f)}};this.removeStyleSheet=function(a){try{var b=g.getElementById(a);"undefined"!==typeof b&&null!==b&&b.parentNode.removeChild(b)}catch(d){WT.Debug.debug("removeStyleSheet:  Failed to remove stylesheet")}};this.redirectElement=function(a,b){b&&WT.Debug.debug(b);null!==a&&a.wt_pending&&"true"===a.wt_pending?(WT.Debug.info("click: redirecting to url ["+a.wt_href+"]"),a.href=a.wt_href,a.target=a.wt_target,a.wt_pending="","undefined"!==typeof a.wt_target&&""!==a.wt_target&&null!==a.wt_target?window.open(a.wt_href,
a.wt_target):setTimeout(function(){window.location.href=a.wt_href},0)):WT.Debug.debug("click: redirect not pending or !elm, so not redirecting")};this.hasVal=function(a){return null!==a&&"undefined"!==typeof a?!0:!1};var u=function(){H||(H=!0,WT.fireEvent(new WTEvent(WTEvent.DOM_READY,WTEvent.STATUS_SUCCESS),!0))},D=function(){C||(C=!0,WT.fireEvent(new WTEvent(WTEvent.DOM_ONLOAD,WTEvent.STATUS_SUCCESS),!0))},E=function(a){return"undefined"!==typeof r&&"undefined"!==typeof c[a].contextName&&"undefined"!==
typeof r[a]&&r[a]===c[a].contextName?(e.Debug.trace("LOADER:  context '"+c[a].contextName+"' triggered for "+a),!0):"undefined"===typeof r||"undefined"===typeof r[a]?(e.Debug.trace("LOADER:  published context triggered for "+a),!0):!1};this.click=function(a,b){try{var d=2;if("undefined"!=typeof a&&"object"==typeof a){var l,f;a.type?(l=a,f=a.currentTarget?a.currentTarget:a.srcElement):a.tagName&&(f=a);l&&(l.preventDefault?l.preventDefault():l.returnValue=!1);if(f){if(f.href){f.wt_pending||(f.wt_pending=
"true",f.wt_href=f.href,f.wt_target=f.target,f.href="javascript:void(0);",f.target="");b.r_redirectLink=f;var c=b.s_conversionTimeout?b.s_conversionTimeout:F;setTimeout(function(){WT.Debug.info("Click: timed out after "+c);redirectElement(f)},c)}}else b=a,d=1}l={};l.element=a;l.params=b;l.arguments=Array.prototype.slice.call(arguments,d);e.fireEvent(new WTEvent(WTEvent.LOADER_CLICK,WTEvent.STATUS_SUCCESS,null,l))}catch(s){"object"==typeof a&&a.href&&b.r_redirectLink===a&&(a.href=a.wt_href,a.target=
a.wt_target),WT.Debug.error("Click: Fatal error, check error message for details.","005",s)}};this.execute=function(a){var b={};b.params=a;b.arguments=Array.prototype.slice.call(arguments,1);e.fireEvent(new WTEvent(WTEvent.LOADER_EXECUTE,WTEvent.STATUS_SUCCESS,null,b))};this.loaderConversionTimeoutDefault=function(){return F};this.setLoaderConversionTimeoutDefault=function(a){F=a};this.startTimer=function(a,b){WT.hasVal(c[a])&&(e.Debug.trace("LOADER:  api starting timer for "+b+" ms on "+a),WT.hasVal(b)?
c[a]._startTimer(b):c[a]._startTimer(1E4))};this.clearTimer=function(a){c[a]&&(e.Debug.trace("LOADER:  loader clearing timer for "+a),c[a]._clearTimer(),e.fireEvent(new WTEvent(a+"_"+WTEvent.TIMER_CLEAR,WTEvent.STATUS_SUCCESS)))};this.pollForCondition=function(a,b,d){var l=function(a,b,d,c){setTimeout(function(){c--;a()?(e.Debug.trace("pollForCondition success result\x3d"+a(),"LOADER"),e.Debug.superfine("pollForCondition success condition\x3d"+a.toString(),"LOADER"),b&&(b(),e.Debug.trace("pollForCondition running callback",
"LOADER"),e.Debug.superfine("pollForCondition callback\x3d"+b.toString(),"LOADER"))):0<c?l(a,b,d,c):(e.Debug.error("pollForCondition Fail on "+a.toString(),"009"),d&&(d(),e.Debug.superfine("pollForCondition callbackFailure\x3d"+d.toString(),"LOADER")))},e.s_pollInterval)};l(a,b,d,100)};this.paramsMerge=function(a,b,d){var e={};if(WT.hasVal(a))for(var f in a)a.hasOwnProperty(f)&&(e[f]=a[f]);for(var c in b)WT.hasVal(b[c])&&b.hasOwnProperty(c)&&(WT.hasVal(d)&&WT.hasVal(d[c])?e[c]=d[c]:e[c]=b[c]);return e};
this.downloadLib=function(a,b,d,c,f,q){e.Debug.info("LOADER:  Start download: "+B+q+" \x26 attach to "+a+", async\x3d"+f);setTimeout(function(){var c=g.getElementsByTagName(a)[0],l=g.createElement("script");l.type="text/javascript";l.src=B+q;l.setAttribute("async",f);l.setAttribute("defer",f);l.wtHasRun=!1;var k=function(){!1===this.wtHasRun?(b(),this.wtHasRun=!0,e.Debug.info("Completed download: "+B+q+", callback running, set wtHasRun\x3d"+this.wtHasRun,"LOADER"),e.Debug.superfine("downloadLib: successCallback\x3d"+
b.toString(),"LOADER")):e.Debug.trace("downloadLib: not running successCallback, since wtHasRun\x3d"+this.wtHasRun,"LOADER")};b&&(l.onload=k,l.onreadystatechange=k);l.onerror=function(){e.Debug.error("FAILED download: "+B+q+" \x26 attach to "+a+", async\x3d"+f,"010");d&&(d(),e.Debug.superfine("failCallback: "+d.toString(),"LOADER"))};typeof("undefined"!==c)?c.appendChild(l):e.Debug.info("LOADER:  Dom element: "+a+" is not found so not Downloading")},c)};this.downloadLibs=function(a,b,d,c,f){if("undefined"===
typeof f)e.Debug.info("LOADER:  downloadLibs srcs is empty");else{var q={},s;for(s in f)f.hasOwnProperty(s)&&(q[s]="waiting",e.Debug.trace("LOADER:  downloadLibs is waiting on src:"+s+" \x3d "+f[s]),e.downloadLib(a,function(a){return function(){q[a]="complete";e.Debug.trace("LOADER:  downloadLibs is complete src:"+a+" \x3d "+f[a])}}(s),null,d,c,f[s]));e.pollForCondition(function(){for(var a in q)if(q.hasOwnProperty(a)&&"complete"!==q[a])return!1;return!0},function(){e.Debug.debug("LOADER:  downloadLibs completed on all downloads");
b()})}};this.parseQueryString=function(a){var b=a;e.hasVal(a)&&e.hasVal(a.location)&&e.hasVal(a.location.search)||(b=document);if(b.location.search){b=b.location.search.substring(1,b.location.search.length);a=b.split("\x26");null!==a&&0===a.length&&(a=b.split(";"));for(var b=a.length-1,d={},c=0;c<=b;c++){var f=a[c].split("\x3d");f[0]=unescape(f[0]);f[1]=unescape(f[1]);f[0]=f[0].replace(/\+/g," ");f[1]=f[1].replace(/\+/g," ");f[1]=f[1].replace(/<.*\?>/g,"");d[f[0]]=f[1]}return d}return null};this.abortModuleHelper=
function(a,b){WT.fireEvent(new WTEvent(a+"_"+WTEvent.LOADER_MODULE_ABORT,WTEvent.STATUS_SUCCESS));WT.setExecuteState(a,WTEvent.LOADER_MODULE_ABORT);WT.clearTimer(a);WT.Debug.error("Aborting product: "+a,"011");WT.Debug.error("LOADER Error","011",b)};WTEvent=function(a,b,d,e){a&&(a=a.toLowerCase());this.name=a;this.handler=null;this.state=WTEvent.STATUS_UNKNOWN;b&&(this.state=b);this.target=d;this.params={};e&&(this.params=e)};this.addEventHandler=function(a,b,d){if(!a||!b&&!d)return e.Debug.debug("events: Can not add event handler, missing name or listeners. ",
"LOADER"),-1;a=a.toLowerCase();k.s_eventHandlers[a]||(k.s_eventHandlers[a]={},k.s_eventHandlers[a].success=[],k.s_eventHandlers[a].fault=[]);var c=!1;if(b){for(var c=!1,f=0;f<k.s_eventHandlers[a].success.length;f++)if(e.hasVal(k.s_eventHandlers[a].success[f])&&k.s_eventHandlers[a].success[f].toString()===b.toString()){c=!0;break}c||(k.s_eventHandlers[a].success.push(b),e.Debug.superfine("addEventHandler success handler"+k.s_eventHandlers[a].success.length+" for "+a+"\nhandler\x3d"+b.toString(),"LOADER"))}f=
c?0:1;if(d){for(var c=!1,q=0;q<k.s_eventHandlers[a].fault.length;q++)if(e.hasVal(k.s_eventHandlers[a].fault[q])&&k.s_eventHandlers[a].fault[q].toString()===d.toString()){c=!0;break}c||(k.s_eventHandlers[a].fault.push(d),e.Debug.superfine("addEventHandler fault handler"+k.s_eventHandlers[a].fault.length+" for "+a+"\nhandler\x3d"+b.toString(),"LOADER"))}return f+(c?0:1)};this.removeEventHandler=function(a,b,d){if(!a)return e.Debug.trace("LOADER removeEventHandler:  events: Can not remove event handler, missing name."),
-1;a=a.toLowerCase();k.s_eventHandlers[a]||(k.s_eventHandlers[a]={},k.s_eventHandlers[a].success=[],k.s_eventHandlers[a].fault=[]);if(!b&&!d)return delete k.s_eventHandlers[a],0;var c=0;if(b)for(var f=0;f<k.s_eventHandlers[a].success.length;f++)if(e.hasVal(k.s_eventHandlers[a].success[f])&&k.s_eventHandlers[a].success[f].toString()==b.toString()){delete k.s_eventHandlers[a].success[f];c=1;break}if(d)for(b=0;b<k.s_eventHandlers[a].fault.length;b++)if(e.hasVal(k.s_eventHandlers[a].fault[b])&&k.s_eventHandlers[a].fault[b].toString()==
d.toString()){delete k.s_eventHandlers[a].fault[b];c++;break}return c};this.fireEvent=function(a,b,d){if(A&&!d)return e.Debug.error("fireEvent: Loader global abort, Aborted due to prior error, check error message for details.","012"),a.name?e.Debug.error("fireEvent(event\x3d'"+a.name+"'): g_loaderAborted due to prior error, check error message for details.","012"):e.Debug.error("fireEvent: Aborted due to prior error, check error message for details.","012"),-1;if(!k.s_eventHandlers[a.name])return e.Debug.trace("fireEvent: no registered event was found for event name: "+
a.name),-1;d=k.s_eventHandlers[a.name][a.state];if(!d)return e.Debug.trace("fireEvent: no event handler was registered for event: "+a.name+" state: "+a.state),-1;for(var c=0,f=0;f<d.length;f++)if(d[f])try{a.handler=d[f],a.params.eventID=(new Date).getTime(),e.Debug.trace("fireEvent: [name:"+a.name+"], state:"+a.state+", handler["+f+"]","LOADER"),e.Debug.superfine("function:"+a.handler.toString()+"]","LOADER"),b?setTimeout(function(a,b){return function(){a(b)}}(d[f],a),0):a.handler(a),c++}catch(q){e.Debug.error("Unhandled Event Exception, [name: "+
a.name+", state: "+a.state+", function: "+a.handler.toString()+"]","013",q)}return c};WTEvent.PREINIT="preinit";WTEvent.INIT="init";WTEvent.PRELOAD="preload";WTEvent.LOAD="load";WTEvent.POSTLOAD="postload";WTEvent.LOADER_ABORT="loader_abort";WTEvent.LOADER_MODULE_ABORT="loader_module_abort";WTEvent.LOADER_CLICK="loader_click";WTEvent.LOADER_EXECUTE="loader_execute";WTEvent.DEBUGGER_CLEAR_COOKIES="debugger_clear_cookies";WTEvent.DEBUGGER_DUMP_PARAMS="debugger_dump_params";WTEvent.DOM_READY="dom_ready";
WTEvent.DOM_ONLOAD="dom_onload";WTEvent.TIMER_EXPIRE="timer_expire";WTEvent.TIMER_CLEAR="timer_clear";WTEvent.STATUS_SUCCESS="success";WTEvent.STATUS_FAULT="fault";WTEvent.STATUS_UNKNOWN="unknown";WTEvent.HIDESHOW="hide_show";WTEvent.PAGEVIEW="pageview";WTEvent.CONVERSION="conversion";WTEvent.DEBUGGER_CHECK_MODE="debugger_check_mode";this._Debug=function(){var a=-1;this._shutdown=!1;var b=[],d=this,c=function(f,d,c){c&&(d=c+":  "+d);this._shutdown||b.push([f,d]);if(this._shutdown)b=[];else if(!(a<
f)&&"undefined"!==typeof console&&console){c=!0;switch(f){case 0:console.error&&(console.error(d),c=!1);break;case 1:console.warn&&(console.warn(d),c=!1);break;case 2:console.info&&(console.info(d),c=!1);break;case 3:case 4:case 5:console.log&&(console.log(d),c=!1)}!0===c&&console.log&&console.log(d)}};d.logInfo=function(a){d.info(a)};d.logDebug=function(a){d.debug(a)};d.logTrace=function(a){d.trace(a)};d.logError=function(a,b,c){d.error(a,b,c)};d.superfine=function(a,b){c(5,a,b)};d.trace=function(a,
b){c(4,a,b)};d.debug=function(a,b){c(3,a,b)};d.info=function(a,b){c(2,a,b)};d.error=function(a,b,d,e){var g="";d&&("string"===typeof d?g="\n"+d:d.toString?(g=d.toString(),d.stack&&(g+=", [stack]: "+d.stack)):g="\n"+(d.message?d.message:"")+(d.name?" ["+d.name+"]":"")+(d.fileName?"\n ("+d.fileName+":"+d.lineNumber+")\n"+d.stack:""));c(0,(b?b+": ":"")+a+g,e);WT.fireEvent(new WTEvent(WTEvent.DEBUG_ERROR_OUT,WTEvent.STATUS_SUCCESS,d))};d.dir=function(a,b,e){b&&c(2,b,e);console&&"function"===typeof console.dir?
console.dir(a):d.dirStr(a)};d.dirStr=function(a,b){a=a||{};b=b||"";for(var c in a)a.hasOwnProperty(c)&&"function"!==typeof a[c]&&d.debug("\t"+c+" : "+a[c],b)};d.setDebugLevel=function(b){a=b};d.getDebugLevel=function(){return a};d.clearCookies=function(){WT.fireEvent(new WTEvent(WTEvent.DEBUGGER_CLEAR_COOKIES,WTEvent.STATUS_SUCCESS))};d.dumpParams=function(){var a=d.getConfigParams();a.loader&&d.dir(a.loader,"Config parameters","Loader");a.optimize&&d.dir(a.optimize,"Config parameters","Optimize");
return a};d.getConfigParams=function(){var a={loader:null,optimize:null};a.loader={version:v,versionStr:[v.major,v.minor,v.inc].join(".")};t.optimize&&(a.optimize=t.optimize.getParams&&t.optimize.getParams());return a};d.checkMode=function(a){WT.fireEvent(new WTEvent(WTEvent.DEBUGGER_CHECK_MODE,WTEvent.STATUS_SUCCESS,{resetFlag:a}))};d.getHistory=function(){return b}};var M=function(a,b){this._name=a;this._state=b;this._met=!1},p=function(a,b,d){this.prodId=a;this.plugin=new b;this.executeState=p.DOWNLOADING;
this.setRunningFlag=!1;this.stopTime=this.startTime=this.timer=null;this.contextName="default";"undefined"!==typeof d&&(this.contextName=d);var c=this,f={};this.putDependency=function(a){f[a._name]=a};this.clearDependencies=function(){f={}};this.getDependency=function(a){for(var b in f)if(f.hasOwnProperty(b)&&f[b]._name==a)return f[b];return null};this.getExecuteState=function(){return this.executeState};this.hasMetDeps=function(){for(var a in f)if(f.hasOwnProperty(a)&&!1===f[a]._met)return!1;return!0};
this.updateDependencyState=function(a,b){var d=c.getDependency(a);null!==d&&d._state===b&&(d._met=!0)};this._startTimer=function(a){this.timer?e.Debug.info("LOADER:  "+this.prodId+" timer already started, using current timer."):(e.Debug.debug("LOADER:  starting timer for "+c.prodId),this.timer=setTimeout(function(){e.Debug.error("LOADER:  "+c.prodId+"module timer expired calling Abort","015");e.fireEvent(new WTEvent(c.prodId+"_"+WTEvent.TIMER_EXPIRE,WTEvent.STATUS_SUCCESS));e.fireEvent(new WTEvent(c.prodId+
"_"+WTEvent.LOADER_MODULE_ABORT,WTEvent.STATUS_SUCCESS))},a),this.startTime=new Date,e.Debug.info("LOADER:  "+this.prodId+" timer started ["+this.startTime+"]."))};this._clearTimer=function(){this.stopTime=new Date;this.timer&&(clearTimeout(this.timer),this.timer=null);e.Debug.info("LOADER:  "+this.prodId+" timer cleared ["+this.stopTime+"]")}};p.DOWNLOADING="downloading";p.WAITING="waiting";p.READY="ready";p.RUNNING="running";p.COMPLETE="complete";p.ABORTED="aborted";var c={};this.registerPlugin=
function(a,b){c[a.ProductName]=new p(a.ProductName,a,b);c[a.ProductName].executeState=p.DOWNLOADING;WT.hasVal(a.prototype.abort)&&WT.addEventHandler(a.ProductName+"_"+WTEvent.LOADER_MODULE_ABORT,a.prototype.abort);if(WT.hasVal(a.prototype.wtConfigObj.s_dependencies))for(var d=[],d=a.prototype.wtConfigObj.s_dependencies.split(","),e=0;e<d.length;e++){var f=[],f=d[e].split(":");c[a.ProductName].putDependency(new M(f[0],f[1]))}};this.updateDependencies=function(a,b){if(!a||!c[a])return null;if(!b)return c[a].clearDependencies(),
null;var d=[],d=b.split(",");if(!d||0==d.length)return null;c[a].clearDependencies();for(var e=0;e<d.length;e++)if(nameToState=d[e].split(":"),2===nameToState.length)c[a].putDependency(new M(nameToState[0],nameToState[1]));else return null};this.setExecuteState=function(a,b){if(b===WTEvent.LOADER_MODULE_ABORT)c[a].executeState=p.ABORTED;else if(e.getExecuteState(a)!==WTEvent.LOADER_MODULE_ABORT){c[a].executeState=b;e.Debug.trace("setExecuteState:  '"+a+"' to '"+b+"'");for(var d in c)c.hasOwnProperty(d)&&
c[d].updateDependencyState(a,b);for(var l in c)if(c.hasOwnProperty(l)&&(d=c[l].getExecuteState(),c[l].hasMetDeps()&&d==p.READY&&(e.Debug.debug("setExecuteState:  '"+l+"' has met all dependencies \x26\x26 ready, running postload"),WT.hasVal(c[l].plugin[WTEvent.POSTLOAD]))))c[l].plugin[WTEvent.POSTLOAD]()}};this.getExecuteState=function(a){return WT.hasVal(c[a])?c[a].executeState===p.ABORTED?WTEvent.LOADER_MODULE_ABORT:c[a].executeState:null};this.isDependency=function(a){for(var b in c)if(c.hasOwnProperty(b)&&
null!==c[b].getDependency(a))return e.Debug.trace("isDependency:  '"+a+"' is dependency of '"+b+"'"),!0;e.Debug.trace("isDependency:  '"+a+"' is not a dependency of any product");return!1};this.getContextUrl=function(a,b){return"//c.webtrends.com/acs/account/mx643kesn3/js/"+a+"-"+b+".js"};this.getProduct=function(a){for(var b in c)if(c.hasOwnProperty(b)&&a==c[b].prodId)return c[b];return null};this.isReady=function(){return H};this.isLoaded=function(){return C};this.addDOMEvent=function(a,b,d){try{return a.addEventListener?
a.addEventListener(b,d,!1):a.attachEvent?a.attachEvent(b,d):eval("elm."+b+"\x3dfunc;"),0}catch(c){return-1}};this.removeDOMEvent=function(a,b,d){try{return a.removeEventListener?a.removeEventListener(b,d,!1):a.detachEvent&&a.detachEvent(b,d),0}catch(c){return-1}};this.hideAndShow=function(a,b,d,c){try{if((WT.hasVal(a)||"shift"==b||w)&&WT.hasVal(b)&&WT.hasVal(d)){e.Debug.debug("hideAndShow:  "+(w?"tag 'inHead'":"tag 'not inHead'")+", "+(d?"showing":"hiding")+" '"+(a&&a.nodeName?a.nodeName:"unnamed elem")+
"' with type '"+b+"'");var f=function(a){d?WT.removeStyleSheet("wt_StyleSheet"):WT.applyStyleSheet(a,"wt_StyleSheet")};if("display"==b)w?f("body{ display: none !important}"):(a.style.display=d?"":"none",a==g.body||d||(g.body.style.display=""));else if("visibility"==b)w?f("body{ visibility: hidden !important}"):(a.style.visibility=d?"visible":"hidden",a.style.hidden=!d,a==g.body||d||(g.body.style.visibility="visible",g.body.style.hidden=!1));else if("shift"==b||"supershift"==b)if(!d){var k=g.getElementsByTagName("head")[0];
style=g.createElement("style");style.type="text/css";style.id="wt_shiftStyle";style.styleSheet?style.styleSheet.cssText="body{position:absolute !important; left: -1000% !important; visibility: hidden}":style.appendChild(g.createTextNode("body{position:absolute !important; left: -1000% !important;}"));k.appendChild(style)}else{if(d){var h=g.getElementById("wt_shiftStyle");h&&h.parentNode.removeChild(h)}}else if("overlay"==b){var m=g.getElementById("wt_overlay"),n=g.getElementById("wt_overlayStyle"),
r=e.hasVal(c)?c:"#ffffff";if(d&&m)m.parentNode.removeChild(m),n&&n.parentNode.removeChild(n);else if(!d&&!m){w&&e.Debug.error("hideAndShow:  Warning! wt tag detected in head, overlay mode may error out or cause flickering","007");if(!n){var p=g.createElement("style");p.setAttribute("type","text/css");p.setAttribute("id","wt_overlayStyle");f="#wt_overlay{position:absolute;width:100%;height:100%;top:0px;right:0px;bottom:0px;left:0px;background-color:"+r+";z-index:2147483646}";p.styleSheet?p.styleSheet.cssText=
f:p.appendChild(g.createTextNode(f));g.getElementsByTagName("head")[0].appendChild(p)}e.hasVal(c)?m=g.createElement("div"):(m=g.createElement("iframe"),m.frameBorder=0);m.id="wt_overlay";g.getElementsByTagName("body")[0].appendChild(m)}}else"none"==b?e.Debug.trace("LOADER: type: none"):e.Debug.debug("hideAndShow did not contain a matching type, so not hiding/showing");c={};c.displayType=b;c.display=d;WT.fireEvent(new WTEvent(WTEvent.HIDESHOW,WTEvent.STATUS_SUCCESS,a,c))}else e.Debug.error("hideAndShow param list incomplete",
"006")}catch(t){WT.Debug.error("Failure in hide/show functionality.  Verify valid HTML syntax","008",t)}};var N=function(){try{if(document.addEventListener&&("complete"!==document.readyState&&"undefined"!==typeof document.readyState||u(),document.addEventListener("DOMContentLoaded",function(){document.removeEventListener("DOMContentLoaded",arguments.callee,!1);u()},!1),/WebKit|Opera/i.test(navigator.userAgent)))var a=setInterval(function(){/loaded|complete/.test(document.readyState)&&(clearInterval(a),
u())},10);document.attachEvent&&("complete"!==document.readyState&&"loading"!==document.readyState||u(),document.attachEvent("onreadystatechange",function(){if("complete"===document.readyState||"loading"===document.readyState)document.detachEvent("onreadystatechange",arguments.callee),u()}));window.addEventListener?window.addEventListener("load",function(){window.removeEventListener("load",arguments.callee,!1);u()},!1):window.attachEvent&&window.attachEvent("onload",function(){window.detachEvent("onload",
arguments.callee,!1);u()});C?D():window.addEventListener?window.addEventListener("load",function(){window.removeEventListener("load",arguments.callee,!1);D()},!1):window.attachEvent&&window.attachEvent("onload",function(){window.detachEvent("onload",arguments.callee,!1);D()})}catch(b){u(),D()}};e.Debug=new e._Debug;w=function(){try{var a=g.getElementsByTagName("script");return"HEAD"==a[a.length-1].parentNode.nodeName?!0:!1}catch(b){return WT.Debug.error("inHead: Failed to detect if in head, assuming inHead",
"001",b),!0}}();e.isBodyExtant();var z=this.parseQueryString(h);h=function(a,b){e.hasVal(z[a])&&e.hasVal(b)&&b(z[a])};e.hasVal(z)&&(h("_wt.accountRoot",function(a){accountRoot=a}),h("_wt.s_jsonUrl",function(a){}),h("_wt.debug",function(a){e.Debug.setDebugLevel(a.length)}));var I=function(a){var b={};a=a.split(";");for(var d in a)if(a.hasOwnProperty(d)){var c=a[d].split(":");b[c[0]]=c[1]}return b},r=function(){if(null!==z&&z["_wt.context"])return I(z["_wt.context"]);var a;a:{a=document.cookie.split(";");
for(var b=0;b<a.length;b++){var c=[];c[0]=a[b].substring(0,a[b].indexOf("\x3d"));for(c[1]=a[b].substring(a[b].indexOf("\x3d")+1);" "===c[0].charAt(0);)c[0]=c[0].substring(1,c[0].length);if("_wt.context"==c[0]){a=c[1];break a}}a=null}if("undefined"!==typeof a&&null!==a)return I(a);a:{a=document.getElementsByTagName("meta");for(b=0;b<a.length;b++)if("_wt.context"==a[b].name){a=a[b].content;break a}a=null}if("undefined"!=typeof a&&null!==a)return I(a)}();if("undefined"!==typeof r){e.Debug.info("LOADER:  Found one or more context(s)");
for(var J in r)r.hasOwnProperty(J)&&e.Debug.trace("LOADER:  triggers have set contextTriggerMap '"+J+"':'"+r[J]+"'")}var x=function(a){e.Debug.error("Loader Error: "+a,"016")};e.Debug.info("LOADER:  Version "+[v.major,v.minor,v.inc].join("."));this.addEventHandler(WTEvent.PREINIT,function(){try{for(var a in c)c.hasOwnProperty(a)&&WT.hasVal(c[a].plugin)&&WT.hasVal(c[a].plugin[WTEvent.PREINIT])&&E(a)&&WT.getExecuteState(a)!==WTEvent.LOADER_MODULE_ABORT&&(e.Debug.debug("LOADER:  product '"+a+"' with context name '"+
c[a].contextName+"' _preinit phase start"),c[a].plugin[WTEvent.PREINIT](),e.Debug.debug("LOADER:  product '"+a+"' with context name '"+c[a].contextName+"' _preinit phase complete"))}catch(b){WT.abortModuleHelper(a,b)}},function(){x("preinit fail")});this.addEventHandler(WTEvent.INIT,function(){try{for(var a in c)c.hasOwnProperty(a)&&WT.hasVal(c[a].plugin)&&WT.hasVal(c[a].plugin[WTEvent.INIT])&&E(a)&&WT.getExecuteState(a)!==WTEvent.LOADER_MODULE_ABORT&&(e.Debug.debug("LOADER:  product '"+a+"' with context name '"+
c[a].contextName+"' _init phase start"),c[a].plugin[WTEvent.INIT](),e.Debug.debug("LOADER:  product '"+a+"' with context name '"+c[a].contextName+"' _init phase complete"))}catch(b){WT.abortModuleHelper(a,b)}},function(){x("init fail")});this.addEventHandler(WTEvent.PRELOAD,function(){try{for(var a in c)c.hasOwnProperty(a)&&WT.hasVal(c[a].plugin)&&WT.hasVal(c[a].plugin[WTEvent.PRELOAD])&&WT.hasVal(c[a].plugin.wtConfigObj)&&!0===c[a].plugin.wtConfigObj.doLoad&&E(a)&&WT.getExecuteState(a)!==WTEvent.LOADER_MODULE_ABORT&&
(e.Debug.debug("LOADER:  product '"+a+"' with context name '"+c[a].contextName+"' _preload phase start"),c[a].plugin[WTEvent.PRELOAD](),e.Debug.debug("LOADER:  product '"+a+"' with context name '"+c[a].contextName+"' _preload phase complete"))}catch(b){WT.abortModuleHelper(a,b)}},function(){x("preload fail")});this.addEventHandler(WTEvent.LOAD,function(){try{for(var a in c)c.hasOwnProperty(a)&&WT.hasVal(c[a].plugin)&&WT.hasVal(c[a].plugin[WTEvent.LOAD])&&WT.hasVal(c[a].plugin.wtConfigObj)&&!0===c[a].plugin.wtConfigObj.doLoad&&
E(a)&&WT.getExecuteState(a)!==WTEvent.LOADER_MODULE_ABORT&&(e.Debug.debug("LOADER:  product '"+a+"' with context name '"+c[a].contextName+"' _load phase start"),c[a].plugin[WTEvent.LOAD](function(a){return function(){WT.setExecuteState(a,p.READY)}}(a)),e.Debug.debug("LOADER:  product '"+a+"' with context name '"+c[a].contextName+"' _load phase complete"))}catch(b){WT.abortModuleHelper(a,b)}},function(){x("load fail")});this.addEventHandler(WTEvent.LOADER_CLICK,function(a){for(var b in c)c.hasOwnProperty(b)&&
e.fireEvent(new WTEvent(b+"_"+WTEvent.LOADER_CLICK,WTEvent.STATUS_SUCCESS,null,a.params))},function(){x("click fail")});this.addEventHandler(WTEvent.LOADER_EXECUTE,function(a){for(var b in c)c.hasOwnProperty(b)&&e.fireEvent(new WTEvent(b+"_"+WTEvent.LOADER_EXECUTE,WTEvent.STATUS_SUCCESS,null,a.params))},function(){x("execute fail")});this.addEventHandler(WTEvent.LOADER_ABORT,function(){A=!0;e.Debug.error("Loader global abort event","017");try{for(var a in c)c.hasOwnProperty(a)&&WT.hasVal(c[a].plugin)&&
!0===c[a].plugin.wtConfigObj.doLoad&&(WT.fireEvent(new WTEvent(a+"_"+WTEvent.LOADER_MODULE_ABORT,WTEvent.STATUS_SUCCESS),!1,!0),WT.setExecuteState(a,WTEvent.LOADER_MODULE_ABORT),WT.clearTimer(a),WT.Debug.error("Aborting product: "+a,"018"))}catch(b){WT.abortModuleHelper(a,b)}},function(){x("abort fail")});this.start=function(){try{N();var a=function(){e.fireEvent(new WTEvent(WTEvent.PREINIT,WTEvent.STATUS_SUCCESS));e.fireEvent(new WTEvent(WTEvent.INIT,WTEvent.STATUS_SUCCESS));e.fireEvent(new WTEvent(WTEvent.PRELOAD,
WTEvent.STATUS_SUCCESS));e.fireEvent(new WTEvent(WTEvent.LOAD,WTEvent.STATUS_SUCCESS));e.Debug.debug("LOADER:  Synchronous functionality has finished firing")};if(WT.hasVal(r)){e.Debug.debug("LOADER:  contextTriggerMap contains contexts");var b=[],c;for(c in r)if(r.hasOwnProperty(c)){var g=e.getContextUrl(c,r[c]);"undefined"!==typeof g&&(e.Debug.debug("LOADER:  adding "+g+" to download"),b.push(g))}e.downloadLibs("head",a,0,!0,b)}else a()}catch(f){e.fireEvent(new WTEvent(WTEvent.LOADER_ABORT,WTEvent.STATUS_SUCCESS))}};
e.Debug.debug("WT object created","LOADER");e.Debug.info("To clear Optimize cookies use: 'WT.Debug.clearCookies()'");e.Debug.info("To dump config params use: 'WT.Debug.dumpParams()'");e.Debug.info("To check the mode use: 'WT.Debug.checkMode(false)' - Use true if you wish to reset the mode.")}"undefined"==typeof WT&&(WT=new m(window,window.document,window.navigator,window.location))})(window,window.document,window.navigator,window.location);WT.sizzleModule=function(){};
WT.sizzleModule.prototype.wtConfigObj={libUrl:"//c.webtrends.com/acs/common/js/lib/sizzle.min.js",doLoad:!0,s_dependencies:""};
WT.sizzleModule.prototype.load=function(h){try{WT.updateDependencies("sizzle",this.wtConfigObj.s_dependencies),"undefined"!=typeof Sizzle&&WT.hasVal(Sizzle)||!WT.isDependency("sizzle")?h():WT.downloadLib("head",h,function(){WT.fireEvent(new WTEvent("sizzle"+WTEvent.LOADER_MODULE_ABORT,WTEvent.STATUS_SUCCESS))},0,!0,this.wtConfigObj.libUrl)}catch(n){WT.abortModuleHelper("optimize",n)}};WT.sizzleModule.prototype.postload=function(){WT.setExecuteState("sizzle","running")};
WT.sizzleModule.ProductName="sizzle";WT.registerPlugin(WT.sizzleModule,"default");WT.jsonModule=function(){};WT.jsonModule.prototype.wtConfigObj={libUrl:"//c.webtrends.com/acs/common/js/lib/json2.js",doLoad:!0};
WT.jsonModule.prototype.load=function(h){try{WT.updateDependencies("json",this.wtConfigObj.s_dependencies),"undefined"===typeof JSON&&WT.isDependency("json")?(WT.Debug.debug("JSON not detected"),s_jsonLoaded=!1,WT.downloadLib("head",h,function(){WT.fireEvent(new WTEvent("json"+WTEvent.LOADER_MODULE_ABORT,WTEvent.STATUS_SUCCESS))},0,!0,this.wtConfigObj.libUrl)):(s_jsonLoaded=!0,h())}catch(n){WT.abortModuleHelper("optimize",n)}};
WT.jsonModule.prototype.postload=function(){WT.setExecuteState("json","running")};WT.jsonModule.ProductName="json";WT.registerPlugin(WT.jsonModule,"default");WT.optimizeModule=function(){};
WT.optimizeModule.prototype.wtConfigObj={alwaysLoad:!0,s_keyToken:"fba384e7667655566b524ce312fb802d95cd01223024",doLoad:!1,s_loaderHide:!0,s_pageTimeout:8E3,s_dependencies:"sizzle:ready,json:ready",domId:"body",s_pageDisplayMode:"visibility",defaultCollectionServer:"scs.webtrends.com",s_domainKey:1368263,libUrl:"//c.webtrends.com/acs/common/product/optimize/js/4.1/optimize.js",accountGuid:"mx643kesn3",s_otsServer:"ots.optimize.webtrends.com",s_pageMode:"dom"};
WT.optimizeModule.prototype.preinit=function(){try{WT.Debug.debug("PREINIT: Executing Preinit script"),WT.sizzleModule.prototype.wtConfigObj.libUrl="//c.webtrends.com/acs/common/js/custom/sizzle/sizzle_1.min.js"}catch(h){WT.abortModuleHelper("optimize",h)}};WT.optimizeModule.prototype.init=function(){try{this.wtConfigObj.doLoad=this.wtConfigObj.doLoad||this.wtConfigObj.alwaysLoad}catch(h){WT.abortModuleHelper("optimize",h)}};
WT.optimizeModule.prototype.preload=function(){try{var h=0;WT.optimizeModule.prototype.wtConfigObj.s_conversionTimeout&&(h=WT.optimizeModule.prototype.wtConfigObj.s_conversionTimeout);WT.setLoaderConversionTimeoutDefault(Math.max(h,WT.loaderConversionTimeoutDefault()));WT.Debug.debug("PRELOAD:  Executing preload script");WT.updateDependencies("optimize",this.wtConfigObj.s_dependencies);if(WT.isBodyExtant()||"shift"===this.wtConfigObj.s_pageDisplayMode||WT.inHead()){var n=document.getElementsByTagName("body")[0];
WT.hideAndShow(n,this.wtConfigObj.s_pageDisplayMode,!1,this.wtConfigObj.overlayColor)}else{WT.Debug.debug("LOADER:  body element not found, hide via polling");var t=this.wtConfigObj.s_pageDisplayMode,A=this.wtConfigObj.overlayColor,m=this.wtConfigObj.s_pageTimeout;WT.pollForCondition(WT.isBodyExtant,function(){var g=document.getElementsByTagName("body")[0];!WT.hasVal(WT.optimize)||WT.hasVal(WT.optimize)&&!0!==WT.optimize.g_done?(WT.Debug.info("LOADER:  Optimize not done so hiding"),WT.hideAndShow(g,
t,!1,A)):WT.Debug.info("LOADER:  Optimize done flag so not hiding");WT.startTimer("optimize",m)})}}catch(y){WT.abortModuleHelper("optimize",y)}};WT.optimizeModule.prototype.load=function(h){try{WT.Debug.debug("LOAD:  Executing load phase"),WT.downloadLib("head",h,function(){WT.fireEvent(new WTEvent("optimize_"+WTEvent.LOADER_MODULE_ABORT,WTEvent.STATUS_SUCCESS))},0,!0,this.wtConfigObj.libUrl)}catch(n){WT.abortModuleHelper("optimize",n)}};
WT.optimizeModule.prototype.postload=function(){WT.Debug.debug("POSTLOAD:  Executing postload optimize complete");try{WT.Debug.info("LOADER:  WT.optimizeModule.prototype: postload");WT.fireEvent(new WTEvent("optimize_"+WTEvent.POSTLOAD,WTEvent.STATUS_SUCCESS));WTEvent.OPTIMIZE_LIB_LOAD="optimize_library_load";if("undefined"!=typeof WT.optimize&&"running"!=WT.getExecuteState("optimize"))WT.setExecuteState("optimize","running"),WT.Debug.info("LOADER:  Optimize dependencies complete, running setup call"),
WT.optimize.setup(WT.optimizeModule.prototype.wtConfigObj);else if("running"!=WT.getExecuteState("optimize")){WT.Debug.info("LOADER:  Optimize dependencies complete, but optimize object not ready, adding eventHandler");var h=function(){"running"!=WT.getExecuteState("optimize")&&(WT.setExecuteState("optimize","running"),WT.Debug.info("LOADER:  running setup call"),WT.optimize.setup(WT.optimizeModule.prototype.wtConfigObj),WT.removeEventHandler(WTEvent.OPTIMIZE_LIB_LOAD,h))};WT.addEventHandler(WTEvent.OPTIMIZE_LIB_LOAD,
h)}eval(function(h,n,m,y,g,K){g=function(h){return(h<n?"":g(parseInt(h/n)))+(35<(h%=n)?String.fromCharCode(h+29):h.toString(36))};if(!"".replace(/^/,String)){for(;m--;)K[g(m)]=y[m]||g(m);y=[function(g){return K[g]}];g=function(){return"\\w+"};m=1}for(;m--;)y[m]&&(h=h.replace(RegExp("\\b"+g(m)+"\\b","g"),y[m]));return h}("5 H\x3dB;6 Z(){5 v\x3d1g;6 1g(){9(4){14(5 1f 1b 4){9(V h!\x3d'3'){h.z(\"u w - M: \"+1f+\" 1J: \"+4[1f].c)}}}9(V h!\x3d'3')h.z('u w - 1g: 1N');5 L\x3d[],W\x3d[],X\x3d[],16\x3d[],12\x3d[],T\x3d[];5 b\x3d{};14(5 p 1b 4){9(~4[p].c.1K(\"1h\")){1M}L.G(4[p].d);W.G(4[p].s);X.G(4[p].x);T.G(4[p].c);12.G(4[p].t);16.G(4[p].i);9(V h!\x3d'3'){h.z(\"u w - M: \"+4[p].d+\"    s: \"+4[p].s);h.z(\"u w - M: \"+4[p].d+\"    x: \"+4[p].x);h.z(\"u w - M: \"+4[p].d+\"    c: \"+4[p].c);h.z(\"u w - M: \"+4[p].d+\"    t: \"+4[p].t);h.z(\"u w - M: \"+4[p].d+\"    i: \"+4[p].i)}}9(L.1B\x3e0)E.1w\x26\x261w(\"1L.1O\",\"11\",\"8.13\",\"1t\",\"8.15\",L.l(';'),\"8.10\",W.l(';'),\"8.Y\",X.l(';'),\"8.19\",T.l(';'));9(L.1B\x3e0){b[\"8.15\"]\x3d{n:\"8.15\",o:L.l(';'),k:a};b[\"8.10\"]\x3d{n:\"8.10\",o:W.l(';'),k:a};b[\"8.Y\"]\x3d{n:\"8.Y\",o:X.l(';'),k:a};b[\"8.19\"]\x3d{n:\"8.19\",o:T.l(';'),k:a};b[\"8.1p\"]\x3d{n:\"8.1p\",o:16.l(';'),k:a};b[\"8.1r\"]\x3d{n:\"8.1r\",o:12.l(';'),k:a};b[\"8.13\"]\x3d{n:\"8.13\",o:\"1t\",k:a};14(5 m 1b b){b[m].k\x3d1u.1U('b');b[m].k.n\x3db[m].n;b[m].k.o\x3db[m].o;1u.2g('29')[0].2f(b[m].k)}}}5 D\x3d18();5 4\x3d{};5 1i\x3dB;5 1e\x3d0;5 1a\x3d0;5 1z\x3d2a;5 f\x3da;5 N\x3da;5 K\x3d6(1s){A 1s};9(!H)H\x3dO('1A');9(H\x3d\x3d-1)A;9(!D){1C(6(){Z()},28);A}F(H);6 18(){A E.27||(E.Q\x26\x26E.Q.25)||a}6 j(1v,1G,1H){5 D\x3d18();5 1o\x3d(D\x26\x26D.j)||(E.Q\x26\x26Q.j);1o.2b(D||E.Q,[1v,1G,1H])}6 q(U){A U.17\x26\x26U.17.1E\x26\x26U.17.1E()||{}}6 O(C){A 1C(6(){9(V h!\x3d'3')h.2c('u w - 2e 2d 2h 26');9(C\x3d\x3d\x3d'1d'){5 e\x3dS K({d:'3',R:'3',s:'3',x:'3',i:'3',c:'23',t:'3',P:'3',I:'1P',J:B,r:a});4[C]\x3de}1F 9(C\x3d\x3d\x3d'1A'){5 e\x3dS K({d:'3',R:'3',s:'3',x:'3',i:'3',c:'24',t:'3',P:'3',I:'1V',J:B,r:a});H\x3d-1;4[C]\x3de}1F{4[C].c\x3d'1T'}9(N!\x3da)4[C].c\x3dN;v()},1z)}j(y.1y,6(7){5 2\x3dq(7);9(f\x3e0)F(f);f\x3d0;5 e\x3dS K({d:2['g']||'3',R:2['1c']||'3',s:2['1j']||'3',x:2['1k']||2['1n']||'3',i:2['i']||'3',c:2['1S']||'3',t:2['1l']||'3',P:2['1m']||'3',I:'1y',J:B,r:a});4[e.d]\x3de;1e++;4[e.d].r\x3dO(e.d)});j(y.1Q,6(7){9(1i){A}1i\x3d1x},6(7){});j(y.1D,6(7){5 2\x3dq(7);4[2.g].J\x3d1x;4[2.g].I\x3d\"1D\";F(4[2.g].r);1a++;F(4[2.g].r);9(1a\x3d\x3d\x3d1e){v()}},6(7){5 2\x3dq(7);4[2.g].c\x3d'1R';v()});j(y.1W,6(7){5 2\x3dq(7);4[2.g].c\x3d'1I';v()},6(7){5 2\x3dq(7);4[2.g].c\x3d'1I';v()});j(y.1X,6(7){N\x3d\"1h\"},6(7){N\x3d\"1h\"});j(y.22,6(7){9(f\x3d\x3da)f\x3dO('1d')},6(7){9(f\x3d\x3da)f\x3dO('1d')});j(y.21,6(7){},6(7){5 2\x3dq(7);5 e\x3dS K({d:2['g']||'3',R:2['1c']||'3',s:2['1j']||'3',x:2['1k']||2['1n']||'3',i:2['i']||'3',c:'20',t:2['1l']||'3',P:2['1m']||'3',I:'1Y',J:B,r:a});F(f);f\x3d-1;4[2.g]\x3de;v()});j(y.1Z,6(7){},6(7){5 2\x3dq(7);5 e\x3dS K({d:2['g']||'3',R:2['1c']||'3',s:2['1j']||'3',x:2['1k']||2['1n']||'3',i:2['i']||'3',c:'1q',t:2['1l']||'3',P:2['1m']||'3',I:'1q',J:B,r:a});4[2.g]\x3de;F(f);f\x3d-1;v()})}Z();",
62,142,"  targetParams undefined oProjects var function event ms if null meta runState projectAlias oProject masterFallBackTimer testAlias console testGroup addEventHandler ele join  name content  getProjectParams r_timer testID testType Optimize trackOptimizeCallback Tracking expID WTEvent info return false proj WTO window clearTimeout push trackOptimizeTestsNoTestTimer currentState pageviewTracked CLASS_PROJECT names Project masterState getDelayedTrackTimer testMode WT projectID new states oEvent typeof tests exps opt_eid trackOptimizeTests opt_tid  type expe for opt_pnm group target getWTO opt_sta iPageviewsTracked in r_testID masterFallbackTimer iProjectsCount sProjectAlias trackMS INVALID_TEST_ERROR isDone r_runID r_experimentID r_type s_mode r_personalizedID func_addEventHandler opt_grp UNKNOWN_ERROR opt_typ params wto document sEventName MscomCustomEvent true RENDER iTimeout noProjectFallbackTimer length setTimeout PAGEVIEW getParams else fHandlerSuccess fHandlerFault TIMER_EXPIRE_ERROR State indexOf wcs continue START cot MASTERFALLBACK DONE PAGEVIEW_ERROR r_runState PAGEVIEW_TIMEOUT_ERROR createElement NO_PROJECT TIMER_EXPIRE INVALID ABORT_ERROR STATUS_UNKNOWN TEST_ABORT_ERROR ABORT CONTROL_RESPONSE MASTERFALLBACK_TIMER_ERROR NO_PROJECT_ERROR optimize timeout WTOptimize 50 head 10000 apply warn tracking Initiating appendChild getElementsByTagName after".split(" "),
0,{}))}catch(n){WT.abortModuleHelper("optimize",n)}};
WT.optimizeModule.prototype.abort=function(){try{WT.Debug.debug("ABORT:  Executing optimizeModule abort");WT.Debug.error("WT.optimizeModule.prototype: abort",145,null,"LOADER");var h=WT.optimizeModule.prototype.wtConfigObj.s_pageDisplayMode;(WT.isBodyExtant()||"shift"===h||WT.inHead())&&WT.optimizeModule.prototype.wtConfigObj.s_loaderHide&&(WT.Debug.error("Optimize abort, so unhiding body ... ",146,null,"LOADER"),WT.hideAndShow(document.getElementsByTagName("body")[0],h,!0,WT.optimizeModule.prototype.wtConfigObj.overlayColor));
WT.setExecuteState("optimize",WTEvent.LOADER_MODULE_ABORT);WT.clearTimer(WT.optimizeModule.ProductName);WT.hasVal(WT.optimize)&&WT.hasVal(WT.optimize.g_Aborted)&&!1===WT.optimize.g_Aborted&&WT.fireEvent(new WTEvent(WTEvent.ABORT,WTEvent.STATUS_FAULT))}catch(n){WT.abortModuleHelper("optimize",n)}};WT.optimizeModule.ProductName="optimize";WT.registerPlugin(WT.optimizeModule,"Base41_WEDCS");WT.start();