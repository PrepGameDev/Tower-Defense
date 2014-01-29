package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Button extends MovieClip
	{
		public var main:Main
		protected var active:Boolean = false
		public function init(main:Main ):void {
			this.main = main
			//this.addEventListener(MouseEvent.MOUSE_OVER, lightUp)
			//this.addEventListener(MouseEvent.MOUSE_OUT, clear)
			//this.addEventListener(MouseEvent.MOUSE_DOWN, click, false)			
			enable()
			
		}
		protected function lightUp(e:MouseEvent):void {
			this.transform.colorTransform = new ColorTransform(1,1,1,1,100,100,100)
		}
		protected function clear(e:MouseEvent):void {
			this.transform.colorTransform = new ColorTransform()
		}
		protected function click(e:MouseEvent):void {
			
		}
		public function enable():void {
			if(!active){
				this.addEventListener(MouseEvent.MOUSE_OVER, lightUp)
				this.addEventListener(MouseEvent.MOUSE_OUT, clear)
				this.addEventListener(MouseEvent.MOUSE_DOWN, click, false)
				this.transform.colorTransform = new ColorTransform()
				active = true
			}
		}
		public function disable():void {
			if(active){
				this.removeEventListener(MouseEvent.MOUSE_OVER, lightUp)
				this.removeEventListener(MouseEvent.MOUSE_OUT, clear)
				this.removeEventListener(MouseEvent.MOUSE_DOWN, click, false)
				this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -100, -100, -100)
				active = false
			}
		}
	}

}