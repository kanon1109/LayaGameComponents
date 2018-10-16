package sample 
{
import components.SimpleButton;
import laya.display.Sprite;
import laya.display.Text;
import laya.events.Event;
import laya.net.Loader;
import laya.renders.Render;
import laya.utils.Browser;
import laya.utils.Handler;
import laya.utils.Tween;
import utils.ScreenCapture;
/**
 * ...截屏测试
 * @author Kanon
 */
public class ScreenCaptureTest extends SampleBase 
{
	private var captureBtn:SimpleButton;
	private var saveBtn:SimpleButton;
	private var debugTxt:Text;
	private var captureSpt:Sprite;
	public function ScreenCaptureTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "ScreenCaptureTest";
		var arr:Array = [];
		arr.push( { url:"res/btn.png", type:Loader.IMAGE } );
		arr.push( { url:"res/role.png", type:Loader.IMAGE } );
		Laya.loader.load(arr, Handler.create(this, function():void
		{
			this.captureBtn = new SimpleButton("res/btn.png", null, null, "屏幕截取");
			this.addChild(this.captureBtn);
			this.captureBtn.x = Laya.stage.width / 2 + 5;
			this.captureBtn.y = Laya.stage.height - 100;
			this.captureBtn.on(Event.CLICK, this, captureBtnClickHandler);
			
			this.saveBtn = new SimpleButton("res/btn.png", null, null, "屏幕截取");
			this.addChild(this.saveBtn);
			this.saveBtn.x = Laya.stage.width / 2 - this.captureBtn.width - 5;
			this.saveBtn.y = Laya.stage.height - 100;
			this.saveBtn.on(Event.CLICK, this, saveBtnClickHandler);
			
		}), null, Loader.IMAGE);
		
		this.debugTxt = new Text();
		this.debugTxt.fontSize = 25;
		this.debugTxt.color = "#FFFFFF";
		this.debugTxt.x = 300;
		this.addChild(this.debugTxt);
		
		this.debugTxt.text = "w"+ Browser.width + " h:" + Browser.height;
		this.debugTxt.text += "\n dw"+ Laya.stage.designWidth + " dh:" + Laya.stage.designHeight;
		this.debugTxt.text += "\n width" + Laya.stage.width + " height:" + Laya.stage.height;
		
		if (Render.isConchApp)
		{
			this.titleLabel.text += "\n isConchApp";
		}
	}
	
	private function saveBtnClickHandler(event:Event):void 
	{
		
	}
	
	private function captureBtnClickHandler(event:Event):void 
	{
		if (this.captureSpt)
		{
			this.captureSpt.removeSelf();
			this.captureSpt.destroy();
			this.captureSpt = null;
		}
		
		var sp:Sprite = ScreenCapture.cature();
		if (sp)
		{
			this.addChild(sp);
			sp.pivotX = Laya.stage.width / 2;
			sp.pivotY = Laya.stage.height / 2;
			sp.x = Laya.stage.width / 2;
			sp.y = Laya.stage.height / 2;
			Tween.to(sp, { scaleX:.5, scaleY:.5 }, 500);
			this.captureSpt = sp;
		}
	}
	
	override public function destroySelf():void 
	{
		if (this.captureBtn)
		{
			this.captureBtn.off(Event.MOUSE_DOWN, this, captureBtnClickHandler);
			this.captureBtn.destroySelf();
			this.captureBtn = null;
		}
		
		if (this.saveBtn)
		{
			this.saveBtn.off(Event.MOUSE_DOWN, this, saveBtnClickHandler);
			this.saveBtn.destroySelf();
			this.saveBtn = null;
		}
		
		if (this.captureSpt)
		{
			this.captureSpt.removeSelf();
			this.captureSpt.destroy();
			this.captureSpt = null;
		}
		
		super.destroySelf();
	}
}
}