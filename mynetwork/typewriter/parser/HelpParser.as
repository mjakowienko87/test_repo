package pl.mynetwork.typewriter.parser
{



	//---------------------------------------------------
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;





	//---------------------------------------------------
	public class HelpParser extends EventDispatcher
	{


		//---------------------------------------------------
		private var loader									:URLLoader;
		private var rawXML									:XML;




		//---------------------------------------------------
		private var helpTitle:String = "";
		private var helpData:String = "";





		//---------------------------------------------------
		public function HelpParser()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onParsedXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}




		//---------------------------------------------------
		private function onIOError(e:Event):void
		{
			trace("No valid link! @HelpParser");
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

			helpTitle = rawXML.instructionMain.@title;
			helpData = rawXML.instructionMain.children();

			trace(helpTitle, helpData);


			dispatchEvent(new Event(Event.COMPLETE, true));
		}




		//---------------------------------------------------
		public function getHelpData():String
		{
			return helpData;
		}





		//---------------------------------------------------
		public function getHelpTitle():String
		{
			return helpTitle;
		}
	}
}
