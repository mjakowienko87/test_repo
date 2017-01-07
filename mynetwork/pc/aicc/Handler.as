package pl.mynetwork.pc.aicc {
	import pl.mynetwork.utils.StringUtils;


	/**
	 * Klasa bazowa dla handlerów komunikacji
	 */
	public class Handler {
		
		/**
		 * Obiekt w którym wywoływać callbacki komunikacji
		 */
		private var callbacks:Array;

		
		/**
		 * Konstruktor
		 *
		 * @param logger_ logger 
		 * @param consoleLogger_ obiekt logujący na konsolę
		 */
		function Handler() {
			callbacks = new Array();
		}
		
		/**
		 * Dodaje target callbacków
		 *
		 * @param target_ target do dodania
		 */
		public function addTarget(target_:IHandlerCallbackTarget):void {
			callbacks.push(target_);
		}
		
		/**
		 * Określa czy operacja zakończyła się sukcesem.
		 */
		private function isSuccess(data_:String):Boolean {
			return true;
		}
		
		/**
		 * Woła callbacki getparam
		 *
		 * @param data_ dane do przekazania do callbacków
		 */
		protected function callOnGetParams(data_:String):void {
			var tmp:String = StringUtils.normalizeNewline(data_);
			var success:Boolean = isSuccess(tmp);

			for (var i:Number = 0; i < callbacks.length; ++i) {
				(IHandlerCallbackTarget (callbacks[i])).onGetParams(success, tmp);
			}
		}
		
		/**
		 * Woła callbacki putparam
		 *
		 * @param data_ dane do przekazania do callbacków
		 */
		protected function callOnPutParams(data_:String):void {
			var tmp:String = StringUtils.normalizeNewline(data_);
			var success:Boolean = isSuccess(tmp);
			
			for (var i:Number = 0; i < callbacks.length; ++i) {
				(IHandlerCallbackTarget (callbacks[i])).onPutParams(success, tmp);
			}
		}
		
		/**
		 * Woła callbacki putinteractions
		 *
		 * @param data_ dane do przekazania do callbacków
		 */
		protected function callOnPutInteractions(data_:String):void {
			var tmp:String = StringUtils.normalizeNewline(data_);
			var success:Boolean = isSuccess(tmp);
			
			for (var i:Number = 0; i < callbacks.length; ++i) {
				(IHandlerCallbackTarget (callbacks[i])).onPutInteractions(success, tmp);
			}
		}
		
		/**
		 * Woła callbacki exitau
		 *
		 * @param data_ dane do przekazania do callbacków
		 */
		protected function callOnExitAu(data_:String):void {
			var tmp:String = StringUtils.normalizeNewline(data_);
			var success:Boolean = isSuccess(tmp);
			
			for (var i:Number = 0; i < callbacks.length; ++i) {
				(IHandlerCallbackTarget (callbacks[i])).onExitAu(success, tmp);
			}
		}
		
		/**
		 * Woła callback na getExtendedStudentId
		 *
		 * @param success_ czy operacja udana
		 * @param result_ dane z platformy
		 */
		public function callOnGetExtendedStudentId(data_:String):void {
			var tmp:String = StringUtils.normalizeNewline(data_);
			var success:Boolean = isSuccess(tmp);
		
			for (var i:Number = 0; i < callbacks.length; ++i) {
				(IHandlerCallbackTarget (callbacks[i])).onGetExtendedStudentId(success, tmp);
			}
		}

		/**
		 * Komenda AICC getparam.
		 */
		public function getParams():void {
			callOnGetParams("");
		}
		
		/**
		 * Komenda AICC putparam.
		 *
		 * @param data_ dane do wysłania
		 */
		public function putParams(data_:String):void {
			callOnPutParams("");
		}
		
		/**
		 * Komenda AICC putinteractions.
		 *
		 * @param data_ dane do wysłania
		 */
		public function putInteractions(data_:String):void {
			callOnPutInteractions("");
		}
		
		/**
		 * Komenda AICC exitau
		 */
		public function exitAu():void {
			callOnExitAu("");
		}
		
		/**
		 * Metoda pobiera "rozszerzone student id"
		 */
		public function getExtendedStudentId():void {
			callOnGetExtendedStudentId("");
		}
		
	};
}