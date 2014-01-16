<%
/*
 * axisASP Library Version 1.0
 * http://axisJ.com
 *
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용기 예상치 못한 피해가 발생 하실 수 있습니다.
 *
 */


var AXBoard = Class.create(AXJ, {
	version: "AXBoard v1.0",
	author: "root@axisj.com",
	logs: [
		"2013-06-04 오후 9:16:42 - 시작"
	],
	initialize: function($super) {
		$super();
		//this.FSO = new ActiveXObject("Scripting.FileSystemObject");

		this.config.debug = false;
		this.config.tableName = "T_board";
		this.config.tableNo = "4";
		this.config.account = {mNo:-1 , auth:0},		//로그인과 연동
		this.config.useComment = false;
		this.config.reply = false;
		this.config.stringDecode = false;
		this.config.cntObj = {listCnt:20,pagingCnt:10};
		this.config.authLevel = {view:0, write:1, reply:1, comment:1};
		this.config.pageWidth = "900";
		this.config.paramObj = {pageNo: 1, chk: "", setext: "", stPage: 1};
		

		this.vg_link = ""		//버튼링크 Pars
		this.pg_link = ""		//페이지이동 Pars
		
		this.boardInfo = {};
		this.contrlAllow = 0;
		this.cancelScript = false;
		this.list = [];
		this.article = {};
		this.isAdmin = false;
		this.end = false;
	},

	init: function(){
		var cfg = this.config;
		if (cfg.account.auth == 9) this.isAdmin = true;

		var query = "select * from T_boardInfo where tableNo = '" + cfg.tableNo + "'";
		var row = axisDB.getRow(query);

		if (!row.eof){
			this.boardInfo = row;	//어따가 쓸거?
			cfg.authLevel.view = row.readAuth;
			cfg.authLevel.write = row.writeAuth;
			cfg.authLevel.reply = row.replyAuth;
			cfg.authLevel.comment = row.commentAuth;

		}else{
			this.end = true;
			
			var po = [];
			po.push("<div style='text-align:center;padding:20px;border:1px solid #ccc;' class='BBF'>");
			po.push("테이블 설정이 맞지 않습니다.</br></br>");
			po.push("setConfig시에 지정된 tableName, tableNo를 확인해주세요");
			po.push("</div>");

			print(po.join(''));
		}
	},

	setBoard: function(paramObj){
		if (!this.end){

			var cfg = this.config;
	
			if (paramObj != undefined){
				this.config.paramObj = paramObj;
			}
	
			this.setLinkParameter();
	
			paramObj.method = paramObj.method.toLowerCase();
	
			if (paramObj.method == "write"){
				myBoard.getWritePage();
			}else if (paramObj.method == "modify"){
				myBoard.getWritePage();
			}else if (paramObj.method == "reply"){
				myBoard.getWritePage();
			}else if (paramObj.method == "view"){
				myBoard.getViewPage();
			}else if (paramObj.method == "list"){
				myBoard.getListPage();
			}else{
				//list
				myBoard.getListPage();
	
				/*
				if (paramObj.pages == 0){
					if (paramObj.docuNo == 0){
						myBoard.getListPage();
					}else{
						myBoard.getViewPage();
					}
				}else{
					myBoard.getWritePage();
				}
				*/
			}
		}

	},

	setLinkParameter: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;

		this.vg_link = "pageNo=" + paramObj.pageNo + "&amp;stPage=" + paramObj.stPage + "&amp;chk=" + paramObj.chk + "&amp;setext=" + paramObj.setext;
		this.pg_link = "chk=" + paramObj.chk + "&amp;setext=" + paramObj.setext;
	},

	__________list: function(){},
	getListPage: function(){
		var cfg = this.config;
		/* check : po를 계속 넘겨야 하나*/
		this.setListHead();
		this.getListItem();
	},

	setListHead: function(){
		var cfg = this.config;
		var po = [];
		po.push("<table width='100%' cellspacing='0' class='BoardType01 BBF'>");
		po.push("<colgroup>");
		$.each(cfg.colGroup, function(idx, o){
			var tmpWidth = (o.width != undefined) ? " style='width:"+o.width+"px;' " : " ";
			po.push("<col ", tmpWidth, "/>");
		});
  		po.push("</colgroup>");
  		po.push("<thead><tr>");
  		$.each(cfg.colGroup, function(idx, o){
  			var tmpAlign = (o.align != undefined) ? "style='"+o.align+"'" : "";

  			if (idx == 0){
  				po.push("<td class='tl' ", tmpAlign, ">", o.label, "</td>");
  			}else if (parseInt(idx) == parseInt(cfg.colGroup.length-1) ) {
  				po.push("<td class='tr' >", o.label, "</td>");
  			}else{
  				po.push("<td>", o.label, "</td>");
  			}
		});
  		po.push("</tr></thead>");

  		print(po.join(''));
	},

	getQuery: function(method, extraParamObj){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var epo = extraParamObj;
		var query = [], addQuery = '';

		if (method == "selectNoticeList"){
			query.push("SELECT B.docuNo, B.sortNo, B.categoryNo, B.title, B.depth, B.regiDate, B.IP, writer ");
			query.push("	,(select count(docuNo) from ", cfg.tableName, "Logs L where tableNo = '", cfg.tableNo, "' and B.docuNo = L.docuNo) as rcnt ");
			query.push("	,(select count(seq) from ", cfg.tableName, "Comment C where tableNo = '", cfg.tableNo, "' and B.docuNo = C.docuNo) as ccnt ");
			query.push("	,(select count(seq) from T_fileSystem F where parentType = 'B", cfg.tableName, "' and B.docuNo = F.parentNo) as fcnt ");
			query.push("	,isNull(opt1, 0) as rewardPoint ");
			query.push("	,ROW_NUMBER() OVER (ORDER BY docuNo) AS rowseq, noticeCD ");
			query.push("FROM ", cfg.tableName, " B ");
			query.push("WHERE tableNo = '", cfg.tableNo, "' and noticeCD = '1' ");
			query.push("ORDER BY sortNo desc");

		}else if (method == "selectList"){
			if (paramObj.chk != undefined && paramObj.chk != "" && paramObj.setext != undefined && paramObj.setext != ""){
				addQuery += " and " + paramObj.chk + " like '%"+paramObj.setext+"%' ";
			}

			query.push("SELECT B.docuNo, B.sortNo, B.categoryNo, B.title, B.depth, B.regiDate, B.IP, writer ");
			query.push("	,(select count(docuNo) from ", cfg.tableName, "Logs L where tableNo = '", cfg.tableNo, "' and B.docuNo = L.docuNo) as rcnt ");
			query.push("	,(select count(seq) from ", cfg.tableName, "Comment C where tableNo = '", cfg.tableNo, "' and B.docuNo = C.docuNo) as ccnt ");
			query.push("	,(select count(seq) from T_fileSystem F where parentType = 'B", cfg.tableName, "' and B.docuNo = F.parentNo) as fcnt ");
			query.push("	,isNull(opt1, 0) as rewardPoint ");
			query.push("	,ROW_NUMBER() OVER (ORDER BY docuNo) AS rowseq, noticeCD ");
			query.push("FROM ", cfg.tableName, " B ");
			query.push("WHERE tableNo = '", cfg.tableNo, "' and noticeCD = '0' ", addQuery);
			query.push("ORDER BY sortNo desc");

		}else if (method == "selectArticle"){
			query.push("select * from ( ");
			query.push("	select ROW_number() over (order by sortNo) as rowseq, * from ( ");
			query.push("		select docuNo, sortNo, depth, categoryNo, title, writer, memberNo, content, IP, regiDate, noticeCD, ");
			query.push("           (select count(docuNo) from ", cfg.tableName, "Logs L where tableNo = '", cfg.tableNo, "' and B.docuNo = L.docuNo) as rcnt, ");
			query.push("           (select count(seq) from ", cfg.tableName, "Comment C where tableNo = '", cfg.tableNo, "' and B.docuNo = C.docuNo) as ccnt,  ");
			query.push("           isNull(opt1, 0) as rewardPoint ");
			query.push("		 from ", cfg.tableName, " B where tableNo = '", cfg.tableNo, "' ");
			query.push("	) Stbl ");
			query.push(") tbl where docuNo = '", paramObj.docuNo, "' ");

		}else if (method == "selectAroundArticle"){
			if (paramObj.chk != undefined && paramObj.chk != "" && paramObj.setext != undefined && paramObj.setext != ""){
				addQuery += " and " + paramObj.chk + " like '%"+paramObj.setext+"%' ";
			}

			query.push("select * from ( ");
			query.push("	select ROW_number() over (order by sortNo) as rowseq, * from ( ");
			query.push("		select docuNo, sortNo, depth, categoryNo, title, writer, memberno, content, IP, regiDate, ");
			query.push("           (select count(docuNo) from ", cfg.tableName, "Logs L where tableNo = '", cfg.tableNo, "' and B.docuNo = L.docuNo) as rcnt, ");
			query.push("           (select count(seq) from ", cfg.tableName, "Comment C where tableNo = '", cfg.tableNo, "' and B.docuNo = C.docuNo) as ccnt  ");
			query.push("		 from ", cfg.tableName, " B where tableNo = '", cfg.tableNo, "' ", addQuery, " ");
			query.push("	) Stbl ");
			query.push(") tbl where rowseq > ", parseInt(epo.rowseq)-5, " and rowseq < ", parseInt(epo.rowseq)+5, " order by rowseq desc ");

		}else if (method == "selectAttFiles"){
			query.push("select * from T_filesystem where parentNo = '", paramObj.docuNo, "' and parentType = 'B", cfg.tableNo, "'");

		}else if (method == "selectReadCount"){
			query.push("select * from ", cfg.tableName, "Logs ");
			query.push("where tableNo = '", cfg.tableNo, "' and docuNo = '", paramObj.docuNo, "' and sessionID = '", $.getCookie("sessionID"), "'");

		}else if (method == "selectAttachFiles"){
			query.push("SELECT * FROM dbo.T_fileSystem WHERE parentNo='", paramObj.docuNo, "' AND parentType = 'B", cfg.tableNo, "' ");
			query.push("ORDER BY seq asc");

		}else {

		}

		//println(query.join(''));
		return query.join('');
	},

	getListItem: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var cntObj = cfg.cntObj;

		var query = this.getQuery("selectNoticeList");
		var row = axisDB.getRows(query);

		var listQuery = this.getQuery("selectList");
		var listRow = axisDB.getRows( listQuery, {pageSize:cntObj.listCnt, pageNo:paramObj.pageNo} );

		this.list = listRow;
		this.setListItem(row, listRow);
	},

	setListItem: function(notiRow, listRow){
		var cfg = this.config;
		var b_paging = false;
		var po = [];
		po.push("<tbody>")

		if (notiRow.length > 0){
			var notiTR = this.makeListItem(notiRow);		//공지사항
			po.push(notiTR);
		}

		if (listRow.list.length > 0){
			var listTR = this.makeListItem(listRow.list);			//리스트
			po.push(listTR);
			b_paging = true;
		}else{
			po.push("<tr>");
			po.push("<td colspan='", cfg.colGroup.length, "' style='text-align:center;'>등록된 내용이 없습니다.</td>");
			po.push("</tr>");
		}

		po.push("</tbody>")
		po.push("</table>");

		po.push("<div class='boardTools BBF'>");
		if (b_paging){
			var pagingDiv = this.setPaging(listRow.page);			//페이징
			po.push(pagingDiv);
		}
		var searchDiv = this.setSearchBar();						//검색
		po.push(searchDiv);
		po.push("</div>");

		if (parseInt(cfg.account.auth) >= parseInt(cfg.authLevel.write)){				//button div
			po.push("<div class='boardButtons' align='right' style='padding-top:10px;'>");
			po.push("<input type='button' value='글쓰기' class='AXButton W70 BBF' onclick=\"location.href='?", this.vg_link, "&amp;method=write';\" />");
			po.push("</div>");
		}

		print(po.join(''));
	},

	getFormatterValue: function(formatter, item, itemIndex, value, key, CH){
	//formatter, 한줄, 줄번호, value, key, 컬럼
		var cfg = this.config;
		var result;
		if(formatter == "money"){
			if(value == "" || value == "null"){
				result = "";
			}else{
				result = value.number().money();
			}
		}else if(formatter == "dec"){
			if (value){
				result = value.dec();
			}
		}else if(formatter == "date" ){
			result = value.left(10);
		}else if(formatter == "html"){
			result = value;
		}else if(formatter == "checkbox"){
			var checked = "";
        	if(CH.checked){
        		var sendObj = {
	                index: itemIndex,
	                list: this.list,
	                item: item
	            }
	            var callResult = CH.checked.call(sendObj);
	            if(callResult){
	            	checked = " checked=\"checked\" ";
	            }
        	}
			result = "<input type=\"checkbox\" name=\""+CH.label+"\" class=\"gridCheckBox_body_colSeq"+CH.colSeq+"\" id=\""+cfg.targetID+"_AX_checkboxItem_AX_"+itemIndex+"\" value=\""+value+"\" " + checked + " />";
		}else{
			var sendObj = {
				index: itemIndex,
				list: this.list,
				item: item
			}
			result = eval(formatter).call(sendObj, itemIndex, item);
		}
		return result;
	},

	makeListItem: function(listObj){
		/* check : 상세보기 링크관련확인 */
		var po = [];
		var cfg = this.config;
		var tmpClass = "", tmpAlign = "";
		var vg_link = this.vg_link;
		var imgClass = "";
		var getFormatterValue = this.getFormatterValue.bind(this);

		$.each(listObj, function(idx, o){
			imgClass = "";

			if (o.noticeCD == 1){
							po.push("<tr class='notice'>");
        	}else{
							po.push("<tr class='List'>");
			}
			$.each(cfg.colGroup, function(eIdx, obj){
	  			tmpClass = (obj.cClass != undefined) ? obj.cClass : obj.key;
				tmpAlign = (obj.align != undefined) ? " align='"+obj.align+"' " : "";

				if (obj.ellipsis){
					po.push("<td class='", tmpClass, "' ", tmpAlign, " title='", o.title, "' nowrap='nowrap' style='text-overflow:ellipsis;overflow:hidden;'>");
				}else{
					po.push("<td class='", tmpClass, "' ", tmpAlign, ">");
				}

				if (obj.formatter){
							po.push(getFormatterValue(obj.formatter, o, idx, o[obj.key], obj.key, obj));
				}else{
							po.push(o[obj.key]);
				}
							po.push("</td>");
			});
							po.push("</tr>");
		});

		return po.join('');
	},

	setPaging: function(pagingObj){
		var po = [];
		var cfg = this.config;
		var paramObj= cfg.paramObj;
		var cntObj = cfg.cntObj;
		var tmpCalc = 0;

		po.push("<div class='pageNos'>");
		po.push("&nbsp;");

		tmpCalc = (parseInt(paramObj.stPage) - parseInt(cntObj.pagingCnt));
		if ( tmpCalc > 0 ){
			po.push("<a href='?pageNo=", tmpCalc, "&stPage=", tmpCalc, "&", this.pg_link, "' class='pgprev'>이전 ", cntObj.pagingCnt, " Page</a>&nbsp;");
		}
		if (paramObj.stPage != 1){
			po.push("<a href='?pageNo=1&stPage=1&", this.pg_link, "'>1</a>..");
		}
		for (var CP = paramObj.stPage ; CP < (parseInt(paramObj.stPage) + parseInt(cntObj.pagingCnt) ); CP++){
			if (CP > pagingObj.pageCount ){

			}else if (CP == paramObj.pageNo){
				po.push("<a style='color:#FB4201;'><u>", CP, "</u></a>");
			}else{
				po.push("<a href='?pageNo=", CP, "&stPage=", paramObj.stPage, "&", this.pg_link, "'>", CP, "</a>");
			}
		}
		if ( (pagingObj.pageCount - cntObj.pagingCnt) >= paramObj.stPage ) {
			var pvg = (parseInt(pagingObj.pageCount / cntObj.pagingCnt)) * cntObj.pagingCnt + 1;
			if (pvg > pagingObj.pageCount) {
				pvg = pvg - pagingObj.pageSize;
			}
			po.push("..<a href='?pageNo=", pagingObj.pageCount, "&stPage=", pvg, "&", this.pg_link, "'>", pagingObj.pageCount, "</a>");
		}
		tmpCalc = parseInt(paramObj.stPage) + parseInt(cntObj.pagingCnt);
		if (tmpCalc <= pagingObj.pageCount){
			po.push("&nbsp;<a href='?pageNo=", tmpCalc, "&stPage=", tmpCalc, "&", this.pg_link, "' class='pgnext'>다음 ", cntObj.pagingCnt, " Page</a>");
		}

		po.push(" (총 <b>", pagingObj.pageCount, "</b> Page)");
		po.push("</div>");

		return po.join('');
	},

	setSearchBar: function(){
		/* check : 검색관련 내용도 확인, 커스텀 및 기본 */
		var po = [];
		var cfg = this.config;
		var paramObj= cfg.paramObj;

		po.push("<div class='boardSearch'>");
		po.push("	<form name='boardsearch' method='get' action='' onsubmit='return AXBoardObj.listSearch();'>");
		po.push("	<table cellpadding='0' cellspacing='0' class=''>");
		po.push("		<tbody>");
		po.push("			<tr>");
		po.push("				<td style='padding-right:10px;'>");
		po.push("					<input type='radio' name='chk' id='bdchk_title' value='title' checked='checked' class='nborder'>");
		po.push("					<label for='bdchk_title'>제목</label>");
		po.push("					<input type='radio' name='chk' id='bdchk_content' value='content' class='nborder'>");
		po.push("					<label for='bdchk_content'>내용</label>");
		po.push("				</td>");
		po.push("				<td>");
		po.push("					<input type='text' name='setext' id='setext' value='", paramObj.setext, "' class='formbox' />");
		po.push("				</td>");
		po.push("				<td>");
		po.push("					<input type='image' src='/samples/AXBoard/_img/bsearch.gif' align='middle' alt='' style='border:0px none;height:23px;' />");
		po.push("				</td>");
		po.push("			</tr>");
		po.push("		</tbody>");
		po.push("	</table>");
		po.push("	</form>");
		po.push("</div>");

		return po.join('');
	},

	__________view: function(){},
	getViewPage: function(){
		this.getViewInfo();
	},

	getViewInfo: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var cntObj = cfg.cntObj;

		//조회수업데이트
		this.readCountUpdate();

		var query = this.getQuery("selectArticle");
		var row = axisDB.getRow(query);
		var fileRow, aaRow;

		if (!row.eof){
			var fileQuery = this.getQuery("selectAttFiles");
			fileRow = axisDB.getRows(fileQuery);
			
			var aaQuery = this.getQuery("selectAroundArticle", {rowseq: row.rowseq} );
			aaRow = axisDB.getRows(aaQuery);
			/* check : 본인 확인 */
			if (parseInt(row.memberNo) == parseInt(cfg.account.memberNo)){
				this.contrlAllow = 1;
			}

			this.article.row = row;
		}

		this.setViewInfo(row, fileRow, aaRow);
		
		this.pageStart("view");
	},

	readCountUpdate: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;

		//게시물 조회수 업데이트
		var result;
		var docuViewLogs = 0;

		var memberNo = (cfg.account.memberNo) ? cfg.account.memberNo : 0;
		var query = this.getQuery("selectReadCount");
		result = axisDB.getRow( query );

		if (!result.eof){ docuViewLogs = 1; }

		if (docuViewLogs == 0){
			var d = new Date();
			var logDate = "";
		   	logDate += d.getFullYear() + "-";
		   	logDate += (d.getMonth() + 1) + "-";
		   	logDate += d.getDate() + " ";
		   	logDate += d.getHours() + ":";
		   	logDate += d.getMinutes() + ":";
		   	logDate += d.getSeconds();

		   	result = axisDB.insert(cfg.tableName+"Logs",
			{
				tableNo		: cfg.tableNo,
				docuNo		: paramObj.docuNo,
				sessionID	: $.getCookie("sessionID")+"",
				memberNo	: memberNo,
				logDate		: logDate
			});
		}

	},

	setViewInfo: function(obj, fObj, aObj){
		var po = [];
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var rowseq = obj.rowseq;
		var vg_link = this.vg_link;

		if (!obj.eof){
									po.push("<table width='100%' cellspacing='0' class='BoardType01 BBF'>");
									po.push("	<colgroup>");
									po.push("		<col style='width:15px'/>");
									po.push("		<col/>");
									po.push("		<col style='width:15px'/>");
									po.push("	</colgroup>");
									po.push("	<thead>");
									po.push("	<tr>");
									po.push("		<td class='tl'></td>");
									po.push("		<td nowrap='nowrap' title='", obj.title, "' >", obj.title, "</td>");
									po.push("		<td class='tr'></td>");
									po.push("	</tr>");
									po.push("	</thead>");
									po.push("</table>");
			if (cfg.tableNo == 99 && this.contrlAllow != 1 ){
				/* check : private board */
									po.push("<br/>");
									po.push("<div class='eofMSG'>본인 외에는 열람할 수 없습니다. 죄송합니다.</div>");
									po.push("<br/>");
									po.push("<div class='boardButtons' align='center'>");
									po.push("	<span class='BT60_30'><a href='javascript:history.go(-1);' title='돌아가기'>돌아가기</a></span>");
									po.push("</div>");
			}else{
									po.push("<table width='100%' cellspacing='0' class='BoardType01 BBF'>");
									po.push("	<colgroup>");
									po.push("		<col style='width:40px'/>");
									po.push("		<col/>");
									po.push("		<col style='width:40px'/>");
									po.push("		<col style='width:60px'/>");
									po.push("		<col style='width:40px'/>");
									po.push("		<col style='width:40px'/>");
									po.push("	</colgroup>");
									po.push("	<tbody>");
									po.push("		<tr class='viewer'>");
									po.push("			<td class='title'>작성일</td>");
									po.push("			<td>", obj.regiDate.left(10), "( ", (new Date()).getTimeAgo(obj.regiDate), " )</td>");
									po.push("			<td class='title'>작성자</td>");
									po.push("			<td>", obj.writer, "</td>");
									po.push("			<td class='title'>조회수</td>");
									po.push("			<td>", obj.rcnt.money(), "</td>");
									po.push("		</tr>");
									po.push("	</tbody>");
									po.push("</table>");

									po.push("<div style='margin:15px 0px;' class='boardContent' id='boardContent'>", obj.content, "</div>");
				if (fObj.length > 0){
					/* check : filedown path */
					$.each(fObj, function(idx, o){
									po.push("<div id='", o.FileName, "' class='ARIAeditorAttFile BBF'>");
									po.push("	<a href='/samples/AXBoard/proc/fileDiskDown.asp?fileName=", o.fileName, "' title='", o.title, "'>");
									po.push("	File : ", o.title, " (", o.fileSize.byte(), ")</a>");
									po.push("</div>");
					});
				}
				/* check : sharer */
									po.push("<div class='lineSNS' style='margin:20px 0px;padding:10px;border-top:1px dashed #eee;' align='right'>");
									po.push("	<input type='image' src='/samples/AXBoard/_img/sns1.png' onclick=\"AXBoardObj.postSNS('facebook',	'" + "http://www.axisj.com" + "', '" + obj.title.enc() + "');\" />");
									po.push("	<input type='image' src='/samples/AXBoard/_img/sns2.png' onclick=\"AXBoardObj.postSNS('twitter', 	'" + "http://www.axisj.com" + "', '" + obj.title.enc() + "');\" />");
									/*
									po.push("	<input type='image' src='/samples/AXBoard/_img/sns3.png' onclick=\"AXBoardObj.postSNS('me2day', 	'", ("http://mucopect.co.kr/~" + cfg.tableNo + paramObj.docuNo).enc(), "', '", obj.title.enc(), "');\" />");
									po.push("	<input type='image' src='/samples/AXBoard/_img/sns4.png' onclick=\"AXBoardObj.postSNS('yozm', 		'", ("http://mucopect.co.kr/~" + cfg.tableNo + paramObj.docuNo).enc(), "', '", obj.title.enc(), "');\" />");
									po.push("	<input type='image' src='/samples/AXBoard/_img/sns5.png' onclick=\"AXBoardObj.postSNS('cyworld', 	'", ("http://mucopect.co.kr/~" + cfg.tableNo + paramObj.docuNo).enc(), "', '", obj.title.enc(), "');\" />");
									*/
									po.push("</div>");
				/* check : comment */
				if (cfg.useComment) {
									po.push("<div class='BBF' id='AXBoardCommentArea'>");
									po.push("	<div id='AXBoardCommentForm'></div>");
									po.push("	<div style='padding:10px 5px 5px 5px;border-bottom:1px solid #e9e9e9;'><b>댓글목록</b></div>");
									po.push("	<div class='commentList' id='AXBoardCommentList'>");
									po.push("		<div class='eofMSG'>댓글 모듈 로딩중...</div>");
									po.push("	</div>");
									po.push("	<div class='pagingDiv' id='AXBoardCommentPaging'></div>");
									po.push("</div>");
				}
				if (aObj.length > 0){
									po.push("<div class='selectOtherList'>");
									po.push("	<table width='100%' cellspacing='0' class='BoardType01Sub BBF'>");
									po.push("		<colgroup>");
									po.push("			<col style='width:5px' />");
									po.push("			<col style='width:20px' />");
									po.push("			<col style='width:5px' />");
									po.push("			<col style='width:80px' />");
									po.push("			<col />");
									po.push("			<col style='width:120px' />" );
									po.push("		</colgroup>");
									po.push("		<tbody>");
					$.each(aObj, function(idx, o){
						var imgClass = "";
						if (rowseq == parseInt(o.rowseq)) {
							/* check : category name */
							imgClass = "stop";
									po.push("			<tr class='stop'>");
						}else{
							if (rowseq > parseInt(o.rowseq) ){
								imgClass = "next" + (rowseq - parseInt(o.rowseq));
							}else{
								imgClass = "prev" + (parseInt(o.rowseq) - rowseq);
							}
									po.push("			<tr>");
						}
									po.push("				<td></td>");
									po.push("				<th><span class='defaultStyle ", imgClass, "'></span></th>");
									po.push("				<td></td>");
									po.push("				<td align='center'> - </td>");		//GetCategoryName(rs("categoryNo"))
									po.push("				<td nowrap='nowrap'>");

							if (o.depth > 0){
								for (var r=0; r < o.depth; r++){
									po.push("&nbsp;&nbsp;");
								}
									po.push("					<span class='defaultStyle re'></span>");
							}		
							var cvtTitle = (cfg.stringDecode) ? o.title.dec() : o.title;
							
									po.push("					<a href='?docuNo=", o.docuNo, "&amp;", vg_link, "&amp;method=view'>", cvtTitle, "</a></td>");
									po.push("				<td align='right'>", (new Date()).getTimeAgo(o.regiDate), "&nbsp;</td>");
									po.push("			</tr>");
					});
									po.push("		</tbody>");
									po.push("	</table>");
									po.push("</div>");
				}
									po.push("<div class='boardButtons BBF'>");
									po.push("	<input type='button' value=' 목록보기 ' class='AXButton' onclick=\"location.href='?" + vg_link + "&amp;method=list';\" />");
				if (cfg.reply && cfg.account.auth >= cfg.authLevel.reply && parseInt(this.article.row.noticeCD) != 1){
									po.push("	<input type='button' value=' 답변하기 ' class='AXButton' onclick=\"location.href='?docuNo=" + obj.docuNo + "&" + vg_link + "&amp;method=reply';\" />");
				}
				if (cfg.account.auth >= cfg.authLevel.write) {
									po.push("	<input type='button' value=' 새글쓰기 ' class='AXButton' onclick=\"location.href='?" + vg_link + "&amp;method=write';\" />");
					if (this.contrlAllow == 1 || this.isAdmin){
									po.push("	<input type='button' value=' 수정하기 ' class='AXButton' onclick=\"location.href='?docuNo=" + obj.docuNo + "&" + vg_link + "&amp;method=modify';\" />");
									po.push("	<input type='button' value=' 삭제하기 ' class='AXButton' onclick='AXBoardObj.articleDelete(\"", cfg.tableName, "\", ", cfg.tableNo, ", ", obj.docuNo, ", ", paramObj.stPage," );' />");
					}
				}
									po.push("</div>");
			}
		}else{
			po.push("<div style='text-align:center;padding:20px;' class='BBF'>");
			po.push("해당 게시글이 존재하지 않습니다.</br></br>");
			po.push("<input type='button' value='돌아가기' class='AXButton W90 BBF' onclick='history.back();' />");
			po.push("</div>");

			this.cancelScript= true;
		}

		print(po.join(''));
	},

	__________write: function(){},
	getWritePage: function(){
		var cfg = this.config;

		if (cfg.account.auth >= cfg.authLevel.write ){
			this.setWritePage();
		}else{
			this.noPermission();
		}
	},

	setWritePage: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var po = [];
		var attFiles = [];
		var content = "";

		this.article.getRecord = true;

		if (paramObj.method == 'modify'){
			this.article = this.getModifyArticleInfo();
			$.each(this.article.attFiles, function(idx, o){
				attFiles.push( { id: "MF_"+o.seq, ti: o.title, nm: o.fileName, ty: o.fileType, size: o.fileSize, path: o.path, thumb: o.thumb } );
			});
		}

		if (paramObj.method == 'reply'){
			this.article = this.getReplyArticleInfo();
		}

		if (paramObj.method == 'reply' || paramObj.method == 'modify'){
			if (this.article.row.content != undefined){
				content = this.article.row.content;
			}else{
				content = "";
			}
		}

		var af = [];
		af.push("<script type=\"text/javascript\" >");
		af.push("	attFiles = " + Object.toJSON(attFiles) + ";" );
		af.push("</script>");
		print(af.join(''));

		if (this.article.getRecord){

			po.push("<form name='AXISboardWriteForm' id='AXISboardWriteForm' method='post'>");
			po.push("<table width='100%' cellspacing='0' class='BoardType01 BBF' style='border-top:1px solid #888;'>");
			po.push("	<col width='80'>");
			po.push("	<col>");
			po.push("	<tbody>");

			if (this.isAdmin){		//관리자 영역
			po.push("		<tr>");
			po.push("			<td style='background:#f3f3f3;text-align:center;font-weight:bold;'>공지글</td>");
			po.push("			<td style='padding-left:5px;vertical-align:middle;'>");
			po.push("				<input type='radio' name='AXISboardNoticeCD' value='0' class='nborder' checked='checked' /> 일반글");
			po.push("				<input type='radio' name='AXISboardNoticeCD' value='1' class='nborder' /> 공지글");
			po.push("			</td>");
			po.push("		</tr>");
			}
			po.push("		<tr>");
			po.push("			<td style='background:#f3f3f3;text-align:center;font-weight:bold;'>제목</td>");
			po.push("			<td style='padding-left:5px;vertical-align:middle;'>");
			po.push("				<input type='text' name='AXISboardTitle' id='AXISboardTitle' value='' style='width:",cfg.pageWidth-100, "px;' />");
			po.push("			</td>");
			po.push("		</tr>");
			po.push("	</tbody>");
			po.push("</table>");

			po.push("<input type='hidden' name='table_name' value='", cfg.tableName, "' />");
			po.push("<input type='hidden' name='tableNo' value='", cfg.tableNo, "' />");
			po.push("<input type='hidden' name='docuNo' value='", paramObj.docuNo, "' />");
			po.push("<input type='hidden' name='memberNo' id='h_memberNo' value='", cfg.account.memberNo, "' />");
			po.push("<input type='hidden' name='method' value='", paramObj.method, "' />");
			po.push("</form>");

			po.push("<div style='height:5px;'></div>");
			po.push("<!-- editor -->");
			po.push("<div id='AXEditorTarget'></div>");
			po.push("<div id='editContent' style='display:none;'>", content, "</div>");
			po.push("<!-- editor -->");
			po.push("<div style='height:5px;'></div>");

			po.push("<div class='AXUploadButton BBF'>");
			po.push("	<span id='spanButtonPlaceHolder'>업로드 버튼영역</span>");
			po.push("	<span class='buttonMsg'>업로드 하실 파일을 선택해 주세요</span>");
			po.push("</div>");
			po.push("<div class='AXUploadQueueBox' id='uploadQueueBox' style='height: 120px; overflow: auto; padding-bottom: 10px; margin-top: 5px;'></div>");
			po.push("<div style='padding-top: 5px;'>");
			po.push("	<input disabled='disabled' class='AXButton' id='cancelBtn' onclick='AXBoardObj.upload.cancelUpload();' type='button' value='전송중지'>");
			po.push("	<input class='AXButton' onclick=\"AXBoardObj.upload.deleteSelect();\" type='button' value='선택삭제' />");
			po.push("	<input class='AXButton' onclick=\"AXBoardObj.upload.deleteSelect('all');\" type='button' value='모두삭제'>");
			po.push("</div>");

			po.push("<div class='boardButtons' align='right' style='padding:10px;'>");
			po.push("	<input type='button' value='작성완료' class='AXButton' onclick='AXBoardObj.articleSave();' />");
			po.push("	<input type='button' value='이전페이지' class='AXButton' onclick='history.back();' />");
			po.push("	<input type='button' value='목록보기' class='AXButton' onclick='location.href=\"?", this.vg_link, "\";' />");
			po.push("</div>");

			print(po.join(''));

			if (paramObj.method == "reply"){
				this.pageStart("reply");

			}else if (paramObj.method == "modify"){
				this.pageStart("modify");

			}else{
				this.pageStart("write");
			}

		}else{
			print(this.article.empty);
		}
	},

	getModifyArticleInfo: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var returnObj = {};

		var query = this.getQuery("selectArticle");
		var row = axisDB.getRow(query);

		if (!row.eof && parseInt(row.memberNo) == parseInt(cfg.account.memberNo) || this.isAdmin){
			returnObj.getRecord = true;
			returnObj.row = row;

			var attQuery = this.getQuery("selectAttachFiles");
			var attFiles = axisDB.getRows(attQuery);
			returnObj.attFiles = attFiles;

		}else{
			var po = [];
			po.push("<div style='text-align:center;padding:20px;' class='BBF'>");
			po.push("해당 게시글이 존재하지 않습니다.</br></br>");
			po.push("<input type='button' value='돌아가기' class='AXButton W90 BBF' onclick='history.back();' />");
			po.push("</div>");

			returnObj.getRecord = false;
			returnObj.empty = po.join('');
		}

		return (returnObj);
	},

	getReplyArticleInfo: function(){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var returnObj = {};

		var query = this.getQuery("selectArticle");
		var row = axisDB.getRow(query);
		var po = [];

		if (!row.eof){
			if ( parseInt(row.noticeCD) == 1 ){
				po.push("<div style='text-align:center;padding:20px;' class='BBF'>");
				po.push("공지에는 답글을 달 수 없습니다.</br></br>");
				po.push("<input type='button' value='돌아가기' class='AXButton W90 BBF' onclick='history.back();' />");
				po.push("</div>");

				returnObj.getRecord = false;
				returnObj.empty = po.join('');

				this.cancelScript= true;

			}else{
				returnObj.getRecord = true;
				returnObj.row = row;
			}


		}else{
			po.push("<div style='text-align:center;padding:20px;' class='BBF'>");
			po.push("해당 게시글이 존재하지 않습니다.</br></br>");
			po.push("<input type='button' value='돌아가기' class='AXButton W90 BBF' onclick='history.back();' />");
			po.push("</div>");

			returnObj.getRecord = false;
			returnObj.empty = po.join('');
		}

		return (returnObj);
	},

	pageStart: function(method, extraObj){
		var cfg = this.config;
		var paramObj = cfg.paramObj;
		var article = this.article;

		var po = [];
		var mNo = (cfg.account.memberNo != undefined && cfg.account.memberNo != "") ? cfg.account.memberNo : "-1" ;
		if (!this.cancelScript){
			po.push("<script type=\"text/javascript\" >");
			if (method=="view"){
				po.push("$(document.body).ready(function(){");
				po.push("	AXBoardObj.boardviewStart(", cfg.pageWidth, ");");
				po.push("	AXBoardObj.commentInit('{tableNo:",cfg.tableNo,", docuNo:",paramObj.docuNo,"}', ", mNo, ");");
				po.push("});");

			}else if (method=="write"){
				po.push("$(document.body).ready(function(){");
				po.push("	AXBoardObj.editorInit('{tableNo:",cfg.tableNo,", memberNo:",mNo,"}' );");
				po.push("});");

			}else if (method=="modify"){
				po.push("$(document.body).ready(function(){");
				if (this.isAdmin) {
				po.push("	$('#h_memberNo').val('", article.row.memberNo, "'); ");
				}
				po.push("	$('#AXISboardTitle').val('", article.row.title, "'); ");
				po.push("	$('input[name=AXISboardNoticeCD]:eq(", article.row.noticeCD, ")').attr( \"checked\", true ); ");
				po.push("	AXBoardObj.editorInit('{tableNo:",cfg.tableNo,", memberNo:",mNo,"}' );");
				po.push("});");

			}else if (method=="reply"){
				var co = [];
				co.push("<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>");
			    co.push("<div class='BoardType01reply BBF' style='border-top:1px dashed #cc0000;' >");
			    co.push("	<div class='replytitle' style='padding:5px 0px;'><b>'", article.row.writer, "님'</b> 께서 ", article.row.regiDate, "에 남기신 글</div>");
			    co.push("</div>");

				po.push("$(document.body).ready(function(){");
				po.push("	$('#AXISboardTitle').val('[re] ", article.row.title, "'); ");
				po.push("	$('.AXEditorContentBody').html( \"", co.join(''), "\" + '<div style=\"border:1px solid #ccc; padding:10px;\">' + $('.AXEditorContentBody').html() + '</div>'  );");
				po.push("	AXBoardObj.editorInit('{tableNo:",cfg.tableNo,", memberNo:",mNo,"}' );");
				po.push("	setTimeout(\"$('#AXISboardTitle').focus().select()\", 100); ");
				po.push("});");
			}else{

			}
			po.push("</script>");
			print(po.join(''));
		}

	},

	noPermission: function(){
		var po = []
		po.push("<script type=\"text/javascript\" >");
		po.push("	alert('권한이 없습니다.');");
		po.push("	history.go(-1);");
		po.push("</script>");

		print(po.join(''));
	}

});
%>