package pl.mynetwork.pc.restricted 
{
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import pl.mynetwork.pc.Tracker;
	import pl.mynetwork.player.Cmd;
	import pl.mynetwork.player.Cmd;
	import pl.mynetwork.player.PlayerConst;
	import pl.mynetwork.utils.Utils;
	
	//dla pekao wysyłamy tylko wynik, status i zapisujemy lokację do cookies
	//wszystko jest do przeniesienia ze starego trackera i będziemy używać tych samych plików.
	
	
	
	/**
	 * ...
	 * @author k.stano
	 */
	public class RestrictedTracker extends Tracker
	{
		

		
		/** Represents LocalSharedObject */
		private var so:SharedObject = null; 		
		
		private var dataModel:RestrictedDataModel = new RestrictedDataModel();
		
		public function RestrictedTracker() 
		{
			super();
		}
		
		override public function init():void {
			initCookie();
			dataModel.setCourseId(Cmd.getConfigParam(PlayerConst.PARAM_AICC_COURSE_ID));
			dataModel.setLessonId(Cmd.getConfigParam(PlayerConst.PARAM_LESSON_NUMBER));		
			trace("dataModel",dataModel.getCourseId(), dataModel.getLessonId());
			//dataModel.setLocation(getCookie());
		}
		
		override public function getData(name):String {
			switch(name) {
				case 'suspend_data':
					return ""
				case 'lesson_status':
					return dataModel.getStatus();
				case 'score':
					return dataModel.getScore();
				case 'lesson_location':
					return dataModel.getLocation();
				default:
					return '';
			}
		}		
		
		/**
		 * Zwraca odpowiednie stringi oraz ustawia badz kasuje ciasteczka flashowe
		 * Jezeli jest score zwraca numer, jezeli nie ma zwraca napis odpowiadajacy statusowi
		 */
		private function getHtmlString(score_:String, status_:String):String {
			var result:String = "";
			clearCookie()
			if (score_ != "null") {
				result = score_;
				clearAllCookies();
			} else {
				switch(status_){
					case RestrictedDataModel.STATUS_SCORM_COMPLETED:
						result = RestrictedDataModel.RESTRICTED_STATUS_COMPLETED;
						break;
				
					case RestrictedDataModel.STATUS_SCORM_FAILED:
						result = RestrictedDataModel.RESTRICTED_STATUS_FAILED;
						break;
				
					case RestrictedDataModel.STATUS_SCORM_INCOMPLETE:
						result = RestrictedDataModel.RESTRICTED_STATUS_INCOMPLETE;
						setCookie();
						break;
				
					case RestrictedDataModel.STATUS_SCORM_PASSED:
						result = RestrictedDataModel.RESTRICTED_STATUS_PASSED;
						break;
				
					default:
						result = RestrictedDataModel.RESTRICTED_STATUS_INCOMPLETE;
						break;
				}
			}
			return result;
		}
			
				
		override public function closeLesson():void {
			trace("closeLesson");
			getURL('score/' + getHtmlString(dataModel.getScore().toString(), dataModel.getStatus()) + '.html', '_self');
		}
		
	 
		override public function setScore(score:Number):void {
			super.setScore(score);
			trace("score.toString()", score.toString());
			if (score.toString() != "null") {
				getURL('mnscore/' + getHtmlString(score.toString(), "") + '.html', RestrictedDataModel.FRAME_ID);
			}
		} 
		
		override public function setStatus(lessonStatus_:String):void {
			super.setStatus(lessonStatus_);

			if(lessonStatus_ != null) {    
				getURL('mnscore/' + getHtmlString("null", lessonStatus_) + '.html', RestrictedDataModel.FRAME_ID);
			}
		}
		private function initCookie():void {
			if (so == null) {
				so = SharedObject.getLocal(RestrictedDataModel.COOKIE_ID);
			}
		}
		
		private function getCookie():String {
			var lessonID:String = dataModel.getCourseId() + dataModel.getLessonId();
			return so.data[lessonID].lessonLocation;
		}
		
		private function setCookie():void {
			var lessonID:String = dataModel.getCourseId() + dataModel.getLessonId();
			so.data[lessonID] = {};
			so.data[lessonID].lessonLocation = dataModel.getLocation();
			so.flush();
		}
		
		private function clearCookie():void {
			var lessonID:String = dataModel.getCourseId() + dataModel.getLessonId();
			so.data[lessonID] = {};
			so.flush();
		}
		
		private function clearAllCookies():void {
			var courseId:String = dataModel.getCourseId();
			var currentLessonId:Number = Number(dataModel.getLessonId());
			if(!isNaN(currentLessonId)) {
				for (var i:int = 1; i <= currentLessonId; i++) {
					so.data[courseId+i] = {};
				}
				so.flush();
			}	
		}
		
		private function getURL(url:String, target:String = "_blank"):void {
			trace("getURL", url, target);
			var request:URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, target);
			} catch (e:Error) {
				trace("Error occurred!");
			}			
		}
		
		override public function putParams():void {
			callJS("commit", "");
		}		
		
		override public function finish():void {
			callJS("finish", "");
		}		
		
	}

}


    
    /*public function RestrictedTracker(trackerProps_:TrackerProps, tempMovie_:MovieClip, trackerOptions_:TrackerOptions,
                                   consoleLogger_:ConsoleLogger) {
        super(trackerProps_, tempMovie_, trackerOptions_, consoleLogger_);
        doLog("Restricted Tracker");
        doTrace("Restricted Tracker");
    }
    
    public function init(params_:Object, callback_:Function):void {
        setStudentId(params_.sId); //TODO: brak implementacji w PlayerSetup 
        setStudentName(params_.sN); //TODO: brak implementacji w PlayerSetup
        setCourseId(params_.getCourseId());
        setLessonId(params_.getLessonId());
        initCookie();
        //weź dane z flash cookie
        setLessonLocation(getCookie());
        super.init(params_, callback_);
    }*/
    
 