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
	//是否调试
	private var _isDrawDebug:Boolean;
	//固定类型
	public var fixType:int = 0;
	//固定状态枚举
	public static const FIXED:int = 0; //固定摇杆
	public static const UNFIXED:int = 1;//不固定（点击任意位置作为起点，并且摇杆跟随拖动的位置移动）
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
		this._rate = 1;
		this.maxRadius = 100;
		this._joystickAngleRad = 0;
		this._isDrawDebug = false;
		this.fixType = Joystick.FIXED;
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
		this.isMouseDown = true;
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
		Laya.stage.on(Event.MOUSE_OUT, this, onMouseUpHandler);
		this.frameLoop(1, this, loopHandler)
		
		if (this.fixType == Joystick.UNFIXED)
			this.setStickPos(mouseX, mouseY);
			
		if (this.mouseMoveHandler)
			this.mouseMoveHandler.run();
	}
	
	private function loopHandler():void 
	{
		this.curPt.x = mouseX;
		this.curPt.y = mouseY;
		
		this._dx = this.curPt.x - this.prevPt.x;
		this._dy = this.curPt.y - this.prevPt.y;
		
		this._joystickAngleRad = Math.atan2(this._dy, this._dx);
		
		var dis:Number = this.curPt.distance(this.prevPt.x, this.prevPt.y);
		if (this.fixType == Joystick.FIXED && dis > this.maxRadius) dis = this.maxRadius; 
		
		var x:Number = Math.cos(this._joystickAngleRad) * dis + this.prevPt.x;
		var y:Number = Math.sin(this._joystickAngleRad) * dis + this.prevPt.y;
		
		if (this.stickImg)
		{
			this.stickImg.x = x;
			this.stickImg.y = y;
		}
		
		if (this.fixType == Joystick.UNFIXED)
		{
			if (dis >= this.maxRadius)
			{
				var sx:Number = Math.cos(this._joystickAngleRad) * this.maxRadius;
				var sy:Number = Math.sin(this._joystickAngleRad) * this.maxRadius;
				this.prevPt.x = x - sx;
				this.prevPt.y = y - sy;
				if (this.baseImg)
				{
					this.baseImg.x = this.prevPt.x;
					this.baseImg.y = this.prevPt.y;
				}
			}
		}
		
		this._rate = dis / this.maxRadius;
		
		if (this.mouseMoveHandler)
			this.mouseMoveHandler.run();
	}
	
	private function onMouseUpHandler():void 
	{
		this.isMouseDown = false;
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		Laya.stage.off(Event.MOUSE_OUT, this, onMouseUpHandler);
		this.clearTimer(this, loopHandler);
		
		this.stickImg.x = this.prevPt.x;
		this.stickImg.y = this.prevPt.y;
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
				this.baseImg.anchorX = .5;
				this.baseImg.anchorY = .5;
				this.addChild(this.baseImg);
			}
			else
			{
				this.baseImg.skin = base;
			}
		}
		
		if (stick)
		{
			if (!this.stickImg)
			{
				this.stickImg = new Image(stick);
				this.stickImg.anchorX = .5;
				this.stickImg.anchorY = .5;
				this.addChild(this.stickImg);
			}
			else
			{
				this.stickImg.skin = stick;
			}
		}
		this.setStickPos(this.prevPt.x, this.prevPt.y);
	}
	
	/**
	 * 设置摇杆的位置
	 * @param	x	x位置
	 * @param	y	y位置
	 */
	public function setStickPos(x:Number, y:Number):void
	{
		this.prevPt.x = x;
		this.prevPt.y = y;
		this.curPt.x = this.prevPt.x;
		this.curPt.y = this.prevPt.y;
		if (this.baseImg)
		{
			this.baseImg.x = x;
			this.baseImg.y = y;
			
		}
		if (this.stickImg)
		{
			this.stickImg.x = x;
			this.stickImg.y = y;
		}
	}
	
	/**
	 * 摇杆强弱
	 */
	public function get rate():Number {return _rate; }
	
	/**
	 * 摇杆的弧度
	 */
	public function get joystickAngleRad():Number {return _joystickAngleRad; }
	
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
	 * 是否绘制调试
	 */
	public function get isDrawDebug():Boolean {return _isDrawDebug; }
	public function set isDrawDebug(value:Boolean):void 
	{
		_isDrawDebug = value;
		this.graphics.clear(true);
		if (value) this.graphics.drawRect(0, 0, this.width, this.height, "#666666");
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		this.clearTimer(this, loopHandler);
		
		if (this.baseImg)
		{
			this.baseImg.destroy();
			this.baseImg.removeSelf();
			this.baseImg = null;
		}
		
		if (this.stickImg)
		{
			this.stickImg.destroy();
			this.stickImg.removeSelf();
			this.stickImg = null;
		}
		
		this.mouseMoveHandler = null;
		
		this.destroy();
		this.removeSelf();
	}
}
}

