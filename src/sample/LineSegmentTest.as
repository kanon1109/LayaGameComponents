package sample 
{
import geom.LineSegment;
import geom.Vector2D;
import laya.display.Sprite;
import laya.events.Event;
/**
 * ...线段测试
 * @author ...Kanon
 */
public class LineSegmentTest extends SampleBase 
{
	private var sp0:Sprite;
	private var sp1:Sprite;
	private var sp2:Sprite;
	private var canves:Sprite;
	private var curSp:Sprite;
	private var ls:LineSegment;
	public function LineSegmentTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "LineSegmentTest";
		
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
		this.sp0.x = 100;
		this.sp0.y = 100;
		
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
		this.sp1.x = 200;
		this.sp1.y = 300;
		
		this.sp2 = new Sprite();
		this.sp2.width = 20;
		this.sp2.height = 20;
		this.sp2.pivotX = 10;
		this.sp2.pivotY = 10;
		this.sp2.name = "sp2";
		this.sp2.graphics.drawCircle(10, 10, 10, "#00FFFF");
		this.addChild(this.sp2);
		this.sp2.mouseEnabled = true;
		this.sp2.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		this.sp2.x = 400;
		this.sp2.y = 450;
		
		this.canves = new Sprite();
		this.addChild(this.canves);
		
		this.ls = new LineSegment(new Vector2D(this.sp0.x, this.sp0.y), new Vector2D(this.sp1.x, this.sp1.y));
		
		this.draw();
		
		Laya.stage.on(Event.MOUSE_UP, this, onMouseUpHandler);
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
			this.ls.startPoint.x = this.curSp.x;
			this.ls.startPoint.y = this.curSp.y;
		}
		else if (this.curSp.name == "sp1")
		{
			this.ls.endPoint.x = this.curSp.x;
			this.ls.endPoint.y = this.curSp.y;
		}
		
		this.draw();
	}
	
	private function onMouseUpHandler(event:Event):void 
	{
		this.curSp = null;
		Laya.stage.off(Event.MOUSE_MOVE, this, onStageMouseMove);
	}
	
	private function draw():void
	{
		if (this.canves)
		{
			var color:String = "#FFFFFF";
			// 判断碰撞
			if (this.ls && this.ls.distToSegmentSquared(new Vector2D(this.sp2.x, this.sp2.y), 50, this.ls.startPoint, this.ls.endPoint))
				color = "#FF0000";
				
			this.canves.graphics.clear();
			this.canves.graphics.drawLine(this.ls.startPoint.x, this.ls.startPoint.y, this.ls.endPoint.x, this.ls.endPoint.y, "#00FFFF", 1);
			this.canves.graphics.drawCircle(this.sp2.x, this.sp2.y, 50, null, color, 1);
		}
	}
	
	override public function destroySelf():void 
	{
		if (this.canves)
		{
			this.canves.graphics.clear();
			this.canves.destroy();
			this.canves.removeSelf();
			this.canves = null;
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
		if (this.sp2)
		{
			this.sp2.destroy();
			this.sp2.removeSelf();
			this.sp2 = null;
		}
		this.ls = null;
		this.curSp = null;
		super.destroySelf();
	}
}
}