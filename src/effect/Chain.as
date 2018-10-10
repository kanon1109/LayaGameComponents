package effect 
{
import laya.display.Sprite;
import laya.maths.Point;
/**
 * ...链子效果
 * @author Kanon
 */
public class Chain 
{
	//存放线条的字典
	private var lineAry:Array;
	//对象池
	private var pool:Array;
	//外部容器
	private var parent:Sprite;
	//还未加速度前的位置
	private var prevPos:Point;
	//加了速度的位置
	private var curPos:Point;
	//线条颜色和粗细
	protected var _lineColor:String = "#FFFFFF";
	protected var _lineSize:Number = 8;
	public function Chain(parent:Sprite) 
	{
		this.parent = parent;

		this.lineAry = [];
		this.pool = [];
		this.prevPos = new Point();
		this.curPos = new Point();
	}
	
	/**
	 * 移动初始点
	 * @param	x	起始点x坐标
	 * @param	y	起始点y坐标
	 */
	public function move(x:Number, y:Number):void
	{
		this.prevPos.x = x;
		this.prevPos.y = y;
	}

	/**
	 * 渲染效果
	 * @param	targetX  链式效果的目标x位置
	 * @param	targetY  链式效果的目标y位置
	 */
	public function update(targetX:Number, targetY:Number):void
	{
		this.curPos.x = targetX;
		this.curPos.y = targetY;
		if (this.prevPos.distance(this.curPos.x, this.curPos.y) > 1)
		{
			var line:Line;
			//如果对象池是空的则新建一个line
			if (this.pool.length == 0)
			{
				line = new Line(this.prevPos.x, this.prevPos.y,
        					  this.curPos.x, this.curPos.y,
        					  this.lineColor, this.lineSize);
			}
			else
			{
				//对象池获取
				line = this.pool.shift();
				line.init(this.prevPos.x, this.prevPos.y,
    					  this.curPos.x, this.curPos.y,
    					  this.lineColor, this.lineSize);
			}
			if (this.lineAry.indexOf(line) == -1)
				this.lineAry.push(line);
			this.parent.addChild(line);
			this.prevPos.x = targetX;
			this.prevPos.y = targetY;
		}
		this.updateLine();
	}

	/**
	 * 更新线条状态
	 */
	private function updateLine():void
	{
		if (!this.lineAry) return;
		var length:int = this.lineAry.length;
		for(var i:int = length - 1; i >= 0; --i)
		{
			var line:Line = this.lineAry[i];
			line.draw();
			line.thickness--;
			if (line.thickness <= 0)
			{
				line.remove();
				this.lineAry.splice(i, 1);
				this.pool.push(line);
			}
		}
	}

	/**
	 * 清除
	 */
	public function clear():void
	{
		var line:Line;
		var length:int = this.pool.length;
		for (var i:int = length - 1; i >= 0; --i)
		{
			line = this.pool[i];
			line.remove();
			this.pool.splice(i, 1);
		}

		length = this.lineAry.length;
		for(i = length - 1; i >= 0; --i)
		{
			line = this.lineAry[i];
			line.remove();
			this.lineAry.splice(i, 1);
		}
	}

	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.clear();
		this.prevPos = null;
		this.curPos = null;
		this.parent = null;
		this.pool = null;
		this.lineAry = null;
	}

	/**
	 * 设置线条颜色
	 */
	public function get lineColor():String{ return this._lineColor; }
	public function set lineColor(value:String):void
	{
		this._lineColor = value;
	}

	/**
	 * 线条粗细
	 */
	public function get lineSize():Number{ return this._lineSize; }
	public function set lineSize(value:Number):void
	{
		this._lineSize = value;
	}
}
}
import laya.display.Sprite;
class Line extends Sprite
{
	//线条的位置
	private var sx:Number;
	private var sy:Number;
	private var ex:Number;
	private var ey:Number;
	//线条的粗细
	private var _thickness:Number;
	//线条颜色
	private var color:String;
	public function Line(sx:Number, sy:Number, ex:Number, ey:Number, color:String, thickness:Number = 5)
	{
        super();
		this.init(sx, sy, ex, ey, color, thickness);
	}

	/**
	 * 初始化
	 * @param	sx
	 * @param	sy
	 * @param	ex
	 * @param	ey
	 * @param	color
	 * @param	thickness
	 */
	public function init(sx:Number, sy:Number, 
						ex:Number, ey:Number, 
						color:String, thickness:Number = 5):void
	{
		this.sx = sx;
		this.sy = sy;
		this.ex = ex;
		this.ey = ey;
		this.color = color;
		this.thickness = thickness;
	}

	/**
	 * 绘制
	 */
	public function draw():void
	{
		this.graphics.clear();
		this.graphics.drawLine(this.sx, this.sy, 
								this.ex, this.ey, 
								this.color, this.thickness);
	}

	/**
	 * 销毁
	 */
	public function remove():void
	{
		this.graphics.clear();
		if (this.parent)
			this.parent.removeChild(this)
	}

	/**
	 * 线条粗细
	 */
	public function get thickness():Number{ return this._thickness; }
	public function set thickness(value:Number):void
	{
		this._thickness = value;
	}
}
