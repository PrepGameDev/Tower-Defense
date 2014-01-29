package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class TurretButton extends Button
	{
		public var price:Number
		public var g:Sprite = new Sprite
		public var animClass:Class
		public var prototype:Turret
		
		public function setPrice(n:Number):void {
			price = n
			var textField:TextField = new TextField
			textField.x = -36
			textField.mouseEnabled = false
			//textField.scaleY = textField.scaleX
			textField.text = "$" + price
			g.addChild(textField)
			textField.scaleY = textField.scaleX = 2
			textField.textColor = 0x99CC77
		}
		public function addTurret(animation:Class):void {
			animClass = animation
			if (!this.contains(g)) this.addChild(g)
			var anim:Sprite = new animation
			
			var scale:Number = (anim.width/this.width)*.75
			var tempScale:Number = (anim.height / this.height)* .75
			g.addChild(anim)
			anim.scaleX = scale
			anim.scaleY = scale
			if (tempScale < scale) scale = tempScale
		}
		//public function addPrototype(p:Turret):void {
			//
		//}
		
		override protected function click(e:MouseEvent):void {
			if (main.money - price >= 0) {
				main.mouseState = "dragging"
				var newTurret:Turret = new Turret(main,animClass)
				main.dragItem = newTurret
					newTurret.scaleX = (main.backCanvas.scaleX) *(main.blockScale) //+ scaledBlockWidth * .5
					newTurret.scaleY = (main.backCanvas.scaleX) *(main.blockScale) //+ scaledBlockWidth * .5
				main.addChild(newTurret)
				main.money -= price
				newTurret.value = price
				newTurret.getPrototypeStats(prototype)
			}
			
			
		}
		override protected function lightUp(e:MouseEvent):void {
			if (main.money >= price) {
				this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 100, 100, 100)
			}else {
				this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 100)
			}
			
			main.showDetail(prototype)
		}
		override protected function clear(e:MouseEvent):void {
			this.transform.colorTransform = new ColorTransform()
			main.showDetail(main.selectedItem)
		}
		
	}

}