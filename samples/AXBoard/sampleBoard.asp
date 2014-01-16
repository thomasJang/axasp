<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>

<!--#include file="dbconn.asp"-->
<!--#include virtual="/_AXASP/AXJ.asp"-->
<!--#include virtual="/_AXASP/AXDB.asp"-->
<!--#include virtual="/_AXASP/AXBoard.asp"-->


<%
var axisDB = new AXDB();
axisDB.setConfig({
	strConnection: strConn
});

axisDB.open();

var req = AXReq();
var myBoard = new AXBoard();

var docuNo 	= (req.docuNo != undefined) ? req.docuNo : 0;
//var pages 	= (req.pages != undefined) ? req.pages : 0;				//변수이름 재정의?

var pageNo		= (req.pageNo != undefined) ? req.pageNo : 1;
var modi        = (req.modi != undefined) ? req.modi : 0;
var chk         = (req.chk != undefined) ? req.chk : "";  			//검색관련
var setext      = (req.setext != undefined) ? req.setext : "";
var stPage      = (req.stPage != undefined) ? req.stPage : 1;
//var list_page	= AXReqSV("URL");									// axj 공통에 적용

//var modi		= (req.modi != undefined) ? req.modi : 0;
//var refLevel	= (req.refLevel != undefined) ? req.refLevel : 0;


var method		= (req.method != undefined) ? req.method : "list" ;

//temp login ------------------------------------------------------------------------------
//temp login ------------------------------------------------------------------------------
var tmp_memberNo = (req.tmp_memberNo != undefined) ? req.tmp_memberNo : "";
var tmp_grade = (req.tmp_grade != undefined) ? req.tmp_grade: "";

if (tmp_memberNo != "") {
	$.setCookie("memberNo", tmp_memberNo);
}


if (tmp_grade != "") {
	$.setCookie("auth", tmp_grade);
	
	if (tmp_grade == 9){
		//임시 관리자 쿠키
		$.setCookie("isAdmin", tmp_memberNo);
	}
}

var logout = (req.logout != undefined) ? req.logout : "";
if ( logout ){
	$.setCookie("memberNo", "");
	$.setCookie("auth", "");
}

var mySessionID;
if (!Session("sessionID")){
	var d = new Date();
	var ssDate = "";
	ssDate += d.getFullYear();
	ssDate += (d.getMonth() + 1);
	ssDate += d.getDate();
	ssDate += d.getHours();


	if ($.getCookie("sessionID") == "" ){
		mySessionID = Session.SessionID+"#"+ssDate;
	}

	var expiredays = d.add(100, "d");
	var exDay = expiredays.getFullYear() +"-"+ (expiredays.getMonth() + 1) +"-"+ expiredays.getDate();

	$.setCookie("sessionID", mySessionID, exDay );
	Session("sessionID") = mySessionID;

}
//temp login ------------------------------------------------------------------------------
//temp login ------------------------------------------------------------------------------

//categoryNo    = modsReq("get", "categoryNo", "char")
//sproductNo    = modsReq("get", "productNo", "int")
//noticeCD      = 0


//검색관련 정리 및 검색스크립트 연결
myBoard.setConfig({
	//debug: true,
	tableName: "T_board",
	tableNo:"4", 															//한개의 테이블로 할때 번호로 구분
	account:{memberNo:$.getCookie("memberNo")+"", auth:$.getCookie("auth")+""},	//멤버정보
	authLevel:{view:0, write:1, reply:1, comment:1},						//기본값, init시 테이블 체크
	useComment:true,
	reply:true,
	cntObj:{listCnt:10,pagingCnt:10},
	/*
	loadPage:{list:"", comment:"", view:"", aroundArticle:""},
	processPage:{insert:"", update:"", del:"", comment:""},
	*/
	pageWidth:"900",
	colGroup : [
	    { key: "rowseq", label: "번호", width: "50", cClass:"no", align: "center", formatter:function(){
	    	if (this.item.noticeCD == 1) return "<span class='notice'></span>";
	    	else return this.item.rowseq;
	    } },
	    { key: "title", label: "제목", ellipsis: true, formatter:function(){
			var po = [];
			var o = this.item;

			if (o.depth != undefined && o.depth > 0) {
				for(var i=0; i<o.depth; i++){ po.push("&nbsp;&nbsp;"); }
				po.push("<span class='defaultStyle re'></span>");
			}

			if (o.regiDate != undefined && Math.abs((new Date()).diff(o.regiDate, "H")) < 24){
				po.push("<span class='defaultStyle new' title='", (new Date()).getTimeAgo(o.regiDate), "'></span>");
			}
  			if (o.fcnt != undefined && o.fcnt > 0){
  				if (o.fcnt == 1) imgClass = "att";
  				else imgClass = "atts";

  				po.push("<span class='defaultStyle ", imgClass, "' title='", o.fcnt, "개의 첨부파일이 있습니다.'></span>");
  			}
  			if (o.ccnt != undefined && o.ccnt > 0){
  				if (o.ccnt == 1) imgClass = "comment";
  				else imgClass = "comments";

  				po.push("<span class='defaultStyle ", imgClass, "' title='", o.ccnt,"개의 덧글이 있습니다.'></span>");
  			}
				po.push("<a href='?docuNo=", o.docuNo, "&amp;", myBoard.vg_link, "&amp;method=view'>", o.title, "</a>");

			return po.join('');
	    } },
	    { key: "writer", label: "작성자", width: "80" },
	    { key: "regiDate", label: "작성일", width: "80", align:"center" , formatter:"date" },
	    { key: "IP", label: "IP", width: "100", align:"center" },
	    { key: "docuNo", label: "doc", width: "50", align:"center"},
        { key: "rcnt", label: "조회수", width: "80", cClass:"no"}
    ]

    /*
    ,view : []
    */
});
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- css block -->

<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXJ.css" />
<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXButton.css" />
<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXSelect.css">
<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXInput.css">

<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXEditor.css">
<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXUpload.css">

<link rel="stylesheet" type="text/css" href="css/AXBoard.css" />

<style type="text/css" >
/* temp */
.b1 {border:1px solid #cc0000;}
/*html{font:malgun gothic;font-size:12px;}*/
</style>

<script type="text/javascript" src="/_AXJ/jquery/jquery.min.js"></script>
<script type="text/javascript" src="/_AXJ/lib/AXJ.js"></script>
<script type="text/javascript" src="/_AXJ/lib/AXInput.js"></script>

<script type="text/javascript" src="/_AXJ/lib/AXDOMRange.js"></script>
<script type="text/javascript" src="/_AXJ/lib/AXEditor.js"></script>
<script type="text/javascript" src="/_AXJ/lib/AXUpload.js"></script>

<script type="text/javascript" src="js/validate.js"></script>
<script type="text/javascript" src="js/AXComment.js"></script>
<script type="text/javascript" src="js/AXBoard.js"></script>

<script type="text/javascript">
	jQuery(document).ready(function(){
		//AXBoardObj.pageOnLoad();
	});

	//temp login
	function login(){
		location.href="?tmp_memberNo="+$("#tmp_memberNo").val()+"&tmp_grade="+$("#tmp_grade").val()+"&<%=myBoard.vg_link%>";
	}
</script>


</head>
<body>

<div class="BBF" style="position:relative;width:<%=myBoard.config.pageWidth%>px;padding-bottom:20px;font-size:13px;">
	<div>
		<a href="?">HOME</a> &nbsp;&nbsp;&nbsp; method : <%=method%>, pageNo : <%=pageNo%>, stPage : <%=stPage%>, docuNo : <%=docuNo%>,
		[ <%="memberNo : " + $.getCookie("memberNo") + "| auth : " + $.getCookie("auth") %> ] <br/>
		테스트 memberNo : 1, 2
	</div>

	<div style="margin-left:20px;border:1px dashed #555;position:absolute;top:0px;right:0px;padding:3px;">
		memberNo : <input type="text" name="tmp_memberNo" id="tmp_memberNo" value='<%=$.getCookie("memberNo")%>' style="width:50px" />
		auth : <input type="text" name="tmp_grade" id="tmp_grade" value='<%=$.getCookie("auth")%>' style="width:50px" />
		<input type='button' value='login' class='AXButton' onclick="login()" />
		<input type='button' value='logout' class='AXButton' onclick="location.href='?logout=true';" />
	</div>
</div>

<!-- board area -->
<div class="boardContainer" id="boardContainer" style="text-align:left;width:<%=myBoard.config.pageWidth%>px;">
<%

var paramObj = {
	pageNo: pageNo,
	stPage: stPage,
	chk: chk,
	setext: setext,
	docuNo: docuNo,
	/*
	pages: pages,
	modi: modi,
	*/
	method: method
	
	
	//,refLevel: refLevel
}

myBoard.setBoard(paramObj);

axisDB.close();
%>
</div>
<!-- board area -->

</body>
</html>