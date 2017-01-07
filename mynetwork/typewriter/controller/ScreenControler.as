package pl.mynetwork.typewriter.controller
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import pl.mynetwork.typewriter.Cmd;
	import flash.ui.Keyboard;
	import pl.mynetwork.typewriter.models.ScreenModel;
	import pl.mynetwork.typewriter.controller._root.Controler;





	public class ScreenControler extends Controler
	{




		//-----------------------------------------------
		private static var p_stage:Stage;






		//-----------------------------------------------
		public function ScreenControler()
		{

		}




		//-----------------------------------------------
		public function _initControler(_stage:Stage):void
		{
			p_stage = _stage;
		}




		//-----------------------------------------------
		public function _startControler():void
		{
			p_stage.addEventListener(KeyboardEvent.KEY_DOWN, 	onSetKeybardEvent);
			p_stage.addEventListener(KeyboardEvent.KEY_UP, 		onResetKeyCode);
		}





		//-----------------------------------------------
		public function _removeController():void
		{
			p_stage.removeEventListener(KeyboardEvent.KEY_DOWN, 	onSetKeybardEvent);
			p_stage.removeEventListener(KeyboardEvent.KEY_UP, 		onResetKeyCode);
		}






		//-----------------------------------------------
		private function onResetKeyCode(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACKSPACE)
			{
				ScreenModel.UPDATE_TEXT = true;
			}
		}






		//-----------------------------------------------
		private function onSetKeybardEvent(e:KeyboardEvent):void
		{
			if(!Cmd.TEXT_FINISHED)
			{
				if(e.keyCode == Keyboard.ENTER)
				{
					if(Cmd.getKeyboardController().getKeyboardModel().get_enter().visible)
					{
						Cmd.getSoundManager().playSound(3);
						nextObjectFocus();
					}
				}
				if(e.keyCode == Keyboard.DOWN)
				{
					moveScreen("DOWN");
				}
				if(e.keyCode == Keyboard.UP)
				{
					moveScreen("UP");
				}
				if(e.keyCode == Keyboard.BACKSPACE)
				{
					ScreenModel.UPDATE_TEXT = false;
					setEnterVisible(false);
					Cmd.getScreenModel_().getObjectArray()[ScreenModel._objIndex].eraseLetter(ScreenModel._objIndex);
				}
				if(e.keyCode != Keyboard.BACKSPACE)
				{
					ScreenModel.UPDATE_TEXT = true;
					moveToNextLineAtEnd();
				}
			}
		}





		//-----------------------------------------------
		private function setEnterVisible(_state:Boolean):void
		{
			if(Cmd.getKeyboardController().getKeyboardModel().get_enter().visible)
			{
				Cmd.getKeyboardController().getKeyboardModel().get_enter().visible = _state;
			}
		}



		//-----------------------------------------------
		private function moveToNextLineAtEnd()
		{
			if(Cmd.getKeyboardController().getKeyboardModel().get_enter().visible)
			{
				Cmd.getScreenModel_().set_errorsInTyping(Cmd.getScreenModel_().get_errorsInTyping()+1);
				nextObjectFocus();
			}
		}





		//-----------------------------------------------
		public function getAllTypedLetters():Number
		{
			var _sum:Number = 0;
			for(var k in Cmd.getScreenModel_().getObjectArray()) _sum += Cmd.getScreenModel_().getObjectArray()[k].dInTxt.text.length;
			return _sum;
		}





		//-----------------------------------------------
		public function moveScreen(_instruction:String, _moveY:Number = 52.6):void
		{
			if(_instruction == "DOWN")
			{
				Cmd.getScreenModel_().moveScreenContainer(_moveY*-1);
			}
			if(_instruction == "UP")
			{
				Cmd.getScreenModel_().moveScreenContainer(_moveY);
			}
		}






		//-----------------------------------------------
		public function nextObjectFocus():void
		{
			Cmd.getScreenModel_().onSetNextObject(p_stage);
			Cmd.getKeyboardController().getKeyboardModel()._hideEnter();
			Cmd.getKeyboardController().getKeyboardModel().getLetterByName(Cmd.getScreenModel_().getObjectArray()[ScreenModel._objIndex].dTxt.text.charAt(0));
			if(Cmd.getScreenModel_().getObjectArray()[ScreenModel._objIndex].get_y() > (Cmd.getScreenModel_().getObjectArray()[ScreenModel._objIndex].get_container_height() - Cmd.getScreenModel_().getObjectArray()[ScreenModel._objIndex].height))
			{
				moveScreen("DOWN",Cmd.getScreenModel_().getObjectArray()[ScreenModel._objIndex].height);
			}

		}






		//-----------------------------------------------
		public function prevObjectFocus():void
		{
			Cmd.getScreenModel_().onSetPrevObject(p_stage);
		}





		//-----------------------------------------------
		public function updateScreenModel():void
		{

		}



		//-----------------------------------------------
		public function _keyboardListener(_a:Number,_b:Number,_c:Number,_d:Number):void
		{
			Cmd.getDisplayDataControler().updateDisplayControler(_a,_b,_c,_d);
		}
	}
}
