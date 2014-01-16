<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>

<!--#include virtual="/samples/AXBoard/dbconn.asp"-->
<!--#include virtual="/_AXASP/AXJ.asp"-->
<!--#include virtual="/_AXASP/AXDB.asp"-->
<!--#include virtual="/_AXASP/AXFSO.asp"-->

<%
var axisDB = new AXDB();
axisDB.setConfig({
	strConnection: strConn
});
axisDB.open();

var axisFSO = new AXFSO();
var req = AXReq();
var reqFiles = req.file;

var query;
var row;
var isBoolean;
var rt1, rt2;

var myFile = req.file;		//saved fileName
var myPath = req.path;		//saved path
var thumb = req.thumb;		//saved thumb fileName

var cvtPath = myPath.replace( /\//g , "\\");
var cvtThumb = thumb.replace( /\//g , "\\");

/*
query = "select thumb from T_fileSystem where fileName = '" + myFile + "'";
row = axisDB.getRow(query);
if (!row.eof){
	thumb = row.thumb;
}
println(row);
*/

query = "delete T_fileSystem where fileName = '" + myFile + "'";
result = axisDB.execute( query );
/*
println(result);
println(axisFSO.getMapPath("/") + cvtPath + myFile );
*/

isBoolean = axisFSO.isFileExist( axisFSO.getMapPath("/") + cvtPath + myFile );
if (isBoolean) {
	rt1 = axisFSO.deleteFile(axisFSO.getMapPath("/") + cvtPath + myFile );
	//println(rt1);
}

//println(axisFSO.getMapPath("/") + cvtThumb );

isBoolean = axisFSO.isFileExist(axisFSO.getMapPath("/") + cvtThumb);
if (isBoolean) {
	rt2 = axisFSO.deleteFile(axisFSO.getMapPath("/") + cvtThumb );
	//println(rt2);
}

print("{result:'ok', msg:'delete'}");

axisFSO = null;
axisDB.close();
%>