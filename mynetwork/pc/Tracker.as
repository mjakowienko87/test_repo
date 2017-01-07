package pl.mynetwork.pc 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import pl.mynetwork.player.ITracker;
	import pl.mynetwork.player.TrackerEvent;
	
	/**
	 * ...
	 * @author mkusiak
	 */
	public class Tracker extends EventDispatcher implements ITracker
	{
		protected var startTime:Date;
		protected var lessonData:Array;
		protected var lessonDataDictionary:Array;
		protected var _trackTime:Boolean = true;
		
		
		public function Tracker() 
		{
			lessonData = new Array();
			lessonDataDictionary = new Array();
			//init();
			startTime = _trackTime ? new Date() : null;	
		}
		
		public function init():void {
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_INIT, { } ));
		}
		
		public function onForceClose():void {
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_FORCE_CLOSE, { } ));
		}
		
		public function putParams():void {
			
		}
		
		public function setScore(score:Number):void {
			trace("score", score);
		}
		
		public function setStatus(status:String):void {
			
		}
		
		public function setParam(paramName:String, value:String):void {
			
		}
		
		public function finish():void {
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_FINISH, { } ));
		}	
		
		public function showJSAlert(text:String):void {
			if (ExternalInterface.available) {
				try{
					ExternalInterface.call("alert", text);
				}catch (error:Error) {
					
				}
			}
		}
		
		public function setLessonData(name:String, value:Object):void {
			if(lessonDataDictionary.indexOf(name) == -1) lessonDataDictionary.push(name);
			lessonData[name] = value;
		}
		
		public function getLessonData(name:String):Object {
			return lessonData[name];
		}
		
		public function clearLessonData(name:String = ""):void {
			if (name == "") {
				lessonDataDictionary = [];
				lessonData = [];
			} else {
				var index:int = lessonDataDictionary.indexOf(name);
				if (index > -1) {
					lessonDataDictionary.splice(index, 1);
					delete lessonData[name];
				}
			}
		}		
		
		public function setLessonLocation(location:String):void {
			
		}
		
		public function getLessonLocation():String {
			return "";
		}
		
		public function getCustomData(name:String):String {
			return "";
		}
		
		public function closeLesson():void {
			
		}		
		
		public function setCoreLesson(coreLesson_:String):void {
			//dataModel.setCoreLesson(coreLesson_);
		}
		
		public function getCoreLesson():String {
			return ""//dataModel.getCoreLesson();
		}		
		
		public function setTime(time_:Number):void {
			//_trackTime = false; 
			//dataModel.setTime(time_);
		}
		
		public function getTime():Number {
			return _trackTime ? trackTime() : 0;//dataModel.getTime();
		}		
		
		/**
		 * Wewnetrzny pomiar czasu.
		 *
		 * @return ilosc sekund od uruchomienia trackera.
		 */
		public function trackTime():Number {
			return Math.floor(((new Date()).getTime() - startTime.getTime()) / 1000);
		}		
		
		//SCORM1.2
		public function setSCORMValue(name:String, value:String):void{}
		public function callJS(command:String, args:String):void{}
		public function getData(name):String{return "";}
		public function refreshSuspendData():void { }
		
	}
}