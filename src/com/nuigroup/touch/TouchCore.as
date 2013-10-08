package com.nuigroup.touch {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.net.Socket;
	import flash.utils.IDataInput;
	
	/**
	 * Touch reciving and parsing class .
	 * 
	 * Here You can find buildin parsers and data input function .
	 * 
	 * 
	 * 
	 * @version 1
	 * 
	 * @author Gerard Sławiński || nuigroup.turbosqel
	 */
	public class TouchCore {
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		// parser target
		
		/**
		 * parse bytes to Touch data
		 * @param	data		IDataInput element , like Socket or ByteArray
		 */
		public static function parse(data:IDataInput):void {
			if(parser){
				parser.parse(data);
			}else {
				trace("TouchCore.Error::no parser selected !");
			}
		};
		
		/**
		 * parser function
		 */
		public static var parser:ITouchParser;
		
		/**
		 * recive data from socket and parse
		 * @param	e
		 */
		internal static function reciveData(e:ProgressEvent):void {
			parse(e.target as Socket);
		};
		
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- EVENTS DISPATCHING
		
		/**
		 * touch down event
		 */
		public static const DOWN:int = 0;
		/**
		 * touch over object event
		 */
		public static const OVER:int = 1;
		/**
		 * touch move event
		 */
		public static const MOVE:int = 2;
		/**
		 * touch out from object event
		 */
		public static const OUT:int = 3
		/**
		 * touch end/finger up event
		 */
		public static const UP:int = 4;
		/**
		 * tap/click event
		 */
		public static const TAP:int = 5;
		
		/**
		 * output function to dispach event .
		 * Function scheme : f(phase:int , point:Point , target:DisplayObject , id:int, force:Number):void
		 */
		internal static var EventDelegate:Function = dispatchMouseEvent;
		
		/**
		 * dispatch output Event on selected object , if target is accessable for mouse
		 * @param	phase			event phase
		 * @param	point			event position
		 * @param	target			target displayobject
		 * @param	id				touch id
		 * @param	force			for TouchEvent - pressure
		 */
		public static function dispatchEvent(target:InteractiveObject , phase:int , point:Point , id:int = 0 , force:Number = 0):void {
			trace("dispatch::",target , phase);
			//if(phase != 1 && phase != 3){
			//	EventDelegate( TouchManager.stage , phase , point , id , force);
			//} else {
			EventDelegate(target , phase , point , id , force);
			//}
			//
		};
		
		/**
		 * dipatch touch Event on target object
		 * @param	phase			event phase
		 * @param	point			touch position
		 * @param	target			target object
		 * @param	id				touch id
		 * @param	force			pressure
		 */
		public static function dispatchTouchEvent(target:InteractiveObject , phase:int , point:Point , id:int, force:Number):void {
			switch(phase) {
				case DOWN:
					var type:String = TouchEvent.TOUCH_BEGIN;
					break;
				case OVER :
					type = TouchEvent.TOUCH_OVER;
					break;
				case MOVE :
					type = TouchEvent.TOUCH_MOVE;
					break;
				case OUT :
					type = TouchEvent.TOUCH_OUT;
					break;
				case UP :
					type = TouchEvent.TOUCH_END;
					break;
				case TAP :
					type = TouchEvent.TOUCH_TAP;
					break;
			};
			var local:Point = target.globalToLocal(point);
			target.dispatchEvent(new TouchEvent(type , true , false , id , false , local.x , local.y , NaN , NaN , force , target ));
		};
		
		/**
		 * dispatch mouse event on target object
		 * @param	phase			event phase
		 * @param	point			touch position
		 * @param	target			target displayobject
		 * @param	id				N/A
		 * @param	force			N/A
		 */
		public static function dispatchMouseEvent(target:InteractiveObject , phase:int , point:Point  , id:int, force:Number):void {
			switch(phase) {
				case DOWN:
					var type:String = MouseEvent.MOUSE_DOWN;
					break;
				case OVER :
					type = MouseEvent.MOUSE_OVER;
					break;
				case MOVE :
					type = MouseEvent.MOUSE_MOVE;
					break;
				case OUT :
					type = MouseEvent.MOUSE_OUT;
					break;
				case UP :
					type = MouseEvent.MOUSE_UP;
					break;
				case TAP :
					type = MouseEvent.CLICK;
					break;
			};
			var local:Point = target.globalToLocal(point);
			target.dispatchEvent(new MouseEvent(type , true , false , local.x , local.y, target , false , false , false , false , 0));
		};
		
		
		/**
		 * check if object is accessable for mouse
		 * @param	target			target object
		 * @return					true if can be clicked , false if not
		 */
		/*
		protected static function mouseEnabled(target:InteractiveObject):Boolean {
			/*if (target is DisplayObject) {
				var loop:DisplayObjectContainer = target as DisplayObjectContainer;
			}else {
				loop = target.parent;
			};
			var loop:DisplayObjectContainer = target.parent;
			while (loop) {
				if (!loop.mouseChildren) {
					return false;
				};
				loop = loop.parent;
			};
			return true;
		};
		*/
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- UTILS
		
		/**
		 * return objects on stage under point
		 * @param	at			target position
		 * @return				array of points
		 */
		public static function getTarget(at:Point):InteractiveObject {
			if (TouchManager.stage) {
				var target:* = TouchManager.stage.getObjectsUnderPoint(at).pop();
				if(target){
					target = target is InteractiveObject ? target : target.parent;
					var parent:DisplayObjectContainer = target.parent;
					while (!(parent is Stage)) {
						if (parent.mouseChildren == false) {
							target = parent;
						};
						parent = parent.parent;
					};
					return target;
				}
			} else {
				trace("TouchCore::Error: add stage to TouchManager !");
			};
			return null;
		};
		
	};
};