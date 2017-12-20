package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.maths.Point;
import laya.ui.Image;
import laya.utils.Handler;
/**
 * ...摇杆
 * @author ...Kanon
 */
public class Joystick extends Sprite 
{
	//移动时的回调
	public var mouseMoveHandler:Handler;
	//摇杆移动范围的最大半径
	public var maxRadius:Number = 100;
	//移动的强弱值
	private var _rate:Number = 1;
	//摇杆的角度（弧度）
	private var _joystickAngleRad:Number;
	//底座
	private var baseImg:Image;
	//摇杆
	private var stickImg:Image;
	//是否按下
	private var isMouseDown:Boolean;
	//起始位置
	private var prevPt:Point;
	//当前位置
	private var curPt:Point;
	//x坐标上向量
	private var _dx:Number;
	//y坐标上向量
	private var _dy:Number;
	//固定类型
	public static var FIX_TYPE:int = 0;
	//固定状态枚举
	public static const FIXED:int = 0; //固定摇杆
	public static const UNFIXED:int = 1;//不固定（点击任意位置作为起点，并且摇杆跟随拖动的位置移动）
	public static const HALF_FIXED:int = 2;//半固定（点击任意位置作为起点）
	public function Joystick() 
	{
		this.initData();
		this.initEvent();
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		Joystick.FIX_TYPE = Joystick.FIXED;
		this.prevPt = new Point(this.width / 2, this.height / 2);
		this.curPt = new Point(this.prevPt.x, this.prevPt.y);
	}
	
	/**
	 * 初始化事件
	 */
	private function initEvent():void
	{
		this.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
	}
	
	private function onMouseDownHandler():void 
	{
		trace("mouse down");
		this.isMouseDown = true;
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
		this.frameLoop(1, this, loopHandler)
	}
	
	private function loopHandler():void 
	{
		this.curPt.x = mouseX;
		this.curPt.y = mouseY;
		
		this._dx = this.curPt.x - this.prevPt.x;
		this._dy = this.curPt.y - this.prevPt.y;
		
		this._joystickAngleRad = Math.atan2(this._dy, this._dx);
		
		var dis:Number = this.curPt.distance(this.prevPt.x, this.prevPt.y);
		if (dis > this.maxRadius) dis = this.maxRadius; 
		
		var x:Number = Math.cos(this._joystickAngleRad) * dis;
		var y:Number = Math.sin(this._joystickAngleRad) * dis;
		
		if (this.stickImg)
		{
			this.stickImg.x = this.prevPt.x + x;
			this.stickImg.y = this.prevPt.y + y;
		}
		this._rate = dis / this.maxRadius;
		
		if (this.mouseMoveHandler)
			this.mouseMoveHandler.run();
	}
	
	private function onMouseUpHandler():void 
	{
		this.isMouseDown = false;
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		this.clearTimer(this, loopHandler);
		
		
		this.stickImg.x = this.baseImg.width / 2;
		this.stickImg.y = this.baseImg.height / 2;
	}
	
	/**
	 * 初始化UI
	 * @param	stick	摇杆
	 * @param	base	底座
	 */
	public function initUI(stick:String="", base:String=""):void
	{
		if (base && !this.baseImg)
		{
			if (!this.baseImg)
			{
				this.baseImg = new Image(base);
				this.addChild(this.baseImg);
			}
			else
			{
				this.baseImg.skin = base;
			}
			this.size(this.baseImg.width, this.baseImg.height);
			this.pivot(this.baseImg.width / 2, this.baseImg.height / 2);
			this.prevPt.x = this.width / 2;
			this.prevPt.y = this.height / 2;
			this.curPt.x = this.prevPt.x;
			this.curPt.y = this.prevPt.y;
		}
		
		if (stick)
		{
			if (!this.stickImg)
			{
				this.stickImg = new Image(stick);
				this.stickImg.anchorX = .5;
				this.stickImg.anchorY = .5;
				this.stickImg.x = this.baseImg.x + this.baseImg.width / 2;
				this.stickImg.y = this.baseImg.y + this.baseImg.height / 2;
				this.addChild(this.stickImg);
			}
			else
			{
				this.stickImg.skin = stick;
			}
		}
	}
	
	/**
	 * 设置摇杆的位置
	 * @param	x	x位置
	 * @param	y	y位置
	 */
	public function setStickPos(x:Number, y:Number):void
	{
		if (this.baseImg)
		{
			this.baseImg.x = x;
			this.baseImg.y = y;
			if (this.stickImg)
			{
				this.stickImg.x = this.baseImg.x + this.baseImg.width / 2;
				this.stickImg.y = this.baseImg.y + this.baseImg.height / 2;
			}
		}

	}
	
	/**
	 * 摇杆强弱
	 */
	public function get rate():Number {return _rate; }
	
	/**
	 * 摇杆的弧度
	 */
	public function get joystickAngleRad():Number {return _joystickAngleRad; };
	
	/**
	 * 摇杆的角度
	 */
	public function get joystickAngleDeg():Number 
	{
		return _joystickAngleRad * 180 / Math.PI;
	}
	
	/**
	 * x坐标上向量
	 */
	public function get dx():Number{return _dx; }
	
	/**
	 * y坐标上向量
	 */
	public function get dy():Number{return _dy; }
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		this.clearTimer(this, loopHandler);
		
		if (this.baseImg)
		{
			this.baseImg.removeSelf();
			this.baseImg = null;
		}
		
		if (this.stickImg)
		{
			this.stickImg.removeSelf();
			this.stickImg = null;
		}
		
		this.mouseMoveHandler = null;
		
		this.destroy();
		this.removeSelf();
	}
}
}

