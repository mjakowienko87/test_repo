package pl.mynetwork.typewriter.Sound
{




	//---------------------------------------------------
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getDefinitionByName;






	//---------------------------------------------------
	public class SoundManager
	{



		//---------------------------------------------------
		private var soundArray:Array = [];





		//---------------------------------------------------
		private var appSoundChannel:SoundChannel;







		//---------------------------------------------------
		public function SoundManager()
		{
			// constructor code
		}




		//---------------------------------------------------
		public function setupSound()
		{
			appSoundChannel = new SoundChannel();
			parseSound(4);
		}





		//---------------------------------------------------
		private function parseSound(_iterations:Number)
		{
			for(var i:Number = 0; i < _iterations; i++)
			{
				var soundReference:Class = getDefinitionByName("sound_" + (i+1)) as Class;
				var _sound:Sound = new soundReference();
				soundArray[i] = _sound;
			}
		}




		//---------------------------------------------------
		public function playSound(_id:Number)
		{
			appSoundChannel = soundArray[_id].play();
		}





		//---------------------------------------------------
		public function getSoundArray():Array
		{
			return soundArray;
		}
	}
}
