package pl.mynetwork.pc.data 
{
	import pl.mynetwork.player.CourseStatus;
	/**
	 * ...
	 * @author k.stano
	 */
	public class BaseDataModel 
	{
		
		public static var additionalParam:Array;
		protected var interactionCount:uint;
		
		//dane z platformy
		protected var courseId:String;
		protected var lessonId:String;
		protected var studentId:String;
		protected var studentName:String;	
		protected var coreLesson:String;
		
		//dane ustawiane przez kurs
		protected var score:String;
		protected var status:String;
		protected var time:Number;
		protected var location:String;
		protected var suspendData:String;		
		
		public function BaseDataModel() 
		{
			score = "";
			status = CourseStatus.NOT_ATTEMPTED;
			time = 0;
			location = "";
			suspendData = "";
			additionalParam = new Array();
		}
		
		public function setScore(scoreIn:String):void {
			score = scoreIn;
		}
		
		public function getScore():String {
			return score;
		}
		
		public function setStatus(statusIn:String):void {
			var outputStatus:String = "";
			statusIn = statusIn.toLowerCase().charAt(0);
			switch(statusIn) {
				case "n":
					status = CourseStatus.NOT_ATTEMPTED;
					break;
				case "i":
					status = CourseStatus.INCOMPLETE;
					break;
				case "c":
					status = CourseStatus.COMPLETED;
					break;
				case "f":
					status = CourseStatus.FAILED;
					break;
				case "p":
					status = CourseStatus.PASSED;
					break;
				case "b":
					status = CourseStatus.BROWSED;
					break;
				default:
					break;
			}			
		}
		
		public function getStatus():String {
			return status;
		}
		
		public function setLessonLocation(location:String):void {
			this.location = location;
		}
		
		public function getLessonLocation():String {
			return location;
		}
		
		public function setSuspendData(suspendIn:String):void {
			suspendData = suspendIn;
		}
		
		public function getSuspendData():String {
			return suspendData;
		}
		
		public function setCoreLesson(coreLesson_:String):void {
			coreLesson = coreLesson_;
		}
		public function getCoreLesson():String {
			return coreLesson != null ? coreLesson : "";
		}		
		
		public function setAdditionalParam(name:String, value:String):void {
			additionalParam[name] = value;
		}
		
		public function getAdditionalParamArr():Array {
			return additionalParam;
		}
		
		public function setCourseId(courseIdIn:String):void {
			courseId = courseIdIn;
		}
		
		public function setLessonId(lessonIdIn:String):void {
			lessonId = lessonIdIn;
		}
		
		public function setStudentId(studentIdIn:String):void {
			studentId = studentIdIn;
		}
		
		public function setStudentName(studentNameIn:String):void {
			studentName = studentNameIn;
		}
		
		public function getCourseId():String {
			return courseId;
		}
		
		public function getLessonId():String {
			return lessonId;
		}
		
		public function getStudentId():String {
			return studentId;
		}
		
		public function getStudentName():String {
			return studentName;
		}
		
		public function setInteractionCount(value:uint):void {
			interactionCount = value;
		}
		
		public function getInteractionCount():uint {
			return interactionCount;
		}	
		
		public function setTime(time_:Number):void {
			time = time_;
		}
		public function getTime():Number {
			return time; //!= undefined ? time : null;
		}		
	}

}