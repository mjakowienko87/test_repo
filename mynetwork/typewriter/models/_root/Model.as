package pl.mynetwork.typewriter.models._root
{

	import pl.mynetwork.typewriter.parser.TypewriterXmlParser;
	import pl.mynetwork.typewriter.parser.HelpParser;
	import flash.display.MovieClip;


	//---------------------------------------------------
	public class Model extends MovieClip
	{



		//---------------------------------------------------
		protected var _parser:TypewriterXmlParser;
		protected var _helpParser:HelpParser;





		//---------------------------------------------------
		public function Model()
		{
			_parser = new TypewriterXmlParser();
			_helpParser = new HelpParser();
		}
	}
}
