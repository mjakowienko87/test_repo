package pl.mynetwork.pc.aicc {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import pl.mynetwork.utils.StringUtils;

	/**
	 * Handler komunikacji przez HTTP
	 */
	class HttpHandler extends Handler {
		
		//
		// dane komunikacyjne
		//
		
		/**
		 * AICC_SID
		 */
		private var aiccSid:String;
		
		/**
		 * AICC_URL
		 */
		private var aiccUrl:String;
		
		/**
		 * AU_Password
		 */
		private var auPassword:String;
		
		/**
		 * Version
		 */
		private var version:String;
		
		private var getParamsLoader:URLLoader;
		private var putParamsLoader:URLLoader;
		private var exitAuLoader:URLLoader;
		private var getExtendedStudentLoader:URLLoader;
		
		
		
		/**
		 * Konstruktor
		 *
		 * @param logger_ logger 
		 * @param consoleLogger_ obiekt logujący na konsolę
		 */
		public function HttpHandler() {
			super();
		}
		
		/**
		 * Inicjalizacja handlera
		 *
		 * @param aiccSid_ AICC_SID
		 * @param aiccUrl_ AICC_URL
		 * @param auPassword_ AU_Password
		 */
		public function init(aiccSid_:String, aiccUrl_:String, auPassword_:String):void {
			aiccSid = aiccSid_ != null ? aiccSid_ : "";
			aiccUrl = aiccUrl_ != null ? aiccUrl_ : "";
			auPassword = auPassword_ != null ? auPassword_ : "";
			version = "3.0.1";
			getParamsLoader = new URLLoader();
			putParamsLoader = new URLLoader();
			exitAuLoader = new URLLoader();
			getExtendedStudentLoader = new URLLoader();
		}
		
		private function handleLoadSuccessful($evt:Event):void
		{
			var loader:URLLoader = URLLoader($evt.target);
			loader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			
			if (loader == getParamsLoader) {
				trace("handleLoadSuccessful:", "getParamsLoader");
				callOnGetParams(loader.data);
			} else if (loader == putParamsLoader) {
				trace("handleLoadSuccessful:", "putParamsLoader");
				callOnPutParams(loader.data);
			} else if (loader == exitAuLoader) {
				trace("handleLoadSuccessful:", "exitAuLoader");
				callOnExitAu(loader.data);
			} else if (loader == getExtendedStudentLoader) {
				trace("handleLoadSuccessful:", "getExtendedStudentLoader");
				callOnGetExtendedStudentId(loader.data);
			}
			
		}
		 
		private function handleLoadError($evt:IOErrorEvent):void
		{
			var loader:URLLoader = URLLoader($evt.target);
			loader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);			
		    trace("Message failed.");
		}		
		
		/**
		 * Ustawia wersję AICC
		 *
		 * @param version_ wersja
		 */
		public function setVersion(version_:String):void {
			version = version_;
		}
		
		/**
		 * Przygotowuje obiekt komunikacyjny
		 *
		 * @param command_ komenda
		 * @param data_ dane
		 * @return obiekt komunikacyjny
		 */
		private function prepare(command_:String, data_:String):URLVariables {
			var scriptVars:URLVariables = new URLVariables();
			scriptVars.command = command_;
			scriptVars.version = version;
			scriptVars.session_id = aiccSid;
			//scriptVars.au_password = auPassword;
			scriptVars.aicc_data = data_;//StringUtils.encode(data_);
			return scriptVars;			
		}
		
		/**
		 * Komenda AICC getparam.
		 */
		override public function getParams():void {
			var URLR:URLRequest = new URLRequest(aiccUrl);
			var URLV:URLVariables = prepare("getparam", "");
			URLR.method = URLRequestMethod.POST;			
			URLR.data = URLV;
			getParamsLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			getParamsLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);			
			getParamsLoader.load(URLR);			
		}
		
		/**
		 * Komenda AICC putparam.
		 *
		 * @param data_ dane do wysłania
		 */
		override public function putParams(data_:String):void {
			var URLR:URLRequest = new URLRequest(aiccUrl);
			var URLV:URLVariables = prepare("putparam", data_);
			trace("putParams", data_);
			URLR.method = URLRequestMethod.POST;			
			URLR.data = URLV;
			putParamsLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			putParamsLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);			
			putParamsLoader.load(URLR);
		}
		
		/**
		 * Komenda AICC putinteractions.
		 *
		 * @param data_ dane do wysłania
		 */
		//override public function putInteractions(data_:String):void {
			//var lv:LoadVars = prepare("PutInteractions", data_);
			//lv.sendAndLoad(aiccUrl, new LoadVarsListener(this, callOnPutInteractions), "POST");
		//}
		
		/**
		 * Komenda AICC exitau
		 */
		override public function exitAu():void {
			var URLR:URLRequest = new URLRequest(aiccUrl);
			var URLV:URLVariables = prepare("exitau", "");
			URLR.method = URLRequestMethod.POST;			
			URLR.data = URLV;
			exitAuLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			exitAuLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);			
			exitAuLoader.load(URLR);
		}
		
		/**
		 * Metoda pobiera "rozszerzone student id"
		 */
		override public function getExtendedStudentId():void {
			var URLR:URLRequest = new URLRequest(aiccUrl);
			var URLV:URLVariables = prepare("getextendedparam", "");
			URLR.method = URLRequestMethod.POST;			
			URLR.data = URLV;
			getExtendedStudentLoader.addEventListener(Event.COMPLETE, handleLoadSuccessful);
			getExtendedStudentLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);			
			getExtendedStudentLoader.load(URLR);				
		}
		
		/**
		 * Czy udana komunikacja
		 *
		 * @param src_ odpowiedź serwera
		 * @return true - komunikacja udana, false - błąd komunikacji lub serwera
		 */
		private function isSuccess(src_:String):Boolean {
			if (src_ == null || src_ == "") {
				return false;
			}
			
			var begin:Number;
			var end:Number;
			var src:String = src_.toLowerCase();
			begin = src.indexOf("error=");
			if (begin >= 0) {
				end = src.indexOf(StringUtils.CRLF, begin + 6);
				if (end >= 0) {
					return StringUtils.trim(src.substring(begin + 6, end)) == "0";
				}
			}
			return false;
		}
	};
}