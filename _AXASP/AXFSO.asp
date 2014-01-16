<%
/*
 * axisASP Library Version 1.0
 * http://axisJ.com
 *
 * 아래 소스의 라이선스는 axisJ.com 에서 확인 하실 수 있습니다.
 * http://axisJ.com/license
 * axisJ를 사용하시려면 라이선스 페이지를 확인 및 숙지 후 사용 하시기 바람니다. 무단 사용기 예상치 못한 피해가 발생 하실 수 있습니다.
 *
 * isFolderExist, isFileExist 을 적용
 * 경로 관련해서 맵패스를 적용해서 보내야하는가?
 */


var AXFSO = Class.create(AXJ, {
	version: "AXFSO v1.0",
	author: "root@axisj.com",
	logs: [
		"2013-03-04 오후 2:54:17 - 시작"
	],
	initialize: function($super) {
		$super();
		this.FSO = new ActiveXObject("Scripting.FileSystemObject");
		this.config.debug = true;
	},

	init: function(){
		//this.showInfo();
	},

	showInfo: function(){
		/*
		var op1 = this.getDriveList();
		println(op1);
		print("<hr/>");
		*/
	},

	getMapPath: function(path){
		try{
			return path ? Server.Mappath(path) : Server.Mappath(".");
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "mappath 가져오기 실패"
			}
		}
	},

	getDriveList: function(){
		try{
			var fso, e, d, x;
			var arrDriveType = [];
			arrDriveType.push("알수없음");
			arrDriveType.push("이동식");
			arrDriveType.push("고정식");
			arrDriveType.push("네트워크");
			arrDriveType.push("CD-ROM");
			arrDriveType.push("RAM DISK");

			fso = this.FSO;
			e = new Enumerator(fso.Drives);
			var arrDrive = [];
			for (; !e.atEnd(); e.moveNext()){
				var objDrive = {};
				x = e.item();

				objDrive.driveLetter = x.DriveLetter;
				objDrive.driveType = x.DriveType;
				objDrive.driveTypeCVT = arrDriveType[x.DriveType];
			  	if (x.DriveType == 3){
			  		objDrive.driveName = x.ShareName;
			  		objDrive.driveDesc = "";
			  	}else if (x.IsReady){
			  		objDrive.driveName = x.VolumeName;
			  		objDrive.driveDesc = "";
			  		d = fso.GetDrive(fso.GetDriveName(x.DriveLetter+":"));
			  		objDrive.freeSpace = d.FreeSpace.byte();
			  		objDrive.availableSpace = d.AvailableSpace.byte();
			  	}else{
			    	objDrive.driveName = "";
			    	//objDrive.driveDesc = "드라이브가 준비되지 않았습니다.".enc();
			    	objDrive.driveDesc = "드라이브가 준비되지 않았습니다.";
				}
			  	arrDrive.push(objDrive);
			}

			fso = null;
			return (arrDrive);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "드라이브리스트 가져오기 실패"
			}
		}
	},

	getDriveInfo: function(drivespec){
		//drivespec 인수는 드라이브 문자(c), 콜론이 추가된 드라이브 문자(c:), 콜론과 경로 구분 기호가 추가된 드라이브 문자(c:\), 또는 네트워크 공유 영역(\\computer2\share1)
		try{
			var fso, d, x;
			var arrDriveType = [];
			arrDriveType.push("알수없음");
			arrDriveType.push("이동식");
			arrDriveType.push("고정식");
			arrDriveType.push("네트워크");
			arrDriveType.push("CD-ROM");
			arrDriveType.push("RAM DISK");
			var objDrive = {};

			fso = this.FSO;
			d = fso.GetDrive(fso.GetDriveName(drivespec));

			objDrive.driveLetter = d.DriveLetter;
			objDrive.driveType = d.DriveType;
			objDrive.driveTypeCVT = arrDriveType[d.DriveType];
		  	if (d.DriveType == 3){
		  		objDrive.driveName = d.ShareName;
		  		objDrive.driveDesc = "";
		  		objDrive.freeSpace = d.FreeSpace.byte();
				objDrive.availableSpace = d.AvailableSpace.byte();

		  	}else if (d.IsReady){
		  		objDrive.driveName = d.VolumeName;
		  		objDrive.driveDesc = "";
		  		objDrive.freeSpace = d.FreeSpace.byte();
		  		objDrive.availableSpace = d.AvailableSpace.byte();
		  	}else{
		    	objDrive.driveName = "";
		    	//objDrive.driveDesc = "드라이브가 준비되지 않았습니다.".enc();
		    	objDrive.driveDesc = "드라이브가 준비되지 않았습니다.";
			}



			fso = null;
			return (objDrive);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "드라이브리스트 가져오기 실패"
			}
		}


	},

	__________folder: function(){},
	isFolderExist: function(folderspec){
		try{
			var fso = this.FSO;
			var isBoolean = fso.FolderExists(folderspec);
			fso = null;

			return (isBoolean);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더확인 실패"
			}
		}
	},

	getFolderList: function(folderspec){
		try{
			var fso, f, fc;
			fso = this.FSO;
			f = fso.GetFolder(folderspec);
			fc = new Enumerator(f.SubFolders);
			var arrFolderList = [];
			for (; !fc.atEnd(); fc.moveNext() ){
				arrFolderList.push({fullPath:""+fc.item(), nm:fc.item().Name, size:fc.item().size.byte(), type:fc.item().Type });
			}
			fso = null;
			return (arrFolderList);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더리스트 가져오기 실패"
			}
		}
	},

	getFolderInfo: function(folderspec){
		try{
			var objFolderInfo = {};
			var fso, fldr, fc;

			fso = this.FSO;
			fldr = fso.GetFolder(folderspec);

			objFolderInfo.folderName = ""+fldr.Name;
			objFolderInfo.driveLetter = (""+fldr.Drive).replace(":",'');
			objFolderInfo.path = ""+fldr;
			objFolderInfo.parentFolder = ""+fldr.ParentFolder;
			objFolderInfo.subFolderCount = fldr.SubFolders.Count;
			objFolderInfo.fileCount = fldr.files.Count;

			objFolderInfo.isRootFolder = (folderspec == this.getMapPath("/")) ? true : false;
			fso = null;
			return (objFolderInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				mse: "폴더정보가져오기 실패"
			}
		}
	},

	getFolderDetailInfo: function(folderspec){
		try{
			var fso, f, fc;
			var objDetailFolderInfo = {};

			var folderInfo = this.getFolderInfo(folderspec);
			objDetailFolderInfo.folderInfo = folderInfo;

			var subFolderList = this.getFolderList(folderspec);
			objDetailFolderInfo.subFolderList = subFolderList;

			var fileList = this.getFileList(folderspec);
			objDetailFolderInfo.fileList = fileList;

			objDetailFolderInfo.root = this.getMapPath("/");

			return (objDetailFolderInfo);
		}catch( e ){
			var objErr = Server.GetLastError();
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더리스트 가져오기 실패"
			}
		}
	},

	makeFolder: function(folderspec, nm, tp ){
		try{
			var objFolderInfo = {};
			var fso, fldr, fc;

			fso = this.FSO;
			if (fso.FolderExists(folderspec)) {
				objFolderInfo.checkResult = this.checkFolderNameAvailable(folderspec, nm, tp);
				if(!objFolderInfo.checkResult.nmCheck){
					fso.CreateFolder (folderspec+"\\"+objFolderInfo.checkResult.nm);
					objFolderInfo.msg = "폴더가 생성되었습니다.";
					objFolderInfo.mappath = folderspec+"\\"+objFolderInfo.checkResult.nm;
				}else{
					objFolderInfo.error = {code : "samefolder"};
					objFolderInfo.msg = "같은이름의 폴더가 있습니다.";
					objFolderInfo.mappath = "";
				}
				objFolderInfo.availableTarget = true;
			}else{
				objFolderInfo.error = {code : "incorrectpath"};
				objFolderInfo.msg = "폴더를 생성할경로가 존재하지 않습니다.";
				objFolderInfo.availableTarget = false;
			}

			fso = null;
			return (objFolderInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더생성 실패"
			}
		}
	},

	checkFolderNameAvailable: function(folderspec, nm, tp){
		try{
			var fso, compareNM, i = 0;
			var objFolderInfo = {};

			fso = this.FSO;
			objFolderInfo.nmCheck = true;

			do{
				if (i == 0) compareNM = nm;
				else compareNM = nm+"("+i+")";

				if (fso.FolderExists(folderspec+"//"+compareNM)) {
					objFolderInfo.nmCheck = true;
					if (!tp) break;
				}else{
					objFolderInfo.nmCheck = false;
				}
				i += 1;

			}while(objFolderInfo.nmCheck);

			objFolderInfo.nm = compareNM;
			fso = null;
			return (objFolderInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더이름확인 실패"
			}
		}
	},

	deleteFolder: function(folderspec, tp){
		try{
			var fso;
			var objFolderInfo = {};
			tp = tp ? tp : false;

			fso = this.FSO;
			if (fso.FolderExists(folderspec)) {
				var arrFile = this.getFileList(folderspec);
				if (arrFile.length > 0){
					if (tp){
						fso.DeleteFolder(folderspec);
						objFolderInfo.msg = "폴더가 삭제되었습니다.";
					}else{
						objFolderInfo.error = {code : "existfile"};
						objFolderInfo.msg = "파일이 존재하기 때문에 폴더가 삭제되지 않았습니다.";
					}
				}else{
					fso.DeleteFolder(folderspec);
					objFolderInfo.msg = "폴더가 삭제되었습니다.";
				}
				objFolderInfo.availableTarget = true;
			}else{
				objFolderInfo.error = {code : "incorrectpath"};
				objFolderInfo.msg = "폴더를 삭제할 경로가 존재하지 않습니다.";
				objFolderInfo.availableTarget = false;
			}

			fso = null;
			return (objFolderInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더삭제 실패"
			}
		}

	},

	moveFolder: function(folderspec, destination, tp){
		try{
			var fso, f;
			var objFolderInfo = {};
			tp = tp ? tp : false;

			fso = this.FSO;
			if (fso.FolderExists(destination)){
				f = this.getFolderInfo(folderspec);
				if (fso.FolderExists(destination+"\\"+f.folderName)){
					objFolderInfo.error = {code : "samefoldername"};
					objFolderInfo.msg = "이동할 경로에 같은이름을 가진 폴더가 있습니다.";

					if (tp){
						//overwrite option
					}else{
						//overwrite option
					}
				}else{
					fso.MoveFolder(folderspec, destination);
					objFolderInfo.msg = folderspec+" => "+destination+" 폴더가 이동되었습니다.";
				}
				objFolderInfo.availableTarget = true;
			}else{
				objFolderInfo.error = {code : "incorrectpath"};
				objFolderInfo.msg = "이동할 경로가 존재하지 않습니다.";
				objFolderInfo.availableTarget = false;
			}

			fso = null;
			return (objFolderInfo);
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더이동 실패"
			}
		}
	},

	moveFolders: function(folderspec, destination, folderNameRegExp, regExpFlag, tp){
		//인자를 오브젝트로 묶어서 전달하는 방식으로 수정
		try{
			var fso, f, re;
			var objFolderInfo = {};
			tp = tp ? tp : false;
			regExpFlag = regExpFlag ? regExpFlag : "ig";
			re = (folderNameRegExp == undefined) ? "" : new RegExp(folderNameRegExp, regExpFlag);

			fso = this.FSO;
			if (fso.FolderExists(destination)){
				var arrFolderList = this.getFolderList(folderspec);
				var movedFolder = [], unMovedFolder = [], isMoveCheck;

				//println(arrFolderList);
				$.each(arrFolderList, function(idx, o){
					isMoveCheck = false;
					if (re == ""){
						isMoveCheck = true;
					}else{
						if ((o.nm+"").search(re) > -1) isMoveCheck = true;
					}

					if (isMoveCheck){
						if (fso.FolderExists(destination+"\\"+o.nm)){
							unMovedFolder.push(o);

							if (tp){
								//overwrite option
							}else{
								//overwrite option
							}
						}else{
							movedFolder.push(o);
							fso.MoveFolder(folderspec+"\\"+o.nm, destination);
						}
					}
				});

				objFolderInfo.movedFolder = movedFolder;
				objFolderInfo.unMovedFolder = unMovedFolder;
				objFolderInfo.msg = movedFolder.length + "개 폴더가 이동되고 "+unMovedFolder.length+"개 폴더가 이동되지 않았습니다.";
				objFolderInfo.availableTarget = true;

			}else{
				objFolderInfo.error = {code : "incorrectpath"};
				objFolderInfo.msg = "이동할 경로가 존재하지 않습니다.";
				objFolderInfo.availableTarget = false;
			}

			fso = null;
			return (objFolderInfo);
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "폴더이동 실패"
			}
		}
	},

	__________file: function(){},
	isFileExist: function(filespec){
		try{
			var fso = this.FSO;
			var isBoolean = fso.FileExists(filespec);
			fso = null;

			return (isBoolean);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일확인 실패"
			}
		}
	},

	getFileList: function(folderspec){
		try{
			var fso, f, fc, s;
			var arrFileList = [];
			fso = this.FSO;
			f = fso.GetFolder(folderspec);
			fc = new Enumerator(f.files);

			for (; !fc.atEnd(); fc.moveNext()){
				//print(new Date(fc.item().DateCreated));
				var fcd = fso.GetFile(fc.item());
				//""+fc.item().DateLastAccessed, ""+fc.item().DateLastModified, ""+fc.item().DateCreated
				arrFileList.push({fullPath:""+fc.item(), nm:fc.item().Name, size:fc.item().size.byte(), type:fc.item().Type, created:(new Date(fc.item().DateCreated)).getTime(), modified:(new Date(fc.item().DateLastModified)).getTime(), extName:fso.GetExtensionName(fc.item()) });
			}

			fso = null;
			return (arrFileList);
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일리스트가져오기 실패"
			}
		}
	},

	getFileInfo: function(filespec){
		try{
			var fso, f, s="";
			var objFileInfo = {};
			fso = this.FSO;

			f = fso.GetFile(filespec);
			objFileInfo.name= f.Name;
			objFileInfo.type= f.Type;
			objFileInfo.size= f.size.byte();
			objFileInfo.path= f.Path;
			//objFileInfo.attributes = f.attributes ;

			//objFileInfo.dateCreated = (""+f.DateCreated).date().print();
			objFileInfo.created = (new Date(f.DateCreated)).getTime();
			objFileInfo.accessed = (new Date(f.DateLastAccessed)).getTime();
			objFileInfo.modified = (new Date(f.DateLastModified)).getTime();

			fso = null;
			return (objFileInfo);
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일정보가져오기 실패"
			}
		}
	},

	makeFile: function(folderspec, nm, tp ){
		try{
			var objFileInfo = {};
			var fso, f;

			tp = tp ? tp : false;

			fso = this.FSO;
			if (fso.FolderExists(folderspec)) {
				objFileInfo.checkResult = this.checkFileNameAvailable(folderspec, nm, tp);


				if(!objFileInfo.checkResult.nmCheck){
					fso.CreateTextFile(folderspec+"\\"+objFileInfo.checkResult.nm, true);
					this.writeFile(folderspec+"\\"+objFileInfo.checkResult.nm, 2);

					objFileInfo.msg = "파일이 생성되었습니다.";
					objFileInfo.mappath = folderspec+"\\"+objFileInfo.checkResult.nm;
				}else{
					if (tp){
						fso.CreateTextFile(folderspec+"\\"+objFileInfo.checkResult.nm, true);
						objFileInfo.msg = objFileInfo.checkResult.nm+"파일이 덮어쓰기 되었습니다.";
						objFileInfo.mappath = "";
					}else{
						objFileInfo.error = {code : "samefilename"};
						objFileInfo.msg = "같은이름의 파일이 있습니다.";
						objFileInfo.mappath = "";
					}
				}
				objFileInfo.availableTarget = true;
			}else{
				objFileInfo.error = {code : "incorrectpath"};
				objFileInfo.msg = "파일를 생성할경로가 존재하지 않습니다.";
				objFileInfo.availableTarget = false;
			}

			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일생성 실패"
			}
		}
	},

	checkFileNameAvailable: function(folderspec, nm, tp){
		try{
			var fso, compareNM, i = 0;
			var objFileInfo = {};

			fso = this.FSO;
			objFileInfo.nmCheck = true;

			do{
				if (i == 0){
					compareNM = nm;
				}else{
					var arrTmp = nm.split(".");
					compareNM = arrTmp[0]+"("+i+")."+arrTmp[1];
				}

				if (fso.FileExists(folderspec+"//"+compareNM)) {
					objFileInfo.nmCheck = true;
					if (!tp) break;
				}else{
					objFileInfo.nmCheck = false;
				}
				i += 1;

			}while(objFileInfo.nmCheck);

			objFileInfo.nm = compareNM;
			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일이름확인 실패"
			}
		}

	},

	deleteFile: function(filespec) {
		try{
			var fso;
			var objFileInfo = {};

			fso = this.FSO;
			if (fso.FileExists(filespec)) {
				fso.DeleteFile(filespec);
				objFileInfo.msg = "파일이 삭제되었습니다.";
				objFileInfo.availableTarget = true;
			}else{
				objFileInfo.error = {code : "incorrectpath"};
				objFileInfo.msg = "삭제할 파일이 존재하지 않습니다.";
				objFileInfo.availableTarget = false;
			}
			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일삭제 실패"
			}
		}
	},

	moveFile: function(filespec, destination, tp){
		try{
			var fso, f;
			var objFileInfo = {};

			tp = tp ? tp : false;

			fso = this.FSO;
			if (fso.FolderExists(destination)){
				f = this.getFileInfo(filespec);
				if (fso.FileExists(destination+"\\"+f.name)){
					objFileInfo.error = {code : "samefilename"};
					objFileInfo.msg = "이동할 경로에 같은이름을 가진 파일이 있습니다.";

					if (tp){
						//overwrite option
					}else{
						//overwrite option
					}
				}else{
					fso.MoveFile(filespec, destination);
					objFileInfo.msg = "파일이 이동되었습니다.";
				}
				objFileInfo.availableTarget = true;
			}else{
				objFileInfo.error = {code : "incorrectpath"};
				objFileInfo.msg = "이동할 경로가 존재하지 않습니다.";
				objFileInfo.availableTarget = false;
			}
			fso = null;
			return (objFileInfo);
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일이동 실패"
			}
		}
	},

	moveFiles: function(folderspec, destination, fileNameRegExp, regExpFlag, tp){
		try{
			var fso, f, fc, re;
			var objFileInfo = {};

			tp = tp ? tp : false;
			regExpFlag = regExpFlag ? regExpFlag : "ig";
			re = (fileNameRegExp == undefined) ? "" : new RegExp(fileNameRegExp, regExpFlag);

			fso = this.FSO;
			if (fso.FolderExists(destination)){
				var arrFileList = this.getFileList(folderspec);
				var movedFile = [], unMovedFile = [], isMoveCheck;

				$.each(arrFileList, function(idx, o){
					isMoveCheck = false;
					if (re == ""){
						isMoveCheck = true;
					}else{
						if ((o.nm+"").search(re) > -1) isMoveCheck = true;
					}

					if (isMoveCheck){
						if (fso.FileExists(destination+"\\"+o.nm)){
							unMovedFile.push(o);

							if (tp){
								//overwrite option
							}else{
								//overwrite option
							}
						}else{
							movedFile.push(o);
							fso.MoveFile(folderspec+"\\"+o.nm, destination);
						}
					}
				});

				objFileInfo.movedFile = movedFile;
				objFileInfo.unMovedFile = unMovedFile;
				objFileInfo.msg = movedFile.length + "개 파일이 이동되고 "+unMovedFile.length+"개 파일이 이동되지 않았습니다.";

				objFileInfo.availableTarget = true;
			}else{
				objFileInfo.error = {code : "incorrectpath"};
				objFileInfo.msg = "이동할 경로가 존재하지 않습니다.";
				objFileInfo.availableTarget = false;
			}
			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일이동 실패"
			}
		}
	},

	copyFile: function(filespec, destination, tp){
		try{
			var fso, f;
			var objFileInfo = {};

			tp = tp ? tp : false;

			fso = this.FSO;
			if (fso.FolderExists(destination)){
				f = this.getFileInfo(filespec);
				if (fso.FileExists(destination+"\\"+f.name)){
					if (tp){
						fso.CopyFile(filespec, destination, true);
						objFileInfo.msg = "파일이 복사되었습니다.";
					}else{
						objFileInfo.error = {code : "samefilename"};
						objFileInfo.msg = "복사할 경로에 같은이름을 가진 파일이 있습니다.";
					}
				}else{
					fso.CopyFile(filespec, destination);
					objFileInfo.msg = "파일이 복사되었습니다.";
				}
				objFileInfo.availableTarget = true;
			}else{
				objFileInfo.error = {code : "incorrectpath"};
				objFileInfo.msg = "복사할 경로가 존재하지 않습니다.";
				objFileInfo.availableTarget = false;
			}
			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일복사 실패"
			}
		}
	},

	writeFile: function(filespec, op1, str, op2){
		/*
		f.OpenAsTextStream(ForReading, TristateUseDefault);

		ForReading 1 읽기 전용 모드로 파일을 엽니다. 이 파일에는 쓸 수 없습니다.
		ForWriting 2 쓰기 모드로 파일을 엽니다.
		ForAppending 8 파일을 열고 파일의 끝에 쓸 수 있습니다.

		TristateUseDefault -2 시스템 기본값으로 파일을 엽니다.
		Tristatetrue -1 유니코드 형식으로 파일을 엽니다.
		Tristatefalse 0 ASCII 형식으로 파일을 엽니다.
		*/

		try{
			var fso, f, ts;
			var objFileInfo = {};

			str = str ? str : "기본값입니다. 그런데 있을필요는 없겠지요";
			op2 = op2 ? op2 : 0;
			fso = this.FSO;
			f = fso.GetFile(filespec);
			ts = f.OpenAsTextStream(op1, op2);
			
			if (op1 == 2 || op1 == 8){
				ts.WriteLine(str);
				ts.Close( );

   				ts = f.OpenAsTextStream(1, op2);
				objFileInfo.cont = ts.ReadAll( );
			}else{
				objFileInfo.cont = "";
				objFileInfo.error = {code : "incorrectmode"};
				objFileInfo.msg = "비정상적인 모드로 파일을 열었습니다."
			}

			ts.Close();

			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일쓰기 실패"
			}
		}
	},

	readFile: function(filespec, lineNo, op2){
		try{
			var fso, f, ts;
			var objFileInfo = {};
			lineNo = lineNo ? lineNo : 0;
			op2 = op2 ? op2 : 0;

			fso = this.FSO;
			f = fso.GetFile(filespec);
			ts = f.OpenAsTextStream(1, op2);

			if (lineNo > 0){
				for(var i=1; i<lineNo; i++) ts.SkipLine();
				objFileInfo.cont = ts.ReadLine();
			}else{
				objFileInfo.cont = ts.ReadAll();
			}

			ts.Close();

			fso = null;
			return (objFileInfo);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일읽기 실패"
			}
		}
	},

	makeUniqueFileName: function(folderspec, nm){
		try{
			var fso, i = 0;
			var isUnique, fileName, tmpName;
			var yyyy, mm, dd, hh, mi, ss, ms, today;
			var objFile = {};
			objFile.originName = nm;

			var fileExt = nm.match(/\.([0-9a-zA-Z]+)$/);
			objFile.fileExt= fileExt[1];

			today = new Date();
			yyyy = today.getFullYear();
			mm = (today.getMonth()+1).setDigit(2);
			dd = today.getDate().setDigit(2);
			hh = today.getHours().setDigit(2);
			mi = today.getMinutes().setDigit(2);
			ss = today.getSeconds().setDigit(2);
			ms = today.getMilliseconds().setDigit(3);

			fileName = yyyy+mm+dd+hh+mi+ss+ms;

			isUnique = true;
			fso = this.FSO;
			do{
				i += 1;
				tmpName = fileName + i.setDigit(3) + fileExt[0];
				if (fso.FileExists(folderspec+"//"+tmpName)) {
					isUnique = true;
				}else{
					isUnique = false;
				}
			}while(isUnique);

			objFile.uniqueName = tmpName;

			fso = null;
			return (objFile);

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "파일이름생성 실패"
			}
		}
	},
	__________method: function(){},
	
	getUploadFolderName: function(path, cnt){
			var localPath = this.getMapPath(path);
			var uploadFolderName = "";
			var fso = this.FSO;
			var fObj = this.getFolderInfo(localPath);
			
			println(localPath);
			
			var fc = fObj.subFolderCount;
			println(fc);
			var fileCnt = this.getFolderInfo(localPath+"\\"+fc).fileCount;
			println(fileCnt);
			uploadFolderName = path+"/"+fc;
			if (parseInt(fileCnt) > parseInt(cnt)){
				var result = fso.makeFolder(localPath, (parseInt(fc)+1), false );
				if (result.error != undefined){
					uploadFolderName = path+"\\"+(parseInt(fc)+1);
				}else{
					return (result);
				}
			}
			fso = null;
			return (uploadFolderName);
		/*
		try{	
		}catch( e ){
			this.pushLog( e.description );
			return {
				error: {
					code:"exception",
					description: e.description
				},
				msg: "업로드 폴더경로  가져오기 실패"
			}
		}
		*/
	}
		
});
%>