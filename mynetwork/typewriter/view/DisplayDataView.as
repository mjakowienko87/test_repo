package pl.mynetwork.typewriter.view 
{
	import flash.display.MovieClip;
	
	
	
	
	
	//-----------------------------------------------
	public class DisplayDataView 
	{
		
		
		
		
		//-----------------------------------------------
		private var _viewObjects:Array;
		
		
		
		
		
		//-----------------------------------------------
		public function DisplayDataView() 
		{
			_viewObjects = new Array();
		}
		
		
		
		
		
		
		//-----------------------------------------------
		public function _displayArray(_objects:Array):void
		{
			
			_viewObjects = _objects;
		}
		
		
		
		
		
		
		//-----------------------------------------------
		public function updateViewArray(_errorMargin:Number,_dynamicError:Number,_progress:Number,_typingSpeed:Number):void
		{
			returnDisplayViewObjectByName("PROGRESS").updateDisplayModel(_progress);
			returnDisplayViewObjectByName("ERROR").updateDisplayModel(_errorMargin);
			returnDisplayViewObjectByName("DYNAMIC_ERROR").updateDisplayModel(_dynamicError);
			
		}	
		
		
		
		
		
		//-----------------------------------------------
		public function updateTime(_time:String):void
		{
			returnDisplayViewObjectByName("TIME").updateTimer(_time);
		}
		
		
		
		
		
		//-----------------------------------------------
		public function updateGrossWPM(_data:Number):void
		{
			returnDisplayViewObjectByName("SPEED").updateDisplayModel(_data);
		}
		
		
		
		
		
		
		//-----------------------------------------------
		private function returnDisplayViewObjectByName(_name:String):MovieClip
		{
			for(var k in _viewObjects) 
			{
				if(_name == _viewObjects[k].get_Type()) 
				{
					return _viewObjects[k];
				}
			}
			return null
		}
	}
}
