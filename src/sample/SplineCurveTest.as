package sample 
{
import curve.SplineCurve;
import laya.d3.math.Vector2;
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Label;
import laya.utils.Dictionary;
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
	private var curSp:Sprite;
	private var tw:Tween;
	private var spArr:Array;
	private var dict:Dictionary;
	private var txt:Label;
	public function SplineCurveTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "SplineCurveTest";
		
		this.txt = new Label("click stage add point");
		this.txt.color = "FFFFFF";
		this.txt.fontSize = 25;
		this.addChild(this.txt);
		this.txt.x = (stage.width - this.txt.displayWidth) / 2;
		this.txt.y = (stage.height - this.txt.displayHeight) / 2;

		this.canves = new Sprite();
		this.addChild(this.canves);
		
		this.spArr = [];
		this.dict = new Dictionary();
		
		this.ball = new Sprite();
		this.ball.width = 20;
		this.ball.height = 20;
		this.ball.pivotX = 10
		this.ball.pivotY = 10;
		this.ball.x = 0;
		this.ball.y = 0;
		this.ball.graphics.drawCircle(10, 10, 10, "#CCFF00");
		
		this.sc = new SplineCurve();
		this.sc.draw(this.canves.graphics);
		
		var position:Vector2 = this.sc.getPoint(0);
		this.ball.x = position.x;
		this.ball.y = position.y;
		
		Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
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
		sp.mouseEnabled = true;
		sp.on(Event.MOUSE_DOWN, this, onSpMouseDownHandler);
		this.addChild(sp);
		this.spArr.push(sp)
		this.sc.addPoint(event.stageX, event.stageY);
		this.sc.draw(this.canves.graphics, 32 * this.spArr.length);
		this.dict.set(sp, this.spArr.length - 1);
		
		if (this.spArr.length == 2)
		{
			this.addChild(this.ball);
			var o:Object = {value : 0};
			this.tw = Tween.to(o, {value:1, complete:Handler.create(this, completeHandler, [o]), update:Handler.create(this, updateHandler, [o], false)}, 1000, Ease.linearNone);
		}
	}
	
	private function onSpMouseDownHandler(event:Event):void 
	{
		event.stopPropagation();
		this.curSp = event.target as Sprite;
		Laya.stage.on(Event.MOUSE_MOVE, this, onStageMouseMove);
	}
	
	private function onStageMouseMove(event:Event):void 
	{
		this.curSp.x = event.stageX;
		this.curSp.y = event.stageY;
		var index:int = this.dict.get(this.curSp);
		this.sc.setPoint(event.stageX, event.stageY, index);
		this.sc.draw(this.canves.graphics, 32 * this.spArr.length);
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
		if (this.sc)
		{
			this.sc.destroySelf();
			this.sc = null;
		}
		
		if (this.spArr)
		{
			var length:int = this.spArr.length;
			for (var i:int = length - 1; i >= 0; i--) 
			{
				var sp:Sprite = this.spArr[i];
				sp.removeSelf();
				sp.destroy();
				this.spArr.splice(i, 1);
			}
		}
		this.spArr = null;
		this.dict = null;
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		Laya.stage.off(Event.MOUSE_UP, this, onMouseUpHandler);
		super.destroySelf();
	}
}
}