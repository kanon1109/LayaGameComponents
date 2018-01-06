package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.maths.Point;
import laya.ui.Image;
import laya.utils.Handler;

/**
 * ...滑动条
 * @author ...Kanon
 */
public class Slider extends Sprite 
{
	//滑块
	private var thumbImg:Image;
	//进度背景
	private var barImg:Image;
	//底板
	private var barBgImg:Image;
	//当前值
	private var _value:int = 0;
	//值间隔
	public var step:int = 1;
	//最大值
	private var _maxValue:int = 100;
	//最小值
	private var _minValue:int = 0;
	//是否横向
	private var _isHorizontal:Boolean;
	//最大宽度
	private var maxWidth:Number;
	//移动的回调
	public var onThumbMoveHandler:Handler;
	public function Slider(thumbImgSkin:String, barBgImgSkin:String, barImgSkin:String="") 
	{
		this.barBgImg = new Image(barBgImgSkin);
		this.addChild(this.barBgImg);
		
		this.barImg = new Image(barImgSkin);
		this.maxWidth = this.barImg.width;
		this.addChild(this.barImg);
		
		this.thumbImg = new Image(thumbImgSkin);
		this.thumbImg.anchorX = .5;
		this.addChild(this.thumbImg);
		this.thumbImg.on(Event.MOUSE_DOWN, this, thumbOnMouseDown);
		Laya.stage.on(Event.MOUSE_UP, this, thumbOnMouseUp);
		this.barBgImg.on(Event.MOUSE_DOWN, this, barOnMouseDown);
	}
	
	private function barOnMouseDown(event:Event):void 
	{
		var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY), true);
		this.value = Math.round(pt.x /  this.barBgImg.width * 100);
		if (this.onThumbMoveHandler)
			this.onThumbMoveHandler.runWith(this._value);
	}
	
	private function thumbOnMouseUp(event:Event):void 
	{
		this.off(Event.MOUSE_MOVE, this, thumbOnMouseMove);
	}
	
	private function thumbOnMouseMove(event:Event):void 
	{
		var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY), true);
		this.thumbImg.x = pt.x;
		if (this.thumbImg.x < this.thumbImg.width / 2) 
			this.thumbImg.x = this.thumbImg.width / 2;
		else if (this.thumbImg.x > this.barBgImg.width - this.thumbImg.width / 2) 
			this.thumbImg.x = this.barBgImg.width - this.thumbImg.width / 2;
		this._value = Math.round((this.thumbImg.x - this.thumbImg.width / 2) / (this.barBgImg.width - this.thumbImg.width) * (maxValue - minValue));
		this.barImg.width = _value / (maxValue - minValue) * this.maxWidth;
		if (this.onThumbMoveHandler)
			this.onThumbMoveHandler.runWith(this._value);
	}
	
	private function thumbOnMouseDown(event:Event):void 
	{
		this.on(Event.MOUSE_MOVE, this, thumbOnMouseMove);
	}
	
	public function get value():int {return _value; }
	public function set value(value:int):void 
	{
		_value = value;
		if (value < minValue) value = minValue;
		if (value > maxValue) value = maxValue;
		this.thumbImg.x = _value / (maxValue - minValue) * (this.barBgImg.width - this.thumbImg.width) + this.thumbImg.width / 2;
		this.barImg.width = _value / (maxValue - minValue) * this.maxWidth;
	}
	
	/**
	 * 最大值
	 */
	public function get maxValue():int {return _maxValue; }
	public function set maxValue(value:int):void 
	{
		if (value < this._minValue) value = this._minValue;
		_maxValue = value;
	}
	
	/**
	 * 最小值
	 */
	public function get minValue():int {return _minValue;}
	public function set minValue(value:int):void 
	{
		if (value > this._maxValue) value = this._maxValue;
		_minValue = value;
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		if (this.thumbImg)
		{
			this.thumbImg.off(Event.MOUSE_DOWN, this, thumbOnMouseDown);
			this.thumbImg.off(Event.MOUSE_UP, this, thumbOnMouseUp);
			this.thumbImg.destroy();
			this.thumbImg.removeSelf();
			this.thumbImg = null;
		}
		
		if (this.barImg)
		{
			this.barImg.destroy();
			this.barImg.removeSelf();
			this.barImg = null;
		}
		
		if (this.barBgImg)
		{
			this.barBgImg.off(Event.MOUSE_DOWN, this, barOnMouseDown);
			this.barBgImg.destroy();
			this.barBgImg.removeSelf();
			this.barBgImg = null;
		}
		this.onThumbMoveHandler = null;
		Laya.stage.off(Event.MOUSE_UP, this, thumbOnMouseUp);
		this.destroy();
		this.removeSelf();
	}
}
}