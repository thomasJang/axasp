<%
/* *** extend implement block ***************************** */
var Class=(function(){
	function subclass(){};
	function create(){var parent=null, properties=$A(arguments);if(Object.isFunction(properties[0])) parent=properties.shift();function klass(){this.initialize.apply(this, arguments);}Object.extend(klass, Class.Methods);klass.superclass=parent;klass.subclasses=[];if(parent){subclass.prototype=parent.prototype;klass.prototype=new subclass;parent.subclasses.push(klass);}for (var i=0; i < properties.length; i++)klass.addMethods(properties[i]);if(!klass.prototype.initialize)klass.prototype.initialize=Prototype.emptyFunction;klass.prototype.constructor=klass;return klass;}
	function addMethods(source){var ancestor=this.superclass && this.superclass.prototype;var properties=Object.keys(source);if(!Object.keys({ toString: true }).length){if(source.toString != Object.prototype.toString) properties.push("toString");if(source.valueOf != Object.prototype.valueOf) properties.push("valueOf");}for (var i=0, length=properties.length; i < length; i++){var property=properties[i], value=source[property];if(ancestor && Object.isFunction(value) && value.argumentNames().first() == "$super"){var method=value;value=(function(m){return function(){ return ancestor[m].apply(this, arguments); };})(property).wrap(method);value.valueOf=method.valueOf.bind(method);value.toString=method.toString.bind(method);}this.prototype[property]=value;}return this;}
	return {create:create, Methods:{addMethods: addMethods}};
})();

(function(){
	var _toString=Object.prototype.toString;
	function extend(destination,source){for(var property in source) destination[property]=source[property];return destination;}
	function inspect(obj){try{if(isUndefined(obj)) return 'undefined';if(obj === null) return 'null';return obj.inspect ? obj.inspect() : String(obj);}catch(e){if(e instanceof RangeError) return '...';throw e;}}
	function toJSON(object, qoute) {
		var type = typeof object;
		var isqoute = qoute;
		if(isqoute == undefined) isqoute = true;
		switch (type) {
			case 'undefined':
			case 'function': return;
			case 'unknown': return;
			case 'boolean': return object.toString();
			case 'number' : return object.toString();
			case 'string' : return object.toJSON(true);
		}
		if (!object) return '\"\"';
		if (object === null) return 'null';
		if (object.toJSON) return object.toJSON(isqoute);
		if (isElement(object)) return;
		var results = [];
		for (var property in object) {
			if(object.hasOwnProperty(property)){
				var value = toJSON(object[property], isqoute);
				if (!isUndefined(value)) results.push(property.toJSON(isqoute) + ':' + value);
			}
		}
		return '{' + results.join(', ') + '}';
	}
	function keys(obj){var results=[];for (var property in obj) results.push(property);return results;}
	function values(obj){var results=[];for(var property in obj) results.push(obj[property]);return results;}
	function clone(obj){return extend({ }, obj);}
	function isElement(obj){return !!(obj && obj.nodeType == 1);}
	function isObject(obj){return _toString.call(obj) == "[object Object]";}
	function isArray(obj){return _toString.call(obj) == "[object Array]";}
	function isHash(obj){return obj instanceof Hash;}
	function isFunction(obj){return typeof obj==="function";}
	function isString(obj){return _toString.call(obj)=="[object String]";}
	function isNumber(obj){return _toString.call(obj)=="[object Number]";}
	function isUndefined(obj){return typeof obj==="undefined";}
	extend(Object, {extend:extend,inspect:inspect,toJSON:toJSON,keys:keys,values:values,clone:clone,isElement:isElement,isObject:isObject,isArray:isArray,isHash:isHash,isFunction:isFunction,isString:isString,isNumber:isNumber,isUndefined:isUndefined});
})();
Object.extend(Function.prototype, (function(){
	var slice=Array.prototype.slice;
	function update(array, args){var arrayLength=array.length, length=args.length;while(length--) array[arrayLength+length] = args[length];return array;}
	function merge(array, args){array=slice.call(array, 0);return update(array, args);}
	function argumentNames(){var names=this.toString().match(/^[\s\(]*function[^(]*\(([^)]*)\)/)[1].replace(/\/\/.*?[\r\n]|\/\*(?:.|[\r\n])*?\*\//g, '').replace(/\s+/g, '').split(',');return names.length == 1 && !names[0] ? [] : names;}
	function bind(context){if(arguments.length < 2 && Object.isUndefined(arguments[0])) return this;var __method=this, args=slice.call(arguments, 1);return function(){var a=merge(args, arguments);return __method.apply(context, a);}}
	function curry(){if(!arguments.length) return this;var __method=this, args=slice.call(arguments, 0);return function(){var a=merge(args, arguments);return __method.apply(this, a);}}
	function delay(timeout){var __method=this, args=slice.call(arguments, 1);timeout=timeout * 1000;return window.setTimeout(function(){return __method.apply(__method, args);}, timeout);}
	function defer(){var args=update([0.01], arguments);return this.delay.apply(this, args);}
	function wrap(wrapper){var __method=this;return function(){var a=update([__method.bind(this)], arguments);return wrapper.apply(this, a);}}
	function methodize(){if(this._methodized) return this._methodized;var __method=this;return this._methodized=function(){var a=update([this], arguments);return __method.apply(null, a);};}
	return {argumentNames:argumentNames,bind:bind,curry:curry,delay:delay,defer:defer,wrap:wrap,methodize:methodize}
})());


Object.extend(String.prototype, (function(){
	function left(strLen){ return this.toString().substr(0, strLen); }
	function right(strLen){ return this.substring(this.length-strLen, this.length); }
	function dec(){ return (this) ? decodeURIComponent(this.replace(/\+/g, " ")) : this; }
	function enc(){ return (this) ? encodeURIComponent(this) : this; }
	function object(){try{var res = this.evalJSON();}catch(e){res = {result:"err", msg:"to object error, "+e.print()+", "+this};try{mask.close();}catch(e){}}return res;}
	function array(){try{var res = this.split(/,/g); }catch(e){ res = {result:"err", msg:"to object error, "+e.print()+", "+this}; }return res;}
	function toDate(separator){
		if(this.length == 10){
			try{
				var aDate = this.split(separator || "-");
				return new Date(aDate[0], ((aDate[1])-1).number(), (aDate[2]).number(), 12);
			}catch(e){
				return new Date();
			}
		}else if(this.length < 10){
			return new Date();
		}else if(this.length > 15){
			try{
				var aDateTime = this.split(/ /g);
				var aDate = aDateTime[0].split(separator || "-");
				if(aDateTime[1]){
					var aTime = aDateTime[1];
				}else{
					var aTime = "09:00";
				}
				var is24 = true;
				if(aTime.right(2) == "AM" || aTime.right(2) == "PM"){
					is24 = false;
				}
				var aTimes = aTime.left(5).split(":");
				var hh = aTimes[0];
				var mm = aTimes[1];
				if(!is24) hh += 12;
				return new Date(aDate[0], (parseFloat(aDate[1])-1), parseFloat(aDate[2]), parseFloat(hh), parseFloat(mm));
			}catch(e){
				return new Date();
			}
		}else{ // > 10
			return new Date();
		}
	}
	function toNum(){var pair = this.replace(/,/g, "").split(".");var isMinus = false;if (parseFloat(pair[0]) < 0) isMinus = true;var returnValue = 0.0;pair[0] = pair[0].replace(/[-|+]?[\D]/gi, "");if (pair[1]) {pair[1] = pair[1].replace(/\D/gi, "");returnValue = parseFloat(pair[0] + "." + pair[1]) || 0;} else {returnValue = parseFloat(pair[0]) || 0;}return (isMinus) ? -returnValue : returnValue;}
	function parseF(){return parseFloat(this);}
	function strip(){ return this.replace(/^\s+/, '').replace(/\s+$/, ''); }
	function stripTags(){ return this.replace(/<\w+(\s+("[^"]*"|'[^']*'|[^>])+)?>|<\/\w+>/gi, ''); } //"
	function times(count){return count < 1 ? '' : new Array(count + 1).join(this);}
	function inspect(useDoubleQuotes) {
		var escapedString = this.replace(
			/[\x00-\x1f\\]/g,
			function(character) {
				try{
					if(character in String.specialChar) return String.specialChar[character];
				}catch(e){}
			return '\\u00' + character.charCodeAt()}
		);
		if (useDoubleQuotes) return '"' + escapedString.replace(/"/g, '\\"') + '"';
		return "" + escapedString.replace(/'/g, '\\\'') + "";
	}
	function toJSON(TF) {return this.inspect(TF||false);}
	function blank() {return /^\s*$/.test(this);}
	function isJSON(){var str = this;if (str.isBlank()) return false;str = this.replace(/\\./g, '@').replace(/"[^"\\\n\r]*"/g, '');return (/^[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]*$/).test(str);} //"
	function unfilterJSON(filter){return this.replace(filter || AXUtil.JSONFilter, '$1');}
	function evalJSON(sanitize){var json = this.unfilterJSON();try {if (!sanitize || json.isJSON()) return eval("("+json+")");else return {result:"err", msg:"JSON syntax error. fail to convert Object\n"+this};} catch (e) {return {result:"err", msg:"JSON syntax error.\n"+this, body:this};}}
	function queryToObject(separator) {var match = this.trim().match(/([^?#]*)(#.*)?$/);if (!match) return { };var rs = match[1].split(separator || '&');var returnObj = {};var i=0;while(i < rs.length){var pair = rs[i].split("=");var k = pair[0], v = pair[1];if(returnObj[k] != undefined){if (!Object.isArray(returnObj[k])) returnObj[k] = [returnObj[k]];returnObj[k].push(v);}else{returnObj[k] = v;}i++;}return returnObj;}
	function crlf(replaceTarget, replacer){return this.replace((replaceTarget || /\n/g), (replacer || "<br/>"));}
	function ecrlf(replaceTarget, replacer){return this.replace((replaceTarget || /%0A/g), (replacer || "<br/>"));}
	function formatDigit(length, padder) {var string = this;return (padder||'0').times(length - string.length) + string;}
	function getFileName(){var sToMatch = this;var reAt = /[\/\\]?([^\/\\]?\.?[^\/\\]+)$/;var reArr = sToMatch.match(reAt);return RegExp.$1;}
	function toColor(sharp){ var colorValue = ""; if(this.left(3) == "rgb"){ var val = this; var reAt = /rgb\((.+)\)/; val.match(reAt); var vals = RegExp.$1.split(", "); for(var a=0;a<vals.length;a++){vals[a] = vals[a].number().setDigit(2, '0', 16); } colorValue = vals.join("");}else{colorValue = this.replace("#", "");} var preFix = (sharp) ? "#":"";return preFix + colorValue;}
	function toMoney() {return this.number().money();}
	function toByte() {return this.number().byte();}
	function lcase() {return this.toLowerCase();}
	function ucase() {return this.toUpperCase();}
	return {
		left: left,
		right: right,
		dec: dec,
		enc: enc,
		object: object,
		array: array,
		date: toDate,
		number: toNum,
		num: parseF,
		money: toMoney,
		byte: toByte,
		trim: strip,
		delHtml: stripTags,
		times: times,
		inspect: inspect,
		toJSON: toJSON,
		isBlank: blank,
		isJSON: isJSON,
		unfilterJSON: unfilterJSON,
		evalJSON: evalJSON,
		queryToObject: queryToObject,
		crlf: crlf,
		ecrlf: ecrlf,
		setDigit: formatDigit,
		getFileName: getFileName,
		toColor: toColor,
		lcase: lcase,
		ucase: ucase
	}
})());

Object.extend(Number.prototype, (function() {
	function left(strLen) {return this.toString().substr(0, strLen);}
	function right(strLen) {return this.toString().substring(this.toString().length - strLen, this.toString().length);}
	function toMoney() {var txtNumber = '' + this;if (isNaN(txtNumber) || txtNumber == "") {return "";} else {var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');var arrNumber = txtNumber.split('.');arrNumber[0] += '.';do {arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');} while (rxSplit.test(arrNumber[0]));if (arrNumber.length > 1) {return arrNumber.join('');} else {return arrNumber[0].split('.')[0];}}}
	function toByte(){var n_unit = "KB";var myByte = this / 1024;if(myByte/1024 > 1){n_unit = "MB";myByte = myByte/1024;}if(myByte/1024 > 1){n_unit = "GB";myByte = myByte/1024;}return myByte.round(1) + n_unit;}
	function toNum() {return this;}
	function formatDigit(length, padder, radix) {var string = this.toString(radix || 10);return (padder||'0').times(length - string.length) + string;}
	function range(start) {var ra = [];for (var a = (start || 0); a < this + 1; a++)ra.push(a);return ra;}
	function toJSON() {return this;}
	function abs() {return Math.abs(this);}
	function round(digit) {return Math.round(this * Math.pow(10, (digit || 0))) / Math.pow(10, (digit || 0));}
	function ceil() {return Math.ceil(this);}
	function floor() {return Math.floor(this);}
	function date() {return new Date(this);}
	function div(divisor) {if (divisor != 0){return this / divisor;}else{return 0;}}
	function none() {return this;}
	function times(count){return count < 1 ? '' : new Array(count + 1).join(this.toString());}
	return {
		left: left,
		right: right,
		abs: abs,
		round: round,
		ceil: ceil,
		floor: floor,
		money: toMoney,
		byte: toByte,
		num: toNum,
		number: toNum,
		setDigit: formatDigit,
		date: date,
		div: div,
		dec: none,
		enc: none,
		rangeFrom: range,
		toJSON: toJSON,
		times: times
	}
})());

Object.extend(Date.prototype, (function(){
	function dateAdd(daynum, interval){
		interval = interval || "d";
		var interval = interval.toLowerCase();
		var DyMilli = ((1000 * 60) * 60) * 24;
		var aDate = new Date(this.getUTCFullYear(), this.getMonth(), this.getDate());
		if(interval == "d"){
			aDate.setTime(this.getTime() + (daynum*DyMilli));
		}else if(interval == "m"){
			var yy = aDate.getFullYear();
			var mm = aDate.getMonth();
			var dd = aDate.getDate();
			if(mm == 0 && dd == 1) yy += 1;
			yy = yy + parseInt(daynum / 12);
			mm += daynum % 12;
			var mxdd = AXUtil.dayLen(yy, mm);
			if(mxdd < dd) dd = mxdd;
			aDate = new Date(yy, mm, dd);
		}else if(interval == "y"){
			aDate.setTime(this.getTime() + ((daynum*365)*DyMilli));
		}else{

		}
		return aDate;
	}
	function dayDiff(edDate, tp){
		var DyMilli = ((1000 * 60) * 60) * 24;
		//trace(this.print() +"/"+ edDate.print() + "//" + ((edDate.date() - this) / DyMilli) + "//" + ((edDate.date() - this) / DyMilli).floor());
		var y1 = this.getFullYear();
		var m1 = this.getMonth();
		var d1 = this.getDate();
		var hh1 = this.getHours();
		var mm1 = this.getMinutes();
		var dd1 = new Date(y1, m1, d1, hh1, mm1);

		var day2 = edDate.date();
		var y2 = day2.getFullYear();
		var m2 = day2.getMonth();
		var d2 = day2.getDate();
		var hh2 = day2.getHours();
		var mm2 = day2.getMinutes();
		var dd2 = new Date(y2, m2, d2, hh2, mm2);

		if (tp != undefined){
			if (tp == "D"){
				DyMilli = ((1000 * 60) * 60) * 24;
			}else if (tp == "H"){
				DyMilli = ((1000 * 60) * 60);
			}else if (tp == "mm"){
				DyMilli = (1000 * 60);
			}else{
				DyMilli = ((1000 * 60) * 60) * 24;
			}
		}

		return ((dd2 - dd1) / DyMilli).floor();

	}
	function toString(format){
		if(format == undefined){
			var sSeper = "-";
			if(this.getMonth() == 0 && this.getDate() == 1) return (this.getUTCFullYear()+1) +sSeper+(this.getMonth()+1).setDigit(2)+sSeper+this.getDate().setDigit(2);
			else return this.getUTCFullYear() +sSeper+(this.getMonth()+1).setDigit(2)+sSeper+this.getDate().setDigit(2);
		}else{
			var fStr = format;
			var nY, nM, nD, nH, nMM, nS;
			if(this.getMonth() == 0 && this.getDate() == 1) nY = this.getUTCFullYear()+1; else nY = this.getUTCFullYear();
			nM = (this.getMonth()+1).setDigit(2); nD = this.getDate().setDigit(2); nH = this.getHours().setDigit(2); nMM = this.getMinutes().setDigit(2); nS = this.getSeconds().setDigit(2);
			var yre = /[^y]*(y{0,4})[^y]*/gi;yre.test(fStr);var regY = RegExp.$1;
			var mre = /[^m]*(m{2})[^m]*/gi;mre.test(fStr);var regM = RegExp.$1;
			var dre = /[^d]*(d{1,2})[^d]*/gi;dre.test(fStr);var regD = RegExp.$1;
			var hre = /[^h]*(h{2})[^d]*/gi;hre.test(fStr);var regH = RegExp.$1;
			var mire = /[^mi]*(mi)[^mi]*/gi;mire.test(fStr);var regMI = RegExp.$1;
			var sre = /[^s]*(s{2})[^s]*/gi;sre.test(fStr);var regS = RegExp.$1;

			if(regY){
				fStr = fStr.replace(regY, nY.right(regY.length));
			}
			if(regM){
				if(regM.length == 1) nM = (this.getMonth()+1);
				fStr = fStr.replace(regM, nM);
			}
			if(regD){
				if(regD.length == 1) nD = this.getDate();
				fStr = fStr.replace(regD, nD);
			}
			if(regH){
				fStr = fStr.replace(regH, nH);
			}
			if(regMI){
				fStr = fStr.replace(regMI, nMM);
			}
			if(regS){
				fStr = fStr.replace(regS, nS);
			}
			return fStr;
		}
	}

	function getTimeAgo(rDate){
		var rtnStr = ""
		var nMinute = Math.abs((new Date()).diff(rDate, "mm"));
		var wknames = []
		wknames.push("일", "월", "화", "수", "목", "금", "토");

		if (isNaN(nMinute)) {
			rtnStr = "알수없음";
		}else{
			if ( parseInt(nMinute/60/24) >= 1 ){
				rtnStr = rDate.date().print("yyyy년 mm월 dd일") +" "+ wknames[rDate.date().getDay()] ;
			}else{
				rtnStr = nMinute;

				if ( parseInt(nMinute/60) > 1 ){
					rtnStr = parseInt(nMinute/60) + "시간" + (nMinute%60) + "분 전";
				}else{
					rtnStr = nMinute + "분 전";
				}
			}
		}
		return rtnStr;
	}

	function date(){return this;}
	function toJSON(){return '"' + this.getUTCFullYear() + '-' +(this.getUTCMonth() + 1).setDigit(2) + '-' +this.getUTCDate().setDigit(2) + 'T' +this.getUTCHours().setDigit(2) + ':' +this.getUTCMinutes().setDigit(2) + ':' +this.getUTCSeconds().setDigit(2) + 'Z"';}
	return {
		add: dateAdd,
		diff: dayDiff,
		print: toString,
		date: date,
		toJSON: toJSON,
		getTimeAgo: getTimeAgo
	}
})());

Object.extend(Error.prototype, (function(){
	function print(){
		return (this.number&0xFFFF)+" : "+this;
	}
	return {
		print: print
	}
})());

Object.extend(Object.prototype, (function(){
	function toString(){
		return (this + "");
	}
	return {
		toString: toString
	}
})());


Object.extend(Array.prototype, (function(){
	function clear() {
		this.length = 0;
		return this;
	}
	function first() {
		return this[0];
	}
	function last() {
		return this[this.length - 1];
	}
	function getToSeq(seq) {
		if(seq > (this.length-1)){
			return null;
		}else{
			return this[seq];
		}
	}
	function toJSON() {
		var results = [];
		for(var i=0;i<this.length;i++) results.push(Object.toJSON(this[i]));
		return '[' + results.join(', ') + ']';
	}
	function remove(callBack){
		var _self = this;
		var collect = [];
		$.each(this, function(index, O){
			if(!callBack.call({index:index, item:O})) collect.push(O);
		});
		return collect;
	}
	function search(callBack){
		var _self = this;
		var collect = [];
		$.each(this, function(index, O){
			if(callBack.call({index:index, item:O})) collect.push(O);
		});
		return collect.length;
	}
	function getObject(callBack){
		var _self = this;
		var collect = [];
		$.each(this, function(index, O){
			if(callBack.call({index:index, item:O})) collect.push(O);
		});
		return collect;
	}
	function hasObject(callBack){
		var _self = this;
		var collect = null;
		$.each(this, function(index, O){
			if(callBack.call({index:index, item:O})){
				collect = O;
				return false;
			}
		});
		return collect;
	}
	return {
		clear: clear,
		first: first,
		last: last,
		getToSeq: getToSeq,
		toJSON: toJSON,
		remove: remove,
		search: search,
		has: hasObject,
		searchObject: getObject
	}
})());

/* **************************** extend implement block ** */

function $A(iterable){if(!iterable) return [];if('toArray' in Object(iterable))return iterable.toArray();var length=iterable.length || 0, results=new Array(length);while(length--)results[length]=iterable[length];return results;}

var AXA = {
	browser: (function(){
		var ua = (""+Request.ServerVariables("HTTP_USER_AGENT")).lcase();
		var mobile = (ua.search(/mobile/g) != -1) ? true : false ;
		if(ua.search(/iphone/g) != -1){
			return {name: "iphone", version: 0, mobile:true}
		}else if(ua.search(/ipad/g) != -1){
			return {name: "ipad",version: 0, mobile:true}
		}else if(ua.search(/android/g) != -1){
			return {name: "android",version: 0, mobile:mobile}
		}else{
			var browserName = "";
			var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
			/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
			/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
			/(msie) ([\w.]+)/.exec( ua ) ||
			ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
			[];

			var matchObject = {browser: match[ 1 ] || "", version: match[ 2 ] || "0"};
			with(matchObject){
				if(browser == "msie") browserName = "ie";
				else browserName = browser;
				return {
					name: browserName,
					version: version.number(),
					mobile : mobile
				}
			}
		}
	})(),
	timekey: function(){
		var d = new Date();
		return("A" + d.getHours().setDigit(2) + d.getMinutes().setDigit(2) + d.getSeconds().setDigit(2) + d.getMilliseconds());
	},
	now: function(){
		return (new Date()).print("yyyy-mm-dd hh:mi:ss");
	},
	overwriteObject: function(tg, obj, rewrite){
		if(rewrite == undefined) rewrite = true;
		if(obj) $.each(obj, function(k, v){
			if(rewrite){ tg[k] = v;}
			else{
				if(tg[k] == undefined) tg[k] = v;
			}
		});
		return tg;
	},
	updateObject: function(tg, obj){
		if(obj) $.each(obj, function(k, v){
			if(tg[k]){
				if(tg[k] == null || tg[k] == "") tg[k] = v;
			}else{
				tg[k] = v;
			}
		});
		return tg;
	},
	setCookie: function( name, value, expiredays ){
		Response.Cookies(name) = value;
		if(expiredays) Response.Cookies(name).Expires = expiredays;
    	Response.Cookies(name).Path = "/";
	},
	getCookie: function( name ){
		return ""+Request.Cookies(name);	// 2013-11-05 오브젝트형으로 출력되서 앞에 "" 붙임 by raniel
	},
	JSONFilter: /^\/\*-secure-([\s\S]*)\*\/\s*$/,
	dayLen: function (y, m){
		if([3,5,8,10].has(function(){return this.item == m;})){return 30;}else if(m == 1){return (((y % 4 == 0) && (y % 100 !=0)) || (y % 400 == 0)) ? 29:28;}else{return 31;}
	},
	each: function(obj, callback){
		//try{
			if(obj){
				var name, i = 0, length = obj.length,
				isObj = length === undefined || Object.isFunction( obj );
				if ( isObj ) {
					for ( name in obj ) {
						if ( callback.call( obj[ name ], name, obj[ name ] ) === false ) {
							break;
						}
					}
				} else {
					for ( ; i < length; ) {
						if ( callback.call( obj[ i ], i, obj[ i++ ] ) === false ) {
							break;
						}
					}
				}
			}
			/*
		}catch(e){
			e.file = "AXJ.asp line 529";
			print(e);
		}
		*/
	},

	printLn: function(obj){
		var type = (typeof obj).toLowerCase(), po;
		var po;
		if(type == "undefined" || type == "function"){
			po = type;
		}else if(type == "boolean" || type == "number" || type == "string"){
			po = obj;
		}else if(type == "object"){
			po = Object.toJSON(obj);
		}
		Response.Write(po);
	},
	printLf: function(obj){
		var type = (typeof obj).toLowerCase(), po;
		if(type == "undefined" || type == "function"){
			po = type;
		}else if(type == "boolean" || type == "number" || type == "string"){
			po = obj;
		}else if(type == "object"){
			po = Object.toJSON(obj);
		}
		Response.Write(po+"<br/>");
	},

	responseEnd: function(){
		Response.End();
	},

	isError: function(obj){
		if (obj.error == undefined){
			return false;
		}else{
			return true;
		}
	},
	serverVar: function(keyName){
		return Request.ServerVariables(keyName) + "";
	}
	
};

var $ = AXA;
var trace = $.printLn;
var echo = $.printLn;
var print = $.printLn;
var excelPrint = $.printLn;
var println = $.printLf;
var die = function(){if(arguments.length > 0){$.printLf(arguments[0]);}$.responseEnd();};	// php의 die()처럼 문자열을 출력하고 종료가능 by json@axisj.com, 2013-10-24
var end = die;
var 끝 = die;
var isError = $.isError;

/* ** AXJ ********************************************** */
var AXJ = Class.create({
	version: "AXJ - v1.0",
	author: "tom@axisj.com",
	logs: [
		"2013-03-04 오후 2:43:39 - 시작"
	],
	initialize: function() {
		this.config = {
			debugMode:false
		};
		this.logger = [];
	},
	init: function() {
		trace(this.config);
	},
	info: function(dispType) {

	},
	setConfig: function(configs) {
		var _self = this;
		if(configs) $.each(configs, function(k, v){_self.config[k] = v;});
		this.init();
	},

	pushLog: function( _strError ){
		this.logger.push( _strError );
		if( this.config.debug ) trace( _strError + "<br />");
	}

});
/* ********************************************** AXJ ** */

/* ** AXRequest ********************************************** */
var AXRequest = Class.create(AXJ, {
	version: "AXJ - v1.0",
	author: "root@axisj.com",
	logs: [
		"2013-03-14 오후 4:41:34 - 시작"
	],
	initialize: function($super) {
		$super();
		this.config = {
			debugMode:false
		};
	},
	init: function() {
		//trace(this.config);
	},

	makeRequestsObj: function(requestData, objRequest){
		for (; !requestData.atEnd(); requestData.moveNext() ){
			var o = requestData.item();
			objRequest[o] = Request(o)+"";
		}
		return (objRequest);
	},
	
	getParam: function(reqObj){
		requestValue = "";
		if (reqObj.Count > 1) {	
			for (var i=0;i < reqObj.Count; i++){
				requestValue = requestValue + (reqObj(i+1))+"".trim();
			}
		}else{
			requestValue = (""+reqObj).trim();
		}		
		
		return (requestValue);
	},
	
	receivingCombined: function(method, requestName, variableType){
		var requestValue;
		var objRequest = {};

		if (method == undefined) method = "post";

		method = method.toLowerCase();
		variableType = (variableType != undefined ? variableType.toLowerCase() : "" ) ;

		if (method == "get"){
			requestValue = this.getParam(Request.Querystring(requestName));
		}else if (method == "post"){
			requestValue = this.getParam(Request.Form(requestName));
		}else if (method == "cookies"){
			requestValue = this.getParam(Request.Form(requestName));
		}else{
			requestValue = this.getParam(Request.Form(requestName));
		}

		if (variableType == "int"){
			if (requestValue == "" || requestValue == "undefined") requestValue = 0;
			requestValue == parseInt(requestValue);
		}else if (variableType == "char"){
			//requestValue == requestValue.toString().stripHTML();
			requestValue = requestValue.toString();
		}else if (variableType == "text"){

		}else{
			//requestValue = requestValue.toString().stripHTML();
			requestValue = requestValue.toString();
		}

		return (requestValue);
	},
	getRequestValue: function(o){
		if(Request(o).count > 1){
			var reqArray = [];
			for (var ri=1;ri<Request(o).count+1;ri++){
				reqArray.push(Request(o)(ri) + "");
			}
			return reqArray;
		}else{
			return Request(o) + "";
		}
	},
	request: function(method, requestName, variableType){
		var requestValue;
		var objRequest = {};

		if (method == undefined) method = "post";

		method = method.toLowerCase();
		variableType = (variableType != undefined ? variableType.toLowerCase() : "" ) ;

		//println(method+"_"+requestName+"_"+variableType +"_"+ typeof( Request.Form(requestName) ) );

		if (method == "get"){
			requestValue = (Request.Querystring(requestName))+"".trim();
		}else if (method == "post"){
			requestValue = (""+Request.Form(requestName)).trim();
		}else if (method == "cookies"){
			requestValue = (Request.Cookies(requestName))+"".trim();
		}else{
			requestValue = (Request(requestName))+"".trim();
		}

		if (variableType == "int"){
			if (requestValue == "" || requestValue == "undefined") requestValue = 0;
			requestValue == parseInt(requestValue);
		}else if (variableType == "char"){
			//requestValue == requestValue.toString().stripHTML();
			requestValue = requestValue.toString();
		}else if (variableType == "text"){
			
		}else{
			//requestValue = requestValue.toString().stripHTML();
			requestValue = requestValue.toString();
		}

		return (requestValue);

	},
	requestsObj: function(method, requestName, variableType){

		if (requestName != undefined) return this.request(method, requestName, variableType);

		var objRequest = {};
		var requestData, requestValue;

		if (method == undefined) method = "all";
		if (method == "get" || method == "post"){
			if (method == "get") requestData = new Enumerator(Request.Querystring);
			else if (method == "post") requestData = new Enumerator(Request.Form);

			//objRequest = this.makeRequestsObj(requestData, objRequest);

			for (; !requestData.atEnd(); requestData.moveNext() ){
				var o = requestData.item();
				objRequest[o] = this.getRequestValue(o);
			}
		}else{
			requestData = new Enumerator(Request.Querystring);
			for (; !requestData.atEnd(); requestData.moveNext() ){
				var o = requestData.item();
				objRequest[o] = this.getRequestValue(o);
			}

			requestData = new Enumerator(Request.Form);
			for (; !requestData.atEnd(); requestData.moveNext() ){
				var o = requestData.item();
				objRequest[o] = this.getRequestValue(o);
			}
		}

		return (objRequest);
	},
	requestsArr: function(method, returnType){
		var tmpObj = {}, o;
		var arrRequest = [];
		var requestData, requestValue;

		if (method == undefined) method = "all";
		if (method == "get" || method == "post"){
			if (method == "get") requestData = new Enumerator(Request.Querystring);
			else if (method == "post") requestData = new Enumerator(Request.Form);

			for (; !requestData.atEnd(); requestData.moveNext() ){
				o = requestData.item();
				tmpObj = {};
				tmpObj.nm = o;
				tmpObj.value = Request(o)+"";
				tmpObj.method = method;
				arrRequest.push(tmpObj);
			}

		}else{
			requestData = new Enumerator(Request.Querystring);
			for (; !requestData.atEnd(); requestData.moveNext() ){
				o = requestData.item();
				tmpObj = {};
				tmpObj.nm = o;
				tmpObj.value = Request(o)+"";
				tmpObj.method = "get";
				arrRequest.push(tmpObj);
				/*
				var o = requestData.item();
				objRequest[o] = Request(o)+"";
				*/
			}

			requestData = new Enumerator(Request.Form);
			for (; !requestData.atEnd(); requestData.moveNext() ){
				o = requestData.item();
				tmpObj = {};
				tmpObj.nm = o;
				tmpObj.value = Request(o)+"";
				tmpObj.method = "post";
				arrRequest.push(tmpObj);
				/*
				var o = requestData.item();
				objRequest[o] = Request(o)+"";
				*/
			}
		}

		return (arrRequest);
	},

	serverVariables: function(key){
		if (key == 0 || key == undefined){
			key = "HTTP_HOST";
		}else if (key == 1){
			key = "PATH_INFO";
		}else if (key == 2){
			key = "HTTP_REFERER";
		}else if (key == 3){
			key = "REMOTE_ADDR";
		}		
		return Request.ServerVariables(key);
	},
	serverValue: function(){

		var obj = {
			HTTP_REFERER : Request.Servervariables("HTTP_REFERER")+"",
				REFERER : Request.Servervariables("HTTP_REFERER")+"",
			LOCAL_ADDR : Request.Servervariables("LOCAL_ADDR")+"",
			PATH_INFO : Request.Servervariables("PATH_INFO")+"",
				PATH : Request.Servervariables("PATH_INFO")+"",
			PATH_TRANSLATED : Request.Servervariables("PATH_TRANSLATED")+"",
			QUERY_STRING : Request.Servervariables("QUERY_STRING")+"",
			REMOTE_ADDR : Request.Servervariables("REMOTE_ADDR")+"",
			REMOTE_HOST : Request.Servervariables("REMOTE_HOST")+"",
				IP : Request.Servervariables("REMOTE_HOST")+"",
			//REMOTE_USER : Request.Servervariables("REMOTE_USER")+"",
			REQUEST_METHOD : Request.Servervariables("REQUEST_METHOD")+"",
			SERVER_PROTOCOL : (Request.Servervariables("SERVER_PORT_SECURE")+"" == "0") ? "http" : "https",
			SERVER_PORT_SECURE : Request.Servervariables("SERVER_PORT_SECURE")+"",
			SERVER_NAME : Request.Servervariables("SERVER_NAME")+"",
			SERVER_PORT : Request.Servervariables("SERVER_PORT")+""
		}
		
		obj.FILE_PATH = obj.PATH_INFO.left(obj.PATH_INFO.lastIndexOf("/")+1);
		obj.FILE_NAME = obj.PATH_INFO.right(obj.PATH_INFO.length - obj.PATH_INFO.lastIndexOf("/")-1);
		obj.FILE_ID = obj.FILE_NAME.left(obj.FILE_NAME.lastIndexOf("."));
		
		obj.hostName = (obj.SERVER_PORT_SECURE == "0") ? "http" : "https";
		obj.hostName += "://" + obj.SERVER_NAME.replace(/www\./g, "");
		if(obj.SERVER_PORT != "80"){
			obj.hostName += ":" + obj.SERVER_PORT;
		}
		return obj;
		
	}

/*
ALL_HTTP
ALL_RAW
APPL_MD_PATH
APPL_PHYSICAL_PATH
AUTH_PASSWORD
AUTH_TYPE
AUTH_USER
CERT_COOKIE
CERT_FLAGS
CERT_ISSUER
CERT_KEYSIZE
CERT_SECRETKEYSIZE
CERT_SERIALNUMBER
CERT_SERVER_ISSUER
CERT_SERVER_SUBJECT
CERT_SUBJECT
CONTENT_LENGTH
CONTENT_TYPE
GATEWAY_INTERFACE
HTTP_<HeaderName>
HTTP_ACCEPT
HTTP_ACCEPT_LANGUAGE
HTTP_COOKIE
HTTP_REFERER
HTTP_USER_AGENT
HTTPS
HTTPS_KEYSIZE
HTTPS_SECRETKEYSIZE
HTTPS_SERVER_ISSUER
HTTPS_SERVER_SUBJECT
INSTANCE_ID
INSTANCE_META_PATH
LOCAL_ADDR
LOGON_USER
PATH_INFO
PATH_TRANSLATED
QUERY_STRING
REMOTE_ADDR
REMOTE_HOST
REMOTE_USER
REQUEST_METHOD
SCRIPT_NAME
SERVER_NAME
SERVER_PORT
SERVER_PORT_SECURE
SERVER_PROTOCOL
SERVER_SOFTWARE
URL
*/

});
/* ********************************************** AXRequest ** */

var myAXReq = new AXRequest();
	myAXReq.setConfig({
		debug: true
	});

var AXReq = function(method, requestName, variableType){
	return myAXReq.requestsObj(method, requestName, variableType);
}
var AXReqToArray = myAXReq.requestsArr;

var AXReqRC = function(method, requestName, variableType){
	return myAXReq.receivingCombined(method, requestName, variableType);
}

var AXReqSV = function(key){
	return myAXReq.serverVariables(key);
}

var AXServerValue = function(){
	return myAXReq.serverValue();
}


/* ** AXResponse********************************************** */
var AXResponse = Class.create(AXJ, {
	version: "AXJ - v1.0",
	author: "root@axisj.com",
	logs: [
		"2013-03-14 오후 4:41:34 - 시작"
	],
	initialize: function($super) {
		$super();
		this.config = {
			debugMode:false
		};
	},
	init: function() {
		//trace(this.config);
	},

	response: function(){
		try{

		}catch( e ){
			this.pushLog( e.description );
			return {
				error: true,
				message: "response failed",
				error_description: e.description
			}
		}
	},

	res: function(obj){

	}

});
/* ********************************************** AXResponse ** */

var AXRes = new AXResponse();
	AXRes.setConfig({
		debug: true
	});


var AXHelper = Class.create(AXJ, {
	version: "AXHelper - v1.0",
	author: "json@axisj.com(류재성)",
	logs: [
		"2013-10-29 : 시작(validateBlank, validate 함수 추가)"
	],
	initialize: function($super) {
		$super();
		this.config = {
			debugMode:false
		};
	},
	init: function() {
		//trace(this.config);
	},
	validateBlank: function(obj){ // 배열 변수에 빈 값이 하나라도 있으면 false
		var ret = true;
		$.each(obj, function(index, O){
			if(O == ""){
				ret = false;
				return false;
			}
		});
		return ret;
	},
	validate: function(obj){ // 배열 값과 타입을 비교하여 에러 시 개체반환
		var ret = true;
		var errorObject = []; 

		$.each(obj, function(index, O){
			var boolErrObj = true;
			if(this.type == "notnull"){		
				if(this.value == undefined || this.value.trim() == ""){
					ret = false; boolErrObj = false;
				}
			}else if(this.type == "email"){
				var pattern = /[A-z0-9_\-]{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/;
				if(!pattern.test(val)){
					ret = false; boolErrObj = false;
				}
			}else if(this.type == "telnum"){
				var pattern = /^[0-9]{2,3}-?[0-9]{3,4}-?[0-9]{4}$/;
            	if (!pattern.test(this.value)) {
            		ret = false; boolErrObj = false;
            	}
			}else if(this.type == "number"){
				if((isNaN(this.value) || /[^\d]/.test(this.value))){
					ret = false; boolErrObj = false;
				}
			}else{
			}
			if( !boolErrObj ){
				errorObject.push({name:this.name, value:this.value, type:this.type});
			}
		});		
		if(ret){
			return {result : "ok"};
		}else{
			return {result: "err", msg: "Validation Error", error: true, errorObject: errorObject};
		}		
	},
	doScript: function(scr){
		die("<script type='text/javascript'>" + scr + "</script>");
	},
	getScript: function(scr){
		return "<script type='text/javascript'>" + scr + "</script>";
	}

});

var AXHelp = function(){
	return new AXHelper();
}



%>