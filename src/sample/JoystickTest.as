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
	private var joystick:Joystick;
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
		this.joystick = new Joystick();
		this.joystick.initUI("res/joystick.png", "res/base.png");
		this.joystick.setStickPos(150, Laya.stage.height - 220);
		this.joystick.size(Laya.stage.width / 2, Laya.stage.height / 2);
		this.joystick.mouseMoveHandler = new Handler(this, mouseMoveHandler);
		this.addChild(this.joystick);
		
		this.rect = new Sprite();
		this.rect.graphics.drawRect(-25, -25, 50, 50, "#FF0000");
		this.rect.x = Laya.stage.width / 2;
		this.rect.y = 130;
		this.addChild(this.rect);
	}
	
	private function mouseMoveHandler():void 
	{
		var vx:Number = Math.cos(this.joystick.joystickAngleRad) * this.speed * this.joystick.rate;
		var vy:Number = Math.sin(this.joystick.joystickAngleRad) * this.speed * this.joystick.rate;
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
		if (this.joystick)
		{
			this.joystick.destroySelf();
			this.joystick = null;
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