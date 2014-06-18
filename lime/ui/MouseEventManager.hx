package lime.ui;


import lime.app.EventManager;
import lime.system.System;

#if js
import js.Browser;
#elseif flash
import flash.Lib;
#end


@:allow(lime.ui.Window)
class MouseEventManager extends EventManager<IMouseEventListener> {
	
	
	private static var instance:MouseEventManager;
	
	private var eventInfo:MouseEventInfo;
	
	
	public function new () {
		
		super ();
		
		instance = this;
		eventInfo = new MouseEventInfo ();
		
		#if (cpp || neko)
		lime_mouse_event_manager_register (dispatch, eventInfo);
		#end
		
	}
	
	
	public static function addEventListener (listener:IMouseEventListener, priority:Int = 0):Void {
		
		if (instance != null) {
			
			instance._addEventListener (listener, priority);
			
		}
		
	}
	
	
	private function dispatch ():Void {
		
		var x = eventInfo.x;
		var y = eventInfo.y;
		var button:Int = cast eventInfo.button;
		
		switch (eventInfo.type) {
			
			case MOUSE_DOWN:
				
				for (listener in listeners) {
					
					listener.onMouseDown (x, y, button);
					
				}
			
			case MOUSE_UP:
				
				for (listener in listeners) {
					
					listener.onMouseUp (x, y, button);
					
				}
			
			case MOUSE_MOVE:
				
				for (listener in listeners) {
					
					listener.onMouseMove (x, y, button);
					
				}
			
			default:
			
		}
		
	}
	
	
	#if js
	private function handleDOMEvent (event:js.html.MouseEvent):Void {
		
		/*
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			__mouseX = (event.clientX - rect.left) * (stageWidth / rect.width);
			__mouseY = (event.clientY - rect.top) * (stageHeight / rect.height);
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			//__mouseX = (event.clientX - rect.left) * (__div.style.width / rect.width);
			__mouseX = (event.clientX - rect.left);
			//__mouseY = (event.clientY - rect.top) * (__div.style.height / rect.height);
			__mouseY = (event.clientY - rect.top);
			
		}
		*/
		
		eventInfo.x = event.clientX;
		eventInfo.y = event.clientY;
		
		eventInfo.type = switch (event.type) {
			
			case "mousedown": MOUSE_DOWN;
			case "mouseup": MOUSE_UP;
			case "mousemove": MOUSE_MOVE;
			//case "click": MouseEvent.CLICK;
			//case "dblclick": MouseEvent.DOUBLE_CLICK;
			case "mousewheel": MOUSE_WHEEL;
			default: null;
			
		}
		
		dispatch ();
		
	}
	#end
	
	
	#if flash
	private function handleFlashEvent (event:flash.events.MouseEvent):Void {
		
		eventInfo.x = event.stageX;
		eventInfo.y = event.stageY;
		
		eventInfo.type = switch (event.type) {
			
			case flash.events.MouseEvent.MOUSE_DOWN: MOUSE_DOWN;
			case flash.events.MouseEvent.MOUSE_MOVE: MOUSE_MOVE;
			default: MOUSE_UP;
			
		}
		
		dispatch ();
		
	}
	#end
	
	
	private static function registerWindow (window:Window):Void {
		
		if (instance != null) {
			
			#if js
			window.element.addEventListener ("mousedown", instance.handleDOMEvent, true);
			window.element.addEventListener ("mousemove", instance.handleDOMEvent, true);
			window.element.addEventListener ("mouseup", instance.handleDOMEvent, true);
			//window.element.addEventListener ("mousewheel", handleDOMEvent, true);
			
			// Disable image drag on Firefox
			/*Browser.document.addEventListener ("dragstart", function (e) {
				if (e.target.nodeName.toLowerCase() == "img") {
					e.preventDefault();
					return false;
				}
				return true;
			}, false);*/
			#elseif flash
			Lib.current.stage.addEventListener (flash.events.MouseEvent.MOUSE_DOWN, instance.handleFlashEvent);
			Lib.current.stage.addEventListener (flash.events.MouseEvent.MOUSE_MOVE, instance.handleFlashEvent);
			Lib.current.stage.addEventListener (flash.events.MouseEvent.MOUSE_UP, instance.handleFlashEvent);
			#end
			
		}
		
	}
	
	
	public static function removeEventListener (listener:IMouseEventListener):Void {
		
		if (instance != null) {
			
			instance._removeEventListener (listener);
			
		}
		
	}
	
	
	#if (cpp || neko)
	private static var lime_mouse_event_manager_register = System.load ("lime", "lime_mouse_event_manager_register", 2);
	#end
	
	
}