package sample 
{
	import components.PageIndicator;
	import laya.net.Loader;
	import laya.utils.Handler;
/**
 * ...页数组件测试
 * @author ...Kanon
 */
public class PageIndicatorTest extends SampleBase 
{
	private var pageIndicator:PageIndicator;
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
		this.pageIndicator = new PageIndicator("res/PageIndicatorNormal.png", "res/PageIndicatorSelected.png", 5);
		this.pageIndicator.x = 250;
		this.pageIndicator.y = 300;
		this.addChild(this.pageIndicator);
	}
	
	override public function destroySelf():void 
	{
		if (this.pageIndicator)
		{
			this.pageIndicator.destroySelf();
			this.pageIndicator = null;
		}
		super.destroySelf();
	}
}
}