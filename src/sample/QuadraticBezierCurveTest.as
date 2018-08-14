package sample 
{
import curve.QuadraticBezierCurve;
import laya.d3.math.Vector2;
import laya.display.Sprite;
import laya.events.Event;
import laya.maths.Rectangle;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ... 二次贝塞尔测试
 * @author ...Kanon
 */
public class QuadraticBezierCurveTest extends SampleBase 
{
	private var qbc:QuadraticBezierCurve;
	private var canves:Sprite;
	private var sp0:Sprite;
	private var sp1:Sprite;
	private var sp2:Sprite;
	private var ball:Sprite;
	private var curSp:Sprite;
	private var tw:Tween;
	public function QuadraticBezierCurveTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "QuadraticBezierCurve";
		
		this.canves = new Sprite();
		this.addChild(this.canves);
		
		var p0:Vector2 = new Vector2(200, 240)
		var p1:Vector2 = new Vector2(130, 140)
		var p2:Vector2 = new Vector2(330, 140)
		
		this.sp0 = new Sprite();
		this.sp0.x = p0.x;
		this.sp0.y = p0.y;
		this.sp0.width = 20;
		this.sp0.height = 20;
		this.sp0.pivotX = 10
		this.sp0.pivotY = 10
		this.sp0.graphics.drawCircle(10, 10, 10, "#FFFF00");
		this.addChild(this.sp0);
		this.sp0.mouseEnabled = true;
		this.sp0.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		
		this.sp1 = new Sprite();
		this.sp1.x = p1.x;
		this.sp1.y = p1.y;
		this.sp1.width = 20;
		this.sp1.height = 20;
		this.sp1.pivotX = 10
		this.sp1.pivotY = 10
		this.sp1.graphics.drawCircle(10, 10, 10, "#00FFFF");
		this.addChild(this.sp1);
		this.sp1.mouseEnabled = true;
		this.sp1.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		
		this.sp2 = new Sprite();
		this.sp2.x = p2.x;
		this.sp2.y = p2.y;
		this.sp2.width = 20;
		this.sp2.height = 20;
		this.sp2.pivotX = 10
		this.sp2.pivotY = 10
		this.sp2.graphics.drawCircle(10, 10, 10, "#00FFFF");
		this.addChild(this.sp2);
		this.sp2.mouseEnabled = true;
		this.sp2.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		
		this.ball = new Sprite();
		this.ball.width = 20;
		this.ball.height = 20;
		this.ball.pivotX = 10
		this.ball.pivotY = 10
		this.ball.graphics.drawCircle(10, 10, 10, "#CCFF00");
		this.addChild(this.ball);

		this.qbc = new QuadraticBezierCurve(p0, p1, p2);
		this.qbc.draw(this.canves.graphics);
		var position:Vector2 = this.qbc.getPoint(0);
		this.ball.x = position.x;
		this.ball.y = position.y;
		
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
		
		var o:Object = {value : 0};
		this.tw = Tween.to(o, {value:1, complete:Handler.create(this, completeHandler, [o]), update:Handler.create(this, updateHandler, [o], false)}, 1000, Ease.linearNone);
	}
	
	private function updateHandler(o:Object):void
	{
		var position:Vector2 = this.qbc.getPoint(o.value);
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
	
	private function onMouseUpHandler(event:Event):void 
	{
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
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
		
		var p0:Vector2 = new Vector2(this.sp0.x, this.sp0.y)
		var p1:Vector2 = new Vector2(this.sp1.x, this.sp1.y)
		var p2:Vector2 = new Vector2(this.sp2.x, this.sp2.y)
		
		this.qbc.initPoints(p0, p1, p2);
		this.qbc.draw(this.canves.graphics);
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void 
	{
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
		if (this.sp2)
		{
			this.sp2.destroy();
			this.sp2.removeSelf();
			this.sp2 = null;
		}
		if (this.canves)
		{
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
		if (this.qbc)
		{
			this.qbc.destroySelf();
			this.qbc = null;
		}
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		super.destroySelf();
	}
}
}