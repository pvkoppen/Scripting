var ohMr=!0,$id,$ajax,ohOnReady,ohRelatedTopics,ohRelatedForums;OH=window.OH||{};$id=function(id){return typeof id=="string"?document.getElementById(id.replace(/^#/g,"")):id};$ajax=function(o){var xhr=null;if(window.ActiveXObject?xhr=new ActiveXObject("Microsoft.XMLHTTP"):window.XMLHttpRequest&&(xhr=new XMLHttpRequest),!xhr)return!1;var ajaxObject=o,url=ajaxObject.url||"",dataType=ajaxObject.dataType||"",success=ajaxObject.success||function(){},error=ajaxObject.error||function(){};xhr.onreadystatechange=function(){xhr.readyState==4&&(xhr.status==200?success(xhr.responseText):error(xhr.responseText))};xhr.open("GET",url,!0);xhr.send(null)};OH.RelatedTopics=function(loading,links,noResults,moreLink,linksToDisplay,topicId,delay){var c=this;c.loading="#"+loading;c.links="#"+links;c.noResults="#"+noResults;c.moreLink="#"+moreLink;c.linksToDisplay=linksToDisplay;c.topicId=topicId;c.delay=delay;c.li=" UL LI";c.cookie=new OH.Cookies};OH.RelatedTopics.prototype={load:function(){var c=this,searchUrl,loadAsync;$id(c.moreLink).onclick=function(e){for(var lis=$id(c.links).getElementsByTagName("li"),mlink,i=0;i<lis.length;i++)lis[i].style.display="list-item";mlink=$id(c.moreLink);mlink.style.display="none";mlink.parentNode.style.display="none";c.cookie.setItem(c.moreLink,!0)};searchUrl="relatedtopicsearch";searchUrl+=window.location.search!=""?window.location.search+"&":"?";searchUrl+="id="+c.topicId;loadAsync=function(){$ajax({url:searchUrl,dataType:"html",success:function(data){var lis,i,mlink;if($id(c.loading).style.display="none",data){$id(c.links).innerHTML+=data;var v=c.cookie.getItem(c.moreLink),b=typeof v!="undefined"?v:!1,lis=$id(c.links).getElementsByTagName("li");if(b||c.linksToDisplay>=lis.length)mlink=$id(c.moreLink),mlink.style.display="none",mlink.parentNode.style.display="none";else{for(lis=$id(c.links).getElementsByTagName("li"),i=c.linksToDisplay;i<lis.length;i++)lis[i].style.display="none";mlink=$id(c.moreLink);mlink.style.display="inline";mlink.parentNode.style.display="block"}$id(c.links).style.display="block";$id(c.noResults).style.display="none"}else $id(c.noResults).style.display="block"},error:function(data){$id(c.loading).style.display="none";$id(c.noResults).style.display="block"}})};$id(c.loading).style.display="block";window.setTimeout(loadAsync,c.delay)},unload:function(){var c=this;$id(c.moreLink).onclick=null}};OH.Cookies=function(){var c,i,item;if(this.list=[],c=document.cookie.split(";"),c.length>0)for(i=0;i<c.length;i++)item=c[i].split("="),item.length==2&&(this.list[item[0].replace(" ","")]=item[1])};OH.Cookies.prototype={setItem:function(key,value,expireDate){this.list[key]=value;var item=key+"="+value+";";expireDate&&(item+="expires="+expireDate.toUTCString()+";");item+="path=/";document.cookie=item},getItem:function(key){return this.list[key]}};OH.RelatedForums=function(loading,links,noResults,query,delay,numResults){var c=this;c.loading="#"+loading;c.links="#"+links;c.noResults="#"+noResults;c.query=query;c.delay=delay;c.resultsParam="";numResults&&numResults>0&&(c.resultsParam="&res="+numResults)};OH.RelatedForums.prototype={load:function(){var c=this,loadAsync=function(){$ajax({url:"relatedforumssearch?q="+c.query+c.resultsParam,dataType:"html",success:function(data){$id(c.loading).style.display="none";data?($id(c.links).innerHTML+=data,$id(c.links).style.display="block",$id(c.noResults).style.display="none"):$id(c.noResults).style.display="block"},error:function(data){$id(c.loading).style.display="none";$id(c.noResults).style.display="block"}})};$id(c.loading).style.display="block";window.setTimeout(loadAsync,c.delay)},unload:function(){}};ohOnReady=[];typeof ohMr!="undefined"&&ohMr&&(ohRelatedTopics=new OH.RelatedTopics("ohid_rtLoadingContainer","ohid_rtLinks","ohid_rtNoResults","ohid_rtMoreLink",ohRtLinksToDisplay,ohRtTopicId,ohRtLoadDelay),ohOnReady.push(ohRelatedTopics),ohRelatedForums=new OH.RelatedForums("ohid_relatedForumsLoadingContainer","ohid_relatedForumsLinks","ohid_relatedForumsNoResultsContainer",ohRfQuery,ohRfLoadDelay),ohOnReady.push(ohRelatedForums));typeof ohRfNumber!="undefined"&&ohRfNumber&&(ohRelatedForums=new OH.RelatedForums("ohid_relatedForumsLoadingContainer","ohid_ErrorAssistanceForumList","ohid_ErrorAssistanceNoForumPostsText",ohRfQuery,ohRfLoadDelay,ohRfNumber),ohOnReady.push(ohRelatedForums));$(document).ready(function(){for(var i=0;i<ohOnReady.length;i++)ohOnReady[i].load()});$(window).unload(function(){for(var i=0;i<ohOnReady.length;i++)ohOnReady[i].unload()});;
epx=window.epx||{};epx.library=window.epx.library||{};epx.library.navigationResizeModule=function(){function init(){epx.topic&&epx.topic.isPrintExperience()===!0||($leftNav=$("#leftNav"),$link=$("#NavigationResize"),$increase=$("#NavigationResize > img.cl_nav_resize_open"),$reset=$("#NavigationResize > img.cl_nav_resize_close"),$content=$("#content"),epx.utilities&&(position=epx.utilities.getCookie("TocPosition",position),normalizedPostion()),setPosition(),$link.keydown(function(e){checkForTPressed(e)}),$link.click(function(){resize()}),$("html").attr("dir")=="rtl"&&$("#toc-resizable-ew").addClass("rtl"),$leftNav.css("max-width",leftNavWidths[maxPosition]+"px"),$("#toc-resizable-ew").css("height",$("#content").height()+"px"),$(".toc-resizable-ew").mousedown(function(e){mouseDown(e)}))}function checkForTPressed(evt){if(evt=evt?evt:event?event:null,evt&&evt.keyCode===84){var target=evt.srcElement!=null?evt.srcElement:evt.target;if(target.tagName.toLowerCase()=="input"||target.tagName.toLowerCase()=="textarea"||evt.ctrlKey||evt.altKey)return;resize()}}function resize(){gotoLeftPredefinedPostion();position++;position>maxPosition&&(position=0,$content.css("width",$("#body").css("width")));setPosition()}function setPosition(width){width?($leftNav.css("width",width+"px"),position=width>=leftNavWidths[maxPosition]?maxPosition:width<=maxPosition?0:width):position<=maxPosition?$leftNav.css("width",leftNavWidths[position]+"px"):$leftNav.css("width",position+"px");epx.utilities&&epx.utilities.setCookie("TocPosition",position,365,"/",".microsoft.com",null);$("html").attr("dir")=="rtl"?($content.css("margin-right",$leftNav.css("width")),$.browser.msie?$link.css("left","-"+(parseInt($link.css("width").replace("px",""))+1)+"px"):$link.css("left","-"+$link.css("width")),applyRtlSrc($increase),applyRtlSrc($reset)):($content.css("margin-left",$leftNav.css("width")),$link.css("left",$leftNav.css("width")));$link.css("display","inline-block");$increase.css("display","none");$reset.css("display","none");$content.css("width","auto");window.setTimeout(epx.library.navigationResize.resizeComplete,0)}function applyRtlSrc($element){var src=$element.attr("src"),dotIndex;src.indexOf("_Rtl")==-1&&(dotIndex=src.lastIndexOf("."),$element.attr("src",src.substr(0,dotIndex)+"_Rtl."+src.substr(dotIndex+1,src.length-dotIndex-1)))}function resizeComplete(){$increase.css("display",position==maxPosition?"none":"");$reset.css("display",position!=maxPosition?"none":"")}function mouseMove(e){resizing&&(mouseDelayMet||(mouseDelayTimer=setTimeout(function(){mouseDelayMet=!0},MinMouseDelay)),epx.library.tocFixed&&epx.library.tocFixed.setPosition(),mouseDistanceMet(e)&&mouseDelayMet&&(prevPageX=e.pageX,prevPageY=e.pageY,$("html").attr("dir")=="rtl"?setPosition($leftNav.offset().left+$leftNav.width()-e.pageX):setPosition(e.pageX-$leftNav.offset().left)),e.preventDefault())}function selectStart(e){return!1}function mouseDown(e){$(document).one("mouseup",mouseUp);$(document).on("mousemove",mouseMove);$(document).on("selectstart",selectStart);prevPageX=e.pageX;prevPageY=e.pageY;resizing=!0;e.preventDefault()}function mouseUp(){resizing&&($(document).off("mousemove",mouseMove),$(document).off("selectstart",selectStart),resizing=!1,mouseDelayMet=!1)}function mouseDistanceMet(e){return Math.abs(prevPageX-e.pageX)>=MinMouseDist}function gotoLeftPredefinedPostion(){var currWidth,i;if(!(position<=maxPosition))for(currWidth=position,position=maxPosition,i=1;i<leftNavWidths.length;i++)if(currWidth<=leftNavWidths[i]){position=i-1;break}}function normalizedPostion(){position>=leftNavWidths[maxPosition]&&(position=maxPosition)}var position=1,resizing=!1,leftNavWidths=[0,280,380,480],maxPosition=leftNavWidths.length-1,prevPageX=0,prevPageY=0,mouseDelayMet=!1,mouseDelayTimer,MinMouseDist=15,MinMouseDelay=1,$leftNav,$link,$increase,$reset,$content;return{init:init,resize:resize,resizeComplete:resizeComplete,setPosition:setPosition}};epx.library.navigationResize=epx.library.navigationResizeModule();$(document).ready(function(){epx.library.navigationResize.init()});;
function positionFeedbackCounter(){var counter=document.getElementById("ratingCounter"),versionSelector,ratingCounterSeperator,h1,mainSec,title,i;if(counter){if(document.getElementById("TopicTitle")){counter.style.display="block";return}if(versionSelector=document.getElementById("curversion"),versionSelector){ratingCounterSeperator=document.getElementById("ratingCounterSeperator");ratingCounterSeperator&&(versionSelector.parentNode.appendChild(ratingCounterSeperator),ratingCounterSeperator.style.display="block");counter.style.margin="0px 0px 0px 13px";versionSelector.parentNode.appendChild(counter);counter.style.display="block";return}if(h1=document.getElementsByTagName("h1"),h1&&h1[0]){h1[0].parentNode.insertBefore(counter,h1[0].nextSibling);counter.style.display="block";return}if(document.getElementsByClassName){if(title=document.getElementsByClassName("title"),title&&title.length>0)for(i=0;i<title.length;i++)if(title[i].tagName.toLowerCase()==="span"){title[i].parentNode.insertBefore(counter,title[i].nextSibling);counter.style.display="block";return}}else if(mainSec=document.getElementById("mainSection"),mainSec!=undefined&&mainSec.length>0&&(title=mainSec.getElementsByTagName("span"),title!=undefined&title.length>0))for(i=0;i<title.length;i++)if(title[i].className.toLowerCase()==="title"){title[i].parentNode.insertBefore(counter,title[i].nextSibling);counter.style.display="block";return}counter.style.display="none"}}function toggleRateThisTopic(){var questions=document.getElementById("contentFeedbackQAContainer"),rateThis,prefix;questions||(document.getElementsByClassName?questions=document.getElementsByClassName("feedbackContainer"):document.querySelectorAll&&(questions=document.querySelectorAll(".feedbackContainer")),questions&&questions.length>0)||(rateThis=document.getElementById("rateThisTopic"),rateThis&&(rateThis.style.display="none"),prefix=document.getElementById("rateThisPrefix"),prefix&&(prefix.style.display="none"))}typeof MTPS!="undefined"&&MTPS&&typeof MTPS.Utility!="undefined"&&MTPS.Utility?MTPS.Utility.addOnloadEvent(function(){toggleRateThisTopic();positionFeedbackCounter()}):typeof jQuery!="undefined"&&jQuery&&$(document).ready(function(){toggleRateThisTopic();positionFeedbackCounter()});;