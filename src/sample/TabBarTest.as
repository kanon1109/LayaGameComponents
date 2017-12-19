package sample 
{
import components.TabBar;
import laya.display.Sprite;
import laya.net.Loader;
import laya.ui.Label;
import laya.utils.Handler;

/**
 * ...切换标签测试
 * @author Kanon
 */
public class TabBarTest extends Sprite 
{
	private var tabBar:TabBar;
	private var txt:Label;
	private var titleLabel:Label;
	public function TabBarTest() 
	{
		var arr:Array = [];
		arr.push({url:"res/tab.png", type:Loader.IMAGE});
		arr.push({url:"res/tabSelected.png", type:Loader.IMAGE});
		arr.push({url:"res/dsableTab.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.txt = new Label();
		this.txt.x = 300;
		this.txt.y = 150;
		this.txt.color = "#FF0000";
		this.txt.fontSize = 20;
		this.addChild(this.txt);
		
		this.titleLabel = new Label("tabBar测试");
		this.titleLabel.color = "#FFFFFF";
		this.titleLabel.fontSize = 30;
		this.titleLabel.x = 5;
		this.titleLabel.bold = true;
		this.addChild(this.titleLabel);
		
		this.tabBar = new TabBar();
		this.tabBar.x = 100;
		this.tabBar.y = 200;
		this.tabBar.init(4, 10, "res/tab.png", "res/tabSelected.png", "res/dsableTab.png", 
						Handler.create(this, tabClickHandler, null, false), 
						Handler.create(this, tabDsableClickHandler, null, false));
		this.tabBar.setSelectedByIndex(1);
		this.tabBar.setDsableByIndex(3, true);
		this.tabBar.setSelectedPosOffset(0, -21);
		this.addChild(this.tabBar);
	}
	
	private function tabDsableClickHandler(index:int):void 
	{
		this.txt.text = "当前第" + (index + 1) + "标签不开放";
	}
	
	private function tabClickHandler(index:int):void 
	{
		this.txt.text = "当前第" + (index + 1) + "标签";
	}
}
}