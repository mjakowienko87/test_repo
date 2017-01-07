package pl.mynetwork.typewriter.events
{
	import flash.events.Event;
	

	public class ComEvent extends Event 
	{
		
		
		
		
		//-----------------------------------------------
		public static const INIT:String = "communicationInit";
		public static const FAIL:String = "communicationFail";
		
		
		
		
		
		//-----------------------------------------------
		public var params:Object;
		
		
		
		
		
		//-----------------------------------------------
		public function ComEvent($type:String, $params:Object, $bubbles:Boolean = false, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
            this.params = $params;
		}
		
		
		
		
		
		//-----------------------------------------------
		public override function clone():Event
        {
            return new ComEvent(type, this.params, bubbles, cancelable);
        }
       
		
		
		
		
		//-----------------------------------------------
        public override function toString():String
        {
            return formatToString("ComEvent", "params", "type", "bubbles", "cancelable");
        }
		
	}

}

