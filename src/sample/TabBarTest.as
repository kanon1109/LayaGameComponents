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
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.tabBar = new TabBar();
		this.tabBar.init(3, 10, "res/tab.png", "res/tabSelected.png");
		this.tabBar.setSelectedByIndex(1);
		this.addChild(this.tabBar);
	}
}
}