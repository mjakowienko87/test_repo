package pl.mynetwork.typewriter.parser
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;

	public class TypewriterXmlParser extends EventDispatcher
	{



		//---------------------------------------------------
		private var loader									:URLLoader;
		private var rawXML									:XML;




		//---------------------------------------------------
		private var _type_text								:String;
		private var _title										:String;
		private var _smallTitle								:String;
		private var _instruction							:String;
		private var _helpText									:String;
		private var _movedStr									:String = "";
		private var _instructionMain					:String = "";
		private var _instructionTitle					:String = "";





		//---------------------------------------------------
		private var _setBorder								:Boolean;






		//---------------------------------------------------
		private var _sWidth									:Number = 0;
		private var _sHeight								:Number = 0;
		private var _sPosY									:Number = 0;
		private var i												:Number = 0;
		private var _dataDistr							:Number = -1;
		private var _passScore							:Number = 0;
		private var _sigleLineLength				:Number = 85;
		private var _testArrayPath					:Number = -1;
		private var _charNumber							:Number = 0;
		private var _speed         					:Number = 0;



		//---------------------------------------------------
		private var lineArray								:Array = [];





		//---------------------------------------------------
		public function TypewriterXmlParser()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onParsedXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}




		//---------------------------------------------------
		private function onIOError(e:Event):void
		{
			trace("No valid link! @TypewriterXmlParser");
		}



		//---------------------------------------------------
		public function init(_path:String):void
		{
			loader.load(new URLRequest(_path));
		}





		//---------------------------------------------------
		private function onParsedXML(e:Event)
		{
			rawXML = new XML(loader.data);

			_type_text 								= rawXML.type_text.children();
			_sWidth										= rawXML.type_text.@setWidth;
			_sHeight									= rawXML.type_text.@setHeight;
			_sPosY										= rawXML.type_text.@_setPosY;
			_dataDistr								= rawXML.type_text.@dataDistr;
			_title 										= rawXML.type_text.@title;
			_smallTitle								= rawXML.type_text.@smallTitle;
			_instruction							= rawXML.type_text.@instruction;
			_helpText									= rawXML.type_text.@help;
			_passScore 								= rawXML.type_text.@passingScore;
			_testArrayPath						= rawXML.type_text.@testNumber;
			_charNumber								= rawXML.type_text.@charsNum;
			_speed										= rawXML.type_text.@speed;

			_instructionTitle					= rawXML.type_text.@instructionTitle;
			_instructionMain 					= rawXML.instructionMain.children();
			trace("_instructionTitle: ", _instructionTitle);

			if(rawXML.type_text.@setBorder == "true")
			{
				_setBorder = true;
			}
			else if(rawXML.type_text.@setBorder == "false")
			{
				_setBorder = false;
			}



			for(i = 0; i < rawXML.type_text.children().length(); i ++)
			{
				var lineString:String = rawXML.type_text.children()[i];
				if(lineString.length > _sigleLineLength)
				{
					var dataLength:Number = lineString.length;
					var lineNum:Number = dataLength / _sigleLineLength;

					var counter:Number = 0;
					for(var k:Number = 0; k < lineNum; k ++)
					{
						var _slicedStr:String = "";
						for(var f:Number = 0; f < _sigleLineLength; f ++)
						{
							if(_movedStr.length > 0)
							{
								_slicedStr = _movedStr;
								_slicedStr = _slicedStr + lineString.charAt(counter);
								_movedStr = "";
							}
							else
							{
								_slicedStr = _slicedStr + lineString.charAt(counter);
							}
							counter ++;
						}
						var _checkedStr:String = checkIfLastLetterIsSingle(_slicedStr);
						if(_checkedStr.length > 0)
						{
							var _removedLastCharString:String = _slicedStr.slice(0,_slicedStr.length-_checkedStr.length);
							if(_removedLastCharString.length > 0)
							{
								lineArray.push(_removedLastCharString);
							}

						}
						else
						{
							if(_slicedStr.length > 0)
							{
								lineArray.push(_slicedStr);
							}

						}
					}
					if(lineNum % _sigleLineLength != 0)
					{
						var lastLine:Number = lineNum % _sigleLineLength;
						var lastString:String = "";
						for(var g:Number = 0; g < lastLine; g++)
						{
							lastString = lastString + lineString.charAt(counter);
							counter ++;
						}
						if(lastString.length > 0)
						{
							lineArray.push(lastString);
						}

					}
				}
				else
				{
					lineArray.push(lineString);
				}
			}


			dispatchEvent(new Event(Event.COMPLETE, true));
		}




		//---------------------------------------------------
		private function checkIfLastLetterIsSingle(_str:String):String
		{
			if(_str.charAt(_str.length-2) == " ")
			{
				_movedStr = _str.charAt(_str.length-1);
				return _movedStr;
			}
			if(_str.charAt(_str.length-3) == " ")
			{
				_movedStr = _str.charAt(_str.length-2) + _str.charAt(_str.length-1);
				return _movedStr;
			}
			if(_str.charAt(_str.length-4) == " ")
			{
				_movedStr = _str.charAt(_str.length-3) + _str.charAt(_str.length-2) + _str.charAt(_str.length-1);
				return _movedStr;
			}
			return _movedStr;
		}




		//---------------------------------------------------
		public function get_instructionTitle():String
		{
			return _instructionTitle;
		}




		//---------------------------------------------------
		public function get_instructionMain():String
		{
			return _instructionMain;
		}





		//---------------------------------------------------
		public function getHelp():String
		{
			return _helpText;
		}






		//---------------------------------------------------
		public function getInstruction():String
		{
			return _instruction;
		}






		//---------------------------------------------------
		public function getTitle():String
		{
			return _title;
		}








		//---------------------------------------------------
		public function getSmallTitle():String
		{
			return _smallTitle
		}






		//---------------------------------------------------
		public function get_lineArray():Array
		{
			return lineArray;
		}





		//---------------------------------------------------
		public function get_testArrayPath():Number
		{
			return _testArrayPath
		}




		//---------------------------------------------------
		public function get_speed():Number
		{
			return _speed;
		}



		//---------------------------------------------------
		public function get_charNumber():Number
		{
			return _charNumber
		}




		//---------------------------------------------------
		public function get_dataDistr():Number
		{
			return _dataDistr
		}




		//---------------------------------------------------
		public function get_passScore():Number
		{
			return _passScore;
		}




		//---------------------------------------------------
		public function get_type_text():String
		{
			return _type_text;
		}





		//---------------------------------------------------
		public function get_setBorder():Boolean
		{
			return _setBorder;
		}










		//---------------------------------------------------
		public function get_sWidth():Number
		{
			return _sWidth;
		}





		//---------------------------------------------------
		public function get_sHeight():Number
		{
			return _sHeight;
		}





		//---------------------------------------------------
		public function get_sPosY():Number
		{
			return _sPosY;
		}
	}
}
