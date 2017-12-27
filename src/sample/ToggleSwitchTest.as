package sample 
{
	import components.ToggleSwitch;
	import laya.net.Loader;
	import laya.utils.Handler;
/**
 * ...切换开关测试
 * @author ...Kanon
 */
public class ToggleSwitchTest extends SampleBase 
{
	private var ts:ToggleSwitch;
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
		this.ts = new ToggleSwitch("res/thumb.png", "res/track.png");
		this.ts.x = 200;
		this.ts.y = 250;
		this.addChild(this.ts);
	}
	
	override public function destroySelf():void 
	{
		if (this.ts)
		{
			this.ts.destroySelf();
			this.ts = null;
		}
		super.destroySelf();
	}
}
}