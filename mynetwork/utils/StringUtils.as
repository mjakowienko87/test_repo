package pl.mynetwork.utils 
{
	/**
	 * ...
	 * @author mkusiak
	 */
	public class StringUtils 
	{
		
		public function StringUtils() 
		{
				
		}
			
		public static var CR:String = String.fromCharCode(13);
		public static var LF:String = String.fromCharCode(10);
		public static var CRLF:String = CR + LF;
		
		/**
		 * Normalizuje znaki końca linii, wszystkie zamienia na CRLF
		 *
		 * @param str_ tekst do normalizacji
		 * @return znormalizowany tekst
		 */
		public static function normalizeNewline(str_:String):String {
			if (str_ == null || str_.length < 1) {
				return "";
			}
			
			var tmp:String = "";
			var output:String = "";
			var begin:Number;
			var end:Number;
			
			// CR -> CRLF
			begin = 0;
			while (true) {
				end = str_.indexOf(CR, begin);
				
				// jeśli na końcu tekstu to dopisz LF i zakończ
				if (end == str_.length - 1) {
					tmp += str_.substring(begin, end + 1) + LF;
					break;
				}
				// jeśli w środku tekstu to dopisz warunkowo LF i kontynuuj
				else if (end >= 0) {
					if (str_.substr(end + 1, 1) == LF) {
						tmp += str_.substring(begin, end + 2);
						begin = end + 2;
					} else {
						tmp += str_.substring(begin, end + 1) + LF;
						begin = end + 1;
					}
				}
				// jeśli nie ma to zakończ
				else {
					tmp += str_.substring(begin);
					break;
				}
			}
			
			// LF -> CRLF
			begin = 0;
			while (true) {
				end = tmp.indexOf(LF, begin);
				
				// jeśli na początku tekstu to dopisz CR i kontynuuj
				if (end == 0) {
					output += CRLF;
					begin = end + 1;
				}
				// jeśli w środku tekstu to dopisz warunkowo CR i kontynuuj
				else if (end > 0) {
					if (tmp.substr(end - 1, 1) == CR) {
						output += tmp.substring(begin, end + 1);
					} else {
						output += tmp.substring(begin, end) + CRLF;
					}
					begin = end + 1;
				}
				// jeśli nie ma to zakończ
				else {
					output += tmp.substring(begin);
					break;
				}
			}
			
			return output;
		}
		
		/**
		 * Funkcja przygotowująca test do zapisu na platformie Saba.
		 * Zamienia polskie znaki na encje HTML.
		 * 
		 * @param p_text tekst do zakodowania
		 * 
		 * @return zakodowany tekst
		 */
		public static function encodeForSaba(p_text:String):String {
			var signs:Array = [['&', '&#38;'], ['ę', '&#281;'], ['Ę', '&#280;'], ['ó', '&#243;'], ['Ó', '&#211;'], ['ł', '&#322;'], 
							   ['Ł', '&#321;'], ['ś', '&#347;'], ['Ś', '&#346;'], ['ą', '&#261;'], ['Ą', '&#260;'], 
							   ['ż', '&#380;'], ['Ż', '&#379;'], ['ź', '&#378;'], ['Ź', '&#377;'], ['ć', '&#263;'], 
							   ['Ć', '&#262;'], ['ń', '&#324;'], ['Ń', '&#323;']];
			for (var v_i:Number = 0; v_i < 65; v_i++) {
				if (v_i != 10 && v_i != 13 && v_i != 32 && v_i != 35 && v_i != 37 && v_i != 38 && (v_i < 48 || v_i > 59)) {
					signs.push([String.fromCharCode(v_i), '&#' + (v_i < 10 ? '0' : '') + v_i.toString() + ';']);
				}
			}
			signs.push(['\\', '&#92;']);
			for (v_i = 94; v_i < 97; v_i++) {
				signs.push([String.fromCharCode(v_i), '&#' + v_i.toString() + ';']);
			}
			for (v_i = 123; v_i < 128; v_i++) {
				signs.push([String.fromCharCode(v_i), '&#' + v_i.toString() + ';']);
			}
							   
			for (var i = 0; i<signs.length; i++) {
				p_text = replace(p_text, signs[i][0], signs[i][1]);
			}
			p_text = normalizeNewline(p_text);
			return escape(p_text);
		}
		
		/**
		 * Koduje znaki specjalne
		 *
		 * @param str_ tekst
		 * @return tekst z zakodowanymi znakami specjalnymi
		 */
		public static function replaceSpecialChars(str_:String):String {
			if (str_ == null || str_.length < 1) {
				return "";
			}
			
			var output:String = "";
			var begin:Number = 0;
			var end:Number;
			while (true) {
				end = indexOfAny(str_, CRLF, begin);
				if (end >= 0) {
					output += str_.substring(begin, end);
					if (str_.charAt(end) == CR) {
					  output += "\\n";
					}
					begin = end + 1;
				} else {
					output += str_.substring(begin, str_.length);
					break;
				}
			}
			return output;
		}
		
		/**
		 * Pierwsze wystąpienie dowolnego z podanych znaków
		 *
		 * @param str_ string w którym szukać znaków
		 * @param chars_ lista znaków
		 * @param begin_ indeks od którego zacząć
		 * @return indeks na którym występuje znak, -1 jeśli żaden nie występuje
		 */
		public static function indexOfAny(str_:String, chars_:String, begin_:Number = 0):Number {
			
			if (str_ == null || str_.length < 1
				|| chars_ == null || chars_.length < 1
				|| begin_ < 0 || begin_ >= str_.length) {
				return -1;
			}
			
			for (var i:Number = begin_; i < str_.length; ++i) {
				for (var j:Number = 0; j < chars_.length; ++j) {
					if (str_.charAt(i) == chars_.charAt(j)) {
						return i;
					}
				}
			}
			return -1;
		}
		
		/**
		 * Podmienia substringi
		 *
		 * @param str_ string
		 * @param from_ co podmienić
		 * @param to_ na co podmienić
		 * @return string z podmienionym from_ na to_
		 */
		public static function replace(str_:String, from_:String, to_:String):String {
			if (str_ == null || str_.length < 1) {
				return "";
			}
			if (from_ == null || from_.length < 1) {
				return str_;
			}
			
			if (to_ == null) {
				to_ = "";
			}
			return str_.split(from_).join(to_);
		}
		
		/**
		 * URLEncoding tekstu, zgodny z przeglądarką a nie z flashem
		 *
		 * @param str_ tekst
		 * @return enkodowany tekst
		 */
		public static function encode(str_:String):String {
			if (str_ == null || str_.length < 1) {
				return "";
			}
			
			var output:String = "";
			for (var i:Number = 0; i < str_.length; ++i) {
				var tmp:String = str_.charAt(i);
				switch (tmp) {
				case CR:  output += "%0D"; break;
				case LF:  output += "%0A"; break;
				
				case "{": output += "%7B"; break;
				case "}": output += "%7D"; break;
				case "!": output += "%21"; break;
				case "\"": output += "%22"; break;
				case "#": output += "%23"; break;
				case "$": output += "%24"; break;
				case "%": output += "%25"; break;
				case "&": output += "%26"; break;
				case "'": output += "%27"; break;
				case "(": output += "%28"; break;
				case ")": output += "%29"; break;
				case "*": output += "%30"; break;
				case "+": output += "%2B"; break;
				case ",": output += "%2C"; break;
				case "-": output += "%2D"; break;
				case ".": output += "%2E"; break;
				case "/": output += "%2F"; break;

				case ":": output += "%3A"; break;
				case ";": output += "%3B"; break;
				case "<": output += "%3C"; break;
				case "=": output += "%3D"; break;
				case ">": output += "%3E"; break;
				case "?": output += "%3F"; break;
				case "@": output += "%40"; break;

				case "[": output += "%5B"; break;
				case "\\": output += "%5C"; break;
				case "]": output += "%5D"; break;
				case "^": output += "%5E"; break;

				case " ": output += "+"; break;
				default:  output += tmp; break;
				}
			}
			return output;
		}
		/**
		 * URLDecoding tekstu, zgodny z przeglądarką a nie z flashem
		 *
		 * @param str_ tekst
		 * @return zdekodowany tekst
		 */
		public static function decode(str_:String):String {
			if (str_ == null || str_.length < 1) {
				return "";
			}
			
			//var tmp:LoadVars = new LoadVars();
			//tmp.decode("xxx=" + str_);
			return unescape(str_);
		}
		
		/**
		 * Zwraca dane bloku z danych aicc
		 *
		 * @param data_ dane AICC
		 * @param block_ nazwa bloku
		 * @return dane bloku, null jeśli nie znaleziono
		 */
		public static function getBlock(data_:String, block_:String):String {
			var begin:Number;
			var end:Number;
			if (data_ == null || block_ == null) {
				return null;
			}
			
			// wyszukaj początek
			begin = 0;
			while (true) {
				begin = data_.indexOf("[", begin);
				if (begin < 0) {
					return null;
				}
				end = data_.indexOf("]", begin);
				if (end < 0) {
					return null;
				}
				if (data_.substring(begin + 1, end).toLowerCase() == block_.toLowerCase()) {
					break;
				}
				begin = end + 1;
			}
			
			// zwróć dane od kolejnej linii do początku kolejnego bloku/końca danych
			begin = end + 1;
			end = data_.indexOf("[", begin);
			if (end < 0) {
				end = data_.length;
			}
			begin = data_.indexOf(CRLF, begin);
			if (begin < 0) {
				return "";
			}
			return data_.substring(begin + 2, end);
		}
		
		/**
		 * Zwraca property z bloku danych
		 *
		 * @param data_ blok danych
		 * @param property_ nazwa property
		 * @return wartość property, null jeśli nie znaleziono
		 */
		public static function getProperty(data_:String, property_:String):String {
			if (data_ == null || data_.length < 1 || property_ == null || property_.length < 1) {
				return null;
			}
			
			var prop:String = property_.toLowerCase();
			var lines:Array = normalizeNewline(data_).split(CRLF);
			for (var i:Number = 0; i < lines.length; ++i) {
				var line:String = lines[i];
				var pos:Number = line.indexOf("=");
				if (pos > 0) {
					if (StringUtils.trim(line.substring(0, pos)).toLowerCase() == prop) {
						return StringUtils.trim(line.substring(pos + 1, line.length));
					}
				}
			}
			return null;
		}
		
		/**
		 * Trim
		 *
		 * @param str_ string
		 * @return trimowany string
		 */ 
		public static function trim(str_:String):String {
			if (str_ == null || str_.length < 1) {
				return "";
			}
			
			var begin:Number = 0;
			while (begin < str_.length && (str_.charAt(begin) == ' ' || str_.charAt(begin) == CR || str_.charAt(begin) == LF)) {
				++begin;
			}
			if (begin == str_.length) {
				return "";
			}
			
			var end:Number = str_.length - 1;
			while (end > begin && (str_.charAt(end) == ' ' || str_.charAt(end) == CR || str_.charAt(end) == LF)) {
				--end;
			}
			return str_.substring(begin, end + 1);
		}
		
		/**
		 * Zwraca string w ""
		 *
		 * @param str_ string do quotowania
		 * @return quotowany string
		 */
		public static function quot(str_:String):String {
			if (str_ == null || str_.length < 1) {
				return "\"\"";
			}
			
			var quoted:String = "";
			var begin:Number = 0;
			var end:Number;
			
			while (true) {
				end = str_.indexOf("\"", begin);
				if (end >= 0) {
					quoted += str_.substring(begin, end) + "'";
					begin = end + 1;
				} else {
					quoted += str_.substring(begin, str_.length);
					break;
				}
			}
			return "\"" + quoted + "\"";
		}
		
		/**
		 * Parsuje czas w formacie HHHH:MM:SS.ss
		 *
		 * @param time_ czas w formacie tekstowym
		 * @return ilość sekund
		 */
		public static function parseTime(time_:String):Number {
			if (time_.length < 1) {
				return 0;
			}
			
			// jeśli więcej niż 3 części to błąd
			var parts:Array = time_.split(":");
			if (parts.length > 3) {
				return 0;
			}
			
			// parsuj kolejne części
			var output:Number = 0;
			var index:Number = parts.length - 1;
			var tmp:Number;
			
			// sekundy
			tmp = parseFloat(parts[index]);
			if (isNaN(tmp) || tmp < 0 || tmp >= 60) {
				return 0;
			}
			output += Math.floor(tmp);
			--index;
			
			// minuty
			if (index >= 0) {
				tmp = parseInt(parts[index]);
				if ( isNaN(tmp) || tmp < 0 || tmp >= 60 || tmp != Math.floor(tmp)) {
					return 0;
				}
				output += tmp * 60;
				--index;
			}
			
			// godziny
			if (index >= 0) {
				tmp = parseInt(parts[index]);
				if ( isNaN(tmp) || tmp < 0 || tmp >= 10000 || tmp != Math.floor(tmp)) {
					return 0;
				}
				output += tmp * 3600;
			}
			return output;
		}
		
		/**
		 * Wypisuje czas w formacie HH:MM:SS
		 *
		 * @param time_ ilość sekund
		 * @return czas w formacie tekstowym
		 */
		public static function writeDuration(time_:Number):String {
			return formatTime(Math.floor(time_ / 3600),
							  Math.floor(time_ / 60) % 60,
							  time_ % 60);
		}
		
		/**
		 * Wypisuje datę i czas w formacie YYYY-MM-DDThh:mm:ss
		 *
		 * @param date_ data
		 * @return data i czas w formacie tekstowym
		 */
		public static function writeTimestamp(date_:Date):String {
			return formatDate(date_, "-") 
				   + "T" 
				   + formatTime(date_.getHours(), date_.getMinutes(), date_.getSeconds());
		}
		
		/**
		 * Wypisuje czas w formacie HH:MM:SS
		 *
		 * @param date_ data
		 * @return czas w formacie tekstowym
		 */
		public static function writeTime(date_:Date):String {
			return formatTime(date_.getHours(), date_.getMinutes(), date_.getSeconds());
		}
		
		/**
		 * Formatuje czas (HH:MM:SS)
		 *
		 * @param h_ godziny
		 * @param m_ minuty
		 * @param s_ sekundy
		 * @return sformatowany czas
		 */
		private static function formatTime(h_:Number, m_:Number, s_:Number):String {
			var output:String = "";
			
			if (h_ < 10) {
				output += "0";
			}
			output += h_.toString() + ":";
			if (m_ < 10) {
				output += "0";
			}
			output += m_.toString() + ":";
			if (s_ < 10) {
				output += "0";
			}
			output += s_.toString();
			return output;
		}
		
		/**
		 * Wypisuje datę w formacie YYYY/MM/DD
		 *
		 * @param date_ data
		 * @return data w formacie tekstowym
		 */
		public static function writeDate(date_:Date):String {
			return formatDate(date_, "/");
		}
		
		/**
		 * Formatuje datę (YYYY$separator$MM$separator$DD)
		 *
		 * @param date_ data
		 * @param separator_ separator
		 * @return sformatowana data
		 */
		private static function formatDate(date_:Date, separator_:String):String {
			var month:Number = date_.getMonth() + 1;
			var day:Number = date_.getDate();
			
			var output:String = date_.getFullYear() + separator_;
			if (month < 10) {
				output += "0";
			}
			output += month + separator_;
			if (day < 10) {
				output += "0";
			}
			output += day + "";
			return output;
		}
		
		/**
		 * Wyciąga nazwę hosta z urla.
		 *
		 * @param url_ dowolny url
		 * @return nazwa hosta
		 */
		public static function extractHost(url_:String):String {
			if (url_ == null || url_.length == 0) {
				return null;
			}
			
			var tmp:String = url_.toUpperCase();
			var begin:Number = tmp.indexOf("HTTP://");
			begin = (begin >= 0) ? begin + 7 : 0;
			var end:Number = tmp.indexOf("/", begin);
			if (end < 0) {
				end = tmp.length;
			}
			return url_.substring(begin, end);
		}
		
		/**
		 * Sprawdza, czy przekazany napis jest pusty lub ma wartość <code>null</code>
		 * Uwaga: napis zawierający tylko białe znaki uważany jest za pusty
		 * 
		 * @param str_ napis do sprawdzenia
		 * @return <code>true</code> jeśli napis jest pusty lub ma wartość <code>null</code>, 
		 *  a w przeciwnyn wypadku <code>false</code>
		 */
		public static function isEmptyOrNull(str_:String):Boolean {
			return Boolean(str_ == null || trim(str_) == "");
		}
		
	}
}

