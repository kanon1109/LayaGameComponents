package sample 
{
import components.ToggleSwitch;
import laya.net.Loader;
import laya.ui.Label;
import laya.utils.Handler;
/**
 * ...切换开关测试
 * @author ...Kanon
 */
public class ToggleSwitchTest extends SampleBase 
{
	private var ts1:ToggleSwitch;
	private var ts2:ToggleSwitch;
	private var txt:Label;
	public function ToggleSwitchTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		var arr:Array = [];
		arr.push({url:"res/thumb.png", type:Loader.IMAGE});
		arr.push({url:"res/track.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
		this.titleLabel.text = "ToggleSwitch";
	}
	
	private function loadImgComplete():void
	{
		this.txt = new Label();
		this.txt.x = 200;
		this.txt.y = 200;
		this.txt.color = "#FF0000";
		this.txt.fontSize = 20;
		this.addChild(this.txt);
		
		this.ts1 = new ToggleSwitch("res/thumb.png", "res/track.png");
		this.ts1.x = 200;
		this.ts1.y = 250;
		this.ts1.onSelectHandler = new Handler(this, onSelectHandler);
		this.addChild(this.ts1);
		
		this.ts2 = new ToggleSwitch("res/thumb.png", "res/track.png");
		this.ts2.x = 500;
		this.ts2.y = 250;
		this.addChild(this.ts2);
		
		this.onSelectHandler();
	}
	
	private function onSelectHandler():void 
	{
		this.txt.text = "this.ts.isSelected: " + this.ts1.isSelected;
	}
	
	override public function destroySelf():void 
	{
		if (this.ts1)
		{
			this.ts1.destroySelf();
			this.ts1 = null;
		}
		if (this.ts2)
		{
			this.ts2.destroySelf();
			this.ts2 = null;
		}
		super.destroySelf();
	}
}
}