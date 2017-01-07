package pl.mynetwork.player 
{
	import pl.mynetwork.player.modules.gui.IGUIModule;
	
	/**
	 * ...
	 * @author mkusiak
	 */
	public interface ITrackerMovie extends IGUIModule
	{
		function getTracker():ITracker;
		function getMode():uint;
	}
	
}