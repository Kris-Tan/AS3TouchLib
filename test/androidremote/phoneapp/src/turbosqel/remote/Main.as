package turbosqel.remote {
	import com.nuigroup.touch.debug.DebugTouchDraw;
	import com.nuigroup.touch.emulator.Emulator;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel.pl
	 */
	public class Main extends Sprite {
		public var text:TextField;
		public var socket:Socket;
		public function Main():void {
			text = new TextField();
			text.width = stage.stageWidth;
			text.height = stage.stageHeight;
			text.text = "init.";
			addChild(text);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			trace("is tracing");
			DebugTouchDraw.stage = stage;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(TouchEvent.TOUCH_BEGIN , sendList);
			stage.addEventListener(TouchEvent.TOUCH_MOVE , sendList);
			stage.addEventListener(TouchEvent.TOUCH_END , sendList);
			stage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDown);
			
			connect();
			
		}
		
		private function connect():void {
			socket = new Socket();
			socket.addEventListener(Event.CONNECT , onConnect);
			socket.addEventListener(Event.CLOSE , onError);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			//socket.endian = Endian.LITTLE_ENDIAN;
			socket.connect("192.168.1.2", 3333);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- SOCKET HANDELRS
		
		private function onConnect(e:Event):void {
			text.appendText("\n on connect");
			TouchList = new Array();
			addEventListener(Event.ENTER_FRAME , oef);
		}
		
		private function oef(e:Event):void {
			if (TouchList.length > 0) {
				text.appendText("\n touches:"+TouchList.length + " , lst:"+TouchList[0].stageX + ","+TouchList[0].stageY);
				var data:ByteArray = Emulator.getTouchOperation(TouchList);
				TouchList.length = 0;
				socket.writeBytes(data, 0, data.length);
				socket.flush();
			}
		}
		
		private function onError(ev:Event):void {
			text.appendText("\n on error:"+ev.type);
			try {
				socket.close();
			}catch (e:Error) { }
			if (hasEventListener(Event.ENTER_FRAME)) {
				TouchList = null;
				removeEventListener(Event.ENTER_FRAME , oef);
			}
			socket.removeEventListener(Event.CONNECT , onConnect);
			socket.removeEventListener(Event.CLOSE , onError);
			socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- EVENTS
		
		private var TouchList:Array;
		private function sendList(e:TouchEvent):void {
			trace("add event:",e);
			if(TouchList){
				TouchList.push(e);
			}
		}
		
		
		private function onKeyDown(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.BACK){
				NativeApplication.nativeApplication.exit();
			}
		}
		
	}
	
}