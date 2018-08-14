package sample 
{
import curve.SplineCurve;
import laya.d3.math.Vector2;
import laya.display.Sprite;
import laya.events.Event;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ... 样条曲线测试
 * @author ...Kanon
 */
public class SplineCurveTest extends SampleBase 
{
	private var sc:SplineCurve;
	private var canves:Sprite;
	private var ball:Sprite;
	private var tw:Tween;
	private var spArr:Array = [];
	public function SplineCurveTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "SplineCurveTest";
		this.sc = new SplineCurve();
		
		this.canves = new Sprite();
		this.addChild(this.canves);
		
		this.ball = new Sprite();
		this.ball.width = 20;
		this.ball.height = 20;
		this.ball.pivotX = 10
		this.ball.pivotY = 10;
		this.ball.x = 0;
		this.ball.y = 0;
		this.ball.graphics.drawCircle(10, 10, 10, "#CCFF00");
		this.addChild(this.ball);
		
		var o:Object = {value : 0};
		this.tw = Tween.to(o, {value:1, complete:Handler.create(this, completeHandler, [o]), update:Handler.create(this, updateHandler, [o], false)}, 1000, Ease.linearNone);
		Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
	}
	
	private function updateHandler(o:Object):void
	{
		var position:Vector2 = this.sc.getPoint(o.value);
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
		var sp:Sprite = new Sprite();
		sp.x = event.stageX;
		sp.y = event.stageY;
		sp.width = 20;
		sp.height = 20;
		sp.pivotX = 10
		sp.pivotY = 10
		sp.graphics.drawCircle(10, 10, 10, "#FFFF00");
		this.addChild(sp);
		this.spArr.push(sp)
		this.sc.addPoint(event.stageX, event.stageY);
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void 
	{
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
		if (this.sc)
		{
			this.sc.destroySelf();
			this.sc = null;
		}
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		super.destroySelf();
	}
}
}