package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.maths.Point;
import laya.ui.Image;
import laya.utils.Handler;
import utils.MathUtil;

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
	private var _step:int = 1;
	//最大值
	private var _maxValue:int = 100;
	//最小值
	private var _minValue:int = 0;
	//最大宽度
	private var maxWidth:Number;
	//点击目标的位置
	private var targetValue:int;
	//点击条时的移动量
	private var _page:int;
	private var maxPage:int = 20;
	//是否持续增加
	private var isAdd:Boolean;
	//是否按下
	private var isMouseDown:Boolean;
	//移动的回调
	public var onThumbMoveHandler:Handler;
	//点击条时移动的模式
	public var trackInteractionMode:int;
	public static const VALUE:int = 0;
	public static const PAGE:int = 1;
	public function Slider(thumbImgSkin:String, barBgImgSkin:String, barImgSkin:String = "")
	{
		this.trackInteractionMode = Slider.VALUE;
		this.barBgImg = new Image(barBgImgSkin);
		this.addChild(this.barBgImg);
		
		this.barImg = new Image(barImgSkin);
		this.maxWidth = this.barImg.width;
		this.addChild(this.barImg);
		
		this.thumbImg = new Image(thumbImgSkin);
		this.thumbImg.anchorX = .5;
		this.addChild(this.thumbImg);
		this.thumbImg.on(Event.MOUSE_DOWN, this, onThumbMouseDown);
		this.barBgImg.on(Event.MOUSE_DOWN, this, onBarMouseDown);
		Laya.stage.on(Event.MOUSE_UP, this, onStageMouseUp);
		this.page = 20;
	}
	
	private function onBarMouseDown(event:Event):void 
	{
		var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY), true);
		if (this.trackInteractionMode == Slider.VALUE)
		{
			this.value = pt.x / this.maxWidth * (this._maxValue - this._minValue);
			this.value = MathUtil.roundToNearest(this._value, this._step);
		}
		else
		{
			this.isMouseDown = true;
			this.targetValue = pt.x / this.maxWidth * (this._maxValue - this._minValue);
			this.targetValue = MathUtil.roundToNearest(this.targetValue, this._step);
			this.isAdd = pt.x > this.thumbImg.x;
			if (this.isAdd)
			{
				this.value += this._page;
				if (this._value > this.targetValue)
					this.value = this.targetValue;
			}
			else
			{
				this.value -= this._page;
				if (this._value < this.targetValue)
					this.value = this.targetValue;
			}
			if (this.onThumbMoveHandler) 
				this.onThumbMoveHandler.runWith(this._value);
			Laya.stage.on(Event.MOUSE_MOVE, this, onStageMouseMove);
			Laya.timer.once(260, this, delayCallBackHandler);
		}
	}
	
	private function delayCallBackHandler():void 
	{
		this.frameLoop(5, this, loopHandler);
	}
	
	private function loopHandler():void 
	{
		if (this.isAdd)
		{
			this.value += this._page;
			if (this._value > this.targetValue)
				this.value = this.targetValue;
		}
		else
		{
			this.value -= this._page;
			if (this._value < this.targetValue)
				this.value = this.targetValue;
		}
			
		if (this.onThumbMoveHandler) 
			this.onThumbMoveHandler.runWith(this._value);
	}
	
	private function onStageMouseUp(event:Event):void 
	{
		this.isMouseDown = false;
		this.clearTimer(this, loopHandler);
		Laya.timer.clear(this, delayCallBackHandler);
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
		if (this.trackInteractionMode == Slider.PAGE)
			this.clearTimer(this, loopHandler);
	}
	
	private function onStageMouseMove(event:Event):void 
	{
		var pt:Point = this.globalToLocal(new Point(event.stageX, event.stageY), true);
		if (!this.isMouseDown)
		{
			var step:Number = pt.x / this.maxWidth * (this._maxValue - this._minValue);
			this.value = MathUtil.roundToNearest(step, this._step);
			if (this.onThumbMoveHandler) this.onThumbMoveHandler.runWith(this._value);
		}
		else
		{
			this.targetValue = pt.x / this.maxWidth * (this._maxValue - this._minValue);
			this.targetValue = MathUtil.roundToNearest(this.targetValue, this._step);
		}
	}
	
	private function onThumbMouseDown(event:Event):void 
	{
		Laya.stage.on(Event.MOUSE_MOVE, this, onStageMouseMove);
	}
	
	/**
	 * 当前值
	 */
	public function get value():int {return _value; }
	public function set value(value:int):void 
	{
		_value = value;
		if (_value < this._minValue) _value = this._minValue;
		if (_value > this._maxValue) _value = this._maxValue;
		this.thumbImg.x = _value / (this._maxValue - this._minValue) * (this.barBgImg.width - this.thumbImg.width) + this.thumbImg.width / 2;
		this.barImg.width = _value / (this._maxValue - this._minValue) * this.maxWidth;
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
		if (_page < 1) _page = 1;
		if (_page > maxPage) _page = maxPage;
		if (_page < this._step) _page = this._step;
	}

	/**
	 * 拖动的间隔步长
	 */
	public function get step():int {return _step;}
	public function set step(value:int):void 
	{
		_step = value;
		if (_step < 1) _page = 1;
		if (_step > maxPage) _step = maxPage;
		if (_step > this._page) this._page = _step;
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		if (this.thumbImg)
		{
			this.thumbImg.off(Event.MOUSE_DOWN, this, onThumbMouseDown);
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
			this.barBgImg.off(Event.MOUSE_DOWN, this, onBarMouseDown);
			this.barBgImg.destroy();
			this.barBgImg.removeSelf();
			this.barBgImg = null;
		}
		this.onThumbMoveHandler = null;
		Laya.timer.clear(this, delayCallBackHandler);
		Laya.stage.off(Event.MOUSE_UP, this, onStageMouseUp);
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
		this.clearTimer(this, loopHandler);
		this.destroy();
		this.removeSelf();
	}
}
}