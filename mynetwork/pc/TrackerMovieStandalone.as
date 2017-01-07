package pl.mynetwork.pc 
{
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import pl.mynetwork.player.ITracker;
	//import pl.mynetwork.pc.aicc.AICCTracker;
	import pl.mynetwork.pc.scorm.SCORMTracker;
	//import pl.mynetwork.pc.scorm2004.SCORM2004Tracker;	
	//import pl.mynetwork.pc.restricted.RestrictedTracker;	
	//import pl.mynetwork.player.modules.gui.elements.IGUIElement;
	//import pl.mynetwork.xmlParsers.IData;
	/**
	 * ...
	 * @author k.stano
	 */
	public class TrackerMovieStandalone extends MovieClip implements ITrackerMovieStandalone
	{

		private var mode:uint;
		private var tracker:Tracker;
		
		public function TrackerMovieStandalone() 
		{
			super();
			Security.allowDomain("*");
			setMode();
			initTracker();
		}
		
		private function setMode():void {
			if (ExternalInterface.available) {
				try {
					mode = ExternalInterface.call("get_mode");
				}
				catch (error:Error){
					
				}
			}
		}
		
		public function getMode():uint {
			return mode;
		}
		
		private function initTracker():void {
			//trace("initTracker", mode);
			switch (mode) {
				case TrackerConstants.OFFLINE:
					break;
				case TrackerConstants.AICC:
					//tracker = new AICCTracker();
					break;
				case TrackerConstants.SCORM_1_2:
					tracker = new SCORMTracker();
					break;
				case TrackerConstants.SCORM_2004:
					//tracker = new SCORM2004Tracker();
					break;
				case TrackerConstants.OFFLINE_COOKIES:
					break;
				case TrackerConstants.RESTRICTED_PEKAO:
					//tracker = new RestrictedTracker();
					break;
				case 6:
				case 7:
				case 8:
				case 9:
					break;
				default:
					break;
			}
		}
		
		public function getTracker():ITracker {
			return tracker != null ? tracker : new Tracker();
		}
		
	}

}