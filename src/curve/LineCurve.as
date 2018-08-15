package curve 
{
import laya.d3.math.Vector2;
import laya.display.Graphics;
import laya.maths.Rectangle;
/**
 * ...线段曲线
 * @author ...Kanon
 */
public class LineCurve 
{
	//起始点
	private var p0:Vector2;
	//结束点
	private var p1:Vector2;
	public function LineCurve(p0:Vector2, p1:Vector2) 
	{
		this.initPoints(p0, p1);
	}
	
	/**
	 * 初始化点	
	 * @param	p0	起始点
	 * @param	p1	结束点
	 */
	public function initPoints(p0:Vector2, p1:Vector2):void
	{
		this.p0 = p0;
		this.p1 = p1;
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
		if (t == 0) return this.p0;
		else if (t == 1) return this.p1;
		var x:Number = this.p1.x - this.p0.x;
		var y:Number = this.p1.y - this.p0.y;
		var v2d:Vector2 = new Vector2(x, y);
		var out:Vector2 = new Vector2();
		Vector2.scale(v2d, t, out);
		return new Vector2(this.p0.x + out.x, this.p0.y + out.y);
	}
	
	/**
	 * 获取范围
	 * @return	范围矩形
	 */
	public function getBounds():Rectangle
	{
		return new Rectangle(this.p0.x, this.p0.y, 
							this.p1.x - this.p0.x, 
							this.p1.y - this.p0.y);
	}
	
	/**
	 * 绘制
	 * @param	graphics		画布
	 */
	public function draw(graphics:Graphics):void
	{
		if (!graphics) return;
		graphics.clear();
		graphics.drawLine(this.p0.x, this.p0.y, 
						  this.p1.x, this.p1.y, 
						  "#FFFFFF", 1);
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.p0 = null;
		this.p1 = null;
	}
}
}