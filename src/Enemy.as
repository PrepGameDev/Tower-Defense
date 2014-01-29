package  
{
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Enemy extends MovieClip
	{
		public var health:Number
		public var armor:Number
		public var speed:Number =5
		public var damage:Number 
		public var value:Number
		public var animClass:Class
		
		public var vx:Number
		public var vy:Number
		public var currentBlock:Block
		public var nextBlock:Block
		private var blockIndex:int
		public var active:Boolean = false
		
		public var main:Main
		
		public var effects:Vector.<Effect> = new Vector.<Effect>
		
		
		public function Enemy(main:Main, c:Class):void {
			this.main = main
			
			animClass = c
			this.addChild(new c)
			this.x = main.startBlock.x + Settings.BLOCK_WIDTH * .5
			this.y = main.startBlock.y + Settings.BLOCK_WIDTH * .5
			this.scaleX = main.startBlock.scaleX
			this.scaleY = main.startBlock.scaleY
			currentBlock = main.startBlock
			nextBlock = main.pathBlocks[1]
			var VX:Number = nextBlock.x-currentBlock.x
			var VY:Number = nextBlock.y - currentBlock.y
			this.vx = VX > 0 ? speed: -speed			
			this.vy = VY > 0 ? speed: -speed
			if(VX == 0) vx = 0
			if(VY == 0) vy = 0
			blockIndex = 0
			
			
		}
		public function init():void {
			main.enemies.push(this)
			main.backCanvas.addChild(this)
			active = true
		}
		
		public function think():void {
			for (var i:int = 0; i < effects.length; i++) {
				var effect:Effect = effects[i]
				var effectProgress:Number = (getTimer() - effect.applyTime) / (effect.duration*1000)
				if (effectProgress >= 1) {
					effects.splice(effects.indexOf(effect), 1)
					i--
				}else{
					if (effect.type == "fire") {
						this.health += effect.sigmaEffect - effect.pow * effectProgress
						effect.sigmaEffect = effect.pow * effectProgress
					}
				}
				trace("SDD")
			}
			
			if (this.health <= 0) {
				die()
			}
			if(!active) return
			this.x += vx
			this.y += vy
			
			var targetX:Number = (nextBlock.x + Settings.BLOCK_WIDTH * .5)
			var targetY:Number = (nextBlock.y + Settings.BLOCK_WIDTH * .5)
			var diffX:Number = targetX - this.x 
			var diffY:Number = targetY - this.y 
			if (diffX * vx + diffY * vy < 0) {
				this.x = targetX
				this.y = targetY
				currentBlock = nextBlock
				if(currentBlock != main.endBlock){
					nextBlock = main.pathBlocks[++blockIndex + 1]		
					var VX:Number = nextBlock.x-currentBlock.x
					var VY:Number = nextBlock.y - currentBlock.y
					this.vx = VX > 0 ? speed: -speed			
					this.vy = VY > 0 ? speed: -speed
					if(VX == 0) vx = 0
					if (VY == 0) vy = 0
				}else {
					die(true)
				}
			}
			this.rotation = Math.atan2(vy, vx) * (180/Math.PI) + 90
		}
		public function die(doDamage:Boolean = false):void {
			main.enemies.splice(main.enemies.indexOf(this),1)
			main.backCanvas.removeChild(this)
			if (doDamage) {
				main.health -= damage
			}else {
				main.money += this.value
			}
		}
		
		public function getPrototypeStats(e:Enemy):void {
			health = e.health
			armor = e.armor
			speed = e.speed
			damage = e.damage
			value = e.value
			animClass = e.animClass
		}
		
	}

}