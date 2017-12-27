package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Image;
import laya.ui.Label;
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
	public function ToggleSwitch(thumbSkin:String, trackSkin:String) 
	{
		this.mouseEnabled = true;
		this.trackImg = new Image(trackSkin);
		this.addChild(this.trackImg);
		
		this.thumbImg = new Image(thumbSkin);
		this.addChild(this.thumbImg);
		
		this.thumbImg.y = (this.trackImg.height - this.thumbImg.height) / 2;
		
		this.onLabel = new Label("on");
		this.onLabel.align = "center";
		this.onLabel.fontSize = 25;
		this.onLabel.color = "#FF8000";
		this.onLabel.visible = false;
		this.onLabel.valign = "center";
		this.onLabel.mouseEnabled = false;

		this.offLabel = new Label("off");
		this.offLabel.fontSize = 25;
		this.offLabel.align = "center";
		this.offLabel.color = "#FFFFFF";
		this.offLabel.valign = "center";
		this.offLabel.mouseEnabled = false;
		
		this.addChild(this.onLabel);
		this.addChild(this.offLabel);
		
		this.onLabel.width = this.trackImg.width - this.thumbImg.width;
		this.offLabel.width = this.trackImg.width - this.thumbImg.width;
		this.offLabel.x = this.thumbImg.width;
		
		this.onLabel.y = (this.trackImg.height - this.onLabel.height) / 2;
		this.offLabel.y = this.onLabel.y;
		
		this.size(this.trackImg.width, this.trackImg.height);
		this.on(Event.CLICK, this, clickHandler);
	}
	
	private function clickHandler(event:Event):void 
	{
		this.isSelected = !this.isSelected;
	}
	
	public function destroySelf():void
	{
		if (this.thumbImg)
		{
			this.thumbImg.destroy();
			this.thumbImg.removeSelf();
			this.thumbImg = null;
		}
		
		if (this.trackImg)
		{
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
		
		this.destroy();
		this.removeSelf();
	}
	
	public function get isSelected():Boolean {return _isSelected;}
	public function set isSelected(value:Boolean):void 
	{
		_isSelected = value;
		this.onLabel.visible = _isSelected;
		this.offLabel.visible = !_isSelected;
		if (this._isSelected)
			this.thumbImg.x = this.trackImg.width - this.thumbImg.width;
		else
			this.thumbImg.x = 0;
	}
	
}
}