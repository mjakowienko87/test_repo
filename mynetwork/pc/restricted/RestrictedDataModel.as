package  pl.mynetwork.pc.restricted 
{
	/**
	 * ...
	 * @author k.stano
	 */
	public class RestrictedDataModel 
	{
		
		public static const STATUS_SCORM_NOT_ATTEMPTED:String = "N";
		public static const STATUS_SCORM_INCOMPLETE:String = "I";
		public static const STATUS_SCORM_COMPLETED:String = "C";
		public static const STATUS_SCORM_FAILED:String = "F";
		public static const STATUS_SCORM_PASSED:String = "P";
		public static const STATUS_SCORM_BROWSED:String = "B";	
		
		/** Representation of html files statuses */
		public static const RESTRICTED_STATUS_COMPLETED:String = 'completed';
		public static const RESTRICTED_STATUS_INCOMPLETE:String = 'incomplete';
		public static const RESTRICTED_STATUS_PASSED:String = 'passed';
		public static const RESTRICTED_STATUS_FAILED:String = 'failed';
		
		/** Represents LocalSharedObject instance name */
		public static const COOKIE_ID:String = 'mnData';
		
		/** Represents html frame name */
		public static const FRAME_ID:String = 'reciever';   		
		
		private var _courseId:String;
		private var _lessonId:String;
		
		private var score:String = "null";
		private var status:String;
		private var time:Number;
		private var location:String;
		private var suspendData:String;		
		
		public function RestrictedDataModel() 
		{
			
		}
		
		public function setScore(scoreIn:String):void {
			score = scoreIn;
		}
		
		public function getScore():String {
			return score;
		}
		
		public function setStatus(statusIn:String):void {
			status = statusIn;
		}
		
		public function getStatus():String {
			return status;
		}
		
		public function setLocation(locationIn:String):void {
			location = locationIn;
		}
		
		public function getLocation():String {
			return location;
		}
		
		public function setSuspendData(suspendIn:String):void {
			suspendData = suspendIn;
		}
		
		public function getSuspendData():String {
			return suspendData;
		}		
		
		public function setCourseId(id:String):void {
			_courseId = id;
		}
		
		public function setLessonId(id:String):void {
			_lessonId = id;
		}	
		
		public function getCourseId():String {
			return _courseId;
		}
		
		public function getLessonId():String {
			return _lessonId;
		}			
	}

}