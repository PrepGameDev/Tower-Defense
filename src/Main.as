package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Main extends Sprite {
		public var backCanvas:Sprite = new Sprite
		public var turretCanvas:Sprite = new Sprite
		public var overlay:Sprite = new Sprite
		public var bulletCanvas:Sprite = new Sprite
		public var blocks:Vector.<Vector.<Block>> = new Vector.<Vector.<Block>>
		public var mapHeight:int 
		public var mapWidth:int 
		public var scaledBlockWidth:Number
		public var highlightedBlock:Block
		public var menus:Sprite = new Menus
		public var turretButtons:Vector.<TurretButton> = new Vector.<TurretButton>
		
		public var turrets:Vector.<Turret> = new Vector.<Turret>
		
		public var mouseState:String = "free"
		public var mouseGridX:int 
		public var mouseGridY:int 
		public var dragItem:Turret
		
		public var detailArea:Sprite
		public var detailCanvas:Sprite = new Sprite
		
		public var selectedItem:DisplayObject = null
		
		
		public var money:Number = 6000
		public var moneyTextField:TextField = new TextField
		
		
		public var upgradeButton:UpgradeButton 
		public var sellButton:SellButton 
		
		public var enemies:Vector.<Enemy> = new Vector.<Enemy>
		
		public var startBlock:Block
		public var endBlock:Block
		public var pathBlocks:Vector.<Block> = new Vector.<Block>
		
		public var health:Number = 100
		public var healthTextField:TextField = new TextField
		
		public var blockScale:Number
		
		public function Main():void {
			
			//   * = start
			//	 # = finish
			//	 0 = grass
			//   p = path
			//   @ = end row
			var levelText:String = 	"0 * 0 0 0 0 0 0 0 0 @" +
									"0 p 0 0 0 p p p 0 0 @" +
									"0 p p p 0 p 0 p 0 0 @" +
									"0 0 0 p 0 p 0 p 0 0 @" +
									"0 0 0 p p p 0 p p p @" +
									"0 0 0 0 0 0 0 0 0 p @" +
									"0 0 0 p p p p p p p @" +
									"0 0 0 p 0 0 0 0 0 0 @" +
									"0 0 0 p p p p # 0 0 @" +
									"0 0 0 0 0 0 0 0 0 0 @" 
			//var levelText:String = 	"0 0 0 @" +
									//"0 0 @" 
									
			
			
			var index:int
			var row:int = 0
			var column:int = 0
			blocks[0] = new Vector.<Block>
			for (;; ) {
				var char:String = levelText.charAt(index++)
				if(index >= levelText.length)break
				if (char != " " && char != "@") {
					var block:Block = new Block(char, column * Settings.BLOCK_WIDTH, row *  Settings.BLOCK_WIDTH)
					block.gridX = column
					block.gridY = row
					blocks[row][column++] = block
					backCanvas.addChild(block)
					if(char == "*") startBlock = block
					if(char == "#") endBlock = block
				}else if(char == "@"){
					blocks[++row] = new Vector.<Block>
					if(column > mapWidth) mapWidth = column
					column = 0
				}
				
			}
			mapHeight = row+1
			
			var currentBlock:Block = startBlock
			var count:int = 0
			while (currentBlock != endBlock) {
				trace("new", currentBlock.gridX, currentBlock.gridY)
				for (var i:int = 0; i < 4; i++) {
					if (i == 0) {
						var column:int = currentBlock.gridX 
						var row:int = currentBlock.gridY -1
					}else if (i == 1) {						
						var column:int = currentBlock.gridX -1
						var row:int = currentBlock.gridY 
					}else if (i == 2) {						
						var column:int = currentBlock.gridX 
						var row:int = currentBlock.gridY + 1
					}else if (i == 3) {
						var column:int = currentBlock.gridX + 1
						var row:int = currentBlock.gridY 
					}
					trace(column, row , i)
					var valid:Boolean = true
					if(row < 0) valid = false
					if(column < 0) valid = false
					if(column >= mapWidth) valid = false
					if (row >= mapHeight) valid = false
					if (valid) {
						var block:Block = blocks[row][column]						
						if ((block.type == "p" || block.type == "#") && pathBlocks.indexOf(block) == -1) {
							currentBlock = block
							pathBlocks.push(currentBlock)
							//currentBlock.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 1, 200)
							break
						}						
					}				
				}
				count++
				if(count > 100) break
				
			}
			
			blockScale = startBlock.scaleX
			addChild(backCanvas)
			addChild(turretCanvas)
			addChild(overlay)
			addChild(bulletCanvas)
			var canvasScale:Number = Settings.MAP_WIDTH / backCanvas.width
			//if (canvasScale > 1) {
			var tempScale:Number = Settings.MAP_HEIGHT / backCanvas.height
				if (tempScale < canvasScale) canvasScale = tempScale
			backCanvas.scaleX = canvasScale
			backCanvas.scaleY = canvasScale
			//}
			var maxB:Number = mapHeight > mapWidth ? mapHeight:mapWidth
			var maxM:Number = Settings.MAP_WIDTH > Settings.MAP_HEIGHT ? Settings.MAP_WIDTH:Settings.MAP_HEIGHT
			scaledBlockWidth = maxM / maxB
			//var rect:Sprite = new Sprite
			//rect.graphics.beginFill(0xFF0000, .3)
			//rect.graphics.drawRect(0, 0, scaledBlockWidth, scaledBlockWidth)
			//addChild(rect)
			
			addEventListener(Event.ENTER_FRAME, loop)
			addEventListener(MouseEvent.MOUSE_DOWN, click, true)
			
			menus.x = Settings.MAP_WIDTH
			addChild(menus)
			
			
			
			var prototype1:Turret = new Turret(this, Fire_Turret)
			prototype1.damage = 0
			prototype1.reload = .1
			prototype1.range = 100
			prototype1.armorPiercing = 1
			prototype1.effect = "fire"
			prototype1.effectPower = 1
			prototype1.effectChance = .2
			prototype1.effectDuration = 2
			//prototype1.animationClass = Fire_Turret
			
			
			var turretTypes:Array = [Fire_Turret,Fire_Turret,Fire_Turret,Fire_Turret]
			var turretPrices:Array = [200,300,400,500]
			var turretPrototypes:Array = [prototype1,prototype1,prototype1,prototype1]
			var turretButtonCount:int = 0
			
			for (var i:int = 0; i < menus.numChildren; i++) {
				var child:DisplayObject = menus.getChildAt(i)
				if (child is Button) {
					var button:Button = Button(child)					
					button.init(this)
					if (button is TurretButton) {
						var tButton:TurretButton = TurretButton(button)
						tButton.addTurret(turretTypes[turretButtonCount])
						tButton.setPrice(turretPrices[turretButtonCount])
						tButton.prototype = turretPrototypes[turretButtonCount]
						turretButtonCount++
						turretButtons.push(tButton)
					}else if(button is UpgradeButton){
						upgradeButton = UpgradeButton(button)						
						upgradeButton.disable()
					}else if(button is SellButton){
						sellButton = SellButton(button)						
						sellButton.disable()
					}
				}else if (child is Detail_Area) {
					detailArea = Sprite(child)
				}
			}
			detailArea.addChild(detailCanvas)
			
			addChild(moneyTextField)
			moneyTextField.text = "$" + money
			moneyTextField.scaleX = 3
			moneyTextField.scaleY = 3
			moneyTextField.x = Settings.MAP_WIDTH - 125
			moneyTextField.mouseEnabled = false
			
			//healthTextField
			menus.addChild(healthTextField)
			healthTextField.text = "Health	\n" +"  " +health
			healthTextField.scaleX = 3
			healthTextField.scaleY = 3
			healthTextField.x = 45
			healthTextField.y = 500
			healthTextField.mouseEnabled = false
			
			
			var enemyPrototype:Enemy = new Enemy(this, Enemy1)
			enemyPrototype.health = 10
			enemyPrototype.armor = .1
			enemyPrototype.speed = 2
			enemyPrototype.damage = 10
			enemyPrototype.value = 15
			
			
			var enemy:Enemy = new Enemy(this, Enemy1)
			enemy.getPrototypeStats(enemyPrototype)
			enemy.init()
			
		}
		
		public function loop(e:Event):void {
			overlay.graphics.clear()
			bulletCanvas.graphics.clear()
			for (var i:int = 0; i < enemies.length; i++) {
				var enemy:Enemy = enemies[i]
				enemy.think()
				trace(enemy.health)
			}
			for (var i:int = 0; i < turrets.length; i++) {
				var turret:Turret = turrets[i]
				turret.think()
			}
			
			if (selectedItem != null && selectedItem is Block) {
				upgradeButton.enable()
				sellButton.enable()
				upgradeButton.resetText()
				sellButton.resetText()
				
			}else {
				upgradeButton.disable()
				sellButton.disable()
			}
			
			healthTextField.text = "Health	\n" +"  " +health
			moneyTextField.text = "$" + money
			if (dragItem != null) {
				dragItem.x = mouseX
				dragItem.y = mouseY
			}
			
			
			//trace(mouseX, mouseY)
			 mouseGridX = mouseX/scaledBlockWidth
			 mouseGridY = mouseY / scaledBlockWidth
			//trace(mouseGridX, mouseGridY)
			if(mouseGridY < mapHeight){
				var row:Vector.<Block> = blocks[mouseGridY]
				if (mouseGridX < mapWidth) if (row[mouseGridX] != null) {
					highlightedBlock = row[mouseGridX];
					if (highlightedBlock.buildable == true) {
						if(highlightedBlock != selectedItem){
							var color:uint = 0xFFFFFF
							if (mouseState == "dragging") {							
									color = 0xFFFFFF
									overlay.graphics.beginFill(0xFFFFFF, .15)
									overlay.graphics.drawCircle(dragItem.x ,dragItem.y,dragItem.range * backCanvas.scaleX)
							}else {
								if (highlightedBlock.turret != null) {
									color = 0x00FF00
								}
							}
						
							overlay.graphics.beginFill(color, .3)
							overlay.graphics.drawRect(mouseGridX * scaledBlockWidth, mouseGridY * scaledBlockWidth, scaledBlockWidth, scaledBlockWidth)
						}
				}
				}
			}
			if (selectedItem != null) {
				if (selectedItem is Block) {
					var block:Block = Block(selectedItem)
					overlay.graphics.beginFill(0x0000FF, .3)
					overlay.graphics.drawRect(block.gridX * scaledBlockWidth, block.gridY * scaledBlockWidth, scaledBlockWidth, scaledBlockWidth)
					overlay.graphics.beginFill(0xFFFFFF, .15)
					overlay.graphics.drawCircle((block.gridX+.5) * scaledBlockWidth,(block.gridY+.5) * scaledBlockWidth,block.turret.range * backCanvas.scaleX)
				}
			}
			
			
		}
		public function click(e:MouseEvent):void {
			if(e.target == upgradeButton)return
			if(e.target == sellButton)return
			
			
			var valid:Boolean = true
			if(mouseGridX >= mapWidth || mouseGridX < 0)valid = false
			if (mouseGridY >= mapWidth || mouseGridY < 0) valid = false
			
			if(valid){
				var row:Vector.<Block> = blocks[mouseGridY]
				if(mouseGridY < mapHeight)if(row[mouseGridX] != null) {
					highlightedBlock = row[mouseGridX];
				}
			}
			if(highlightedBlock == null || !highlightedBlock.buildable) valid = false
			
			if (mouseState == "dragging") {
				removeChild(dragItem)
				if (valid) {
					backCanvas.addChild(dragItem)
					turrets.push(dragItem)
					dragItem.x = highlightedBlock.x + Settings.BLOCK_WIDTH * .5
					dragItem.y = highlightedBlock.y + Settings.BLOCK_WIDTH * .5
					dragItem.scaleX = highlightedBlock.scaleX //+ scaledBlockWidth * .5
					dragItem.scaleY = highlightedBlock.scaleY //+ scaledBlockWidth * .5
					highlightedBlock.buildable = false
					highlightedBlock.turret = dragItem
					dragItem.block = highlightedBlock
					selectedItem = highlightedBlock
					showDetail(selectedItem)
				}else {
					money += dragItem.value
				}
				
				dragItem = null
				mouseState = "free"
			}else {
				if (highlightedBlock != null) {
					if (highlightedBlock.turret != null){
						if(highlightedBlock != selectedItem) {
							selectedItem = highlightedBlock
							showDetail(highlightedBlock.turret)
						}else {
							selectedItem = null
							showDetail(null)
						}
					}else {
						selectedItem = null
							showDetail(null)
					}
				}
			}			
			
		}
		public function showDetail(item:DisplayObject = null):void {
			
			
			if(detailArea.contains(detailCanvas))detailArea.removeChild(detailCanvas)
			if (item != null) {
				if(item is Block) item = Block(item).turret
				if(item is Turret){
					detailCanvas = new Sprite
					detailArea.addChild(detailCanvas)
					
					var turret:Turret = Turret(item)
					
					var textCanvas:Sprite = new Sprite
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Damage: 	" + turret.damage.toFixed(1)
					textField.y = 0
					
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Reload: 		" + turret.reload.toFixed(1)
					textField.y = 10
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Range: 		" + turret.range.toFixed(1)
					textField.y = 20
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Piercing: 	" + turret.armorPiercing.toFixed(1)
					textField.y = 30
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Effect: 	" + turret.effect.toLocaleUpperCase()
					textField.y = 50
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "	-Power: 	" + turret.effectPower.toFixed(1)
					textField.y = 60
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "	-Chance: 	" + turret.effectChance.toFixed(1)
					textField.y = 70
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "	-Duration: 	" + turret.effectDuration.toFixed(1)
					textField.y = 80
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Level: 	" + turret.level
					textField.y = 100
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = turret.id
					textField.y = 122
					
					textCanvas.scaleX = 1.2
					textCanvas.scaleY = 1.2
					detailCanvas.addChild(textCanvas)
					
					var c:Class = turret.animationClass
					
					var thumbnail:Sprite = new c
					var scale:Number =  40 / thumbnail.width
					var tempScale:Number = 40 / thumbnail.height
					if (tempScale < scale) scale = tempScale
					thumbnail.scaleX = scale
					thumbnail.scaleY = scale
					
					detailCanvas.addChild(thumbnail)
					thumbnail.x = 140
					thumbnail.y = 135					
					
					
				}
			}
		}
		
	}
	
}