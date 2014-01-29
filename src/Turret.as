package  
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName
	import flash.utils.getTimer
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Turret extends Sprite
	{
		public var value:Number
		
		public var damage:Number
		public var reload:Number
		public var range:Number
		public var armorPiercing:Number
		public var effect:String
		public var effectPower:Number
		public var effectChance:Number
		public var effectDuration:Number
		public var type:String
		public var animationClass:Class
		public var state:String
		public var level:int = 1
		
		public var id:String =""
		
		public var g:Sprite
		
		public var block:Block
		public var main:Main
		
		public var target:Enemy
		
		public var timeOfLastShot:int = 0
		
		
		
		public function Turret(main:Main,c:Class) {
			if (c != null) {
				this.main = main
				animationClass = c
				type = getQualifiedClassName(c)
				g = new c
				addChild(g)
				
				
				//var scale:Number =  Settings.BLOCK_WIDTH / this.width
				//var tempScale:Number = Settings.BLOCK_WIDTH / this.height
				//if (tempScale < scale) scale = tempScale
				//g.scaleX = scale
				//g.scaleY = scale
				
			}
		}
		public function think():void {
			
			var diffX:Number = 0
			var diffY:Number = 0
			//trace(target)
			if(target != null){
				diffX = (target.x - this.x)
				diffY = (target.y - this.y)
				if (target.health <= 0) {
					target = null
					//trace("MOO")
				}
				if (diffX * diffX + diffY * diffY >= range * range) {
					target = null
				}
				
				
			}
			if (target == null) {
				var minSqDist:Number = Number.POSITIVE_INFINITY
				for (var i:int = 0; i < main.enemies.length; i++) {
					var enemy:Enemy = main.enemies[i]
					diffX = (enemy.x - this.x)
					diffY = (enemy.y - this.y)
					
					var sqDist = diffX * diffX + diffY * diffY
					if (sqDist < range * range) {
						if (sqDist < minSqDist) {
							target = enemy
							minSqDist = sqDist
						}
						
					}					
					
				}
			}
			if(diffX*diffY != 0)this.rotation = Math.atan2(diffY, diffX) * (180/Math.PI) + 90
			if(target != null){
				if (diffX * diffX + diffY * diffY < range * range) {
					if (timeOfLastShot + reload * 1000 < getTimer()) {
						timeOfLastShot = getTimer()
						main.bulletCanvas.graphics.lineStyle(3, 0xFFFFFF)
						main.bulletCanvas.graphics.moveTo(this.x*main.backCanvas.scaleX, this.y*main.backCanvas.scaleX)
						main.bulletCanvas.graphics.lineTo(target.x * main.backCanvas.scaleX, target.y * main.backCanvas.scaleX)
						var delim:Number = target.armor - this.armorPiercing
						if(delim <0) delim = 0
						target.health -= this.damage - (delim)
						if (Math.random() <= this.effectChance) {
							var newEffect:Effect = new Effect
							newEffect.duration = this.effectDuration
							newEffect.type = this.effect
							newEffect.pow = this.effectPower
							target.effects.push(newEffect)
						}
						
						//main.overlay.graphics.drawCircle(this.x, this.y, 500)
					}
				}
			}
		}
		
		public function getPrototypeStats(p:Turret):void {
			damage = p.damage
			reload = p.reload
			range = p.range
			armorPiercing = p.armorPiercing
			effect = p.effect
			effectPower = p.effectPower
			effectChance = p.effectChance
			effectDuration = p.effectDuration
			value = p.value
			var index:int = (Settings.OBJ_INDEX++)
			id = "0000"+ index
		}
		
	}

}