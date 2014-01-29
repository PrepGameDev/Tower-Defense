package  
{
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class UpgradeButton extends Button
	{
		private var textField:TextField = new TextField
		public var amount:Number
		override protected function click(e:MouseEvent):void {
			if (main.selectedItem is Block) {
				if(main.money >= amount){
					var turret:Turret = Block(main.selectedItem).turret
					turret.level++
					turret.damage *= 1.5
					turret.reload *= .9
					turret.armorPiercing *=1.5
					turret.effectChance += .05
					turret.effectDuration += .3
					turret.effectPower *= 1.3
					turret.value *= 1.3
					turret.value = int(turret.value)
					main.showDetail(turret)
					main.money -= amount
					
				}
			}
		}
		
		override public function enable():void {
			if(!active){
				this.addEventListener(MouseEvent.MOUSE_OVER, lightUp)
				this.addEventListener(MouseEvent.MOUSE_OUT, clear)
				this.addEventListener(MouseEvent.MOUSE_DOWN, click, false)
				this.transform.colorTransform = new ColorTransform()
				active = true
				addChild(textField)
				
				
				textField.x = 21
				textField.y = 4
				textField.scaleX = 1.2
				textField.scaleY = 1
				textField.textColor = 0x00FF00
				textField.mouseEnabled = false
				if(main.selectedItem != null)resetText()
				
			}
		}
		public function resetText():void {
			var turret:Turret = Block(main.selectedItem).turret
			amount = turret.value * 1.5			
			amount = int(amount)
			textField.text = "$" + amount
		}
		
		override public function disable():void {
			if (active) {
				this.removeChild(textField)
				this.removeEventListener(MouseEvent.MOUSE_OVER, lightUp)
				this.removeEventListener(MouseEvent.MOUSE_OUT, clear)
				this.removeEventListener(MouseEvent.MOUSE_DOWN, click, false)
				this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -50, -50, -50)
				active = false
			}
		}
		
		
	}

}