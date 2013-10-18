package turbosqel.receive
{
	import com.nuigroup.airtouch.TouchEventSocket;
	import com.nuigroup.touch.debug.DebugTouchDraw;
	import com.nuigroup.touch.emulator.EventCheckBox;
	import com.nuigroup.touch.TouchManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.TouchEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel.pl
	 */
	public class Main extends Sprite 
	{
		public var out:TextField;
		public var server:ServerSocket;
		public function Main():void 
		{
			out = new TextField();
			out.text = "init";
			addChild(out);
			
			server= new ServerSocket();
			
			
			var box:EventCheckBox = new EventCheckBox();
			box.x = box.y = 100;
			addChild(box);
		}
		
		public function initserv():void{
			server.addEventListener(ServerSocketConnectEvent.CONNECT , onSocket);
			server.addEventListener(Event.CLOSE , trace);
			server.bind(3333);
			server.listen();
			
			DebugTouchDraw.stage = stage;
		}
		
		private function onSocket(e:ServerSocketConnectEvent):void {
			out.appendText("\nsocket connected.");
			TouchEventSocket.listen(stage,e.socket);
		}
		
	}
	
}