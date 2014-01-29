package  
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Block extends Sprite
	{
		public var type:String 
		public var buildable:Boolean = false
		public var turret:Turret
		public var gridX:int
		public var gridY:int
		
		public function Block(char:String,X:Number, Y:Number):void {
			this.type = char
			this.x = X
			this.y = Y
			
			var color:uint = 0xCCCCCC
			var bitmapData:BitmapData 
			var useBitmap:Boolean = true
			if (char == "p") {
				bitmapData = new Path
			}else if ( char == "*") {
				bitmapData = new Entrance
			}else if ( char == "#") {
				bitmapData = new Caution
			}else if(char == "0"){
				bitmapData = new Grass
				buildable = true
			}else {
				color = 0x00FF00
				useBitmap = false
			}
			
			if (!useBitmap) {
				this.graphics.beginFill(color)
				this.graphics.drawRect(0, 0, Settings.BLOCK_WIDTH, Settings.BLOCK_WIDTH)
			}else {
				this.graphics.beginBitmapFill(bitmapData)
				this.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height)
				this.scaleX = Settings.BLOCK_WIDTH/bitmapData.width
				this.scaleY = Settings.BLOCK_WIDTH / bitmapData.height
				
			}
		}
		
	}

}