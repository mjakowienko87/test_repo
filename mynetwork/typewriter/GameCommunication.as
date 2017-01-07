package pl.mynetwork.typewriter
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import pl.mynetwork.typewriter.events.ComEvent;
	import pl.mynetwork.player.CourseStatus;
	import pl.mynetwork.player.ITracker;
	import pl.mynetwork.player.TrackerEvent;
	

	public class GameCommunication extends EventDispatcher 
	{
		
		
		
		
		//-----------------------------------------------
		private var _tracker:ITracker;
		
		
		
		
		
		//-----------------------------------------------
		public function GameCommunication(tracker:ITracker,target:IEventDispatcher=null) 
		{
			super(target);
			_tracker = tracker;
		}
		
		
		
		
		
		//-----------------------------------------------
		public function init():void {
			_tracker.addEventListener(TrackerEvent.TRACKER_INIT, onInitTracker);
			_tracker.init();			
		}
		
		
		
		
		
		//-----------------------------------------------
		private function onInitTracker(event:TrackerEvent):void 
		{
			_tracker.removeEventListener(TrackerEvent.TRACKER_INIT, onInitTracker);
			_tracker.addEventListener(TrackerEvent.TRACKER_FORCE_CLOSE, onForceClose);
			
			if (_tracker.getData("lesson_status") == CourseStatus.NOT_ATTEMPTED || _tracker.getData("lesson_status") == CourseStatus.BROWSED) 
			{
				_tracker.setStatus(CourseStatus.INCOMPLETE);
			}
			_tracker.putParams();		
			dispatchEvent(new ComEvent(ComEvent.INIT, { } ));
		}
		
		
		
		
		
		//-----------------------------------------------
		private function onForceClose(event:TrackerEvent):void 
		{
			
		}
		
		
		
		
		
		//-----------------------------------------------
		public function getData(name:String):String 
		{
			return String(_tracker.getLessonData(name));
		}
		
		
		
		
		
		//-----------------------------------------------
		public function getNumericData(name:String):Number 
		{
			return Number(_tracker.getLessonData(name));
		}
		
		
		
		
		
		//-----------------------------------------------
		public function setData(name:String, value:String):void 
		{
			_tracker.setLessonData(name, value);
		}
		
		
		
		
		
		//-----------------------------------------------
		public function setNumericData(name:String, value:Number):void
		{
			_tracker.setLessonData(name, value);
		}
		
		
		
		
		
		//-----------------------------------------------
		public function saveData():void 
		{
			_tracker.putParams();
		}
		
		
		
		
		
		//-----------------------------------------------
		public function setCourseStatus(status:String):void 
		{
			_tracker.setStatus(status);
		}
		
		
		
		
		
		//-----------------------------------------------
		public function setCourseScore(score:Number):void 
		{
			//trace("// ---------------- SET COURSE SCORE -------------// "  + score);
			_tracker.setScore(score);
		}
	}

}