package pl.mynetwork.pc.scorm 
{
	import flash.external.ExternalInterface;
	import pl.mynetwork.pc.Tracker;
	import pl.mynetwork.player.CourseStatus;
	import pl.mynetwork.player.TrackerEvent;
	import pl.mynetwork.utils.StringUtils;
	import pl.mynetwork.utils.Utils;
	
	/**
	 * ...
	 * @author mkusiak
	 */
	public class SCORMTracker extends Tracker implements ISCORMTracker
	{
		private var dataModel:SCORMDataModel = new SCORMDataModel();
		private var suspendDataStart:String;
		
		public function SCORMTracker() 
		{
			super();
		}
		
		override public function init():void {
			startTime = _trackTime ? new Date() : null;	
			if (ExternalInterface.available) {
				try{
					ExternalInterface.addCallback("setTrackerData", initData);
				}
				catch (error:Error) {
					
				}
			}	
			callJS('init', '');
		}
		
		override public function setSCORMValue(name:String, value:String):void {
			//if (name == "cmi.suspend_data") refreshSuspendData();
			if (ExternalInterface.available) {
				try{
					ExternalInterface.call("doLMSSetValue", name, value);
					callJS('commit', '');
				}
				catch (error:Error) {
					
				}
			}
		}
		
		override public function setParam(paramName:String, value:String):void {
			setSCORMValue(paramName, value);
		}
		
		private function initData(_data:String):void {
			suspendDataStart = "SD:";
			dataModel = new SCORMDataModel();
			var data:String = StringUtils.normalizeNewline(_data);
			
			dataModel.setStudentId(StringUtils.getProperty(data, "student_id"));
			dataModel.setLessonLocation(StringUtils.getProperty(data, "lesson_location"));
			dataModel.setStatus(StringUtils.getProperty(data, "lesson_status"));
			dataModel.setScore((StringUtils.getProperty(data, "score")));
			dataModel.setSuspendData(StringUtils.getProperty(data, "suspend_data"));
			dataModel.setStudentName(StringUtils.getProperty(data, "student_name"));
			dataModel.setInteractionCount(parseInt(StringUtils.getProperty(data, "interactions_count")));
			if (ExternalInterface.available) {
				try{
					ExternalInterface.addCallback("getSCORMValue", getData);
					ExternalInterface.addCallback("forceClose", onForceClose);
				}
				catch (error:Error) {
					
				}
			}
			setInitLData();
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_INIT, { } ));			
		}
		
		override public function callJS(command:String, args:String):void {
			if (ExternalInterface.available) {
				try {
					ExternalInterface.call("flashCall", command, args);
				}
				catch (error:Error) {
					
				}
			}
		}
		
		
		
		override public function putParams():void {
			refreshSuspendData();
			callJS("commit", "");
		}
		
		override public function getData(name):String {
			switch(name) {
				case 'suspend_data':
					refreshSuspendData();
					return dataModel.getSuspendData();
				case 'lesson_status':
					return dataModel.getStatus();
				case 'score':
					return dataModel.getScore();
				case 'lesson_location':
					return dataModel.getLessonLocation();
				case 'student_id':
					return dataModel.getStudentId();
				case 'student_name':
					return dataModel.getStudentName();	
				case 'time':
					return getFormattedTime();
				default:
					return '';
			}
		}
		
		override public function getCustomData(name:String):String {
			if (ExternalInterface.available) {
				try{
					return ExternalInterface.call("doLMSGetValue", name);
				}
				catch (error:Error) {
					
				}
			}
			return "";
		}
		
		override public function setLessonLocation(location:String):void {
			dataModel.setLessonLocation(location);
		}
		
		override public function getLessonLocation():String {
			return dataModel.getLessonLocation();
		}		
		
		override public function refreshSuspendData():void {
			var tempSuspend:String = suspendDataStart;
			for (var i = 0; i < lessonDataDictionary.length; i++) {
				tempSuspend += lessonDataDictionary[i] + '::' + Utils.serialize(lessonData[lessonDataDictionary[i]]) + '::';
			}
			dataModel.setSuspendData(tempSuspend);
		}
		
		private function setInitLData():void {
			var data:String = dataModel.getSuspendData();
			if(data != null){
				data = data.slice(data.indexOf(suspendDataStart) + suspendDataStart.length , data.length);
				var pattern:RegExp = /::/g;
				var objCount:Array = data.match(pattern);
				for (var i = 0; i < objCount.length; i++) {
					var name:String = data.slice(0, data.indexOf("::"));
					var startInd:uint = data.indexOf("::")+2;
					var endInd:uint = data.indexOf("::", startInd);
					var object:Object = Utils.deserialize(data.slice(startInd, endInd));
					setLessonData(name, object);
					data = data.slice(endInd + 2, data.length);
				}
			}
		}
		
		override public function setScore(score:Number):void {
			dataModel.setScore(String(score));
		}
		
		override public function setStatus(status:String):void {
			dataModel.setStatus(status);
		}
		
		override public function finish():void {
			callJS("finish", "");
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_FINISH, { } ));
		}
		
		//override public function closeLesson():void {
			////callJS('commit', '');
			//finish();
		//}		
		
		override public function setTime(time_:Number):void {
			_trackTime = false; 
			dataModel.setTime(time_);
		}
		
		override public function getTime():Number {
			return _trackTime ? trackTime() : dataModel.getTime();
		}
		
		private function getFormattedTime():String {
			var time:Number = getTime();
			var jsTime:String = null;
			
			if (time && time > 0) {
				//jsTime = trackingVersion == TrackingStandardEnum.SCORM_2004 
				//	   ? ScormDataUtils.writeTimeinterval(time) 
				//	   : StringUtils.writeDuration(time);
				jsTime = StringUtils.writeDuration(time);
			}
			
			return jsTime;  
		}		
	}
}