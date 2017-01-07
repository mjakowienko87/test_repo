package pl.mynetwork.utils 
{
	import flash.external.ExternalInterface;
	
	public class Utils {
	
		// warunek uzywany przy kompresji danych (jezeli skompresowane dane uzywane
		// beda w standardzie AICC to nie moga wystapic znaki ']','['
		private static var toAicc:Boolean = true;
		
		/**
		 * Serializacja obiektow
		 * 
		 * @param obj obiekt do serializacji
		 * @return string (obiekt po serializacji)
		 */
		public static function serialize(obj:Object):String {
			var serializedObj_:Object = new Object();
			var wrapper:Object = new Object();
			var type:String = typeof(obj);
			var isSimpleType:Boolean = false;
			
			if (type == 'string' || type == 'number' || type == 'boolean' || 
				obj is Date || obj is Number || obj is Array || 
				obj is String || obj is Boolean) {
					isSimpleType = true;
					wrapper.value = obj;
			}  else {
				isSimpleType = false;
				wrapper = obj;
			}
			
			serializedObj_.str = "";
			Utils.makeSerialize(wrapper, serializedObj_, isSimpleType);
			serializedObj_.str = serializedObj_.str;
			return serializedObj_.str;
		}
		
		/**
		 * Deserializacja obiektow
		 * 
		 * @param serializedObj string do deserializacji
		 * @return obiekt po deserializacji
		 */
		public static function deserialize(serializedObj:String):Object {
			var deserializedObj:Object = new Object();
			var objectType:String = serializedObj.charAt(0);
			serializedObj = serializedObj.slice(2);
			var isSimpleType:Boolean = (objectType == "s");
			Utils.makeDeserialize(serializedObj, deserializedObj);
			if (isSimpleType && deserializedObj != null) {
				return deserializedObj.value;
			} else {
				return deserializedObj;
			}
		}
		
		/**
		 * Kompresja danych
		 * 
		 * @param str ciag znakow do kompresji
		 * @param _toAicc czy dane wykorzystane beda w komunikacji AICC
		 * @return skompresowany ciag znakow
		 */
		public static function compress(str:String):String {
			var dico:Array = new Array();
			var skipnum:Number = toAicc ? 3 : 0;
			for (var i:Number = 0; i<256; i++) {
				dico[String.fromCharCode(i)] = i;
			}
			if (toAicc) {
				dico["["] = 256;
				dico["]"] = 257;
				dico["%"] = 258;
			}
			var res:String = "";
			var txt2encode:String = str;
			var splitStr:Array = txt2encode.split("");
			var len:Number = splitStr.length;
			var nbChar:Number = 256 + skipnum;
			var buffer:String = "";
			for (i = 0; i <= len; i++) {
				var current = splitStr[i];
				if (dico[buffer + current] != undefined) {
					buffer += current;
				} else {
					res += String.fromCharCode(dico[buffer]);
					dico[buffer+current] = nbChar;
					nbChar++;
					buffer = current;
				}
			}
			return res;
		}
		
		/**
		 * Dekompresja danych
		 * 
		 * @param str skompresowany ciag znakow
		 * @return ciag po dekompresji
		 */
		public static function decompress(str:String):String {
			var dico:Array = new Array();
			var skipnum:Number = toAicc ? 3 : 0;
			for (var i = 0; i < 256; i++) {
				var c:String = String.fromCharCode(i);
				dico[i] = c;
			}
			if (toAicc) {
				dico[256] = "[";
				dico[257] = "]";
				dico[258] = "%";
			}
			var txt2encode:String = str;
			var splitStr:Array = txt2encode.split("");
			var length:Number = splitStr.length;
			var nbChar:Number = 256 + skipnum;
			var buffer:String = "";
			var chaine:String = "";
			var result:String = "";
			for (i= 0; i < length; i++) {
				var code:Number = txt2encode.charCodeAt(i);
				var current:String = dico[code];
				if (buffer == "") {
					buffer = current;
					result += current;
				} else {
					if (code <= 255 + skipnum) {
						result += current;
						chaine = buffer + current;
						dico[nbChar] = chaine;
						nbChar++;
						buffer = current;
					} else {
						chaine = dico[code];
						if (dico[code] == undefined) {
							chaine = buffer + buffer.slice(0, 1);
						}
						result += chaine;
						dico[nbChar] = buffer + chaine.slice(0, 1);
						nbChar++;
						buffer = chaine;
					}
				}
			}
			return result;
		}
		
		/**
		 * Funkcja pomocnicza do serializacji
		 * 
		 * @param obiekt do serializacji
		 * @param _serializedObj obiekt,do ktorego wpisywany jest string powstaly po serializacji
		 * @param _simpleType parametr wskazujacy czy obiekt jest typu prostego (Date, Number, Array, String, Boolean)
		 */
		private static function makeSerialize(obj:Object, _serializedObj:Object, _simpleType:Boolean):void {
			var j = null;
			if (_serializedObj.str.length == 0) {
				_serializedObj.str += _simpleType ? "s:" : "c:";
			}
			_serializedObj.str += "{";
			
			for (var i in obj) {
				j = i;
				if (_serializedObj.str.charAt(_serializedObj.str.length - 1) != '{') {
					_serializedObj.str += ",";
				}
				// sprawdzanie typow
				if (typeof(obj[i]) == "string") {
					j = i;
					obj[i] = obj[i].split('"').join('\\"');
					_serializedObj.str += i + ':s:' + '"' + obj[i]+ '"';   
				} else if (typeof(obj[i]) == "number") {
					j = i;
					_serializedObj.str += i + ':n:' + '"' + obj[i] + '"';   
				} else if (typeof(obj[i]) == "boolean") {
					j = i;
					_serializedObj.str += i + ':b:' + '"' + obj[i] + '"';
				} else if (typeof(obj[i]) == "array") {
					j = i;
					_serializedObj.str += i + ':A:' + '"' +obj[i].toString + '"';   
				} else if (obj[i] is Object) {
					j = i;
					if (obj[i] is Date) {
						var day = obj[i].getDate();
						var month = obj[i].getMonth();
						var year = obj[i].getFullYear();
						var date = year + "-" + month + "-" + day;
						_serializedObj.str += i + ':D:' + '"' + date + '"';  
					} else if (obj[i] is Array) {
						_serializedObj.str += i + ":A:";
						makeSerialize(obj[i], _serializedObj,true);
					} else if (obj[i] is Boolean) {
						_serializedObj.str += i + ':B:' + '"' + obj[i] + '"';
					} else if (obj[i] is String) {
						obj[i] = obj[i].split('"').join('\\"');
						_serializedObj.str += i + ':S:' + '"' + obj[i] + '"';
					} else if (obj[i] is Number) {
						_serializedObj.str += i + ':N:' + '"' + obj[i] + '"';
					} else {
						// jezeli obiekt to serializuje go jeszcze raz
						_serializedObj.str += i + ":O:";
						makeSerialize(obj[i], _serializedObj, _simpleType);
					}
				}
			}
			_serializedObj.str += "}";
		}
		
		/**
		 * Funkcja pomocnicza do deserializacji
		 * 
		 * @param str string do deserializacji
		 * @param obj obiekt po deserializacji
		 */
		private static function makeDeserialize(str:String, obj:Object):void {
			var arr:Array = new Array();
			var tmp:String = unescape(str);
			var separatorNum:Number = 0;
			
			if (str.substring(1,str.length-1).length == 0) {
				obj.value = null;
			} else {
				var comaPos:Number = 0;
				separatorNum = tmp.indexOf(":", separatorNum);
				while (comaPos != -1) {
					var type:String = tmp.charAt(separatorNum + 1);
					if (type == "O" || type == "A") {
						// Element jest obiektem lub tablica
						var endObj:Number;
						var opens:Number = 0;
						var closes:Number = 0;
						var propName = tmp.substring(comaPos + 1, separatorNum);
						separatorNum = tmp.indexOf(":", separatorNum + 1);
						var startObj:Number = tmp.indexOf('{', separatorNum);
						var subStr:String = tmp.substring(startObj, tmp.length);
						var insideString:Boolean = false;
						for (var i = 0; i < subStr.length; i++) {
							switch (subStr.charAt(i)) {
								case '"': 
									if (subStr.charAt(i-1) != '\\') {
										insideString = insideString ? false : true; 
									}
									break;
								case '{': insideString ? null : opens++; break;
								case '}': insideString ? null : closes++; break;
								default: break;
							}
							if (opens == closes) {
								endObj = i;
								break;
							}
						}
						var objString:String = subStr.substring(0, endObj + 1);
						if (type == "A") {
							// element jest tablica
							var tempObj:Object = new Object();
							makeDeserialize(objString, tempObj);
							obj[propName] = new Array();
							for (i in tempObj) {
								obj[propName][i] = (tempObj[i]);
							}
						} else {
							// element jest obiektem
							obj[propName] = new Object();
							makeDeserialize(objString, obj[propName]);
						}
						comaPos = tmp.indexOf(",", startObj+endObj);
						if (comaPos >= 0) {
							separatorNum = tmp.indexOf(":", comaPos);
						}
					} else {
						var objType:String = tmp.charAt(separatorNum + 1);
						propName = tmp.substring(comaPos + 1, separatorNum);
						separatorNum = tmp.indexOf(":", separatorNum + 1);
						var startString:Number = tmp.indexOf('"',separatorNum) + 1;
						var endString:Number;
						for (i = startString; i < tmp.length; i++) {
							if (tmp.charAt(i) == '"' && tmp.charAt(i-1) != '\\') {
								endString = i;
								break;
							}
						}
						var propValue:String = tmp.substring(startString, endString);
						var valLength:Number = 0;
						switch (objType) {
							case "D" :
								// element typu Date
								var dateArr:Array = propValue.split("-");
								var dateObj:Date = new Date(dateArr[0], dateArr[1], dateArr[2]);
								obj[propName] = dateObj;
								break;
							case "S" :
								// element typu String
								propValue = propValue.split('\\"').join('"');
								valLength = propValue.length;
								obj[propName] = new String(propValue);
								break;
							case "s" :
								// element typu String
								propValue = propValue.split('\\"').join('"');
								valLength = propValue.length;
								obj[propName] = propValue;
								break;
							case "N" :
								// element typu Number
								obj[propName] = new Number(propValue);
								break;
							case "n" :
								// element typu Number
								obj[propName] = (new Number(propValue)).valueOf();
								break;
							case "B" :
								// element typu Booean
								obj[propName] = new Boolean(propValue == 'true');
								break;
							case "b" :
								// element typu Booean
								obj[propName] = (propValue == 'true');
								break;
							default: break;
						}
						if (endString < tmp.length) {
							comaPos = tmp.indexOf(",", endString + 1);
							if (comaPos >=0) {
								separatorNum = tmp.indexOf(":", comaPos);
							}
						} else {
							break;
						}
					}
				}
			}
		}
	}
}