/******************************************
EXTRA FEATURE - SCROLL MENU WHEN PAGE SCROLLS
Just add this code to the coolmenus js file to have this feature enabled
*****************************************/
if(bw.ie) makeCM.prototype.onconstruct='document.body.onscroll=new Function(c.name+".checkscrolled("+c.name+")")'
else makeCM.prototype.onconstruct='setTimeout(c.name+".checkscrolled()",200)' //REMOVE THIS LINE TO HAVE SCROLLING ON FOR EXPLORER ONLY!!
makeCM.prototype.lscroll=0
makeCM.prototype.scrollstop=1 //Set to one to use fromTop as scrolling start and end (like dhtmlcentral.com) - ONLY WORKS CORRECTLY FOR MENUS IN COLUMNS
makeCM.prototype.checkscrolled=function(obj){
	if(bw.mac) return //REMOVE THIS LINE TO HAVE SCROLLING ON THE MAC AS WELL - unstable!
  var c=bw.ie?obj:this, o
	if(bw.ns4 || bw.ns6 || bw.op5) c.scrollY=window.pageYOffset
	else c.scrollY=document.body.scrollTop
	if(c.scrollY!=c.lscroll){
    c.hidesub()
    if(c.scrollY>c.fromTop&&c.scrollstop){
      for(i=0;i<c.l[0].m.length;i++){o=c.m[c.l[0].m[i]].b; o.moveIt(o.x,c.scrollY)}
      if(c.useBar) c.bar.moveIt(c.bar.x,c.scrollY)
    }else{
      if(c.scrollstop){
        for(i=0;i<c.l[0].m.length;i++){o=c.m[c.l[0].m[i]].b; o.moveIt(o.x,c.fromTop)}
        if(c.useBar) c.bar.moveIt(c.bar.x,c.barY)
      }else{
        for(i=0;i<c.l[0].m.length;i++){o=c.m[c.l[0].m[i]].b; o.moveIt(o.x,o.oy+c.scrollY)}
        if(c.useBar) c.bar.moveIt(c.bar.x,c.barY+c.scrollY)
      }
      c.scrollY=c.scrollstop
    }
    c.ev.moveIt(0,c.scrollY)
		c.lscroll=c.scrollY; cmpage.y=c.scrollY; cmpage.y2=cmpage.orgy+c.scrollY-119
		if(bw.ie){ clearTimeout(c.tim); c.isover=0; c.hidesub()}
	}
	if(!bw.ie) setTimeout(c.name+".checkscrolled()",200)
}
/******************************************
EXTRA FEATURE - HIDE SELECT BOXES (ie5+ and ns6+ only - ignores the other browsers)
Just add this code to the coolmenus js file to have this feature enabled
*****************************************/
if(bw.dom&&!bw.op5&&!bw.op6){
  makeCM.prototype.sel=0
  makeCM.prototype.onshow+=";this.hideselectboxes(pm.subx,pm.suby,x+pm.w,y+pm.h,pm.lev)"
  makeCM.prototype.hideselectboxes=function(x,y,w,h,l){
    var selx,sely,selw,selh,i
    if(!this.sel){
      this.sel=document.getElementsByTagName("SELECT")
		  this.sel.level=0
    }
    var sel=this.sel
    for(i=0;i<sel.length;i++){
			selx=0; sely=0; var selp;
			if(sel[i].offsetParent){selp=sel[i]; while(selp.offsetParent){selp=selp.offsetParent; selx+=selp.offsetLeft; sely+=selp.offsetTop;}}
			selx+=sel[i].offsetLeft; sely+=sel[i].offsetTop
			selw=sel[i].offsetWidth; selh=sel[i].offsetHeight
			if(selx+selw>x && selx<w && sely+selh>y && sely<h){
				if(sel[i].style.visibility!="hidden"){sel[i].level=l; sel[i].style.visibility="hidden"; this.onhide+="sel["+i+"].style.visibility='visible';"}
      }else if(l<=sel[i].level) sel[i].style.visibility="visible"
    }
  }
}
/******************************************
EXTRA FEATURE -PAGECHECK - simple code that *tries* to keep the menus inside the bounderies of the page
Just add this code to the coolmenus js file to have this feature enabled
*****************************************/
makeCM.prototype.onshow+=";this.pagecheck(b,pm,pm.subx,pm.suby,maxw,maxh)"
makeCM.prototype.pagecheck=function(b,pm,x,y,w,h,n){  
  l=pm.lev+1
  a=b.align; if(!n) n=1
  //self.status="x:"+x+" y:" + y+ " w:" + w + " h:" + h + " ---- " + n
  ok=1
  if(x<cmpage.x) {pm.align=1; ok=0;}
  else if(x+w>cmpage.x2){ pm.align=2; ok=0;}
  else if(y<cmpage.y) { pm.align=3; ok=0;}
  else if(h+y>cmpage.y2) {pm.align=4; ok=0;}
  if(!ok) this.getcoords(pm,this.l[l-1].borderX,this.l[l-1].borderY,pm.b.x,pm.b.y,w,h,this.l[l-1].offsetX,this.l[l-1].offsetY)
  x=pm.subx; y=pm.suby
  b.moveIt(x,y)  
}
/******************
EXTRA - FILTER FUNCTION
*****************/
bw.filter=(bw.ie55||bw.ie6) && !bw.mac
makeCM.prototype.onshow+=";if(c.l[pm.lev].filter) b.filterIt(c.l[pm.lev].filter)"
cm_makeLevel.prototype.filter=null
cm_makeObj.prototype.filterIt=function(f){
  if(bw.filter){
    if(this.evnt.filters[0]) this.evnt.filters[0].Stop(); 
    else this.css.filter=f; 
    this.evnt.filters[0].Apply(); 
    this.showIt(); 
    this.evnt.filters[0].Play();
  }
}
/******************
EXTRA - SLIDE FUNCTION
*****************/
makeCM.prototype.onshow+="; if(c.l[pm.lev].slidepx){b.moveIt(x,b.y-b.h); b.showIt(); b.tim=null; b.slide(y,c.l[pm.lev].slidepx,c.l[pm.lev].slidetim,c,pm.lev,pm.name)}"
makeCM.prototype.going=0
cm_makeObj.prototype.tim=10;
cm_makeLevel.prototype.slidepx=null
cm_makeLevel.prototype.slidetim=30
cm_makeObj.prototype.slide=function(end,px,tim,c,l,name){
  if(!this.vis || c.l[l].a!=name) return
	if(this.y<end-px){
		if(this.y>(end-px*px-px) && px>1) px-=px/5; this.moveIt(this.x,this.y+px)
		this.clipTo(end-this.y,this.w,this.h,0)
		this.tim=setTimeout(this.obj+".slide("+end+","+px+","+tim+","+c.name+","+l+",'"+name+"')",tim)
	}else{this.moveIt(this.x,end)}
}
/******************
EXTRA - CLIP FUNCTION 
*****************/
makeCM.prototype.onshow+="if(c.l[pm.lev].clippx){h=b.h; if(!rows) b.clipTo(0,maxw,0,0,1); else b.clipTo(0,0,maxh,0,1); b.clipxy=0; b.showIt(); clearTimeout(b.tim); b.clipout(c.l[pm.lev].clippx,!rows?maxw:maxh,!rows?maxh:maxw,c.l[pm.lev].cliptim,rows)}"
cm_makeObj.prototype.tim=10;
cm_makeLevel.prototype.clippx=null
cm_makeLevel.prototype.cliptim=30
cm_makeObj.prototype.clipxy=0
cm_makeObj.prototype.clipout=function(px,w,stop,tim,rows){
	if(!this.vis) return; if(this.clipxy<stop-px){this.clipxy+=px; 
  if(!rows) this.clipTo(0,w,this.clipxy,0,1);
  else this.clipTo(0,this.clipxy,w,0,1);
  this.tim=setTimeout(this.obj+".clipout("+px+","+w+","+stop+","+tim+","+rows+")",tim)
	}else{if(bw.ns6){this.hideIt();}; if(!rows) this.clipTo(0,w,stop,0,1); else this.clipTo(0,stop,w,0,1);if(bw.ns6){this.showIt()}}
}