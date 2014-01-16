<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>
<!--#include virtual="/_AXASP/AXJ.asp"-->
<!--#include virtual="/_AXASP/AXDB.asp"-->
<%
var strMSSql = "Provider= SQLOLEDB;Data Source=182.162.89.77;Initial Catalog=AXISJ_dev;User id=AXISJ;password=axisj!@#$";
var mydb = new AXDB();
mydb.setConfig({
	strConnection: strMSSql,		// 연결 문자열(필수 인자)
	debug: true						// 디버그 모드의 경우 에러가 발생할 때마다 에러내용을 출력해준다
	/*autoRollback: false*/			// 커밋 때 에러 발생 시 자동 롤백방지
});

var ret = mydb.open();

/* 에러처리 */
if ( isError(ret) ){
	println( ret.error.description );
	println( ret.msg );
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>AXDB</title>

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

	<!-- 메인 Division -->
	<div style="padding:20px;">

		<!-- 탭 Default -->
		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="#default" class="AXTab Blue on" id="default">Default</a>
				<a href="#manipulation" class="AXTab Blue">Manipulation</a>
				<a href="#transaction" class="AXTab Blue">Transaction</a>
				<a href="#sample" class="AXTab Blue">Sample</a>
				<div class="clear"></div>
			</div>
		</div>

		<h2>AXDB</h2>

		<!-- setConfig() -->
		<div class="method AXASP">
			<div class="methodName">
				setConfig( object )
			</div>
			<div class="methodDesc">
				<div class="desc">
					open()전에 반드시 실행되어야 하는 필수 항목 입니다<br /><br />
					속성 설명<br />
					strConnection : 커넥션 문자열<br />
					debug : 디버그 모드 사용 여부(에러 시 에러 메시지 자동 출력)<br />
					autoRollback : commitTrans() 함수 실행 시점에 에러가 있으면 자동 롤백<br />
				</div>
<pre>
&lt;%
mydb.setConfig({
	// debug: true,
	// autoRollback: false,
	strConnection: strMSSql
});
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>

		<!-- setDebug() -->
		<div class="method AXASP">
			<div class="methodName">
				setDebug( boolean )
			</div>
			<div class="methodDesc">
				<div class="desc">
					디버그 모드 동작, 에러 시점에 에러메시지가 자동으로 출력됩니다
				</div>
<pre>
&lt;%
mydb.setDebug( true );
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>

		<!-- open() -->
		<div class="method AXASP">
			<div class="methodName">
				open()
			</div>
			<div class="methodDesc">
				<div class="desc">디비를 연결 합니다 사전에 setConfig() 함수가 선행 되어야 합니다</div>
<pre>
&lt;%
var ret = mydb.open();
%&gt;
</pre>
			</div>
			<div class="returnType">
				object array
			</div>
			<div class="methodExam">
				성공<br />
				{ msg : "성공" }
				<br /><br />
				실패<br />
				{
					error: {
						code: "exception",
						description: "예외내용"
					},
					msg: "실패"
				}
			</div>			
		</div>

		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				close()
			</div>
			<div class="methodDesc">
				<div class="desc">디비를 닫습니다</div>
<pre>
&lt;%
mydb.close();
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace20"></div>


		<!-- 탭 Manipulation -->
		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="#default" class="AXTab Blue">Default</a>
				<a href="#manipulation" class="AXTab Blue on" id="manipulation">Manipulation</a>
				<a href="#transaction" class="AXTab Blue">Transaction</a>
				<a href="#sample" class="AXTab Blue">Sample</a>
				<div class="clear"></div>
			</div>
		</div>
	
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				getRows()
			</div>
			<div class="methodDesc">
				<div class="desc">
					레코드 셋을 오브젝트 배열로 받습니다.
				</div>
<pre>
&lt;%
var row = mydb.getRows( "SELECT memberNM, memberID FROM t_member" );

$.each( row, function(){
	print( "이름 : " + this.memberNM );
	print( "아이디 : " + this.memberID );
	print( "&lt;br /&gt;" );
});
%&gt;
</pre>
			</div>

			<div class="returnType">
				object array
			</div>
			<div class="methodExam">
				성공<br />
<%
	trace( mydb.getRows( "SELECT memberNM, memberID FROM t_member" ) );
%>
				<br /><br />
				실패<br />
				{
					msg: "getRows() 실패"
				}
			</div>
		</div>
		<div class="Hspace10"></div>



		<div class="method AXASP">
			<div class="methodName">
				command( object )
			</div>
			<div class="methodDesc">
				<div class="desc">
					ADODB.Command의 Wrapper함수 (더 자세한 내용은 ADODB 래퍼런스 참조)<br /><br />
					속성 설명 <br />
					CommandType : 프로시져 타입<br />
					CommandText : 프로시져 이름<br />
					parameter : 입력 또는 출력받을 변수 설정<br />
					returnValue : 리턴받을 요소를 기술<br /><br />
				</div>
<pre>
&lt;%
var arrRet = mydb.command(
{
	CommandType : adCmdStoredProc,
	CommandText : "USP_MemberInfo_P",
	parameter:[
		["@no", adInteger, adParamInput, 0, no],
		["@userid", adVarChar, adParamInput, 20, userid],
		["@addr", adVarChar, adParamInput, -1, addr],
		["@result", adChar, adParamOutput, 2],
		["@resultmsg", adChar, adParamOutput, 2]
	],
	returnValue: [
		"@result",
		"@resultmsg"
	]
});

var result = arrRet[0];
var ressultmsg = arrRet[1];
%&gt;
</pre>
			</div>
			<div class="returnType">
				object or object array
			</div>
			<div class="methodExam">
				성공<br />
				[{name: "홍길동", age: 20}, {name: "태권브이", age: 30}]
				<br /><br />

				실패<br />
				{
					error: {
						code: "exception",
						description: "예외내용"
					},
					msg: "Command 실패"
				}

			</div>
		</div>
		<div class="Hspace10"></div>



		<div class="method AXASP">
			<div class="methodName">
				insert( string, object )
			</div>
			<div class="methodDesc">
				<div class="desc">
					새로운 레코드를 추가합니다 <br/>
					arg1 : 테이블 이름 (string)<br/>
					arg2 : 필드에 입력할 내용 (object)<br/>
				</div>
<pre>
&lt;%	
var retInsert = mydb.insert( "t_member",
{
	memberLevel	: 1,
	memberID	: "snowwhite",
	memberNM	: "대따공주",
	memberPW	: "snow100",
	memberEmail	: "gonjoo@axisj.com",
	memberAddr	: "일곱난쟁이집",
	memberBirthday	: "2011-03-13"
});
%&gt;
</pre>

			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<div class="desc">
					성공<br />
					{msg : "insert 성공"}
					<br /><br />
					실패
					<br />
					{
						error: {
							code: "exception",
							description: "예외내용"
						},
						_tableName:"t_member",
						_objFields:{memberLevel	: 1,memberID	: "snowwhite",memberNM	: "대따공주",memberPW	: "snow100",memberEmail	: "gonjoo@axisj.com",memberAddr	: "일곱난쟁이집",memberBirthday	: "2011-03-13"}
						msg: "insert 실패"
					}

				</div>
			</div>			
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				update( string, object )
			</div>
			<div class="methodDesc">
				<div class="desc">
					새로운 레코드를 추가합니다 <br/>
					arg1 : 업데이트 조건 select문 (string)<br/>
					arg2 : 필드에 입력할 내용 (object)<br/>
				</div>
<pre>
&lt;%	
var retUpdate = mydb.update( "select * from t_member where memberID = 'bigprince'",
{
	memberLevel	: 1,
	memberID	: "bigprince",
	memberNM	: "대빡왕자",
	memberPW	: "prince100",
	memberEmail	: "bigprince@axisj.com",
	memberAddr	: "일곱난쟁이집",
	memberBirthday	: "2011-03-13"
});
%&gt;
</pre>

			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				<div class="desc">
					성공<br />
					{msg : "update 성공"}
					<br /><br />
					실패
					<br />
					{
						error: {
							code: "exception",
							description: "예외내용"
						},
						_tableName:"t_member",
						_objFields:{
							memberLevel	: 1,
							memberID	: "bigprince",
							memberNM	: "대빡왕자",
							memberPW	: "prince100",
							memberEmail	: "bigprince@axisj.com",
							memberAddr	: "일곱난쟁이집",
							memberBirthday	: "2011-03-13"
						}
						msg: "update 실패"
					}

				</div>
			</div>			
		</div>
		<div class="Hspace10"></div>		


		<div class="method AXASP">
			<div class="methodName">
				execute( string ), execute( string array )
			</div>
			<div class="methodDesc">
				<div class="desc">
					지정된 쿼리를 실행합니다 <br/>
					arg1 : 쿼리 문자열 또는 쿼리 문자열의 배열 <br/>
				</div>
<pre>
&lt;%
/* 문자열로 전달하는 경우 */
mydb.execute( "DELETE FROM t_member WHERE memberID = 'honggildong'" );

/* 배열 형태로 전달하는 경우 */
var arrQuery = [];
arrQuery.push( "UPDATE t_member SET memberNM = '일지매' WHERE memberName = '홍길동';" );
arrQuery.push( "UPDATE t_member SET memberNM = '존' WHERE memberName = '톰';" );
mydb.execute( arrQuery );
%&gt;
</pre>

			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				성공<br />
				{ msg: "실행 성공" }
				<br /><br />
				실패<br />
				{
				error: {
					code: "exception",
					description: "예외내용"
				},
				msg: "실행 중 문제발생"
			}
			</div>
		</div>
		<div class="Hspace20"></div>


		<!-- 탭 Transaction -->
		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="#default" class="AXTab Blue">Default</a>
				<a href="#manipulation" class="AXTab Blue">Manipulation</a>
				<a href="#transaction" class="AXTab Blue on" id="transaction">Transaction</a>
				<a href="#sample" class="AXTab Blue">Sample</a>
				<div class="clear"></div>
			</div>
		</div>

		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				beginTrans()
			</div>
			<div class="methodDesc">
				<div class="desc">
					트랜젝션을 시작한다 (commitTrans()이 실행 될 때까지)
				</div>
<pre>
&lt;%
mydb.beginTrans()
%&gt;
</pre>
			</div>


			<!--div class="returnType">
				object
			</div>
			<div class="methodExam">
				{ error: { code: "rollback" }, msg: "커밋 중 문제가 생겨 롤백 되었습니다" };
			</div-->
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				commitTrans()
			</div>
			<div class="methodDesc">
				<div class="desc">
					트랜잭션에 묶여있던 내용을 커밋(반드시 beginTrans()가 선행 되어야 한다)
				</div>
<pre>
&lt;%
mydb.commitTrans()
%&gt;
</pre>
				
				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"rollback" : 커밋 중 문제가 생겨 롤백 되었습니다<br />
					"nobegintrans" : 트랜젝션이 시작되지 않아서 커밋할 수 없습니다
					</div>
				</div>				
			</div>
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
			성공<br />
			{ msg: "커밋 성공" }
			<br /><br />
			실패<br />
			{
				error: {
					code: "rollback"
				},
				msg: "커밋 중 문제가 생겨 롤백 되었습니다"
			};

			<br /><br />
			기타<br />
			{		
				error: {
					code: "nobegintrans"
				},
				msg: "트랜젝션이 시작되지 않아서 커밋할 수 없습니다"
			};			
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				rollbackTrans()
			</div>
			<div class="methodDesc">
				<div class="desc">
					트랜젝션 롤백 <br />
					execute()등의 함수 실행 시 반환된 에러에 맞게 활용<br />
					최초 setconfig시 autoTollback의 인자가 true로 설정되어 있다면 문제 발생 시 자동으로 호출된다.
				</div>
<pre>
&lt;%
mydb.rollbackTrans()
%&gt;
</pre>				
				<div class="errorCode">
					<span>error.code value</span><br/>
					<div class="list">
					"notready" : 트랜젝션이 시작되지 않아서 롤백할 수 없습니다.
					</div>
				</div>
			</div>
			
			<div class="returnType">
				object
			</div>
			<div class="methodExam">
				성공<br />
				{ msg: "롤백 성공" }
				<br /><br />

				실패<br />
				{
					error: {
						code: "exception",
						description: e.description
					},
					msg: "예외발생"
				}
				<br /><br />
				
				기타<br />
				{
					error: {
						code: "notready"
					},
					msg: "beginTrans() 함수가 실행되지 않아서 롤백 되지 않았습니다"
				};
			</div>
		</div>
		<div class="Hspace20"></div>


		<!-- 탭 Sample -->
		<div class="AXTabs">
			<div class="AXTabsTray">
				<a href="#default" class="AXTab Blue">Default</a>
				<a href="#manipulation" class="AXTab Blue">Manipulation</a>
				<a href="#transaction" class="AXTab Blue">Transaction</a>
				<a href="#sample" class="AXTab Blue on" id="sample">Sample</a>
				<div class="clear"></div>
			</div>
		</div>
		
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				초기화
			</div>
			<div class="methodDesc">
				<div class="desc">AXDB를 사용할 준비를 합니다.</div>

<pre>
&lt;%
/*  mssql의 드라이버 또는 mysql의 드라이버 커넥션 문자열  */
var strMSSql = "Provider= SQLOLEDB;Data Source=서버주소;Initial Catalog=데이터베이스;User id=아이디;password=패스워드";
//var strMySql = "Driver={MySQL ODBC 3.51 //Driver};server=서버주소;database=데이터베이스;uid=아이디;pwd=패스워드;charset=euckr;port=3306";

/*  인스턴스 생성  */
var mydb = new AXDB();


/*  시작 및 환경설정  */
mydb.setConfig({
	strConnection: strMSSql
});

/*  디비 오픈  */
var ret = mydb.open();

/*  디비열기 시 에러처리  */
if( isError( ret ) ){
	println( ret.error.description );
	println( ret.msg );
}
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>


		<div class="method AXASP">
			<div class="methodName">
				해제
			</div>
			<div class="methodDesc">
				<div class="desc">모든 작업 후 해제합니다</div>
<pre>
&lt;%
mydb = null;
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>

		<div class="method AXASP">
			<div class="methodName">
				트랜젝션 예제
			</div>
			<div class="methodDesc">
<pre>
&lt;%
/*  트랜잭션 처리 시작  */
mydb.beginTrans();

var row = mydb.getRows( "SELECT memberNM, memberID FROM t_member" );

var retExecute = mydb.execute( "UPDATE t_member SET memberNM = '류재성' WHERE memberNo = 1;" );

/* beginTrans()가 시작된 후 이 구문까지의 트랜젝션을 한번에 커밋합니다 "
var retCommit = mydb.commitTrans();

/*  최초 생성 시 autoRollback이 true로 설정 되면 커밋 단계에서 자동 롤백 처리가 됩니다  */
if( isError( retCommit ) ){
	mydb.rollbackTrans();
}
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>
		

		<div class="method AXASP">
			<div class="methodName">
				에러처리 예제
			</div>
			<div class="methodDesc">
				<div class="desc">
					반환이 있는 모든 function은 에러에 대한 반환 값이 있습니다. 에러의 경우는 2가지가 있습니다.<br /><br />
					1. 예외 발생 에러<br />
					obj.error.code : "에러코드"<br />
					obj.error.description : "예외일 경우 예외에 대한 내용(예외 에러가 아닌경우 없을 수 있습니다)"<br />
					obj.msg : "에러내용"<br /><br />
					
					2. 실패 에러<br />
					obj.error.code 와 obj.msg는 존재하고 obj.error.description은 존재하지 않습니다.
				
				</div>
<pre>
&lt;%
var ret = mydb.getRows();

if( isError( ret ) ){
	println( ret.error.code );
	println( ret.error.description ); /* 실패 에러의 경우는 생략 됨 */
	println( ret.msg );
}
%&gt;
</pre>
			</div>
		</div>
		<div class="Hspace10"></div>		
	</div>
</body>
</html>
