package pl.mynetwork.typewriter.controller
{




	//-----------------------------------------------
	import flash.display.MovieClip;
	import pl.mynetwork.typewriter.Cmd;






	//-----------------------------------------------
	public class HeaderController extends MovieClip
	{





		//-----------------------------------------------
		public function HeaderController()
		{
			// constructor code
		}





		//-----------------------------------------------
		public function _initHeader()
		{

			Cmd.APP_MAIN_CONTAINER.addChild(this);
			this.x 						= 0;
			this.y 						= 0;
		}






		//-----------------------------------------------
		public function updateData(_title:String, _smallTitle:String):void
		{
			lessonTitleTF.text 			= "" + _title;
			smallTitleTF.text 			= "" + _smallTitle;

		}
	}
}
