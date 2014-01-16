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

<%
var axisDB = new AXDB();
axisDB.setConfig({
	strConnection: strConn
});

axisDB.open();

var req = AXReq();
//tableNo = req.AXBC_tableNo; 요거 정리

var tableNo = req.tableNo;
var docuNo = req.docuNo;

var query = [];
var queryStr = "";
var row, result;
var table_name = "T_BoardComment";
//관리자나 회원관리확인
var memberNo = $.getCookie("memberNo");


//memberNo = 1;

if (req.method == "save" ){
	tableNo = req.AXBC_tableNo;
	docuNo = req.AXBC_docuNo;

	if (memberNo == ""){
		print("{result:'err', msg:'회원 로그인 정보가 없습니다. 요청을 처리 할 수 없습니다'}");
		Response.End 
	}
	
	queryStr  = "select isNull(max(seq), 0)+1 as seq from "+table_name+" where tableNo = '"+tableNo+"' and docuNo = '"+docuNo+"' "
	var row1 = axisDB.getRow(queryStr);
	var maxSeq = row1.seq;
	
	queryStr = "select isNull(max(sortNo), 0)+1 as sortNo from "+table_name+" where tableNo = '"+tableNo+"' and docuNo = '"+docuNo+"' "
	var row2 = axisDB.getRow(queryStr);
	var maxSortNo = row2.sortNo;
	
	result = axisDB.insert(table_name,
	{
		tableNo		: req.AXBC_tableNo,
		docuNo      : req.AXBC_docuNo,
		seq         : maxSeq,
		up_seq      : maxSeq,
		sortNo      : maxSortNo,
		memberNo    : memberNo,
		content     : req.AXBC_content,
		IP          : AXReqSV(3)
	});

	//print(result);
	print("{result:'ok', msg:'저장되었습니다.'}");

}else if (req.method == "delete" ){
	var seq = req.seq;
	result = axisDB.execute( "DELETE FROM T_BoardComment WHERE seq = '" + seq + "' and tableNo = '" + tableNo + "' and docuNo = '" + docuNo + "' " );
    print("{result:'ok', msg:'삭제되었습니다.'}");

}else if (req.method == "modify" ){
	tableNo = req.AXBC_tableNo;
	docuNo = req.AXBC_docuNo;
	
	//수정도 하나요?
    result = axisDB.update(
	    "select * from T_BoardComment WHERE seq = '"+req.seq+"' and tableNo = '"+tableNo+"' and docuNo = '"+docuNo+"' ",
	    {
		    content : req.AXBC_content
	    }
    );

    print("{result:'ok', msg:'수정되었습니다.'}");

}else{
	//list
	query.push(" SELECT a.tableNo, a.docuNo, a.seq, a.up_seq, a.sortNo, a.depth, a.memberNo, a.content, a.regiDate, a.IP ");
	query.push("	,ROW_NUMBER() OVER (ORDER BY a.seq) AS rowseq ");
	query.push("	,isnull(b.name+'('+b.ID+')', '--') as memberInfo ");
	query.push(" FROM T_BoardComment as a ");
	query.push(" LEFT OUTER JOIN T_member as b on a.memberNo = b.idx ");
	query.push(" WHERE tableNo = '", req.tableNo, "' and docuNo = ", req.docuNo);
	query.push(" ORDER BY sortNo desc ");


	row = axisDB.getRows( query.join(''), {pageSize:req.pageSize, pageNo:req.pageNo} );
	print(row);
}


axisDB.close();
%>