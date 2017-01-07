package pl.mynetwork.pc.aicc 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import pl.mynetwork.pc.Tracker;
	import pl.mynetwork.player.Cmd;
	import pl.mynetwork.player.CourseStatus;
	import pl.mynetwork.player.PlayerConst;
	import pl.mynetwork.player.TrackerEvent;
	import pl.mynetwork.utils.StringUtils;
	
	
	public class AICCTracker extends Tracker implements IHandlerCallbackTarget {

		private var dataModel:AICCDataModel = new AICCDataModel();
		
		/**
		 * Czy komunikacja zakonczona
		 */
		private var ready:Boolean;
		  
		/**
		 * Handler komunikacji
		 */
		private var handler:Handler;

		//
		// Callbacki komunikacji
		//
		private var getParamsCallback:Function;
		private var putParamsCallback:Function;
		private var putInteractionsCallback:Function;
		private var exitAuCallback:Function;
		private var getExtendedStudentIdCallback:Function;
		
		private var trackerInitted:Boolean = false;
		
		/**
		 * Callback na zamkniecie lekcji
		 */
		private var onCloseCallback:Function;
		 
		/**
		 * Konstruktor
		 *
		 */
		function AICCTracker() {
			super();
			trace("AICCTracker");
		 }
		 
		/**
		 * Inicjalizacja
		 * 
		 */
		override public function init():void {
			startTime = _trackTime ? new Date() : null;	
			
			var courseId:String = Cmd.getConfigParam(PlayerConst.PARAM_AICC_COURSE_ID);
			var lessonId:String = Cmd.getConfigParam(PlayerConst.PARAM_AICC_LESSON_ID);
			var sessionId:String = Cmd.getConfigParam(PlayerConst.PARAM_AICC_SESSION_ID);
			var aiccUrl:String = Cmd.getConfigParam(PlayerConst.PARAM_AICC_URL);
			var password:String = Cmd.getConfigParam(PlayerConst.PARAM_AICC_PASSWORD);
			
			if (lessonId != null) {
				dataModel.setLessonId(lessonId);
			}
			if (courseId != null) {
				dataModel.setCourseId(courseId);
			}
			
			handler = new HttpHandler();
			HttpHandler(handler).init(sessionId, aiccUrl, password);
			//
			handler.addTarget(this);
			//
			
			getParams();
			//if (p_test) {
				//testLmsConnection(aiccUrl);
			//}
			
			//if (callback_ != null) {
				//callback_.call(null, Tracker.NO_ERRORS);
			//}
		}	 
		
		/**
		 * Sprawdza mozliwosc polaczenia sie z LMS podanym w AICC_URL
		 * 
		 * @param aiccUrl_ url komunikacyjny z platformy
		 */
		private function testLmsConnection(aiccUrl_:String):void {
			var url:String = "http://" + StringUtils.extractHost(aiccUrl_) + "/crossdomain.xml";
			var scriptRequest:URLRequest = new URLRequest(url);
			var scriptLoader:URLLoader = new URLLoader();
			var scriptVars:URLVariables = new URLVariables();
			 
			scriptLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			scriptLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			
			   
			scriptRequest.method = URLRequestMethod.GET;
			scriptRequest.data = scriptVars;
			 
			scriptLoader.load(scriptRequest);			
		}
		
		private function handleLoadSuccessful($evt:Event):void {
		    trace("Message sent.", URLLoader($evt.target).data);
		}
		 
		private function handleLoadError($evt:IOErrorEvent):void {
		    trace("Message failed.");
		}		
		  
		
		override public function finish():void {
			exitAu();
		}		
		
		//override public function closeLesson():void {
			//finish();
		//}		
		
		override public function setLessonLocation(location:String):void {
			dataModel.setLessonLocation(location);
		}
		
		override public function getLessonLocation():String {
			return dataModel.getLessonLocation();
		}
		
		override public function setCoreLesson(coreLesson_:String):void {
			dataModel.setCoreLesson(coreLesson_);
		}
		
		override public function getCoreLesson():String {
			return dataModel.getCoreLesson();
		}		
		
		override public function setTime(time_:Number):void {
			_trackTime = false; 
			dataModel.setTime(time_);
		}
		
		override public function getTime():Number {
			return _trackTime ? trackTime() : dataModel.getTime();
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
				default:
					return '';
			}
		}		
		
		override public function setScore(score:Number):void {
			dataModel.setScore(String(score));
		}
		
		override public function setStatus(status:String):void {
			dataModel.setStatus(status);
		}		
		 

		protected function getParams():void {
			ready = false;
			handler.getParams();
		}

		override public function putParams():void {
			ready = false;
			var tmp:String = write();
			handler.putParams(tmp);
		}
		  
		 /**
		  * exitauexitau
		  * 
		  * @param callback_ callback komunikacji
		  */
		  public function exitAu():void {
			ready = false;
			handler.exitAu();
		  }
		
		/**
		 * Metoda pobiera "rozszerzone id studenta" (tylko na platformie LMS MyLearning)
		 * Wartość jest zwracana w funkcji "callBack_" jak argument w postaci stringa
		 * 
		 * @param callBack_ funkcja wywoływana po pobraniu danych
		 */
		//public function getExtendedStudentId(callBack_:Function):void {
			//trace("AICC Tracker.getExtendedStudentId");
			//
			//if (getTrackerOptions().getLmsType() == TrackerOptions.LMS_MYLEARNING) {
				//ready = false;
				//getExtendedStudentIdCallback = callBack_;
				//handler.getExtendedStudentId();
			//} else {
				//super.getExtendedStudentId(callBack_);
			//}
		//}
		  
		  //
		  // Handlery
		  //
		  
		/**
		 * Callback getparam
		 * 
		 * @param success_ wartosc logiczna informujaca o powodzeniu getparam
		 * @param result_ dane komunikatu
		 */
		public function onGetParams(success_:Boolean, result_:String):void {
			trace("AICC Tracker.onGetParam : " + success_ + ", " + result_);
			ready = true;
			if (success_) {
				parse(result_);
				dataModel.setStudentId(getData("student_id"));
				//dataModel.setStudentId(StringUtils.getBlock(result_, "student_id")); //sprawdzić, czy dobrze
				
				setCoreLesson(StringUtils.getBlock(result_, "core_lesson"));
				if (getCoreLesson() != null) {
					trace("getCoreLesson()", getCoreLesson());
					setCoreLesson(StringUtils.trim(getCoreLesson()));
				}
				

				// Saba begin
				var tmp:String = StringUtils.getBlock(result_, "evaluation");
				if (tmp != null) {
					dataModel.setCourseId(StringUtils.getProperty(tmp, "course_id"));
				}
				// Saba end
			}
			//if (getParamsCallback != null) {
				//getParamsCallback.call(null, success_);
			//}
			if (!trackerInitted) {
				trackerInitted = true;
				dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_INIT, { } ));
			}
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_UPDATE, { } ));
		}
		  
		/**
		 * Callback putparam
		 * 
		 * @param success_ wartosc logiczna informujaca o powodzeniu getparam
		 * @param result_ dane komunikatu
		 */
		public function onPutParams(success_:Boolean, result_:String):void {
			trace("AICC Tracker.onPutParam : " + success_ + ", " + result_);
			
			ready = true;
			//if (putParamsCallback != null) {
				//putParamsCallback.call(null, success_);
			//}
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_UPDATE, { } ));
			//tylko dla testu!!!!!!!!!!!!!
			getParams();			
		}
		 
		/**
		 * Callback putinteraction
		 * 
		 * @param success_ wartosc logiczna informujaca o powodzeniu getparam
		 * @param result_ dane komunikatu
		 */
		public function onPutInteractions(success_:Boolean, result_:String):void {
			trace("AICC Tracker.onPutInteractions : " + success_ + ", " + result_);
			
			ready = true;
			//if (putInteractionsCallback != null) {
				//putInteractionsCallback.call(null, success_);
			//}
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_UPDATE, { } ));
		}
		  
		  /**
		   * Callback exitau
		   * 
		   * @param success_ wartosc logiczna informujaca o powodzeniu getparam
		   * @param result_ dane komunikatu
		   */
		public function onExitAu(success_:Boolean, result_:String):void {
			trace("AICC Tracker.onExitAu : " + success_ + ", " + result_);
			
			ready = true;
			//if (exitAuCallback != null) {
				//exitAuCallback.call(null, success_);
			//}
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_FINISH, { } ));
		}
		
		/**
		 * Callback na getExtendedStudentId.
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		public function onGetExtendedStudentId(success_:Boolean, result_:String):void {
			trace("AICC Tracker.onGetExtendedStudentId : " + success_ + ", " + result_);
			
			ready = true;
			//if (getExtendedStudentIdCallback != null) {
				//var v_extendedStudentId:String = StringUtils.getBlock(result_, "Mn.student_id");
				//getExtendedStudentIdCallback.call(null, v_extendedStudentId);
			//}
			dispatchEvent(new TrackerEvent(TrackerEvent.TRACKER_UPDATE, { } ));
		}
		 

		//
		// Metody pomocnicze
		//

		/**
		* Parsowanie komunikatu AICC
		* 
		* @param data_ dane komunikatu
		*/
		private function parse(data_:String):void {
			var core:String = StringUtils.getBlock(data_, "core");
			
			if (core != null) {
				var value:String;
				
				value = StringUtils.getProperty(core, "score");
				if (value != null) {
					setScore(parseFloat(value));
				}
				value = StringUtils.getProperty(core, "lesson_status");
				if (value != null) {
					var statusValue = value.substring(0, 1).toUpperCase();
					if (statusValue == CourseStatus.NOT_ATTEMPTED.substring(0, 1).toUpperCase()
						|| statusValue == CourseStatus.INCOMPLETE.substring(0, 1).toUpperCase()
						|| statusValue == CourseStatus.COMPLETED.substring(0, 1).toUpperCase()
						|| statusValue == CourseStatus.FAILED.substring(0, 1).toUpperCase()
						|| statusValue == CourseStatus.PASSED.substring(0, 1).toUpperCase()
						|| statusValue == CourseStatus.BROWSED.substring(0, 1).toUpperCase()) {
							setStatus(statusValue);
					}
				}
			}
			setLessonLocation(StringUtils.getProperty(core, "lesson_location"));
			//dataModel.setTime(StringUtils.parseTime(StringUtils.getProperty(core, "time")));
			dataModel.setStudentId(StringUtils.getProperty(core, "student_id"));
			dataModel.setStudentName(StringUtils.getProperty(core, "student_name"));
		}
			
		/**
		* Wypisywanie komunikatu AICC
		* 
		* @return dane komunikatu
		*/
		private function write():String {
			var result:String = "[core]" + StringUtils.CRLF;
			
			result += "lesson_status=" + dataModel.getStatus() 
						+ (StringUtils.isEmptyOrNull(getCoreLesson()) ? "": ",S") + StringUtils.CRLF;
			result += "score=" + (isNaN(parseFloat(getData("score"))) ? "" : getData("score").toString()) + StringUtils.CRLF;
			result += "lesson_location=" 
						+ (StringUtils.isEmptyOrNull(getLessonLocation()) ? "" : getLessonLocation()) 
						+ StringUtils.CRLF;
			result += "time=" + StringUtils.writeDuration(getTime() ? getTime() : 0) + StringUtils.CRLF;
			//if (!StringUtils.isEmptyOrNull(getCoreLesson())) {
				result += "[core_lesson]" + StringUtils.CRLF + getCoreLesson() + StringUtils.CRLF;
			//}
			return result;
		}			
	}	 
}