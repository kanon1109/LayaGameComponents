package curve 
{
import laya.d3.math.Vector2;
import laya.display.Graphics;
/**
 * ...二次贝塞尔曲线
 * @author ...Kanon
 */
public class QuadraticBezierCurve 
{
	//起始点
	private var p0:Vector2;
	//控制点
	private var p1:Vector2;
	//结束点
	private var p2:Vector2;
	public function QuadraticBezierCurve(p0:Vector2, p1:Vector2, p2:Vector2) 
	{
		this.initPoints(p0, p1, p2);
	}
	
	/**
	 * 初始化点
	 * @param	p0	起始点
	 * @param	p1	控制点
	 * @param	p2	结束点
	 */
	public function initPoints(p0:Vector2, p1:Vector2, p2:Vector2):void
	{
		this.p0 = p0;
		this.p1 = p1;
		this.p2 = p2;
	}
	
	/**
	 * 获取起始点
	 * @return
	 */
	public function getStartPoint():Vector2
	{
		return this.p0;
	}
	
	/**
	 * 获取曲线上某一点的位置
	 * @param	t 沿曲线的位置其中0是开始，1是结束。
	 * @return	位置坐标
	 */
	public function getPoint(t:Number):Vector2
	{
		if (t < 0) t = 0;
		else if (t > 1) t = 1;
		
		return new Vector2(this.quadraticBezier(t, this.p0.x, this.p1.x, this.p2.x), 
						   this.quadraticBezier(t, this.p0.y, this.p1.y, this.p2.y));
	}
	
	/**
	 * 使用getPoint获取点序列
	 * @param	divisions		分割数量
	 * @return	坐标列表
	 */
	public function getPoints(divisions:int = 5):Array
	{
		var points:Array = [];
		for (var i:int = 0; i <= divisions; i++) 
		{
			points.push(this.getPoint(i / divisions));
		}
		return points;
	}
	
	/**
	 * 绘制
	 * @param	graphics		画布
	 * @param	pointsTotal		点的数量	
	 */
	public function draw(graphics:Graphics, pointsTotal:int = 32):void
	{
		if (!graphics) return;
		graphics.clear();
		var points:Array = this.getPoints(pointsTotal);
		var length:int = points.length;
		var sp:Vector2 = points[0]
		for (var i:int = 1; i < length; i++) 
		{
			var p:Vector2 = points[i];
			graphics.drawLine(sp.x, sp.y, p.x, p.y, "#FFFFFF", 1);
			sp = p;
		}
	}
	
	private function P0(t:Number, p:Number):Number
	{
		var k:Number = 1 - t;
		return k * k * p;
	}

	private function P1(t:Number, p:Number):Number
	{
		return 2 * (1 - t) * t * p;
	}

	private function P2(t:Number, p:Number):Number
	{
		return t * t * p;
	}
	
	/**
	 * 一种两次次贝塞尔插值方法。
	 * @param	t	The percentage of interpolation, between 0 and 1.
	 * @param	p0	起始点
	 * @param	p1	控制点
	 * @param	p2	结束点
	 * @return	插值
	 */
	public function quadraticBezier(t:Number, p0:Number, p1:Number, p2:Number):Number
	{
		return P0(t, p0) + P1(t, p1) + P2(t, p2);
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.p0 = null;
		this.p1 = null;
		this.p2 = null;
	}
}
}