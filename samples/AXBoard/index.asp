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

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>AXBoard</title>

	<!-- css block -->
	<link rel="stylesheet" type="text/css" href="/html/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXJ.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXTabs.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXButton.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXInput.css" />

	<style type="text/css">
	H2{font-family:consolas;}
	.sample{border:1px solid #a1a1a1;padding:7px 7px 2px 7px;}
	.sample input{margin-bottom:5px;width:500px;}
	.sample input[type=file]{height:20px;}
	</style>
	<!-- css block -->

	<!-- js block -->
	<script type="text/javascript" src="/_AXJ/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/_AXJ/lib/AXJ.js"></script>
	<script type="text/javascript" src="/_AXJ/lib/AXCodeArea.js"></script>
	<script type="text/javascript" src="/_AXJ/lib/AXInput.js"></script>

	<script type="text/javascript">
	var fnObj = {
		pageStart: function(){
			$(".AXscriptSource").bindCode();
			$(".AXInputPlaceHolder").bindPlaceHolder();
		},
		checkForm: function(){
			var frm = document.fileForm;

			//frm.action = "sampleRequest.asp";
			frm.action = "sampleRequest.asp?qs1=queryStringVariable&qs2=thisisQS";
			frm.target = "iFrameRequest";
			frm.submit();
		}
	};

	$(document.body).ready(function(){
		setTimeout(fnObj.pageStart, 1);
	});
	</script>
	<!-- js block -->

</head>
<body>

	<div style="padding:20px;">
		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="index.asp" class="AXTab Blue on" id="default" >Default</a>
				<a href="sampleBoard.asp" class="AXTab Blue" target="_blank" >sample</a>
				<div class="clear"></div>
			</div>
		</div>

		<h2>AXBoard</h2>

		<div class="method AXASP">
			<div class="methodName">
				setConfig( object )
			</div>
			<div class="methodDesc">
				<div class="desc">
					debug : 디버그 모드 사용 여부(에러 시 에러 메시지 자동 출력)<br />
				</div>
<pre>
&lt;%
myBoard.setConfig({
	//debug: true,
	tableName: "T_board",
	tableNo:"4",	//테이블 번호로 구분
	account:{mNo:$.getCookie("memberNo"), auth:$.getCookie("auth")},	//멤버정보
	authLevel:{view:0, write:1, reply:1, comment:1},	//기본값, init시 테이블 체크
	useComment:true,
	reply:true,
	cntObj:{listCnt:10,pagingCnt:10},
	pageWidth:"900",
	colGroup : [
	    { key: "rowseq", label: "번호", width: "50", cClass:"no", align: "center", type:"notice" },
	    { key: "title", label: "제목", type:"title" },
	    { key: "writer", label: "작성자", width: "80" },
	    { key: "regiDate", label: "작성일", width: "80", align:"center" , type:"date" },
	    { key: "IP", label: "IP", width: "100", align:"center" },
        { key: "rcnt", label: "조회수", width: "80", cClass:"no" }
    ]
});
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				메뉴얼 준비중입니다. 
				<!--
				request(string, string, string), AXRequest(string, string, string)
				-->
			</div>
			<div class="methodDesc">
				<div class="desc">
					<!--
					서버로 전송된 값을 반환합니다.<br/>
					arg1: method = get | post | cookies<br/>
					arg2: requestName <br/>
					arg3: variableType = int | char | text<br/>
					-->
				</div>

				<pre>

				</pre>
				<!--
				<div class="errorCode">
					myAXReq.request의 단축형을 AXRequest로 제공합니다.
				</div>
				-->
			</div>
			<div class="returnType">
				
			</div>
			<div class="methodExam" >

			</div>
		</div>
		<div class="Hspace10"></div>


		

		<a name="#fileMethod"></a>
		<div class="Hspace10"></div>
<%
%>
	</div>

</body>
</html>