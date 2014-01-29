package  
{
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	
	 import flash.utils.getTimer
	public class Effect 
	{
		public var type:String
		public var pow:Number
		public var duration:Number
		public var applyTime:Number
		public var sigmaEffect:Number = 0
		
		public function Effect() 
		{
			applyTime = getTimer()
		}
		
	}

}