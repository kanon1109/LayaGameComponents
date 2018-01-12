package 
{
import components.SimpleButton;
import laya.display.Sprite;
import laya.display.Stage;
import laya.events.Event;
import laya.net.Loader;
import laya.utils.Handler;
import sample.JoystickTest;
import sample.ListViewTest;
import sample.NumericStepperTest;
import sample.PageIndicatorTest;
import sample.PanelTest;
import sample.SampleBase;
import sample.SimpleButtonTest;
import sample.SliderTest;
import sample.TabBarTest;
import sample.ToggleSwitchTest;
/**
 * ...入口
 * @author ...Kanon
 */
public class Main 
{
	private var sampleTestArr:Array;
	private var index:int;
	private var prevIndex:int;
	private var sampleSpt:Sprite;
	public function Main() 
	{
		Laya.init(800, 500);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Laya.stage.bgColor = "#283331";
		
		DebugPanel.init();
		
		this.sampleTestArr = [new SimpleButtonTest(),
							  new TabBarTest(), new ListViewTest(), 
							  new JoystickTest(), new NumericStepperTest(), 
							  new PageIndicatorTest(), new ToggleSwitchTest(), 
							  new SliderTest(), new PanelTest()];
		this.index = 0;
		this.prevIndex = 0;
		
		var arr:Array = [];
		arr.push({url:"res/btn.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.sampleSpt = new Sprite();
		Laya.stage.addChild(this.sampleSpt);
		this.loadSample();
		var nextBtn:SimpleButton = new SimpleButton("res/btn.png", null, null, "下一个");
		var prevBtn:SimpleButton = new SimpleButton("res/btn.png", null, null, "上一个");
		nextBtn.labelSize = 15;
		prevBtn.labelSize = nextBtn.labelSize;
		nextBtn.x = Laya.stage.width / 2 + 200 - nextBtn.width / 2;
		nextBtn.y = Laya.stage.height - 100;
		
		prevBtn.x = Laya.stage.width / 2 - 200 - prevBtn.width / 2;
		prevBtn.y = nextBtn.y;
		
		Laya.stage.addChild(nextBtn);
		Laya.stage.addChild(prevBtn);
		
		nextBtn.on(Event.CLICK, this, nextBtnClickHandler);
		prevBtn.on(Event.CLICK, this, prevBtnClickHandler);
	}
	
	private function loadSample():void
	{
		var sampleTest:SampleBase = this.sampleTestArr[this.index];
		sampleTest.init();
		this.sampleSpt.addChild(sampleTest);
	}
	
	private function destroySample():void
	{
		var sampleTest:SampleBase = this.sampleTestArr[this.prevIndex];
		sampleTest.destroySelf();
	}
	
	private function prevBtnClickHandler():void 
	{
		if (this.index == 0) return;
		this.prevIndex = this.index;
		this.index--;
		this.destroySample();
		this.loadSample();
	}
	
	private function nextBtnClickHandler():void 
	{
		if (this.index == this.sampleTestArr.length - 1) return;
		this.prevIndex = this.index;
		this.index++;
		this.destroySample();
		this.loadSample();
	}
}
}