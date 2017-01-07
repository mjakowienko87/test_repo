package pl.mynetwork.pc.aicc 
{
	/**
	 * Interfejs obiektu z callbackami dla handlera komunikacji
	 */
	public interface IHandlerCallbackTarget {
		
		/**
		 * Callback na getparam.
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		function onGetParams(success_:Boolean, result_:String):void;
		
		/**
		 * Callback na putparam.
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		function onPutParams(success_:Boolean, result_:String):void;
		
		/**
		 * Callback na putinteractions.
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		function onPutInteractions(success_:Boolean, result_:String):void;
		
		/**
		 * Callback na exitau.
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		function onExitAu(success_:Boolean, result_:String):void;
		
		/**
		 * Callback na getExtendedStudentId.
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		function onGetExtendedStudentId(success_:Boolean, result_:String):void;
	};
}