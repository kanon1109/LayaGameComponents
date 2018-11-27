package sample 
{
import effect.BloodSplatter;
import laya.display.Sprite;
import laya.events.Event;
import laya.net.Loader;
import laya.ui.Label;
import laya.utils.Handler;
/**
 * ...血渍测试
 * @author Kanon
 */
public class BloodSplatterTest extends SampleBase 
{
	private var bs:BloodSplatter;
	private var txt:Label;
	public function BloodSplatterTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "BloodSplatter";
		
		this.txt = new Label("click stage");
		this.txt.color = "FFFFFF";
		this.txt.fontSize = 25;
		this.addChild(this.txt);
		this.txt.x = (stage.width - this.txt.displayWidth) / 2;
		this.txt.y = (stage.height - this.txt.displayHeight) / 2;
		
		var arr:Array = [];
		arr.push( { url:"res/blood.png", type:Loader.IMAGE } );
		Laya.loader.load(arr, Handler.create(this, function():void
		{
			this.bs = new BloodSplatter("res/blood.png", Sprite(this));
			Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
			
		}), null, Loader.IMAGE)
	}
	
	private function onMouseDownHandler(event:Event):void 
	{
		//this.bs.clear();
		this.bs.show(event.stageX, event.stageY);
	}
	
	override public function destroySelf():void 
	{
		if (this.txt)
		{
			this.txt.removeSelf()
			this.txt.destroy();
			this.txt = null;
		}
		if (this.bs)
		{
			this.bs.destroy();
			this.bs = null;
		}
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		super.destroySelf();
	}
}
}