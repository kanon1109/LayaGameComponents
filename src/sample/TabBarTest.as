package sample 
{
import components.TabBar;
import laya.display.Sprite;
import laya.net.Loader;
import laya.utils.Handler;

/**
 * ...切换标签测试
 * @author Kanon
 */
public class TabBarTest extends Sprite 
{
	private var tabBar:TabBar;
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
		this.tabBar = new TabBar();
		this.tabBar.x = 100;
		this.tabBar.y = 200;
		this.tabBar.init(4, 10, "res/tab.png", "res/tabSelected.png", "res/dsableTab.png", 
						Handler.create(this, tabClickHandler, null, false), 
						Handler.create(this, tabDsableClickHandler, null, false));
		this.tabBar.setSelectedByIndex(1);
		this.tabBar.setDsableByIndex(3);
		this.tabBar.setSelectedPosOffset(0, -22);
		this.addChild(this.tabBar);
	}
	
	private function tabDsableClickHandler(index:int):void 
	{
		trace("not open", index);
	}
	
	private function tabClickHandler(index:int):void 
	{
		trace("index", index);
	}
}
}