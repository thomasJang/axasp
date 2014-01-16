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

var tableName 	= req.tableName;
var tableNo 	= req.tableNo;
var docuNo 		= req.docuNo;

var query;
var articleRow;
var result;
var isBoolean;
var cvtFile, cvtThumb;

query = "select * from "+tableName+" where docuNo="+docuNo+" and tableNo = '"+tableNo+"'";
articleRow = axisDB.getRow(query);



if (!articleRow.eof){
	//if ($.getCookie("isAdmin") ){
	if ($.getCookie("auth") == "9" ){
		//관리자 확인
		
	}else if (parseInt(articleRow.memberNo) != $.getCookie("memberNo")){
		print("{result:'err', msg:'삭제권한이 없습니다.'}");
		Response.End;
	}else{
	
	}	

}else{
	print("{result:'err', msg:'해당 게시글이 존재하지 않습니다'}");
	Response.End;
}


axisDB.beginTrans();
	query = "select path+fileName as attFile, thumb from T_fileSystem where parentType = 'B"+tableNo+"' and parentNo = '"+docuNo+"'";
	var attFileRow = axisDB.getRows(query);
	
	//print(attFileRow);
	
	
	query = "delete T_fileSystem where parentType = 'B"+tableNo+"' and parentNo = '"+docuNo+"'";
	result = axisDB.execute(query);
	
	query = "delete from "+tableName+"Logs where docuNo="+docuNo+" and tableNo = '"+tableNo+"'";
	result = axisDB.execute(query);
	
	query = "delete from "+tableName+"Comment where docuNo="+docuNo+" and tableNo = '"+tableNo+"'";
	result = axisDB.execute(query);
	
	query = "delete from "+tableName+" where docuNo="+docuNo+" and tableNo = '"+tableNo+"'";
	result = axisDB.execute(query);

var retCommit = axisDB.commitTrans();
if (isError(retCommit)){
	axisDB.rollBackTrans();
}else{
	//파일 시스템에서 물리적 파일 제거
	
	$.each(attFileRow, function(idx, o){
		cvtFile = o.attFile.replace( /\//g , "\\");
		cvtThumb = o.thumb.replace( /\//g , "\\");

		isBoolean = axisFSO.isFileExist( axisFSO.getMapPath("/") + cvtFile );
		if (isBoolean) {
			var rt1 = axisFSO.deleteFile(axisFSO.getMapPath("/") + cvtFile );
			//println(rt1);
		}
		
		isBoolean = axisFSO.isFileExist(axisFSO.getMapPath("/") + cvtThumb);
		if (isBoolean) {
			var rt2 = axisFSO.deleteFile(axisFSO.getMapPath("/") + cvtThumb );
			//println(rt2);
		}
	});	
}
	
print("{result:'ok', msg:'삭제제되었습니다.'}");

axisDB.close();

Response.End;
%>