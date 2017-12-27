package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Image;
import laya.ui.TextInput;
/**
 * ...计数器
 * @author ...Kanon
 */
public class NumericStepper extends Sprite 
{
	//输入文本
	public var input:TextInput;
	//最大值
	public var maxValue:int = 100;
	//最小值
	public var minValue:int = 0;
	//当前的值
	public var value:int;
	public var reduceBtn:SimpleButton;
	public var addBtn:SimpleButton;
	//间隔
	private var _step:int = 1;
	private var inputImg:Image;
	private var gap:int;
	private var isReduceMouseDown:Boolean;
	private var isAddMouseDown:Boolean;
	public function NumericStepper(reduceBtnSkin:String, 
									addBtnSkin:String, 
									inputImgPath:String, 
									fontSize:int,
									fontColor:String="#FFFFFF",
									gap:int = 2) 
	{
		this.value = this.minValue;
		this.reduceBtn = new SimpleButton(reduceBtnSkin);
		this.reduceBtn.on(Event.CLICK, this, reduceBtnClickHandler);
		this.reduceBtn.on(Event.MOUSE_DOWN, this, reduceBtnMouseDownHandler);
		this.reduceBtn.on(Event.MOUSE_UP, this, reduceBtnMouseUpHandler);
		this.reduceBtn.on(Event.MOUSE_OUT, this, reduceBtnMouseUpHandler);
		this.addChild(this.reduceBtn);
		
		this.addBtn = new SimpleButton(addBtnSkin);
		this.addBtn.on(Event.CLICK, this, addBtnClickHandler);
		this.addBtn.on(Event.MOUSE_DOWN, this, addBtnMouseDownHandler);
		this.addBtn.on(Event.MOUSE_UP, this, addBtnMouseUpHandler);
		this.addBtn.on(Event.MOUSE_OUT, this, addBtnMouseUpHandler);
		this.addChild(this.addBtn);
		
		this.inputImg = new Image(inputImgPath);
		this.addChild(this.inputImg);
				
		this.input = new TextInput();
		this.input.restrict = "0-9-";
		this.input.fontSize = fontSize;
		this.input.align = "center";
		this.input.color = fontColor;
		this.input.text = this.value.toString();
		this.input.on(Event.BLUR, this, blurInputHandler);
		this.addChild(this.input);
		this.input.size(this.inputImg.width, this.inputImg.height);
		
		this.gap = gap;
		this.layout();
	}
	
	private function blurInputHandler():void 
	{
		this.value = parseInt(this.input.text);
		this.updateValue();
	}
	
	private function addBtnMouseUpHandler():void 
	{
		this.clearTimer(this, loopHandler);
		this.isAddMouseDown = false;
	}
	
	private function addBtnMouseDownHandler():void 
	{
		this.frameLoop(10, this, loopHandler)
		this.isAddMouseDown = true;
	}
	
	private function reduceBtnMouseUpHandler():void 
	{
		this.clearTimer(this, loopHandler);
		this.isReduceMouseDown = false;
	}
	
	private function reduceBtnMouseDownHandler():void 
	{
		this.frameLoop(10, this, loopHandler)
		this.isReduceMouseDown = true;
	}
	
	private function loopHandler():void 
	{
		if (this.isAddMouseDown)
			this.addBtnClickHandler();
		
		if (this.isReduceMouseDown)
			this.reduceBtnClickHandler();
	}
	
	private function addBtnClickHandler():void 
	{
		this.value += this.step;
		this.updateValue();
	}
	
	private function reduceBtnClickHandler():void 
	{
		this.value -= this.step;
		this.updateValue();
	}
	
	/**
	 * 更新内容
	 */
	private function updateValue():void
	{
		if (this.value < this.minValue) this.value = this.minValue;
		if (this.value > this.maxValue) this.value = this.maxValue;
		this.input.text = this.value.toString();
	}
	
	private function layout():void
	{
		this.inputImg.x = this.reduceBtn.x + this.reduceBtn.width + this.gap;
		this.addBtn.x = this.inputImg.x + this.inputImg.width + this.gap;
		this.inputImg.y = (this.addBtn.height - this.inputImg.height) / 2;
		this.input.x = this.inputImg.x;
		this.input.y = this.inputImg.y;
	}
	
	/**
	 * 销毁自己
	 */
	public function destroySelf():void
	{
		if (this.reduceBtn)
		{
			this.reduceBtn.off(Event.CLICK, this, reduceBtnClickHandler);
			this.reduceBtn.off(Event.MOUSE_DOWN, this, reduceBtnMouseDownHandler);
			this.reduceBtn.off(Event.MOUSE_UP, this, reduceBtnMouseUpHandler);
			this.reduceBtn.off(Event.MOUSE_OUT, this, reduceBtnMouseUpHandler);
			this.reduceBtn.destroySelf();
			this.reduceBtn = null;
		}
		
		if (this.addBtn)
		{
			this.addBtn.off(Event.CLICK, this, addBtnClickHandler);
			this.addBtn.off(Event.MOUSE_DOWN, this, addBtnMouseDownHandler);
			this.addBtn.off(Event.MOUSE_UP, this, addBtnMouseUpHandler);
			this.addBtn.off(Event.MOUSE_OUT, this, addBtnMouseUpHandler);
			this.addBtn.destroySelf();
			this.addBtn = null;
		}
		
		if (this.inputImg)
		{
			this.inputImg.destroy();
			this.inputImg.removeSelf();
			this.inputImg = null;
		}
		
		if (this.input)
		{
			this.input.destroy();
			this.input.removeSelf();
			this.input = null;
		}
		
		this.clearTimer(this, loopHandler);
		this.destroy();
		this.removeSelf();
	}
	
	public function get step():int{ return _step; }
	public function set step(value:int):void 
	{
		_step = value;
		this.updateValue();
	}
}
}