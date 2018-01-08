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
	//最大宽度
	private var maxWidth:Number;
	//点击目标的位置
	private var targetX:Number;
	//点击条时的移动量
	private var _page:int;
	private var pageValue:Number;
	private var isAdd:Boolean;
	//移动的回调
	public var onThumbMoveHandler:Handler;
	//点击条时移动的模式
	public var trackInteractionMode:int;
	public static const VALUE:int = 0;
	public static const PAGE:int = 1;
	public function Slider(thumbImgSkin:String, barBgImgSkin:String, barImgSkin:String="") 
	{
		this.trackInteractionMode = Slider.VALUE;
		this.barBgImg = new Image(barBgImgSkin);
		this.addChild(this.barBgImg);
		
		this.barImg = new Image(barImgSkin);
		this.maxWidth = this.barImg.width;
		this.addChild(this.barImg);
		
		this.page = 20;
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
		if (this.trackInteractionMode == Slider.VALUE)
		{
			this.updateValueByPosX(pt.x);
		}
		else
		{
			this.targetX = pt.x;
			this.isAdd = this.targetX > this.thumbImg.x;
			if (this.isAdd)
				this.updateValueByPosX(this.thumbImg.x - this.thumbImg.width / 2 + this.pageValue);
			else
				this.updateValueByPosX(this.thumbImg.x + this.thumbImg.width / 2 - this.pageValue);
				
			this.barBgImg.on(Event.MOUSE_MOVE, this, barOnMouseMove);
			Laya.timer.once(300, this, delayCallBackHandler);
		}
	}
	
	private function barOnMouseMove(event:Event):void 
	{
		var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY), true);
		this.targetX = pt.x;
	}
	
	private function delayCallBackHandler():void 
	{
		this.frameLoop(5, this, loopHandler);
	}
	
	private function loopHandler():void 
	{
		if (this.isAdd)
			this.updateValueByPosX(this.thumbImg.x - this.thumbImg.width / 2 + this.pageValue);
		else
			this.updateValueByPosX(this.thumbImg.x + this.thumbImg.width / 2 - this.pageValue);
	}
	
	private function thumbOnMouseUp(event:Event):void 
	{
		this.clearTimer(this, loopHandler);
		Laya.timer.clear(this, delayCallBackHandler);
		this.off(Event.MOUSE_MOVE, this, thumbOnMouseMove);
		if (this.trackInteractionMode == Slider.PAGE)
			this.clearTimer(this, loopHandler);
	}
	
	private function thumbOnMouseMove(event:Event):void 
	{
		var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY), true);
		this.updateValueByPosX(pt.x);
	}
	
	/**
	 * 根据x坐标更新value
	 * @param	x	x坐标
	 */
	private function updateValueByPosX(x:Number):void
	{
		this.thumbImg.x = x;
		this.fixRange();
		this._value = Math.round((this.thumbImg.x - this.thumbImg.width / 2) / (this.barBgImg.width - this.thumbImg.width) * (maxValue - minValue));
		this.barImg.width = this.thumbImg.x;
		if (this.onThumbMoveHandler)
			this.onThumbMoveHandler.runWith(this._value);
	}
	
	private function thumbOnMouseDown(event:Event):void 
	{
		this.on(Event.MOUSE_MOVE, this, thumbOnMouseMove);
	}
	
	/**
	 * 修正移动范围
	 */
	private function fixRange():void
	{
		if (this.trackInteractionMode == Slider.PAGE)
		{
			if (this.isAdd)
			{
				if (this.thumbImg.x > this.targetX)
					this.thumbImg.x = this.targetX;
			}
			else
			{
				if (this.thumbImg.x < this.targetX)
					this.thumbImg.x = this.targetX;
			}
		}
		
		if (this.thumbImg.x < this.thumbImg.width / 2) 
			this.thumbImg.x = this.thumbImg.width / 2;
		else if (this.thumbImg.x > this.barBgImg.width - this.thumbImg.width / 2) 
			this.thumbImg.x = this.barBgImg.width - this.thumbImg.width / 2;
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
	 * 点击条时的移动量
	 */
	public function get page():int {return _page; }
	public function set page(value:int):void 
	{
		_page = value;
		this.pageValue = this.maxWidth / value;
		trace("pageValue", this.pageValue);
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
			this.barBgImg.off(Event.MOUSE_MOVE, this, barOnMouseMove);
			this.barBgImg.off(Event.MOUSE_DOWN, this, barOnMouseDown);
			this.barBgImg.destroy();
			this.barBgImg.removeSelf();
			this.barBgImg = null;
		}
		this.onThumbMoveHandler = null;
		Laya.timer.clear(this, delayCallBackHandler);
		Laya.stage.off(Event.MOUSE_UP, this, thumbOnMouseUp);
		this.clearTimer(this, loopHandler);
		this.off(Event.MOUSE_MOVE, this, thumbOnMouseMove);
		this.destroy();
		this.removeSelf();
	}
}
}