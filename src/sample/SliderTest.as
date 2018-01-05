package sample 
{
import components.Slider;
import laya.net.Loader;
import laya.utils.Handler;
/**
 * ...条的测试
 * @author ...Kanon
 */
public class SliderTest extends SampleBase 
{
	private var slider:Slider;
	public function SliderTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		var arr:Array = [];
		arr.push({url:"res/thumb.png", type:Loader.IMAGE});
		arr.push({url:"res/sliderBar.png", type:Loader.IMAGE});
		arr.push({url:"res/sliderBarBg.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
		this.titleLabel.text = "Slider";
	}
	
	private function loadImgComplete():void
	{
		this.slider = new Slider("res/thumb.png", "res/sliderBarBg.png", "res/sliderBar.png");
		this.addChild(this.slider);
		this.slider.x = 200;
		this.slider.y = 300;
		this.slider.maxValue = 100;
		this.slider.minValue = 1;
		this.slider.value = 40;
	}
	
}
}