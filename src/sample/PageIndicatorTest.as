package sample 
{
	import components.PageIndicator;
	import laya.net.Loader;
	import laya.ui.Label;
	import laya.utils.Handler;
/**
 * ...页数组件测试
 * @author ...Kanon
 */
public class PageIndicatorTest extends SampleBase 
{
	private var pageIndicator:PageIndicator;
	private var txt:Label;
	public function PageIndicatorTest() 
	{
		super();
		
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "PageIndicator";
		
		var arr:Array = [];
		arr.push({url:"res/PageIndicatorNormal.png", type:Loader.IMAGE});
		arr.push({url:"res/PageIndicatorSelected.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.txt = new Label();
		this.txt.x = 250;
		this.txt.y = 150;
		this.txt.color = "#FF0000";
		this.txt.fontSize = 20;
		this.addChild(this.txt);
		
		this.pageIndicator = new PageIndicator("res/PageIndicatorNormal.png", "res/PageIndicatorSelected.png", 5);
		this.pageIndicator.x = 250;
		this.pageIndicator.y = 190;
		this.pageIndicator.pageChangeHandler = new Handler(this, pageChangeHandler);
		this.addChild(this.pageIndicator);
		
		this.pageChangeHandler();
	}
	
	private function pageChangeHandler():void 
	{
		this.txt.text = "当前页数索引" + this.pageIndicator.selectedIndex;
	}
	
	override public function destroySelf():void 
	{
		if (this.pageIndicator)
		{
			this.pageIndicator.destroySelf();
			this.pageIndicator = null;
		}
		
		if (this.txt)
		{
			this.txt.destroy();
			this.txt.removeSelf();
			this.txt = null;
		}
		super.destroySelf();
	}
}
}