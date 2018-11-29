package sample 
{
import components.Gestures;
import laya.display.Text;
/**
 * ...手势测试
 * @author Kanon
 */
public class GesturesTest extends SampleBase 
{
	private var gestures:Gestures;
	private var txt:Text;
	public function GesturesTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "GesturesTest";
		this.txt = new Text();
		this.txt.fontSize = 30;
		this.txt.color = "#FFFFFF";
		this.txt.x = 300;
		this.txt.y = 30;
		this.addChild(this.txt);
		Laya.stage.frameLoop(1, this, loop);
		this.gestures = new Gestures();
	}
	
	private function loop():void 
	{
		if (this.gestures)
		{
			if (this.gestures.state == Gestures.UP)
				this.txt.text = "gestures's direction is up";
			else if(this.gestures.state == Gestures.DOWN)
				this.txt.text = "gestures's direction is down";
			else if (this.gestures.state == Gestures.LEFT)
				this.txt.text = "gestures's direction is left";
			else if (this.gestures.state == Gestures.RIGHT)
				this.txt.text = "gestures's direction is right";
		}
	}
	
	override public function destroySelf():void 
	{
		Laya.stage.clearTimer(this, loop);
		super.destroySelf();
		if (this.gestures)
		{
			this.gestures.destroySelf();
			this.gestures = null;
		}
		if (this.txt)
		{
			this.txt.removeSelf();
			this.txt.destroy();
			this.txt = null;
		}
	}
}
}