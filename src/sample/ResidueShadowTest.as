package sample 
{
import effect.ResidueShadow;
import laya.ani.bone.Skeleton;
import laya.ani.bone.Templet;
import laya.display.Animation;
import laya.display.Sprite;
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
	//骨骼动画
	private var bossAni1:Skeleton;
	//序列帧动画
	private var bossAni2:Animation;
	private var curSpt:Sprite;
	public function ResidueShadowTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "ResidueShadow";
		
		this.rs = new ResidueShadow();
		this.rs.init(this, 800);
		
		var arr:Array = [];
		arr.push({url:"res/role.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, function():void {
			this.img = new Image("res/role.png");
			this.img.x = Laya.stage.width / 2;
			this.img.y = Laya.stage.height / 2;
			this.addChild(this.img);
			this.img.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
			Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
			this.frameLoop(1, this, loop);
			this.rs.push(this.img);
		}), null, Loader.IMAGE);
		
		
		arr = [];
		arr.push( { url:"res/enemy1.json", type:Loader.ATLAS } );
		Laya.loader.load(arr, Handler.create(this, function():void {
			this.bossAni2 = new Animation();
			this.bossAni2.loadAtlas("res/enemy1.json", Handler.create(this, function():void {
				this.bossAni2.play();
				this.bossAni2.autoSize = true;
				this.bossAni2.x = 300;
				this.bossAni2.y = 200;
				this.rs.push(this.bossAni2);
			}));
			this.bossAni2.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
			this.addChild(this.bossAni2);
		}), null, Loader.ATLAS);
		
		//骨骼动画
		var temp:Templet = new Templet();
		temp.on(Event.COMPLETE, this, function(fac:Templet):void
		{
			this.bossAni1 = fac.buildArmature(0);
			this.bossAni1.x = 100;
			this.bossAni1.y = 200;
			this.bossAni1.play(0, true);
			this.bossAni1.autoSize = true;
			this.bossAni1.pivotX = -this.bossAni1.width / 2;
			this.bossAni1.pivotY = -this.bossAni1.height;
			this.bossAni1.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
			this.rs.push(this.bossAni1);
			this.addChild(this.bossAni1);
		});
		temp.on(Event.ERROR, this, function(e:*):void {
			trace("load fail");
		});
		temp.loadAni("res/boss1Ani.sk");
	}
	
	private function loop():void 
	{
		if (this.rs)
			this.rs.render();
	}
	
	private function onMouseDownHandler(event:Event):void 
	{
		this.curSpt = event.target;
		if (this.curSpt)
			this.curSpt.startDrag();
	}
	
	private function onMouseUpHandler():void 
	{
		if (this.curSpt)
		{
			//this.rs.remove(this.curSpt);
			this.curSpt.stopDrag();
		}
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
		if (this.bossAni1)
		{
			this.bossAni1.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
			this.bossAni1.removeSelf();
			this.bossAni1.destroy();
			this.bossAni1 = null;
		}
		if (this.bossAni2)
		{
			this.bossAni2.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
			this.bossAni2.removeSelf();
			this.bossAni2.destroy();
			this.bossAni2 = null;
		}
		this.curSpt = null;
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		super.destroySelf();
	}
}
}