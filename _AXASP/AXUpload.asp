<%
/*
 * axisASP Library Version 1.0
 * http://axisJ.com
 *
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용기 예상치 못한 피해가 발생 하실 수 있습니다.
 */


var AXUpload = Class.create(AXJ, {
	version: "AXUpload v1.1",
	author: "root@axisj.com",
	logs: [
		"2013-03-12 오전 10:39:55 - 시작",
		"2013-06-21 오후 2:42:53 - thumb 폴더이름 지정방식 변경",
		"2013-08-05 오후 3:31:19 - 최대용량 초과시 error 코드 리턴",
		"2013-11-04 오후 4:13:19 - 썸네일 메서드 버그패치 : tom",
		"2013-11-04 오후 4:42:20 - setMaxWidthHeight 메서드 추가 : tom"
	],
	initialize: function($super) {
		$super();

		//this.Upload = Server.CreateObject("Persits.Upload");
		this.config.debug = false;
		this.config.uploadPath = "";
		this.config.defaultPath = "/_FILE";
		this.config.thumbFolderName = "thumb";
		this.config.autoFolderMake = true;
		this.config.componentName = "aspUpload";
		this.config.maxSize = 1024 * 1024;

		//최대갯수제한
		//this.config.maxCount = 5;

		//component별 분기예정입니까?
		this.Upload = new ActiveXObject("Persits.Upload");
		this.Thumb = new ActiveXObject("Persits.Jpeg");
		//this.myAXFSO = new AXFSO();
		this.FSO = new ActiveXObject("Scripting.FileSystemObject");
	},

	init: function(){
		this.Upload.CodePage = 65001;
		//this.showInfo();
	},

	showInfo: function(){
		upload = this.Upload;
		println(this.config.autoFolderMake);
	},

	saveFiles: function(){
	
	
		var cfg = this.config;
		var upload = this.Upload;
		var fileSizeCheck = true;

		if (Request.TotalBytes > cfg.maxSize) {
			fileSizeCheck = false;
		}

		try{
			if (fileSizeCheck){
				upload.SetMaxSize (cfg.maxSize, true);
				upload.Save();

				var objFile = {};
				var saveFolder, savedFile, savePath, thumbPath;
				var arrSaveFiles = [];
				var tmpObj;

				if (cfg.uploadPath != ""){
					if (cfg.autoFolderMake){
						tmpObj = this.getSaveFolderName(cfg.uploadPath);

						saveFolder = tmpObj.localPath;
						savePath = tmpObj.webPath;
						thumbPath = tmpObj.thumbPath;

					}else{
						saveFolder = Server.MapPath(cfg.uploadPath);
						savePath = cfg.uploadPath.replace(/\\/g, "/");
						thumbPath = savePath+"/"+cfg.thumbFolderName;
					}

					//saveFolder = (cfg.autoFolderMake) ? this.getSaveFolderName(cfg.uploadPath).localPath : Server.MapPath(cfg.uploadPath);
					//savePath = cfg.uploadPath;
				}else{
					tmpObj = this.getSaveFolderName(cfg.defaultPath);
					saveFolder = tmpObj.localPath;
					savePath = tmpObj.webPath;
					thumbPath = tmpObj.thumbPath;
				}

				objFile.saveFolder = saveFolder;
				objFile.thumbPath = thumbPath;
				objFile.savePath = savePath;

				var myAXFSO = new AXFSO();
				var uploadFiles = new Enumerator(upload.Files);

				for (; !uploadFiles.atEnd(); uploadFiles.moveNext() ){
					var o = uploadFiles.item();
					savedFile = myAXFSO.makeUniqueFileName(saveFolder, o.FileName);
					savedFile.size = o.Size;
					o.SaveAs (saveFolder + "\\" + savedFile.uniqueName);

					if (this.isImageFile(savedFile.fileExt) && cfg.thumbSize != undefined ){
						savedFile.thumb = this.makeThumbNail(saveFolder, savedFile);
					}else{
						savedFile.thumb = "";
					}
					
					this.setMaxWidthHeight(saveFolder, savedFile);
					arrSaveFiles.push(savedFile);
				}
				objFile.arrSaveFiles = arrSaveFiles;

				myAXFSO = null;
				return (objFile);

			}else{
				return {
					error: {
						code:"exception",
						description: "최대 용량을 초과했습니다. "
					},
					msg: "업로드 실패"
				}
			}

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "업로드 실패"
			}
		}
	},
	getSaveFolderName: function(folderspac){
		try{
			folderspac = folderspac.replace(/\//g, "\\");

			var cfg = this.config;
			var fso = this.FSO;
			var yyyy, mm, today, folderName;
			var folderObj = {};
			today = new Date();
			yyyy = today.getFullYear();
			mm = (today.getMonth()+1).setDigit(2);

			var myAXFSO = new AXFSO();
			if (fso.FolderExists(folderspac+"\\"+yyyy+"_"+mm)) {
				folderName = folderspac+"\\"+yyyy+"_"+mm;
			}else{
				folderName = myAXFSO.makeFolder( myAXFSO.getMapPath(folderspac), yyyy+"_"+mm );
				folderName = folderspac+"\\"+folderName.checkResult.nm;
			}
			folderObj.localPath = myAXFSO.getMapPath(folderName);
			folderObj.webPath = (folderName+"\\").replace(/\\/g, "/");
			if (cfg.thumbSize){
				folderObj.thumbPath = (folderName + "\\" + cfg.thumbFolderName + "\\").replace(/\\/g, "/");
			}

			myAXFSO = null;
			fso = null;
			return (folderObj);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "저장경로 가져오기 실패"
			}
		}
	},

	getFormData: function(nm){
		//반환형이 다를땐 함수를 나누는 방식으로 수정 예정
		try{
			var cfg = this.config;
			var upload = this.Upload;

			if (nm == undefined){
				var objFormData = {};
				var formData = new Enumerator(upload.Form);
				for (; !formData.atEnd(); formData.moveNext() ){
					var o = formData.item();
					objFormData[o.Name] = o.Value;
				}
				return (objFormData);

			}else{
				return (Upload.Form(nm));
			}

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "저장경로 가져오기 실패"
			}
		}
	},

	isImageFile: function(ext){
		try{
			ext = ext.toLowerCase();
			if (ext == "jpg" || ext == "jpeg" || ext == "gif" || ext == "bmp" || ext == "png" ){
				return (true);
			}else{
				return (false);
			}

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "타입반환 실패"
			}
		}
	},
	setMaxWidthHeight: function(folderspec, objFile){
		var cfg = this.config;
		var fso = this.FSO;
		
		if(cfg.imgSizeMax){
			var thumb = this.Thumb;
			thumb.Open(folderspec+"\\"+objFile.uniqueName);
			var imgWidth = thumb.originalWidth;
			var imgHeight = thumb.originalHeight;
			var newHeight = cfg.imgSizeMax.height;
			var newWidth = cfg.imgSizeMax.width;
			
			if(imgWidth > newWidth){
				thumb.width    = newWidth;
				thumb.height   = imgHeight * newWidth / imgWidth;
			}else if(imgHeight > newHeight){
				thumb.height = newHeight;
				thumb.width = imgWidth * newHeight / imgHeight;
			}
			
			thumb.Save (folderspec+"\\"+objFile.uniqueName);
		}
	},
	makeThumbNail: function(folderspec, objFile){

			var cfg = this.config;
			var fso = this.FSO;
			var thumb = this.Thumb;

			var objThumb = {};
			var folderName;
			var thumbFolderName = cfg.thumbFolderName;

			var myAXFSO = new AXFSO();
			if (fso.FolderExists(folderspec+"\\"+thumbFolderName)) {
				folderName = folderspec+"\\"+thumbFolderName;
			}else{
				folderName = myAXFSO.makeFolder( folderspec, thumbFolderName );
				folderName = folderspec+"\\"+folderName.checkResult.nm;
			}
			myAXFSO = null;

			thumb.Open(folderspec+"\\"+objFile.uniqueName);
			
			var imgWidth = thumb.originalWidth;
			var imgHeight = thumb.originalHeight;
			var newHeight = (cfg.thumbSize.height || 100);
			var newWidth = (cfg.thumbSize.width || 100);
			
			if(imgWidth > imgHeight){
				thumb.height = newHeight;
				thumb.width = imgWidth * newHeight / imgHeight;
				imgWidth = imgWidth * newHeight / imgHeight;
				var cropLen = (imgWidth - newWidth) / 2;
				thumb.Crop(cropLen, 0, imgWidth-cropLen, newHeight);
			}else{
				thumb.width    = newWidth;
				thumb.height   = imgHeight * newWidth / imgWidth;
				imgHeight     = imgHeight * newWidth / imgWidth;
				cropLen = (imgHeight - newHeight)/2;
				thumb.Crop(0, 0, newWidth, newHeight);
			}
			
			/*
			if (cfg.thumbSize.width != undefined && cfg.thumbSize.height != undefined){
				thumb.Width = cfg.thumbSize.width;
				thumb.Height = cfg.thumbSize.height;
			}else if (cfg.thumbSize.width != undefined){
				thumb.Width = cfg.thumbSize.width;
				thumb.Height = thumb.OriginalHeight * cfg.thumbSize.width / thumb.OriginalWidth;
			}else if (cfg.thumbSize.height != undefined){
				thumb.Height = cfg.thumbSize.height;
				thumb.Width = thumb.OriginalWidth * cfg.thumbSize.height / thumb.OriginalHeight;
			}
			*/
			
			thumb.Save (folderName+"\\thumb_"+objFile.uniqueName);

			objThumb.name = "thumb_"+objFile.uniqueName;
			objThumb.width = thumb.Width;
			objThumb.height = thumb.Height;

			fso = null;
			thumb = null;
			return (objThumb);
	}
});
%>