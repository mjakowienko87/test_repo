package pl.mynetwork.typewriter.controller
{
	import pl.mynetwork.typewriter.Cmd;
	import pl.mynetwork.typewriter.controller.ScreenControler;
	import pl.mynetwork.typewriter.models.ScreenModel;
	import pl.mynetwork.typewriter.controller.DisplayDataControler;
	import pl.mynetwork.typewriter.event.DataComplete;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import pl.mynetwork.typewriter.controller._root.Controler;



	public class AppControler extends Controler
	{



		//-----------------------------------------------
		private var _screenControler:ScreenControler;





		//-----------------------------------------------
		private var p_stage:Stage;





		//-----------------------------------------------
		public function AppControler(_stage:Stage)
		{
			p_stage = _stage;
		}





		//-----------------------------------------------
		public function _initApp():void
		{
			if(Cmd.getScreenModel_())
			{
				Cmd.APP_MAIN_CONTAINER.addChild(Cmd.getScreenModel_());
				Cmd.getScreenControler()._initControler(p_stage);
				Cmd.getScreenControler()._startControler();

				Cmd.getDisplayDataControler()._initControler(p_stage);
				Cmd.getDisplayDataControler()._startControler();

				Cmd.getDisplayDataControler().get_displayDataView().updateViewArray(0,0,0,0);
				Cmd.getDisplayDataControler().get_displayDataView().updateGrossWPM(0);
				Cmd.getDisplayDataControler().get_displayDataView().updateTime("00:00");

				Cmd.getSoundManager().setupSound();

			}
		}



		//-----------------------------------------------
		public function _configureKeyboard(_y:Number,_h:Number):void
		{
			Cmd.getKeyboardController()._initControler(p_stage);
			Cmd.getKeyboardController()._startControler(_y,_h);
			Cmd.getKeyboardController().getKeyboardModel().getLetterByName(Cmd.getScreenModel_().getObjectArray()[0].dTxt.text.charAt(0));

			Cmd.getAppHeaderController()._initHeader();
			
		}



	}
}
