package 
{
import components.SimpleButton;
import laya.display.Sprite;
import laya.display.Stage;
import laya.events.Event;
import laya.net.Loader;
import laya.ui.Button;
import laya.utils.Handler;
import sample.ListViewTest;
import sample.SampleBase;
import sample.TabBarTest;
/**
 * ...入口
 * @author ...Kanon
 */
public class Main 
{
	private var sampleTestArr:Array;
	private var index:int;
	private var prevIndex:int;
	public function Main() 
	{
		Laya.init(800, 500);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Laya.stage.bgColor = "#0F1312";
		
		this.sampleTestArr = [new TabBarTest(), new ListViewTest()];
		this.index = 0;
		this.prevIndex = 0;
		
		var arr:Array = [];
		arr.push({url:"res/btn.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.loadSample();
		
		var nextBtn:SimpleButton = new SimpleButton("res/btn.png", "下一个");
		var prevBtn:SimpleButton = new SimpleButton("res/btn.png", "上一个");
		nextBtn.labelSize = 15;
		prevBtn.labelSize = nextBtn.labelSize;
		//prevBtn.labelColors = "#FF0000";
		//prevBtn.labelStroke = 2;
		//prevBtn.labelStrokeColor = "#FFcc00";
		//prevBtn.labelBold = true;
		
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
		var sample:SampleBase = this.sampleTestArr[this.index];
		sample.init();
		Laya.stage.addChild(sample);
	}
	
	private function destroySample():void
	{
		var sample:SampleBase = this.sampleTestArr[this.prevIndex];
		sample.destroy();
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