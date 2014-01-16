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

try {
	strCon = "Provider=SQLOLEDB.1;Password=vkakelql2012;Persist Security Info=True;User ID=pharmaton;Initial Catalog=bbhelp;Data Source=121.88.6.75;Network Library=DBMSSOCN;";
	var dbCon = Server.CreateObject("ADODB.Connection");
	dbCon.Open(strCon);
	
	var rs = dbCon.Execute("select top 10 * from T_kin_board");
	if(rs.EOF) {
		print("데이터 없음");
	} else {
		while(!rs.EOF) {
			print({
				kinNo: (rs("kinNo")+"").number(),
				title: ""+rs("title")
			});
			rs.MoveNext();
		}
	}
} catch(e) {
	print(e.description);
}

print("<hr/>");

try {
	strCon = "Provider=SQLOLEDB.1;Password=vkakelql2012;Persist Security Info=True;User ID=pharmaton;Initial Catalog=bbhelp;Data Source=121.88.6.75;Network Library=DBMSSOCN;";
	var dbCon = Server.CreateObject("ADODB.Connection");
	dbCon.Open(strCon);

	var rs = Server.CreateObject("ADODB.RecordSet");
	rs.Open("select top 10 * from T_kin_board", dbCon, adOpenStatic, adLockReadOnly, adCmdText);

	var myRow = [];
	if(rs.EOF) {
		print("데이터 없음");
	} else {
		myRow = rs.GetString();
		//var rr = new Enumerator(myRow);
		Response.write(myRow);
		
		/*
		while(!rs.EOF) {
			//print(typeof rs("kinNo"));
			
			print({
				kinNo: (rs("kinNo")+"").number(),
				title: ""+rs("title")
			});
			
			rs.MoveNext();
		}
		*/
	}
} catch(e) {
	print(e.description);
}
%>