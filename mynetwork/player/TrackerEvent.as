package pl.mynetwork.player
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author mkusiak
	 */
	public class TrackerEvent extends Event 
	{
		public static const TRACKER_INIT:String = "trackerInit";
		public static const TRACKER_UPDATE:String = "trackerUpdate";
		public static const TRACKER_FINISH:String = "trackerFinish";
		public static const TRACKER_FORCE_CLOSE:String = "trackerForceClose";
		
		public var params:Object;
		
		public function TrackerEvent($type:String, $params:Object, $bubbles:Boolean = false, $cancelable:Boolean = false) 
		{
			super($type, $bubbles, $cancelable);
            this.params = $params;
		}
		
		public override function clone():Event
        {
            return new TrackerEvent(type, this.params, bubbles, cancelable);
        }
       
        public override function toString():String
        {
            return formatToString("TrackerEvent", "params", "type", "bubbles", "cancelable");
        }
		
	}

}

