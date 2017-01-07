package pl.mynetwork.pc.scorm 
{

	/**
	 * ...
	 * @author mkusiak
	 */
	public interface ISCORMTracker
	{
		function setSCORMValue(name:String, value:String):void;
		function callJS(command:String, args:String):void;
		function getData(name):String;
		function refreshSuspendData():void;
	}
}