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
var myAXUpload = new AXUpload();
	myAXUpload.setConfig({
		debug: true,
		//componentName:"aspUpload",
		//uploadPath:"path",
		autoFolderMake:true,
		maxSize:1024*1024,
		thumbSize:{width:100, height:100}	
	});

var rt1= myAXUpload.saveFiles();
println(rt1);

var rt2 = myAXUpload.getFormData();
println(rt2);

%>