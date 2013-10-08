package com.nuigroup.airtouch 
{
	import com.nuigroup.touch.TouchManager;
	import com.nuigroup.touch.TouchOutput;
	import com.nuigroup.touch.TouchProtocol;
	import flash.display.Stage;
	import flash.net.Socket;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel.pl
	 */
	public class TouchEventSocket 
	{
		
		public static function listen(stage:Stage , socket:Socket , outputMode:String = "TouchEvent" ):void {
			TouchManager.stage = stage;
			TouchManager.inputMode = TouchProtocol.FLASHEVENT;
			TouchManager.outputMode = outputMode;
			TouchManager.addSocket(socket);
		}
		
	}

}