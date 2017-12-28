package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.maths.Point;
import laya.maths.Rectangle;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ...切换开关
 * @author ...Kanon
 */
public class ToggleSwitch extends Sprite 
{
	private var _isSelected:Boolean;
	//滑块
	private var thumbImg:Image;
	//底
	private var trackImg:Image;
	//开启文本
	public var onLabel:Label;
	//关闭文本
	public var offLabel:Label;
	//滑块容器
	private var spt:Sprite;
	//运动
	private var tween:Tween;
	//上一次点击的位置
	private var prevMousePos:Point;
	private var curMousePos:Point;
	//滑块上一次的位置
	private var prevThumbX:Number;
	//是否点击
	private var isMouseDown:Boolean;
	//选中回调
	public var onSelectHandler:Handler;
	public function ToggleSwitch(thumbSkin:String, trackSkin:String) 
	{
		this.mouseEnabled = true;
		this.trackImg = new Image(trackSkin);
		this.addChild(this.trackImg);
		
		this.prevMousePos = new Point();
		this.curMousePos = new Point();
		this.spt = new Sprite();
		this.addChild(this.spt);
		
		this.onLabel = new Label("on");
		this.onLabel.align = "center";
		this.onLabel.valign = "middle";
		this.onLabel.fontSize = 25;
		this.onLabel.color = "#FF8000";
		this.onLabel.mouseEnabled = false;

		this.offLabel = new Label("off");
		this.offLabel.fontSize = 25;
		this.offLabel.align = "center";
		this.offLabel.valign = "middle";
		this.offLabel.color = "#FFFFFF";
		this.offLabel.mouseEnabled = false;
		
		this.spt.addChild(this.onLabel);
		this.spt.addChild(this.offLabel);
		
		this.thumbImg = new Image(thumbSkin);
		this.thumbImg.y = (this.trackImg.height - this.thumbImg.height) / 2;
		this.spt.addChild(this.thumbImg);
		
		this.onLabel.width = this.trackImg.width - this.thumbImg.width;
		this.offLabel.width = this.trackImg.width - this.thumbImg.width;
		this.onLabel.height = this.trackImg.height;
		this.offLabel.height = this.onLabel.height;
		this.offLabel.x = this.thumbImg.width;
		
		this.onLabel.y = (this.trackImg.height - this.onLabel.height) / 2;
		this.offLabel.y = this.onLabel.y;
		this.onLabel.x = this.thumbImg.x - this.onLabel.width;
		this.offLabel.x = this.thumbImg.x + this.thumbImg.width;
		
		this.thumbImg.on(Event.MOUSE_DOWN, this, thumbMouseDownHandler);
		this.trackImg.on(Event.CLICK, this, clickHandler);
		Laya.stage.on(Event.MOUSE_UP, this, thumbMouseUpHandler);

		this.size(this.trackImg.width, this.trackImg.height);
		this.scrollRect = new Rectangle(0, 0, this.width, this.height);
	}
	
	private function thumbMouseUpHandler(event:Event):void 
	{
		if (this.isMouseDown)
		{
			this.isMouseDown = false;
			this.clearTimer(this, loopHandler);
			if (this.prevMousePos.distance(event.stageX - this.x, event.stageY - this.y) < 1)
			{
				this.isSelected = !this.isSelected;
			}
			else
			{
				if (this.spt.x + this.thumbImg.width / 2 < this.width / 2)
					this.isSelected = false;
				else
					this.isSelected = true;
			}
		}
	}
	
	private function thumbMouseDownHandler(event:Event):void 
	{
		this.isMouseDown = true;
		this.prevMousePos.x = event.stageX - this.x;
		this.prevMousePos.y = event.stageY - this.y;
		this.prevThumbX = this.spt.x;
		this.frameLoop(1, this, loopHandler);
	}
	
	private function loopHandler():void 
	{
		var dis:Number = mouseX - this.prevMousePos.x;
		this.spt.x = this.prevThumbX + dis;
		if (this.spt.x < 0)
			this.spt.x = 0;
		else if (this.spt.x > this.trackImg.width - this.thumbImg.width)
			this.spt.x = this.trackImg.width - this.thumbImg.width;
	}
	
	private function clickHandler(event:Event):void 
	{
		this.isSelected = !this.isSelected;
	}
	
	/**
	 * 删除tween
	 */
	private function removeTween():void
	{
		if (this.tween)
		{
			this.tween.clear();
			this.tween = null;
		}
	}
	
	public function destroySelf():void
	{
		if (this.thumbImg)
		{
			this.thumbImg.off(Event.MOUSE_DOWN, this, thumbMouseDownHandler);
			this.thumbImg.destroy();
			this.thumbImg.removeSelf();
			this.thumbImg = null;
		}
		
		if (this.trackImg)
		{
			this.trackImg.off(Event.CLICK, this, clickHandler);
			this.trackImg.destroy();
			this.trackImg.removeSelf();
			this.trackImg = null;
		}
		
		if (this.onLabel)
		{
			this.onLabel.destroy();
			this.onLabel.removeSelf();
			this.onLabel = null;
		}
		
		if (this.offLabel)
		{
			this.offLabel.destroy();
			this.offLabel.removeSelf();
			this.offLabel = null;
		}
		
		if (this.spt)
		{
			this.spt.destroy();
			this.spt.removeSelf();
			this.spt = null;
		}
		
		Laya.stage.off(Event.MOUSE_UP, this, thumbMouseUpHandler);
		this.clearTimer(this, loopHandler);
		this.removeTween();
		this.destroy();
		this.removeSelf();
	}
	
	public function get isSelected():Boolean {return _isSelected;}
	public function set isSelected(value:Boolean):void 
	{
		_isSelected = value;
		this.removeTween();
		if (value)
			this.tween = Tween.to(this.spt, {x:this.trackImg.width - this.thumbImg.width}, 100, Ease.circOut);
		else
			this.tween = Tween.to(this.spt, {x:0}, 100, Ease.circOut);
		if (this.onSelectHandler)
			this.onSelectHandler.run();
	}
}
}