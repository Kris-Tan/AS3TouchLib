package com.nuigroup.touch.debug {
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class TouchView extends Sprite {
		
		public static var color:uint = 0x123456;
		public static var size:Number = 20;
		
		protected var interval:Number = NaN;
		
		
		public function TouchView() {
			graphics.beginFill(color, 0.8);
			graphics.drawCircle(0, 0, size);
			graphics.endFill();
		}
		
		public function replace(x:Number , y:Number):void {
			this.x = x;
			this.y = y;
			if (!isNaN(interval)) {
				clearTimeout(interval);
			}
			interval = setTimeout(remove,1000);
		}
		
		public function pressure(num:Number):void {
			width = 15 + 10 * num;
			height = 15 + 10 * num;
		}
		
		
		public function remove():void {
			if (parent) {
				parent.removeChild(this);
			};
			if (!isNaN(interval)) {
				clearTimeout(interval);
			};
		}
		
	}

}