package pl.mynetwork.typewriter.models
{
	import flash.display.MovieClip;
	import pl.mynetwork.typewriter.Cmd;





	public class DisplayDataModel extends MovieClip
	{



		private var _displayType:String;




		//---------------------------------------------------
		public function DisplayDataModel()
		{
			// constructor code
		}




		//---------------------------------------------------
		public function setBorder(_state:Boolean):void
		{
			dTxt.border = _state;
		}




		//---------------------------------------------------
		public function updateDisplayModel(_data:Number):void
		{
			switch (_displayType)
			{
				case "PROGRESS":
					this.dTxt.htmlText = '<font color="#FFFFFF">' + "Ukończono: " + '</font>' + _data + "%";
					lineContainer.width = Cmd.getUtils().returnLenghtPercentage(100,_data,27);
					break;
				case "ERROR":
					this.dTxt.htmlText = '<font color="#0099FF">' + "Błędy: " + '</font>' + Math.round(_data);
					this.lineContainer.width = 0;
					break;
				case "DYNAMIC_ERROR":
					this.dTxt.htmlText = '<font color="#0099FF">' + "Bezbłędność: " + '</font>' + (100-Math.round(_data)) + "%";
					this.lineContainer.width = 0;
					break;
				case "SPEED":
					this.dTxt.htmlText = '<font color="#0099FF">' + "Szybkość zn./min.: "+ '</font>' + _data;
					this.lineContainer.width = 0;
					break;
			}

		}





		//---------------------------------------------------
		public function updateTimer(_time:String):void
		{
			this.dTxt.htmlText = '<font color="#0099FF">' + "Czas: " + '</font>' + _time;
			this.lineContainer.width = 0;
		}





		//---------------------------------------------------
		public function setType(_type:String):void
		{
			_displayType = _type;

		}




		//---------------------------------------------------
		public function get_Type():String
		{
			return _displayType;
		}
	}

}
