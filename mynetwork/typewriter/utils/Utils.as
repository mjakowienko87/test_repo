package pl.mynetwork.typewriter.utils
{




	//---------------------------------------------------
	import flash.text.TextField;





	//---------------------------------------------------
	public class Utils
	{




		//---------------------------------------------------
		private var i									:Number = 0;





		//---------------------------------------------------
		private var _spaceBtn					:String = " ";





		//---------------------------------------------------
		public function Utils()
		{

		}





		//---------------------------------------------------
		public function calculateLenght(_width:Number, _singleLetter:Number):Number
		{
			return Math.round(_width/_singleLetter);
		}






		//---------------------------------------------------
		public function renderHtmlText(_text:String, _state:String):String
		{
			var outputString:String;
			//trace(_text)
			if(_state == "_good")
			{
				if(_text == "<")
				{
					outputString = '<font color="#ff0000">' + "&lt;" + '</font>';
				}
				else if(_text != "<")
				{
					outputString = '<font color="#0000ff">' + _text + '</font>'
				}
			}
			if(_state == "_bad")
			{
				trace("_text: " + _text);
				if(_text == "<")
				{
					outputString = '<font color="#ff0000">' + "&lt;" + '</font>';
				}
				if(_text == _spaceBtn)
				{
					outputString = '<font color="#ff0000">' + "_" + '</font>'
				}
				else if(_text != _spaceBtn && _text != "<")
				{
					trace("else!")
					outputString = '<font color="#ff0000">' + _text + '</font>'
				}
			}
			return outputString;
		}




		//---------------------------------------------------
		public function returnLenghtPercentage(_dataLenght:Number,_lenght:Number,_maxLenght:Number):Number
		{
				return _lenght*(_maxLenght/_dataLenght)
		}






		//---------------------------------------------------
		public function rewriteOverlayText (_textField_source:TextField,
																				_textField_replace:TextField,
																				_textfield_appr:TextField,
																				_overlayTxt:String):String
		{
			var _repStr:String = "";
			for(i = 0; i < _textfield_appr.text.length-1; i ++)
			{
				if(_textfield_appr.text.charAt(i) == _textField_source.text.charAt(i))
				{
					_repStr = _repStr + this.renderHtmlText(_textfield_appr.text.charAt(i),"_good");
				}
				else
				{
					_repStr = _repStr + this.renderHtmlText(_textfield_appr.text.charAt(i),"_bad");
				}
			}
			return _repStr;
		}






		//---------------------------------------------------
		public function returnRandomizedData(_data:Array, _length:Number = 240):String
		{
			return _data.length == 2 ? generateString(_data,_length) : generateWords(_data,_length);
		}





		//---------------------------------------------------
		private function generateString(patterns:Array,length:Number):String
		{
			var v_result:String = '';

	    while (v_result.length < length)
			{
	    	var v_isSpace:Boolean = false;
				v_result += patterns[1].charAt(randomInt(0, patterns[1].length - 1));
				if (randomInt(0, 9999) % 2 == 0)
				{
						v_result += ' ';
						v_isSpace = true;
				}
		    v_result += patterns[0].charAt(randomInt(0, patterns[0].length - 1));
				if (randomInt(0, 9999) % 2 == 0)
				{
					v_result += ' ';
					v_isSpace = true;
				}
				v_result += patterns[1].charAt(randomInt(0, patterns[1].length - 1));
				if (!v_isSpace)
				{
					v_result += ' ';
				}
	    	v_result += patterns[1].charAt(randomInt(0, patterns[1].length - 1));
	    	v_result += patterns[0].charAt(randomInt(0, patterns[0].length - 1));
				if (randomInt(0, 9999) % 2 == 0)
				{
					v_result += ' ';
				}
	    	v_result += patterns[1].charAt(randomInt(0, patterns[1].length - 1));
			}
			v_result = v_result.substr(0, length);

			if (v_result.charAt(length - 1) == ' ')
			{
				v_result = v_result.substr(0, length - 1) + patterns[1].charAt(randomInt(0, patterns[1].length - 1));
			}

			return v_result;
		}





		//---------------------------------------------------
		private function generateWords(words:Array,length:Number):String
		{
			var v_result:String = '';

	    while (v_result.length < length - 6)
			{
				var v_word:String = words[randomInt(0, words.length - 1)];
				if (v_result.length + v_word.length < length - 2)
				{
			    	v_result += v_word + ' ';
				}
	    }
			for (var v_i:Number = words.length - 1; v_i >= 0; --v_i)
			{
				if (v_result.length + words[v_i].length == length)
				{
						v_result += words[v_i];
						break;
				}
			}
			if (v_result.length < length)
			{
				v_result = (v_result + words[randomInt(0, words.length - 1)]).substr(0, length);
			}
			return v_result;
		}



		//---------------------------------------------------
		private function randomInt(min:Number, max:Number):Number
		{
				return Math.floor(Math.random() * (max + 1 - min)) + min;
		}





		//---------------------------------------------------
		public function returnValuePercentage( _value:Number, min:Number, max:Number ):Number
		{
			return ((( _value - min ) / ( max - min )) * 100 );
		}
	}
}
