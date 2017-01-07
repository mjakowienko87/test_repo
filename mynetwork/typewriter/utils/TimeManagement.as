package pl.mynetwork.typewriter.utils
{
	
	public class TimeManagement 
	{
		
		
		
		
		
		//-----------------------------------------------
		public function TimeManagement() 
		{
			// constructor code
		}
		
		
		
		
		//-----------------------------------------------
		 public function timecodeToSeconds(tcStr:String):Number
        {
            var t:Array = tcStr.split(":");
            return (t[0] * 60 + t[1] * 1);
        }

		
		
		
		
		//-----------------------------------------------
        public function secondsToTimecode(seconds:Number):String
        {
            var minutes:Number          = Math.floor(seconds/60);
            var remainingSec:Number     = seconds % 60;
            var remainingMinutes:Number = minutes % 60;
            var hours:Number            = Math.floor(minutes/60);
            var floatSeconds:Number     = Math.floor((remainingSec - Math.floor(remainingSec))*100);
            remainingSec                = Math.floor(remainingSec);

            return getTwoDigits(remainingMinutes) + ":" + getTwoDigits(remainingSec);
        }

		
		
		
		
		//-----------------------------------------------
        private function getTwoDigits(number:Number):String
        {
            if (number < 10)
            {
                return "0" + number;
            }
            else
            {
                return number + "";
            }
        }
	}
}

