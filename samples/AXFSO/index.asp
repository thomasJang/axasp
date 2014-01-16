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

<%
var myAXFSO = new AXFSO();
	myAXFSO.setConfig({
		debug: true
	});
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>AXFSO</title>

	<!-- css block -->
	<link rel="stylesheet" type="text/css" href="/html/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXJ.css" />
	<link rel="stylesheet" type="text/css" href="/_AXJ/ui/default/AXTabs.css" />
	<style type="text/css">
	H2, H3, H4{font-family:consolas;}
	.dottedLine{border-top:1px dotted #000;height:20px;}

	/*
	hr {margin-top:30px;}
	span.title {display:block;color:#cc0000;}
	*/

	</style>
	<!-- css block -->

	<!-- js block -->
	<script type="text/javascript" src="/_AXJ/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/_AXJ/lib/AXJ.js"></script>
	<script type="text/javascript" src="/_AXJ/lib/AXCodeArea.js"></script>

	<script type="text/javascript">
	var fnObj = {
		pageStart: function(){
			$(".AXscriptSource").bindCode();
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
				<a href="index.asp" class="AXTab Blue on" id="default">Default</a>
				<a href="#folderMethod" class="AXTab Blue">folder method</a>
				<a href="#fileMethod" class="AXTab Blue">file method</a>
				<div class="clear"></div>
			</div>
		</div>

		<h2>AXFSO</h2>

		<div class="method AXASP">
			<div class="methodName">
				초기화
			</div>
			<div class="methodDesc">
				<div class="desc">AXFSO 를 사용할 준비를 합니다.</div>
				&lt;%<br/>
				var myAXFSO = new AXFSO();<br/>
					myAXFSO.setConfig({<br/>
						debug: true<br/>
					});<br/>
				%&gt;
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				getDriveList()
			</div>
			<div class="methodDesc">
				<div class="desc">드라이브 리스트를 반환합니다. </div>
				&lt;%<br/>
				var op0 = myAXFSO.getDriveList();<br/>
				println(op0);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object array
			</div>
			<div class="methodExam">
				<% var op0 = myAXFSO.getDriveList();print(op0); %>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				getDriveInfo(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					해당 드라이브 정보를 반환합니다.<br/>
					arg1 : 드라이브 문자<br/>
				</div>
				&lt;%<br/>
				var op1 = myAXFSO.getDriveInfo("c");<br/>
				println(op1);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<% var op1 = myAXFSO.getDriveInfo("c:");print(op1); %>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				getMapPath([string])
			</div>
			<div class="methodDesc">
				<div class="desc">
					mappath 정보를 반환합니다.<br/>
					arg1 : path
				</div>
				&lt;%<br/>
				var mp = myAXFSO.getMapPath("\\samples\\FSO");<br/>
				println(mp);<br/>
				var mp1 = myAXFSO.getMapPath(".");<br/>
				println(mp1);<br/>
				var mp2 = myAXFSO.getMapPath("/");<br/>
				println(mp22);<br/>
				%&gt;
			</div>
			<div class="returnType">
				string
			</div>
			<div class="methodExam">
				<%
				var mp = myAXFSO.getMapPath("\\samples\\AXFSO");println(mp);
				var mp1 = myAXFSO.getMapPath("."); println(mp1);
				var mp2 = myAXFSO.getMapPath("/"); println(mp2);
				%>
			</div>
		</div>
		<div class="Hspace20"></div>

		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="#default" class="AXTab Blue">Default</a>
				<a href="#folderMethod" class="AXTab Blue on" id="folderMethod">folder method</a>
				<a href="#fileMethod" class="AXTab Blue">file method</a>
				<div class="clear"></div>
			</div>
		</div>
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				getFolderList(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더의 하위폴더리스트를 반환합니다.<br/>
					arg1 : 로컬경로<br/>
				</div>
				&lt;%<br/>
				var op2 = myAXFSO.getFolderList(mp);<br/>
				println(op2);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object array
			</div>
			<div class="methodExam">
				<%
				var op2 = myAXFSO.getFolderList(mp);println(op2);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				getFolderInfo(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더의 정보를 반환합니다.<br/>
					arg1 : 로컬경로<br/>
				</div>
				&lt;%<br/>
				var op3 = myAXFSO.getFolderInfo(mp);<br/>
				println(op3);<br/>
				var op3_1 = myAXFSO.getFolderInfo(myAXFSO.getMapPath("/"));<br/>
				println(op3_1);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op3 = myAXFSO.getFolderInfo(mp);println(op3);println("");
				var op3_1 = myAXFSO.getFolderInfo(myAXFSO.getMapPath("/"));println(op3_1);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				getFolderDetailInfo(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더의 세부정보를 반환합니다.<br/>
					arg1 : 로컬경로<br/>
				</div>
				&lt;%<br/>
				var op4 = myAXFSO.getFolderDetailInfo(mp);<br/>
				println(op4);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op4 = myAXFSO.getFolderDetailInfo(mp);println(op4);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				makeFolder(string, string[, boolean = false ])<br/>
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더의 세부정보를 반환합니다.<br/>
					arg1 : 폴더 생성위치<br/>
					arg2 : 폴더 이름<br/>
					arg3 : 같은이름이 있을경우 리네임설정<br/>

				</div>
				&lt;%<br/>
				var op5 = myAXFSO.makeFolder(mp, "FSO_TEST", false);<br/>
				println(op5);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"samefolder" : 같은이름의 폴더가 있습니다.<br/>
					"incorrectpath" : 폴더를 생성할경로가 존재하지 않습니다.<br/>
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op5 = myAXFSO.makeFolder(mp, "FSO_TEST", false);println(op5);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				deleteFolder(string[, boolean = false])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더를 삭제합니다.<br/>
					arg1 : 로컬폴더 위치<br/>
					arg2 : 파일이 있을경우 삭제여부 설정<br/>
				</div>
				&lt;%<br/>
				var op6 = myAXFSO.deleteFolder(mp+"\\FSO_TEST", false);<br/>
				println(op6);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"existfile" : 파일이 존재하기 때문에 폴더가 삭제되지 않았습니다.<br/>
					"incorrectpath" : 폴더를 삭제할 경로가 존재하지 않습니다.<br/>
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<% var op6 = myAXFSO.deleteFolder(mp+"\\FSO_TEST", false);println(op6); %>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				moveFolder(string, string[, boolean = false])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더를 이동합니다.<br/>
					arg1 : 원본 로컬폴더 경로<br/>
					arg2 : 이동할 경로<br/>
					arg3 : 이동 옵션(미구현)<br/>
				</div>
				&lt;%<br/>
				var op7 = myAXFSO.moveFolder(op2+"\\FSO_TEST\\2", op2+"\\FSO_TEST\\1\\");<br/>
				println(op7);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"samefoldername" : 이동할 경로에 같은이름을 가진 폴더가 있습니다.<br/>
					"incorrectpath" : 이동할 경로가 존재하지 않습니다.<br/>
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op7 = myAXFSO.moveFolder(mp+"\\FSO_TEST\\2", mp+"\\FSO_TEST\\1\\");println(op7);

				if (op7.error != undefined){
					println("<hr/>");
					println(op7.error.description);
				}

				var op7_1 = myAXFSO.moveFolder(mp+"\\FSO_TEST\\1\\2", mp+"\\FSO_TEST\\");
				%>
			</div>
		</div>
		<div class="Hspace10"></div>



		<div class="method AXASP">
			<div class="methodName">
				moveFolders(string, string[, string[, string, [boolean = false]]])
			</div>
			<div class="methodDesc">
				<div class="desc">
					해당경로의 폴더들(정규식가능)을 이동합니다.<br/>
					arg1 : 로컬폴더 경로<br/>
					arg2 : 이동할 경로<br/>
					arg3 : 정규식문자열<br/>
					arg4 : 정규식플래그<br/>
					arg5 : 이동 옵션(미구현)<br/>
				</div>
				&lt;%<br/>
				var op8 = myAXFSO.moveFolder(op2+"\\FSO_TEST\\2", op2+"\\FSO_TEST\\1\\");<br/>
				println(op8);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op8 = myAXFSO.moveFolders(mp+"\\FSO_TEST\\2", mp+"\\FSO_TEST\\1\\");println(op8);
				var op8_1 = myAXFSO.moveFolders(mp+"\\FSO_TEST\\1", mp+"\\FSO_TEST\\2\\");
				%>
			</div>
		</div>
		<div class="Hspace20"></div>

		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="#default" class="AXTab Blue">Default</a>
				<a href="#folderMethod" class="AXTab Blue" >folder method</a>
				<a href="#fileMethod" class="AXTab Blue on" id="fileMethod">file method</a>
				<div class="clear"></div>
			</div>
		</div>
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				getFileList(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더의 파일리스트를 반환합니다. <br/>
					arg1 : 로컬경로<br/>
				</div>
				&lt;%<br/>
				var op9 = myAXFSO.getFileList(mp);<br/>
				println(op9);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object array
			</div>
			<div class="methodExam">
				<%
				var op9 = myAXFSO.getFileList(mp);println(op9);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				getFileInfo(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 파일의 정보를 반환합니다.<br/>
					arg1 : 로컬경로<br/>
				</div>
				&lt;%<br/>
				var op10 = myAXFSO.getFileInfo(""+op9[0].fullPath);<br/>
				println(op10);<br/>
				%&gt;
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op10 = myAXFSO.getFileInfo(""+op9[0].fullPath);println(op10);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				makeFile(string, string[, boolean = false])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 경로에 파일을 생성합니다.<br/>
					arg1 : 로컬경로<br/>
					arg2 : 생성할 파일명<br/>
					arg3 : 덮어쓰기 옵션<br/>
				</div>
				&lt;%<br/>
				var op11 = myAXFSO.makeFile(mp+"\\FSO_TEST", "a.txt", false);<br/>
				println(op11);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"samefilename" : 같은이름의 파일이 있습니다.<br/>
					"incorrectpath" : 파일를 생성할경로가 존재하지 않습니다.
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op11 = myAXFSO.makeFile(mp+"\\FSO_TEST", "a.txt", false);println(op11);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				deleteFile(string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 경로에 파일을 삭제합니다.<br/>
					arg1 : 로컬경로<br/>
				</div>
				&lt;%<br/>
				var op12 = myAXFSO.deleteFile(mp+"\\FSO_TEST\\a.txt");<br/>
				println(op12);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"incorrectpath" : 삭제할 파일이 존재하지 않습니다.
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op12 = myAXFSO.deleteFile(mp+"\\FSO_TEST\\a.txt");println(op12);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>



		<div class="method AXASP">
			<div class="methodName">
				copyFile(string, string[, boolean = false])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 경로에 파일을 복사합니다.<br/>
					arg1 : 원본파일경로<br/>
					arg2 : 복사할경로<br/>
					arg3 : 덮어쓰기옵션<br/>
				</div>
				&lt;%<br/>
				var op13 = myAXFSO.copyFile(mp+"\\FSO_TEST\\guard.txt" , op2+"\\FSO_TEST\\", true );<br/>
				println(op13);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"samefilename" : 복사할 경로에 같은이름을 가진 파일이 있습니다.<br/>
					"incorrectpath" : 복사할 경로가 존재하지 않습니다.
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op13 = myAXFSO.copyFile(mp+"\\FSO_TEST\\guard.txt" , mp+"\\FSO_TEST\\", true );println(op13);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				moveFile(string, string[, boolean])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 경로에 파일을 이동합니다.<br/>
					arg1 : 로컬경로<br/>
					arg1 : 이동할 경로<br/>
				</div>
				&lt;%<br/>
				var op14 = myAXFSO.moveFile(mp+"\\FSO_TEST\\moveFile.txt" , mp+"\\FSO_TEST\\1\\");<br/>
				println(op14);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"samefilename" : 이동할 경로에 같은이름을 가진 파일이 있습니다.<br/>
					"incorrectpath" : 이동할 경로가 존재하지 않습니다.
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op14 = myAXFSO.moveFile(mp+"\\FSO_TEST\\moveFile.txt" , mp+"\\FSO_TEST\\1\\");println(op14);
				var op14_1 = myAXFSO.moveFile(mp+"\\FSO_TEST\\1\\moveFile.txt" , mp+"\\FSO_TEST\\");
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				moveFiles(string, string[, boolean = false])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 경로에 파일을 이동합니다.<br/>
					해당경로의 폴더들(정규식가능)을 이동합니다.(반환형식 object)<br/>
					arg1 : 로컬폴더 경로<br/>
					arg2 : 이동할 경로<br/>
					arg3 : 정규식문자열<br/>
					arg4 : 정규식플래그<br/>
					arg5 : 이동 옵션(미구현)<br/>
				</div>
				&lt;%<br/>
				var op15 = myAXFSO.moveFiles(mp+"\\FSO_TEST\\" , mp+"\\FSO_TEST\\2\\");<br/>
				println(op15);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"incorrectpath" : 이동할 경로가 존재하지 않습니다.
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op15 = myAXFSO.moveFiles(mp+"\\FSO_TEST\\" , mp+"\\FSO_TEST\\2\\" );println(op15);
				var op15_1 = myAXFSO.moveFiles(mp+"\\FSO_TEST\\2\\" , mp+"\\FSO_TEST\\" );
				%>
			</div>
		</div>
		<div class="Hspace10"></div>



		<div class="method AXASP">
			<div class="methodName">
				writeFile(string, int[, str[, int]])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 파일에 내용을 작성합니다.<br/>
					arg1 : 원본파일경로<br/>
					arg2 : 파일오픈모드1 <br/>
					<div class="argOption">
						2(ForWriting) - 쓰기 모드로 파일을 엽니다.<br/>
						8(ForAppending) - 파일을 열고 파일의 끝에 쓸 수 있습니다.<br/>
					</div>
					arg3 : 입력문자열<br/>
					arg4 : 파일오픈모드2 <br/>
					<div class="argOption">
						-2(TristateUseDefault) - 시스템 기본값으로 파일을 엽니다.<br/>
						-1(Tristatetrue) - 유니코드 형식으로 파일을 엽니다.<br/>
						0(Tristatefalse) - ASCII 형식으로 파일을 엽니다.<br/>
					</div>
				</div>
				&lt;%<br/>
				var writeStr = "입력할 문자열을 지정합니다. \n네";
				var op16 = myAXFSO.writeFile(mp+"\\FSO_TEST\\guard.txt" , 8, writeStr );<br/>
				println(op16);<br/>
				%&gt;

				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"incorrectmode" : 비정상적인 모드로 파일을 열었습니다.<br/>
					</div>
				</div>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var writeStr = "입력할 문자열을 지정합니다. \n네";
				//var op16 = myAXFSO.writeFile(mp+"\\FSO_TEST\\guard.txt" , 8, writeStr );println(op16);

				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				readFile(string[, int])
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 파일의 내용을 읽어옵니다.<br/>
					arg1 : 원본파일경로<br/>
					arg2 : 읽어올 라인넘버 <br/>
				</div>
<pre>
&lt;%
var writeStr = "입력할 문자열을 지정합니다. \n네";
var op17 = myAXFSO.readFile(mp+"\\FSO_TEST\\guard.txt");
println(op17);
var op17_1 = myAXFSO.readFile(mp+"\\FSO_TEST\\guard.txt", 3 );
println(op17_1);
%&gt;
</pre>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op17 = myAXFSO.readFile(mp+"\\FSO_TEST\\guard.txt");println(op17);println("");
				var op17_1 = myAXFSO.readFile(mp+"\\FSO_TEST\\guard.txt", 3 );println(op17_1);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				makeUniqueFileName(string, string)
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정한 폴더안에서 유일한 파일이름을(날자에 파일시퀀스를 더한값) 생성합니다.<br/>
					arg1 : 로컬경로<br/>
					arg2 : 파일이름<br/>
				</div>
<pre>
&lt;%
var op18 = myAXFSO.makeUniqueFileName(mp, "test.test.txt");println(op18);
println(op18);
%&gt;
</pre>
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<%
				var op18 = myAXFSO.makeUniqueFileName(mp, "test.test.txt");println(op18);
				%>
			</div>
		</div>
		<div class="Hspace10"></div>


<%
var aaa = "'";
print(aaa);
%>

	</div>

</body>
</html><input type="hidden"  />