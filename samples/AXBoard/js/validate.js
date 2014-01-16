/*
* [지원되는 유효성검사 목록]
* v-req			: 필수입력
* v-num			: 숫자만 입력
* v-tel-num		: 전화번호 형식(하이픈 '-' 포함 형식)
* v-telnum		: 전화번호 형식(하이픈 제외 형식)
* v-gtel g-1    : 전화번호 그룹 형식 체크( 하이픈 제외 ) g-1 에서 1은 그룹번호를 의미한다. 그룹끼리 번호로 묶어야한다.
* v-email		: 이메일 형식
* v-ssn			: 주민등록번호 형식
* v-companyno	: 사업자등록번호 형식
* v-birth		: 생년월일 형식 (831020)
* v-engnum		: 영문과 숫자만 가능한 형식
* v-opt			: radio 또는 checkbox 값
* v-len			: 문자열 입력 길이 제한 체크 
*/
function validate(formID) {
    var test = true;

	if (formID != undefined){
		var checkClassStr = '#'+formID+' .v-qty, #'+formID+' .v-phone, #'+formID+' .v-userid, #'+formID+' .v-req, #'+formID+' .v-digits, #'+formID+' .v-tel-num, #'+formID+' .v-phone, #'+formID+' .v-mobile, #'+formID+' .v-email, #'+formID+' v-email1, #'+formID+' .v-ssn1, #'+formID+' .v-ssn3, #'+formID+' .v-ssn5, #'+formID+' .v-companyno1, #'+formID+' .v-companyno4, #'+formID+' .v-cpnum1, #'+formID+' .v-opt, #'+formID+' .v-len, #'+formID+' .v-gtel, #'+formID+' .v-engnum'
	}else{
		var checkClassStr = '.v-qty, .v-phone, .v-userid, .v-req, .v-digits, .v-tel-num, .v-phone, .v-mobile, .v-email, v-email1, .v-ssn1, .v-ssn3, .v-ssn5, .v-companyno1, .v-companyno4, .v-cpnum1, .v-opt, .v-len, .v-gtel, .v-engnum'
	}

    $(checkClassStr).each(function(i, o) {
        var val = $(o).val();
        var classNames = $(o).attr('class');

        var objName = typeof ($(o).attr('title')) != "undefined" ? $(o).attr('title') : "";

        if (/v-req/.test(classNames)) { // 필수입력
            if (!val || val.length == 0) {
                alert(objName + "(은)는 반드시 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;

            }
        }

        if (/v-num/.test(classNames)) { // 숫자만 입력
            if (isNaN(val) || /[^\d]/.test(val)) {
                var objName = $(o).attr('title') != "" ? $(o).attr('title') : $('label[for=' + $(o).attr('id') + ']').text();
                alert(objName + "(은)는 숫자만 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-tel-num/.test(classNames)) { // 전화번호 형식(하이픈 제외)
            var pattern = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;

            if (!pattern.test(val)) {
                alert(objName + "(은)는 형식이 올바르지 않습니다.\n하이픈(-)을 포함하여 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-telnum/.test(classNames)) { // 전화번호 형식(하이픈 포함)
            var pattern = /^[0-9]{9,11}$/;

            if (!pattern.test(val)) {
                alert(objName + "(은)는 형식이 올바르지 않습니다.\n숫자만 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-mobile/.test(classNames)) { // 휴대전화 형식
            var pattern = /(01[016789])(\d{4}|\d{3})\d{4}$/g;

            if (!pattern.test(val)) {
                alert(objName + "(은)는 형식이 올바르지 않습니다.\n숫자만 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-email/.test(classNames)) { // 이메일 형식
            var pattern = /[A-z0-9_\-]{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/;
            val = $(o).val() + '@' + $(o).next().val();

            if (!pattern.test(val)) {
                alert(objName + "바른 이메일 주소를 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-email1/.test(classNames)) { // 이메일 형식
            var pattern = /\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/;
            val = $(o).val();

            if (!pattern.test(val)) {
                alert(objName + "바른 이메일 주소를 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-ssn1/.test(classNames)) { // 주민등록번호 형식(하이픈 '-' 제외)
            val = $(o).val() + $(o).next().val();

			if (val == '1111111111111') {
				return true;
			}

			if (fnrrnCheck(val) || fnfgnCheck(val)) {  
				return true;  
			}  
			else
			{
                alert("주민등록번호를 확인하세요.");
                $(o).focus();
                test = false;
                return false;

	            test = false;
				return false;  
			}
        }
        if (/v-ssn3/.test(classNames)) { // 무조건체크(1연속 입력 체크 제외)
            val = $(o).val() + $(o).next().val();

			if (fnrrnCheck(val) || fnfgnCheck(val)) {  
				return true;  
			}  
			else
			{
                alert("주민등록번호를 확인하세요.");
                $(o).focus();
                test = false;
                return false;

	            test = false;
				return false;  
			}
        }
        if (/v-ssn5/.test(classNames)) { // 공백인정
            val = $(o).val() + $(o).next().val();

			if (val.trim() == '') {
				return true;
			}

			if (fnrrnCheck(val) || fnfgnCheck(val)) {  
				return true;  
			}  
			else
			{
                alert("주민등록번호를 확인하세요.");
                $(o).focus();
                test = false;
                return false;

	            test = false;
				return false;  
			}
        }
        if (/v-companyno1/.test(classNames)) { // 사업자 등록번호 형식 (하이픈 '-' 제외)
            var pattern = /(^[0-9]{10}$)/;

            val = $(o).val() + $(o).next().val() + $(o).next().next().val();

            if (val == '1111111111') {
                return true;
            }

            if (!pattern.test(val)) {
                alert("사업자등록번호를 10자리 숫자로 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            } else {
                var sum = 0;
                var at = 0;
                var att = 0;
                var saupjano = val;
                sum = (saupjano.charAt(0) * 1) +
					  (saupjano.charAt(1) * 3) +
					  (saupjano.charAt(2) * 7) +
					  (saupjano.charAt(3) * 1) +
					  (saupjano.charAt(4) * 3) +
					  (saupjano.charAt(5) * 7) +
					  (saupjano.charAt(6) * 1) +
					  (saupjano.charAt(7) * 3) +
					  (saupjano.charAt(8) * 5);
                sum += parseInt((saupjano.charAt(8) * 5) / 10);
                at = sum % 10;
                if (at != 0)
                    att = 10 - at;

                if (saupjano.charAt(9) != att) {
                    alert("올바른 사업자등록번호가 아닙니다.");
                    $(o).focus();
                    test = false;
                    return false;
                }
            }
        }
        if (/v-companyno4/.test(classNames)) { // 무조건체크(1연속 입력 체크 제외)
            var pattern = /(^[0-9]{10}$)/;

            val = $(o).val() + $(o).next().val() + $(o).next().next().val();

            if (!pattern.test(val)) {
                alert("사업자등록번호를 10자리 숫자로 입력하셔야 합니다.");
                $(o).focus();
                test = false;
                return false;
            } else {
                var sum = 0;
                var at = 0;
                var att = 0;
                var saupjano = val;
                sum = (saupjano.charAt(0) * 1) +
					  (saupjano.charAt(1) * 3) +
					  (saupjano.charAt(2) * 7) +
					  (saupjano.charAt(3) * 1) +
					  (saupjano.charAt(4) * 3) +
					  (saupjano.charAt(5) * 7) +
					  (saupjano.charAt(6) * 1) +
					  (saupjano.charAt(7) * 3) +
					  (saupjano.charAt(8) * 5);
                sum += parseInt((saupjano.charAt(8) * 5) / 10);
                at = sum % 10;
                if (at != 0)
                    att = 10 - at;

                if (saupjano.charAt(9) != att) {
                    alert("올바른 사업자등록번호가 아닙니다.");
                    $(o).focus();
                    test = false;
                    return false;
                }
            }
        }
        if (/v-birth/.test(classNames)) { // 생년월일 형식 (831020) 
            var pattern = /(^[0-9]{6}$)/;

            if (!pattern.test(val)) {
                alert("주민번호 앞자리 또는 생년월일 형식은 6자리 숫자로 입력하셔야 합니다.");
                $(o).val('');
                $(o).focus();
                test = false;
                return false;
            } else {
                var y = NUMBER(val.substring(0, 2));
                var m = NUMBER(val.substring(2, 4));
                var d = NUMBER(val.substring(4, 6));
                var bool = false;
                if (m > 12) {
                    bool = true;
                }
                if (d < 1 || d > 31) {
                    bool = true;
                }

                if (bool) {
                    alert("생년월일 형식이 올바르지 않습니다.");
                    $(o).focus();
                    $(o).val('');
                    test = false;
                    return false;
                }
            }
        }
        if (/v-engnum/.test(classNames)) { // 생년월일 형식 (831020) 
            var pattern = /[a-z][a-z_0-9]*$/;

            if (!pattern.test(val)) {
                alert(objName + "(은)는 영문소문자와 숫자만 입력가능하며 영문으로 시작되어야 합니다.");
                $(o).val('');
                $(o).focus();
                test = false;
                return false;
            }
        }
        if (/v-opt/.test(classNames)) { // 라디오 버튼 또는 체크박스
            if ($(o).attr('type') == 'radio' || $(o).attr('type') == 'checkbox') {
                var obFlag = false;
                var obName = $(o).attr('name');
                var cnt = 0;
                $('input[name=' + obName + ']').each(function(x) {
                    cnt++;
                    if ($(this).attr('checked')) {
                        obFlag = true;
                        return;
                    }
                });

                if (!obFlag) {
                    alert(objName + "(을)는 선택하십시오");
                    test = false;
                    return false;
                }
            }
        }
        if (/v-len/.test(classNames)) { // 길이 제한 체크 max or min

            var maxLen = Number($(o).attr("maxlength"));
            var minLen = $(o).attr("minlength") ? Number($(o).attr("minlength")) : 0;
            var objLen = $(o).val().length;
            var msg;
            var mode = 0;
            mode += maxLen > 0 ? 1 : 0;
            mode += minLen > 0 ? 2 : 0;
            var rtn = true;
            switch (mode) {
                case 1: // max
                    if (objLen >= maxLen) {
                        msg = objName + "(은)는 허용하는 최대 길이가 " + maxLen + " 자리 입니다";
                        alert(msg);
                        rtn = false;
                        test = false;
                        $(o).focus();
                    }
                    break;

                case 2: // min
                    if (objLen < minLen) {
                        msg = objName + "(은)는 최소 " + minLen + " 자리 이상 입력";
                        alert(msg);
                        rtn = false;
                        test = false;
                        $(o).focus();
                    }
                    break;

                case 3: // min - max 
                    if (objLen < minLen || objLen > maxLen) {
                        msg = objName + "(은)는 최소 " + minLen + " 자리부터 최대 " + maxLen + " 자리까지 입력";
                        alert(msg);
                        rtn = false;
                        test = false;
                        $(o).focus();
                    }

                    break;
            }
            return rtn;
        }

        if (/v-phone/.test(classNames)) { // 전화번호 형식(하이픈 포함)
            //var pattern = /^[0-9]{9,11}$/;
            var pattern = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/;

            var phone = $(o).val() + "-" + $(o).next().val() + "-" + $(o).next().next().val()

            if (phone != "--") {
                if (!pattern.test(phone)) {
                    alert(objName + "(은)는 형식이 올바르지 않습니다.\n숫자만 입력하셔야 합니다.");
                    $(o).focus();
                    test = false;
                    return false;
                }
            }
        }
        
        if (/v-gtel/.test(classNames)) { // 그룹 전화번호 체크 g-그룹번호 지정으로 그룹을 묶어줘야함

            var clazz = $(this).attr('class');

			var classnm = $(this).attr('class');
			var st = classnm.indexOf("g-");

            var groupName = "." + classnm.substr(st,4);
            var groupEmptyCount = 0;
            var groupEmpty = false;
            var groupCount = 0;
            var group = new Object();
            var emptyObject = null;
			var rtn = true;
			var isNotSelect = true;

            $(groupName).each(function(i, o) {
                groupCount++;
                group[$(this).attr('name')] = $(this).val();

                if ($(this).val() == "" || $(this).val().length == 0) {
                    if (emptyObject == null) {
                        emptyObject = o;
                    }
                }
                
                if ( $(this)[0].tagName == "SELECT" ) {
                    isNotSelect = false;
                }
            });

            for (var key in group) {
                if (group[key] == "" || group[key].length == 0) {
                    groupEmptyCount++;
                }
            }

            if (groupEmptyCount > 0) {
                if (groupCount != groupEmptyCount) {
                    alert(objName + "(은)를 모두 입력하셔야 합니다.");
                    $(emptyObject).focus();
					rtn = false;
					test = false;
                    return false;
                }
            } else {
                //var pattern = /^[0-9]{9,11}$/;
			    var pattern = /^(0[2-8][0-5]?|01[01346-9])-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
                var val = "";

                for (var key in group) {
                    val += group[key]
                }
                if ( isNotSelect ) {
                    if (!pattern.test(val)) {
                        alert(objName + "(은)는 형식이 올바르지 않습니다.\n숫자만 입력하셔야 합니다.");
                        $(o).focus();
					    rtn = false;
					    test = false;
                        return false;
                    }
               }
            }
			return rtn;
        }
    });
    return test;
}

function juminChk(val1, val2)
{
	var pattern = /(^[0-9]{13}$)/;
	val = val1.val() + val2.val();

	if (!pattern.test(val)) {
		alert("주민등록번호를 13자리 숫자로 입력하셔야 합니다.");
		$(val1).focus();
		test = false;
		return false;
	} else {
		var sum_1 = 0;
		var sum_2 = 0;
		var at = 0;
		var juminno = val;
		sum_1 = (juminno.charAt(0) * 2) +
				(juminno.charAt(1) * 3) +
				(juminno.charAt(2) * 4) +
				(juminno.charAt(3) * 5) +
				(juminno.charAt(4) * 6) +
				(juminno.charAt(5) * 7) +
				(juminno.charAt(6) * 8) +
				(juminno.charAt(7) * 9) +
				(juminno.charAt(8) * 2) +
				(juminno.charAt(9) * 3) +
				(juminno.charAt(10) * 4) +
				(juminno.charAt(11) * 5);
		sum_2 = sum_1 % 11;

		if (sum_2 == 0)
			at = 10;
		else {
			if (sum_2 == 1)
				at = 11;
			else
				at = sum_2;
		}
		att = 11 - at;

		if (juminno.charAt(12) != att ||
			juminno.substr(2, 2) < '01' ||
			juminno.substr(2, 2) > '12' ||
			juminno.substr(4, 2) < '01' ||
			juminno.substr(4, 2) > '31' ||
			juminno.charAt(6) > 4) {
			alert("올바른 주민등록번호가 아닙니다.");
			$(val1).focus();
			test = false;
			return false;
		}
	}

	return true;

}

function cutStr(str,limit){  
	var tmpStr = str;  
	var byte_count = 0;  
	var len = str.length;  
	var dot = "";  
	for(i=0; i<len; i++){  
	  byte_count += chr_byte(str.charAt(i));   
	  if(byte_count == limit-1){  
		 if(chr_byte(str.charAt(i+1)) == 2){  
			tmpStr = str.substring(0,i+1);  
			dot = "...";  
		 } else {  
			if(i+2 != len) dot = "...";  
			tmpStr = str.substring(0,i+2);  
		 }  
		 break;  
	  } else if(byte_count == limit){  
		 if(i+1 != len) dot = "...";  
		 tmpStr = str.substring(0,i+1);  
		 break;  
	  }  
	}  
	return tmpStr+dot;  
//	return true;  
}  
  
function chr_byte(chr){  
   if(escape(chr).length > 4)  
      return 2;  
   else  
      return 1;  
}  

function isValidDate(dateStr) {
   var year = Number(dateStr.substr(0,4));  
   var month = Number(dateStr.substr(4,2));
   var day = Number(dateStr.substr(6,2));
 
   if (month < 1 || month > 12) return false;
   if (day < 1 || day > 31) return false;
   if ((month==4 || month==6 || month==9 || month==11) && day==31) return false

   if (month == 2) { // check for february 29th
		var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
			if (day>29 || (day==29 && !isleap)) return false;
   }

   return true;
} 


function fnrrnCheck(rrn) // 주민등록번호유효성검사.  
{  
    var sum = 0;  
    if (rrn.length != 13) {  
        return false;  
    }  
    else if (rrn.substr(6, 1) != 1 && rrn.substr(6, 1) != 2 && rrn.substr(6, 1) != 3 && rrn.substr(6, 1) != 4) {  
        return false;  
    }  

    for (var i = 0; i < 12; i++) {  
        sum += Number(rrn.substr(i, 1)) * ((i % 8) + 2);  
    }  

    if (((11 - (sum % 11)) % 10) == Number(rrn.substr(12, 1))) {  
        return true;  
    }  
    return false;  
}  

function fnfgnCheck(socno) // 외국인등록번호유효성검사.  
{  
	/*
    var sum = 0;  

    if (rrn.length != 13) {  
        return false;  
    }  
    else if (rrn.substr(6, 1) != 5 && rrn.substr(6, 1) != 6 && rrn.substr(6, 1) != 7 && rrn.substr(6, 1) != 8) {  
        return false;  
    }  

    if (Number(rrn.substr(7, 2)) % 2 != 0) {  
        return false;  
    }  

    for (var i = 0; i < 12; i++) {  
        sum += Number(rrn.substr(i, 1)) * ((i % 8) + 2);  
    }  

    if ((((11 - (sum % 11)) % 10 + 2) % 10) == Number(rrn.substr(12, 1))) {  
        return true;  
		alert(112);
    }  

    return false;  
	*/

     var total =0;
     var parity = 0;

     var fgnNo = new Array(13);

     for(i=0;i < 13;i++) fgnNo[i] = parseInt(socno.charAt(i));

     if(fgnNo[11] < 6) return false;

     if((parity = fgnNo[7]*10 + fgnNo[8])&1) return false;

	 var weight = 2;

     for(i=0,total=0;i < 12;i++)
     {
          var sum = fgnNo[i] * weight;
          total += sum;

          if(++weight > 9) weight=2;
     }

     if((total = 11 - (total%11)) >= 10) total -= 10;
     if((total += 2) >= 10) total -= 10;
     if(total != fgnNo[12]) return false;

     return true;
} 