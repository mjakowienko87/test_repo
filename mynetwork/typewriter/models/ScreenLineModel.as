package pl.mynetwork.typewriter.models
{



	import pl.mynetwork.typewriter.models._root.Model;
	import pl.mynetwork.typewriter.Cmd;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;





	//---------------------------------------------------
	public class ScreenLineModel extends Model
	{




		//---------------------------------------------------
		private var _inlineText								:String = "::NaN::";





		//---------------------------------------------------
		private var _y													:Number = 0;
		private var _containerHeigth						:Number = 0;
		private var _length											:Number = 0;
		private var _id													:Number = -1;
		private var _lineLength									:Number = 0;
		private var _speedTyping								:Number = 0;




		//---------------------------------------------------
		public var _overlayText								:String = "";






		//---------------------------------------------------
		private var pressEnter								:Boolean = false;





		//---------------------------------------------------
		public function ScreenLineModel()
		{
			if(!stage)addEventListener(Event.ADDED_TO_STAGE, _init);
			else _init();

		}





		//---------------------------------------------------
		private function _init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _init);
		}






		//---------------------------------------------------
		public function setInlineText(_text:String):String
		{
			var inpText:String = "";
			if(_text.charAt(0) == " ")
			{
				inpText = _text.substr(1);
			}
			else
			{
				inpText = _text;
			}

			this._inlineText = inpText;
			updateText(this._inlineText);
			return inpText;
		}




		//---------------------------------------------------
		private function updateText(_text:String):void
		{
			this.dTxt.text = "" + _text;
		}





		//---------------------------------------------------
		public function getInlineText():String
		{
			return this._inlineText;
		}




		//---------------------------------------------------
		public function set_id(_n:Number):void
		{
			_id = _n;
		}




		//---------------------------------------------------
		public function get_id():Number
		{
			return _id;
		}





		//---------------------------------------------------
		public function _setWidth(_n:Number = 800):void
		{
			this.dTxt.width = _n;
			this.iTxt.width = _n;
			this.dInTxt.width = _n;
		}



		//---------------------------------------------------
		public function _border(_state:Boolean = false)
		{
			this.dTxt.border = _state;
			this.iTxt.border = _state;
		}




		//---------------------------------------------------
		public function _setMaxChar(_maxChar:Number):void
		{
			this.iTxt.maxChars = _maxChar;
			//trace(_maxChar);
		}





		//---------------------------------------------------
		public function addListenerToTextfields():void
		{
			this.iTxt.addEventListener(Event.CHANGE, onUpdateData);
		}




		//---------------------------------------------------
		public function _setY(_n:Number)
		{
			_y = _n;
		}




		//---------------------------------------------------
		public function _setContainerHeight(_h:Number)
		{
			this._containerHeigth = _h;
		}





		//---------------------------------------------------
		public function eraseLetter(_index:Number):void
		{
			Cmd.getKeyboardController().getKeyboardModel().getLetterByName(dTxt.text.charAt(iTxt.length-1));
			_overlayText = Cmd.getUtils().rewriteOverlayText(dTxt,dInTxt,iTxt,_overlayText);
			dInTxt.htmlText = "" + _overlayText;
			if(_index > 0)
			{
				if(iTxt.length == 0)
				{
					Cmd.getScreenControler().prevObjectFocus();
				}
			}
		}








		//---------------------------------------------------
		private function onUpdateData(e:Event):void
		{
			if(!Cmd.TEXT_FINISHED)
			{
				if(ScreenModel.UPDATE_TEXT)
				{
					var _errorMargin									:Number = 0;
					var _dynamicErrorRange						:Number = 0;
					var _progress											:Number = 0;
					var _typingPerMinute							:Number = 0;

					Cmd.getScreenModel_()._resetTrackerTimer();
					Cmd.getScreenModel_()._startTimer();

					Cmd.getKeyboardController().getKeyboardModel().getLetterByName(dTxt.text.charAt(e.target.length));

					Cmd.getDisplayDataControler().showButton(2,"hide");



					if(dTxt.text.charAt(e.target.length-1) != e.target.text.charAt(e.target.length-1))
					{
						_overlayText 						= _overlayText + Cmd.getUtils().renderHtmlText(e.target.text.charAt(e.target.length-1),"_bad");
						dInTxt.htmlText 				= _overlayText;

						Cmd.getSoundManager().playSound(0);

						Cmd.getScreenModel_().set_errorsInTyping(Cmd.getScreenModel_().get_errorsInTyping()+1);

						_errorMargin 						= get_errorMargin();
						_dynamicErrorRange 			= get_dynamicErrorRange();
						_progress 							= get_progress();

					}
					else
					{
						_overlayText 						= _overlayText + Cmd.getUtils().renderHtmlText(e.target.text.charAt(e.target.length-1),"_good");
						dInTxt.htmlText 				= _overlayText;

						Cmd.getSoundManager().playSound(1);

						_errorMargin 						= get_errorMargin();
						_dynamicErrorRange 			= get_dynamicErrorRange();
						_progress 							= get_progress();
					}

					updateTypeSpeed(_typingPerMinute);



					if(Cmd.getKeyboardController().getKeyboardModel().get_enter().visible)
					{
						Cmd.getScreenControler().nextObjectFocus();
						if(_y > (_containerHeigth-(e.target.parent.height*2)))
						{
							Cmd.getScreenControler().moveScreen("DOWN",e.target.parent.height);
						}
						pressEnter = false;
					}

					if(e.target.length == this.iTxt.maxChars)
					{
						stopTimer();
						pressEnter = true;
						this._length = e.target.length + 1;

						Cmd.getKeyboardController().getKeyboardModel()._showEnter();
					}
					Cmd.getScreenControler()._keyboardListener(Cmd.getScreenModel_().get_errorsInTyping(),_dynamicErrorRange,_progress,_typingPerMinute);
				}
			}
		}





		//---------------------------------------------------
		public function get_y():Number
		{
			return this._y;
		}





		//---------------------------------------------------
		public function get_container_height():Number
		{
			return _containerHeigth;
		}





		//---------------------------------------------------
		private function stopTimer()
		{
			//trace("this._id: " + this._id, "Cmd.getScreenModel_().getObjectArray().length: " + Cmd.getScreenModel_().getObjectArray().length);
			if(this._id == Cmd.getScreenModel_().getObjectArray().length-1)
			{
				Cmd.getInstructionModule()._initInstruction(gatherUserData());
				Cmd.getScreenModel_()._stopTimer();
				Cmd.getScreenControler()._removeController();
				Cmd.TEXT_FINISHED = true;

				if((100-Math.round(get_dynamicErrorRange())) > Cmd._PASS_SCORE)
				{
					if(_speedTyping > Cmd._PASS_SPEED)
					{
						Cmd.get_tracker().setScore((100-Math.round(get_dynamicErrorRange())));
						Cmd.get_tracker().setStatus("P");
						Cmd.get_tracker().putParams();
					}
					else
					{
						lessonFail();
					}
				}
				else
				{
					lessonFail();
				}
			}
		}



		//---------------------------------------------------
		private function lessonFail()
		{
			trace("lessonFailed");
			Cmd.get_tracker().setScore((100-Math.round(get_dynamicErrorRange())));
			Cmd.get_tracker().setStatus("F");
			Cmd.get_tracker().putParams();
		}




		//---------------------------------------------------
		private function gatherUserData():Array
		{
			var _userDataArray:Array 					= [];

			var _userScore:String 						= "Twój wynik: " + String(100-Math.round(get_dynamicErrorRange()));
			var _userMistakes:String 					= "Ilość błędów: " + String(Cmd.getScreenModel_().get_errorsInTyping());
			var _userSpeed:String							= "Szybkość pisania: " + String(_speedTyping);
			var _finishMessage:String 				= "";


			_finishMessage = "\n" + "Ocena szybkości: " + getSpeedCriteriaDescription(_speedTyping) + "\n" + "\n" +
			"Ocena dokładności: " + getCorrectnessCriteriaDescription(100-Math.round(get_dynamicErrorRange()));


			_userDataArray.push(_userScore,_userMistakes,_userSpeed,_finishMessage);
			return _userDataArray;
		}





		//---------------------------------------------------
		private function getSpeedCriteriaDescription(_score:Number):String
		{
			var speedCriteria:Array = [];
			speedCriteria[0] = [-1, 60, 'żółwia, czeka Cię jeszcze sporo pracy. W tym tempie możesz przegonić tylko ślimaka.'];
			speedCriteria[1] = [60, 120, 'bardzo wolna, postaraj się zwiększyć tempo. Założę się, że stać Cię na więcej.'];
			speedCriteria[2] = [120, 180, 'wolna. Nie przejmuj się jednak, lokomotywa w wierszu Tuwima też na początku była nieco ospała.'];
			speedCriteria[3] = [180, 240, 'średnia. Założę się, że nie jest to ocena na miarę Twoich ambicji. Średniactwo jest raczej nijakie.'];
			speedCriteria[4] = [240, 280, 'dobra. Może warto jeszcze trochę potrenować i do oceny „dobra” dodać przymiotnik „bardzo”.'];
			speedCriteria[5] = [280, 350, 'bardzo dobra. Gratulacje, piątka to wspaniała ocena. Może jednak chcesz zamienić ją na szóstkę? '];
			speedCriteria[6] = [350, 400, 'znakomita. Już tylko krok dzieli Cię od tytułu Mistrza.'];
			speedCriteria[7] = [400, 100000, 'mistrzowska. Nawet struś pędziwiatr miałby kłopoty z osiągnięciem Twojego wyniku.'];

			for(var k in speedCriteria)
			{
				var splitArray:Array = [];
				for(var t in speedCriteria[k])
				{
					splitArray.push(speedCriteria[k][t]);
				}

				if(_score >= splitArray[0] && _score <= splitArray[1])
				{
					return splitArray[2];
				}
			}
			return "";
		}





		//---------------------------------------------------
		private function getCorrectnessCriteriaDescription(_score:Number):String
		{
			var correctnessCriteria:Array = [];
			correctnessCriteria[0] = [-1, 70, 'fatalna, przed Tobą jeszcze sporo pracy. Pamiętaj jednak, że nie od razu Rzym zbudowano.'];
			correctnessCriteria[1] = [70, 80, 'bardzo zła. Chyba zgodzisz się ze mną, że stać Cię na więcej? Pamiętaj, trening czyni mistrza!'];
			correctnessCriteria[2] = [80, 90, 'niedostateczna, musisz jeszcze sporo poćwiczyć. Pamiętaj, bez pracy nie ma kołaczy.'];
			correctnessCriteria[3] = [90, 93, 'mierna. Nie jest wprawdzie tragicznie, ale do doskonałości jeszcze sporo Ci brakuje.'];
			correctnessCriteria[4] = [93, 96, 'dostateczna. Założę się, że nie jest to ocena na miarę Twoich ambicji. Spróbuj poprawić swój wynik.'];
			correctnessCriteria[5] = [96, 98, 'dość dobra, trenuj jednak by „dość” przemienić w „bardzo”.'];
			correctnessCriteria[6] = [98, 99.5, 'bardzo dobra. Już tylko krok dzieli Cię od tytułu Mistrza.'];
			correctnessCriteria[7] = [99.5, 101, 'znakomita. Brawo Mistrzu! Wynik jaki udało Ci się osiągnąć jest doprawdy imponujący.'];

			for(var k in correctnessCriteria)
			{
				var splitArray:Array = [];
				for(var t in correctnessCriteria[k])
				{
					splitArray.push(correctnessCriteria[k][t]);
				}

				if(_score >= splitArray[0] && _score <= splitArray[1])
				{
					return splitArray[2];
				}
			}
			return "";
		}





		//---------------------------------------------------
		private function get_errorMargin():Number
		{
			return Cmd.getScreenModel_().calculateErrorMargin(Cmd.getScreenModel_().get_dataLenght(),Cmd.getScreenModel_().get_errorsInTyping());
		}




		//---------------------------------------------------
		private function get_dynamicErrorRange():Number
		{
			return Cmd.getScreenModel_().calculateDynamicErrorRange(Cmd.getScreenModel_().get_typedAllLetters(),Cmd.getScreenModel_().get_errorsInTyping());
		}





		//---------------------------------------------------
		private function get_progress():Number
		{
			return Cmd.getScreenModel_().calculateProgress(Cmd.getScreenControler().getAllTypedLetters(),Cmd.getScreenModel_().get_dataLenght());
		}






		//---------------------------------------------------
		private function updateTypeSpeed(_typingPerMinute:Number)
		{
			Cmd.getScreenModel_().set_typeSpeedTrsh(Cmd.getScreenModel_().get_typeSpeedTrsh()+1);
			Cmd.getScreenModel_().set_typedAllLetters(Cmd.getScreenModel_().get_typedAllLetters()+1);

			if(Cmd.getScreenModel_().get_typeSpeedTrsh() > Cmd.SPEED_TRSH)
			{

				_typingPerMinute = Cmd.getScreenModel_().calculateTypingSpeedPerMinute(Cmd.getScreenModel_().get_typedAllLetters(),Cmd.getScreenModel_().get_timerCurrentCount());
				Cmd.getDisplayDataControler().get_displayDataView().updateGrossWPM(_typingPerMinute);
				Cmd.getScreenModel_().set_typeSpeedTrsh(0);
				_speedTyping = _typingPerMinute;
				trace("_speedTyping: " + _speedTyping);
			}
		}
	}
}
