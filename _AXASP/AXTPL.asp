<!--METADATA TYPE= "typelib" NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<%
/*!
 * axisJ Javascript Library Version 1.0
 * http://axisJ.com
 * 
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용기 예상치 못한 피해가 발생 하실 수 있습니다.
 */

var AXTPL = Class.create(AXJ, {
	version: "AXTPL v0.9",
	author: "raniel, json@axisj.com",
	logs: [
		"2013-03-04 오후 3:04:21"
	],
	
	initialize: function($super){
		$super();
		this.logger			= [];		// 에러 내용
		this.config.debug	= false;	// 디버그 모드
		this.fldTemplate	= "_template";
		this.fldCompile		= "_compile";
		this.template		= [];	
	},
	
	init: function(){
		//var cfg = this.config;
		//trace( cfg.strConnection );
	},
	
	// example1: "index", "index.tpl"
	// example2: { index: "index.tpl" }
	// example3: [ { index: "index.tpl" }, { main: "main.tpl" } ]
	define: function( _arg1, _arg2 ){
		//try{
		
			// 현재 경로파일로 부터 템플릿의 내용을 로드
			if( typeof _arg1 == "object" )
			{
				var lenArg1 = _arg1.length;
				if( lenArg1 > 0 )
				{
					for( var i = 0; i < lenArg1; i++ ){
						$.each( _arg1[i], function( k, v )
						{
							this.template[ k ] = this.loadContents( v );
							println( k + " : " + v );
						});
					}
				}
				else
				{
					$.each( _arg1, function( k, v ){
						//this.template[ k ] = this.loadContents( v );
						println( k + " : " + v );
					});	
				}
			}
			else
			{
				this.template[ _arg1 ] = this.loadContents( _arg2 );
			}
		//}catch( e ){
			//trace( e );
		//}
	}, 
	
	loadContents: function( _path ){
		// 경로를 받아서 그 경로의 파일을 읽어서 리턴
		var htmlString = "<html>" +
		"	<head>" +
		"		<title>{title}</title>" +
		"	</head>" +
		"	<body>" +
		"		<table>" +
		"		<tr>" +
		"			<td> 이름 </td>" +
		"			<td> 성별 </td>" +
		"			<td> 나이 </td>" +
		"		</tr>" +
		"		<!--{@list}-->" +
		"		<tr>" +
		"			<td> {name} </td>" +
		"			<td> {sex} </td>" +
		"			<td> {age} </td>" +
		"		</tr>" +
		"		<!--{/}-->" +
		"		</table>" +
		"	</body>" +
		"</html>";
		
		
		
		
		// test
		if( _path == "index.tpl" || _path == "main.tpl" ) return htmlString;
		//return "<html><head><title>{title}</title></head><body>{content}</body></html>";
	},
	
	assign: function( _arg1, _arg2 ){
		// 템플릿 파일을 변경
	},
	
	write: function( _arg1 ){
		// 출력
	}
});

	// example
	var tpl = new AXTPL();
	
	tpl.setConfig({
		debug: true						// 디버그 모드의 경우 에러가 발생할 때마다 에러내용을 출력해준다
	});
	
	//println( tpl.loadContents("index.tpl") );
	
	//tpl.define( "index", "index.tpl" );
	//tpl.define( [{ index : "index.tpl" }, { main : "main.tpl" }] );
	//tpl.define( { index : "index.tpl" } );
	//tpl.assign({ title : "제목", content : "들어갈 내용"});
	//tpl.write( "index" );

	var r;
	var cntShow = 0;
	var show = function(el){
		cntShow++;
		println( cntShow + " : " + el );
	};

	/*
	var a = 'ABC'.match(/(A)/);
	var b = '12_34_12'.search(/^34/);
	show(a);
	show(b);
	
	
	r = 'sports'.match(/sp/);
	show(r);
	
	var param = /sp/i;
	r = 'sports'.match(param);
	show(r);
	*/
	/*
	var regexp = new RegExp('sp', 'i');
	r = regexp.test('sports');
	show(r)
	
	r = new RegExp('sp', 'i').test('sports');
	show(r);
	
	regexp = RegExp('sp', 'i');
	
	regexp = new RegExp('sp', 'i');
	show(regexp);
	*/
	
	//show( 'sports'.match(/s/) );
	
	//show( 'JavaScript'.match(/s/i) );
	
//	var value = 'JavaScript\nMultiLine\nMultiLine';
//	
//	r = value.match(/^Multi/);
//	show(r);
//	
//	r = value.match(/^Multi/m);
//	show(r);
//	
//	r = value.match(/^Multi/g);
//	show(r);
//	
//	r = value.match(/^Multi/gm);
//	show(r);
//	
//	r = value.match(/Multi/);
//	show(r);
//	
//	r = value.match(/multi/igm);
//	show(r);

	
//	r = '12_34_56'.match(/23|34|56/);
//	show( r );
//	
//	r = '12_34_56'.match(/23|56|34/);
//	show( r );
//	
//	r = /bc|c/.exec("abc");
//	show( r );
//	
//	r = /c|bc/.exec("abc");
//	show( r );
//	
//	r = /c|bc|abc/.exec("abc");
//	show( r );
//
//	// a와 abc의 인덱스가 같지만 a가 먼저 나왔기 때문에 a가 출력된다	
//	r = /c|bc|a|abc/.exec("abc");
//	show( r );
//
//	// 글로벌을 설정하면 모두 매칭시킨다
//	r = '12_34_56'.match(/12|34|56/g);
//	show( r );

//	// s앞에 한자라도 와야하므로 ts가 출력
//	r = 'sports'.match(/.s/);
//	show( r );
//	
//	// sp 출력
//	r = 'sports'.match(/s./);
//	show( r );
//	
//	// 사랑해,사모해 출력
//	r = '사랑해 사모해 사랑함'.match(/사.해/g);
//	show( r );
	
	// 공백 문자(white space)
	
//	\u0009 탭(수평 탭)
//	\u000B 수직 탭
//	\u000C 폼 넘김
//	\u0020 공백
//	\u00A0 자동 줄 바꿈 방지
	
	// 매치 된다 그러므로 공백(탭)이 출력 만약 매치 되지 않았다면 null이 출력 됐을 것이다
//	r = '\u0009'.match(/\t/);
//	show( r );
//	
//	r = '\u000c'.match(/\f/);
//	if( r ){
//		show('공백 문자');
//	}

	// 줄 분리자
//	\u000A 줄 바꿈				Line Feed			<LF>	\n
//	\u000D 줄 바꿈(첫 위치)		Carriage Return		<VR>	\r
//	\u2028 줄 분리자			Line Separator		<LS>
//	\u2029 구문 분리자			Paragraph Separator	<PS>

//	r = '\u000A'.match(/\n/);
//	if(r) show('줄 분리자');
	
	// match
//	r = 'Sports'.match(/s/);
//	for(var i=0; i<r.length; i++){
//		show( r[i] );
//	}
//	show( r.index );
//	show( r.input );
//	
//	function returnValue(){
//		return 'method';
//	}
//	
//	r = returnValue().match(/met/);
//	
//	for(var i=0; i<r.length; i++){
//		show(r[i]);
//	}
//	
//	r = 'StringClass'.match('s', 'g');
//	show(r);


	// 인덱스 추출 search()
	
	// 인덱스의 위치를 반환
//	r = 'Sports'.search(/s/);
//	show(r);
//	
//	r = 'Class'.search(/s/g);
//	show(r);
//	
//	// 매치되지 않으면 -1을 반환
//	r = 'Class'.search(/K/);
//	show(r);
//	
//	r = 'Class'.search('s');
//	show(r);
	
	
	// 매치 결과 분리 split()
//	r = '12_34_56'.split('_');
//	show(r);
//	
//	r = '12_34_56'.split(/_/);
//	show(r);
//	
//	r = '12_34_56'.split('S');
//	show(r);
//	
//	r = '12_34_56'.split();
//	show(r);
//	
//	r = '12_34_56'.split('');
//	show(r);
//	
//	r = '_12_34'.split('_');
//	show(r);
//	
//	r = '_12_34'.split(/_/);
//	show(r);
//	
//	r = '12A34A56'.split(/(A)/);
//	show(r);
//	
//	// 2개만 반환 한다
//	r = '12_34_56'.split('_', 2);
//	show(r);

	// 값 치환 replace()
	
//	r = '12_34_12'.replace('12', 77);
//	show(r);
//	
//	// 모든 12를 77로 치환
//	r = '12_34_12'.replace(/12/g, 77);
//	show(r);
//	
//	function returnValue(){
//		return 'AA';
//	}
//	
//	r = '12_34_12'.replace(/12/g, returnValue());
//	show(r);

	
	// 매치 여부 test()
//	r = /12/.test('12_34_12');
//	show(r);

	// 하나만 매치 exec()
//	r = /12/.exec('12_34_12');
//	show(r)
//	show(r.index);
//	show(r.input);

//	r = /12/g.exec('12_34_12');
//	show(r);
//	
//	r = /a/i.exec('ABAB');
//	show(r);


	// 처음부터 매치 ^
//	r = '12_34_12'.search(/^34/);
//	show(r);
//	
//	r = '12_34_12'.search(/^12/);
//	show(r);
//	
//	var value = 'first\u000aStart\u000aStart';
//	r = value.search(/^Start/);
//	show(r);
//	
//	r = value.search(/^Start/m);
//	show(r);

	// 끝에 매치 $
//	r = '12_34_12'.search(/34$/);
//	show(r);
//	
//	r = '12_34_12'.search(/12$/);
//	show(r);
//	
//	var value = 'ccStart\u000aStart\u000aStart';
//	r = value.search(/Start$/);
//	show(r);
//	
//	r = value.search(/Start$/m);
//	show(r);
//	
//	startEnd = '';
//	r = startEnd.search(/^$/);
//	show(r);
	
	// 63개 문자 매치 \B
	
//	r = 'A12A 12B 12A'.match(/12\B/g);
//	show(r);
//	
//	r = 'A12 B12 12'.match(/12\B/g);
//	show(r);
//	
//	r = 'A12 12 C12'.match(/\B12/g);
//	show(r);
//	
//	r = 'A12 12 C12'.match(/\B12\B/g);
//	show(r);
//	
//	r = 'A12B C12D E12F'.match(/\B12\B/g);
//	show(r);
	
	
	// 단어 경계 \b
//	r = 'A12A 12B 12A'.match(/12\b/g);
//	show(r);
//	
//	r = 'A12 12B 12C'.match(/12\b/g);
//	show(r);
//	
//	r = 'A12 12B 12 '.match(/12\b/g);
//	show(r);
//	
//	r = '표현 표현 표현'.match(/표현\b/g);
//	show(r);
//	
//	r = '12표현 표현12표현 12표현'.match(/12\b/g);
//	show(r);
//	
//	r = 'A급 '.match(/A급\b/);
//	show(r);
//	
//	r = 'A와B '.match(/A와B\b/);
//	show(r);
//	
//	r = 'A12 12 C12'.match(/\b12/g);
//	show(r);
//	
//	r = '12 12 C12'.match(/\b12/g);
//	show(r);
//	
//	r = 'A12 12 C12'.match(/12\b/g);
//	show(r);
	
	// 수량자
//	+				하나 이상 매치
//	*				없거나 하나 이상 매치
//	?				없거나 하나만 매치
//	{숫자}			수에 매치
//	{숫자,}			수 이상에 매치
//	{숫자,숫자}		숫자 매치 구간 지정
//	+?				한 번만 매치
//	*?				최소 매치
//	{숫자,숫자}?	숫자 범위 무시
	
	
	// 욕심 많은 매치(Greedy Match)
//	value = 'aaaaac';
//	r = value.match(/a/);
//	show(r);
//	
//	r = value.match(/a+/);
//	show(r);
//	
//	r = 'aab aac'.match(/a/g);
//	show(r);
//	
//	r = 'aab aac'.match(/a+/g);
//	show(r);
//	
//	r = 'aab aac'.match(/K+/);
//	show(r);
//	
//	r = 'abcdefg'.match(/.+/);
//	show(r);
//	
//	// abcA
//	r = 'abcABC'.match(/.+A/);
//	show(r);
//	
//	// abcAB
//	r = 'abcABC'.match(/.+AB/);
//	show(r);
	
	// 없거나 하나 이상 매치
//	r = 'aaaaaC'.match(/a*/);
//	show(r);
//	
//	r = 'aaaaaC'.match(/k*/);
//	show(r);
//	show(r.index);
//	
//	r = '12ab_12efg'.match(/12c*/g);
//	show(r);
//	
//	r = '123ab_12efg'.match(/123c*/g);
//	show(r);
//	
//	r = 'abc_123'.match(/123c*/g);
//	show(r);
//	
//	r = '12A 12c'.match(/12c*/g);
//	show(r);
//	
//	r = 'CaaBaaa'.match(/a+/);
//	show(r);
//	
//	r = 'CaaBaaa'.match(/a*/);
//	show(r);
//	show(r.index);
//	
//	r = 'abcde'.match(/.*/);
//	show(r);
//	
//	r = 'abcdABC'.match(/.*AB/);
//	show(r);
//	
//	r = ''.match(/.*/);
//	show(r);
//	
//	r = 'BaaCaaa'.match(/a*/g);
//	show(r);
//	show(r.length);

	// 없거나 하나만 매치 ?
//	r = 'abcAAA'.match(/abcs?/);
//	show( r );
//	
//	r = 'abcsss'.match(/abcs?/);
//	show( r );
//	
//	r = 'abcsssA'.match(/abcs?A/);
//	show( r );
//	
//	r = 'abcsssA'.match(/abcs*A/);
//	show( r );
//	
//	r = 'abcdABC'.match(/.?AB/);
//	show( r );
//	
//	r = ''.match(/.?/);
//	show( r );
	
	// 숫자로 매치 범위 지정
//	r = 'aaa'.match(/a{2}/);
//	show( r );
//	
//	r = 'aaa'.match(/a{4}/);
//	show( r );
//	
//	r = 'aaaKK'.match(/a{2}K/);
//	show( r );


	// 수 이상에 매치 {숫자,}
	
//	// a 적어도 1개 이상
//	r = 'aaa'.match(/a{1,}/);
//	show( r );
//	
//	// a 적어도 4개 이상
//	r = 'aaa'.match(/a{4,}/);
//	show( r );
//	
//	r = 'aaaBB'.match(/a{2,}B/);
//	show( r );
	
	
	// 매치된 것 모두 반환
//	r = 'aaaBB'.match(/a{2,}B/);
//	show( r );
//	
//	// 매치 구간 지정 {숫자,숫자}
//	// a가 2번에서 4번이하로 나와야 한다
//	r = 'aaaaa'.match(/a{2,4}/);
//	show( r );
//	
//	// a가 0~2번 나와야한다
//	r = 'ccc'.match(/a{0,2}/);
//	show( r );
	
	
	// 욕심 없는 매치(none-greedy match)
	
	// 한 번만 매치 +?
//	r = 'aaaaac'.match(/aa+/);
//	show( r );
//	
//	// 한번만 매치
//	r = 'aaaaac'.match(/aa+?/);
//	show( r );
	
	
	// 최소 매치
//	r = 'abcabc'.match(/abc*/);
//	show( r );
//	
//	// 패턴문자 *?가 c를 최소로 매치하려는 것에 기인하여 ab가 출력된다
//	r = 'abcabc'.match(/abc*?/);
//	show( r );
//	
//	r = 'abcabc'.match(/abQ*?/);
//	show( r );
//	
//	r = 'aaaaa'.match(/a*/);
//	show( r );
//	
//	r = 'aaaaa'.match(/a*?/);
//	show( r );
//	show( r.index );
//	
//	r = 'aaaKK'.match(/a*K/);
//	show( r );
//	
//	result = 'aaaKK'.match(/a*?K/);
//	show( r );

	// 앞에서부터 매치
//	r = 'aaaaa'.match(/a*/);
//	show( r );
//	
//	r = 'aaaaa'.match(/a*?/);
//	show( r );
//	show( r.index );
	
//	r = 'aaaKK'.match(/a*K/);
//	show( r );
//	
//	// 욕심없는 패턴 문자 *?는 앞에서부터 매치한다 그래서 aK가 아닌 aaaK가 반환된다
//	r =	'aaaKK'.match(/a*?K/);
//	show( r );
	
	// 숫자 범위 무시 {숫자,숫자}?
	
//	r = 'aaaaa'.match(/a{1,}/);
//	show( r );
//	
//	r = 'aaaaa'.match(/a{1,}?/);
//	show( r );
//	
//	r = 'aaaaa'.match(/a{1,5}/);
//	show( r );
//	
//	r = 'aaaaa'.match(/a{1,5}?/);
//	show( r );


	// 문자클래스
//	r = 'abcde'.match(/[ ]/);
//	show( r );
//	
//	// a 또는 b 또는 k가 있으면 반환
//	r = 'abcde'.match(/[abk]/);
//	show( r );
//	
//	r = 'abcde'.match(/[bac]/);
//	show( r );
//	
//	r = 'abcde'.match(/[cak]/g);
//	show( r );
//	
//	r = '정규표현식'.match(/[정표]/g);
//	show( r );
	
	// 패턴 문자를 문자화
	// +를 패턴으로 인식하므로 111이 출력
//	r = '111'.match(/1+/);
//	show( r );
//	
//	// []안에 있는 +는 문자이므로 '1' 또는 '+'을 의미한다
//	r = '111'.match(/[1+]/);
//	show( r );
//	
//	r = '+++'.match(/[1+]/);
//	show( r );
	
	// 백스페이스 [\b]
//	r = '2**  '.match(/2\b/);
//	show( r );
//	
//	r = /[\b]/.test('\u0008');
//	show( r );
//	
//	
//	// 구간 [-]
//	r = '54321'.match(/[0-9]/);
//	show( r );
//	
//	// Syntax Error 큰 값을 먼저 작성하면 에러난다
//	//r = '12345'.match(/[9-0]/);
//	//show( r );
//	
//	// a에서 e까지 해당 되는 모두
//	r = 'cdbd'.match(/[a-e]/g);
//	show( r );
//	
//	// 가에서 라까지 해당되는 모두
//	r = '가나다라'.match(/[가-라]/g);
//	show( r );
	
	//[-문자] 형태
	
	// 대괄호([]) 안에 -3에서 -는 문자 하이픈으로서의 의미를 지닌다 1-3와 같은 형태만 범위를 표현한다
//	r = '7321'.match(/[-3]/);
//	show( r );
//	
//	r = '721'.match(/[-3]/);
//	show( r );
//	
//	r = '-321'.match(/[-3]/);
//	show( r );


	// 대소문자 구분
//	r = 'AB*^cd'.match(/[A-D]/ig);
//	show( r );
//	
//	// A와 d사이에 기호도 포함되어 있다
//	r = 'AB[\^]"+cd'.match(/[A-d]/ig);		//"
//	show( r );
//	
//	// 영문 대소문자, 숫자 매치
//	r = 'aA1'.match(/[A-Za-z0-9]/g);
//	show( r );
	
	// CSS 프로퍼티 형태 변경 (하이픈 다음에 a부터 z까지의 문자가 오는 패턴을 선택하고 변경한다)
//	r = 'border-bottom-color'.replace(/-[a-z]/ig, function(cvt){
//		return cvt.charAt(1).toUpperCase(); // 1번 인덱스의 내용을 대문자로 변경한다
//	});
//	show( r );
	
	
	// 제외 [^]
//	r = 'abcd'.match(/[^a]/);	// b
//	show( r );
//	
//	r = 'abcde'.match(/[^acd]/);	// b
//	show( r );
//	
//	r = '1525'.match(/[^1-2]/);		// 5
//	show( r );
//	
//	r = '정규표현식'.match(/[^정표]/g);	// 규,현,식
//	show( r );
	
	
	// 텍스트 값 추출
//	var stripTags = function(base){
//		return base.replace(/<\/?[^>]+>/ig, '');
//	};
//	
//	r = stripTags('<div id="sports">축구</div>');
//	show( r );
	
	
	// 독식을 막아라
//	var reg = 'RegExp 1239 Count';
//	r = reg.match(/.*[0-5][6-9]/);
//	show( r );
//	
//	r = reg.match(/.*[0-5][1-5]/);
//	show( r );
	
	
	// 이스케이프 문자 클래스
	
//	\d		숫자만 매치
//	\D		숫자 이외 매치
//	\s		보이지 않는 문자 매치
//	\S		보이지 문자 매치
//	\w		63개 문자만 매치
//	/W		63개 이외 문자 매치
//	\uhhhh	유니코드 값으로 매치
//	\xhh	16진수 값으로 매치
//	\c		제어문자
	
	// 패턴 문자의 문자화
//	r = '^ABC'.match(/^A/);
//	show( r );
//	
//	r = 'B^AC'.match(/\^A/);
//	show( r );
//	
//	r = '\\ab'.match(/\\/);
//	show( r );
//	
//	r = '\\^'.match(/\\\^/);
//	show( r );
//	
//	r = new RegExp('\^A').exec('ABC');
//	show( r );
//	
//	r = new RegExp('\\^B').exec('A^BC');
//	show( r );
	
	
	// 숫자 매치
//	r = 'A123'.match(/\d/);
//	show( r );
//	
//	var num = /^\d+$/; // 시작하고 바로 숫자가 나와야 하므로 null 출력
//	r = 'A123'.match(num);
//	show( r );
//	
//	r = '123'.match(num);
//	show( r );

	// 숫자 이외 매치 ( \D )
//	r = '1A표현23'.match(/\D/);
//	show( r );
//	
//	r = '1A표현23'.match(/\D/g);
//	show( r );
//	
//	var alpha = /^\D+$/;
//	r = 'ABC3'.match(alpha); // 마지막 까지 숫자가 아닌 것이 나와야하는데 숫자가 나왔으므로 null
//	show( r );
//	
//	r = 'ABC'.match(alpha);
//	show( r );


	// 문자 매치
	
	// 보이지 않는 문자 매치 \s (공백 문자 white space, 줄 구분 line terminator)
//	r = 'az'.match(/\s/);
//	show( r );
//	
//	r = '\u0009'.match(/\s/);
//	if( r ){
//		show('u0009');
//	}
	
	// 문자열 앞뒤 공백 삭제
//	var value = ' abcde ';
//	show( value.length );
//	
//	value = value.replace(/^\s+|\s+$/g, '');
//	show( value );
//	show( value.length );
	
//	^	첫 문자에 매치
//	\s	보이지 않는 문자 매치
//	+	하나 이상 매치
//	|	대체
//	\s	보이지 않는 문자 매치
//	+	하나 이상 매치
//	$	끝 문자에 매치

//	/^\s+|\s+$/ 가운데 패턴 문자 대체(|)를 기준으로 나눌 수 있다. 패턴 문자 대체는 OR 조건이 아니다.
	
	// 보이는 문자 매치 \S
//	r = '\u0009\u0061'.match(/\S/); // 탭과 a
//	show( r );
//	
//	r = '한글'.match(/\S/);
//	show( r );
	
	// 63개 문자 매치 (영문 대/소문자, 숫자, 언더바)
//	r = '%_aA1'.match(/\w/g);
//	show( r );
//	
//	// 63개 이외 문자 매치
//	r = '%&_aA1'.match(/\W/g);
//	show( r );
//	
//	r = '#12'.match(/[\w]/);
//	show( r );
//	
//	r = '#12'.match(/[w]/);
//	show( r );
//	
//	r = '34#'.match(/[\W\w]/);
//	show( r );
	
	// 이메일 주소 체크
//	var email = /^[\w][\w-\.]+@[\w]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,3|)$/i;
//	r = email.test('abcd@efgh.co.kr');
//	show( r );
//	
//	^[\w]		첫 문자는 63개 문자로 시작해야 한다
//	[\w-\.]+	63개 문자(\w), 하이픈, 점을 반드시 하나 이상 작성해야한다 
//	@[\w]+		@는 전자 메일 주소를

%>