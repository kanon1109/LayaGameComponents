package effect 
{
import laya.display.Sprite;
import laya.resource.Texture;
import utils.Random;
/**
 * ...火焰枪效果
 * @author Kanon
 */
public class FlameGun 
{
	//发射速度
	private var speed:Number;
	//发射角度
	private var _rotation:Number;
	//最大缩放比
	private var maxScale:Number;
	//最小alpha值
	private var minAlpha:Number;
	//最大射程距离
	private var distance:Number;
	//发射位置的浮动
	private var floating:Number;
	//火焰弹列表
	private var flameList:Array;
	//外部容器
	private var parent:Sprite;
	//发射位置x坐标
	private var _startX:Number;
	//发射位置y坐标
	private var _startY:Number;
	//缩放速度
	private var scaleSpeed:Number;
	//透明度速度
	private var alphaSpeed:Number;
	//状态
	private var _status:int;
	//开火状态
	public static const FIRE:int = 1;
	//停止状态
	public static const STOP:int = 0;
	//火焰纹理
	private var tex:Texture;
	public function FlameGun(parent:Sprite, 
							   url:String, 
							   startX:Number = 0, startY:Number = 0,
							   speed:Number = 5,  rotation:Number = 0, 
							   maxScale:Number = 1, minAlpha:Number = .1, 
							   distance:Number = 100, floating:Number = 10, 
							   scaleSpeed:Number = .1, alphaSpeed:Number = .05) 
	{
		this.parent = parent;
		this.speed = speed;
		this.rotation = rotation;
		this.maxScale = maxScale;
		this.minAlpha = minAlpha;
		this.distance = distance;
		this.move(startX, startY);
		this.flameList = [];
		this.floating = floating;
		this.scaleSpeed = scaleSpeed;
		this.alphaSpeed = alphaSpeed;
		this.tex = Laya.loader.getRes(url);
	}
	
	/**
	 * 移动
	 * @param	x	发射位置x坐标
	 * @param	y	发射位置y坐标
	 */
	public function move(x:Number = 0, y:Number = 0):void
	{
		this._startX = x;
		this._startY = y;
	}
		
	/**
	 * 发射
	 */
	private function fire():void
	{
		var rot:Number = this.rotation + Random.randnum(-this.floating, this.floating);
		var rad:Number = rot / 180 * Math.PI;
		var vx:Number = Math.cos(rad) * this.speed;
		var vy:Number = Math.sin(rad) * this.speed;
		var flame:Flame = new Flame();
		flame.source = this.tex;
		flame.init(vx, vy, 
					this.startX, this.startY, 
					this.maxScale, this.minAlpha, 
					this.distance, this.scaleSpeed, this.alphaSpeed);
		flame.rotation = this.rotation;
		this.flameList.push(flame);
		this.parent.addChild(flame);
	}
	
	/**
	 * 渲染
	 */
	public function update():void
	{
		switch (this._status) 
		{
			case FlameGun.FIRE:
				this.fire();
				break;
		}
		//更新火焰弹数据
		var length:int = this.flameList.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			var flame:Flame = this.flameList[i];
			flame.update();
			if (flame.isOutRange())
			{
				flame.removeSelf();
				flame.destroy();
				this.flameList.splice(i, 1);
			}
		}
	}
	
	/**
	 * 显示
	 */
	public function show():void
	{
		this.status = FlameGun.FIRE;
	}
	
	/**
	 * 暂停
	 */
	public function pause():void
	{
		this.status = FlameGun.STOP;
	}
	
	/**
	 * 获取状态
	 */
	public function get status():int 
	{
		return _status;
	}
	
	/**
	 * 设置状态
	 */
	public function set status(value:int):void 
	{
		_status = value;
	}
	
	/**
	 * 获取角度
	 */
	public function get rotation():Number 
	{
		return _rotation;
	}
	
	/**
	 * 设置角度
	 */
	public function set rotation(value:Number):void 
	{
		_rotation = value;
	}
	
	/**
	 * 获取起始x位置
	 */
	public function get startX():Number 
	{
		return _startX;
	}
	
	/**
	 * 获取起始y位置
	 */
	public function get startY():Number 
	{
		return _startY;
	}
	
	/**
	 * 清理
	 */
	public function clear():void
	{
		var length:int = this.flameList.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			var flame:Flame = this.flameList[i];
			flame.removeSelf();
			flame.destroy();
			this.flameList.splice(i, 1);
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		if (this.tex)
		{
			this.tex.destroy();
			this.tex = null;
		}
		this.clear();
		this.flameList = null;
	}
}
}
import laya.ui.Image;
import utils.MathUtil;
class Flame extends Image
{
	//速度向量
	private var vx:Number;
	private var vy:Number;
	//发射位置x坐标
	private var startX:Number;
	//发射位置y坐标
	private var startY:Number;
	//最大缩放比
	private var maxScale:Number;
	//最小alpha值
	private var minAlpha:Number;
	//最大射程距离
	private var distance:Number;
	//缩放速度
	private var scaleSpeed:Number;
	//透明度速度
	private var alphaSpeed:Number;

	public function Flame(skin:String = null)
	{
		super(skin);
	}
	
	/**
	 * 初始化
	 * @param	vx			x速度
	 * @param	vy			y速度
	 * @param	startX		起始位置x
	 * @param	startY		起始位置y
	 * @param	maxScale	最大缩放
	 * @param	minAlpha	最小透明
	 * @param	distance	最大距离
	 * @param	scaleSpeed	缩放速度
	 * @param	alphaSpeed	透明速度
	 */
	public function init(vx:Number, vy:Number, 
						 startX:Number, startY:Number, 
						 maxScale:Number, minAlpha:Number, distance:Number, 
						 scaleSpeed:Number, alphaSpeed:Number):void
	{
		this.startX = startX;
		this.startY = startY;
		this.vx = vx;
		this.vy = vy;
		this.x = startX;
		this.y = startY;
		this.scaleX = .2;
		this.scaleY = this.scaleY;
		this.maxScale = maxScale;
		this.minAlpha = minAlpha;
		this.distance = distance;
		this.scaleSpeed = scaleSpeed;
		this.alphaSpeed = alphaSpeed;
	}
	
	/**
	 * 更新速度
	 */
	public function update():void
	{
		this.x += this.vx;
		this.y += this.vy;
		this.scaleX += this.scaleSpeed;
		this.scaleY = this.scaleX;
		if (this.scaleX > this.maxScale) this.scaleX = this.maxScale;
		if (MathUtil.distance(this.x, this.y, this.startX, this.startY) >= this.distance * .5)
		this.alpha -= this.alphaSpeed;
		if (this.alpha < this.minAlpha) this.alpha = this.minAlpha;
	}
	
	/**
	 * 是否超过射程
	 * @return
	 */
	public function isOutRange():Boolean
	{
		return MathUtil.distance(this.x, this.y, this.startX, this.startY) >= this.distance;
	}
}