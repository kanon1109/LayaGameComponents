package effect 
{
import laya.display.Sprite;
import laya.ui.Image;
/**
 * ...血渍
 * @author Kanon
 */
public class BloodSplatter 
{
	//飞溅数量
    private var num:int;
    //飞溅距离
    private var dis:Number;
    //飞溅强度
    private var intensity:Number;
    //飞溅大小
    private var size:Number;
    //容器
    private var parent:Sprite;
	//图片链接
	private var url:String;
	//存放图片的数组
	private var bloodList:Array;
	public function BloodSplatter(url:String, 
								  parent:Sprite, 
								  num:int = 12,
								  dis:Number = 65,
								  intensity:Number = .8,
								  size:Number = 1.6) 
	{
		this.url = url;
		this.parent = parent;
		this.num = num;
		this.dis = dis;
		this.intensity = intensity;
		this.size = size;
		this.bloodList = [];
	}
	
	/**
	 * 显示
	 * @param	x	显示位置x
	 * @param	y	显示位置y
	 */
	public function show(x:Number, y:Number):void
	{
		for (var i:int = 0; i < this.num; i += 1)
        {
            //创建血迹
            var blood:Image = new Image(this.url);
			blood.cacheAsBitmap = true;
            //设置位置
            blood.x = x + Math.random() * (this.dis + 1) - (this.dis / 2);
            blood.y = y + Math.random() * (this.dis + 1) - (this.dis / 2);
            //设置缩放
            blood.scaleX = Math.random() * this.size + this.size / 4;
            blood.scaleY = Math.random() * this.size + this.size / 4;
            //角度
            blood.rotation = Math.random() * 360;
            //透明度
            blood.alpha = Math.random() * this.intensity + this.intensity / 4;
            this.parent.addChild(blood);
            this.bloodList.push(blood);
        }
	}
	
	/**
	 * 清理
	 */
	public function clear():void
	{
		var length:int = this.bloodList.length;
		for (var i:int = length - 1; i >= 0; i--) 
		{
			var img:Image = this.bloodList[i];
			img.removeSelf();
			img.destroy();
			this.bloodList.splice(i, 1);
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.clear();
		this.bloodList = null;
	}
}
}