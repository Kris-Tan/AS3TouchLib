package com.nuigroup.touch.emulator {
	import flash.events.TouchEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.nuigroup.touch.TouchCore;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Emulator {
		
		public static function emulateCCVTouch(id:int = 0 , posX:Number = 0 , posY:Number = 0 ):void {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeUTFBytes("CCV");
			ba.writeByte(0);
			ba.writeInt(1);
			ba.writeInt(id);
			ba.writeFloat(posX);
			ba.writeFloat(posY);
			ba.writeFloat(0);
			ba.writeFloat(0);
			ba.writeFloat(0);
			ba.position = 0;
			TouchCore.parse(ba);
		}
		
		
		public static function getTouchOperation(arrayOfTouchEvents:Array):ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes("FL");
			ba.writeShort(arrayOfTouchEvents.length);
			for (var i:int = 0; i < arrayOfTouchEvents.length; i++ ) {
				var evt:TouchEvent = arrayOfTouchEvents[i];
				ba.writeByte(evt.touchPointID);
				switch(evt.type) {
					case TouchEvent.TOUCH_BEGIN :
						ba.writeByte(0);
						break;
					case TouchEvent.TOUCH_MOVE:
						ba.writeByte(2);
						break;
					default:
						ba.writeByte(4);
						break;
				}
				ba.writeFloat(evt.stageX);
				ba.writeFloat(evt.stageY);
				ba.writeFloat(evt.pressure);
			}
			ba.position = 0;
			return ba;
		}
		
	}

}