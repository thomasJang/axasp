<!--METADATA TYPE= "typelib" NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<%
/*!
 * axisJ Javascript Library Version 1.0
 * http://axisJ.com
 *
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용 시 예상치 못한 피해가 발생 하실 수 있습니다.
 */

var AXDB = Class.create(AXJ, {
	version: "AXDB v0.9",
	author: "raniel(json@axisj.com)",

	NEWID: "AXDB_NEWID", 	// insert 시 자동증가 값이 아닌 필드의 최대 값을 구하기 위해 필요한 Static 변수
	NOW: "AXDB_NOW",		// 현재 시간을 yyyy-mm-dd hh:mi:ss 형태로 저장(datetime)

	logs: [
		"2013-03-04 오후 3:04:21",
		"2013-10-29 오후 3:14:00 getNewRecordNum(), NEWID 추가",
		"2013-10-30 오전 11:50:00 getCount(), NOW, remove(), 추가 ",
		"2013-11-04 오후 3:32 transaction() 함수 추가(인자로 넘긴 function을 한꺼번에 처리, beginTrans와 commitTrans를 한꺼번에)",
		"2013-11-05 once()추가 (open과 close를 자동으로 실행) onceTrans()추가 'once와 같지만 트랜잭션 처리 기능 추가",
		"2013-11-06 this.errorOccurred 추가 했음 insert실패 했는데도 디비 에러 카운트가 안 나와서 다음 update문이 실행되는 현상 때문에 변수 처리 했음"
	],

	initialize: function($super){
		$super();
		this.dbcon					= null;		// DB Connection
		this.rs						= null;		// Recordset
		this.connected 				= false;	// DB 오픈여부 플래그
		this.beginTransed			= false;	// 현재 트랜젝션 사용 여부
		this.errorOccurred			= false;	// 에러 발생 시 체크
		this.config.debug			= false;	// 디버그 모드
		this.config.autoRollback	= true;		// 커밋시에 에러가 발생하는 경우 자동적으로 롤백
		this.config.type 			= "mssql";	// db type 기본값
	},

	init: function(){
		//var cfg = this.config;
		//trace( cfg.strConnection );
	},

	// 디비 열기
	open: function(){
		this.dbcon = Server.CreateObject("ADODB.Connection");
		this.dbcon.Open( this.config.strConnection );
		this.connected = true;				
		//print( this.dbcon.Provider + "<br />");
		//print( this.dbcon.ConnectionString + "<br />");
		//print( this.dbcon.DefaultDatabase + "<br />");
		//print( this.dbcon.Mode + "<br />");
		return {
			msg: "성공"
		};
	},

	// 디비 닫기
	close: function(){
		if( this.connected ){
			this.dbcon.close();
			this.dbcon = null;
			this.connected = false;
		}
	},

	// open close 한 번에
	once: function(func){
		this.open();
		func.call(this);
		this.close();
	},

	// 디버그모드
	setDebug: function( _mode ){
		if( _mode == true || _mode == false ){
			this.config.debug = _mode;
		}
	},

	// 트랜젝션 단위를 function으로 전달받아서 처리
	transaction: function(func){
		this.beginTrans();
		func.call(this);
		return this.commitTrans();
	},

	onceTrans: function(func){
		this.open();
		this.beginTrans();
		func.call(this);
		var ret = this.commitTrans()
		this.close();
		return ret;
	},

	// 트랜젝션 시작
	beginTrans: function(){
		this.dbcon.BeginTrans();
		this.beginTransed = true;
	},

	// 트랜젝션 실행
	commitTrans: function(){
		var db = this.dbcon;

		// 트랜젝션이 시작 되었을 때
		if( this.beginTransed ){
			if(db.Errors.Count > 0 || this.errorOccurred){
				if( this.config.autoRollback ){ // 롤백 옵션이 있으면 자동 롤백한다
					this.rollbackTrans();
				}
				return {
					error: {
						code: "rollback"
					},
					msg: "커밋 중 문제가 생겨 롤백 되었습니다"
				};
			}else{
				db.CommitTrans();
				this.__resetTrans();
				return {
					msg: "커밋 성공"
				};
			}
		}else{
			this.pushLog( "Transaction이 시작되지 않아서 Commit할 수 없습니다." );
			return {
				error:{
					code: "nobegintrans"
				},
				msg: "트랜젝션이 시작되지 않아서 커밋할 수 없습니다"
			};
		}
	},

	// 트랜젝션 롤백
	rollbackTrans: function(){
		var db = this.dbcon;
		if( this.beginTransed ){
			try{
				db.RollbackTrans(); // 트랜젝션 실행 중이라면 롤백
				this.__resetTrans();
			}catch( e ){
				return {
					error: {
						code: "exception",
						description: e.description
					},
					msg: "예외발생"
				};
			}
		}else{
			return {
				error: {
					code: "notready"
				},
				msg: "beginTrans() 함수가 실행되지 않아서 롤백 되지 않았습니다"
			};
		}
		return {
			msg: "롤백 성공"
		};
	},

	// adodb.command wrapper function (before testing)
	command: function( _obj ){
		var db = this.dbcon;
		var param = _obj.parameter;
		var cntParameter = param.length;

		var cmd = Server.CreateObject("ADODB.Command");
		var arrRet = [];

		try
		{
			cmd.ActiveConnection = db
			cmd.CommandType = _obj.CommandType;
			cmd.CommandText = _obj.CommandText;

			for( var i = 0; i < cntParameter; i++)
			{
				if( param[i].length == 5)
				{
					cmd.Parameters.Append( cmd.CreateParameter( param[i][0], param[i][1], param[i][2], param[i][3], param[i][4] ) );
				}
				else if( param[i].length == 4)
				{
					cmd.Parameters.Append( cmd.CreateParameter( param[i][0], param[i][1], param[i][2], param[i][3] ) );
				}
			}
			cmd.Execute();

			var retVal = _obj.retVal;
			var lenRetVal = retVal.length;

			for( i = 0; i < lenRetVal; i++ ) arrRet.push( cmd.Parameters( retVal[i] ) );

		}catch( e ){
			this.pushLog( e.description );
			this.errorOccurred = true;
			return {
				error: {
					code: "exception",
					description: e.description
				},
				msg: "Command 실패"
			};
		}

		cmd = null;

		return arrRet;
	},

	// insert
	insert: function( _tableName, _objFields ){
		var db = this.dbcon;
		var _self = this;

		try{
			var rs = Server.CreateObject("ADODB.RecordSet");
			rs.open( _tableName, db, adOpenKeyset, adLockPessimistic, adCmdTable );
			rs.AddNew();
			$.each( _objFields, function(key, value){
				var _value;
				if(value == _self.NEWID){ // "AXDB_NEWID"
					_value = _self.getNewRecordNum(_tableName, key);
				}else if(value == _self.NOW){	// "AXDB_NOW"
					_value = new Date().print("yyyy-mm-dd hh:mi:ss");
				}else{
					_value = value;
				}
				rs.Fields(key) = _value;
			});
			rs.Update();
			rs.Close();
			rs = null;
			return {msg:"insert 성공"};
		}catch( e ){
			this.pushLog( e.description );
			this.errorOccurred = true;
			return {
				error: {
					code: "exception",
					description: e.description,
					tableName: _tableName, 
					objFields: _objFields
				},
				msg: "insert 실패"
			}
		}
	},

	// update
	update: function( _query, _objFields ){
		//try{
			var db = this.dbcon;
			var rs = Server.CreateObject("ADODB.Recordset");
			rs.open( _query, db, adOpenStatic, adLockOptimistic );
			if( !rs.EOF ){
				while( !rs.EOF ){
					$.each( _objFields, function(key, value){
						rs.Fields(key) = value;
					});
					rs.Update();
					rs.MoveNext();
				}
			}
			rs.Close();
			rs = null;
			return {msg:"update 성공"};
			/*
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code: "exception",
					description: e.description,
					_query:_query,
					_objFields:_objFields
				},
				message: "update 실패"
			}
		}
		*/
	},

	remove: function(tableName, condition){// 삭제 예) remove(member, "memberID = 'admin02')
		var query = "DELETE FROM " + tableName + " WHERE " + condition;
		//trace(query);
		return this.execute(query);
	},

	// 쿼리를 문자열로 또는 배열 문자열로 여러개를 보낼 수 있다
	execute: function( _query ){
		var db = this.dbcon;

		try{
			if( typeof _query == "object" ){
				var idx			= 0;
				var cntQuery 	= _query.length;

				for( ; idx < cntQuery; idx++ ){
					db.Execute( _query[idx] );
				}
			}else{
				db.Execute( _query );
			}
			
		}catch(e){
			this.pushLog( e.description );
			return{
				error: {
					code: "exception",
					description: e.description,
					query: _query
				},
				msg: "실행 중 문제발생"
			};
		}
		
		return {
			msg: "실행 성공"
		};
	},

	// 쿼리를 통해 행을 반환한다
	getRows: function( _query, _page ){

		var ret = null;
		var rs = Server.CreateObject("ADODB.recordset");

		if( this.config.type == "mssql"){
			rs.Open( _query, this.dbcon, adOpenStatic, adLockReadOnly, adCmdText );

			if( _page && !rs.eof ){
				rs.PageSize = _page.pageSize;
				rs.absolutePage = (_page.pageNo || 1);
			}
		}

		if( this.config.type == "mysql" ){
			var tmp_query = "";

			if( _page ){
				// 괄호로 감싸서 limit 추가 by raniel, 2013-06-07
				tmp_query = "SELECT * FROM (" + _query.replace(/;/, "") + ") alias LIMIT " + ( ( _page.pageNo - 1 ) * _page.pageSize ) + ", " + _page.pageSize;
			}else{
				tmp_query = _query;
			}

			rs.Open( tmp_query, this.dbcon, adOpenStatic, adLockReadOnly, adCmdText );
		}

		var jsonResult = [];

		if( _page && this.config.type == "mssql" ){
			
			var rsIndex = 0;

			while( !rs.EOF &&  rsIndex < _page.pageSize ){
				this.__getJSONFromRecordSet( rs, false, jsonResult );
				rs.MoveNext();
				rsIndex++;
			}

		}else{

			while( !rs.EOF ){
				this.__getJSONFromRecordSet( rs, false, jsonResult );
				rs.MoveNext();
			}

		}

		//print(_query + "<br>");
		
		if(_page){

			if( this.config.type == "mssql" ){
				ret = {
					list:jsonResult,
					page:{
						pageNo:(_page.pageNo || 1),
						pageCount:rs.pageCount,
						listCount:rs.recordcount
					}
				};
			}else if( this.config.type == "mysql" ){

				// 괄호로 감싸 COUNT 한다 by raniel, 2013-06-07
				//var tmp_query = _query.replace(/\slimit \d{1,},\s?\d{1,};?$/, "");
				var tmp_query = _query.replace(/\slimit .{1,}$/, ""); // 변경 by raniel, 2013-11-01
				tmp_query = "SELECT COUNT(*) FROM (" + tmp_query + ") alias";


				var rs_count = Server.CreateObject("ADODB.recordset");
				rs_count.Open( tmp_query, this.dbcon, adOpenStatic, adLockReadOnly, adCmdText );

				if( !rs_count.eof ){
					var total_count = rs_count.Fields.item(0).Value;
					var page_count = parseInt((total_count + (_page.pageSize - 1)) / _page.pageSize);

					ret = {
						list:jsonResult,
						page:{
							pageNo:(_page.pageNo || 1),
							pageCount:page_count,
							listCount:total_count
						}
					};

				}else{
					ret = {
						msg: "getRows() 실패"
					};
				}

				rs_count.close();

			}
		}else{
			ret = jsonResult;
		}
		rs.Close();
		rs = null;

		return ret;
	},
	
	getRow: function( _query ){
		var rs = Server.CreateObject("ADODB.recordset");

		try{
			rs.Open( _query, this.dbcon );
		}catch( e ){
			this.pushLog( e.description );
			this.errorOccurred = true;
			return{
				error: {
					code: "exception",
					description: e.description
				},
				msg: "getRow() 실패"
			};
		}
		var jsonRows = this.__getJSONFromRecord( rs, false );
		rs.Close();
		rs = null;

		return jsonRows;
	},

	// 자동증가 인덱스가 아닐 때 최대값 + 1 구해온다. 아직 mysql에선 테스트 해보지 않았음, 2013-10-29, json@axisj.com
	getNewRecordNum: function(tableName, fieldName){
		if(tableName == "" || fieldName == ""){return -1;}
		var nrnData = this.getRows("SELECT ISNULL(MAX("+fieldName+"), 0) + 1 nrn FROM "+tableName);
		return nrnData.first().nrn;
	},

	// 조건에 맞는 레코드 수 반환
	getCount: function(tableName, condition){
		var query = "SELECT COUNT(*) cnt FROM " + tableName + " WHERE " + condition;
		var rs = this.getRows(query);
		return rs[0].cnt;
	},

	레코드얻기: function( _query ){
		return this.getRows( _query );
	},

	// 로그 쌓기(debug 모드에서는 에러메시지 출력)
	pushLog: function( _strError ){
		this.logger.push( _strError );
		if( this.config.debug ) trace( _strError + "<br />");
	},


	// 트랜젝션 리셋
	__resetTrans: function(){
		this.beginTransed = false;
		//this.cntError = 0;
	},

	// Recordset를 JSON형태로 변환 _toEncode가 true일경우 문자열을 enc()해서 전달
	// 1개씩 push 해주는 방식으로 변경 by raniel, 2013-06-07
	__getJSONFromRecordSet: function( _rs, _toEncode, _jsonResult ){

		var fd		= _rs.Fields;
		var cntRS	= fd.Count;
		var stack	= {};
		var idx 	= 0;

		for( ; idx < cntRS; idx++ ){
			var value = fd.item(idx).Value;
			//print( "type : " + typeof fd.item(idx).Value + ", value : " + fd.item(idx).Value + "<br/>");
			if(typeof fd.item(idx).Value == "date"){
				value = new Date(fd.item(idx).Value).print("YYYY-MM-DD HH:MI:SS");
			}else if(typeof fd.item(idx).Value == "string"){
				value = value.enc();
			}
			//stack[ fd.item(idx).Name ] = _toEncode ? value.enc() : value; // encode option
			stack[ fd.item(idx).Name ] = value; // encode option
		}
		_jsonResult.push( stack );
			
	},

	__getJSONFromRecord: function( _rs, _toEncode ){
		var jsonResult = {};
		if(_rs.EOF) return {eof:true};
		while( !_rs.EOF ){
			var fd		= _rs.Fields;
			var cntRS	= fd.Count;
			var stack	= {};
			var idx 	= 0;
			for( ; idx < cntRS; idx++ ){
				var value = fd.item(idx).Value;
				if(typeof fd.item(idx).Value == "date"){
					value = new Date(fd.item(idx).Value).print("YYYY-MM-DD HH:MI:SS");
				}
				stack[ fd.item(idx).Name ] = _toEncode ? value.enc() : value; // encode option
			}
			jsonResult = stack;
			_rs.MoveNext();
		}
		return jsonResult;
	}

});
%>