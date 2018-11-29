package components 
{
import laya.events.Event;
import laya.maths.Point;
/**
 * ...上下左右滑动基本手势
 * @author Kanon
 */
public class Gestures 
{
	//点击位置
	private var touchPos:Point;
	//操作间隔
	private var delta:Number;
	//手势状态
	private var _state:int;
	//滑动最小像素距离
	private var minDis:Number = 10;
	//滑动最小时间间隔
	private var minDelta:Number = 1000;
	//方向
	public static const NONE:int = 0;
	public static const UP:int = 1;
	public static const DOWN:int = 2;
	public static const LEFT:int = 3;
	public static const RIGHT:int = 4;
	public function Gestures() 
	{
		this.touchPos = new Point();
		this._state = Gestures.NONE;
		Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
	}
	
	private function onMouseDownHandler(event:Event):void 
	{
		this._state = Gestures.NONE;
		this.touchPos.x = event.stageX;
		this.touchPos.y = event.stageY;
		this.delta = 0;
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
		Laya.stage.frameLoop(1, this, loop);
	}
	
	private function onMouseUpHandler():void 
	{
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		Laya.stage.clearTimer(this, loop);
		this._state = Gestures.NONE;
	}
	
	private function loop():void 
	{
		//小于一秒内的操作
		this.delta += Laya.stage.timer.delta;
		if (this.delta <= this.minDelta && 
			this.touchPos.distance(Laya.stage.mouseX, Laya.stage.mouseY) >= this.minDis)
		{
			//判断手势
			var disX:Number = this.touchPos.x - Laya.stage.mouseX;
			var disY:Number = this.touchPos.y - Laya.stage.mouseY;
			if (disY < 0)
			{
				if (Math.abs(disY) > Math.abs(disX)) 
					this._state = Gestures.DOWN;
			}
			else 
			{
				if (Math.abs(disY) > Math.abs(disX)) 
					this._state = Gestures.UP;
			}
			if (disX < 0)
			{
				if (Math.abs(disY) < Math.abs(disX)) 
					this._state = Gestures.RIGHT;
			}
			else 
			{
				if (Math.abs(disY) < Math.abs(disX)) 
					this._state = Gestures.LEFT;
			}
		}
		else
		{
			this._state = Gestures.NONE;
			this.touchPos.x = Laya.stage.mouseX;
			this.touchPos.y = Laya.stage.mouseY;
			this.delta = 0;
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.touchPos = null;
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		Laya.stage.clearTimer(this, loop);
	}
	
	/**
	 * 获取当前手势状态
	 */
	public function get state():int{ return _state; }
	
}
}