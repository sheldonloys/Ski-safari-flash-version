package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Sheldonloys
	 */
	public class PlayerControl extends MovieClip
	{
		
		public var _jump : Boolean = false;
		public var _theta:Number ;
		private var _a:Number = 0
		private var _b:Number = 0
		private var _c:Number = 0
		private var _x0 :Number ;//起始点x坐标，人物跳跃要换算成这里的坐标
		private var _oldX : Number;
		private var _oldY : Number;
		private var _jumpHeight: int = 100;//玩家跳起的高度
		
		public function PlayerControl() 
		{
			
		}
		
		//人物弹跳统一用一个方程
		public function JumpFormula (x0:Number,y0:Number):void
		{
			_x0 = x0;
			_a = -1 / 700 ;
			//_b = -(_a * (Math.pow(_x1, 2) - Math.pow(_x0, 2)) - (_y1 - _y0)) / (_x1 - _x0);
			_b = Math.sqrt( -(_jumpHeight) * 4 * _a);
			_oldX = x0;
			_oldY = y0;
		}
		
		public function playerJumpY (_x):Number
		{
			var _y = _a * (Math.pow((_x-_x0), 2)) + _b * ((_x-_x0)) 
			return _y;
		}
		
		public function playerRotation (_x:Number,_y:Number) :void
		{
			_theta = Math.atan2((_y - _oldY), (_x - _oldX)) * 180 / Math.PI;
			_oldX = _x;
			_oldY = _y;
		}
		
		public function  playerJump () : void 
		{
			_jump = true;
		}
		
		public function  playerGround () : void 
		{
			_jump = false;
		}
		
		public function get playerIsJump () :Boolean
		{
			return _jump;
		}
	}

}