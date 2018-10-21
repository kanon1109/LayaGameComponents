package sample 
{
import components.SimpleButton;
import laya.display.Sprite;
import laya.events.Event;
import laya.net.HttpRequest;
import laya.net.Loader;
import laya.renders.Render;
import laya.utils.Browser;
import laya.utils.Byte;
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
			
			this.saveBtn = new SimpleButton("res/btn.png", null, null, "保存为二进制");
			this.addChild(this.saveBtn);
			this.saveBtn.x = Laya.stage.width / 2 - this.captureBtn.width - 5;
			this.saveBtn.y = Laya.stage.height - 100;
			this.saveBtn.on(Event.CLICK, this, saveBtnClickHandler);
			
		}), null, Loader.IMAGE);
		
		if (Render.isConchApp)
			this.titleLabel.text += "\n is conchApp";
		else
			this.titleLabel.text += "\n not conchApp";
	}
	
	private function saveBtnClickHandler(event:Event):void 
	{
		if (!Render.isConchApp)
		{
			var base64:* = ScreenCapture.catureAsData(Laya.stage, Laya.stage.width, Laya.stage.height);
			var xhr:HttpRequest = new HttpRequest();
			xhr.once(Event.COMPLETE, this, completeHandler);
			xhr.once(Event.ERROR, this, errorHandler);
			xhr.send(base64, "", "get", "arraybuffer");
		}
		else
		{
			ScreenCapture.catureAsDevice("capture");
			/*var CaptureScreenClass = Laya.PlatformClass.createClass("com.LayaGameComponents.game.CaptureScreenClass");
			if (CaptureScreenClass)
				CaptureScreenClass.call("capture");*/
			if (this.captureSpt)
			{
				Tween.clearAll(this.captureSpt);
				this.captureSpt.removeSelf();
				this.captureSpt.destroy();
				this.captureSpt = null;
			}	
			
			var sp:Sprite = new Sprite();
			sp.loadImage("file:///sdcard/capture.png", 0, 0, 0, 0, Handler.create(this, function()
			{
				sp.pivotX = Laya.stage.width / 2;
				sp.pivotY = Laya.stage.height / 2;
				sp.x = Laya.stage.width / 2;
				sp.y = Laya.stage.height / 2;
				Tween.to(sp, { scaleX:.5, scaleY:.5 }, 500);
			}));
			this.addChild(sp);//添加到舞台
			this.captureSpt = sp;
		}
	}
	
	private function errorHandler():void 
	{
		trace("error");
	}
	
	private function completeHandler(data:Object):void 
	{
		trace("completeHandler2");
		var byte:Byte = new Byte(data);//Byte数组接收arraybuffer
		if (this.captureSpt)
		{
			Tween.clearAll(this.captureSpt);
			this.captureSpt.removeSelf();
			this.captureSpt.destroy();
			this.captureSpt = null;
		}
		
		var blob:Object = new Browser.window.Blob([byte.buffer], { type: "image/png" } );
		var url:String = Browser.window.URL.createObjectURL(blob);//创建一个url对象；
		
		
		var sp:Sprite = new Sprite();
		sp.loadImage(url);
		sp.pivotX = Laya.stage.width / 2;
		sp.pivotY = Laya.stage.height / 2;
		sp.x = Laya.stage.width / 2;
		sp.y = Laya.stage.height / 2;
		Tween.to(sp, { scaleX:.5, scaleY:.5 }, 500);
		this.addChild(sp);//添加到舞台
		this.captureSpt = sp;
	}
	
	private function captureBtnClickHandler(event:Event):void 
	{
		if (this.captureSpt)
		{
			Tween.clearAll(this.captureSpt);
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
			Tween.clearAll(this.captureSpt);
			this.captureSpt.removeSelf();
			this.captureSpt.destroy();
			this.captureSpt = null;
		}
		
		super.destroySelf();
	}
}
}