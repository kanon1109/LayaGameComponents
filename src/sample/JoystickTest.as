package sample 
{
import components.Joystick;
import laya.display.Sprite;
import laya.net.Loader;
import laya.utils.Handler;

/**
 * ...摇杆测试类
 * @author ...Kanon
 */
public class JoystickTest extends SampleBase 
{
	private var rect:Sprite;
	private var moveJoystick:Joystick;
	private var dirJoystick:Joystick;
	private var speed:Number = 10;
	public function JoystickTest() 
	{
		
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "joystick";
		
		var arr:Array = [];
		arr.push({url:"res/joystick.png", type:Loader.IMAGE});
		arr.push({url:"res/base.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.moveJoystick = new Joystick();
		this.moveJoystick.initUI("res/joystick.png", "res/base.png");
		this.moveJoystick.setStickPos(120, Laya.stage.height - 200);
		this.moveJoystick.size(Laya.stage.width / 2, Laya.stage.height);
		this.moveJoystick.mouseMoveHandler = new Handler(this, moveJoystickMouseMoveHandler);
		this.addChild(this.moveJoystick);
		
		this.dirJoystick = new Joystick();
		this.dirJoystick.initUI("res/joystick.png", "res/base.png");
		this.dirJoystick.initStickPos(Laya.stage.width / 2 - 120, Laya.stage.height - 200);
		this.dirJoystick.size(Laya.stage.width / 2, Laya.stage.height);
		this.dirJoystick.x = Laya.stage.width / 2;
		this.dirJoystick.fixType = Joystick.HALF_FIXED;
		this.dirJoystick.mouseMoveHandler = new Handler(this, dirJoystickMouseMoveHandler);
		this.addChild(this.dirJoystick);
		
		this.rect = new Sprite();
		this.rect.graphics.drawRect(-25, -25, 50, 50, "#FF0000");
		this.rect.x = Laya.stage.width / 2;
		this.rect.y = 130;
		this.addChild(this.rect);
	}
	
	private function dirJoystickMouseMoveHandler():void 
	{
		this.rect.rotation = this.dirJoystick.joystickAngleDeg;
	}
	
	private function moveJoystickMouseMoveHandler():void 
	{
		var vx:Number = Math.cos(this.moveJoystick.joystickAngleRad) * this.speed * this.moveJoystick.rate;
		var vy:Number = Math.sin(this.moveJoystick.joystickAngleRad) * this.speed * this.moveJoystick.rate;
		
		this.rect.x += vx;
		this.rect.y += vy;
		
		if (this.rect.x < 25) this.rect.x = 25;
		else if (this.rect.x > Laya.stage.width - 25) this.rect.x = Laya.stage.width - 25;
		
		if (this.rect.y < 25) this.rect.y = 25;
		else if (this.rect.y > Laya.stage.height - 25) this.rect.y = Laya.stage.height - 25;
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void
	{
		if (this.moveJoystick)
		{
			this.moveJoystick.destroySelf();
			this.moveJoystick = null;
		}
		
		if (this.dirJoystick)
		{
			this.dirJoystick.destroySelf();
			this.dirJoystick = null;
		}
		
		if (this.rect)
		{
			this.rect.removeSelf();
			this.rect = null;
		}
		
		super.destroySelf();
	}
}
}