package com.nuigroup.touch.parsers {
	import com.nuigroup.touch.ITouchParser;
	import com.nuigroup.touch.Touch;
	import com.nuigroup.touch.TouchCore;
	import com.nuigroup.touch.TouchManager;
	import com.nuigroup.touch.TouchProtocol;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.utils.IDataInput;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class FlashEvents implements ITouchParser {
		
		public function FlashEvents() {
			
		}
		/**
		 * 
		 * endian = LITTLE_ENDIAN
		 * operation 				// bytes
		 * 
		 * header:
		 * writeUTFBytes("FL") 		// 2
		 * writeShort(numTouchs)	// 2 
		 * loop:
		 * writeByte(id) 			// 1 (touch num)
		 * writeByte(phase)			// 1 (phase 0-down , 2-move , 4-up , 5-tap)
		 * writeFloat(x) 			// 4 ( x position in 0-1 value )
		 * writeFloat(y) 			// 4 ( y position in 0-1 value )
		 * writeFload(pressure)		// 4 ( force in 0-1 value )
		 * 
		 */
		
		
		public function get name():String {
			return TouchProtocol.FLASHEVENT;
		}
		
		public function get header():String {
			return "FL";
		}
		
		public function parse(data:IDataInput):void {
			try {
				// current time::
				var time:Number = (new Date()).getTime();
				// check header
				if ("FL" != data.readUTFBytes(2)) {
					trace("invalid request , no FL header");
					return;
				};
				// number of touches
				var length:int = data.readShort();
				trace("FL numtouchs:",length);
				// touch position holder
				for (var i:int = 0 ; i < length ; i++ ) {
					// read touch id
					var id:int = data.readByte();
					// read touch phase
					var phase:int = data.readByte();
					switch(phase) {
						case 0 :
							var t:Touch = new Touch(id,data.readFloat(),data.readFloat() , time, data.readFloat());
							break;
						case 2 :
							t = Touch.touches[id];
							if (t) {
								t.move(data.readFloat(),data.readFloat() , data.readFloat());
							}
							break;
						case 4:
						case 5:
							t = Touch.touches[id];
							if (t) {
								t.end(time);
							}
							
							data.readFloat();
							data.readFloat();
							data.readFloat();
							break;
					}
					trace("loop:",id,phase,t);
				}
			} catch (er:Error) {
				trace("parse error:FlashEvents :" + er.message + "\n" + er.getStackTrace());
			}
			// write left bytes from stream
			while (data.bytesAvailable) {
				data.readByte();
			}
		}
		
	}

}