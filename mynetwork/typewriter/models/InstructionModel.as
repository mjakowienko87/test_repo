package pl.mynetwork.typewriter.models
{



	//-----------------------------------------------
	import flash.display.MovieClip;
	import com.freeactionscript.Scrollbar;
	import pl.mynetwork.typewriter.Cmd;
	import flash.events.MouseEvent;





	//-----------------------------------------------
	public class InstructionModel extends MovieClip
	{





		//-----------------------------------------------
		private var _scrollBar:Scrollbar;






		//-----------------------------------------------
		public function InstructionModel()
		{
			// constructor code
		}





		//-----------------------------------------------
		public function _initInstruction(_data:Array)
		{
			Cmd.APP_MAIN_CONTAINER.addChild(this);
			iks.addEventListener(MouseEvent.CLICK, onCloseInstruction);
			insertData(_data);
			initScroll();
		}





		//-----------------------------------------------
		public function _initInstructionString(_data:String,_title:String)
		{
			Cmd.APP_MAIN_CONTAINER.addChild(this);
			iks.addEventListener(MouseEvent.CLICK, onCloseInstruction);
			insertDataString(_data,_title);
			initScroll();
		}






		//-----------------------------------------------
		private function onCloseInstruction(e:MouseEvent):void
		{
			Cmd.getDisplayDataControler().hideAllHighlights();
			Cmd.APP_MAIN_CONTAINER.removeChild(this);
		}




		//-----------------------------------------------
		private function initScroll()
		{
			_scrollBar = new Scrollbar();
			_scrollBar.init(_content, contentMask, track, slider);
		}




		private function insertDataString(_data:String,_title:String):void
		{
			_content.mTxt.text = "";
			_content.mTxt.htmlText = "" + _data;
			contentTitleTF.text = "" + _title;
			_content.mTxt.height = _content.mTxt.numLines *20;
		}





		private function insertData(_data:Array):void
		{
			_content.mTxt.text = "";
			for(var k in _data)
			{
				_content.mTxt.text = "" + _content.mTxt.text + _data[k] + "\n";
			}

			_content.mTxt.height = _content.mTxt.numLines *20;
		}
	}
}
