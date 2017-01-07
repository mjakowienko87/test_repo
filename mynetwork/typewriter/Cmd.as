package pl.mynetwork.typewriter
{


	//-----------------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;



	//-----------------------------------------------
	import pl.mynetwork.typewriter.GameCommunication;



	//-----------------------------------------------
	import pl.mynetwork.typewriter.models.ScreenModel;




	//-----------------------------------------------
	import pl.mynetwork.typewriter.parser.TypewriterXmlParser;
	import pl.mynetwork.typewriter.parser.HelpParser;




	//-----------------------------------------------
	import pl.mynetwork.typewriter.controller.AppControler;
	import pl.mynetwork.typewriter.controller.ScreenControler;




	//-----------------------------------------------
	import pl.mynetwork.typewriter.utils.Utils;
	import pl.mynetwork.typewriter.utils.StringUtils;
	import pl.mynetwork.typewriter.utils.TimeManagement;
	import pl.mynetwork.typewriter.utils.Dictionary;




	//-----------------------------------------------
	import pl.mynetwork.typewriter.controller.DisplayDataControler;
	import pl.mynetwork.typewriter.controller.KeyboardController;
	import pl.mynetwork.typewriter.controller._root.Controler;



	//-----------------------------------------------
	import pl.mynetwork.pc.ITrackerMovieStandalone;
	import pl.mynetwork.pc.TrackerMovieStandalone;
	import pl.mynetwork.player.ITracker;
	import pl.mynetwork.typewriter.events.ComEvent;
	import pl.mynetwork.typewriter.controller.HeaderController;




	//-----------------------------------------------
	import pl.mynetwork.typewriter.Sound.SoundManager;





	//-----------------------------------------------
	public class Cmd extends MovieClip
	{




		//-----------------------------------------------
		private static var trackerComponent						:ITrackerMovieStandalone;
		private static var tracker										:ITracker;
		private static var gameCommunication					:GameCommunication;




		//-----------------------------------------------
		private static var _typeParser							:TypewriterXmlParser;
		private static var _helpParser							:HelpParser;
		private static var _soundManager						:SoundManager;
		private static var _dictionary							:Dictionary;
		private static var _screenModel							:ScreenModel;
		private static var _appConroler							:AppControler;
		private static var _displayDataControler		:DisplayDataControler;
		private static var _keyboardController			:KeyboardController;
		private static var _screenControler					:ScreenControler;
		private static var _headerController				:HeaderController;
		private static var _utils										:Utils;
		private static var _timeManagement					:TimeManagement;
		private static var _screenModel_						:MovieClip;
		private static var p_stage									:Stage;
		private static var _headerMC								:MovieClip;
		private static var _instructionMc						:MovieClip;





		//-----------------------------------------------
		public static var APP_MAIN_CONTAINER					:MovieClip;






		//-----------------------------------------------
		public static var DISPLAY_DATA_CATEGORY					:Number = 5;
		public static var SPEED_TRSH										:Number = 10;






		//-----------------------------------------------
		public static var _PASS_SCORE									:Number = 0;
		public static var _PASS_SPEED									:Number = 0;






		//-----------------------------------------------
		public static var UI_OBJECT_LIST						= ["PROGRESS","TIME","DYNAMIC_ERROR","ERROR","SPEED"]
		public static var UI_POS_X									= [100,150,250,340,440];
		public static var UI_POS_Y									= [43,9,9,9,9];





		//-----------------------------------------------
		public static var TEXT_FINISHED							:Boolean = false;




		//-----------------------------------------------
		public static var XML_PATH								:String = "";








		/*////////////////////////////////////////////////////////////////////////////

		Metody iniciujące

		*/
		//-----------------------------------------------
		public static function _initApplication(_stage:Stage, _loadPath:String):void
		{
			XML_PATH 																		= _loadPath;
			p_stage 																		= _stage;
			var trackerLinkageClass:Class 							= _stage.loaderInfo.applicationDomain.getDefinition("trackerStandalone") as Class;
			trackerComponent 														= new trackerLinkageClass() as ITrackerMovieStandalone;
			_stage.addChild(MovieClip(trackerComponent));
			MovieClip(trackerComponent).visible 				= false;
			tracker 																		= ITracker(trackerComponent.getTracker());
			gameCommunication = new GameCommunication(tracker);
			gameCommunication.addEventListener(ComEvent.INIT, 		onCommunicationInit);
			gameCommunication.addEventListener(ComEvent.FAIL, 		onCommunicationFail);
			gameCommunication.init();
		}






		//-----------------------------------------------
		private static function onCommunicationFail(event:ComEvent):void
		{
			trace("COMMUNICATION FAILED");
		}




		//-----------------------------------------------
		private static function onCommunicationInit(event:ComEvent):void
		{
			_screenModel_ 						= new screenModule();
			_utils 										= new Utils;
			_helpParser								= new HelpParser();
			_typeParser 							= new TypewriterXmlParser();
			_screenModel 							= new ScreenModel();
			_screenControler 					= new ScreenControler();
			_timeManagement 					= new TimeManagement();
			_displayDataControler			= new DisplayDataControler;
			_keyboardController				= new KeyboardController();
			_headerController					= new HeaderController();
			_headerMC 								= new app_header();
			_instructionMc						= new instructionModule();
			_dictionary								= new Dictionary();
			_soundManager							= new SoundManager();

			APP_MAIN_CONTAINER 				= new MovieClip();
			p_stage.addChild(APP_MAIN_CONTAINER);
			_appConroler 							= new AppControler(p_stage);
			_appConroler._initApp();
		}






		/*////////////////////////////////////////////////////////////////////////////
		*/
		//-----------------------------------------------
		public static function getDictionary():Dictionary
		{
			return _dictionary;
		}






		/*////////////////////////////////////////////////////////////////////////////
		*/
		//-----------------------------------------------
		public static function getSoundManager():SoundManager
		{
			return _soundManager;
		}



		public static function getNewInstance():MovieClip{
			return null
		}



		public static function getNewerInstanceOfOtherMC():MovieClip{
			return null
		}









		/*////////////////////////////////////////////////////////////////////////////
		Metody get dla klas modeli
		*/
		//-----------------------------------------------
		public static function getScreenModel():ScreenModel
		{
			return _screenModel;
		}





		//-----------------------------------------------
		public static function getAppController():AppControler
		{
			return _appConroler;
		}






		//-----------------------------------------------
		public static function getScreenControler():ScreenControler
		{
			return _screenControler;
		}






		//-----------------------------------------------
		public static function getDisplayDataControler():DisplayDataControler
		{
			return _displayDataControler
		}






		//-----------------------------------------------
		public static function getKeyboardController():KeyboardController
		{
			return _keyboardController;
		}






		//-----------------------------------------------
		public static function getHeaderController():HeaderController
		{
			return _headerController;
		}






		//-----------------------------------------------
		public static function getAppHeaderController():MovieClip
		{
			return _headerMC;
		}






		//-----------------------------------------------
		public static function getInstructionModule():MovieClip
		{
			return _instructionMc;
		}
		
		
		public static function newFunction():MovieClip
		{
			return new MovieClip();
		}









		/*////////////////////////////////////////////////////////////////////////////
		Metody get dla klas modeli przypisanych do MovieClip'ów w bibliotece
		*/
		//-----------------------------------------------
		public static function getScreenModel_():MovieClip
		{

			return _screenModel_;
		}








		/*////////////////////////////////////////////////////////////////////////////
		Metody get dla instancji klas
		*/
		//-----------------------------------------------
		public static function getTypewriterParser():TypewriterXmlParser
		{
			return _typeParser;
		}





		//-----------------------------------------------
		public static function getHelpParser():HelpParser
		{
			return _helpParser;
		}



		_helpParser




		//-----------------------------------------------
		public static function getUtils():Utils
		{
			return _utils;
		}




		//-----------------------------------------------
		public static function getTimeManagement():TimeManagement
		{
			return _timeManagement;
		}




		//-----------------------------------------------
		public static function get_tracker():ITracker
		{
			return tracker;
		}

	}
}
