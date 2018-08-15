package curve 
{
import laya.d3.math.Vector2;
import laya.display.Graphics;
import utils.MathUtil;
/**
 * ...椭圆曲线
 * @author ...Kanon
 */
public class EllipseCurve 
{
	private var p0:Vector2;
	private var _xRadius:Number;
	private var _yRadius:Number;
	private var _startAngle:Number;
	private var _endAngle:Number;
	private var _clockwise:Boolean;
	private var _rotation:Number;
	public function EllipseCurve(x:Number=0, y:Number=0, 
								xRadius:Number=0, yRadius:Number=0, 
								startAngle:int=0, endAngle:int=360, 
								clockwise:Boolean=false, rotation:int=0) 
	{
		this.init(x, y, xRadius, yRadius, startAngle, endAngle, clockwise, rotation);
	}
	
	/**
	 * 初始化
	 * @param	x			起始x坐标
	 * @param	y			起始y坐标
	 * @param	xRadius		横向半径
	 * @param	yRadius		纵向半径
	 * @param	startAngle	起点角度（0-360）
	 * @param	endAngle	终点角度（0-360）
	 * @param	clockwise	顺时针
	 * @param	rotation	角度
	 */
	public function init(x:Number=0, y:Number=0, 
						xRadius:Number=0, yRadius:Number=0, 
						startAngle:int=0, endAngle:int=360, 
						clockwise:Boolean=false, rotation:int=0):void
	{
		this.p0 = new Vector2(x, y);
		this._xRadius = xRadius;
		this._yRadius = yRadius;
		this._startAngle = MathUtil.dgs2rds(startAngle);
		this._endAngle = MathUtil.dgs2rds(endAngle);
		this._clockwise = clockwise;
		this._rotation = MathUtil.dgs2rds(rotation);
	}
	
	/**
	 * 获取起始点
	 * @return
	 */
	public function getStartPoint():Vector2
    {
        return this.getPoint(0);
    }
	
	/**
	 * 获取曲线上某一点的位置
	 * @param	t 沿曲线的位置其中0是开始，1是结束。
	 * @return	位置坐标
	 */
	public function getPoint(t:Number):Vector2
	{
		var twoPi:Number = Math.PI * 2;
        var deltaAngle:Number = this._endAngle - this._startAngle;
        var samePoints:Boolean = Math.abs(deltaAngle) < __JS__("Number.EPSILON");

        // ensures that deltaAngle is 0 .. 2 PI
        while (deltaAngle < 0)
        {
            deltaAngle += twoPi;
        }

        while (deltaAngle > twoPi)
        {
            deltaAngle -= twoPi;
        }

        if (deltaAngle < __JS__("Number.EPSILON"))
        {
            if (samePoints)
                deltaAngle = 0;
            else
                deltaAngle = twoPi;
        }

        if (this._clockwise && !samePoints)
        {
            if (deltaAngle === twoPi)
                deltaAngle = - twoPi;
            else
                deltaAngle = deltaAngle - twoPi;
        }

        var angle:Number = this._startAngle + t * deltaAngle;
        var x:Number = this.p0.x + this._xRadius * Math.cos(angle);
        var y:Number = this.p0.y + this._yRadius * Math.sin(angle);

        if (this._rotation !== 0)
        {
            var cos:Number = Math.cos(this._rotation);
            var sin:Number = Math.sin(this._rotation);

            var tx:Number = x - this.p0.x;
            var ty:Number = y - this.p0.y;

            // Rotate the point about the center of the ellipse.
            x = tx * cos - ty * sin + this.p0.x;
            y = tx * sin + ty * cos + this.p0.y;
        }
        return new Vector2(x, y);
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
	
	/**
	 * 横向半径
	 */
	public function get xRadius():Number {return _xRadius;}
	public function set xRadius(value:Number):void 
	{
		_xRadius = value;
	}
	
	/**
	 * 纵向半径
	 */
	public function get yRadius():Number {return _yRadius;}
	public function set yRadius(value:Number):void 
	{
		_yRadius = value;
	}
	
	/**
	 * 椭圆宽度
	 */
	public function set width(value:Number):void 
	{
		this._xRadius = value * 2;
	}	

	/**
	 * 椭圆高度
	 */
	public function set height(value:Number):void 
	{
		this._yRadius = value * 2;
	}
	
	/**
	 * 起点角度
	 */
	public function get startAngle():Number {return MathUtil.rds2dgs(_startAngle);}
	public function set startAngle(value:Number):void 
	{
		_startAngle = MathUtil.dgs2rds(value);
	}
	
	/**
	 * 终点角度
	 */
	public function get endAngle():Number {return MathUtil.rds2dgs(_endAngle);}
	public function set endAngle(value:Number):void 
	{
		_endAngle = MathUtil.dgs2rds(value);
	}
	
	/**
	 * 是否顺时针
	 */
	public function get clockwise():Boolean {return _clockwise;}
	public function set clockwise(value:Boolean):void 
	{
		_clockwise = value;
	}
	
	/**
	 * 椭圆角度
	 */
	public function get rotation():Number {return MathUtil.rds2dgs(_rotation);}
	public function set rotation(value:Number):void 
	{
		_rotation = MathUtil.dgs2rds(value);
	}
	
	/**
	 * x坐标
	 */
	public function get x():Number {return this.p0.x; }
	public function set x(value:Number):void 
	{
		this.p0.x = value;
	}
	
	/**
	 * y坐标
	 */
	public function get y():Number {return this.p0.y; }
	public function set y(value:Number):void 
	{
		this.p0.y = value;
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.p0 = null;
	}
}
}