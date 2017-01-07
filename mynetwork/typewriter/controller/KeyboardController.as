package pl.mynetwork.typewriter.controller
{
	import pl.mynetwork.typewriter.controller._root.Controler;
	import pl.mynetwork.typewriter.Cmd;
	import flash.display.Stage;
	import pl.mynetwork.typewriter.view.KeyboardView;
	import flash.display.MovieClip;
	import pl.mynetwork.typewriter.models.MetronomModule;





	public class KeyboardController extends Controler
	{




		//-----------------------------------------------
		private static var p_stage:Stage;




		//-----------------------------------------------
		private var _keyboardView:KeyboardView;
		private var _metronomModule:MetronomModule;




		//-----------------------------------------------
		private var _keyboardModel:MovieClip;





		//-----------------------------------------------
		public function KeyboardController()
		{

		}







		//-----------------------------------------------
		public function _initControler(_stage:Stage):void
		{
			p_stage = _stage;

			_keyboardView = new KeyboardView();
			_keyboardModel = new keyboardModel();
			_metronomModule = new MetronomModule();
		}








		//-----------------------------------------------
		public function _startControler(_y:Number,_h:Number):void
		{
			setKeyboard(_y,_h);
		}




		//-----------------------------------------------
		public function getKeyboardModel():MovieClip
		{
			return _keyboardModel;
		}





		//-----------------------------------------------
		public function getMetronomModule():MetronomModule
		{
			return _metronomModule;
		}




		//-----------------------------------------------
		private function setKeyboard(_y:Number,_h:Number)
		{
			Cmd.APP_MAIN_CONTAINER.addChild(_keyboardModel);
			_keyboardModel._initKeyboard(p_stage);
			_keyboardModel._setPositionRelative(_y,_h);
			_keyboardModel._setSizeRelative();

		}
	}
}
