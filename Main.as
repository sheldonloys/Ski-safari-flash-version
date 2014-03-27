package
{
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Sheldonloys
	 */
	public class Main extends MovieClip
	{
		
		var _player:PlayerControl = new PlayerControl(); //玩家
		private var _deltaX:Number = 9; //地形曲线的光滑程度,越小越光滑,但是负担越大,
		//同时也是速度
		private var _deltaYArr:Array = new Array(); //记录y的增量
		
		private var _Lineoldx0:Number = 0; //确定函数图像的起始点
		private var _Lineoldy0:Number = 0; //确定函数图像的起始点
		private var _oldx0:Number = 1028; //确定函数图像的起始点
		private var _oldy0:Number = 0; //确定函数图像的起始点
		private var _newx0:Number = 0; //确定函数图像的终点
		private var _newy0:Number = 0; //确定函数图像的终点
		
		private var _lineObjArr:Array = new Array(); //存储当前存在视觉范围内的line用于碰撞检测
		private var _lineArr:Array = new Array(); //存储当前视觉范围内的line的连续点的坐标
		private var _line:Sprite; //存储地形一小段直线
		private var _ground:Sprite = new Sprite(); //地形元件
		private var _aaa:int = 0;
		private var _bbb:int = 1; //每帧绘制线段
		private var _thetaArr:Array = new Array(); //存储曲线上的斜率
		private var _a:Number = 1 / 70
		private var _b:Number = 0
		private var _c:Number = 82
		
		private var ttt:int = 1078; //测试留属性.之后改成随机值
		private var ccc:int = 1; //测试留属性.之后改成随机值
		private var _fuhao:int = 1; //确定函数开口向上还是向下
		
		public function Main()
		{
			GetReadyForGame(); //游戏准备,初始化游戏
			//DrawCurve();
			//stage.addEventListener(MouseEvent.CLICK, onPlayerJump); //玩家的跳跃动作,先用鼠标测试
			//this.addEventListener(Event.ENTER_FRAME, GameCamera);
			//this.addEventListener(Event.ENTER_FRAME, onPlayerMove); //主角移动
		}
		
		//玩家的跳跃方法
		private function onPlayerJump(e:MouseEvent)
		{
			if (_player.playerIsJump)
			{
				return;
			}
			_player.playerJump();
			this.addEventListener(Event.ENTER_FRAME, CollisionTest); //此时开启碰撞检测
			//跳起后改用玩家的跳起函数
			/*	var _x1:Number;
			   var _y1:Number;
			   _x1 = _lineArr[_aaa].x + _deltaX;
			 _y1 = _lineArr[_aaa].y - _deltaYArr[ccc] + (_thetaArr[_aaa] - (0.6 * 180 / Math.PI)) / _thetaArr[_aaa] * _deltaYArr[ccc]*/
			//_player.JumpFormula(_lineArr[_aaa].x, _lineArr[_aaa].y, _x1, _y1);
			_player.JumpFormula(_lineArr[_aaa].x, _lineArr[_aaa].y);
			//trace (_thetaArr[_aaa]);
		}
		
		private function GetReadyForGame()
		{
			_ground.addChild(_player);
			//_ground.y = 700 * (1 - 0.618);
			_ground.y = 500;
			_ground.x = 0;
			this.addChild(_ground);
			
			for (var x0:int = 0; x0 < 1028; x0 = x0 + _deltaX)
			{
				var y0:Number = 1 / 13000 * (Math.pow(x0, 2));
				DrawDeltaLine(_Lineoldx0, _Lineoldy0, x0, y0); //绘制曲线增量
				_thetaArr.push(Math.atan2((y0 - _Lineoldy0), (x0 - _Lineoldx0)) * 180 / Math.PI);
				_Lineoldx0 = x0;
				_Lineoldy0 = y0;
			}
			
			_player.x = _lineArr[50];
			_aaa = ccc = 50; //设定玩家的初始位置
			this.addEventListener(Event.ENTER_FRAME, GameStart);
			this.addEventListener(Event.ENTER_FRAME, onPlayerMove);
			this.addEventListener(Event.ENTER_FRAME, GameCamera); //镜头跟踪
			this.addEventListener(Event.ENTER_FRAME, DrawCurve); //此方法是绘制地形曲面
		}
		
		private function GameStart(e:Event) //游戏真正开始,开始绘制地图和角色可以控制
		{
			if (_player.x >= 1027)
			{
				trace(12312312);
				this.removeEventListener(Event.ENTER_FRAME, GameStart);
				//this.addEventListener(Event.ENTER_FRAME, CleanGroundSprites);
				stage.addEventListener(MouseEvent.CLICK, onPlayerJump);
					//this.addEventListener(Event.ENTER_FRAME, onPlayerMove);
			}
		}
		
		//此方法是绘制地形曲面
		public function DrawCurve(e:Event)
		{
			//for (var x0:int = 0; x0 < 8000; x0 = x0 + _deltaX)
			//{
			var x0:Number;
			x0 = 1027 + _bbb * _deltaX;
			var y0:Number = SetFormula(x0);
			DrawDeltaLine(_Lineoldx0, _Lineoldy0, x0, y0); //绘制曲线增量
			//_deltaYArr.push(y0 - _Lineoldy0);
			_thetaArr.push(Math.atan2((y0 - _Lineoldy0), (x0 - _Lineoldx0)) * 180 / Math.PI);
			//trace (Math.atan2((SetFormula(x0) - _oldy0),(x0 - _oldx0)));
			_Lineoldx0 = x0;
			_Lineoldy0 = y0;
			_bbb++;
			//}
			//trace (_xArr, _yArr);
		}
		
		//此方法定义了初始地形的曲面方程/
		private function SetFormula(_x:Number):Number
		{
			_x = _x - 1028
			if ((_x + 1028) >= ttt)
			{
				_fuhao = _fuhao * (-1);
				_oldx0 = _x;
				_oldy0 = _a * (Math.pow(_x, 2)) + _b * (_x) + _c;
				_newx0 = _x + _deltaX;
				_newy0 = _a * (Math.pow(_newx0, 2)) + _b * (_newx0) + _c;
				GetFormula(_oldx0, _oldy0, _newx0, _newy0);
					//_a = 0; 
					//_b = 0;
					//_c = 0;
					//trace (_oldx0, _oldy0, _newx0, _newy0);
			}
			var _y = _a * (Math.pow(_x, 2)) + _b * (_x) + _c;
			return _y;
		}
		
		//改变地形的曲面
		private function GetFormula(_x0:Number, _y0:Number, _x1:Number, _y1:Number)
		{
			//trace (_a, _b, _c);
			if (_fuhao == -1) //flash坐标 a的符号为负,开口向上
			{
				_a = 1 / randomNum(700, 800) * _fuhao;
				_b = -(_a * (Math.pow(_x1, 2) - Math.pow(_x0, 2)) - (_y1 - _y0)) / (_x1 - _x0);
				_c = _y0 - _a * Math.pow(_x0, 2) - _b * _x0;
				ttt = Math.ceil(-(_b / 2 / _a) + randomNum(70, 90)) + 1028;
			}
			else if (_fuhao == 1)
			{
				_a = 1 / randomNum(2000, 2300) * _fuhao;
				_b = -(_a * (Math.pow(_x1, 2) - Math.pow(_x0, 2)) - (_y1 - _y0)) / (_x1 - _x0);
				_c = _y0 - _a * Math.pow(_x0, 2) - _b * _x0;
				ttt = Math.ceil(-(_b / 2 / _a) + randomNum(800, 1200)) + 1028;
			}
			else
			{
				
			}
			//trace( ttt);
		}
		
		//此方法是曲面细分直线//正式版改成绘制有填充的四边形
		private function DrawDeltaLine(_x0:Number, _y0:Number, _x1:Number, _y1:Number)
		{
			_line = new Sprite();
			var _point:Point = new Point();
			_deltaYArr.push(_y1 - _y0);
			_line.graphics.lineStyle(0,0,0);
			_line.graphics.beginFill(0xffffff);
			_line.graphics.moveTo(_x0, _y0);
			_line.graphics.lineTo(_x0, _y0+500);
			_line.graphics.lineTo(_x1, _y1+500);
			_line.graphics.lineTo(_x1, _y1);
			//_line.graphics.lineTo(_x1, _y1+400);
            _line.graphics.endFill ();
			_point.x = _x0;
			_point.y = _y0;
			_lineObjArr.push(_line);
			_lineArr.push(_point);
			_ground.addChild(_line);
			//trace (_ground.height);
			//this.addChild(_ground);
		}
		
		//碰撞检测
		private function CollisionTest(e:Event):void
		{
			if (_player.y > (_lineArr[_aaa].y - _deltaYArr[ccc]))
			{
				//trace(1111111111111);
				_player.playerGround();
				this.removeEventListener(Event.ENTER_FRAME, CollisionTest);
			}
			else
			{
				
			}
		}
		
		//随机数方法
		private function randomNum(min:int, max:int):int
		{
			return Math.random() * (max - min + 1) + min;
		}
		
		//主角移动
		private function onPlayerMove(e:Event):void
		{
			if (!_player.playerIsJump)
			{
				_player.x = _lineArr[_aaa].x - _deltaX
				_player.y = _lineArr[_aaa].y - _deltaYArr[ccc];
				_player.rotation = _thetaArr[_aaa];
			}
			else
				//玩家跳起后函数
			{
				_player.x = _lineArr[_aaa].x - _deltaX;
				_player.y = _lineArr[_aaa].y - _deltaYArr[ccc] - _player.playerJumpY(_player.x + _deltaX + _deltaX);
				//trace (_player.y,_lineArr[_aaa].y - _deltaYArr[ccc]);
				_player.playerRotation(_player.x, _player.y);
				_player.rotation = _player._theta;
					//_player.rotation = _thetaArr[_aaa];
			}
			_aaa++;
		}
		
		//地形移动
		private function GameCamera(e:Event):void
		{
			_ground.x -= _deltaX;
			_ground.y -= _deltaYArr[ccc];
			BackGround.x -= 0.2
			ccc++;
			
			_ground.removeChild(_lineObjArr[0]);
			_lineObjArr[0] = null;
			_lineObjArr.shift();
		
		}
	
	}

}