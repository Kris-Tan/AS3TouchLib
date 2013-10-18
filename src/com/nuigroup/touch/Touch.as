package com.nuigroup.touch {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Touch {
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- TOUCHES
		
		public static var touches:Array = new Array();
		
		public static function get freeTouchID():int {
			var i:int = 0;
			while (touches[i]) {
				i++;
			};
			return i;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- STATIC CONST
		
		/**
		 * delay for tap event , if time between touch start and end is smaller than TAP_DELAY , Tap events is dispatcher
		 */
		public static var TAP_DELAY:int = 220;
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- PARAMS
		
		/**
		 * touch id
		 */
		public var id:int;
		
		/**
		 * last touch position
		 */
		public var last:Point = new Point();
		
		/**
		 * actual touch position
		 */
		public var point:Point = new Point();
		
		/**
		 * acceleration or pressure
		 */
		public var force:Number;
		
		/**
		 * start time
		 */
		public var initTime:Number;
		
		/**
		 * actual elements on stage under touch point
		 */
		public var target:InteractiveObject;
		
		
		
		/**
		 * recognized shape ID; for TUIO
		 */
		public var shape:Number = NaN;
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- INIT
		
		/**
		 * create new Touch data object
		 * @param	id				touch point id
		 * @param	x				x position
		 * @param	y				y position
		 * @param	initTime		initialize time
		 */
		public function Touch(id:int , x:Number , y:Number , initTime:Number , force:Number = 0) {
			// touch id and begin position
			this.id = id;
			// register touch ::
			
			if (id < touches.length  && touches[id]) {
				// somethings left ?
				touches[id].end(initTime);
			};
			touches[id] = this;
			// touch data::
			point.x = x;
			point.y = y;
			this.force = force;
			// touch start time
			this.initTime = initTime;
			// get object under position and dispatch Begin/MouseDown event
			target = TouchCore.getTarget(point);
			dispatch(target , 0);
		};
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- FUNCTIONS
		
		/**
		 * apply move on touch and dispatch events
		 * @param	x		new x position
		 * @param	y		new y position
		 */
		public function move(x:Number , y:Number , force:Number = NaN):void {
			// change new and last position (to not create new instances)
			last.x = point.x;
			last.y = point.y;
			
			if(!isNaN(force)){
				this.force = force;
			}
			
			point.x = x;
			point.y = y;
			var current:InteractiveObject = TouchCore.getTarget(point);
			if (current == target) {
				dispatch(target , 2);
			} else {
				dispatch(target , 3);
				dispatch(current , 1);
				target = current;
			}
		}
		
		
		/**
		 * touch end , dispatch UP/END event and can dispatch TAP/CLICK
		 * @param	time		remove time
		 */
		public function end(time:Number):void {
			dispatch(target , 4);
			if (time - initTime < TAP_DELAY) {
				dispatch(target , 5);
			}
			// end touch
			remove();
		};
		
		
		
		
		protected function dispatch(target:InteractiveObject , phase:int):void {
			if(target){
				TouchCore.dispatchEvent( target , phase , point , id , force);
			} else {
				TouchCore.dispatchEvent( TouchManager.stage , phase , point , id , force);
			}
		}
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------- REMOVE && UTIL
		
		
		public function toString():String {
			return "[ :Touch:  id:" + id + " , point:" + point + " , target:" + target + " ]";
		};
		
		
		/**
		 * remove and release instances
		 */
		public function remove():void {
			// if array exist - release and remove
			touches[id] = null;
			target = null;
			point = null;
			last = null;
		};
		
	};

};