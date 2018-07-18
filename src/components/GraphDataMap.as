package components 
{
import laya.display.Graphics;
import laya.display.Sprite;
import laya.maths.Point;
import utils.MathUtil;
/**
 * ...图形数据图 
 * 用于游戏中展示角色数据
 * @author ...Kanon
 */
public class GraphDataMap extends Sprite 
{
	//数值的步长
	public var step:Number;
	//数值最大值
	public var maxValue:Number;
	//数据填充颜色
	public var dataFillColor:String = "#FF0000";
	//数据线段颜色
	public var dataLineColor:String = "#FF0000";
	//图形线段颜色
	public var graphlineColor:String = "#FFFFFF";
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
	//最少角数不小于3个
	private static const MIN_COUNT = 3;
	public function GraphDataMap() 
	{
		this.count = 6;
		this.radius = 100;
		this.step = 1;
		this.maxValue = 100;
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
		var angle:Number = 360 / this.count;
		var curAngle:Number = 0;
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
		this.fillCanvas.graphics.clear();
		if (!dataList) return;
		var length:int = dataList.length;
		length = this.count - length;
		for (var i:int = 0; i < length; i++) 
		{
			dataList.push(0)
		}
		length = dataList.length;
		var angle:Number = 360 / this.count;
		var curAngle:Number = 0;
		var ptList:Array = [];
		for (var i:int = 0; i < length; i++) 
		{
			var value:Number = dataList[i];
			if (value < 0) value = 0;
			else if (value > this.maxValue) value = this.maxValue;
			var rds:Number = MathUtil.dgs2rds(curAngle);
			var r:Number = this._radius * (value / this.maxValue);
			var p:Point = new Point();
			p.x = Math.cos(rds) * r;
			p.y = Math.sin(rds) * r;
			ptList.push(p.x);
			ptList.push(p.y);
			curAngle -= angle;
			this.fillCanvas.graphics.drawCircle(p.x, p.y, 2, this.dataFillColor, this.dataLineColor);
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
		this.drawGraphLine(this.graphlineColor);
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
		this.drawGraphLine(this.graphlineColor);
	}
	
	/**
	 * 半径
	 */
	public function get radius():Number {return _radius;}
	public function set radius(value:Number):void 
	{
		_radius = value;
		this.initGraphDataPoint();
		this.drawGraphLine(this.graphlineColor);
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.pointList = null;
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