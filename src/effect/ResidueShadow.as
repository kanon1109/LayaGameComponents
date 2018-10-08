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
	//位置字典
	private var posDict:Object = { };
	//残影数组
	private var shadowAry:Array = [];
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
		this.sptAry.push(spt);
		this.posDict[spt] = new Point(spt.x, spt.y);
	}
	
	/**
	 * 更新
	 */
	public function render():void
	{
		if (!this.sptAry) return;
		for (var i:int = 0; i < this.sptAry.length; i++) 
		{
			var spt:Sprite = this.sptAry[i];
			var pos:Point = this.posDict[spt];
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
				shadow.graphics.drawTexture(spt.source);
				this.parent.addChild(shadow);
				this.shadowAry.push(shadow);
				Tween.to(shadow, { alpha:0 }, this.duration, null, Handler.create(this, function() {
					if (this.shadowAry) 
					{
						var length:int = this.shadowAry.length - 1;
						for (var i:int = length; i >= 0; i--) 
						{
							var s:Sprite = this.shadowAry[i];
							if (s == shadow)
							{
								this.shadowAry.splice(i, 1);
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
		length = this.shadowAry.length - 1;
		for (i = length; i >= 0; i--) 
		{
			var shadow:Sprite = this.shadowAry[i];
			Tween.clearAll(shadow);
			shadow.removeSelf();
			shadow.destroy();
			this.shadowAry.splice(i, 1);
		}
		this.sptAry = null;
		this.shadowAry = null;
		this.posDict = null;
	}
}
}