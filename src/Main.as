package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.events.KeyboardEvent
	
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
		
		//TODO: 6) A) Change the speed dynamically
				//	The variable time speed can be changed to speed up and slow down the game
				// 	Remember from the Simple Collisions project how we can use keystrokes to control
				// 	our games.
				//	Somewhere in Main() add an event listener -> (addEventListener(KeyboardEvent.KEY_DOWN, keyDown))
				// then make a corresponding function with the parameter (e:KeyboadEvent)
				// test for when keys like Space or P are pressed
				// When P is pressed pause the game (set timeSpeed to 0)
				// When Space is pressed cycle through increasing speeds(1,2,5)
				//Hint you will need an else-if chain
		
		public var timeSpeed:Number = 2
		public var timeStep:Number = 1000 / 30
		public var time:Number = 0
		
		public var levelText:String
		//private var turretPrices:Array
		public var turretPrototypes:Array
		public var waveData:Array
		
		public var waveIndex:int
		public var timeOfNextWaveNode:Number = 0
		//private var turretPrices:Array
		
		//TODO: 3) A) Making a rock Tile.
	//					1.First go to Flash Pro and draw a rock or import an image from the internet(preferably square) into Assets.fla.
					//	2.Then drag select your entire drawing and to Right Click-> Convert to bitmap.
					//  	-If you a got your image from online it is probably already a bitmap.
					// 	3.Then go to the library panel, right click your new bitmap and select Properties
					//	4.Export your image for actionscript with a name you will remember like Rock
		//					-Do not change the base class
					// 	5.Then do CTRL+ENTER to export the swc library
					
		//TODO: 4) A) Making a custom Enemy.
					//	1. Draw your enemey in Flash Pro
					//	2. Make a new symbol from your drawing and export it for actionscipt
					//		-Do not change the base class
					
		//TODO: 5) A) Making a custom Turret.
					//	1. Draw your turret in Flash Pro
					//	2. Make a new symbol from your drawing and export it for actionscipt
					//		-Do not change the base class
					
		
					
		
		public function Main():void {
			
			//   * = start
			//	 # = finish
			//	 0 = grass
			//   p = path
			//   @ = end row
			//TODO: 1) A) Edit the map. Note the key above.
			levelText = 			"0 * 0 0 0 0 0 0 0 0 @" +
									"0 p 0 0 0 p p p 0 0 @" +
									"0 p p p 0 p 0 p 0 0 @" +
									"0 0 0 p 0 p 0 p 0 0 @" +
									"0 0 0 p p p 0 p p p @" +
									"0 0 0 0 0 0 0 0 0 p @" +
									"0 0 0 p p p p p p p @" +
									"0 0 0 p 0 0 0 0 0 0 @" +
									"0 0 0 p p p p # 0 0 @" +
									"0 0 0 0 0 0 0 0 0 0 @" 
									
			//TODO: 3) C) Making a rock Tile.
					//	Now incorperate your rock into the map by changing the type of some of the 
					//	tiles to "r". You should see your image and you should not be able to build on it.
					
			
			
			
			
			//TODO: 5) B) Making a custom Turret.
					//	You can now make a prototype for your turret with whatever stats you choose
					// 	Be sure to make the second parameter of the Turret constuctor the class you created in step A.
					//		-don't forget to give the prototype variable a unique name like prototype2
					
			
			var prototype1:Turret = new Turret(this, Fire_Turret)
			prototype1.damage = 1
			prototype1.reload = .1
			prototype1.range = 100
			prototype1.armorPiercing = 1
			prototype1.effect = "fire"
			prototype1.effectPower = 1
			prototype1.effectChance = .2
			prototype1.effectDuration = 2
			prototype1.value = 200
			//prototype1.animationClass = Fire_Turret
			
			
			//var turretTypes:Array = [Fire_Turret,Fire_Turret,Fire_Turret,Fire_Turret]
			//var turretPrices:Array = [200,300,400,500]
			
			//TODO: 5) C) Making a custom Turret.
							// you can now include your turret in the button sequence
							//at the moment every button is linked to prototype1
			
			turretPrototypes = [prototype1,prototype1,prototype1,prototype1]
			buildLevel()
			
			//TODO: 4) B) Making a custom Enemy.
					//	You can now make a prototype for your enemy with whatever stats you choose
					// 	Be sure to make the second parameter of the Enemey constuctor the class you created in step A.
					//		-don't forget to give the prototype variable a unique name like e3
					// 	You can now include your enemy in the wave sequence
			var e1:Enemy = new Enemy(this, Enemy1)
			e1.health = 10
			e1.armor = .1
			e1.speed = 2
			e1.damage = 10
			e1.value = 15
			
			var e2:Enemy = new Enemy(this, Enemy1)
			e2.health = 15
			e2.armor = .5
			e2.speed = 1
			e2.damage = 10
			e2.value = 30
			
			
			//TODO: 2) A) Edit the wave sequence.
			//				e# are prototype enemies.
			//				Populate the sequence with delays and enemies 
			waveData = [.1, e1, .5, e1, .5, e1, .5, e1,
						10, e2, .4, e2, .4, e2, .4, e2]
			
			
			//var enemy:Enemy = new Enemy(this, Enemy1)
			//enemy.getPrototypeStats(enemyPrototype)
			//enemy.init()
			
		}
		
		public function loop(e:Event):void {
			time += timeStep * timeSpeed
			if(time > timeOfNextWaveNode){
				var waveNode:* = waveData[waveIndex++]
				if (waveNode is Number) {
					timeOfNextWaveNode += Number(waveNode) * 1000
				}else if (waveNode is Enemy) {
					var enemyPrototype:Enemy = Enemy(waveNode)
					var enemy:Enemy = new Enemy(this, enemyPrototype.animClass)
					enemy.getPrototypeStats(enemyPrototype)
					enemy.init()
				}
			}
			
			overlay.graphics.clear()
			bulletCanvas.graphics.clear()
			for (var i:int = 0; i < enemies.length; i++) {
				var enemy:Enemy = enemies[i]
				enemy.think()
				//trace(enemy.health)
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
			//trace(item)
			
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
					textField.text = "Reload: 		" + turret.reload.toFixed(2)
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
				if (item is Enemy) {
					var enemy:Enemy = Enemy(item)
					detailCanvas = new Sprite
					detailArea.addChild(detailCanvas)
					
					var textCanvas:Sprite = new Sprite
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Health: 	" + enemy.health.toFixed(1)
					textField.y = 0
					
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Armor: 		" + enemy.armor.toFixed(1)
					textField.y = 10
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Speed: 		" + enemy.speed.toFixed(1)
					textField.y = 20
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Damage: 	" + enemy.damage.toFixed(1)
					textField.y = 30
					
					var textField:TextField = new TextField
					textField.textColor = 0xFFFFFF
					textCanvas.addChild(textField)
					textField.text = "Value: 	$" + enemy.value.toFixed(1)
					textField.y = 50
					
					textCanvas.scaleX = 1.2
					textCanvas.scaleY = 1.2
					detailCanvas.addChild(textCanvas)
					
					var c:Class = enemy.animClass
					
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
		
		public function buildLevel():void {
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
				//trace("new", currentBlock.gridX, currentBlock.gridY)
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
					//trace(column, row , i)
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
			
			var turretButtonCount:int = 0
			
			for (var i:int = 0; i < menus.numChildren; i++) {
				var child:DisplayObject = menus.getChildAt(i)
				if (child is Button) {
					var button:Button = Button(child)					
					button.init(this)
					if (button is TurretButton) {
						var tButton:TurretButton = TurretButton(button)
						//tButton.addTurret(turretTypes[turretButtonCount])
						
						tButton.prototype = turretPrototypes[turretButtonCount]
						tButton.addTurret(tButton.prototype.animationClass)
						tButton.setPrice(tButton.prototype.value)
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
		}
		
	}
	
}