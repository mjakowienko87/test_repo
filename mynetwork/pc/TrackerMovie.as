package pl.mynetwork.pc 
{
	import fl.text.TLFTextField;
	 import flash.system.Security;
    import flash.system.SecurityPanel;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flashx.textLayout.events.ModelChange;
	import pl.mynetwork.pc.restricted.RestrictedTracker;
	import pl.mynetwork.player.Cmd;
	import pl.mynetwork.player.modules.gui.GUIBase;
	import pl.mynetwork.player.modules.gui.IGUIModule;
	import pl.mynetwork.pc.aicc.AICCTracker;
	import pl.mynetwork.pc.scorm.SCORMTracker;
	import pl.mynetwork.pc.scorm2004.SCORM2004Tracker;
	import pl.mynetwork.player.modules.events.ModuleEvent;
	import pl.mynetwork.xmlParsers.IData;
	import pl.mynetwork.xmlParsers.TrackerParser;
	import pl.mynetwork.player.ITrackerMovie
	import pl.mynetwork.player.ITracker;
	
	/**
	 * ...
	 * @author mkusiak
	 */
	public class TrackerMovie extends GUIBase implements ITrackerMovie
	{
		private var mode:uint;
		private var tracker:Tracker;
		
		public function TrackerMovie() 
		{
			super();
			Security.allowDomain("*");
			setMode();
			initTracker();
		}
		
		public override function setData(dataObj:IData):void {
			data = dataObj;
			//trackerData = TrackerParser(data);
			dispatchEvent(new ModuleEvent(ModuleEvent.INIT,{}));
		}
		
		private function setMode():void {
			if (ExternalInterface.available) {
				try {
					mode = ExternalInterface.call("get_mode");
					//trace("mode", mode);
				}
				catch (error:Error){
					//Cmd.showAlert("trackerError");
					
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
					tracker = new AICCTracker();
					break;
				case TrackerConstants.SCORM_1_2:
					tracker = new SCORMTracker();
					break;
				case TrackerConstants.SCORM_2004:
					tracker = new SCORM2004Tracker();
					break;
				case TrackerConstants.OFFLINE_COOKIES:
					break;
				case TrackerConstants.RESTRICTED_PEKAO:
					tracker = new RestrictedTracker();
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