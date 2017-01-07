package pl.mynetwork.typewriter.models
{


	//---------------------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import pl.mynetwork.typewriter.Cmd;
	import flash.events.Event;






	//---------------------------------------------------
	public class MetronomModule
	{



		//---------------------------------------------------
		private var passedMetronom:MovieClip;




		private var toggleKeyStartPosX:Number = 0;
		private var metronomButtonStartPosX:Number = 0;
		private var minValue:Number = 60;
		private var maxValue:Number = 300;
		private var minX:Number = 0;
		private var maxX:Number = 0;
		private var totalSteps:Number = (300-60)/10;
		private var discreteTickSum:Number = 0;
		private var tickDelaySpeed:Number = 0;
		private var tickNum:Number = 0;
		private var descriteSecondTick:Number = 1000/24;



		var playedSound:Boolean = false;




		//---------------------------------------------------
		private static var METRONOM_STATE:Boolean = false;




		//---------------------------------------------------
		public function MetronomModule()
		{
			// constructor code
		}



		//---------------------------------------------------
		public function setMetronom(_metronom:MovieClip)
		{

			passedMetronom = _metronom;
			setControl(passedMetronom);
			setDisplayData(passedMetronom);
		}





		//---------------------------------------------------
		private function setControl(_mc:MovieClip)
		{
			_mc.tempomatKnob.buttonMode = true;
			_mc.tempoField.mouseEnabled = false;
			_mc.tempomatBlock.visible = false;
			minX = _mc.tempomatKnob.x;
			maxX = _mc.tempomatKnob.x + passedMetronom.metronomMoveArea.width;
			_mc.tempomatButton.addEventListener(MouseEvent.CLICK, 			onToggleTempomat);
			_mc.tempomatKnob.addEventListener(MouseEvent.MOUSE_DOWN, 		onStartAdjustMetronom);
			_mc.tempomatKnob.addEventListener(Event.ENTER_FRAME, 				onUpdateMetronomTextData);

		}



		//---------------------------------------------------
		private function setDisplayData(_mc:MovieClip)
		{
			_mc.tempomatCheckbox.visible = false;
		}





		//---------------------------------------------------
		private function onStartAdjustMetronom(e:MouseEvent):void
		{
			var rectangle:Rectangle = new Rectangle(passedMetronom.metronomMoveArea.x,
			passedMetronom.metronomMoveArea.y,
			passedMetronom.metronomMoveArea.width,
			0);
			passedMetronom.tempomatKnob.addEventListener(Event.ENTER_FRAME, 				onUpdateMetronomTextData);
			passedMetronom.parent.parent.addEventListener(MouseEvent.MOUSE_UP,	 		onEndAdjustMetronom);
			e.target.startDrag(true,rectangle);

		}





		//---------------------------------------------------
		private function onUpdateMetronomTextData(e:Event):void
		{
			var sliderValue = (e.target.x-minX)/passedMetronom.metronomMoveArea.width;
			var discreteSliderValue = Math.floor(sliderValue*totalSteps)/totalSteps;
			var tempo = minValue+(maxValue-minValue)*discreteSliderValue;
			passedMetronom.tempoField.text = "" + (tempo + 120);
			var speed = 1000/((tempo + 120)/60);
			tickDelaySpeed = Math.round(speed);
		}






		//---------------------------------------------------
		private function tickFunction(e:Event):void
		{

			discreteTickSum = discreteTickSum + descriteSecondTick;

			if(discreteTickSum > tickDelaySpeed)
			{
				passedMetronom.tempomatBlock.visible = true;
				if(!playedSound)
				{
					Cmd.getSoundManager().playSound(2);
					playedSound = true;
				}

				if(discreteTickSum > tickDelaySpeed + tickDelaySpeed/2)
				{
					discreteTickSum = 0;
					passedMetronom.tempomatBlock.visible = false;
					playedSound = false;
				}
			}
		}






		//---------------------------------------------------
		private function onEndAdjustMetronom(e:MouseEvent):void
		{
			passedMetronom.tempomatKnob.removeEventListener(Event.ENTER_FRAME, 				onUpdateMetronomTextData);
			passedMetronom.parent.parent.removeEventListener(MouseEvent.MOUSE_UP,	 		onEndAdjustMetronom);
			e.target.stopDrag();
		}





		//---------------------------------------------------
		private function onToggleTempomat(e:MouseEvent):void
		{
			if(passedMetronom.tempomatCheckbox.visible)
			{
				passedMetronom.tempomatCheckbox.visible = false;
				METRONOM_STATE = false;
				passedMetronom.removeEventListener(Event.ENTER_FRAME,													tickFunction);
				passedMetronom.tempomatBlock.visible = false;
			}
			else
			{
				passedMetronom.tempomatCheckbox.visible = true;
				METRONOM_STATE = true;
				passedMetronom.addEventListener(Event.ENTER_FRAME,													tickFunction);
				passedMetronom.tempomatBlock.visible = true;
			}
		}
	}
}
