/************************************************************************************
Simple reusable DHTML library made by Thomas Brattli from www.bratta.com
Please keep this notice in the code if you use it. Thanks.
bratta-dhtml-lib ver 1
************************************************************************************/
function lib_bwcheck(){
	this.ver=navigator.appVersion; this.agent=navigator.userAgent
	this.dom=document.getElementById?1:0
	this.ie5=(this.ver.indexOf("MSIE 5")>-1 && this.dom)?1:0;
	this.ie6=(this.ver.indexOf("MSIE 6")>-1 && this.dom)?1:0;
	this.ie4=(document.all && !this.dom)?1:0; this.ie=this.ie4||this.ie5||this.ie6
	this.mac=this.agent.indexOf("Mac")>-1; this.opera=this.agent.indexOf("Opera")>-1
	this.opera5=this.agent.indexOf("Opera 5")>-1; 
	this.ns6=(this.dom && parseInt(this.ver) >= 5) ?1:0; this.ns4=(document.layers && !this.dom)?1:0;
	this.bw=(this.ie6 || this.ie5 || this.ie4 || this.ns4 || this.ns6 || this.opera4)
	return this
}
var bw=new lib_bwcheck(); if(!bw.bw) location.href='sorry.html'
function lib_doc_size(){
	this.x=0;this.x2=bw.ie && document.body.offsetWidth-20||innerWidth||0;
	this.y=0;this.y2=bw.ie && document.body.offsetHeight-5||innerHeight-12||0;
	if(bw.ns6) this.x2-=15
	if(!this.x2||!this.y2) return message('Document has no width or height') 
	this.x50=this.x2/2;this.y50=this.y2/2;
	this.x10=(this.x2*10)/100;this.y10=(this.y2*10)/100
	this.ytop=140*100/this.y2
	this.avail=(this.y2*(100-this.ytop))/100
	this.origy=this.y2
	return this;
}
function lib_message(txt){alert(txt); return false}
function lib_moveIt(x,y){this.x=x;this.y=y; this.css.left=x;this.css.top=y}
function lib_moveBy(x,y){this.moveIt(this.x+x,this.y+y)}
function lib_showIt(){this.css.visibility="visible"}
function lib_hideIt(){this.css.visibility="hidden"}
function lib_bg(color){
	if(bw.opera) this.css.background=color
	else if(bw.dom || bw.ie4) this.css.backgroundColor=color
	else if(bw.ns4) this.css.bgColor=color  
}
function lib_writeIt(text,startHTML,endHTML){
	if(bw.ns4){if(!startHTML){startHTML=""; endHTML=""}
	this.ref.open("text/html"); this.ref.write(startHTML+text+endHTML); this.ref.close()
	}else this.evnt.innerHTML=text
}
function lib_clipTo(t,r,b,l,setwidth){ 
	this.ct=t; this.cr=r; this.cb=b; this.cl=l
	if(bw.ns4){this.css.clip.top=t;this.css.clip.right=r; this.css.clip.bottom=b;this.css.clip.left=l
	}else{
		if(t<0)t=0;if(r<0)r=0;if(b<0)b=0;if(b<0)b=0
		this.css.clip="rect("+t+","+r+","+b+","+l+")";
		if(setwidth){
			if(bw.opera){this.css.pixelWidth=r; this.css.pixelHeight=b}
			else{this.css.width=r; this.css.height=b}; this.w=r; this.h=b
		}
	}
}
function lib_clipBy(t,r,b,l,setwidth){this.clipTo(this.ct+t,this.cr+r,this.cb+b,this.cl+l,setwidth)}
function b_clipIt(tstop,rstop,bstop,lstop,step,fn,wh,www){
if(!fn) fn=null; if(!wh) wh=null; var clipval=new Array()
if(bw.dom || bw.ie4) {clipval=this.css.clip; clipval=clipval.slice(5,clipval.length-1);
clipval=clipval.split(' '); for(var i=0;i<4;i++){clipval[i]=parseInt(clipval[i])}
}else{clipval[0]=this.css.clip.top; clipval[1]=this.css.clip.right
clipval[2]=this.css.clip.bottom; clipval[3]=this.css.clip.left}
totantstep=Math.max(Math.max(Math.abs((tstop-clipval[0])/step),Math.abs((rstop-clipval[1])/step)),
Math.max(Math.abs((bstop-clipval[2])/step),Math.abs((lstop-clipval[3])/step)))
if(!this.clipactive)this.clip(clipval[0],clipval[1],clipval[2],clipval[3],(tstop-clipval[0])/totantstep,
(rstop-clipval[1])/totantstep,(bstop-clipval[2])/totantstep,
(lstop-clipval[3])/totantstep,totantstep,0, fn,wh,www)}
function b_clip(tcurr,rcurr,bcurr,lcurr,tperstep,rperstep,bperstep,lperstep,totantstep,antstep,fn,wh,www){
tcurr=tcurr+tperstep; rcurr=rcurr+rperstep; bcurr=bcurr+bperstep; lcurr=lcurr+lperstep
if(www)this.clipTo(tcurr,rcurr,bcurr,lcurr,1);
else this.clipTo(tcurr,rcurr,bcurr,lcurr);
eval(wh); if(antstep<totantstep){this.clipactive=true;	antstep++
setTimeout(this.obj+".clip("+tcurr+","+rcurr+","+bcurr+","+lcurr+","+tperstep+","
+rperstep+","+bperstep+","+lperstep+","+totantstep+","+antstep+",'"+fn+"','"+wh+"','"+www+"')",50)	
}else{this.clipactive=false; eval(fn)}}
function lib_slideIt(endx,endy,inc,speed,fn,wh) {
if (!this.slideactive) {var distx = endx - this.x;var disty = endy - this.y
var num = Math.sqrt(Math.pow(distx,2) + Math.pow(disty,2))/inc
var dx = distx/num;var dy = disty/num
this.slideactive = 1; this.slide(dx,dy,endx,endy,speed,fn,wh)}}
function lib_slide(dx,dy,endx,endy,speed,fn,wh) {
if (!fn) fn = null; if(!wh) wh=null
if (this.slideactive && (Math.floor(Math.abs(dx))<Math.floor(Math.abs(endx-this.x)) || Math.floor(Math.abs(dy))<Math.floor(Math.abs(endy-this.y)))) {
this.moveBy(dx,dy); eval(wh)
slidTim=setTimeout(this.obj+".slide("+dx+","+dy+","+endx+","+endy+","+speed+",'"+fn+"','"+wh+"')",speed)
}else{this.slideactive = 0;this.moveIt(endx,endy);eval(fn)}}
function lib_obj2(obj,nest,dnest,ddnest,num){
	this.num=num; if(!bw.bw) return lib_message('Old browser')
	if(!bw.ns4) this.evnt=bw.dom && document.getElementById(obj)||bw.ie4 && document.all[obj]
	else{
		if(ddnest){
		this.evnt=document[nest].document[dnest].document[ddnest].document[obj]?document[nest].document[dnest].document[ddnest].document[obj]:0;
		}else if(dnest){this.evnt=document[nest].document[dnest].document[obj]?document[nest].document[dnest].document[obj]:0;
		}else if(nest){this.evnt=document[nest].document[obj]?document[nest].document[obj]:0;
		}else{this.evnt=document.layers[obj]?document.layers[obj]:0;}	
	}
	if(!this.evnt) return lib_message('The layer does not exist ('+obj+') - Exiting script\n\nIf your using Netscape please check the nesting of your tags!')
	this.css=bw.dom||bw.ie4?this.evnt.style:this.evnt;  this.ref=bw.dom||bw.ie4?document:this.css.document;
	this.moveIt=lib_moveIt; this.moveBy=lib_moveBy; this.showIt=lib_showIt; this.hideIt=lib_hideIt;
	this.writeIt=lib_writeIt; this.bg=lib_bg; this.clipTo=lib_clipTo; this.clipBy=lib_clipBy;
	this.slideIt=lib_slideIt; this.slide=lib_slide; this.obj = obj + "Object"; 	eval(this.obj + "=this")
	return this
}

//EX
function setMode(mode){
	l=location.href
	s=location.search
	l=l.replace(s,"")
	if(s.indexOf("?")>-1){
		if(s.indexOf("setMode")>-1){
			s=s.substr(0,s.indexOf("setMode"))
		}
		if(s.lastIndexOf("&")==s.length-1||s.indexOf("?")==s.length-1) se=""
		else if(s.length>1) se="&"
		else se="?"
	}else se="?"
	location.href=l+s+se+"setMode="+mode
}