/*Browsercheck object*/
function cm_bwcheck(){
	this.ver=navigator.appVersion
	this.agent=navigator.userAgent.toLowerCase()
	this.dom=document.getElementById?1:0
	this.op5=this.agent.indexOf("opera 5")>-1 && window.opera 
  this.op6=this.agent.indexOf("opera 6")>-1 && window.opera 
  this.ie5 = (this.agent.indexOf("msie 5")>-1 && !this.op5 && !this.op6)
  this.ie55 = (this.ie5 && this.agent.indexOf("msie 5.5")>-1)
  this.ie6 = (this.agent.indexOf("msie 6")>-1 && !this.op5 && !this.op6)
	this.ie4=(this.agent.indexOf("msie")>-1 && document.all &&!this.op5 &&!this.op6 &&!this.ie5&&!this.ie6)
  this.ie = (this.ie4 || this.ie5 || this.ie6)
	this.mac=(this.agent.indexOf("mac")>-1)
	this.ns6=(this.agent.indexOf("gecko")>-1 || window.sidebar)
	this.ns4=(!this.dom && document.layers)?1:0;
	this.bw=(this.ie6 || this.ie5 || this.ie4 || this.ns4 || this.ns6 || this.op5 || this.op6)
  this.usedom= this.ns6//Use dom creation
  this.reuse = this.ie||this.usedom //Reuse layers
  this.px=this.dom&&!this.op5?"px":""
	return this
}
var bw=new cm_bwcheck()

function openWindow(url) {
  popupWin = window.open(url,'new_page','width=400,height=400')
}

var oM,wins