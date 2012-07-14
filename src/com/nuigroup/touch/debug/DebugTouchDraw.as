package com.nuigroup.touch.debug 
{
	import flash.display.Stage;
	import flash.events.TouchEvent;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class DebugTouchDraw {
		
		
		
		
		/**
		 * to initialize , set stage
		 */
		public static function set stage(s:Stage):void {
			if (s == null && _stage) {
				_stage.removeEventListener(TouchEvent.TOUCH_BEGIN , makeMove);
				_stage.removeEventListener(TouchEvent.TOUCH_END , makeMove);
				_stage.removeEventListener(TouchEvent.TOUCH_MOVE, makeMove);
				_stage = null;
				for each(var v:TouchView in touches) {
					v.remove();
				}
				touches.length = 0;
			} else {
				_stage = s;
				_stage.addEventListener(TouchEvent.TOUCH_BEGIN , makeMove);
				_stage.addEventListener(TouchEvent.TOUCH_END , makeMove);
				_stage.addEventListener(TouchEvent.TOUCH_MOVE, makeMove);
			}
		}
		
		
		
		
		
		
		protected static var _stage:Stage;
		protected static var touches:Array = new Array();
		protected static function makeMove(e:TouchEvent):void {
			var id:int = e.touchPointID;
			switch(e.type) {
				case TouchEvent.TOUCH_BEGIN :
					if (touches[id]) {
						touches[id].remove();
						touches[id] = null;
					}
					var t:TouchView = new TouchView();
					touches[id] = t;
					t.replace(e.stageX,e.stageY);
					t.pressure(e.pressure);
					_stage.addChild(t);
					return;
				case TouchEvent.TOUCH_MOVE:
					if (touches[id]) {
						touches[id].pressure(e.pressure);
						touches[id].replace(e.stageX,e.stageY);
					};
					return;
				case TouchEvent.TOUCH_END :
					if (touches[id]) {
						touches[id].remove();
						touches[id] = null;
					}
					return;
			}
		}
		
	}

}