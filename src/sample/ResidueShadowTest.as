package sample 
{
import effect.ResidueShadow;
import laya.events.Event;
import laya.net.Loader;
import laya.ui.Image;
import laya.utils.Handler;
/**
 * ...残影测试
 * @author Kanon
 */
public class ResidueShadowTest extends SampleBase 
{
	private var rs:ResidueShadow;
	private var img:Image;
	public function ResidueShadowTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "ResidueShadow";

		var arr:Array = [];
		arr.push({url:"res/role.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, function():void {
			this.rs = new ResidueShadow();
			this.rs.init(this, 800);
			this.img = new Image("res/role.png");
			this.img.x = Laya.stage.width / 2;
			this.img.y = Laya.stage.height / 2;
			this.addChild(this.img);
			this.rs.push(this.img);
			this.img.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
			Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
			this.frameLoop(1, this, loop);
		}), null, Loader.IMAGE);
		
	}
	
	private function loop():void 
	{
		if (this.rs)
			this.rs.render();
	}
	
	private function onMouseDownHandler(event:Event):void 
	{
		this.img.startDrag();
	}
	
	private function onMouseUpHandler():void 
	{
		this.img.stopDrag();
	}
	
	override public function destroySelf():void 
	{
		if (this.rs)
		{
			this.rs.destroy();
			this.rs = null;
		}
		if (this.img)
		{
			this.img.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
			this.img.removeSelf();
			this.img.destroy();
			this.img = null;
		}
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		super.destroySelf();
	}
}
}