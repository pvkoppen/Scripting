
//===================================================
// eMFrameScripts.js
//===================================================

//Assumes definitions defined in BrowserVersions.js

// ================  Utility Methods =====================
function urlEncode(str)
{
   if(BrowserCharset != null && BrowserCharset.toLowerCase() == "utf-8")
   {
      if(MS55 || NN6)
      {
         var r = encodeURIComponent(str);
      }
      else
      {
         //REMIND: Fix to use real utf-8 algorithm.  This is not THAT big of a deal since we are only going to support IE5.5 and above and NS6 and above for utf-8.
         var r = escape(str,1);
         //return r.replace(/\+/g,"%2B");  //since the stinking ,1 doesn't always work
         r=replace(r, "+", "%2B");
         r=replace(r, " ", "+");
      }
   }
   else
   {
      var r = escape(str,1);
      //return r.replace(/\+/g,"%2B");  //since the stinking ,1 doesn't always work
      r=replace(r, "+", "%2B");
      r=replace(r, " ", "+");
   }
   return r;
}

function urlDecode(str)
{
   str = replace(str, "+", " ");
   if(BrowserCharset != null && BrowserCharset.toLowerCase() == "utf-8")
   {
      if(MS55 || NN6)
      {
         return decodeURIComponent(str);
      }
      else
      {
         //REMIND: Fix to use real utf-8 algorithm.  This is not THAT big of a deal since we are only going to support IE5.5 and above and NS6 and above for utf-8.
         return unescape(str);
      }
   }
   else
   {
      return unescape(str);
   }
}

function pack(list)
{
   if(!list || !list.length || list.length<1)
   {
      return "PP";
   }

   var s = "P:" + urlEncode(list[0]);
   for(var i=1; i<list.length; i++)
   {
      s += ":" + urlEncode(list[i]);
   }

   return s + "P";
}

function unpack(s)
{
   if(!s || s.length<1  || s.charAt(0)!='P')
   {
      return null;
   }

   if(s == "PP")
      return new Array();

   s = s.substring(2, s.length-1);

   var tmplist = s.split(":");
   var list = new Array();
   for(var i=0; i<tmplist.length; i++)
   {
      list[i] = urlDecode(tmplist[i]);
   }

   return list;
}

function packSelect(sel)
{
   var o = sel.options;
   var list = new Array();

   for(var i=0; i<o.length; i++)
   {
      list[i] = o[i].value;
   }
   return pack(list);
}

function formatMessage(format, params)
{
   for(var i=0; i<params.length; i++)
   {
      format = replace(format, "{" + i + "}", params[i]);
   }
   return format;
}

function replace(s, s1, s2)
{
   var l = s.split(s1);
   return l.join(s2);
}

//When working in a popup window, this function should be called on the "OK" button action.
//This ensures that the parent window is still open. If task has changed or parent window is
//no longer open, an alert will fire telling the user that their changes have not been saved,
//and the window will be closed.
function parentIsOpen(o)
{
    if(!o)
    {
        alert(ParentWindowChangedErrorAlertMessage);
        window.close();
        return false;
    }
    else
    {
        return true;
    }
}

function toggleDivVisibility(id)
{
   var el = document.getElementById(id).style;
   if (el.visibility=="visible") el.visibility = "hidden";
   else el.visibility = "visible";
}

function toggleDivDisplay(id)
{
   var el = document.getElementById(id).style;
   if (el.display=="none") el.display = "block";
   else el.display = "none";
}

// ================  Encoding Methods =====================
// static data for toDisplay
_trans = new Array();
_trans["&"] = "&amp;";
_trans["<"] = "&lt;";
_trans[">"] = "&gt;";
_trans["$"] = "&#36;";
_trans["\t"] = "&nbsp;&nbsp;&nbsp;&nbsp;";
_trans[" "] = "&nbsp;";
_trans["\""] = "&quot;";

function toDisplay(str)
{
   if (str==null || str.length==0)
   {
      return str;
   }

   var newStr = "";
   var charStr;
   var charValue;
   var index = 0;

   // Walk string, (Unicode)
   while (index < str.length)
   {
      charValue = str.charCodeAt(index);
      charStr = str.charAt(index);

      if( charValue >= 126 )
      {
         newStr += "&#" + charValue + ";";
      }
      else
      {
         if (charStr == "\r")
         {
            newStr += "<BR>";
            if( (index < str.length-1) && (str.charAt(index+1) == "\n") )
            {
               index++;
            }
         }
         else if (charStr == "\n")
         {
            newStr += "<BR>";
            if ((index < str.length-1) && (str.charAt(index+1) == "\r"))
            {
               index++;
            }
         }
         else if (charValue == 27)
         {
            newStr = newStr = "&#27;";
         }
         else if (_trans[charStr] != null)
         {
            newStr += _trans[charStr];
         }
         else
         {
            newStr += charStr;
         }
      }
      index++;
   }
   return newStr;
}

function xmlEncode(str)
{
   if (str==null || str.length==0)
   {
      return str;
   }

   var newStr = "";

   for(var i=0; i<str.length; i++)
   {
      var charValue = str.charCodeAt(i);
      var charStr = str.charAt(i);

      if(charValue >= 126 || charValue < 30)
      {
         newStr += "&#" + charValue + ";";
      }
      else if (_xmlEscape[charStr] != null)
      {
         newStr += _xmlEscape[charStr];
      }
      else
      {
         newStr += charStr;
      }
   }

   return newStr;
}

// static data for xmlEncode
_xmlEscape = new Array();
_xmlEscape["&"]="&amp;";   //do the & first so we don't recurse
_xmlEscape["'"]="&apos;";
_xmlEscape[">"]="&gt;";
_xmlEscape["<"]="&lt;";
_xmlEscape["\""]="&quot;";


function xmlDecode(src)
{
   if(src==null || src.length==0)
   {
      return "";
   }

   // replace &quot; with " etc
   for(i in _xmlEscape)
   {
      src=replace(src, _xmlEscape[i], i);
   }

   var charCode = "";
   var dst = "";
   var idxSrc=0;

   // replace #2b; with char for 2b
   while(idxSrc < src.length)
   {
      var ch = src.charAt(idxSrc++);
      if(ch=="&" && src.charAt(idxSrc)=='#')
      {
         // We have an escape char; Read in char code
         idxSrc++;

         ch=src.charAt(idxSrc++);
         while (ch!=';')
         {
            charCode += ch;
            ch=src.charAt(idxSrc++);
         }

         ch = String.fromCharCode(parseInt(charCode));
         charCode = "";
      }

      dst += ch;
   }

   return dst;
}


// static data for toScript
_toScript = new Array();
_toScript["\\"]="\\\\";
_toScript["\""]="\\\"";
_toScript["\'"]="\\\'";
_toScript["\n"]="\\n";
_toScript["\r"]="\\r";

function toScript(s)
{
   if (s!=null && s.length>0)
   {
      for(i in _toScript) s=replace(s, i, _toScript[i]);
   }
   return s;
}

// static data for toTag
// cannot replace # or ; with anything
_toTag = new Array();
_toTag["&"]="&#38;";    //do the & first so we don't recurse
_toTag["<"]="&#60;";
_toTag[">"]="&#62;";
_toTag["\'"]="&#39;";
_toTag["\""]="&#34;";
_toTag["\x1B"]="&#27;"; //escape

function toTag(s)
{
   if (s!=null && s.length!=0)
   {
      for(i in _toTag) s=replace(s, i, _toTag[i]);
   }
   return s;
}
