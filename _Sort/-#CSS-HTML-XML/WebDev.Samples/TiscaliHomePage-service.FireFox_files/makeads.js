// New ad-writing function - MartijnV 13-09-2001 - Zie ook includes-writeadscript.stm
var pageid=Math.floor(Math.random() * 19031982)

function adString(tags) {
var now = new Date()
var magic=now.getTime()
return '<sc'+'ript language="JavaScript1.2" src="http://ad.tiscali.com/jserver' + tags + '/ACC_RANDOM='+magic+'/PAGEID='+pageid+'"></sc'+'ript>';
}

function ad(tags)
{
document.write(adString(tags));
}