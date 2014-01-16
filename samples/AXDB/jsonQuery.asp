<%@ language="javascript" CODEPAGE="65001" %>
<%
	Session.CodePage  = 65001;
	Response.CharSet  = "UTF-8";
	Response.AddHeader("Pragma","no-cache");
	Response.AddHeader("cache-control", "no-staff");
	Response.Expires  = -1;
%>
<!--METADATA TYPE= "typelib" NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual="/_AXASP/AXJ.asp"-->
<!--#include virtual="/_AXASP/AXDB.asp"-->
<%

	var strMySql = "Driver={MySQL ODBC 3.51 Driver};server=codecord.net;database=www_codecord_net;uid=raniel;pwd=raniel20130220;charset=euckr;port=3306";


	var mydb = new AXDB();


	mydb.setConfig({
		type: "mysql",					// 연결 DB 생략 시 mssql
		strConnection: strMySql,		// 연결 문자열(필수 인자)
		debug: false					// 디버그 모드의 경우 에러가 발생할 때마다 에러내용을 출력해준다
		/*autoRollback: false*/			// 커밋 때 에러 발생 시 자동 롤백방지
	});

	var ret = mydb.open();

	
	var row = mydb.getRows("select * from t_filesystem", { pageSize : 10, pageNo : 1 });
	
	print("pageCount = " + row.page.pageCount + "<br>");
	print("listCount = " + row.page.listCount + "<br>");

	$.each(row.list, function(){
		print("title : " + this.title);
		print(", path : " + this.path);
		print(", filename : " + this.filename);
		print("<br />");
	});
	

	print("________________________________________________<br />");



	var row = mydb.getRows("select * from t_filesystem");

	$.each(row, function(){
		print("title : " + this.title);
		print(", path : " + this.path);
		print(", filename : " + this.filename);
		print("<br />");
	});

	


//	trace(row);

	mydb.close();
%>