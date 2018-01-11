package sample 
{
import components.Panel;
import laya.net.Loader;
import laya.utils.Handler;
/**
 * ...面板测试
 * @author ...Kanon
 */
public class PanelTest extends SampleBase 
{
	private var panel:Panel;
	public function PanelTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "Panel";
		
		var arr:Array = [];
		arr.push({url:"res/titleBg.png", type:Loader.IMAGE});
		arr.push({url:"res/contentBg.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.panel = new Panel("res/contentBg.png", "This is the Panel's content.", "res/titleBg.png", "Title");
		this.panel.x = 150;
		this.panel.y = 60;
		this.addChild(this.panel);
	}
	
	override public function destroySelf():void 
	{
		if (this.panel)
		{
			this.panel.destroySelf();
			this.panel = null;
		}
		super.destroySelf();
	}
}
}