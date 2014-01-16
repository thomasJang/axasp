<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>
<!--#include virtual="/_AXASP/AXJ.asp"-->
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1.0, minimum-scale=1" />
	<title>AXISJ</title>
	<!-- css block -->
	<link rel="stylesheet" type="text/css" href="/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXJ.css" />
	<style type="text/css">
		body{padding:20px;font-family:consolas;}
		a{font-size:14px;padding:5px;display:inline-block;font-family:consolas;text-decoration:none;}
		a:hover{text-decoration:underline;}
		.sampleLink{color:#000;}
	</style>
	<!-- css block -->
	
	<!-- js block -->
	<script type="text/javascript" src="/_AXJ/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/_AXJ/lib/AXJ.js"></script>
	<script type="text/javascript" src="/js/content.js"></script>
	<script type="text/javascript">
	var fnObj = {
		pageStart: function(){

		}
	};
	$(document).ready(fnObj.pageStart);
	</script>
	<!-- js block -->
	
</head>
<body>
	<div>
		<img src="/_AXJ/axj_v.png" align="middle" alt="" />
	</div>
	
	<%
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var f = fso.GetFolder(Server.MapPath("/samples/"));
		var fc = new Enumerator(f.SubFolders);
	
		var po = [];
		for (; !fc.atEnd(); fc.moveNext()){
			folder = fso.GetFolder(fc.item());
			po.push("<a href=\"/samples/"+ folder.Name +"/\" target=\""+ folder.name +"\" class=\"sampleLink\">"+folder.Name+"</a><br/>");
		}
		print(po.join(''));
	%>

	<div style="padding:10px 5px;">ver 0.9 - 2013-03-04 오후 6:03:23</div>
</body>
</html>