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
	<title>AXRequest</title>

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

			/*
			if (!isEmpty){

			}else{
				alert("파일을 선택해주세요");
			}
			*/
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
				<a href="#sample" class="AXTab Blue">sample</a>
				<div class="clear"></div>
			</div>
		</div>

		<h2>AXRequest</h2>

		<div class="method AXASP">
			<div class="methodName">
				초기화
			</div>
			<div class="methodDesc">
				<div class="desc">
					AXRequest 를 사용할 준비를 합니다.<br/>
					아래 초기화 구문이 AXJ.asp에 들어있어 AXJ.asp파일을 include 하면 자동으로 준비가 되며 "myAXReq"로 접근 가능합니다..
				</div>

				<pre>
&lt;!--#include virtual="/_AXASP/AXJ.asp"--&gt;

var myAXReq = new AXRequest();
myAXReq.setConfig({
	debug: true
});
				</pre>
			</div>
		</div>
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				request(string, string, string), AXRequest(string, string, string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					서버로 전송된 값을 반환합니다.<br/>
					arg1: method = get | post | cookies<br/>
					arg2: requestName <br/>
					arg3: variableType = int | char | text<br/>
				</div>

				<pre>
var result = myAXReq.request("post", "name", "text");
var result = AXRequest("post", "name", "text");
				</pre>
				<div class="errorCode">
					myAXReq.request의 단축형을 AXRequest로 제공합니다.
				</div>
			</div>
			<div class="returnType">
				string
			</div>
			<div class="methodExam" >
				"groovedk"
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				requestsObj([string]), AXReq([string])
			</div>
			<div class="methodDesc">
				<div class="desc">
					서버로 전송된 값을 object로 모두 반환합니다. arg를 지정하지 않으면 모든 전송된 값을 넘겨줍니다.<br/>
					arg1: method = get | post <br/>
				</div>

				<pre>
var result = myAXReq.requestsObj();
var result = AXReq();
var result = AXReq('get');
var result = AXReq('post');
				</pre>
				<div class="errorCode">
					myAXReq.requestsObj의 단축형을 AXReq로 제공합니다.
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam" >
				{name: "groovedk", sex:"male", address:"서울시 은평구"}
			</div>
		</div>
		<div class="Hspace20"></div>


		<div class="method AXASP">
			<div class="methodName">
				requestsArr([string]), AXReqToArray([string])
			</div>
			<div class="methodDesc">
				<div class="desc">
					서버로 전송된 값을 Array로 모두 반환합니다. arg를 지정하지 않으면 모든 전송된 값을 넘겨줍니다.<br/>
					arg1: method = get | post <br/>
				</div>

				<pre>
var result = myAXReq.requestsArr();
<b>var result = AXReqToArray();</b>
var result = AXReqToArray('get');
var result = AXReqToArray('post');
				</pre>
				<div class="errorCode">
					myAXReq.requestsArr의 단축형을 AXReqToArray로 제공합니다.
				</div>
			</div>
			<div class="returnType">
				object array
			</div>
			<div class="methodExam" >
				[<br/>
				{nm:"qs1", value:"queryStringVariable", method:"get"}, <br/>
				{nm:"qs2", value:"thisisQS", method:"get"}, <br/>
				{nm:"nm", value:"111", method:"post"}, <br/>
				{nm:"sex", value:"222", method:"post"}, <br/>
				{nm:"address", value:"333", method:"post"}, <br/>
				{nm:"ta", value:"textarea", method:"post"}<br/>
				]<br/>
			</div>
		</div>
		<div class="Hspace20"></div>

		<div class="method AXASP">
			<div class="methodName">
				serverVariables([string]), AXReqSV ([string])
			</div>
			<div class="methodDesc">
				<div class="desc">
					serverVariables 값을 반환합니다. arg를 지정하지 않으면 Request.ServerVariables("HTTP_HOST") 값을 넘겨줍니다.<br/>
					arg1: key = HTTP_HOST | PATH_INFO | HTTP_REFERER | Request.ServerVariables 의 key value <br/>
					HTTP_HOST | PATH_INFO | HTTP_REFERER | REMOTE_ADDR  이 4개 값은 0,1,2,3 으로 접근이 가능합니다.
				</div>

				<pre>
var result = myAXReq.serverVariables();
var result = AXReqSV();
var result = myAXReq.serverVariables("PATH_INFO");
var result = AXReqSV(2);
var result = AXReqSV(3);
				</pre>
				<div class="errorCode">
					myAXReq.serverVariables 단축형을 AXReqSV 로 제공합니다.
				</div>
			</div>
			<div class="returnType">
				string
			</div>
			<div class="methodExam" >
				<%=myAXReq.serverVariables()%><br/>
				<%=AXReqSV()%><br/>
				<%=AXReqSV(1)%><br/>
				<%=AXReqSV(2)%><br/>
				<%=AXReqSV(3)%><br/>
			</div>
		</div>
		<div class="Hspace20"></div>
		
		<div class="method AXASP">
			<div class="methodName">
				AXReqRC(string, string, string)
				
			</div>
			<div class="methodDesc">
				<div class="desc">
				서버로 전송된 값을 반환합니다.<br/>
					arg1: method = get | post | cookies<br/>
					arg2: requestName <br/>
					arg3: variableType = int | char | text<br/>
				</div>

				<pre>
var result = myAXReq.receivingCombined("post", "content", "text");
var result = AXReqRC("post", "content", "text");
				</pre>
				<div class="errorCode">
					myAXReq.receivingCombined 단축형을 AXReqRC 로 제공합니다.
				</div>
			</div>
			<div class="returnType">
				string
			</div>
			<div class="methodExam" >
				parameter name 이 같을때 문자열을 합쳐서 리턴합니다. <br/>
				주로 AXEditor 의 내용을 받을때 사용됩니다. 
			</div>
		</div>
		<div class="Hspace20"></div>
		


		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="index.asp" class="AXTab Blue" >Default</a>
				<a href="#sample" class="AXTab Blue on" id="sample">sample</a>
				<div class="clear"></div>
			</div>
		</div>

		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				sample
			</div>
			<div class="methodDesc">
				<div class="desc">sample form</div>
				<div class="sample">
					<form name="fileForm" id="fileForm" METHOD="POST" >
						<input type="text" name="nm" id="AXInputPlaceHolder1" value="" class="AXInputSmall AXInputPlaceHolder" placeholder="name" /><br/>
						<input type="text" name="nm" id="AXInputPlaceHolder4" value="" class="AXInputSmall AXInputPlaceHolder" placeholder="name" /><br/>
						<input type="text" name="sex" id="AXInputPlaceHolder2" value="" class="AXInputSmall AXInputPlaceHolder" placeholder="sex" /><br/>
						<input type="text" name="address" id="AXInputPlaceHolder3" value="" class="AXInputSmall AXInputPlaceHolder" placeholder="address" /><br/>
						<textarea name="ta" rows="5" style="width:500px;">textarea</textarea>
					</form>
					<br/>
					<input type="button" value="submit" class="AXButton Red" onclick="fnObj.checkForm();" />

				</div>
			</div>
			<div class="methodExam" >
				<iframe name="iFrameRequest" id="iFrameRequest" src="" width="100%" height="300" frameborder="0"  ></iframe>
				<%
				//var op0 = myAXFSO.getDriveList();
				//print("return value");
				%>
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