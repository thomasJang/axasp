/*!
 * axisJ Javascript Library Version 1.0
 * http://axisJ.com
 *
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용기 예상치 못한 피해가 발생 하실 수 있습니다.
 */

var AXBoardComment = Class.create(AXJ, {
    version: "AXBoardComment V0.9",
    author: "root@axisj.com",
    logs: [
		"2013-06-14 오전 11:46:05"
    ],
    initialize: function ($super) {
        $super();
        this.config.prefix = "AXBC";
        
        this.config.formID = "AXBoardCommentForm";
		this.config.listID = "AXBoardCommentList";
		this.config.pagingID = "AXBoardCommentPaging";
		this.config.commentListHead = false;

		this.config.cntObj = {listCnt:10,pagingCnt:10};

		//this.config.pageSize = 10;

    },

    init: function () {
        var cfg = this.config;
    },

    search: function (http) {
        var cfg = this.config;

		var printHead = this.printHead.bind(this);
        var printBody = this.printBody.bind(this);
        var printPage = this.printPage.bind(this);

        var url = http.ajaxUrl;
        var pars = http.ajaxPars;

        new AXReq(url, {
            debug: false,
            pars: pars,
            onsucc: function (res) {
            	printHead(res.list);
	            //printBody(res.list);
	            printPage(res.page);

	            if (http.onLoad) {
	                http.onLoad.call(res);
	            }
            },
            onerr: null
        });
    },

    printHead: function (ds) {
    	var cfg = this.config;
    	var po = [];
	    				po.push("<table width='100%' cellspacing='0' class='BoardType01 BBF'>");
						po.push("	<colgroup>");
		$.each(cfg.colGroup, function(idx, o){
			var tmpWidth = (o.width != undefined) ? " style='width:"+o.width+"px;' " : " ";
						po.push("		<col ", tmpWidth, "/>");
		});
						po.push("	</colgroup>");
						
		if (ds.length > 0) {
	  		if (cfg.commentListHead){
				  		po.push("	<thead>");
				  		po.push("		<tr>");
		  		$.each(cfg.colGroup, function(idx, o){
		  			var tmpAlign = (o.align != undefined) ? "style='"+o.align+"'" : "";
		  			if (idx == 0){
	  					po.push("			<td class='tl' ", tmpAlign, ">", o.label, "</td>");
		  			}else if (parseInt(idx) == parseInt(cfg.colGroup.length-1) ) {
	  					po.push("			<td class='tr' >", o.label, "</td>");
		  			}else{
	  					po.push("			<td>", o.label, "</td>");
		  			}
				});
				  		po.push("		</tr>");
				  		po.push("	</thead>");
			}
		}
		this.printBody(ds, po);
    },

    printBody: function (ds, po) {
        var cfg = this.config;
						po.push("	<tbody>");
        if (ds.length > 0) {
            $.each(ds, function (idx, o) {
                		po.push("		<tr>");
                $.each(cfg.colGroup, function (cIdx, c) {
                    	po.push("			<td class=\"" + c.className + "\">");
                    if (c.key == "regiDate") {
                        po.push(o[c.key].left(16));
                        //po.push((new Date()).getTimeAgo(o[c.key]));	//AXJ 에 정의 해야함
                    } else {
                        po.push(o[c.key]);
                    }
                    if (c.delFn && parseInt(o["memberNo"]) == parseInt(cfg.memberNo) ) {
                        var onClickEvent = "";
                        po.push("				<a href='#axexec' id='" + cfg.prefix+ "_AX_"+ idx +"_AX_" + cIdx + "_AX_" + o["seq"] + "' class='deleteComment' >삭제</a>");
                    }
                    	po.push("			</td>");
                });
                		po.push("		</tr>");
            });
        } else {
            			po.push("		<tr><td colspan='", cfg.colGroup.length, "'><div class='eofMSG'>등록된 댓글이 없습니다.</div></td></tr>");
        }
				        po.push("	</tbody>");
						po.push("</table>");

        $("#" + cfg.listID).html(po.join(''));

        $("#" + cfg.listID).find(".deleteComment").bind("click", function (event) {
            var seq = event.target.id.split(/_AX_/g).last();
			cfg.deleteFn(seq, cfg.paramObj);
            
            /*
            alert(seq); return false;
            
            //seq 삭제
            var di = seq[seq.length - 1], ci = seq[seq.length - 2];
            if (cfg.colGroup[ci].onclick) {
                cfg.colGroup[ci].onclick.call(ds[di]);
            }
            */
        });

    },

    getPageNo: function(pageNo, pagingCnt, tp){
    	//매 블럭의 1로 가는게 맞나 아니면 같은 페이지로 가는게 맞나?
		if (tp == "N"){							// 다음 블럭 페이지 시작
			var nextBlock = ((parseInt((pageNo - 1) / pagingCnt) + 1) * pagingCnt) + 1;
			return nextBlock;
			
		}else if (tp == "P"){					// 이전 블럭 페이지 시작
			var prevBlock = (parseInt(( pageNo - 1) / pagingCnt ) * pagingCnt + 1) - pagingCnt;
			if (prevBlock < 1)	prevBlock = 1;
			return prevBlock;
		}
	},

	printPage: function (rs) {
    	//rs = {"pageNo":1, "pageCount":4, "listCount":4};
    	/* check : paging valuable */
		//trace(rs);
		
        var cfg = this.config;
 		var cntObj = cfg.cntObj;
		var po = [];
		
		if (rs.pageCount > 0) {
			po.push("<div class='pageNos'>");
			po.push("&nbsp;");
	
			var nPageFirst = parseInt((rs.pageNo - 1) / cntObj.pagingCnt ) * cntObj.pagingCnt + 1;
	
			var prevBlock = this.getPageNo (rs.pageNo, cntObj.pagingCnt, "P");
			var nextBlock = this.getPageNo (rs.pageNo, cntObj.pagingCnt, "N");
	
			if (nPageFirst > cntObj.pagingCnt){
				po.push("<a href=\"#axexec\" class=\"first\" title=\"첫페이지\" id=\"", cfg.prefix,"_AX_paging_AX_", 1,"\" >첫페이지</a>");
				po.push("<a href=\"#axexec\" class=\"prev\" title=\"이전\" id=\"", cfg.prefix,"_AX_paging_AX_", prevBlock, "\">이전</a>");
			}
			for (var i=0; i<(cntObj.pagingCnt); i++) {
				if (nPageFirst + i > rs.pageCount){
				}else{
					if (rs.pageNo == nPageFirst + i){
						po.push("<a href=\"#axexec\" style=\"font-weight:bold;color:#000;\"> " + (nPageFirst + i) + " </a>");
					}else{
						po.push("<a href=\"#axexec\" id=\"", cfg.prefix,"_AX_paging_AX_", (nPageFirst+i),"\" > " + (nPageFirst+i) + " </a>");
					}
				}
			}
			if ((nPageFirst + cntObj.pagingCnt) < rs.pageCount){
				po.push("<a href=\"#axexec\" class=\"next\" title=\"다음\" id=\"", cfg.prefix,"_AX_paging_AX_", nextBlock ,"\">다음</a>");
				po.push("<a href=\"#axexec\" class=\"last\" title=\"끝페이지\" id=\"", cfg.prefix,"_AX_paging_AX_", rs.pageCount, "\" >끝페이지</a>");
			}
	
			po.push(" (총 <b>", rs.pageCount, "</b> Page)");
			po.push("</div>");
			
			$("#" + cfg.pagingID).html(po.join(''));
			$("#" + cfg.pagingID).find("a").bind("click", this.commentPaging.bind(this));
		}
		
    },

    commentPaging: function (event) {
        var cfg = this.config;
        var pageNo= event.target.id.split(/_AX_/g).last();
		cfg.pagingFn(pageNo);	
		
		/*
		alert(pageNo);
        return false;
        
        var sender = {
            //list: this.ds,
            ps: seqArr[0],
            abs: seqArr[1]
        };
        cfg.pagingLink.call(sender);
        */
    }
});