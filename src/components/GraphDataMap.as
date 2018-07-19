package components 
{
import laya.display.Sprite;
import laya.maths.Point;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
import utils.MathUtil;
/**
 * ...图形数据图 
 * 用于游戏中展示角色数据
 * @author ...Kanon
 */
public class GraphDataMap extends Sprite 
{
	//动画间隔(毫秒)
	private var _duration:int = 500;
	//是否显示过渡动画
	public var isShowAnim:Boolean = true;
	//数值最大值
	public var maxValue:Number;
	//数据填充颜色
	public var dataFillColor:String = "#FF0000";
	//数据线段颜色
	public var dataLineColor:String = "#FF0000";
	//图形线段颜色
	public var graphLineColor:String = "#FFFFFF";
	//数据点的半径
	public var dataPointRadius:Number = 3;
	//画布
	private var fillCanvas:Sprite;
	//是否显示绘制的线条
	private var _showDraw:Boolean;
	//角数
	private var _count:uint;
	//数据线半径
	private var _radius:Number;
	//数据列表
	private var pointList:Array;
	private var pointDataList:Array;
	//最少角数不小于3个
	private static const MIN_COUNT:uint = 3;
	public function GraphDataMap() 
	{
		this.count = 6;
		this.radius = 100;
		this.maxValue = 100;
		this.duration = 200;
		this.fillCanvas = new Sprite();
		this.fillCanvas.alpha = .5;
		this.addChild(this.fillCanvas);
		this.initGraphDataPoint();
	}	

	/**
	 * 初始化数据点
	 */
	private function initGraphDataPoint():void
	{
		this.pointList = [];
		this.pointDataList = [];
		var angle:Number = 360 / this.count;
		var curAngle:Number = 90;
		var sp:Point = new Point();
		this.pointList.push(sp);
		for (var i:int = 0; i < this.count; i++) 
		{
			var p:Point = new Point();
			var rds:Number = MathUtil.dgs2rds(curAngle);
			p.x = Math.cos(rds) * this.radius;
			p.y = Math.sin(rds) * this.radius;
			curAngle -= angle;
			this.pointList.push(p);
			this.pointDataList.push(new Point());
		}
	}
	
	/**
	 * 绘制外形线条
	 * @param	lineColor	线段颜色
	 * @param	lineWidth	线段宽度
	 */
	public function drawGraphLine(lineColor:String = "#FFFFFF", lineWidth:Number = 1):void
	{
		this.graphics.clear();
		if (!this.showDraw) return;
		var length:int = this.pointList.length
		var sp:Point = this.pointList[0]
		var np:Point;
		for (var i:int = 1; i < length; i++) 
		{
			var p:Point = this.pointList[i];
			this.graphics.drawLine(sp.x, sp.y, p.x, p.y, lineColor, lineWidth);
			if (i < length - 1) np = this.pointList[i + 1];
			else np = this.pointList[1];
			this.graphics.drawLine(p.x, p.y, np.x, np.y, lineColor, lineWidth);
		}
	}
	
	/**
	 * 绘制图形
	 * @param	dataList	数量列表 [0 到 maxValue, 0 到 maxValue ]
	 */
	public function drawGraph(dataList:Array):void
	{	
		if (!dataList || dataList.length == 0) return;
		var length:int = this.pointDataList.length;
		var angle:Number = 360 / this.count;
		var curAngle:Number = 90;
		for (var i:int = 0; i < length; i++) 
		{
			var value:Number = 0;
			if (i < dataList.length) value = dataList[i];
			if (value < 0) value = 0;
			else if (value > this.maxValue) value = this.maxValue;
			
			var rds:Number = MathUtil.dgs2rds(curAngle);
			var r:Number = this._radius * (value / this.maxValue);
			var x:Number = Math.cos(rds) * r;
			var y:Number = Math.sin(rds) * r;
			var point:Point = this.pointDataList[i];
			curAngle -= angle;
			if (this.isShowAnim) 
			{
				this.frameLoop(1, this, loopHandler)
				if (i == length - 1)
					Tween.to(point, {x:x, y:y, complete:Handler.create(this, completeHandler)}, this._duration, Ease.sineOut, null, 0, true);
				else
					Tween.to(point, {x:x, y:y}, this._duration, Ease.sineOut, null, 0, true);
			}
			else
			{
				point.x = x;
				point.y = y;
			}
		}
		if (!this.isShowAnim)
			this.updateHandler();
	}
	
	private function completeHandler():void
	{
		this.clearTimer(this, loopHandler);
		this.loopHandler(this, loopHandler);
	}
	
	private function loopHandler():void 
	{
		this.fillCanvas.graphics.clear();
		var ptList:Array = [];
		var length:int = this.pointDataList.length;
		for (var i:int = 0; i < length; i++) 
		{
			var point:Point = this.pointDataList[i];
			ptList.push(point.x);
			ptList.push(point.y);
			this.fillCanvas.graphics.drawCircle(point.x, point.y, this.dataPointRadius, this.dataFillColor, this.dataLineColor);
		}
		this.fillCanvas.graphics.drawPoly(0, 0, ptList, this.dataFillColor, this.dataLineColor);
	}
	
	/**
	 * 是否绘制图形
	 */
	public function get showDraw():Boolean {return _showDraw;}
	public function set showDraw(value:Boolean):void 
	{
		_showDraw = value;
		this.drawGraphLine(this.graphLineColor);
	}
	
	/**
	 * 角数
	 */
	public function get count():uint {return _count;}
	public function set count(value:uint):void 
	{
		_count = value;
		if (_count < MIN_COUNT) _count = MIN_COUNT;
		this.initGraphDataPoint();
		this.drawGraphLine(this.graphLineColor);
	}
	
	/**
	 * 半径
	 */
	public function get radius():Number {return _radius;}
	public function set radius(value:Number):void 
	{
		_radius = value;
		this.initGraphDataPoint();
		this.drawGraphLine(this.graphLineColor);
	}
	
	/**
	 * 过渡动画的时间间隔
	 */
	public function get duration():int {return _duration;}
	public function set duration(value:int):void 
	{
		if (value < 0) value = 0;
		if (value == 0) this.isShowAnim = false;
		else this.isShowAnim = true;
		_duration = value;
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.clearTimer(this, loopHandler);
		var length:int = this.pointDataList.length;
		for (var i:int = 0; i < length; i++) 
		{
			var point:Point = this.pointDataList[i];
			Tween.clearAll(point);
		}
		this.pointList = null;
		this.pointDataList = null;
		if (this.fillCanvas)
		{
			this.fillCanvas.graphics.clear();
			this.fillCanvas.removeSelf();
			this.fillCanvas.destroy();
			this.fillCanvas = null;
		}
		this.destroy();
	}
}
}