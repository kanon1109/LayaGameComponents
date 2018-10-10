package sample 
{
import effect.Chain;
import laya.events.Event;
/**
 * ...链子效果测试
 * @author Kanon
 */
public class ChainTest extends SampleBase 
{
	private var chain:Chain;
	private var isMouseDown:Boolean;
	public function ChainTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "Chain";
		this.chain = new Chain(this);
		this.chain.move(Laya.stage.mouseX, Laya.stage.mouseY);
		this.chain.lineColor = "#FFFF00";
		this.chain.lineSize = 20;
		Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
		this.frameLoop(1, this, loop);
	}
	
	private function onMouseUpHandler():void 
	{
		this.isMouseDown = false;
		this.chain.clear();
	}
	
	private function onMouseDownHandler():void 
	{
		this.isMouseDown = true;
		this.chain.move(Laya.stage.mouseX, Laya.stage.mouseY);
	}
	
	private function loop():void 
	{
		if (this.isMouseDown)
			this.chain.update(Laya.stage.mouseX, Laya.stage.mouseY);
	}
	
	override public function destroySelf():void 
	{
		if (this.chain)
		{
			this.chain.destroy();
			this.chain = null;
		}
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		this.clearTimer(this, loop);
		super.destroySelf();
	}
}
}