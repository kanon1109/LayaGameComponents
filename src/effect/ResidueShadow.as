package effect 
{
import laya.display.Sprite;
import laya.maths.Point;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ...残影效果
 * @author Kanon
 */
public class ResidueShadow
{
    //需要显示残影的列表
	private var sptAry:Array = [];
	//残影数组
	private var shadowPool:Array = [];
    //持续时间（毫秒）
	private var duration:int;
	//父容器
	private var parent:Sprite;
	public function ResidueShadow() 
	{
		
	}
	
	/**
	 * 初始化
	 * @param	parent		父容器
	 * @param	duration	持续时间
	 */
	public function init(parent:Sprite, duration:int):void
	{
		this.parent = parent;
		this.duration = duration;
	}
	
	/**
	 * 加入残影
	 * @param	spt		需要加入残影的显示对象
	 */
	public function push(spt:Sprite):void
	{
		if (this.indexOf(spt) >= 0) return;
		this.sptAry.push( { spt:spt, pos:new Point(spt.x, spt.y) } );
	}
	
	/**
	 * 当前索引
	 * @param	spt		加入残影的显示对象
	 * @return	索引
	 */
	private function indexOf(spt:Sprite):int
	{
		var length:int = this.sptAry.length;
		for (var i:int = 0; i < length; i++) 
		{
			var obj:Object = this.sptAry[i];
			if (obj.spt == spt) return i;
		}
		return -1;
	}
	
	/**
	 * 删除
	 * @param	spt		需要删除残影的显示对象
	 */
	public function remove(spt:Sprite):void
	{
		var index:int = this.indexOf(spt);
		if (index >= 0) this.sptAry.splice(index, 1);
	}
	
	/**
	 * 更新
	 */
	public function render():void
	{
		if (!this.sptAry) return;
		for (var i:int = 0; i < this.sptAry.length; i++) 
		{
			var obj:Object = this.sptAry[i];
			var spt:Sprite = obj.spt;
			var pos:Point = obj.pos;
			if (pos.distance(spt.x, spt.y) > 0)
			{
				pos.x = spt.x;
				pos.y = spt.y;
				//copy image
				var shadow:Sprite = new Sprite();
				shadow.x = spt.x;
				shadow.y = spt.y;
				shadow.alpha = spt.alpha;
				shadow.scale(spt.scaleX, spt.scaleY);
				shadow.width = spt.width;
				shadow.height = spt.height;
				shadow.skew(spt.skewX, spt.skewY);
				shadow.pivot(spt.pivotX, spt.pivotY);
				shadow.rotation = spt.rotation;
				//所有显示对象都通过graphics来实现的
				shadow.graphics = spt.graphics;
				this.parent.addChild(shadow);
				this.shadowPool.push(shadow);
				Tween.to(shadow, { alpha:0 }, this.duration, null, Handler.create(this, function():void {
					if (this.shadowPool) 
					{
						var length:int = this.shadowPool.length - 1;
						for (var i:int = length; i >= 0; i--) 
						{
							var s:Sprite = this.shadowPool[i];
							if (s == shadow)
							{
								this.shadowPool.splice(i, 1);
								break;
							}
						}
					}
					shadow.removeSelf();
				}))
			}
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		var length:int = this.sptAry.length - 1;
		for (var i:int = length; i >= 0; i--) 
		{
			this.sptAry.splice(i, 1);
		}
		length = this.shadowPool.length - 1;
		for (i = length; i >= 0; i--) 
		{
			var shadow:Sprite = this.shadowPool[i];
			Tween.clearAll(shadow);
			shadow.removeSelf();
			shadow.destroy();
			this.shadowPool.splice(i, 1);
		}
		this.sptAry = null;
		this.shadowPool = null;
	}
}
}