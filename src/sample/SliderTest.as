package sample 
{
import components.Slider;
import laya.net.Loader;
import laya.ui.Label;
import laya.utils.Handler;
/**
 * ...条的测试
 * @author ...Kanon
 */
public class SliderTest extends SampleBase 
{
	private var slider:Slider;
	private var slider2:Slider;
	private var txt:Label;
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
		this.txt = new Label();
		this.txt.x = 100;
		this.txt.y = 250;
		this.txt.color = "#FF0000";
		this.txt.fontSize = 20;
		this.addChild(this.txt);
		
		this.slider = new Slider("res/thumb.png", "res/sliderBarBg.png", "res/sliderBar.png");
		this.addChild(this.slider);
		this.slider.x = 100;
		this.slider.y = 300;
		this.slider.maxValue = 100;
		this.slider.minValue = 0;
		this.slider.value = 40;
		this.txt.text = "value: " + this.slider.value;
		this.slider.trackInteractionMode = Slider.PAGE;
		this.slider.page = 20;
		this.slider.onThumbMoveHandler = new Handler(this, onThumbMoveHandler);
		
		this.slider2 = new Slider("res/thumb.png", "res/sliderBarBg.png", "res/sliderBar.png");
		this.addChild(this.slider2);
		this.slider2.x = 450;
		this.slider2.y = 350;
		this.slider2.maxValue = 100;
		this.slider2.minValue = 0;
		this.slider2.value = 50;
		this.slider2.rotation = -90;
	}
	
	private function onThumbMoveHandler(value:int):void 
	{
		this.txt.text = "value: " + value;
	}
	
	override public function destroySelf():void 
	{
		if (this.slider)
		{
			this.slider.destroySelf();
			this.slider = null;
		}
		if (this.slider2)
		{
			this.slider2.destroySelf();
			this.slider2 = null;
		}
		
		if (this.txt)
		{
			this.txt.removeSelf();
			this.txt.destroy();
			this.txt = null;
		}
		super.destroySelf();
	}
}
}