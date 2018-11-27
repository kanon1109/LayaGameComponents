package sample 
{
import effect.FlameGun;
import laya.display.Sprite;
import laya.events.Event;
import laya.net.Loader;
import laya.utils.Handler;
import utils.MathUtil;
/**
 * ...火焰枪测试
 * @author Kanon
 */
public class FlameGunTest extends SampleBase 
{
	private var fg:FlameGun;
	private var spt:Sprite;
	private var isMouseDown:Boolean;
	public function FlameGunTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.spt = new Sprite();
		this.spt.width = 20;
		this.spt.height = 20;
		this.spt.pivotX = 10;
		this.spt.pivotY = 10;
		this.spt.x = Laya.stage.designWidth / 2;
		this.spt.y = Laya.stage.designHeight / 2;
		this.spt.graphics.drawCircle(10, 10, 10, "#FF0000");
		this.spt.mouseEnabled = true;
		this.spt.on(Event.MOUSE_DOWN, this, onSptMouseDownHandler);
		Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
		this.addChild(this.spt);

		var arr:Array = [];
		arr.push( { url:"res/flame.png", type:Loader.IMAGE } );
		Laya.loader.load(arr, Handler.create(this, function():void
		{
			this.fg = new FlameGun(Sprite(this), "res/flame.png", this.spt.x, this.spt.y, 5, 0, 1, .1, 400);
			this.fg.show();
			this.frameLoop(1, this, loop);
		}), null, Loader.IMAGE)
	}
	
	private function loop():void 
	{
		if (this.isMouseDown)
		{
			var rad:Number = Math.atan2(Laya.stage.mouseY - this.spt.y, 
										Laya.stage.mouseX - this.spt.x);
			var angle:Number = MathUtil.rds2dgs(rad);
			this.fg.rotation = angle;
		}
		this.fg.move(this.spt.x, this.spt.y);
		this.fg.update();
	}
	
		
	private function onMouseDownHandler():void 
	{
		this.isMouseDown = true;
	}
	
	private function onMouseUpHandler():void 
	{
		this.isMouseDown = false;
		this.fg.show();
		this.spt.stopDrag();
	}
	
	private function onSptMouseDownHandler(event:Event):void 
	{
		event.stopPropagation();
		this.fg.pause()
		this.spt.startDrag();
	}
	
	override public function destroySelf():void 
	{
		if (this.spt)
		{
			this.spt.off(Event.MOUSE_DOWN, this, onSptMouseDownHandler);
			this.spt.removeSelf();
			this.spt.destroy();
			this.spt = null;
		}
		if (this.fg)
		{
			this.fg.destroy();
			this.fg = null;
		}
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		this.clearTimer(this, loop);
		super.destroySelf();
	}
}
}