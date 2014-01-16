<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>AXUpload</title>

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
			var isEmpty = true;
			$.each($(".fileInput"), function(idx, o){
				if (o.value != "" || !isEmpty) {
					isEmpty = false;
				}
			});

			if (!isEmpty){
				frm.action = "sampleFileUpload.asp";
				frm.target = "iFrameFileUpload";
				frm.submit();
			}else{
				alert("파일을 선택해주세요");
			}
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

		<h2>AXUpload</h2>

		<div class="method AXASP">
			<div class="methodName">
				초기화
			</div>
			<div class="methodDesc">
				<div class="desc">AXUpload 를 사용할 준비를 합니다.</div>
				<pre>
var myAXUpload = new AXUpload();
myAXUpload.setConfig({
	debug: true,
	//componentName:"aspUpload",	//업로드에 사용될 컴포넌트명(미구현)
	//uploadPath:"",		//업로드 경로 (기본은 _FILE)
	autoFolderMake:true,		//하위폴더 자동생성옵션, 년_월 형식(2013_03)
	maxSize:1024*1024,		//파일하나의 최대 사이즈(기본 1MB)
	thumbSize:{width:100, height:100}	//thumbSize 주지않으면  썸네일 만들지 않음
});
				</pre>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				saveFiles()
			</div>
			<div class="methodDesc">
				<div class="desc">첨부파일을 저장하고 처리내역을 반환합니다. (반환형식 object)</div>
				<pre>
var result = myAXUpload.saveFiles();
				</pre>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam" >
				{saveFolder:"C:\u0092groovedk\u0092Free\u0092AXISASP\u0092trunk\u0092_FILE\u00922013_03", arrSaveFiles:[{originName:"파일_4.jpg", fileExt:"jpg", uniqueName:"20130313103508001.jpg", size:4830}, {originName:"파일_1.jpg", fileExt:"jpg", uniqueName:"20130313103508002.jpg", size:4830}, {originName:"br.png", fileExt:"png", uniqueName:"20130313103508001.png"}]}
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				getFormData([string])
			</div>
			<div class="methodDesc">
				<div class="desc">
					서브밋된 폼 데이터를 받아옵니다. (반환형식 object/string)<br/>
					arg1 : 받을 tag name value
				</div>
				<pre>
var result1 = myAXUpload.getFormData(); //FILES and FORM Collections
var result2 = myAXUpload.getFormData("name");  //individual item
				</pre>
			</div>
			<div class="returnType">
				object | string
			</div>
			<div class="methodExam" >
				object : 폼안의 모든 데이터를 오브젝트형으로 반환, {nm1:"인자를 던지지 않으면", nm2:"폼안의 모든값을", nm3:"오브젝트로 반환합니다",  ...}<br/>
				string : 지정된 값 반환
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
				<div class="desc">file upload sample form (반환형식 object)</div>
				<div class="sample">
					<form name="fileForm" id="fileForm" METHOD="POST" ENCTYPE="multipart/form-data" >
						<input type="file" name="file1" value="" class="fileInput" /><br/>
						<input type="file" name="file2" value="" class="fileInput" /><br/>
						<input type="file" name="file3" value="" class="fileInput" /><br/>

						<input type="text" name="text" id="AXInputPlaceHolder4" value="" class="AXInputSmall AXInputPlaceHolder" placeholder="input" /><br/>
						<textarea name="ta" rows="5" style="width:500px;">textarea</textarea>
					</form>
					<br/>
					<input type="button" value="submit" class="AXButton Red" onclick="fnObj.checkForm();" />

				</div>
			</div>
			<div class="methodExam" >
				<iframe name="iFrameFileUpload" id="iFrameFileUpload" src="" width="100%" height="150" frameborder="0" ></iframe>
				<%
				//var op0 = myAXFSO.getDriveList();
				//print("return value");
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="Hspace10"></div>
<%
%>
	</div>

</body>
</html>