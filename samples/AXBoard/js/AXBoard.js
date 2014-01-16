var myEditor	= new AXEditor();
var myUpload 	= new AXUpload();
var AXBC 		= new AXBoardComment();

var procObj = {
	comment: "/samples/AXBoard/proc/commentProc.asp",
	articleSave: "/samples/AXBoard/proc/saveProc.asp",
	articleDelete: "/samples/AXBoard/proc/deleteProc.asp",
	uploadFile:	"/samples/AXBoard/proc/uploadFile.asp",
	deleteFile: "/samples/AXBoard/proc/deleteFile.asp"
}
	
var AXBCObj = {
    init: function () {
    	//obj를 어따 쓰지?
        AXBC.setConfig({
        	prefix:"AXBC",
        	//paramObj:obj,
            //pagingLink: "tableNo="+tNo+"&docuNo="+dNo,		//페이지 링크 확인
            //commentListHead: true,
            colGroup: [
                { key: "memberInfo", label: "이름", width:120, className: "AXBC_writer"},
                { key: "content", 	label: "내용",  className: "AXBC_cont", delFn:true },		//, onclick: fnObj.AXBC.onClickDelete
                { key: "regiDate",	label: "작성일", width:105, className: "AXBC_date" }
            ],
            cntObj:{listCnt:7,pagingCnt:10},
            pagingFn:AXBCObj.search,
            deleteFn:AXBCObj.onClickDelete
        });

        var cfg = AXBC.config;
        AXBCObj.setForm(cfg.prefix, cfg.paramObj);
        AXBCObj.search(1);
    },

	setForm: function(prefix, obj){
		var po = [];

		po.push("<form name=\"", prefix, "_form\" id=\"", prefix, "_form\" method=\"post\" onsubmit=\"return AXBCObj.checkForm();\" >");
		$.each(obj, function(k,v){
			po.push("<input type=\"hidden\" name=\"", prefix, "_",k,"\" value=\"",v,"\" />");
		});
		po.push("<table class=\"AXBCForm\" cellspacing=\"0\">");
		po.push("<colgroup>");
		po.push("<col /><col width=\"60\" />");
		po.push("</colgroup>");
		po.push("<tbody>");
		po.push("  <tr>");
		po.push("    <td><textarea name=\"", prefix, "_content\" class=\"commentContent v-req\" id=\"", prefix, "_content\" title=\"내용\" ></textarea></td>");
		po.push("    <td align=\"right\" valign=\"top\">");
		po.push("	 	<input type=\"submit\" value=\"등록\" class=\"AXButtonLarge W50\" id=\""+prefix+"_rebtn\" />");
		po.push("	 </td>");
		po.push("  </tr>");
		po.push("</tbody>");
		po.push("</table>");
		po.push("</form>");

	    $("#AXBoardCommentForm").html(po.join(""));
	    //$("#"+prefix+"_content").focus();
	},

	checkForm: function(){
		var cfg = AXBC.config;

		var result = validate(cfg.prefix+"_form");
		if (!result) return false;

		var url = procObj.comment;
		var pars = $("#"+cfg.prefix+"_form").serialize() + "&method=save";

		new AXReq(url, {
			debug: true, pars: pars, onsucc: function (res) {
			    if (res.result == AXUtil.ajaxOkCode) {
			        toast.push(res.msg);
			        AXBCObj.search(1);
			        $("#"+cfg.prefix+"_content").val('');
			    }else if (res.result == "err"){
			    	dialog.push(res.msg);
			    }
			},
			onerr: function (res) {
			    alert("point onFail:" + res.msg);
			}
		});
		return false;
	},

	search: function (pageNo) {
		mask.open();
		var cfg = AXBC.config;
        var pars = AXBC.config.pagingLink;

        AXBC.search({
            ajaxUrl: "/samples/AXBoard/proc/commentProc.asp",
            ajaxPars: pars + "&pageSize=" + cfg.cntObj.listCnt + "&pageNo=" + pageNo + "&method=list",
            onLoad: function () {
            }
        });
        mask.close();
        return false;
    },

    onClickDelete: function (seq, pObj) {
    	var ans = confirm("삭제하시겠습니까?");
        if (ans) {
        	var param = [];
			$.each(pObj, function(k,v){ param.push(k+"="+v); });

			var url = procObj.comment;
	        var pars = param.join("&")+"&seq="+seq+"&method=delete";

	        new AXReq(url, {
	            debug: false,
	            pars: pars,
	            onsucc: function (res) {
	                if (res.result == AXUtil.ajaxOkCode) {
	                    toast.push(res.msg);
	                    AXBCObj.search(1);
	                } else {
	                	dialog.push(res.msg);
	                	//trace(res);
	                }
	            },
	            onerr: null
	        });
        }
    }
}



var AXBoardObj = {
	pageOnLoad: function(){

	},

	commentInit: function(obj, mNo){
		var pars = [];
		var sender = obj.object();
		$.each(sender, function(k,v){ pars.push(k+"="+v); });
		
		pars = pars.join("&");

		//memberNo = (mNo != undefined) ? mNo : "";

		AXBC.setConfig({
			pagingLink: pars,
			memberNo: mNo,
			paramObj:sender
		});
		
        AXBCObj.init();
	},

	listSearch: function(){
		var tform = document.boardsearch;
		if(tform.setext.value.length == 0){
			alert("검색어를 입력하세요");
			tform.setext.focus();
			return false;
		}
		return true;
	},

	boardviewStart: function(vv){
		$("#boardContent")[0].style.fontSize = "12";
		$("#boardContent").find("IMG").each(function(index, n){
			if($(n).width() > vv ){
				var ratio = vv / n.width;
				n.width = vv;
				n.height = n.height * ratio;
				$(n).bind("click", function(){
					/* check : resize 확인 */
					fcObj.realsizeImage(n, event);
				});
				n.style.cursor = "pointer";
			}
		});

		//덧글 시작
		/*
		myComment.setConfig({
			rootElementID:"boardComment",
			page:{pageSize:50, absPage:1},
			writeAllow:"<=isLogin%>",
			memberNo:"<=acMemberNo%>",
			adminCD:"<=commentAdminCD%>"
		});
		myComment.load({load:"/_as/board/commentLoad.asp", save:"/_as/board/commentSave.asp", pars:"tableNo=<=tableNo%>&docuNo=<=docuNo%>"});
		*/
	},

	postSNS: function(snsNM, surl, stitle){
		var slink = "";
		if(snsNM == "facebook"){
			slink = "https://www.facebook.com/sharer.php?u="+surl+"&t="+stitle;
			window.open(slink, "_blank", "width=700,height=600");
		}else if(snsNM == "twitter"){
			slink = "https://twitter.com/share?url="+surl+"&text="+stitle;
			window.open(slink, "_blank");
		}else if(snsNM == "me2day"){
			slink = "https://me2day.net/posts/new?new_post[body]="+("\"".enc()+stitle+"\":".enc()+surl);
			window.open(slink, "_blank");
		}else if(snsNM == "yozm"){
			slink = "http://yozm.daum.net/api/popup/prePost?sourceid=0&link="+surl+"&prefix="+stitle;
			window.open(slink, "_blank");
		}else if(snsNM == "cyworld"){
			slink = "http://csp.cyworld.com/bi/bi_recommend_pop.php?url="+surl;
			window.open(slink, "_blank", "width=700,height=600");
		}
	},

	editorInit: function(obj){
		myEditor.setConfig({
			targetID: "AXEditorTarget",
			lang: "kr",
			height:300,
			frameSrc: "/_AXJ/lib/AXEditor.html",
			editorFontFamily: "Malgun Gothic",
			fonts:["Malgun Gothic","Gulim","Dotum","궁서"],
			onReady: function(){
				myEditor.setContent($("#editContent"));
			}
		});
		AXBoardObj.upload.init();

	},

	upload: {
		init: function(){
			myUpload.setSetting({
				button_image_url: "/_AXJ/ui/default/img/AXBtnUpload_69x32.png",
				button_width: "69",
				button_height: "32",
				button_placeholder_id: "spanButtonPlaceHolder",
				queueBox_id: "uploadQueueBox",
				flash_url : "/_AXJ/lib/swfupload.swf",
				upload_url: procObj.uploadFile,
				delete_url: procObj.deleteFile,
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : 100,
				onStartUpload: AXBoardObj.upload.onStartUpload,
				onEndUpload: AXBoardObj.upload.onEndUpload,
				onEndFileUpload: AXBoardObj.upload.onEndFileUpload,
				onEndFileDelete: AXBoardObj.upload.onEndFileDelete
			});


			if(attFiles.length > 0){
				myUpload.setUploadedList(attFiles);
			}


		},
		onStartUpload: function(){
			$("#cancelBtn").get(0).disabled = false;
		},
		onEndUpload: function(){
			$("#cancelBtn").get(0).disabled = true;
		},
		cancelUpload: function(){
			myUpload.cancelUpload();
		},
		onEndFileUpload: function(file){
			//{id:"", ti:"", nm:"", ty:"", size:"", path:"", thumb:""}
			//editor 에 이미지 삽입
			myEditor.insertIMG(file);
		},
		onEndFileDelete: function(file){
			myEditor.removeIMG("MF_"+file.nm.replace(file.ty, "").dec());
		},
		getFileList: function(arg){
			var myFileList = myUpload.getUploadedList(arg);
			alert(myFileList);
		},
		getSelectFileList: function(arg){
			var myFileList = myUpload.getSelectUploadedList(arg);
			alert(myFileList);
		},
		deleteSelect: function(arg){
			if(!confirm("정말 삭제하시겠습니까?")) return;
			myUpload.deleteSelect(arg);
		}
	},

	saveEditor: function(paramStr){
		//AXEditor 의 내용 얻기
		var editorContent = myEditor.getContentCheck();
		if (!editorContent){
			alert("내용을 입력해주세요");
			return false;
		}
		var myContent = myEditor.getContent();
		var content = [];
		var obj = {};

		while(myContent.length > 0){
			content.push("content="+myContent.substr(0, 102399).enc());
			myContent = myContent.substr(102399);
		}

		//AXUpload 의 파일 리스트 얻기
		var files = myUpload.getUploadedList();
		var fpas = [];
		$.each(files, function(index, f){
			fpas.push("attFileName="+f.nm+"&attPath="+f.path+"&attFileType="+f.ty+"&attTitle="+f.ti+"&attFileSize="+f.sz+"&attThumb="+f.thumb);
		});

		var pars = []
		pars.push(paramStr, "&", content.join("&"), "&", fpas.join("&"));
		pars = pars.join('');

		var url = procObj.articleSave;
		//var pars = $("#"+cfg.prefix+"_form").serialize() + "&method=save";

		new AXReq(url, {
			debug: true, pars: pars, onsucc: function (res) {
			    if (res.result == AXUtil.ajaxOkCode) {
			        toast.push(res.msg);
			        location.href="?docuNo="+res.docuNo;

			    }else if (res.result == "err"){
			    	dialog.push(res.msg);
			    }
			},
			onerr: function (res) {
			    alert("point onFail:" + res.msg);
			}
		});
		return false;
	},

	articleSave: function(){
		if ($("#AXISboardTitle").val().trim() == ""){
			$("#AXISboardTitle").focus();
			alert("제목을 입력해주세요");
			return false;
		}
		var pars = $("#AXISboardWriteForm").serialize();
		this.saveEditor(pars);

	},

	articleDelete: function(tName, tNo, docuNo, stPage){
		if(confirm("정말 삭제 하시겠습니까?")){
			//alert(tName+", "+tNo+", "+docuNo);

			var url = procObj.articleDelete;
			var pars = "tableName="+tName+"&tableNo="+tNo+"&docuNo="+docuNo+"&stPage="+stPage+"&method=delete";

			new AXReq(url, {
				debug: true, pars: pars, onsucc: function (res) {

					trace(res);
				    if (res.result == AXUtil.ajaxOkCode) {
				        toast.push(res.msg);
				        location.href="?pageNo="+stPage;

				    }else if (res.result == "err"){
				    	dialog.push(res.msg);
				    }
				},
				onerr: function (res) {
				    alert("point onFail:" + res.msg);
				}
			});
			return false;


		}
	},

	someFunc: function(){

	}
}