package pl.mynetwork.typewriter.event 
{
	import flash.events.Event;
	
	public class DataComplete extends Event
	{
		
		public static const TEST_EVENT:String = "Test"; 
		private var params:Object;
		
		

		public function DataComplete($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		
		

		public override function clone():Event
		{
			return new DataComplete(type, bubbles, cancelable);
		}

	}
	
}
