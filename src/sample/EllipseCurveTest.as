package sample 
{
import curve.EllipseCurve;
import laya.d3.math.Vector2;
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Label;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ... 样条曲线测试
 * @author ...Kanon
 */
public class EllipseCurveTest extends SampleBase 
{
	private var ec:EllipseCurve;
	private var canves:Sprite;
	private var ball:Sprite;
	private var curSp:Sprite;
	private var sp0:Sprite;
	private var sp1:Sprite;
	private var tw:Tween;
	public function EllipseCurveTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "EllipseCurveTest";
		
		this.canves = new Sprite();
		this.addChild(this.canves);
		
		this.ec = new EllipseCurve(stage.width / 2, stage.height / 2, 50, 150, 0);
		this.ec.draw(this.canves.graphics);
		
		this.sp0 = new Sprite();
		this.sp0.width = 20;
		this.sp0.height = 20;
		this.sp0.pivotX = 10;
		this.sp0.pivotY = 10;
		this.sp0.graphics.drawCircle(10, 10, 10, "#FFFF00");
		this.sp0.name = "sp0";
		this.addChild(this.sp0);
		this.sp0.mouseEnabled = true;
		this.sp0.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		this.sp0.x = this.ec.x;
		this.sp0.y = this.ec.y;
		
		this.sp1 = new Sprite();
		this.sp1.width = 20;
		this.sp1.height = 20;
		this.sp1.pivotX = 10;
		this.sp1.pivotY = 10;
		this.sp1.name = "sp1";
		this.sp1.graphics.drawCircle(10, 10, 10, "#00FFFF");
		this.addChild(this.sp1);
		this.sp1.mouseEnabled = true;
		this.sp1.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		this.sp1.x = this.ec.x + this.ec.xRadius;
		this.sp1.y = this.ec.y + this.ec.yRadius;
		
		this.ball = new Sprite();
		this.ball.width = 20;
		this.ball.height = 20;
		this.ball.pivotX = 10
		this.ball.pivotY = 10;
		this.ball.x = 0;
		this.ball.y = 0;
		this.ball.graphics.drawCircle(10, 10, 10, "#CCFF00");
		
		var position:Vector2 = this.ec.getPoint(0);
		this.ball.x = position.x;
		this.ball.y = position.y;
		
		this.addChild(this.ball);
		var o:Object = {value : 0};
		this.tw = Tween.to(o, {value:1, complete:Handler.create(this, completeHandler, [o]), update:Handler.create(this, updateHandler, [o], false)}, 1000, Ease.linearNone);
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
	}

	private function updateHandler(o:Object):void
	{
		var position:Vector2 = this.ec.getPoint(o.value);
		this.ball.x = position.x;
		this.ball.y = position.y;
	}
	
	private function completeHandler(o:Object):void
	{
		if (this.tw)
		{
			this.tw.clear();
			this.tw = null
		}
		var value:int = o.value;
		if (value == 1) 
		{
			o = {};
			o.value = 1;
			value = 0;
		}
		else
		{
			o = {};
			o.value = 0;
			value = 1;
		}
		this.tw = Tween.to(o, {value:value, complete:Handler.create(this, completeHandler, [o]), update:Handler.create(this, updateHandler, [o], false)}, 1000, Ease.linearNone);
	}
	
	private function onMouseDownHandler(event:Event):void 
	{
		this.curSp = event.target as Sprite;
		Laya.stage.on(Event.MOUSE_MOVE, this, onStageMouseMove);
	}
	
	private function onStageMouseMove(event:Event):void 
	{
		this.curSp.x = event.stageX;
		this.curSp.y = event.stageY;
		if (this.curSp.name == "sp0")
		{
			this.ec.x = event.stageX;
			this.ec.y = event.stageY;
			this.sp1.x = this.ec.x + this.ec.xRadius;
			this.sp1.y = this.ec.y + this.ec.yRadius;
		}
		else
		{
			this.ec.xRadius = this.curSp.x - this.ec.x;
			this.ec.yRadius = this.curSp.y - this.ec.y;
		}
		this.ec.draw(this.canves.graphics);
	}
		
	private function onMouseUpHandler(event:Event):void 
	{
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void 
	{
		if (this.canves)
		{
			this.canves.graphics.clear();
			this.canves.destroy();
			this.canves.removeSelf();
			this.canves = null;
		}
		if (this.ball)
		{
			this.ball.destroy();
			this.ball.removeSelf();
			this.ball = null;
		}
		if (this.tw)
		{
			this.tw.clear();
			this.tw = null
		}
		if (this.ec)
		{
			this.ec.destroySelf();
			this.ec = null;
		}
		if (this.sp0)
		{
			this.sp0.destroy();
			this.sp0.removeSelf();
			this.sp0 = null;
		}
		if (this.sp1)
		{
			this.sp1.destroy();
			this.sp1.removeSelf();
			this.sp1 = null;
		}
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		super.destroySelf();
	}
}
}