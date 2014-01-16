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

//println(req);

var noticeCD 	= req.AXISboardNoticeCD;
var title 		= req.AXISboardTitle;
//var content 	= AXReqRC("post", "content");
var content;
if (typeof(req.content) == "object"){
	content 	= req.content.join('');
}else{
	content 	= req.content;
}

var table_name 	= req.table_name;
var tableNo 	= req.tableNo;
var docuNo 		= req.docuNo;
var memberNo 	= req.memberNo;
var method 		= req.method;

var arrAttFileName = [];
var arrAttFileType = [];
var arrAttFileSize = [];
var arrAttThumb    = [];
var arrAttPath     = [];
var arrAttTitle    = [];

if (typeof(req.attFileName) == "object"){
	arrAttFileName = req.attFileName;
	arrAttFileType = req.attFileType;
	arrAttFileSize = req.attFileSize;
	arrAttThumb    = req.attThumb;
	arrAttPath     = req.attPath;
	arrAttTitle    = req.attTitle;
	
}else if (typeof(req.attFileName) == "string"){
	arrAttFileName.push(req.attFileName);
	arrAttFileType.push(req.attFileType);
	arrAttFileSize.push(req.attFileSize);
	arrAttThumb.push(req.attThumb);
	arrAttPath.push(req.attPath);
	arrAttTitle.push(req.attTitle);
}




if (parseInt(noticeCD) != 1) { noticeCD = 0; }

var query ;
var up_docuNo, up_memberNo, sortNo  ;
var result ;

if (method != "modify"){
	if (method == "reply"){

		up_docuNo = docuNo;
		query = "select sortNo, memberNo, up_docuMemberNo, depth from "+table_name+" where docuNo='"+docuNo+"' and tableNo = '"+tableNo+"'";
		var rt1 = axisDB.getRow(query);
		sortNo = rt1.sortNo;
		refLevel = rt1.depth + 1;

	  	up_memberNo = rt1.memberNo;
	  	if (refLevel > 1) up_memberNo = rt1.up_docuMemberNo;

	  	query = "update "+table_name+" set sortNo = sortNo+1 where (sortNo > "+sortNo+" or sortNo = "+sortNo+") and tableNo = '"+tableNo+"'";
	  	result = axisDB.execute( query );

	  	query  = "select isNull(max(docuNo), 0)+1 as docuNo from "+table_name+" where tableNo = '"+tableNo+"'";
	  	var rt3 = axisDB.getRow(query);
		docuNo = rt3.docuNo;

		query  = "select name from T_member where idx = '"+memberNo+"'";
	  	var rt4 = axisDB.getRow(query);
	  	memberNM = rt4.name;

	}else if (method == "write"){					//새글작성
		refLevel = 0;
	  	query  = "select isNull(max(docuNo), 0)+1 as docuNo from "+table_name+" where tableNo = '"+tableNo+"'";
	  	var rt1 = axisDB.getRow(query);
		docuNo = rt1.docuNo;
		up_docuNo = rt1.docuNo;
		up_memberNo = memberNo;

	    query  = "select isNull(max(sortNo), 0)+1 as sortNo from "+table_name+" where tableNo = '"+tableNo+"'";
	  	var rt2 = axisDB.getRow(query);
	  	sortNo = rt2.sortNo;

	  	query  = "select name from T_member where idx = '"+memberNo+"'";
	  	var rt3 = axisDB.getRow(query);
	  	memberNM = rt3.name;

	}

	var d = new Date();
	var regiDate = "";
   	regiDate += d.getFullYear() + "-";
   	regiDate += (d.getMonth() + 1) + "-";
   	regiDate += d.getDate() + " ";
   	regiDate += d.getHours() + ":";
   	regiDate += d.getMinutes() + ":";
   	regiDate += d.getSeconds();

	result = axisDB.insert(table_name,
	{
		tableNo		: tableNo,
		docuNo		: docuNo,
		up_docuNo	: up_docuNo,
		sortNo		: sortNo,
		depth		: refLevel,
		noticeCD	: noticeCD,
		title		: title,
		writer		: memberNM,
		content		: content,
		up_docuMemberNo	: up_memberNo,
		memberNo	: memberNo,
		IP			: AXReqSV(3),
		regiDate	: regiDate
	});


	if (result.error != undefined){
		print("{result:'err', msg:'글작성에 실패했습니다.'  }");
		Response.End;
	}
/*
//thumb		:
//categoryNo:
//productNo	:
//oid		:
//opseq		:
//opt1		:
//password	:
//writerPwd	:
*/

	var query = "";
	var table_name = "T_fileSystem";

	query  = "select isNull(max(seq), 0)+1 as seq from "+ table_name +" where parentNo = '"+docuNo+"' and parentType = 'B"+tableNo+"' ";
	var rt = axisDB.getRow(query);
	maxSeq = rt.seq;

	if (typeof(arrAttFileName) == "object"){
		for (var i=0 ; i < arrAttFileName.length; i++){

			result = axisDB.insert(table_name,
			{
				parentNo	: docuNo,
				parentType	: "B"+tableNo,
				seq			: maxSeq,
				title		: arrAttTitle[i].trim(),
				path		: arrAttPath[i].trim(),
				filename	: arrAttFileName[i].trim(),
				filetype	: arrAttFileType[i].trim(),
				filesize	: arrAttFileSize[i].trim(),
				thumb		: arrAttThumb[i].trim()
			});

			if (result.error != undefined){
				//print(result);
				print("{result:'err', msg:'첨부파일저장에 실패했습니다.' }");
				Response.End;
			}
		}

	}else if (typeof(arrAttFileName) == "string"){

		result = axisDB.insert(table_name,
		{
			parentNo	: docuNo,
			parentType	: "B"+tableNo,
			seq			: maxSeq,
			title		: arrAttTitle.trim(),
			path		: arrAttPath.trim(),
			filename	: arrAttFileName.trim(),
			filetype	: arrAttFileType.trim(),
			filesize	: arrAttFileSize.trim(),
			thumb		: arrAttThumb.trim()
		});

		if (result.error != undefined){
			//print(result);
			print("{result:'err', msg:'첨부파일저장에 실패했습니다.' }");
			Response.End;
		}
	}

	print("{result:'ok', msg:'저장되었습니다.', docuNo:"+docuNo+"}");

} else if (method == "modify"){

	result = axisDB.update(
	    "select * from " + table_name + " WHERE tableNo = '"+tableNo+"' and docuNo = '"+docuNo+"' ",
	    {
			noticeCD	: noticeCD,
			title		: title,
			content		: content
			/*
			수정일을 넣을건가?
			,IP			: AXReqSV(3)
			,regiDate	: regiDate
			*/
	    }
    );

    query = "SELECT * FROM dbo.T_fileSystem WHERE parentNo='" + docuNo + "' AND parentType = 'B" + tableNo + "'";
	var attFiles = axisDB.getRows(query);

	var already;
	$.each(arrAttTitle, function(idx, o){
		already = false;
		$.each(attFiles, function(tIdx, oo){
			if (oo.title.trim() == o.trim()){
				already = true;
			}
		});

		if (!already){
			//attfile add!

			var e_query = "";
			var e_table_name = "T_fileSystem";

			e_query  = "select isNull(max(seq), 0)+1 as seq from "+ e_table_name +" where parentNo = '"+docuNo+"' and parentType = 'B"+tableNo+"' ";
		  	var e_rt = axisDB.getRow(e_query);
			var e_maxSeq = e_rt.seq;

			var e_result = axisDB.insert(e_table_name,
			{
				parentNo	: docuNo,
				parentType	: "B"+tableNo,
				seq			: e_maxSeq,
				title		: arrAttTitle[idx].trim(),
				path		: arrAttPath[idx].trim(),
				filename	: arrAttFileName[idx].trim(),
				filetype	: arrAttFileType[idx].trim(),
				filesize	: arrAttFileSize[idx].trim(),
				thumb		: arrAttThumb[idx].trim()
			});
		}
	});

    print("{result:'ok', msg:'수정되었습니다.', docuNo:"+docuNo+"}");
}

Response.End;

axisDB.close();
%>