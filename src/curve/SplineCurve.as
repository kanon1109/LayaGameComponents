package curve 
{
import laya.d3.math.Vector2;
/**
 * ...样条曲线
 * @author ...Kanon
 */
public class SplineCurve 
{
	private var points:Array;
	public function SplineCurve(points:Array) 
	{
		this.addPoints(points);
	}
	
	/**
	 * 添加一组坐标点
	 * @param	points	坐标点数组
	 */
	public function addPoints(points:Array):void
	{
		if (!points) return;
		this.points = [];
		var lenght:int = points.length;
		for (var i:int = 0; i < lenght; i++) 
		{
			var v2d:Vector2 = points[i];
			this.points.push(v2d.clone());
		}
	}
	
	/**
	 * 添加一个坐标点
	 * @param	x	x坐标
	 * @param	y	y坐标
	 */
	public function addPoint(x:Number, y:Number):void
	{
		if (!this.points) this.points = [];
		this.points.push(new Vector2(x, y));
	}
	
	/**
	 * 获取曲线上某一点的位置
	 * @param	t 沿曲线的位置其中0是开始，1是结束。
	 * @return	位置坐标
	 */
	public function getPoint(t:Number):Vector2
	{
		if (!this.points) return new Vector2();
		var points:Array = this.points;
		var point:Number = (this.points.length - 1) * t;
		var intPoint:Number = Math.floor(point);
		var weight:Number = point - intPoint;
		var p0:Vector2 = points[(intPoint === 0) ? intPoint : intPoint - 1];
        var p1:Vector2 = points[intPoint];
        var p2:Vector2 = points[(intPoint > points.length - 2) ? points.length - 1 : intPoint + 1];
        var p3:Vector2 = points[(intPoint > points.length - 3) ? points.length - 1 : intPoint + 2];
        return new Vector2(this.catmullRom(weight, p0.x, p1.x, p2.x, p3.x), this.catmullRom(weight, p0.y, p1.y, p2.y, p3.y));
	}
	
	/**
	 * 获取起始点
	 * @return
	 */
	public function getStartPoint():Vector2
	{
		if (!this.points) return new Vector2();
		return this.points[0];
	}
	
	/**
	 * Calculates a Catmull-Rom value.
	 * @param	t	The percentage of interpolation, between 0 and 1.
	 * @param	p0	
	 * @param	p1
	 * @param	p2
	 * @param	p3
	 * @return	插值
	 */
	private function catmullRom(t:Number, p0:Number, p1:Number, p2:Number, p3:Number):Number
	{
		var v0:Number = (p2 - p0) * 0.5;
		var v1:Number = (p3 - p1) * 0.5;
		var t2:Number = t * t;
		var t3:Number = t * t2;
		return (2 * p1 - 2 * p2 + v0 + v1) * t3 + ( -3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.points = null;
	}
}
}