function lib_doc_size(){this.x=0;this.x2=bw.ie && document.body.offsetWidth-5||innerWidth||0;
this.y=0;this.y2=bw.ie && document.body.offsetHeight-5||innerHeight-12||0; if(bw.ns6) this.x2-=15; this.x50=this.x2/2;this.y50=this.y2/2;
this.x10=(this.x2*10)/100;this.y10=(this.y2*10)/100; this.ytop=140*100/this.y2; this.avail=(this.y2*(100-this.ytop))/100
this.origy=this.y2; return this;}; function lib_message(txt){alert(txt); return false}; function lib_moveIt(x,y){this.x=x;this.y=y; this.css.left=x;this.css.top=y}
function lib_moveBy(x,y){this.moveIt(this.x+x,this.y+y)}; function lib_showIt(){this.css.visibility="visible"}; 
function lib_hideIt(){this.css.visibility="hidden"}; function lib_bg(color){if(bw.op5) this.css.background=color; else if(bw.dom || bw.ie4) this.css.backgroundColor=color; 
else if(bw.ns4) this.css.bgColor=color}; function lib_writeIt(text,startHTML,endHTML){if(bw.ns4){if(!startHTML){startHTML=""; endHTML=""}; 
this.ref.open("text/html"); this.ref.write(startHTML+text+endHTML); this.ref.close()}else this.evnt.innerHTML=text}
function lib_clipTo(t,r,b,l,setwidth){this.cr=r; this.cb=b; if(bw.ns4){this.css.clip.top=t;this.css.clip.right=r; 
this.css.clip.bottom=b;this.css.clip.left=l; }else{if(t<0)t=0;if(r<0)r=0;if(b<0)b=0;if(b<0)b=0; 
this.css.clip="rect("+t+","+r+","+b+","+l+")"; if(setwidth){if(bw.op5){this.css.pixelWidth=r; this.css.pixelHeight=b} 
else{this.css.width=r; this.css.height=b}; this.w=r; this.h=b}}}
function lib_clipBy(t,r,b,l,setwidth){this.clipTo(this.ct+t,this.cr+r,this.cb+b,this.cl+l,setwidth)}
function b_clipIt(tstop,rstop,bstop,lstop,step,fn,wh,www){if(!fn) fn=null; if(!wh) wh=null; var clipval=new Array()
if(bw.dom || bw.ie4) {clipval=this.css.clip; clipval=clipval.slice(5,clipval.length-1);
clipval=clipval.split(' '); for(var i=0;i<4;i++){clipval[i]=parseInt(clipval[i])}
}else{clipval[0]=this.css.clip.top; clipval[1]=this.css.clip.right; clipval[2]=this.css.clip.bottom; clipval[3]=this.css.clip.left}
totantstep=Math.max(Math.max(Math.abs((tstop-clipval[0])/step),Math.abs((rstop-clipval[1])/step)),
Math.max(Math.abs((bstop-clipval[2])/step),Math.abs((lstop-clipval[3])/step)))
if(!this.clipactive)this.clip(clipval[0],clipval[1],clipval[2],clipval[3],(tstop-clipval[0])/totantstep,
(rstop-clipval[1])/totantstep,(bstop-clipval[2])/totantstep,(lstop-clipval[3])/totantstep,totantstep,0, fn,wh,www)}
function b_clip(tcurr,rcurr,bcurr,lcurr,tperstep,rperstep,bperstep,lperstep,totantstep,antstep,fn,wh,www){
tcurr=tcurr+tperstep; rcurr=rcurr+rperstep; bcurr=bcurr+bperstep; lcurr=lcurr+lperstep
if(www)this.clipTo(tcurr,rcurr,bcurr,lcurr,1); else this.clipTo(tcurr,rcurr,bcurr,lcurr); eval(wh); 
if(antstep<totantstep){this.clipactive=true;	antstep++; ;setTimeout(this.obj+".clip("+tcurr+","+rcurr+","+bcurr+","+lcurr+","
+tperstep+","+rperstep+","+bperstep+","+lperstep+","+totantstep+","+antstep+",'"+fn+"','"+wh+"','"+www+"')",50)	
}else{this.clipactive=false; eval(fn)}}; function lib_slideIt(endx,endy,inc,speed,fn,wh) {
if (!this.slideactive) {var distx = endx - this.x;var disty = endy - this.y
var num = Math.sqrt(Math.pow(distx,2) + Math.pow(disty,2))/inc; var dx = distx/num;var dy = disty/num
this.slideactive = 1; this.slide(dx,dy,endx,endy,speed,fn,wh)}}
function lib_slide(dx,dy,endx,endy,speed,fn,wh) {if (!fn) fn = null; if(!wh) wh=null; 
if (this.slideactive && (Math.floor(Math.abs(dx))<Math.floor(Math.abs(endx-this.x)) || 
Math.floor(Math.abs(dy))<Math.floor(Math.abs(endy-this.y)))) {this.moveBy(dx,dy); eval(wh)
slidTim=setTimeout(this.obj+".slide("+dx+","+dy+","+endx+","+endy+","+speed+",'"+fn+"','"+wh+"')",speed)
}else{this.slideactive = 0;this.moveIt(endx,endy);eval(fn)}}; var slidTim;
function lib_obj2(obj,nest,dnest,ddnest,num){
if(!bw.ns4) this.evnt=bw.dom && document.getElementById(obj)||bw.ie4 && document.all[obj]
else{; if(ddnest){this.evnt=document[nest].document[dnest].document[ddnest].document[obj]?document[nest].document[dnest].document[ddnest].document[obj]:0;
}else if(dnest){this.evnt=document[nest].document[dnest].document[obj]?document[nest].document[dnest].document[obj]:0;
}else if(nest){this.evnt=document[nest].document[obj]?document[nest].document[obj]:0;
}else{this.evnt=document.layers[obj]?document.layers[obj]:0;}}
if(!this.evnt) return lib_message('The layer does not exist ('+obj+') - Exiting script\n\nIf your using Netscape please check the nesting of your tags!')
this.css=bw.dom||bw.ie4?this.evnt.style:this.evnt;  this.ref=bw.dom||bw.ie4?document:this.css.document;
this.moveIt=lib_moveIt; this.moveBy=lib_moveBy; this.showIt=lib_showIt; this.hideIt=lib_hideIt;
this.writeIt=lib_writeIt; this.bg=lib_bg; this.clipTo=lib_clipTo; this.x=0; this.y=0; this.w=0; this.h=0; 
this.clipactive=0; this.slideactive=0; this.slideIt=lib_slideIt; this.slide=lib_slide; 
this.obj = obj + "Object"; 	eval(this.obj + "=this"); return this}

/*Window script - Copyrighted 2001 Thomas Brattli.*/
var oWin=new Object(); oWin.dragover=-1; oWin.clickedY=0; oWin.clickedX=0; oWin.resizeover=-1; oWin.zIndex=10; oWin.dragobj=-1; oWin.resizeobj=-1; oWin.zIndex=100
var isFront, winpage, wins, a
function winit(w,is,w1,h1,x1,y1){
  var ended=new Date()  
	wins=w; win_init(); winpage=lib_doc_size()
	for(var i=0;i<wins;i++)	create_window(i,0,0,1)
	oWin.currwins=i; if(is){isFront=1; setWindows()}
	else if(w1){ j=0
		for(i=2;i<arguments.length;i+=4){
			oWin[j].resize(arguments[i],arguments[i+1])
			oWin[j].origw=arguments[i]; oWin[0].origh=arguments[i+1]
			oWin[j].moveIt(eval(arguments[i+2]),arguments[i+3])
			oWin[j].checkscroll(); oWin[j].showIt(); j++
		}
	}
};function create_window(i){
	oWin[i]=new lib_obj2('divWin'+i,'','','',i)
	oWin[i].oWindow=new lib_obj2('divWindow'+i,'divWin'+i)
	oWin[i].oText=new lib_obj2('divWinText'+i,'divWin'+i,'divWindow'+i)
	oWin[i].oHead=new lib_obj2('divWinHead'+i,'divWin'+i)
	oWin[i].oButtons=new lib_obj2('divWinButtons'+i,'divWin'+i)
	oWin[i].oResize=new lib_obj2('divWinResize'+i,'divWin'+i)
	oWin[i].oHead.evnt.onmouseover=new Function("w_mmover("+i+")")
	oWin[i].oHead.evnt.onmouseout=new Function("w_mmout()")
	if(!bw.ns4) oWin[i].oHead.evnt.ondblclick=new Function("mdblclick(0,"+i+")")
	oWin[i].oResize.evnt.onmouseover=new Function("w_mmover("+i+",1)")
	oWin[i].oResize.evnt.onmouseout=new Function("w_mmout()")	
	if(!bw.ns4){oWin[i].oHead.css.cursor="move"; oWin[i].oResize.css.cursor="w-resize"
		if(!bw.op5){oWin[i].oWindow.css.overflow="hidden"; oWin[i].css.overflow="hidden"
		}
	}
	oWin[i].oUp=new lib_obj2('divWinUp'+i,'divWin'+i); oWin[i].oDown=new lib_obj2('divWinDown'+i,'divWin'+i)
	oWin[i].lastx=oWin[i].x; oWin[i].lasty=oWin[i].y; oWin[i].resize=win_resize; oWin[i].close=win_close;
	oWin[i].maximize=win_maximize;	oWin[i].minimize=win_minimize;
	oWin[i].regwin=win_regwin; oWin[i].checkscroll=win_checkscroll;
	oWin[i].up=win_up; oWin[i].down=win_down; oWin[i].addZ=win_addZ; oWin[i].state="reg"}
function win_regwin(m){
	this.oResize.css.visibility="inherit"; this.resize(this.origw,this.origh)
	if(!m)this.slideIt(this.lastx,this.lasty,30,10); else this.moveIt(this.lastx,this.lasty)
  this.state="reg"; this.addZ(); this.checkscroll()}
function win_maximize(){
	if(this.state!="max"){
		if(this.state!="min"){this.lastx=this.x; this.lasty=this.y}
		var mw=winpage.x2 - 10, mh=winpage.y2 - 10 - 140
		this.slideIt(5,143,30,10,this.obj+'.resize('+mw+','+mh+');'+ this.obj+'.checkscroll();')
		this.state="max"; this.addZ();}else this.regwin()}
function win_minimize(){
	if(this.state!="min"){
		if(this.state!="max"){this.lastx=this.x; this.lasty=this.y}
		var y=winpage.y2-16,ox=winpage.x2-126,a=0,couns=0,x
		for(i=0;i<wins;i++){ x=i*125; ok=a
			if(a*125>ox){if(ox>126) i=0; a=0; y-=15; x=0}
			for(j=0;j<wins;j++){couns++; if(oWin[j].x==x && oWin[j].y==y) a++}		
			if(a==ok) break;
    }; x=a*125;
		this.slideIt(x,y,30,10); this.oResize.hideIt()
		this.state="min"; this.resize(125,14)
	}else this.regwin()}
function win_close(){this.hideIt(); this.oUp.hideIt(); this.oDown.hideIt()}
function win_resize(w,h){
	this.oButtons.moveIt(w-39,0); this.oResize.moveIt(w-13,h-9); this.oWindow.clipTo(0,w-2,h-23,0,1)
	this.clipTo(0,w,h,0,1); this.oHead.clipTo(0,w,14,0,1); this.oText.moveIt(2,3)
	this.oUp.hideIt(); this.oDown.hideIt()}
function win_checkscroll(w,h){
	this.oText.height=this.oText.evnt.offsetHeight||this.oText.css.pixelHeight||this.oText.ref.height||0
	w=this.cr; h=this.cb; if(this.oText.height>h-28 && this.state!="min"){
		this.oWindow.clipTo(0,w-14,h-23,0,1); this.oUp.moveIt(w-12,14)
		this.oUp.clipTo(0,11,h-30,0,1); this.oDown.moveIt(w-12,h-21)
		this.oDown.clipTo(0,11,12,0,1); this.oUp.showIt(); this.oDown.showIt()
	}else{this.oUp.hideIt(); this.oDown.hideIt()}
}
var sctim=100,winScroll;
function win_up(){clearTimeout(sctim);if(this.oText.y>=this.oWindow.cb-this.oText.height-10 && winScroll){this.oText.moveBy(0,-8); setTimeout(this.obj+".up()",30)}}
function win_down(){clearTimeout(sctim); if(this.oText.y<=0 && winScroll){this.oText.moveBy(0,8); setTimeout(this.obj+".down()",30)}}
function noScroll(){clearTimeout(sctim);winScroll=false}
function win_addZ(){oWin.zIndex++; this.css.zIndex=oWin.zIndex}
function win_init(){
	if(bw.ns4){document.captureEvents(Event.MOUSEMOVE | Event.MOUSEDOWN | Event.MOUSEUP | Event.DBLCLICK)
    document.ondblclick=mdblclick; }document.onmousemove=mmove;	document.onmousedown=mdown; document.onmouseup=mup;}
function w_mmover(num,resize){if(!resize) oWin.dragover=num; else oWin.resizeover=num}
function w_mmout(){oWin.dragover=-1; oWin.resizeover=-1}
function mup(e){
	if(oWin.dragobj!=-1){if(oWin[oWin.dragobj].state=="reg"){oWin[oWin.dragobj].lastx=oWin[oWin.dragobj].x; oWin[oWin.dragobj].lasty=oWin[oWin.dragobj].y}}
	oWin.dragobj=-1	
	if(oWin.resizeobj!=-1){oWin[oWin.resizeobj].checkscroll()
		oWin[oWin.resizeobj].origw=oWin[oWin.resizeobj].cr
		oWin[oWin.resizeobj].origh=oWin[oWin.resizeobj].cb		
	}else if(bw.ns4) routeEvent(e); oWin.resizeobj=-1
}
function mdown(e){
	var x=(bw.ns4 || bw.ns6)?e.pageX:event.x||event.clientX
  var y=(bw.ns4 || bw.ns6)?e.pageY:event.y||event.clientY
	if(bw.ie5 || bw.ie6) y+=document.body.scrollTop
  var id1=oWin.dragover,id,id2=oWin.resizeover
	if(id1>-1 || id2>-1){if(id2>-1){ id=id2; oWin.resizeobj=id;
		}else{id=id1; oWin.dragobj=id; oWin.clickedX=x-oWin[id].x; 
			oWin.clickedY=y-oWin[id].y}; oWin[id].addZ()
		for(var i=0;i<wins;i++){if(i!=id)	oWin[i].oWindow.bg("white"); else oWin[i].oWindow.bg("#EEF3F9")}
	}else if(bw.ns4) routeEvent(e)
}
function mmove(e,y){
	var x=(bw.ns4 || bw.ns6)?e.pageX:event.x||event.clientX
  y=(bw.ns4 || bw.ns6)?e.pageY:event.y||event.clientY
	if(bw.ie5 || bw.ie6) y+=document.body.scrollTop
	var id1=oWin.dragobj,id2=oWin.resizeobj
	if(id2>-1){
		var nx=x,ny=y, oldw=oWin[id2].cr,oldh=oWin[id2].cb,cw= nx -oWin[id2].x, ch= ny - oWin[id2].y; 
    if(cw<120) cw=120; if(ch<70) ch=70; oWin[id2].resize(cw,ch)
	}else if(id1>-1){nx=x-oWin.clickedX; ny=y-oWin.clickedY
		if(ny<140) ny=140; oWin[id1].moveIt(nx,ny)
	}
  if(bw.op5||bw.op6&&oM) cm_resized()
	if(!bw.ns4) return false; else return true
}
function mdblclick(e,num){if(num>-1) oWin[num].maximize(); else if(oWin.dragover>-1) oWin[oWin.dragover].maximize()}
function setWindows(){
	var between=10; oWin.rows=Math.round((oWin.currwins/3)+0.2)
	oWin.columns=1; var j=0,a=0,c=0;
	for(var i=0;i<wins;i++){
		if(j==oWin.columns-1){
			oWin.columns=oWin.currwins-a<3?oWin.currwins-a:oWin.currwins-a==4?2:3
			if(oWin.currwins!=1 && a!=0) c++; j=0
		}else if(a!=0) j++
		oWin[i].origw=(winpage.x2-3-(between*oWin.columns))/oWin.columns 
		oWin[i].origh=(winpage.y2-137-(between*oWin.rows))/oWin.rows
		oWin[i].origx=oWin[i].origw*(j)+(between*j+1) +5
		oWin[i].origy=oWin[i].origh*c+140+(between*c)  + 3
		oWin[i].lasty=oWin[i].origy; oWin[i].lastx=oWin[i].origx
    oWin[i].regwin(1); oWin[i].moveIt(oWin[i].lastx,oWin[i].lasty); 
    oWin[i].showIt(); a++;
	}
}