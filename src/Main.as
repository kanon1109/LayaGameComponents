package 
{
import laya.display.Sprite;
import laya.display.Stage;
import laya.events.Event;
import laya.net.Loader;
import laya.ui.Button;
import laya.utils.Handler;
import sample.TabBarTest;
/**
 * ...入口
 * @author ...Kanon
 */
public class Main 
{
	private var sampleTestArr:Array;
	private var index:int;
	public function Main() 
	{
		Laya.init(800, 500);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Laya.stage.bgColor = "#0F1312";
		
		this.sampleTestArr = [new TabBarTest()];
		this.index = 0;
		
		var arr:Array = [];
		arr.push({url:"res/btn.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.loadSample();
		
		var nextBtn:Button = new Button("res/btn.png", "下一个");
		var prevBtn:Button = new Button("res/btn.png", "上一个");
		nextBtn.stateNum = 1;
		prevBtn.stateNum = 1;
		
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
		var sample:Sprite = this.sampleTestArr[this.index];
		Laya.stage.addChild(sample);
	}
	
	private function prevBtnClickHandler():void 
	{
		this.index--;
		if (this.index < 0) 
			this.index = 0;
		this.loadSample();
	}
	
	private function nextBtnClickHandler():void 
	{
		this.index++;
		if (this.index > this.sampleTestArr.length - 1)
			this.index = this.sampleTestArr.length - 1;
		this.loadSample();
	}
}
}