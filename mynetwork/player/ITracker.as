package pl.mynetwork.player 
{
	/**
	 * ...
	 * @author mkusiak
	 */
	public interface ITracker 
	{
		function init():void;
		function putParams():void;
		function setScore(score:Number):void;
		function setStatus(status:String):void;
		function setParam(paramName:String, value:String):void;
		function finish():void;
		function showJSAlert(text:String):void;
		function setCoreLesson(coreLesson_:String):void;
		function getCoreLesson():String;
		function setLessonData(name:String, value:Object):void;
		function getLessonData(name:String):Object;
		function clearLessonData(name:String = ""):void;
		function setLessonLocation(location:String):void;
		function getLessonLocation():String;
		function closeLesson():void
		
		//SCORM1.2
		function setSCORMValue(name:String, value:String):void;
		function callJS(command:String, args:String):void;
		function getData(name):String;
		function getCustomData(name:String):String;
		function refreshSuspendData():void;
		
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void;
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void;
	}
}