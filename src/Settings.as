package  
{
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Settings {
		public static var BLOCK_WIDTH:Number = 41
		public static var MAP_WIDTH:Number = 600
		public static var MAP_HEIGHT:Number = 600
		public static var OBJ_INDEX:int = 1
		public static var HIGHLIGHT_GLOW:GlowFilter = new GlowFilter(0xFFFFFF, 1, 3,3,2,3)
		public static var SELECTION_GLOW:GlowFilter = new GlowFilter(0x00FF00, 1, 3,3,2,3)
	}

}