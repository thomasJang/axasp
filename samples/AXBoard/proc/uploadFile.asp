<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>

<!--#include virtual="/_AXASP/AXJ.asp"-->
<!--#include virtual="/_AXASP/AXFSO.asp"-->
<!--#include virtual="/_AXASP/AXUpload.asp"-->

<%
var axisFSO = new AXFSO();

var myAXUpload = new AXUpload();
	myAXUpload.setConfig({
		debug: true,
		//componentName:"aspUpload",
		uploadPath:"/_FILE",
		thumbFolderName:"thumb",		
		autoFolderMake:true,
		maxSize:1024*1024,
		thumbSize:{width:71, height:71}	
	});

var rt= myAXUpload.saveFiles();
//println(rt);

var po = [];
var obj = {};
$.each(rt.arrSaveFiles, function(idx, o){
	obj = { originName: o.originName, uniqueName: o.uniqueName, fileExt: "."+o.fileExt, fileSize: o.size, path:rt.savePath.enc() , thumbName:rt.thumbPath.enc() + o.thumb.name };
	po.push(obj);
	obj = {};
});

/*
po.push("[");
$.each(rt.arrSaveFiles, function(idx, o){
	po.push("{");
	po.push("originName:'",o.originName,"',");
	po.push("uniqueName:'",o.uniqueName,"',");
	po.push("fileExt:'.",o.fileExt,"',");
	po.push("fileSize:'",o.size,"',");
	po.push("path:'",rt.savePath,"',");
	po.push("thumbName:'",o.thumb.name,"'");
	po.push("}");
	if (rt.arrSaveFiles.length != (idx+1) ) po.push(",");	
});
po.push("]");
*/

print(po);

//var str = Object.toJSON(po).replace(/\\/g, "\\");
//print(str);



/*
var rt2 = myAXUpload.getFormData();
println(rt2);
*/


%>